package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.LearnResource;
import com.trader.security.RequireRole;
import com.trader.service.LearnResourceService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 外部资源控制器
 */
@RestController
@RequestMapping("/learn/resource")
@RequiredArgsConstructor
public class LearnResourceController {
    
    private final LearnResourceService resourceService;
    
    /**
     * 根据章节获取资源列表
     */
    @GetMapping("/chapter/{chapterId}")
    public Result<List<LearnResource>> listByChapter(@PathVariable Long chapterId) {
        return Result.success(resourceService.listByChapter(chapterId));
    }
    
    /**
     * 分页查询资源列表
     */
    @GetMapping("/list")
    public Result<PageResult<LearnResource>> listResources(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String resourceType,
            @RequestParam(required = false) String platform,
            @RequestParam(required = false) String language,
            @RequestParam(required = false) Long chapterId) {
        return Result.success(resourceService.listResources(pageNum, pageSize, 
                resourceType, platform, language, chapterId));
    }
    
    /**
     * 获取资源详情
     */
    @GetMapping("/{id}")
    public Result<LearnResource> getResource(@PathVariable Long id) {
        return Result.success(resourceService.getResource(id));
    }
    
    /**
     * 搜索资源
     */
    @GetMapping("/search")
    public Result<PageResult<LearnResource>> searchResources(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(resourceService.searchResources(pageNum, pageSize, keyword));
    }
    
    /**
     * 获取所有平台（用于筛选下拉框）
     */
    @GetMapping("/platforms")
    public Result<List<String>> listPlatforms() {
        return Result.success(resourceService.listPlatforms());
    }
    
    /**
     * 获取资源统计信息
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", resourceService.countByType(null));
        stats.put("video", resourceService.countByType("video"));
        stats.put("article", resourceService.countByType("article"));
        stats.put("tool", resourceService.countByType("tool"));
        stats.put("chart", resourceService.countByType("chart"));
        stats.put("book", resourceService.countByType("book"));
        stats.put("report", resourceService.countByType("report"));
        return Result.success(stats);
    }
    
    // ============ 管理员和讲师接口 ============
    
    /**
     * 管理员查询资源列表
     */
    @GetMapping("/admin/list")
    @RequireRole({"admin", "teacher"})
    public Result<PageResult<LearnResource>> listAllResources(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String resourceType,
            @RequestParam(required = false) String platform,
            @RequestParam(required = false) Long chapterId,
            @RequestParam(required = false) Integer status) {
        return Result.success(resourceService.listAllResources(pageNum, pageSize, 
                resourceType, platform, chapterId, status));
    }
    
    /**
     * 创建资源
     */
    @PostMapping
    @RequireRole({"admin", "teacher"})
    public Result<Void> createResource(@RequestBody LearnResource resource) {
        resourceService.createResource(resource);
        return Result.success();
    }
    
    /**
     * 更新资源
     */
    @PutMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> updateResource(@PathVariable Long id, @RequestBody LearnResource resource) {
        resource.setId(id);
        resourceService.updateResource(resource);
        return Result.success();
    }
    
    /**
     * 删除资源
     */
    @DeleteMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> deleteResource(@PathVariable Long id) {
        resourceService.deleteResource(id);
        return Result.success();
    }
}
