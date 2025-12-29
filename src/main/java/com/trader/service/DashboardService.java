package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.trader.entity.*;
import com.trader.mapper.*;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class DashboardService {
    private final LearnChapterMapper chapterMapper;
    private final LearnProgressMapper progressMapper;
    private final LearnTaskMapper taskMapper;
    private final LearnTaskRecordMapper taskRecordMapper;
    private final TradeLogMapper tradeLogMapper;

    public Map<String, Object> getStats() {
        Long userId = SecurityUtils.getUserId();
        Map<String, Object> stats = new HashMap<>();

        // 学习进度
        int totalChapters = chapterMapper.selectCount(new LambdaQueryWrapper<LearnChapter>().eq(LearnChapter::getStatus, 1)).intValue();
        int completedChapters = progressMapper.selectCount(new LambdaQueryWrapper<LearnProgress>()
                .eq(LearnProgress::getUserId, userId).eq(LearnProgress::getIsCompleted, 1)).intValue();
        stats.put("learnProgress", totalChapters > 0 ? completedChapters * 100 / totalChapters : 0);

        // 本月交易统计
        LocalDate monthStart = LocalDate.now().withDayOfMonth(1);
        List<TradeLog> monthTrades = tradeLogMapper.selectList(new LambdaQueryWrapper<TradeLog>()
                .eq(TradeLog::getUserId, userId).ge(TradeLog::getTradeDate, monthStart));
        stats.put("monthTrades", monthTrades.size());

        // 本月收益
        BigDecimal monthProfit = monthTrades.stream()
                .filter(t -> t.getStatus() == 1 && t.getProfitLoss() != null)
                .map(TradeLog::getProfitLoss)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        stats.put("monthProfit", monthProfit);

        // 胜率
        long closedTrades = monthTrades.stream().filter(t -> t.getStatus() == 1).count();
        long winTrades = monthTrades.stream()
                .filter(t -> t.getStatus() == 1 && t.getProfitLoss() != null && t.getProfitLoss().compareTo(BigDecimal.ZERO) > 0)
                .count();
        stats.put("winRate", closedTrades > 0 ? BigDecimal.valueOf(winTrades * 100.0 / closedTrades).setScale(1, RoundingMode.HALF_UP) : BigDecimal.ZERO);

        return stats;
    }

    public List<TradeLog> getRecentTrades() {
        Long userId = SecurityUtils.getUserId();
        return tradeLogMapper.selectList(new LambdaQueryWrapper<TradeLog>()
                .eq(TradeLog::getUserId, userId)
                .orderByDesc(TradeLog::getCreateTime)
                .last("LIMIT 5"));
    }

    public List<Map<String, Object>> getCurrentTasks() {
        Long userId = SecurityUtils.getUserId();
        // 获取当前进行中的章节任务
        List<LearnProgress> progresses = progressMapper.selectList(new LambdaQueryWrapper<LearnProgress>()
                .eq(LearnProgress::getUserId, userId).eq(LearnProgress::getIsCompleted, 0));
        
        List<Map<String, Object>> tasks = new ArrayList<>();
        if (!progresses.isEmpty()) {
            Long chapterId = progresses.get(0).getChapterId();
            List<LearnTask> chapterTasks = taskMapper.selectList(new LambdaQueryWrapper<LearnTask>()
                    .eq(LearnTask::getChapterId, chapterId).orderByAsc(LearnTask::getSortOrder));
            List<Long> completedTaskIds = taskRecordMapper.selectList(new LambdaQueryWrapper<LearnTaskRecord>()
                    .eq(LearnTaskRecord::getUserId, userId).eq(LearnTaskRecord::getIsCompleted, 1))
                    .stream().map(LearnTaskRecord::getTaskId).collect(java.util.stream.Collectors.toList());
            
            for (LearnTask task : chapterTasks) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", task.getId());
                item.put("content", task.getTaskContent());
                item.put("completed", completedTaskIds.contains(task.getId()));
                tasks.add(item);
            }
        }
        return tasks;
    }
}
