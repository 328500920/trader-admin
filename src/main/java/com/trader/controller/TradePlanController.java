package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.TradePlan;
import com.trader.service.TradePlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/trade/plan")
@RequiredArgsConstructor
public class TradePlanController {
    
    private final TradePlanService tradePlanService;
    
    /**
     * 获取计划列表
     */
    @GetMapping
    public Result<PageResult<TradePlan>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String symbol) {
        return Result.success(tradePlanService.list(pageNum, pageSize, status, symbol));
    }
    
    /**
     * 获取计划详情
     */
    @GetMapping("/{id}")
    public Result<TradePlan> getById(@PathVariable Long id) {
        return Result.success(tradePlanService.getById(id));
    }
    
    /**
     * 创建计划
     */
    @PostMapping
    public Result<Void> create(@RequestBody TradePlan plan) {
        tradePlanService.create(plan);
        return Result.success();
    }
    
    /**
     * 更新计划
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody TradePlan plan) {
        plan.setId(id);
        tradePlanService.update(plan);
        return Result.success();
    }
    
    /**
     * 删除计划
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        tradePlanService.delete(id);
        return Result.success();
    }
    
    /**
     * 执行计划
     */
    @PutMapping("/{id}/execute")
    public Result<Void> execute(
            @PathVariable Long id,
            @RequestParam(required = false) Long tradeLogId) {
        tradePlanService.execute(id, tradeLogId);
        return Result.success();
    }
    
    /**
     * 取消计划
     */
    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(@PathVariable Long id) {
        tradePlanService.cancel(id);
        return Result.success();
    }
    
    /**
     * 获取统计数据
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        return Result.success(tradePlanService.getStats());
    }
}
