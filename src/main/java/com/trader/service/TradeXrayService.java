package com.trader.service;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.BusinessException;
import com.trader.common.PageResult;
import com.trader.entity.*;
import com.trader.mapper.TradePositionMapper;
import com.trader.mapper.TradeRecordMapper;
import com.trader.mapper.TradeXrayReportMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class TradeXrayService {
    
    private final TradeRecordMapper tradeRecordMapper;
    private final TradePositionMapper tradePositionMapper;
    private final TradeXrayReportMapper xrayReportMapper;
    private final AiModelService aiModelService;
    private final AiQuotaService aiQuotaService;

    /**
     * 预览待分析数据
     */
    public Map<String, Object> preview(LocalDate startDate, LocalDate endDate) {
        Long userId = SecurityUtils.getUserId();
        
        // 统计成交记录数
        LambdaQueryWrapper<TradeRecord> tradeWrapper = new LambdaQueryWrapper<>();
        tradeWrapper.eq(TradeRecord::getUserId, userId)
                .ge(TradeRecord::getTradeTime, startDate.atStartOfDay())
                .le(TradeRecord::getTradeTime, endDate.atTime(LocalTime.MAX));
        long tradeCount = tradeRecordMapper.selectCount(tradeWrapper);
        
        // 统计仓位数
        LambdaQueryWrapper<TradePosition> positionWrapper = new LambdaQueryWrapper<>();
        positionWrapper.eq(TradePosition::getUserId, userId)
                .ge(TradePosition::getOpenTime, startDate.atStartOfDay())
                .le(TradePosition::getOpenTime, endDate.atTime(LocalTime.MAX));
        long positionCount = tradePositionMapper.selectCount(positionWrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("tradeCount", tradeCount);
        result.put("positionCount", positionCount);
        result.put("startDate", startDate);
        result.put("endDate", endDate);
        
        return result;
    }

    /**
     * 执行AI分析
     */
    public TradeXrayReport analyze(LocalDate startDate, LocalDate endDate) {
        // 检查配额
        aiQuotaService.checkAndConsume();
        
        Long userId = SecurityUtils.getUserId();
        
        // 获取成交记录
        LambdaQueryWrapper<TradeRecord> tradeWrapper = new LambdaQueryWrapper<>();
        tradeWrapper.eq(TradeRecord::getUserId, userId)
                .ge(TradeRecord::getTradeTime, startDate.atStartOfDay())
                .le(TradeRecord::getTradeTime, endDate.atTime(LocalTime.MAX))
                .orderByAsc(TradeRecord::getTradeTime);
        List<TradeRecord> trades = tradeRecordMapper.selectList(tradeWrapper);
        
        // 获取仓位历史
        LambdaQueryWrapper<TradePosition> positionWrapper = new LambdaQueryWrapper<>();
        positionWrapper.eq(TradePosition::getUserId, userId)
                .ge(TradePosition::getOpenTime, startDate.atStartOfDay())
                .le(TradePosition::getOpenTime, endDate.atTime(LocalTime.MAX))
                .orderByAsc(TradePosition::getOpenTime);
        List<TradePosition> positions = tradePositionMapper.selectList(positionWrapper);
        
        if (trades.isEmpty() && positions.isEmpty()) {
            throw new BusinessException("所选时间范围内没有交易数据");
        }
        
        // 构建Prompt
        String prompt = buildPrompt(startDate, endDate, trades, positions);
        
        // 调用AI
        SysAiModel activeModel = aiModelService.getActiveModel();
        String aiResponse = aiModelService.chat(prompt);
        
        // 解析AI响应
        TradeXrayReport report = parseAiResponse(aiResponse);
        report.setUserId(userId);
        report.setModelId(activeModel.getId());
        report.setModelName(activeModel.getName());
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        report.setTradeCount(trades.size());
        report.setPositionCount(positions.size());
        report.setFullReport(aiResponse);
        
        // 保存报告
        xrayReportMapper.insert(report);
        
        return report;
    }

    /**
     * 获取历史报告列表
     */
    public PageResult<TradeXrayReport> listReports(int pageNum, int pageSize) {
        Long userId = SecurityUtils.getUserId();
        
        Page<TradeXrayReport> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<TradeXrayReport> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TradeXrayReport::getUserId, userId)
                .orderByDesc(TradeXrayReport::getCreateTime);
        
        Page<TradeXrayReport> result = xrayReportMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    /**
     * 获取报告详情
     */
    public TradeXrayReport getReport(Long id) {
        Long userId = SecurityUtils.getUserId();
        
        TradeXrayReport report = xrayReportMapper.selectById(id);
        if (report == null || !report.getUserId().equals(userId)) {
            throw new BusinessException("报告不存在");
        }
        
        return report;
    }

    /**
     * 构建AI Prompt
     */
    private String buildPrompt(LocalDate startDate, LocalDate endDate, 
                               List<TradeRecord> trades, List<TradePosition> positions) {
        StringBuilder sb = new StringBuilder();
        
        sb.append("请根据以下交易数据进行深度分析：\n\n");
        sb.append("## 交易数据概览\n");
        sb.append("- 分析周期：").append(startDate).append(" 至 ").append(endDate).append("\n");
        sb.append("- 成交记录：").append(trades.size()).append(" 笔\n");
        sb.append("- 仓位数量：").append(positions.size()).append(" 个\n\n");
        
        // 成交记录摘要
        if (!trades.isEmpty()) {
            sb.append("## 成交记录明细\n");
            sb.append("| 时间 | 交易对 | 方向 | 价格 | 数量 | 手续费 |\n");
            sb.append("|------|--------|------|------|------|--------|\n");
            
            int count = 0;
            for (TradeRecord trade : trades) {
                if (count++ >= 50) {
                    sb.append("| ... | 更多").append(trades.size() - 50).append("条记录省略 | ... | ... | ... | ... |\n");
                    break;
                }
                sb.append("| ").append(trade.getTradeTime())
                  .append(" | ").append(trade.getSymbol())
                  .append(" | ").append(trade.getDirection())
                  .append(" | ").append(trade.getPrice())
                  .append(" | ").append(trade.getQuantity())
                  .append(" | ").append(trade.getFee())
                  .append(" |\n");
            }
            sb.append("\n");
        }
        
        // 仓位历史摘要
        if (!positions.isEmpty()) {
            sb.append("## 仓位历史明细\n");
            sb.append("| 开仓时间 | 交易对 | 方向 | 开仓价 | 平仓价 | 盈亏 |\n");
            sb.append("|----------|--------|------|--------|--------|------|\n");
            
            int count = 0;
            for (TradePosition pos : positions) {
                if (count++ >= 50) {
                    sb.append("| ... | 更多").append(positions.size() - 50).append("条记录省略 | ... | ... | ... | ... |\n");
                    break;
                }
                sb.append("| ").append(pos.getOpenTime())
                  .append(" | ").append(pos.getSymbol())
                  .append(" | ").append(pos.getPositionSide())
                  .append(" | ").append(pos.getEntryPrice())
                  .append(" | ").append(pos.getClosePrice() != null ? pos.getClosePrice() : "持仓中")
                  .append(" | ").append(pos.getClosingPnl() != null ? pos.getClosingPnl() : "-")
                  .append(" |\n");
            }
            sb.append("\n");
        }
        
        sb.append("## 分析要求\n");
        sb.append("请从以下维度进行分析，并给出评分和建议：\n");
        sb.append("1. **胜率分析**：计算胜率，分析连胜/连亏情况\n");
        sb.append("2. **盈亏比分析**：计算平均盈亏比，评估风险收益\n");
        sb.append("3. **风控评估**：分析止损执行情况，最大回撤\n");
        sb.append("4. **交易纪律**：是否存在冲动交易、过度交易\n");
        sb.append("5. **时间分析**：不同时段的交易表现\n");
        sb.append("6. **行为模式**：识别交易习惯和潜在问题\n\n");
        
        sb.append("请按以下JSON格式输出分析结果（只输出JSON，不要其他内容）：\n");
        sb.append("```json\n");
        sb.append("{\n");
        sb.append("  \"totalScore\": 75,\n");
        sb.append("  \"winRate\": 65.5,\n");
        sb.append("  \"profitLossRatio\": 1.8,\n");
        sb.append("  \"riskScore\": \"B+\",\n");
        sb.append("  \"disciplineScore\": \"A-\",\n");
        sb.append("  \"strengths\": [\"优势1\", \"优势2\"],\n");
        sb.append("  \"problems\": [\"问题1\", \"问题2\"],\n");
        sb.append("  \"suggestions\": [\"建议1\", \"建议2\", \"建议3\"],\n");
        sb.append("  \"summary\": \"总结性评价...\"\n");
        sb.append("}\n");
        sb.append("```\n");
        
        return sb.toString();
    }

    /**
     * 解析AI响应
     */
    private TradeXrayReport parseAiResponse(String response) {
        TradeXrayReport report = new TradeXrayReport();
        
        try {
            // 提取JSON部分
            String json = response;
            if (response.contains("```json")) {
                int start = response.indexOf("```json") + 7;
                int end = response.indexOf("```", start);
                if (end > start) {
                    json = response.substring(start, end).trim();
                }
            } else if (response.contains("```")) {
                int start = response.indexOf("```") + 3;
                int end = response.indexOf("```", start);
                if (end > start) {
                    json = response.substring(start, end).trim();
                }
            }
            
            JSONObject obj = JSONUtil.parseObj(json);
            
            report.setTotalScore(obj.getInt("totalScore", 0));
            report.setWinRate(obj.getBigDecimal("winRate"));
            report.setProfitLossRatio(obj.getBigDecimal("profitLossRatio"));
            report.setRiskScore(obj.getStr("riskScore"));
            report.setDisciplineScore(obj.getStr("disciplineScore"));
            
            JSONArray strengths = obj.getJSONArray("strengths");
            if (strengths != null) {
                report.setStrengths(strengths.toString());
            }
            
            JSONArray problems = obj.getJSONArray("problems");
            if (problems != null) {
                report.setProblems(problems.toString());
            }
            
            JSONArray suggestions = obj.getJSONArray("suggestions");
            if (suggestions != null) {
                report.setSuggestions(suggestions.toString());
            }
            
        } catch (Exception e) {
            log.warn("解析AI响应失败，使用原始响应", e);
            report.setTotalScore(0);
        }
        
        return report;
    }
}
