package com.trader.controller;

import com.trader.annotation.OperationLog;
import com.trader.annotation.OperationLog.OperationType;
import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.TradeRecord;
import com.trader.service.TradeRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/trade/record")
@RequiredArgsConstructor
public class TradeRecordController {
    private final TradeRecordService tradeRecordService;

    @GetMapping("/list")
    public Result<PageResult<TradeRecord>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(required = false) String symbol,
            @RequestParam(required = false) String direction,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        return Result.success(tradeRecordService.list(pageNum, pageSize, symbol, direction, startTime, endTime));
    }

    @GetMapping("/{id}")
    public Result<TradeRecord> getById(@PathVariable Long id) {
        return Result.success(tradeRecordService.getById(id));
    }

    @DeleteMapping("/{id}")
    @OperationLog(module = "成交记录", type = OperationType.DELETE, description = "删除成交记录")
    public Result<Void> delete(@PathVariable Long id) {
        tradeRecordService.delete(id);
        return Result.success();
    }

    @PostMapping("/import")
    @OperationLog(module = "成交记录", type = OperationType.IMPORT, description = "导入成交记录")
    public Result<Map<String, Object>> importExcel(@RequestParam("file") MultipartFile file) {
        try {
            Map<String, Object> result = tradeRecordService.importFromExcel(file);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("导入失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        return Result.success(tradeRecordService.getStatistics(startTime, endTime));
    }
}
