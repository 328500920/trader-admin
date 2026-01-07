package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.TradeLog;
import com.trader.entity.TradePosition;
import com.trader.mapper.TradeLogMapper;
import com.trader.mapper.TradePositionMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import cn.hutool.core.util.StrUtil;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class TradePositionService {
    private final TradePositionMapper tradePositionMapper;
    private final TradeLogMapper tradeLogMapper;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

    public PageResult<TradePosition> list(int pageNum, int pageSize, String symbol,
            String positionSide, LocalDateTime startTime, LocalDateTime endTime) {
        Long userId = SecurityUtils.getUserId();
        Page<TradePosition> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<TradePosition> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradePosition::getUserId, userId);
        if (StrUtil.isNotBlank(symbol)) wrapper.like(TradePosition::getSymbol, symbol);
        if (StrUtil.isNotBlank(positionSide)) wrapper.eq(TradePosition::getPositionSide, positionSide);
        if (startTime != null) wrapper.ge(TradePosition::getOpenTime, startTime);
        if (endTime != null) wrapper.le(TradePosition::getOpenTime, endTime);
        wrapper.orderByDesc(TradePosition::getOpenTime);
        Page<TradePosition> result = tradePositionMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    public TradePosition getById(Long id) {
        return tradePositionMapper.selectById(id);
    }

    public void delete(Long id) {
        tradePositionMapper.deleteById(id);
    }

    public Map<String, Object> importFromExcel(MultipartFile file) throws Exception {
        Long userId = SecurityUtils.getUserId();
        List<TradePosition> positions = new ArrayList<>();
        int successCount = 0;
        int failCount = 0;
        List<String> errors = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            
            // 读取表头
            String headerLine = reader.readLine();
            if (headerLine == null) {
                throw new RuntimeException("文件为空");
            }
            
            // 去除BOM标记（如果有）
            if (headerLine.startsWith("\uFEFF")) {
                headerLine = headerLine.substring(1);
            }
            
            log.info("CSV表头原始内容: {}", headerLine);
            
            // 解析表头，获取列索引（使用CSV解析处理引号）
            String[] headers = parseCsvLine(headerLine);
            Map<String, Integer> columnIndex = new HashMap<>();
            for (int i = 0; i < headers.length; i++) {
                String header = cleanValue(headers[i]);
                log.info("表头[{}]: 原始='{}', 清理后='{}'", i, headers[i], header);
                if (StrUtil.isNotBlank(header)) {
                    columnIndex.put(header, i);
                }
            }
            
            log.info("列索引映射: {}", columnIndex);

            // 读取数据行
            String line;
            int lineNum = 1;
            while ((line = reader.readLine()) != null) {
                lineNum++;
                if (StrUtil.isBlank(line)) continue;
                
                try {
                    String[] values = parseCsvLine(line);
                    if (lineNum == 2) {
                        log.info("第一行数据解析结果: {}", Arrays.toString(values));
                    }
                    TradePosition position = parseRow(values, columnIndex, userId);
                    if (position != null && StrUtil.isNotBlank(position.getSymbol())) {
                        positions.add(position);
                        successCount++;
                    } else {
                        failCount++;
                        String symbolValue = columnIndex.get("symbol") != null && columnIndex.get("symbol") < values.length 
                            ? values[columnIndex.get("symbol")] : "索引不存在";
                        errors.add("第" + lineNum + "行: symbol为空, 原始值=" + symbolValue);
                    }
                } catch (Exception e) {
                    failCount++;
                    errors.add("第" + lineNum + "行: " + e.getMessage());
                }
            }
        }

        for (TradePosition position : positions) {
            tradePositionMapper.insert(position);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("successCount", successCount);
        result.put("failCount", failCount);
        result.put("errors", errors.size() > 10 ? errors.subList(0, 10) : errors);
        return result;
    }

    // 解析CSV行，正确处理双引号包裹的字段
    private String[] parseCsvLine(String line) {
        List<String> result = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;
        
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '"') {
                // 检查是否是转义的引号 ""
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    current.append('"');
                    i++; // 跳过下一个引号
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (c == ',' && !inQuotes) {
                result.add(current.toString());
                current = new StringBuilder();
            } else {
                current.append(c);
            }
        }
        result.add(current.toString());
        
        return result.toArray(new String[0]);
    }

    private TradePosition parseRow(String[] values, Map<String, Integer> columnIndex, Long userId) {
        TradePosition position = new TradePosition();
        position.setUserId(userId);
        position.setSource("BINANCE");

        // symbol
        Integer symbolIdx = columnIndex.get("symbol");
        if (symbolIdx != null && symbolIdx < values.length) {
            position.setSymbol(cleanValue(values[symbolIdx]));
        }

        // Margin Mode
        Integer marginModeIdx = columnIndex.get("Margin Mode");
        if (marginModeIdx != null && marginModeIdx < values.length) {
            position.setMarginMode(cleanValue(values[marginModeIdx]));
        }

        // Position Side
        Integer positionSideIdx = columnIndex.get("Position Side");
        if (positionSideIdx != null && positionSideIdx < values.length) {
            position.setPositionSide(cleanValue(values[positionSideIdx]));
        }

        // Entry Price
        Integer entryPriceIdx = columnIndex.get("Entry Price");
        if (entryPriceIdx != null && entryPriceIdx < values.length) {
            position.setEntryPrice(parseBigDecimal(values[entryPriceIdx]));
        }

        // Avg. Close Price (注意Binance导出可能有拼写错误 Pirce)
        Integer closePriceIdx = columnIndex.get("Avg. Close Pirce");
        if (closePriceIdx == null) {
            closePriceIdx = columnIndex.get("Avg. Close Price");
        }
        if (closePriceIdx != null && closePriceIdx < values.length) {
            position.setClosePrice(parseBigDecimal(values[closePriceIdx]));
        }

        // Max Open Interest
        Integer maxQtyIdx = columnIndex.get("Max Open Interest");
        if (maxQtyIdx != null && maxQtyIdx < values.length) {
            position.setMaxQuantity(parseBigDecimal(values[maxQtyIdx]));
        }

        // Closed Vol.
        Integer closedQtyIdx = columnIndex.get("Closed Vol.");
        if (closedQtyIdx != null && closedQtyIdx < values.length) {
            position.setClosedQuantity(parseBigDecimal(values[closedQtyIdx]));
        }

        // Closing PNL
        Integer pnlIdx = columnIndex.get("Closing PNL");
        if (pnlIdx != null && pnlIdx < values.length) {
            position.setClosingPnl(parseBigDecimal(values[pnlIdx]));
        }

        // Opened
        Integer openedIdx = columnIndex.get("Opened");
        if (openedIdx != null && openedIdx < values.length) {
            position.setOpenTime(parseDateTime(values[openedIdx]));
        }

        // Closed
        Integer closedIdx = columnIndex.get("Closed");
        if (closedIdx != null && closedIdx < values.length) {
            position.setCloseTime(parseDateTime(values[closedIdx]));
        }

        // Status
        Integer statusIdx = columnIndex.get("Status");
        if (statusIdx != null && statusIdx < values.length) {
            position.setStatus(cleanValue(values[statusIdx]));
        }

        return position;
    }

    private String cleanValue(String value) {
        if (value == null) return null;
        return value.trim().replace("\"", "");
    }

    private BigDecimal parseBigDecimal(String value) {
        if (StrUtil.isBlank(value)) return null;
        String cleaned = cleanValue(value);
        if (StrUtil.isBlank(cleaned)) return null;
        try {
            return new BigDecimal(cleaned);
        } catch (Exception e) {
            return null;
        }
    }

    private LocalDateTime parseDateTime(String value) {
        if (StrUtil.isBlank(value)) return null;
        String cleaned = cleanValue(value);
        if (StrUtil.isBlank(cleaned)) return null;
        try {
            // 尝试带毫秒的格式 yyyy-MM-dd HH:mm:ss.SSS
            return LocalDateTime.parse(cleaned, DATE_TIME_FORMATTER);
        } catch (Exception e) {
            try {
                // 尝试不带毫秒 yyyy-MM-dd HH:mm:ss
                return LocalDateTime.parse(cleaned, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            } catch (Exception e2) {
                return null;
            }
        }
    }

    public Map<String, Object> getStatistics(LocalDateTime startTime, LocalDateTime endTime) {
        Long userId = SecurityUtils.getUserId();
        LambdaQueryWrapper<TradePosition> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradePosition::getUserId, userId);
        wrapper.eq(TradePosition::getStatus, "Closed");
        if (startTime != null) wrapper.ge(TradePosition::getOpenTime, startTime);
        if (endTime != null) wrapper.le(TradePosition::getOpenTime, endTime);
        List<TradePosition> positions = tradePositionMapper.selectList(wrapper);

        int totalCount = positions.size();
        int winCount = (int) positions.stream()
                .filter(p -> p.getClosingPnl() != null && p.getClosingPnl().compareTo(BigDecimal.ZERO) > 0)
                .count();
        BigDecimal totalPnl = positions.stream()
                .filter(p -> p.getClosingPnl() != null)
                .map(TradePosition::getClosingPnl)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalProfit = positions.stream()
                .filter(p -> p.getClosingPnl() != null && p.getClosingPnl().compareTo(BigDecimal.ZERO) > 0)
                .map(TradePosition::getClosingPnl)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalLoss = positions.stream()
                .filter(p -> p.getClosingPnl() != null && p.getClosingPnl().compareTo(BigDecimal.ZERO) < 0)
                .map(TradePosition::getClosingPnl)
                .reduce(BigDecimal.ZERO, BigDecimal::add).abs();

        Map<String, Object> result = new HashMap<>();
        result.put("totalCount", totalCount);
        result.put("winCount", winCount);
        result.put("loseCount", totalCount - winCount);
        result.put("winRate", totalCount > 0 ? BigDecimal.valueOf(winCount * 100.0 / totalCount).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO);
        result.put("totalPnl", totalPnl);
        result.put("totalProfit", totalProfit);
        result.put("totalLoss", totalLoss);
        result.put("profitFactor", totalLoss.compareTo(BigDecimal.ZERO) > 0 ? totalProfit.divide(totalLoss, 2, RoundingMode.HALF_UP) : BigDecimal.ZERO);
        return result;
    }

    @Transactional
    public Long generateTradeLog(Long positionId) {
        TradePosition position = tradePositionMapper.selectById(positionId);
        if (position == null) {
            throw new RuntimeException("仓位记录不存在");
        }
        if (position.getTradeLogId() != null) {
            throw new RuntimeException("该仓位已生成交易日志");
        }

        TradeLog tradeLog = new TradeLog();
        tradeLog.setUserId(position.getUserId());
        tradeLog.setSymbol(position.getSymbol());
        // Long -> 1做多, Short -> 2做空
        tradeLog.setDirection("Long".equalsIgnoreCase(position.getPositionSide()) ? 1 : 2);
        tradeLog.setEntryPrice(position.getEntryPrice());
        tradeLog.setEntryTime(position.getOpenTime());
        tradeLog.setExitPrice(position.getClosePrice());
        tradeLog.setExitTime(position.getCloseTime());
        // 仓位大小 = 数量 × 入场价
        if (position.getClosedQuantity() != null && position.getEntryPrice() != null) {
            tradeLog.setPositionSize(position.getClosedQuantity().multiply(position.getEntryPrice()));
        }
        tradeLog.setProfitLoss(position.getClosingPnl());
        // 计算盈亏百分比
        if (position.getEntryPrice() != null && position.getClosePrice() != null 
                && position.getEntryPrice().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal priceDiff = position.getClosePrice().subtract(position.getEntryPrice());
            if ("Short".equalsIgnoreCase(position.getPositionSide())) {
                priceDiff = priceDiff.negate();
            }
            BigDecimal percent = priceDiff.divide(position.getEntryPrice(), 6, RoundingMode.HALF_UP)
                    .multiply(BigDecimal.valueOf(100));
            tradeLog.setProfitLossPercent(percent);
        }
        tradeLog.setStatus(1); // 已平仓
        // 交易日期取开仓时间的日期
        if (position.getOpenTime() != null) {
            tradeLog.setTradeDate(position.getOpenTime().toLocalDate());
        } else {
            tradeLog.setTradeDate(LocalDate.now());
        }

        tradeLogMapper.insert(tradeLog);

        // 更新仓位记录关联
        position.setTradeLogId(tradeLog.getId());
        tradePositionMapper.updateById(position);

        return tradeLog.getId();
    }
}
