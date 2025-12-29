package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.*;
import com.trader.mapper.*;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GlossaryService {
    
    private final GlossaryCategoryMapper categoryMapper;
    private final GlossaryTermMapper termMapper;
    private final GlossaryFavoriteMapper favoriteMapper;
    private final GlossaryHistoryMapper historyMapper;
    
    // ========== 分类 ==========
    
    /**
     * 获取分类列表（带术语数量）
     */
    public List<GlossaryCategory> getCategoryList() {
        List<GlossaryCategory> categories = categoryMapper.selectList(
            new LambdaQueryWrapper<GlossaryCategory>()
                .eq(GlossaryCategory::getStatus, 1)
                .orderByAsc(GlossaryCategory::getSortOrder)
        );
        
        // 统计每个分类的术语数量
        List<Map<String, Object>> counts = termMapper.countByCategory();
        Map<Long, Integer> countMap = new HashMap<>();
        for (Map<String, Object> item : counts) {
            Long categoryId = ((Number) item.get("category_id")).longValue();
            Integer count = ((Number) item.get("count")).intValue();
            countMap.put(categoryId, count);
        }
        
        // 构建树形结构
        List<GlossaryCategory> rootCategories = categories.stream()
            .filter(c -> c.getParentId() == 0)
            .collect(Collectors.toList());
        
        for (GlossaryCategory root : rootCategories) {
            List<GlossaryCategory> children = categories.stream()
                .filter(c -> c.getParentId().equals(root.getId()))
                .collect(Collectors.toList());
            root.setChildren(children);
            
            // 计算术语数量（包含子分类）
            int totalCount = countMap.getOrDefault(root.getId(), 0);
            for (GlossaryCategory child : children) {
                child.setTermCount(countMap.getOrDefault(child.getId(), 0));
                totalCount += child.getTermCount();
            }
            root.setTermCount(totalCount);
        }
        
        return rootCategories;
    }
    
    // ========== 术语 ==========
    
    /**
     * 获取术语列表
     */
    public PageResult<GlossaryTerm> getTermList(int pageNum, int pageSize, 
            Long categoryId, Integer difficulty, String keyword) {
        Page<GlossaryTerm> page = new Page<>(pageNum, pageSize);
        
        LambdaQueryWrapper<GlossaryTerm> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(GlossaryTerm::getStatus, 1);
        
        if (categoryId != null) {
            wrapper.eq(GlossaryTerm::getCategoryId, categoryId);
        }
        if (difficulty != null) {
            wrapper.eq(GlossaryTerm::getDifficulty, difficulty);
        }
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w
                .like(GlossaryTerm::getName, keyword)
                .or().like(GlossaryTerm::getNameEn, keyword)
                .or().like(GlossaryTerm::getPinyin, keyword)
                .or().like(GlossaryTerm::getBrief, keyword)
            );
        }
        wrapper.orderByDesc(GlossaryTerm::getViewCount);
        
        Page<GlossaryTerm> result = termMapper.selectPage(page, wrapper);
        
        // 填充分类名称
        fillCategoryName(result.getRecords());
        
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取术语详情
     */
    public GlossaryTerm getTermById(Long id) {
        GlossaryTerm term = termMapper.selectById(id);
        if (term == null) return null;
        
        // 填充分类名称
        GlossaryCategory category = categoryMapper.selectById(term.getCategoryId());
        if (category != null) {
            term.setCategoryName(category.getName());
        }
        
        // 检查是否收藏
        Long userId = SecurityUtils.getUserId();
        if (userId != null) {
            GlossaryFavorite favorite = favoriteMapper.selectOne(
                new LambdaQueryWrapper<GlossaryFavorite>()
                    .eq(GlossaryFavorite::getUserId, userId)
                    .eq(GlossaryFavorite::getTermId, id)
            );
            term.setIsFavorite(favorite != null);
        }
        
        // 增加浏览次数
        term.setViewCount(term.getViewCount() + 1);
        termMapper.updateById(term);
        
        // 记录浏览历史
        recordHistory(id);
        
        return term;
    }
    
    /**
     * 获取热门术语
     */
    public List<GlossaryTerm> getHotTerms(int limit) {
        return termMapper.getHotTerms(limit);
    }
    
    /**
     * 搜索术语
     */
    public List<GlossaryTerm> search(String keyword) {
        if (keyword == null || keyword.isEmpty()) {
            return Collections.emptyList();
        }
        
        LambdaQueryWrapper<GlossaryTerm> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(GlossaryTerm::getStatus, 1)
            .and(w -> w
                .like(GlossaryTerm::getName, keyword)
                .or().like(GlossaryTerm::getNameEn, keyword)
                .or().like(GlossaryTerm::getPinyin, keyword)
                .or().like(GlossaryTerm::getBrief, keyword)
            )
            .orderByDesc(GlossaryTerm::getViewCount)
            .last("LIMIT 20");
        
        List<GlossaryTerm> terms = termMapper.selectList(wrapper);
        fillCategoryName(terms);
        return terms;
    }
    
    // ========== 收藏 ==========
    
    /**
     * 切换收藏状态
     */
    public boolean toggleFavorite(Long termId) {
        Long userId = SecurityUtils.getUserId();
        
        GlossaryFavorite existing = favoriteMapper.selectOne(
            new LambdaQueryWrapper<GlossaryFavorite>()
                .eq(GlossaryFavorite::getUserId, userId)
                .eq(GlossaryFavorite::getTermId, termId)
        );
        
        GlossaryTerm term = termMapper.selectById(termId);
        
        if (existing != null) {
            // 取消收藏
            favoriteMapper.deleteById(existing.getId());
            if (term != null) {
                term.setFavoriteCount(Math.max(0, term.getFavoriteCount() - 1));
                termMapper.updateById(term);
            }
            return false;
        } else {
            // 添加收藏
            GlossaryFavorite favorite = new GlossaryFavorite();
            favorite.setUserId(userId);
            favorite.setTermId(termId);
            favoriteMapper.insert(favorite);
            if (term != null) {
                term.setFavoriteCount(term.getFavoriteCount() + 1);
                termMapper.updateById(term);
            }
            return true;
        }
    }
    
    /**
     * 获取收藏列表
     */
    public List<GlossaryTerm> getFavorites() {
        Long userId = SecurityUtils.getUserId();
        
        List<GlossaryFavorite> favorites = favoriteMapper.selectList(
            new LambdaQueryWrapper<GlossaryFavorite>()
                .eq(GlossaryFavorite::getUserId, userId)
                .orderByDesc(GlossaryFavorite::getCreateTime)
        );
        
        if (favorites.isEmpty()) {
            return Collections.emptyList();
        }
        
        List<Long> termIds = favorites.stream()
            .map(GlossaryFavorite::getTermId)
            .collect(Collectors.toList());
        
        List<GlossaryTerm> terms = termMapper.selectBatchIds(termIds);
        fillCategoryName(terms);
        terms.forEach(t -> t.setIsFavorite(true));
        
        return terms;
    }
    
    // ========== 历史 ==========
    
    /**
     * 记录浏览历史
     */
    private void recordHistory(Long termId) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) return;
        
        // 删除旧的相同记录
        historyMapper.delete(
            new LambdaQueryWrapper<GlossaryHistory>()
                .eq(GlossaryHistory::getUserId, userId)
                .eq(GlossaryHistory::getTermId, termId)
        );
        
        // 插入新记录
        GlossaryHistory history = new GlossaryHistory();
        history.setUserId(userId);
        history.setTermId(termId);
        history.setViewTime(LocalDateTime.now());
        historyMapper.insert(history);
    }
    
    /**
     * 获取浏览历史
     */
    public List<GlossaryTerm> getHistory(int limit) {
        Long userId = SecurityUtils.getUserId();
        
        List<GlossaryHistory> histories = historyMapper.selectList(
            new LambdaQueryWrapper<GlossaryHistory>()
                .eq(GlossaryHistory::getUserId, userId)
                .orderByDesc(GlossaryHistory::getViewTime)
                .last("LIMIT " + limit)
        );
        
        if (histories.isEmpty()) {
            return Collections.emptyList();
        }
        
        List<Long> termIds = histories.stream()
            .map(GlossaryHistory::getTermId)
            .collect(Collectors.toList());
        
        List<GlossaryTerm> terms = termMapper.selectBatchIds(termIds);
        fillCategoryName(terms);
        
        // 按历史顺序排序
        Map<Long, GlossaryTerm> termMap = terms.stream()
            .collect(Collectors.toMap(GlossaryTerm::getId, t -> t));
        
        return termIds.stream()
            .map(termMap::get)
            .filter(Objects::nonNull)
            .collect(Collectors.toList());
    }
    
    // ========== 辅助方法 ==========
    
    private void fillCategoryName(List<GlossaryTerm> terms) {
        if (terms.isEmpty()) return;
        
        Set<Long> categoryIds = terms.stream()
            .map(GlossaryTerm::getCategoryId)
            .collect(Collectors.toSet());
        
        List<GlossaryCategory> categories = categoryMapper.selectBatchIds(categoryIds);
        Map<Long, String> categoryMap = categories.stream()
            .collect(Collectors.toMap(GlossaryCategory::getId, GlossaryCategory::getName));
        
        terms.forEach(t -> t.setCategoryName(categoryMap.get(t.getCategoryId())));
    }
}
