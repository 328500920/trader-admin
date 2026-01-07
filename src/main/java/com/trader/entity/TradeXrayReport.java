package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("trade_xray_report")
public class TradeXrayReport {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long modelId;
    private String modelName;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer tradeCount;
    private Integer positionCount;
    private Integer totalScore;
    private BigDecimal winRate;
    private BigDecimal profitLossRatio;
    private String riskScore;
    private String disciplineScore;
    private String strengths;
    private String problems;
    private String suggestions;
    private String fullReport;
    private String statistics;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
