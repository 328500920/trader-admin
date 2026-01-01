package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.trader.entity.*;
import com.trader.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 用户收藏服务
 */
@Service
@RequiredArgsConstructor
public class UserFavoriteService extends ServiceImpl<UserFavoriteMapper, UserFavorite> {
    
    private final LearnCaseMapper caseMapper;
    private final LearnResourceMapper resourceMapper;
    private final LearnTopicMapper topicMapper;
    private final LearnToolGuideMapper toolGuideMapper;
    
    /**
     * 添加收藏
     */
    public boolean addFavorite(Long userId, String targetType, Long targetId) {
        // 检查是否已收藏
        if (isFavorited(userId, targetType, targetId)) {
            return false;
        }
        
        UserFavorite favorite = new UserFavorite();
        favorite.setUserId(userId);
        favorite.setTargetType(targetType);
        favorite.setTargetId(targetId);
        return save(favorite);
    }
    
    /**
     * 取消收藏
     */
    public boolean removeFavorite(Long userId, String targetType, Long targetId) {
        LambdaQueryWrapper<UserFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserFavorite::getUserId, userId)
               .eq(UserFavorite::getTargetType, targetType)
               .eq(UserFavorite::getTargetId, targetId);
        return remove(wrapper);
    }
    
    /**
     * 检查是否已收藏
     */
    public boolean isFavorited(Long userId, String targetType, Long targetId) {
        LambdaQueryWrapper<UserFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserFavorite::getUserId, userId)
               .eq(UserFavorite::getTargetType, targetType)
               .eq(UserFavorite::getTargetId, targetId);
        return count(wrapper) > 0;
    }
    
    /**
     * 分页获取收藏列表
     */
    public Page<UserFavorite> getFavoriteList(Long userId, String targetType, 
                                               Integer pageNum, Integer pageSize) {
        Page<UserFavorite> page = new Page<>(pageNum, pageSize);
        
        LambdaQueryWrapper<UserFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserFavorite::getUserId, userId);
        
        if (targetType != null && !targetType.isEmpty()) {
            wrapper.eq(UserFavorite::getTargetType, targetType);
        }
        
        wrapper.orderByDesc(UserFavorite::getCreateTime);
        
        Page<UserFavorite> result = page(page, wrapper);
        
        // 填充收藏目标详情
        fillTargetDetails(result.getRecords());
        
        return result;
    }
    
    /**
     * 获取收藏统计
     */
    public Map<String, Object> getFavoriteStats(Long userId) {
        LambdaQueryWrapper<UserFavorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserFavorite::getUserId, userId);
        
        List<UserFavorite> all = list(wrapper);
        
        Map<String, Long> countByType = all.stream()
                .collect(Collectors.groupingBy(UserFavorite::getTargetType, Collectors.counting()));
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", all.size());
        stats.put("case", countByType.getOrDefault("case", 0L));
        stats.put("resource", countByType.getOrDefault("resource", 0L));
        stats.put("topic", countByType.getOrDefault("topic", 0L));
        stats.put("tool", countByType.getOrDefault("tool", 0L));
        
        return stats;
    }
    
    /**
     * 填充收藏目标详情
     */
    private void fillTargetDetails(List<UserFavorite> favorites) {
        // 按类型分组
        Map<String, List<UserFavorite>> byType = favorites.stream()
                .collect(Collectors.groupingBy(UserFavorite::getTargetType));
        
        // 填充案例详情
        if (byType.containsKey("case")) {
            List<Long> ids = byType.get("case").stream()
                    .map(UserFavorite::getTargetId)
                    .collect(Collectors.toList());
            List<LearnCase> cases = caseMapper.selectBatchIds(ids);
            Map<Long, LearnCase> caseMap = cases.stream()
                    .collect(Collectors.toMap(LearnCase::getId, c -> c));
            byType.get("case").forEach(f -> f.setTargetDetail(caseMap.get(f.getTargetId())));
        }
        
        // 填充资源详情
        if (byType.containsKey("resource")) {
            List<Long> ids = byType.get("resource").stream()
                    .map(UserFavorite::getTargetId)
                    .collect(Collectors.toList());
            List<LearnResource> resources = resourceMapper.selectBatchIds(ids);
            Map<Long, LearnResource> resourceMap = resources.stream()
                    .collect(Collectors.toMap(LearnResource::getId, r -> r));
            byType.get("resource").forEach(f -> f.setTargetDetail(resourceMap.get(f.getTargetId())));
        }
        
        // 填充专题详情
        if (byType.containsKey("topic")) {
            List<Long> ids = byType.get("topic").stream()
                    .map(UserFavorite::getTargetId)
                    .collect(Collectors.toList());
            List<LearnTopic> topics = topicMapper.selectBatchIds(ids);
            Map<Long, LearnTopic> topicMap = topics.stream()
                    .collect(Collectors.toMap(LearnTopic::getId, t -> t));
            byType.get("topic").forEach(f -> f.setTargetDetail(topicMap.get(f.getTargetId())));
        }
        
        // 填充工具详情
        if (byType.containsKey("tool")) {
            List<Long> ids = byType.get("tool").stream()
                    .map(UserFavorite::getTargetId)
                    .collect(Collectors.toList());
            List<LearnToolGuide> tools = toolGuideMapper.selectBatchIds(ids);
            Map<Long, LearnToolGuide> toolMap = tools.stream()
                    .collect(Collectors.toMap(LearnToolGuide::getId, t -> t));
            byType.get("tool").forEach(f -> f.setTargetDetail(toolMap.get(f.getTargetId())));
        }
    }
}
