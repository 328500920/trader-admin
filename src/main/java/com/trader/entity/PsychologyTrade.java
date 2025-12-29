package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("psychology_trade")
public class PsychologyTrade {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long tradeLogId;
    private LocalDate recordDate;
    
    // 情绪评分
    private Integer entryMood; // 1-10
    private Integer holdingMood; // 1-10
    private Integer exitMood; // 1-10
    
    // 心理陷阱
    private String traps; // JSON数组
    
    // 描述
    private String description;
    
    // 系统字段
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
