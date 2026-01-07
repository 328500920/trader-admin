package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("ai_usage_quota")
public class AiUsageQuota {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private LocalDate usageDate;
    private Integer usedCount;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
