package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("psychology_daily")
public class PsychologyDaily {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private LocalDate recordDate;
    
    // 情绪评分
    private Integer moodScore;
    private String moodTags; // JSON数组
    
    // 身心状态
    private Integer sleepQuality; // 1-5
    private Integer physicalState; // 1-3
    private Integer externalPressure; // 1-10
    
    // 心理陷阱
    private String traps; // JSON数组
    
    // 文字记录
    private String dailyPlan;
    private String dailyReflection;
    
    // 系统字段
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
