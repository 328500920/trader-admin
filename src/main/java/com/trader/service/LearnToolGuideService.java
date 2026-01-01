package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.LearnToolGuide;
import com.trader.mapper.LearnToolGuideMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 工具指南服务类
 */
@Service
@RequiredArgsConstructor
public class LearnToolGuideService {
    
    private final LearnToolGuideMapper toolGuideMapper;
    
    /**
     * 获取所有工具指南列表
     */
    public List<LearnToolGuide> listTools(String toolType) {
        LambdaQueryWrapper<LearnToolGuide> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnToolGuide::getStatus, 1);
        
        if (StringUtils.hasText(toolType)) {
            wrapper.eq(LearnToolGuide::getToolType, toolType);
        }
        
        wrapper.orderByAsc(LearnToolGuide::getSortOrder);
        return toolGuideMapper.selectList(wrapper);
    }
    
    /**
     * 分页查询工具指南
     */
    public PageResult<LearnToolGuide> listToolsPaged(int pageNum, int pageSize, 
            String toolType, Integer difficulty) {
        Page<LearnToolGuide> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnToolGuide> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnToolGuide::getStatus, 1);
        
        if (StringUtils.hasText(toolType)) {
            wrapper.eq(LearnToolGuide::getToolType, toolType);
        }
        if (difficulty != null) {
            wrapper.eq(LearnToolGuide::getDifficulty, difficulty);
        }
        
        wrapper.orderByAsc(LearnToolGuide::getSortOrder);
        
        Page<LearnToolGuide> result = toolGuideMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取工具指南详情
     */
    public LearnToolGuide getTool(Long id) {
        return toolGuideMapper.selectById(id);
    }
    
    /**
     * 搜索工具指南
     */
    public PageResult<LearnToolGuide> searchTools(int pageNum, int pageSize, String keyword) {
        Page<LearnToolGuide> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnToolGuide> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnToolGuide::getStatus, 1);
        
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(LearnToolGuide::getToolName, keyword)
                    .or().like(LearnToolGuide::getDescription, keyword));
        }
        
        wrapper.orderByAsc(LearnToolGuide::getSortOrder);
        
        Page<LearnToolGuide> result = toolGuideMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 统计工具数量
     */
    public long countByType(String toolType) {
        LambdaQueryWrapper<LearnToolGuide> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnToolGuide::getStatus, 1);
        if (StringUtils.hasText(toolType)) {
            wrapper.eq(LearnToolGuide::getToolType, toolType);
        }
        return toolGuideMapper.selectCount(wrapper);
    }
    
    // ============ 管理员方法 ============
    
    public void createTool(LearnToolGuide tool) {
        tool.setCreateBy(SecurityUtils.getUserId());
        tool.setStatus(1);
        toolGuideMapper.insert(tool);
    }
    
    public void updateTool(LearnToolGuide tool) {
        toolGuideMapper.updateById(tool);
    }
    
    public void deleteTool(Long id) {
        toolGuideMapper.deleteById(id);
    }
    
    public PageResult<LearnToolGuide> listAllTools(int pageNum, int pageSize, 
            String toolType, Integer status) {
        Page<LearnToolGuide> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnToolGuide> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(LearnToolGuide::getStatus, status);
        }
        if (StringUtils.hasText(toolType)) {
            wrapper.eq(LearnToolGuide::getToolType, toolType);
        }
        
        wrapper.orderByDesc(LearnToolGuide::getCreateTime);
        
        Page<LearnToolGuide> result = toolGuideMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
}
