package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("trade_image")
public class TradeImage {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long tradeId;
    private String imageUrl;
    private String imageType;
    private String description;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
