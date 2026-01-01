package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.trader.entity.LearnCheckin;
import com.trader.mapper.LearnCheckinMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 学习打卡服务
 */
@Service
public class LearnCheckinService extends ServiceImpl<LearnCheckinMapper, LearnCheckin> {
    
    /**
     * 获取日历数据（指定年月）
     */
    public List<Map<String, Object>> getCalendarData(Long userId, Integer year, Integer month) {
        LocalDate startDate = LocalDate.of(year, month, 1);
        LocalDate endDate = startDate.plusMonths(1).minusDays(1);
        
        List<LearnCheckin> records = baseMapper.getByDateRange(userId, startDate, endDate);
        
        // 转换为Map便于查找
        Map<LocalDate, LearnCheckin> recordMap = records.stream()
                .collect(Collectors.toMap(LearnCheckin::getCheckinDate, r -> r));
        
        List<Map<String, Object>> result = new ArrayList<>();
        LocalDate current = startDate;
        while (!current.isAfter(endDate)) {
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", current.toString());
            dayData.put("day", current.getDayOfMonth());
            
            LearnCheckin checkin = recordMap.get(current);
            if (checkin != null) {
                dayData.put("studyMinutes", checkin.getStudyMinutes());
                dayData.put("chaptersCompleted", checkin.getChaptersCompleted());
                dayData.put("quizzesCompleted", checkin.getQuizzesCompleted());
                dayData.put("casesViewed", checkin.getCasesViewed());
                dayData.put("level", getLevel(checkin.getStudyMinutes()));
            } else {
                dayData.put("studyMinutes", 0);
                dayData.put("chaptersCompleted", 0);
                dayData.put("quizzesCompleted", 0);
                dayData.put("casesViewed", 0);
                dayData.put("level", 0);
            }
            
            result.add(dayData);
            current = current.plusDays(1);
        }
        
        return result;
    }
    
    /**
     * 获取热力图数据（过去N天）
     */
    public List<Map<String, Object>> getHeatmapData(Long userId, Integer days) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);
        
        List<LearnCheckin> records = baseMapper.getByDateRange(userId, startDate, endDate);
        
        Map<LocalDate, LearnCheckin> recordMap = records.stream()
                .collect(Collectors.toMap(LearnCheckin::getCheckinDate, r -> r));
        
        List<Map<String, Object>> result = new ArrayList<>();
        LocalDate current = startDate;
        while (!current.isAfter(endDate)) {
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", current.toString());
            
            LearnCheckin checkin = recordMap.get(current);
            int minutes = checkin != null ? checkin.getStudyMinutes() : 0;
            dayData.put("value", minutes);
            dayData.put("level", getLevel(minutes));
            
            result.add(dayData);
            current = current.plusDays(1);
        }
        
        return result;
    }
    
    /**
     * 获取连续打卡信息
     */
    public Map<String, Object> getStreakInfo(Long userId) {
        LocalDate today = LocalDate.now();
        
        // 获取最近60天的记录来计算连续天数
        LocalDate startDate = today.minusDays(60);
        List<LearnCheckin> records = baseMapper.getByDateRange(userId, startDate, today);
        
        // 计算当前连续天数
        int currentStreak = 0;
        LocalDate checkDate = today;
        Set<LocalDate> checkinDates = records.stream()
                .filter(r -> r.getStudyMinutes() > 0)
                .map(LearnCheckin::getCheckinDate)
                .collect(Collectors.toSet());
        
        while (checkinDates.contains(checkDate)) {
            currentStreak++;
            checkDate = checkDate.minusDays(1);
        }
        
        // 计算最长连续天数
        int maxStreak = 0;
        int tempStreak = 0;
        List<LocalDate> sortedDates = new ArrayList<>(checkinDates);
        Collections.sort(sortedDates);
        
        for (int i = 0; i < sortedDates.size(); i++) {
            if (i == 0 || ChronoUnit.DAYS.between(sortedDates.get(i - 1), sortedDates.get(i)) == 1) {
                tempStreak++;
            } else {
                maxStreak = Math.max(maxStreak, tempStreak);
                tempStreak = 1;
            }
        }
        maxStreak = Math.max(maxStreak, tempStreak);
        
        // 总打卡天数和学习时长
        Integer totalDays = baseMapper.getTotalCheckinDays(userId);
        Integer totalMinutes = baseMapper.getTotalStudyMinutes(userId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("currentStreak", currentStreak);
        result.put("maxStreak", maxStreak);
        result.put("totalDays", totalDays != null ? totalDays : 0);
        result.put("totalMinutes", totalMinutes != null ? totalMinutes : 0);
        result.put("todayChecked", checkinDates.contains(today));
        
        return result;
    }
    
    /**
     * 今日打卡
     */
    public LearnCheckin checkinToday(Long userId) {
        LocalDate today = LocalDate.now();
        
        // 查找今日记录
        LambdaQueryWrapper<LearnCheckin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnCheckin::getUserId, userId)
               .eq(LearnCheckin::getCheckinDate, today);
        LearnCheckin checkin = getOne(wrapper);
        
        if (checkin == null) {
            // 创建新记录
            checkin = new LearnCheckin();
            checkin.setUserId(userId);
            checkin.setCheckinDate(today);
            checkin.setStudyMinutes(0);
            checkin.setChaptersCompleted(0);
            checkin.setQuizzesCompleted(0);
            checkin.setCasesViewed(0);
            save(checkin);
        }
        
        return checkin;
    }
    
    /**
     * 更新今日学习数据
     */
    public void updateTodayData(Long userId, Integer addMinutes, Integer addChapters, 
                                 Integer addQuizzes, Integer addCases) {
        LocalDate today = LocalDate.now();
        
        LambdaQueryWrapper<LearnCheckin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnCheckin::getUserId, userId)
               .eq(LearnCheckin::getCheckinDate, today);
        LearnCheckin checkin = getOne(wrapper);
        
        if (checkin == null) {
            checkin = new LearnCheckin();
            checkin.setUserId(userId);
            checkin.setCheckinDate(today);
            checkin.setStudyMinutes(addMinutes != null ? addMinutes : 0);
            checkin.setChaptersCompleted(addChapters != null ? addChapters : 0);
            checkin.setQuizzesCompleted(addQuizzes != null ? addQuizzes : 0);
            checkin.setCasesViewed(addCases != null ? addCases : 0);
            save(checkin);
        } else {
            if (addMinutes != null) {
                checkin.setStudyMinutes(checkin.getStudyMinutes() + addMinutes);
            }
            if (addChapters != null) {
                checkin.setChaptersCompleted(checkin.getChaptersCompleted() + addChapters);
            }
            if (addQuizzes != null) {
                checkin.setQuizzesCompleted(checkin.getQuizzesCompleted() + addQuizzes);
            }
            if (addCases != null) {
                checkin.setCasesViewed(checkin.getCasesViewed() + addCases);
            }
            updateById(checkin);
        }
    }
    
    /**
     * 根据学习时长获取等级
     */
    private int getLevel(Integer minutes) {
        if (minutes == null || minutes == 0) return 0;
        if (minutes <= 30) return 1;
        if (minutes <= 60) return 2;
        if (minutes <= 120) return 3;
        return 4;
    }
}
