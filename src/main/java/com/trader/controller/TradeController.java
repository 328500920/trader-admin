package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.TradeImage;
import com.trader.entity.TradeLog;
import com.trader.service.TradeService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/trade")
@RequiredArgsConstructor
public class TradeController {
    private final TradeService tradeService;

    @GetMapping("/list")
    public Result<PageResult<TradeLog>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String symbol,
            @RequestParam(required = false) String strategy,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return Result.success(tradeService.list(pageNum, pageSize, symbol, strategy, status, startDate, endDate));
    }

    @GetMapping("/summary")
    public Result<Map<String, Object>> getSummary(@RequestParam(defaultValue = "all") String period) {
        return Result.success(tradeService.getSummary(period));
    }

    @GetMapping("/summary/chart")
    public Result<List<Map<String, Object>>> getChartData(@RequestParam(defaultValue = "all") String period) {
        return Result.success(tradeService.getChartData(period));
    }

    @GetMapping("/summary/strategy")
    public Result<List<Map<String, Object>>> getStrategyStats() {
        return Result.success(tradeService.getStrategyStats());
    }

    @GetMapping("/summary/symbol")
    public Result<List<Map<String, Object>>> getSymbolStats() {
        return Result.success(tradeService.getSymbolStats());
    }

    @DeleteMapping("/image/{imageId}")
    public Result<Void> deleteImage(@PathVariable Long imageId) {
        tradeService.deleteImage(imageId);
        return Result.success();
    }

    @PostMapping
    public Result<Void> create(@RequestBody TradeLog trade) {
        tradeService.create(trade);
        return Result.success();
    }

    // 路径参数的路由放在最后，避免与其他路由冲突
    @GetMapping("/{id}")
    public Result<TradeLog> getById(@PathVariable Long id) {
        return Result.success(tradeService.getById(id));
    }

    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody TradeLog trade) {
        trade.setId(id);
        tradeService.update(trade);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        tradeService.delete(id);
        return Result.success();
    }

    @PutMapping("/{id}/close")
    public Result<Void> closeTrade(@PathVariable Long id, @RequestBody TradeLog closeInfo) {
        tradeService.closeTrade(id, closeInfo);
        return Result.success();
    }

    @PostMapping("/{id}/image")
    public Result<Void> addImage(@PathVariable Long id, @RequestBody TradeImage image) {
        tradeService.addImage(id, image);
        return Result.success();
    }
}
