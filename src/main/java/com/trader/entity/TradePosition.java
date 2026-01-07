package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("trade_position")
public class TradePosition {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String symbol;
    private String marginMode;
    private String positionSide;
    private BigDecimal entryPrice;
    private BigDecimal closePrice;
    private BigDecimal maxQuantity;
    private BigDecimal closedQuantity;
    private BigDecimal closingPnl;
    private LocalDateTime openTime;
    private LocalDateTime closeTime;
    private String status;
    private Long tradeLogId;
    private String source;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
