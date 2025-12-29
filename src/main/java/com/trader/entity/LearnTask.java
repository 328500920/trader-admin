package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

@Data
@TableName("learn_task")
public class LearnTask {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long chapterId;
    private String taskContent;
    private Integer sortOrder;

    @TableField(exist = false)
    private Boolean isCompleted;
}
