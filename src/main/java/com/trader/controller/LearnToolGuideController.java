package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.LearnToolGuide;
import com.trader.security.RequireRole;
import com.trader.service.LearnToolGuideService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工具指南控制器
 */
@RestController
@RequestMapping("/learn/tool-guide")
@RequiredArgsConstructor
public class LearnToolGuideController {
    
    private final LearnToolGuideService toolGuideService;
    
    /**
     * 获取工具列表（不分页）
     */
    @GetMapping("/all")
    public Result<List<LearnToolGuide>> listAllTools(
            @RequestParam(required = false) String toolType) {
        return Result.success(toolGuideService.listTools(toolType));
    }
    
    /**
     * 分页查询工具列表
     */
    @GetMapping("/list")
    public Result<PageResult<LearnToolGuide>> listTools(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String toolType,
            @RequestParam(required = false) Integer difficulty) {
        return Result.success(toolGuideService.listToolsPaged(pageNum, pageSize, toolType, difficulty));
    }
    
    /**
     * 获取工具详情
     */
    @GetMapping("/{id}")
    public Result<LearnToolGuide> getTool(@PathVariable Long id) {
        return Result.success(toolGuideService.getTool(id));
    }
    
    /**
     * 搜索工具
     */
    @GetMapping("/search")
    public Result<PageResult<LearnToolGuide>> searchTools(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(toolGuideService.searchTools(pageNum, pageSize, keyword));
    }
    
    /**
     * 获取工具统计信息
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", toolGuideService.countByType(null));
        stats.put("chart", toolGuideService.countByType("chart"));
        stats.put("exchange", toolGuideService.countByType("exchange"));
        stats.put("data", toolGuideService.countByType("data"));
        stats.put("sentiment", toolGuideService.countByType("sentiment"));
        stats.put("record", toolGuideService.countByType("record"));
        return Result.success(stats);
    }
    
    // ============ 管理员和讲师接口 ============
    
    @GetMapping("/admin/list")
    @RequireRole({"admin", "teacher"})
    public Result<PageResult<LearnToolGuide>> listAllToolsAdmin(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String toolType,
            @RequestParam(required = false) Integer status) {
        return Result.success(toolGuideService.listAllTools(pageNum, pageSize, toolType, status));
    }
    
    @PostMapping
    @RequireRole({"admin", "teacher"})
    public Result<Void> createTool(@RequestBody LearnToolGuide tool) {
        toolGuideService.createTool(tool);
        return Result.success();
    }
    
    @PutMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> updateTool(@PathVariable Long id, @RequestBody LearnToolGuide tool) {
        tool.setId(id);
        toolGuideService.updateTool(tool);
        return Result.success();
    }
    
    @DeleteMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> deleteTool(@PathVariable Long id) {
        toolGuideService.deleteTool(id);
        return Result.success();
    }
}
