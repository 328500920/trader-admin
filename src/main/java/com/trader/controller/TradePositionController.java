package com.trader.controller;

import com.trader.annotation.OperationLog;
import com.trader.annotation.OperationLog.OperationType;
import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.TradePosition;
import com.trader.service.TradePositionService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/trade/position")
@RequiredArgsConstructor
public class TradePositionController {
    private final TradePositionService tradePositionService;

    @GetMapping("/list")
    public Result<PageResult<TradePosition>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(required = false) String symbol,
            @RequestParam(required = false) String positionSide,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        return Result.success(tradePositionService.list(pageNum, pageSize, symbol, positionSide, startTime, endTime));
    }

    @GetMapping("/{id}")
    public Result<TradePosition> getById(@PathVariable Long id) {
        return Result.success(tradePositionService.getById(id));
    }

    @DeleteMapping("/{id}")
    @OperationLog(module = "仓位历史", type = OperationType.DELETE, description = "删除仓位记录")
    public Result<Void> delete(@PathVariable Long id) {
        tradePositionService.delete(id);
        return Result.success();
    }

    @PostMapping("/import")
    @OperationLog(module = "仓位历史", type = OperationType.IMPORT, description = "导入仓位历史")
    public Result<Map<String, Object>> importExcel(@RequestParam("file") MultipartFile file) {
        try {
            Map<String, Object> result = tradePositionService.importFromExcel(file);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("导入失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        return Result.success(tradePositionService.getStatistics(startTime, endTime));
    }

    @PostMapping("/{id}/generate-log")
    @OperationLog(module = "仓位历史", type = OperationType.CREATE, description = "生成交易日志")
    public Result<Long> generateTradeLog(@PathVariable Long id) {
        try {
            Long tradeLogId = tradePositionService.generateTradeLog(id);
            return Result.success(tradeLogId);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}
