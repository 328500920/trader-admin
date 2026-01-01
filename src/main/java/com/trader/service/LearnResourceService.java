package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.LearnResource;
import com.trader.entity.LearnChapter;
import com.trader.mapper.LearnResourceMapper;
import com.trader.mapper.LearnChapterMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 外部资源服务类
 */
@Service
@RequiredArgsConstructor
public class LearnResourceService {
    
    private final LearnResourceMapper resourceMapper;
    private final LearnChapterMapper chapterMapper;
    
    /**
     * 根据章节ID获取资源列表
     */
    public List<LearnResource> listByChapter(Long chapterId) {
        return resourceMapper.selectList(new LambdaQueryWrapper<LearnResource>()
                .eq(LearnResource::getChapterId, chapterId)
                .eq(LearnResource::getStatus, 1)
                .orderByAsc(LearnResource::getSortOrder));
    }
    
    /**
     * 分页查询资源列表
     */
    public PageResult<LearnResource> listResources(int pageNum, int pageSize, 
            String resourceType, String platform, String language, Long chapterId) {
        Page<LearnResource> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnResource> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnResource::getStatus, 1);
        
        if (StringUtils.hasText(resourceType)) {
            wrapper.eq(LearnResource::getResourceType, resourceType);
        }
        if (StringUtils.hasText(platform)) {
            wrapper.eq(LearnResource::getPlatform, platform);
        }
        if (StringUtils.hasText(language)) {
            wrapper.eq(LearnResource::getLanguage, language);
        }
        if (chapterId != null) {
            wrapper.eq(LearnResource::getChapterId, chapterId);
        }
        
        wrapper.orderByAsc(LearnResource::getSortOrder);
        
        Page<LearnResource> result = resourceMapper.selectPage(page, wrapper);
        
        // 填充章节信息
        for (LearnResource r : result.getRecords()) {
            LearnChapter chapter = chapterMapper.selectById(r.getChapterId());
            r.setChapter(chapter);
        }
        
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取资源详情
     */
    public LearnResource getResource(Long id) {
        LearnResource resource = resourceMapper.selectById(id);
        if (resource != null) {
            LearnChapter chapter = chapterMapper.selectById(resource.getChapterId());
            resource.setChapter(chapter);
        }
        return resource;
    }
    
    /**
     * 搜索资源
     */
    public PageResult<LearnResource> searchResources(int pageNum, int pageSize, String keyword) {
        Page<LearnResource> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnResource> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnResource::getStatus, 1);
        
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(LearnResource::getTitle, keyword)
                    .or().like(LearnResource::getDescription, keyword)
                    .or().like(LearnResource::getAuthor, keyword));
        }
        
        wrapper.orderByAsc(LearnResource::getSortOrder);
        
        Page<LearnResource> result = resourceMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取所有平台（用于筛选）
     */
    public List<String> listPlatforms() {
        return resourceMapper.selectObjs(new LambdaQueryWrapper<LearnResource>()
                .select(LearnResource::getPlatform)
                .eq(LearnResource::getStatus, 1)
                .isNotNull(LearnResource::getPlatform)
                .groupBy(LearnResource::getPlatform)
                .orderByAsc(LearnResource::getPlatform))
                .stream()
                .filter(obj -> obj != null)
                .map(Object::toString)
                .distinct()
                .collect(Collectors.toList());
    }
    
    /**
     * 统计资源数量
     */
    public long countByType(String resourceType) {
        LambdaQueryWrapper<LearnResource> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnResource::getStatus, 1);
        if (StringUtils.hasText(resourceType)) {
            wrapper.eq(LearnResource::getResourceType, resourceType);
        }
        return resourceMapper.selectCount(wrapper);
    }
    
    // ============ 管理员方法 ============
    
    /**
     * 创建资源
     */
    public void createResource(LearnResource resource) {
        resource.setCreateBy(SecurityUtils.getUserId());
        resource.setStatus(1);
        resourceMapper.insert(resource);
    }
    
    /**
     * 更新资源
     */
    public void updateResource(LearnResource resource) {
        resourceMapper.updateById(resource);
    }
    
    /**
     * 删除资源
     */
    public void deleteResource(Long id) {
        resourceMapper.deleteById(id);
    }
    
    /**
     * 管理员分页查询（包含禁用的）
     */
    public PageResult<LearnResource> listAllResources(int pageNum, int pageSize, 
            String resourceType, String platform, Long chapterId, Integer status) {
        Page<LearnResource> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnResource> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(LearnResource::getStatus, status);
        }
        if (StringUtils.hasText(resourceType)) {
            wrapper.eq(LearnResource::getResourceType, resourceType);
        }
        if (StringUtils.hasText(platform)) {
            wrapper.eq(LearnResource::getPlatform, platform);
        }
        if (chapterId != null) {
            wrapper.eq(LearnResource::getChapterId, chapterId);
        }
        
        wrapper.orderByDesc(LearnResource::getCreateTime);
        
        Page<LearnResource> result = resourceMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
}
