package com.trader.controller;

import com.trader.common.Result;
import com.trader.entity.PsychologyDaily;
import com.trader.entity.PsychologyTrade;
import com.trader.service.PsychologyService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/psychology")
@RequiredArgsConstructor
public class PsychologyController {
    
    private final PsychologyService psychologyService;
    
    // ========== 每日打卡 ==========
    
    /**
     * 保存每日打卡
     */
    @PostMapping("/daily")
    public Result<Void> saveDaily(@RequestBody PsychologyDaily daily) {
        psychologyService.saveDaily(daily);
        return Result.success();
    }
    
    /**
     * 获取指定日期的打卡记录
     */
    @GetMapping("/daily/{date}")
    public Result<PsychologyDaily> getDailyByDate(
            @PathVariable @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        return Result.success(psychologyService.getDailyByDate(date));
    }
    
    /**
     * 获取每日记录列表
     */
    @GetMapping("/daily")
    public Result<List<PsychologyDaily>> getDailyList(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(psychologyService.getDailyList(startDate, endDate));
    }
    
    // ========== 交易情绪 ==========
    
    /**
     * 保存交易情绪记录
     */
    @PostMapping("/trade")
    public Result<Void> saveTrade(@RequestBody PsychologyTrade trade) {
        psychologyService.saveTrade(trade);
        return Result.success();
    }
    
    /**
     * 获取交易情绪列表
     */
    @GetMapping("/trade")
    public Result<List<PsychologyTrade>> getTradeList(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(psychologyService.getTradeList(startDate, endDate));
    }
    
    // ========== 日历数据 ==========
    
    /**
     * 获取日历数据
     */
    @GetMapping("/calendar")
    public Result<List<Map<String, Object>>> getCalendarData(
            @RequestParam int year,
            @RequestParam int month) {
        return Result.success(psychologyService.getCalendarData(year, month));
    }
    
    /**
     * 获取月度概览
     */
    @GetMapping("/overview")
    public Result<Map<String, Object>> getMonthOverview(
            @RequestParam int year,
            @RequestParam int month) {
        return Result.success(psychologyService.getMonthOverview(year, month));
    }
    
    // ========== 情绪分析 ==========
    
    /**
     * 获取情绪分析数据
     */
    @GetMapping("/analysis")
    public Result<Map<String, Object>> getAnalysis(
            @RequestParam(defaultValue = "month") String period) {
        return Result.success(psychologyService.getAnalysis(period));
    }
}
