package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.TradePlan;
import com.trader.mapper.TradePlanMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class TradePlanService {
    
    private final TradePlanMapper tradePlanMapper;
    
    /**
     * 获取计划列表
     */
    public PageResult<TradePlan> list(int pageNum, int pageSize, Integer status, String symbol) {
        Long userId = SecurityUtils.getUserId();
        Page<TradePlan> page = new Page<>(pageNum, pageSize);
        
        LambdaQueryWrapper<TradePlan> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradePlan::getUserId, userId);
        if (status != null) {
            wrapper.eq(TradePlan::getStatus, status);
        }
        if (symbol != null && !symbol.isEmpty()) {
            wrapper.like(TradePlan::getSymbol, symbol);
        }
        wrapper.orderByDesc(TradePlan::getCreateTime);
        
        Page<TradePlan> result = tradePlanMapper.selectPage(page, wrapper);
        
        // 计算额外字段
        result.getRecords().forEach(this::calculateFields);
        
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取计划详情
     */
    public TradePlan getById(Long id) {
        TradePlan plan = tradePlanMapper.selectById(id);
        if (plan != null) {
            calculateFields(plan);
        }
        return plan;
    }
    
    /**
     * 创建计划
     */
    public void create(TradePlan plan) {
        plan.setUserId(SecurityUtils.getUserId());
        plan.setStatus(1); // 待执行
        tradePlanMapper.insert(plan);
    }
    
    /**
     * 更新计划
     */
    public void update(TradePlan plan) {
        // 只能更新待执行的计划
        TradePlan existing = tradePlanMapper.selectById(plan.getId());
        if (existing != null && existing.getStatus() == 1) {
            tradePlanMapper.updateById(plan);
        }
    }
    
    /**
     * 删除计划
     */
    public void delete(Long id) {
        tradePlanMapper.deleteById(id);
    }
    
    /**
     * 执行计划
     */
    public void execute(Long id, Long tradeLogId) {
        TradePlan plan = tradePlanMapper.selectById(id);
        if (plan != null && plan.getStatus() == 1) {
            plan.setStatus(2); // 已执行
            plan.setExecuteTime(LocalDateTime.now());
            plan.setTradeLogId(tradeLogId);
            tradePlanMapper.updateById(plan);
        }
    }
    
    /**
     * 取消计划
     */
    public void cancel(Long id) {
        TradePlan plan = tradePlanMapper.selectById(id);
        if (plan != null && plan.getStatus() == 1) {
            plan.setStatus(3); // 已取消
            tradePlanMapper.updateById(plan);
        }
    }
    
    /**
     * 获取统计数据
     */
    public Map<String, Object> getStats() {
        Long userId = SecurityUtils.getUserId();
        
        List<TradePlan> allPlans = tradePlanMapper.selectList(
            new LambdaQueryWrapper<TradePlan>().eq(TradePlan::getUserId, userId)
        );
        
        long pending = allPlans.stream().filter(p -> p.getStatus() == 1).count();
        long executed = allPlans.stream().filter(p -> p.getStatus() == 2).count();
        long cancelled = allPlans.stream().filter(p -> p.getStatus() == 3).count();
        long expired = allPlans.stream().filter(p -> p.getStatus() == 4).count();
        
        // 计算执行率
        long total = pending + executed + cancelled + expired;
        double executeRate = total > 0 ? (double) executed / total * 100 : 0;
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", total);
        stats.put("pending", pending);
        stats.put("executed", executed);
        stats.put("cancelled", cancelled);
        stats.put("expired", expired);
        stats.put("executeRate", BigDecimal.valueOf(executeRate).setScale(1, RoundingMode.HALF_UP));
        
        return stats;
    }
    
    /**
     * 计算额外字段
     */
    private void calculateFields(TradePlan plan) {
        if (plan.getEntryPrice() == null || plan.getEntryPrice().compareTo(BigDecimal.ZERO) == 0) {
            return;
        }
        
        BigDecimal entryPrice = plan.getEntryPrice();
        BigDecimal stopLossPrice = plan.getStopLossPrice();
        
        // 计算止损幅度
        if (stopLossPrice != null) {
            BigDecimal stopLossDiff = entryPrice.subtract(stopLossPrice).abs();
            plan.setStopLossPercent(
                stopLossDiff.divide(entryPrice, 4, RoundingMode.HALF_UP)
                    .multiply(BigDecimal.valueOf(100))
            );
            
            // 计算盈亏比
            if (plan.getTakeProfit1() != null) {
                BigDecimal tp1Diff = plan.getTakeProfit1().subtract(entryPrice).abs();
                plan.setRiskRewardRatio1(
                    tp1Diff.divide(stopLossDiff, 2, RoundingMode.HALF_UP)
                );
            }
            if (plan.getTakeProfit2() != null) {
                BigDecimal tp2Diff = plan.getTakeProfit2().subtract(entryPrice).abs();
                plan.setRiskRewardRatio2(
                    tp2Diff.divide(stopLossDiff, 2, RoundingMode.HALF_UP)
                );
            }
            if (plan.getTakeProfit3() != null) {
                BigDecimal tp3Diff = plan.getTakeProfit3().subtract(entryPrice).abs();
                plan.setRiskRewardRatio3(
                    tp3Diff.divide(stopLossDiff, 2, RoundingMode.HALF_UP)
                );
            }
        }
    }
}
