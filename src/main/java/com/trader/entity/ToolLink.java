package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

@Data
@TableName("tool_link")
public class ToolLink {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String url;
    private String icon;
    private String category;
    private Integer sortOrder;
    private Integer status;
}
