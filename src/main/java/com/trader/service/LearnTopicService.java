package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.LearnTopic;
import com.trader.mapper.LearnTopicMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 专题内容服务类
 */
@Service
@RequiredArgsConstructor
public class LearnTopicService {
    
    private final LearnTopicMapper topicMapper;
    
    /**
     * 获取所有已发布专题列表
     */
    public List<LearnTopic> listTopics(String topicType, Integer difficulty) {
        LambdaQueryWrapper<LearnTopic> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnTopic::getStatus, 1);
        
        if (StringUtils.hasText(topicType)) {
            wrapper.eq(LearnTopic::getTopicType, topicType);
        }
        if (difficulty != null) {
            wrapper.eq(LearnTopic::getDifficulty, difficulty);
        }
        
        wrapper.orderByAsc(LearnTopic::getSortOrder);
        return topicMapper.selectList(wrapper);
    }
    
    /**
     * 分页查询专题列表
     */
    public PageResult<LearnTopic> listTopicsPaged(int pageNum, int pageSize, 
            String topicType, Integer difficulty) {
        Page<LearnTopic> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnTopic> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnTopic::getStatus, 1);
        
        if (StringUtils.hasText(topicType)) {
            wrapper.eq(LearnTopic::getTopicType, topicType);
        }
        if (difficulty != null) {
            wrapper.eq(LearnTopic::getDifficulty, difficulty);
        }
        
        wrapper.orderByAsc(LearnTopic::getSortOrder);
        
        Page<LearnTopic> result = topicMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取专题详情
     */
    public LearnTopic getTopic(Long id) {
        return topicMapper.selectById(id);
    }
    
    /**
     * 搜索专题
     */
    public PageResult<LearnTopic> searchTopics(int pageNum, int pageSize, String keyword) {
        Page<LearnTopic> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnTopic> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnTopic::getStatus, 1);
        
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(LearnTopic::getTitle, keyword)
                    .or().like(LearnTopic::getSubtitle, keyword)
                    .or().like(LearnTopic::getDescription, keyword));
        }
        
        wrapper.orderByAsc(LearnTopic::getSortOrder);
        
        Page<LearnTopic> result = topicMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 根据关联周数获取专题
     */
    public List<LearnTopic> listByWeek(Integer weekNumber) {
        return topicMapper.selectList(new LambdaQueryWrapper<LearnTopic>()
                .eq(LearnTopic::getStatus, 1)
                .eq(LearnTopic::getRelatedWeek, weekNumber)
                .orderByAsc(LearnTopic::getSortOrder));
    }
    
    /**
     * 统计专题数量
     */
    public long countByType(String topicType) {
        LambdaQueryWrapper<LearnTopic> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnTopic::getStatus, 1);
        if (StringUtils.hasText(topicType)) {
            wrapper.eq(LearnTopic::getTopicType, topicType);
        }
        return topicMapper.selectCount(wrapper);
    }
    
    // ============ 管理员方法 ============
    
    /**
     * 创建专题
     */
    public void createTopic(LearnTopic topic) {
        topic.setCreateBy(SecurityUtils.getUserId());
        topicMapper.insert(topic);
    }
    
    /**
     * 更新专题
     */
    public void updateTopic(LearnTopic topic) {
        topicMapper.updateById(topic);
    }
    
    /**
     * 删除专题
     */
    public void deleteTopic(Long id) {
        topicMapper.deleteById(id);
    }
    
    /**
     * 管理员分页查询（包含草稿）
     */
    public PageResult<LearnTopic> listAllTopics(int pageNum, int pageSize, 
            String topicType, Integer status) {
        Page<LearnTopic> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnTopic> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(LearnTopic::getStatus, status);
        }
        if (StringUtils.hasText(topicType)) {
            wrapper.eq(LearnTopic::getTopicType, topicType);
        }
        
        wrapper.orderByDesc(LearnTopic::getCreateTime);
        
        Page<LearnTopic> result = topicMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
}
