package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("tool_daily_analysis")
public class ToolDailyAnalysis {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private LocalDate analysisDate;
    private String macroEvents;
    private String fedAttitude;
    private String dxyTrend;
    private String stockTrend;
    private String exchangeFlow;
    private String whaleAction;
    private Integer fearGreedIndex;
    private BigDecimal fundingRate;
    private BigDecimal longShortRatio;
    private BigDecimal btcPrice;
    private String weeklyTrend;
    private String dailyTrend;
    private BigDecimal keySupport;
    private BigDecimal keyResistance;
    private Integer overallScore;
    private String marketView;
    private String todayStrategy;
    private String notes;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
