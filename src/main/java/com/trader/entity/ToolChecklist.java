package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("tool_checklist")
public class ToolChecklist {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String description;
    private String items;
    private Integer isSystem;
    private Long createBy;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
