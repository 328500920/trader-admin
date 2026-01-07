package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("sys_ai_model")
public class SysAiModel {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String provider;
    private String model;
    private String apiUrl;
    private String apiKey;
    private Integer maxTokens;
    private BigDecimal temperature;
    private Integer isActive;
    private Integer sortOrder;
    private String remark;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
