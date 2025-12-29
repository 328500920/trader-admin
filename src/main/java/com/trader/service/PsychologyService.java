package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.trader.entity.PsychologyDaily;
import com.trader.entity.PsychologyTrade;
import com.trader.mapper.PsychologyDailyMapper;
import com.trader.mapper.PsychologyTradeMapper;
import com.trader.utils.SecurityUtils;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PsychologyService {
    
    private final PsychologyDailyMapper dailyMapper;
    private final PsychologyTradeMapper tradeMapper;
    private final ObjectMapper objectMapper;
    
    // ========== 每日打卡 ==========
    
    /**
     * 保存每日打卡（创建或更新）
     */
    public void saveDaily(PsychologyDaily daily) {
        Long userId = SecurityUtils.getUserId();
        daily.setUserId(userId);
        
        // 检查当天是否已有记录
        PsychologyDaily existing = dailyMapper.selectOne(
            new LambdaQueryWrapper<PsychologyDaily>()
                .eq(PsychologyDaily::getUserId, userId)
                .eq(PsychologyDaily::getRecordDate, daily.getRecordDate())
        );
        
        if (existing != null) {
            daily.setId(existing.getId());
            dailyMapper.updateById(daily);
        } else {
            dailyMapper.insert(daily);
        }
    }
    
    /**
     * 获取指定日期的打卡记录
     */
    public PsychologyDaily getDailyByDate(LocalDate date) {
        Long userId = SecurityUtils.getUserId();
        return dailyMapper.selectOne(
            new LambdaQueryWrapper<PsychologyDaily>()
                .eq(PsychologyDaily::getUserId, userId)
                .eq(PsychologyDaily::getRecordDate, date)
        );
    }
    
    /**
     * 获取每日记录列表
     */
    public List<PsychologyDaily> getDailyList(LocalDate startDate, LocalDate endDate) {
        Long userId = SecurityUtils.getUserId();
        return dailyMapper.selectList(
            new LambdaQueryWrapper<PsychologyDaily>()
                .eq(PsychologyDaily::getUserId, userId)
                .between(PsychologyDaily::getRecordDate, startDate, endDate)
                .orderByDesc(PsychologyDaily::getRecordDate)
        );
    }
    
    // ========== 交易情绪 ==========
    
    /**
     * 保存交易情绪记录
     */
    public void saveTrade(PsychologyTrade trade) {
        Long userId = SecurityUtils.getUserId();
        trade.setUserId(userId);
        
        if (trade.getId() != null) {
            tradeMapper.updateById(trade);
        } else {
            tradeMapper.insert(trade);
        }
    }
    
    /**
     * 获取交易情绪列表
     */
    public List<PsychologyTrade> getTradeList(LocalDate startDate, LocalDate endDate) {
        Long userId = SecurityUtils.getUserId();
        LambdaQueryWrapper<PsychologyTrade> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PsychologyTrade::getUserId, userId);
        if (startDate != null && endDate != null) {
            wrapper.between(PsychologyTrade::getRecordDate, startDate, endDate);
        }
        wrapper.orderByDesc(PsychologyTrade::getCreateTime);
        return tradeMapper.selectList(wrapper);
    }
    
    // ========== 日历数据 ==========
    
    /**
     * 获取日历数据
     */
    public List<Map<String, Object>> getCalendarData(int year, int month) {
        Long userId = SecurityUtils.getUserId();
        YearMonth ym = YearMonth.of(year, month);
        LocalDate startDate = ym.atDay(1);
        LocalDate endDate = ym.atEndOfMonth();
        
        return dailyMapper.getCalendarData(userId, startDate, endDate);
    }
    
    // ========== 情绪分析 ==========
    
    /**
     * 获取情绪分析数据
     */
    public Map<String, Object> getAnalysis(String period) {
        Long userId = SecurityUtils.getUserId();
        LocalDate endDate = LocalDate.now();
        LocalDate startDate;
        
        switch (period) {
            case "week":
                startDate = endDate.minusWeeks(1);
                break;
            case "month":
                startDate = endDate.minusMonths(1);
                break;
            default:
                startDate = endDate.minusMonths(3);
        }
        
        Map<String, Object> result = new HashMap<>();
        
        // 1. 情绪趋势
        List<PsychologyDaily> dailyList = getDailyList(startDate, endDate);
        List<Map<String, Object>> moodTrend = dailyList.stream()
            .sorted(Comparator.comparing(PsychologyDaily::getRecordDate))
            .map(d -> {
                Map<String, Object> item = new HashMap<>();
                item.put("date", d.getRecordDate().toString());
                item.put("score", d.getMoodScore());
                return item;
            })
            .collect(Collectors.toList());
        result.put("moodTrend", moodTrend);
        
        // 2. 情绪统计
        Map<String, Object> moodStats = dailyMapper.getMoodStats(userId, startDate, endDate);
        result.put("avgMood", moodStats.get("avgMood"));
        result.put("totalDays", moodStats.get("totalDays"));
        
        // 3. 心理陷阱统计
        Map<String, Integer> trapCounts = new HashMap<>();
        for (PsychologyDaily daily : dailyList) {
            if (daily.getTraps() != null && !daily.getTraps().isEmpty()) {
                try {
                    List<String> traps = objectMapper.readValue(daily.getTraps(), 
                        new TypeReference<List<String>>() {});
                    for (String trap : traps) {
                        trapCounts.merge(trap, 1, Integer::sum);
                    }
                } catch (Exception e) {
                    // ignore
                }
            }
        }
        
        List<Map<String, Object>> trapStats = trapCounts.entrySet().stream()
            .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
            .map(e -> {
                Map<String, Object> item = new HashMap<>();
                item.put("trap", e.getKey());
                item.put("count", e.getValue());
                return item;
            })
            .collect(Collectors.toList());
        result.put("trapStats", trapStats);
        
        // 4. 情绪分布
        Map<String, Long> moodDistribution = dailyList.stream()
            .collect(Collectors.groupingBy(
                d -> {
                    int score = d.getMoodScore();
                    if (score >= 7) return "high";
                    if (score >= 4) return "medium";
                    return "low";
                },
                Collectors.counting()
            ));
        result.put("moodDistribution", moodDistribution);
        
        return result;
    }
    
    /**
     * 获取月度概览
     */
    public Map<String, Object> getMonthOverview(int year, int month) {
        Long userId = SecurityUtils.getUserId();
        YearMonth ym = YearMonth.of(year, month);
        LocalDate startDate = ym.atDay(1);
        LocalDate endDate = ym.atEndOfMonth();
        
        Map<String, Object> stats = dailyMapper.getMoodStats(userId, startDate, endDate);
        
        // 统计心理陷阱次数
        List<PsychologyDaily> dailyList = getDailyList(startDate, endDate);
        int trapCount = 0;
        for (PsychologyDaily daily : dailyList) {
            if (daily.getTraps() != null && !daily.getTraps().isEmpty() 
                && !daily.getTraps().equals("[]")) {
                trapCount++;
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("avgMood", stats.get("avgMood"));
        result.put("totalDays", stats.get("totalDays"));
        result.put("daysInMonth", ym.lengthOfMonth());
        result.put("trapDays", trapCount);
        
        return result;
    }
}
