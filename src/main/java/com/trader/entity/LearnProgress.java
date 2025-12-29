package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("learn_progress")
public class LearnProgress {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long chapterId;
    private Integer isCompleted;
    private LocalDateTime completeTime;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
