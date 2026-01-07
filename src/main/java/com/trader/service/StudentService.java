package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.*;
import com.trader.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class StudentService {
    private final SysUserMapper userMapper;
    private final LearnProgressMapper progressMapper;
    private final LearnNoteMapper noteMapper;
    private final LearnCheckinMapper checkinMapper;
    private final TradeLogMapper tradeLogMapper;
    private final LearnQuizRecordMapper quizRecordMapper;

    /**
     * 学员列表
     */
    public PageResult<SysUser> list(int pageNum, int pageSize, String keyword) {
        Page<SysUser> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUser::getRole, "student");
        wrapper.eq(SysUser::getStatus, 1);
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like(SysUser::getUsername, keyword)
                    .or().like(SysUser::getNickname, keyword));
        }
        wrapper.orderByDesc(SysUser::getCreateTime);
        Page<SysUser> result = userMapper.selectPage(page, wrapper);
        // 清除密码
        result.getRecords().forEach(u -> u.setPassword(null));
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    /**
     * 用户列表（不包含管理员）
     */
    public PageResult<SysUser> listNonAdmin(int pageNum, int pageSize, String keyword) {
        Page<SysUser> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        // 排除管理员
        wrapper.ne(SysUser::getRole, "admin");
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like(SysUser::getUsername, keyword)
                    .or().like(SysUser::getNickname, keyword));
        }
        wrapper.orderByDesc(SysUser::getCreateTime);
        Page<SysUser> result = userMapper.selectPage(page, wrapper);
        // 清除密码
        result.getRecords().forEach(u -> u.setPassword(null));
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    /**
     * 学员详情
     */
    public SysUser getById(Long id) {
        SysUser user = userMapper.selectById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    /**
     * 学员学习进度统计
     */
    public Map<String, Object> getProgress(Long userId) {
        Map<String, Object> result = new HashMap<>();

        // 课程进度
        List<LearnProgress> progressList = progressMapper.selectList(
                new LambdaQueryWrapper<LearnProgress>().eq(LearnProgress::getUserId, userId));
        int completedChapters = (int) progressList.stream()
                .filter(p -> p.getIsCompleted() != null && p.getIsCompleted() == 1).count();
        int totalChapters = progressList.size();
        
        result.put("completedChapters", completedChapters);
        result.put("totalChapters", totalChapters);
        result.put("progressRate", totalChapters > 0 
                ? BigDecimal.valueOf(completedChapters * 100.0 / totalChapters).setScale(1, RoundingMode.HALF_UP) 
                : BigDecimal.ZERO);

        // 笔记数量
        Long noteCount = noteMapper.selectCount(
                new LambdaQueryWrapper<LearnNote>().eq(LearnNote::getUserId, userId));
        result.put("noteCount", noteCount);

        // 打卡天数
        Long checkinDays = checkinMapper.selectCount(
                new LambdaQueryWrapper<LearnCheckin>().eq(LearnCheckin::getUserId, userId));
        result.put("checkinDays", checkinDays);

        // 测验记录
        List<LearnQuizRecord> quizRecords = quizRecordMapper.selectList(
                new LambdaQueryWrapper<LearnQuizRecord>().eq(LearnQuizRecord::getUserId, userId));
        int quizCount = quizRecords.size();
        double avgScore = quizRecords.stream()
                .filter(r -> r.getScore() != null)
                .mapToInt(LearnQuizRecord::getScore)
                .average().orElse(0);
        result.put("quizCount", quizCount);
        result.put("avgScore", BigDecimal.valueOf(avgScore).setScale(1, RoundingMode.HALF_UP));

        return result;
    }

    /**
     * 学员交易统计
     */
    public Map<String, Object> getTradeStats(Long userId) {
        Map<String, Object> result = new HashMap<>();

        List<TradeLog> trades = tradeLogMapper.selectList(
                new LambdaQueryWrapper<TradeLog>()
                        .eq(TradeLog::getUserId, userId)
                        .eq(TradeLog::getStatus, 1));

        int totalTrades = trades.size();
        int winTrades = (int) trades.stream()
                .filter(t -> t.getProfitLoss() != null && t.getProfitLoss().compareTo(BigDecimal.ZERO) > 0)
                .count();
        BigDecimal totalPnl = trades.stream()
                .filter(t -> t.getProfitLoss() != null)
                .map(TradeLog::getProfitLoss)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        result.put("totalTrades", totalTrades);
        result.put("winTrades", winTrades);
        result.put("loseTrades", totalTrades - winTrades);
        result.put("winRate", totalTrades > 0 
                ? BigDecimal.valueOf(winTrades * 100.0 / totalTrades).setScale(1, RoundingMode.HALF_UP) 
                : BigDecimal.ZERO);
        result.put("totalPnl", totalPnl);

        return result;
    }

    /**
     * 学员交易日志列表
     */
    public PageResult<TradeLog> getTradeLogs(Long userId, int pageNum, int pageSize) {
        Page<TradeLog> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<TradeLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradeLog::getUserId, userId);
        wrapper.orderByDesc(TradeLog::getTradeDate);
        Page<TradeLog> result = tradeLogMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    /**
     * 学员打卡记录
     */
    public List<LearnCheckin> getCheckins(Long userId, int year, int month) {
        LambdaQueryWrapper<LearnCheckin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnCheckin::getUserId, userId);
        wrapper.apply("YEAR(checkin_date) = {0} AND MONTH(checkin_date) = {1}", year, month);
        wrapper.orderByDesc(LearnCheckin::getCheckinDate);
        return checkinMapper.selectList(wrapper);
    }
}
