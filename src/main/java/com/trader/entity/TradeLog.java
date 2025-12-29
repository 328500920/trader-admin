package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("trade_log")
public class TradeLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private LocalDate tradeDate;
    private String symbol;
    private Integer direction;
    private String strategy;
    private BigDecimal entryPrice;
    private LocalDateTime entryTime;
    private String entryReason;
    private BigDecimal exitPrice;
    private LocalDateTime exitTime;
    private String exitReason;
    private BigDecimal stopLoss;
    private BigDecimal takeProfit;
    private BigDecimal positionSize;
    private BigDecimal profitLoss;
    private BigDecimal profitLossPercent;
    private Integer status;
    private String macroAnalysis;
    private String chainAnalysis;
    private String sentimentAnalysis;
    private String technicalAnalysis;
    private String review;
    private Integer emotionScore;
    private Integer disciplineFollowed;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableField(exist = false)
    private List<TradeImage> images;
}
