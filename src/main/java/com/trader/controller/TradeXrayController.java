package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.TradeXrayReport;
import com.trader.service.AiQuotaService;
import com.trader.service.TradeXrayService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/trade/xray")
@RequiredArgsConstructor
public class TradeXrayController {
    
    private final TradeXrayService xrayService;
    private final AiQuotaService quotaService;

    /**
     * 预览待分析数据
     */
    @GetMapping("/preview")
    public Result<Map<String, Object>> preview(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(xrayService.preview(startDate, endDate));
    }

    /**
     * 执行AI分析
     */
    @PostMapping("/analyze")
    public Result<TradeXrayReport> analyze(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(xrayService.analyze(startDate, endDate));
    }

    /**
     * 获取历史报告列表
     */
    @GetMapping("/reports")
    public Result<PageResult<TradeXrayReport>> listReports(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(xrayService.listReports(pageNum, pageSize));
    }

    /**
     * 获取报告详情
     */
    @GetMapping("/report/{id}")
    public Result<TradeXrayReport> getReport(@PathVariable Long id) {
        return Result.success(xrayService.getReport(id));
    }

    /**
     * 获取今日配额信息
     */
    @GetMapping("/quota")
    public Result<Map<String, Object>> getQuota() {
        return Result.success(quotaService.getQuotaInfo());
    }
}
