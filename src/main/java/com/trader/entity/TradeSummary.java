package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("trade_summary")
public class TradeSummary {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String summaryMonth;
    private Integer totalTrades;
    private Integer winTrades;
    private Integer loseTrades;
    private BigDecimal winRate;
    private BigDecimal totalProfit;
    private BigDecimal totalLoss;
    private BigDecimal netProfit;
    private BigDecimal profitFactor;
    private BigDecimal maxProfit;
    private BigDecimal maxLoss;
    private BigDecimal maxDrawdown;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
