package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.TradeRecord;
import com.trader.mapper.TradeRecordMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import cn.hutool.core.util.StrUtil;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class TradeRecordService {
    private final TradeRecordMapper tradeRecordMapper;
    
    private static final DateTimeFormatter UTC_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public PageResult<TradeRecord> list(int pageNum, int pageSize, String symbol, 
            String direction, LocalDateTime startTime, LocalDateTime endTime) {
        Long userId = SecurityUtils.getUserId();
        Page<TradeRecord> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<TradeRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradeRecord::getUserId, userId);
        if (StrUtil.isNotBlank(symbol)) wrapper.like(TradeRecord::getSymbol, symbol);
        if (StrUtil.isNotBlank(direction)) wrapper.eq(TradeRecord::getDirection, direction);
        if (startTime != null) wrapper.ge(TradeRecord::getTradeTime, startTime);
        if (endTime != null) wrapper.le(TradeRecord::getTradeTime, endTime);
        wrapper.orderByDesc(TradeRecord::getTradeTime);
        Page<TradeRecord> result = tradeRecordMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    public TradeRecord getById(Long id) {
        return tradeRecordMapper.selectById(id);
    }

    public void delete(Long id) {
        tradeRecordMapper.deleteById(id);
    }

    public Map<String, Object> importFromExcel(MultipartFile file) throws Exception {
        Long userId = SecurityUtils.getUserId();
        List<TradeRecord> records = new ArrayList<>();
        int successCount = 0;
        int failCount = 0;
        List<String> errors = new ArrayList<>();

        try (Workbook workbook = new XSSFWorkbook(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            Row headerRow = sheet.getRow(0);
            
            // 解析表头，获取列索引
            Map<String, Integer> columnIndex = new HashMap<>();
            for (int i = 0; i < headerRow.getLastCellNum(); i++) {
                Cell cell = headerRow.getCell(i);
                if (cell != null) {
                    String header = getCellStringValue(cell).trim();
                    columnIndex.put(header, i);
                }
            }

            // 从第二行开始读取数据
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                try {
                    TradeRecord record = parseRow(row, columnIndex, userId);
                    if (record != null) {
                        records.add(record);
                        successCount++;
                    }
                } catch (Exception e) {
                    failCount++;
                    errors.add("第" + (i + 1) + "行: " + e.getMessage());
                }
            }
        }

        // 批量插入
        for (TradeRecord record : records) {
            tradeRecordMapper.insert(record);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("successCount", successCount);
        result.put("failCount", failCount);
        result.put("errors", errors.size() > 10 ? errors.subList(0, 10) : errors);
        return result;
    }

    private TradeRecord parseRow(Row row, Map<String, Integer> columnIndex, Long userId) {
        TradeRecord record = new TradeRecord();
        record.setUserId(userId);
        record.setSource("BINANCE");

        // 时间(UTC) - 转换为北京时间 +8小时
        Integer timeIdx = columnIndex.get("时间(UTC)");
        if (timeIdx != null) {
            String timeStr = getCellStringValue(row.getCell(timeIdx));
            if (StrUtil.isNotBlank(timeStr)) {
                LocalDateTime utcTime = LocalDateTime.parse(timeStr, UTC_FORMATTER);
                record.setTradeTime(utcTime.plusHours(8)); // UTC转北京时间
            }
        }

        // 合约
        Integer symbolIdx = columnIndex.get("合约");
        if (symbolIdx != null) {
            record.setSymbol(getCellStringValue(row.getCell(symbolIdx)));
        }

        // 方向
        Integer directionIdx = columnIndex.get("方向");
        if (directionIdx != null) {
            record.setDirection(getCellStringValue(row.getCell(directionIdx)));
        }

        // 价格
        Integer priceIdx = columnIndex.get("价格");
        if (priceIdx != null) {
            record.setPrice(getCellBigDecimalValue(row.getCell(priceIdx)));
        }

        // 数量
        Integer quantityIdx = columnIndex.get("数量");
        if (quantityIdx != null) {
            record.setQuantity(getCellBigDecimalValue(row.getCell(quantityIdx)));
        }

        // 成交额
        Integer amountIdx = columnIndex.get("成交额");
        if (amountIdx != null) {
            record.setAmount(getCellBigDecimalValue(row.getCell(amountIdx)));
        }

        // 手续费
        Integer feeIdx = columnIndex.get("手续费");
        if (feeIdx != null) {
            record.setFee(getCellBigDecimalValue(row.getCell(feeIdx)));
        }

        // 手续费结算币种
        Integer feeCurrencyIdx = columnIndex.get("手续费结算币种");
        if (feeCurrencyIdx != null) {
            record.setFeeCurrency(getCellStringValue(row.getCell(feeCurrencyIdx)));
        }

        // 已实现盈亏
        Integer pnlIdx = columnIndex.get("已实现盈亏");
        if (pnlIdx != null) {
            record.setRealizedPnl(getCellBigDecimalValue(row.getCell(pnlIdx)));
        }

        // 计价资产
        Integer quoteIdx = columnIndex.get("计价资产");
        if (quoteIdx != null) {
            record.setQuoteAsset(getCellStringValue(row.getCell(quoteIdx)));
        }

        return record;
    }

    private String getCellStringValue(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getLocalDateTimeCellValue().format(UTC_FORMATTER);
                }
                return BigDecimal.valueOf(cell.getNumericCellValue()).toPlainString();
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }

    private BigDecimal getCellBigDecimalValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case NUMERIC:
                return BigDecimal.valueOf(cell.getNumericCellValue());
            case STRING:
                String str = cell.getStringCellValue().trim();
                if (StrUtil.isBlank(str)) return null;
                return new BigDecimal(str);
            default:
                return null;
        }
    }

    public Map<String, Object> getStatistics(LocalDateTime startTime, LocalDateTime endTime) {
        Long userId = SecurityUtils.getUserId();
        LambdaQueryWrapper<TradeRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradeRecord::getUserId, userId);
        if (startTime != null) wrapper.ge(TradeRecord::getTradeTime, startTime);
        if (endTime != null) wrapper.le(TradeRecord::getTradeTime, endTime);
        List<TradeRecord> records = tradeRecordMapper.selectList(wrapper);

        int totalCount = records.size();
        BigDecimal totalPnl = records.stream()
                .filter(r -> r.getRealizedPnl() != null)
                .map(TradeRecord::getRealizedPnl)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalFee = records.stream()
                .filter(r -> r.getFee() != null)
                .map(TradeRecord::getFee)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalAmount = records.stream()
                .filter(r -> r.getAmount() != null)
                .map(TradeRecord::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        Map<String, Object> result = new HashMap<>();
        result.put("totalCount", totalCount);
        result.put("totalPnl", totalPnl);
        result.put("totalFee", totalFee);
        result.put("totalAmount", totalAmount);
        result.put("netPnl", totalPnl.subtract(totalFee));
        return result;
    }
}
