package com.trader.controller;

import com.trader.common.Result;
import com.trader.entity.LearnCheckin;
import com.trader.service.LearnCheckinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 学习打卡控制器
 */
@RestController
@RequestMapping("/learn/checkin")
public class LearnCheckinController {
    
    @Autowired
    private LearnCheckinService checkinService;
    
    /**
     * 获取日历数据
     */
    @GetMapping("/calendar")
    public Result<List<Map<String, Object>>> getCalendarData(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        
        if (year == null) {
            year = LocalDate.now().getYear();
        }
        if (month == null) {
            month = LocalDate.now().getMonthValue();
        }
        
        List<Map<String, Object>> data = checkinService.getCalendarData(userId, year, month);
        return Result.success(data);
    }
    
    /**
     * 获取热力图数据
     */
    @GetMapping("/heatmap")
    public Result<List<Map<String, Object>>> getHeatmapData(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam(defaultValue = "90") Integer days) {
        
        List<Map<String, Object>> data = checkinService.getHeatmapData(userId, days);
        return Result.success(data);
    }
    
    /**
     * 获取连续打卡信息
     */
    @GetMapping("/streak")
    public Result<Map<String, Object>> getStreakInfo(
            @RequestParam(defaultValue = "1") Long userId) {
        
        Map<String, Object> data = checkinService.getStreakInfo(userId);
        return Result.success(data);
    }
    
    /**
     * 今日打卡
     */
    @PostMapping("/today")
    public Result<LearnCheckin> checkinToday(
            @RequestParam(defaultValue = "1") Long userId) {
        
        LearnCheckin checkin = checkinService.checkinToday(userId);
        return Result.success(checkin);
    }
    
    /**
     * 更新今日学习数据
     */
    @PostMapping("/update")
    public Result<Void> updateTodayData(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam(required = false) Integer addMinutes,
            @RequestParam(required = false) Integer addChapters,
            @RequestParam(required = false) Integer addQuizzes,
            @RequestParam(required = false) Integer addCases) {
        
        checkinService.updateTodayData(userId, addMinutes, addChapters, addQuizzes, addCases);
        return Result.success();
    }
}
