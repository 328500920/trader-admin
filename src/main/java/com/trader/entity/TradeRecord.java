package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("trade_record")
public class TradeRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private LocalDateTime tradeTime;
    private String symbol;
    private String direction;
    private BigDecimal price;
    private BigDecimal quantity;
    private BigDecimal amount;
    private BigDecimal fee;
    private String feeCurrency;
    private BigDecimal realizedPnl;
    private String quoteAsset;
    private String source;
    private Long tradeLogId;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
