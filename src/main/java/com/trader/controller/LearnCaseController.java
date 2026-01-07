package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.LearnCase;
import com.trader.security.RequireRole;
import com.trader.service.LearnCaseService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 实战案例控制器
 */
@RestController
@RequestMapping("/learn/case")
@RequiredArgsConstructor
public class LearnCaseController {
    
    private final LearnCaseService caseService;
    
    /**
     * 根据章节获取案例列表
     */
    @GetMapping("/chapter/{chapterId}")
    public Result<List<LearnCase>> listByChapter(@PathVariable Long chapterId) {
        return Result.success(caseService.listByChapter(chapterId));
    }
    
    /**
     * 分页查询案例列表
     */
    @GetMapping("/list")
    public Result<PageResult<LearnCase>> listCases(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String caseType,
            @RequestParam(required = false) String symbol,
            @RequestParam(required = false) Long chapterId) {
        return Result.success(caseService.listCases(pageNum, pageSize, caseType, symbol, chapterId));
    }
    
    /**
     * 获取案例详情
     */
    @GetMapping("/{id}")
    public Result<LearnCase> getCase(@PathVariable Long id) {
        return Result.success(caseService.getCase(id));
    }
    
    /**
     * 搜索案例
     */
    @GetMapping("/search")
    public Result<PageResult<LearnCase>> searchCases(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(caseService.searchCases(pageNum, pageSize, keyword));
    }
    
    /**
     * 获取所有交易品种（用于筛选下拉框）
     */
    @GetMapping("/symbols")
    public Result<List<String>> listSymbols() {
        return Result.success(caseService.listSymbols());
    }
    
    /**
     * 获取案例统计信息
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", caseService.countByType(null));
        stats.put("success", caseService.countByType("success"));
        stats.put("failure", caseService.countByType("failure"));
        stats.put("analysis", caseService.countByType("analysis"));
        return Result.success(stats);
    }
    
    // ============ 管理员和讲师接口 ============
    
    /**
     * 管理员查询案例列表
     */
    @GetMapping("/admin/list")
    @RequireRole({"admin", "teacher"})
    public Result<PageResult<LearnCase>> listAllCases(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String caseType,
            @RequestParam(required = false) String symbol,
            @RequestParam(required = false) Long chapterId,
            @RequestParam(required = false) Integer status) {
        return Result.success(caseService.listAllCases(pageNum, pageSize, caseType, symbol, chapterId, status));
    }
    
    /**
     * 创建案例
     */
    @PostMapping
    @RequireRole({"admin", "teacher"})
    public Result<Void> createCase(@RequestBody LearnCase learnCase) {
        caseService.createCase(learnCase);
        return Result.success();
    }
    
    /**
     * 更新案例
     */
    @PutMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> updateCase(@PathVariable Long id, @RequestBody LearnCase learnCase) {
        learnCase.setId(id);
        caseService.updateCase(learnCase);
        return Result.success();
    }
    
    /**
     * 删除案例
     */
    @DeleteMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> deleteCase(@PathVariable Long id) {
        caseService.deleteCase(id);
        return Result.success();
    }
}
