package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.LearnCase;
import com.trader.entity.LearnChapter;
import com.trader.mapper.LearnCaseMapper;
import com.trader.mapper.LearnChapterMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 实战案例服务类
 */
@Service
@RequiredArgsConstructor
public class LearnCaseService {
    
    private final LearnCaseMapper caseMapper;
    private final LearnChapterMapper chapterMapper;
    
    /**
     * 根据章节ID获取案例列表
     */
    public List<LearnCase> listByChapter(Long chapterId) {
        return caseMapper.selectList(new LambdaQueryWrapper<LearnCase>()
                .eq(LearnCase::getChapterId, chapterId)
                .eq(LearnCase::getStatus, 1)
                .orderByAsc(LearnCase::getSortOrder));
    }
    
    /**
     * 分页查询案例列表
     */
    public PageResult<LearnCase> listCases(int pageNum, int pageSize, 
            String caseType, String symbol, Long chapterId) {
        Page<LearnCase> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnCase> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnCase::getStatus, 1);
        
        if (StringUtils.hasText(caseType)) {
            wrapper.eq(LearnCase::getCaseType, caseType);
        }
        if (StringUtils.hasText(symbol)) {
            wrapper.eq(LearnCase::getSymbol, symbol);
        }
        if (chapterId != null) {
            wrapper.eq(LearnCase::getChapterId, chapterId);
        }
        
        wrapper.orderByDesc(LearnCase::getEntryDate)
               .orderByAsc(LearnCase::getSortOrder);
        
        Page<LearnCase> result = caseMapper.selectPage(page, wrapper);
        
        // 填充章节信息
        for (LearnCase c : result.getRecords()) {
            LearnChapter chapter = chapterMapper.selectById(c.getChapterId());
            c.setChapter(chapter);
        }
        
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取案例详情
     */
    public LearnCase getCase(Long id) {
        LearnCase learnCase = caseMapper.selectById(id);
        if (learnCase != null) {
            LearnChapter chapter = chapterMapper.selectById(learnCase.getChapterId());
            learnCase.setChapter(chapter);
        }
        return learnCase;
    }
    
    /**
     * 搜索案例
     */
    public PageResult<LearnCase> searchCases(int pageNum, int pageSize, String keyword) {
        Page<LearnCase> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnCase> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnCase::getStatus, 1);
        
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(LearnCase::getTitle, keyword)
                    .or().like(LearnCase::getBackground, keyword)
                    .or().like(LearnCase::getLessons, keyword)
                    .or().like(LearnCase::getSymbol, keyword));
        }
        
        wrapper.orderByDesc(LearnCase::getEntryDate);
        
        Page<LearnCase> result = caseMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取所有交易品种（用于筛选）
     */
    public List<String> listSymbols() {
        return caseMapper.selectObjs(new LambdaQueryWrapper<LearnCase>()
                .select(LearnCase::getSymbol)
                .eq(LearnCase::getStatus, 1)
                .groupBy(LearnCase::getSymbol)
                .orderByAsc(LearnCase::getSymbol))
                .stream()
                .map(Object::toString)
                .distinct()
                .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * 统计案例数量
     */
    public long countByType(String caseType) {
        return caseMapper.selectCount(new LambdaQueryWrapper<LearnCase>()
                .eq(LearnCase::getStatus, 1)
                .eq(StringUtils.hasText(caseType), LearnCase::getCaseType, caseType));
    }
    
    // ============ 管理员方法 ============
    
    /**
     * 创建案例
     */
    public void createCase(LearnCase learnCase) {
        learnCase.setCreateBy(SecurityUtils.getUserId());
        learnCase.setStatus(1);
        caseMapper.insert(learnCase);
    }
    
    /**
     * 更新案例
     */
    public void updateCase(LearnCase learnCase) {
        caseMapper.updateById(learnCase);
    }
    
    /**
     * 删除案例
     */
    public void deleteCase(Long id) {
        caseMapper.deleteById(id);
    }
    
    /**
     * 管理员分页查询（包含禁用的）
     */
    public PageResult<LearnCase> listAllCases(int pageNum, int pageSize, 
            String caseType, String symbol, Long chapterId, Integer status) {
        Page<LearnCase> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnCase> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(LearnCase::getStatus, status);
        }
        if (StringUtils.hasText(caseType)) {
            wrapper.eq(LearnCase::getCaseType, caseType);
        }
        if (StringUtils.hasText(symbol)) {
            wrapper.eq(LearnCase::getSymbol, symbol);
        }
        if (chapterId != null) {
            wrapper.eq(LearnCase::getChapterId, chapterId);
        }
        
        wrapper.orderByDesc(LearnCase::getCreateTime);
        
        Page<LearnCase> result = caseMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
}
