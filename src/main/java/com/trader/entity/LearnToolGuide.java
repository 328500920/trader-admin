package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 工具指南实体类
 */
@Data
@TableName("learn_tool_guide")
public class LearnToolGuide {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /** 工具名称 */
    private String toolName;
    
    /** 工具类型：chart图表/exchange交易所/data数据/sentiment情绪/record记录 */
    private String toolType;
    
    /** 工具描述 */
    private String description;
    
    /** 官方网址 */
    private String officialUrl;
    
    /** Logo图片 */
    private String logoUrl;
    
    /** 使用指南(Markdown) */
    private String content;
    
    /** 主要功能JSON数组 */
    private String features;
    
    /** 优点 */
    private String pros;
    
    /** 缺点 */
    private String cons;
    
    /** 价格说明 */
    private String pricing;
    
    /** 上手难度：1简单 2中等 3复杂 */
    private Integer difficulty;
    
    /** 排序 */
    private Integer sortOrder;
    
    /** 状态：0禁用 1启用 */
    private Integer status;
    
    /** 创建人 */
    private Long createBy;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
