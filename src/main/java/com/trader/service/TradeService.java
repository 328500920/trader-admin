package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.*;
import com.trader.mapper.*;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TradeService {
    private final TradeLogMapper tradeLogMapper;
    private final TradeImageMapper tradeImageMapper;
    private final TradeSummaryMapper tradeSummaryMapper;

    public PageResult<TradeLog> list(int pageNum, int pageSize, String symbol, String strategy, 
            Integer status, LocalDate startDate, LocalDate endDate) {
        Long userId = SecurityUtils.getUserId();
        Page<TradeLog> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<TradeLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradeLog::getUserId, userId);
        if (StrUtil.isNotBlank(symbol)) wrapper.eq(TradeLog::getSymbol, symbol);
        if (StrUtil.isNotBlank(strategy)) wrapper.eq(TradeLog::getStrategy, strategy);
        if (status != null) wrapper.eq(TradeLog::getStatus, status);
        if (startDate != null) wrapper.ge(TradeLog::getTradeDate, startDate);
        if (endDate != null) wrapper.le(TradeLog::getTradeDate, endDate);
        wrapper.orderByDesc(TradeLog::getTradeDate);
        Page<TradeLog> result = tradeLogMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    public TradeLog getById(Long id) {
        TradeLog trade = tradeLogMapper.selectById(id);
        if (trade != null) {
            List<TradeImage> images = tradeImageMapper.selectList(
                    new LambdaQueryWrapper<TradeImage>().eq(TradeImage::getTradeId, id));
            trade.setImages(images);
        }
        return trade;
    }

    public void create(TradeLog trade) {
        trade.setUserId(SecurityUtils.getUserId());
        trade.setStatus(0);
        tradeLogMapper.insert(trade);
    }

    public void update(TradeLog trade) {
        tradeLogMapper.updateById(trade);
    }

    public void delete(Long id) {
        tradeLogMapper.deleteById(id);
        tradeImageMapper.delete(new LambdaQueryWrapper<TradeImage>().eq(TradeImage::getTradeId, id));
    }

    public void closeTrade(Long id, TradeLog closeInfo) {
        TradeLog trade = tradeLogMapper.selectById(id);
        if (trade != null && trade.getStatus() == 0) {
            trade.setExitPrice(closeInfo.getExitPrice());
            trade.setExitTime(closeInfo.getExitTime());
            trade.setExitReason(closeInfo.getExitReason());
            trade.setStatus(1);
            // 计算盈亏
            if (trade.getEntryPrice() != null && closeInfo.getExitPrice() != null && trade.getPositionSize() != null) {
                BigDecimal priceDiff = closeInfo.getExitPrice().subtract(trade.getEntryPrice());
                if (trade.getDirection() == 2) priceDiff = priceDiff.negate();
                BigDecimal profitPercent = priceDiff.divide(trade.getEntryPrice(), 6, RoundingMode.HALF_UP);
                trade.setProfitLossPercent(profitPercent.multiply(BigDecimal.valueOf(100)));
                trade.setProfitLoss(trade.getPositionSize().multiply(profitPercent));
            }
            tradeLogMapper.updateById(trade);
        }
    }

    public void addImage(Long tradeId, TradeImage image) {
        image.setTradeId(tradeId);
        tradeImageMapper.insert(image);
    }

    public void deleteImage(Long imageId) {
        tradeImageMapper.deleteById(imageId);
    }

    public Map<String, Object> getSummary(String period) {
        Long userId = SecurityUtils.getUserId();
        LocalDate startDate = getStartDate(period);
        LambdaQueryWrapper<TradeLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradeLog::getUserId, userId).eq(TradeLog::getStatus, 1);
        if (startDate != null) wrapper.ge(TradeLog::getTradeDate, startDate);
        List<TradeLog> trades = tradeLogMapper.selectList(wrapper);

        int total = trades.size();
        int wins = (int) trades.stream().filter(t -> t.getProfitLoss() != null && t.getProfitLoss().compareTo(BigDecimal.ZERO) > 0).count();
        BigDecimal totalProfit = trades.stream().filter(t -> t.getProfitLoss() != null && t.getProfitLoss().compareTo(BigDecimal.ZERO) > 0)
                .map(TradeLog::getProfitLoss).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalLoss = trades.stream().filter(t -> t.getProfitLoss() != null && t.getProfitLoss().compareTo(BigDecimal.ZERO) < 0)
                .map(TradeLog::getProfitLoss).reduce(BigDecimal.ZERO, BigDecimal::add).abs();
        BigDecimal netProfit = totalProfit.subtract(totalLoss);

        Map<String, Object> result = new HashMap<>();
        result.put("totalTrades", total);
        result.put("winTrades", wins);
        result.put("loseTrades", total - wins);
        result.put("winRate", total > 0 ? BigDecimal.valueOf(wins * 100.0 / total).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO);
        result.put("totalProfit", totalProfit);
        result.put("totalLoss", totalLoss);
        result.put("netProfit", netProfit);
        result.put("profitFactor", totalLoss.compareTo(BigDecimal.ZERO) > 0 ? totalProfit.divide(totalLoss, 2, RoundingMode.HALF_UP) : BigDecimal.ZERO);
        return result;
    }

    public List<Map<String, Object>> getChartData(String period) {
        Long userId = SecurityUtils.getUserId();
        LocalDate startDate = getStartDate(period);
        LambdaQueryWrapper<TradeLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradeLog::getUserId, userId).eq(TradeLog::getStatus, 1);
        if (startDate != null) wrapper.ge(TradeLog::getTradeDate, startDate);
        wrapper.orderByAsc(TradeLog::getTradeDate);
        List<TradeLog> trades = tradeLogMapper.selectList(wrapper);

        Map<String, BigDecimal> dailyProfit = new LinkedHashMap<>();
        BigDecimal cumulative = BigDecimal.ZERO;
        for (TradeLog trade : trades) {
            String date = trade.getTradeDate().format(DateTimeFormatter.ISO_DATE);
            if (trade.getProfitLoss() != null) {
                cumulative = cumulative.add(trade.getProfitLoss());
            }
            dailyProfit.put(date, cumulative);
        }
        List<Map<String, Object>> chartData = new ArrayList<>();
        for (Map.Entry<String, BigDecimal> e : dailyProfit.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("date", e.getKey());
            item.put("profit", e.getValue());
            chartData.add(item);
        }
        return chartData;
    }

    public List<Map<String, Object>> getStrategyStats() {
        Long userId = SecurityUtils.getUserId();
        List<TradeLog> trades = tradeLogMapper.selectList(new LambdaQueryWrapper<TradeLog>()
                .eq(TradeLog::getUserId, userId).eq(TradeLog::getStatus, 1));
        return trades.stream().filter(t -> StrUtil.isNotBlank(t.getStrategy()))
                .collect(Collectors.groupingBy(TradeLog::getStrategy))
                .entrySet().stream().map(e -> {
                    List<TradeLog> list = e.getValue();
                    int wins = (int) list.stream().filter(t -> t.getProfitLoss() != null && t.getProfitLoss().compareTo(BigDecimal.ZERO) > 0).count();
                    Map<String, Object> item = new HashMap<>();
                    item.put("strategy", e.getKey());
                    item.put("count", list.size());
                    item.put("winRate", list.size() > 0 ? wins * 100 / list.size() : 0);
                    return item;
                }).collect(Collectors.toList());
    }

    public List<Map<String, Object>> getSymbolStats() {
        Long userId = SecurityUtils.getUserId();
        List<TradeLog> trades = tradeLogMapper.selectList(new LambdaQueryWrapper<TradeLog>()
                .eq(TradeLog::getUserId, userId).eq(TradeLog::getStatus, 1));
        return trades.stream().collect(Collectors.groupingBy(TradeLog::getSymbol))
                .entrySet().stream().map(e -> {
                    List<TradeLog> list = e.getValue();
                    BigDecimal profit = list.stream().filter(t -> t.getProfitLoss() != null)
                            .map(TradeLog::getProfitLoss).reduce(BigDecimal.ZERO, BigDecimal::add);
                    Map<String, Object> item = new HashMap<>();
                    item.put("symbol", e.getKey());
                    item.put("count", list.size());
                    item.put("profit", profit);
                    return item;
                }).collect(Collectors.toList());
    }

    private LocalDate getStartDate(String period) {
        if ("week".equals(period)) return LocalDate.now().minusWeeks(1);
        if ("month".equals(period)) return LocalDate.now().minusMonths(1);
        if ("quarter".equals(period)) return LocalDate.now().minusMonths(3);
        if ("year".equals(period)) return LocalDate.now().minusYears(1);
        return null;
    }
}
