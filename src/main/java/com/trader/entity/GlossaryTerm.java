package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("glossary_term")
public class GlossaryTerm {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    // 基础信息
    private String name;
    private String nameEn;
    private Long categoryId;
    
    // 内容
    private String brief;
    private String detail;
    private String application;
    private String example;
    
    // 关联
    private String relatedTerms; // JSON数组
    private String relatedChapters; // JSON数组
    
    // 属性
    private Integer difficulty; // 1入门 2进阶 3高级
    private String tags; // JSON数组
    private String pinyin;
    
    // 统计
    private Integer viewCount;
    private Integer favoriteCount;
    
    // 系统字段
    private Integer status;
    private Long createBy;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // 非数据库字段
    @TableField(exist = false)
    private String categoryName;
    @TableField(exist = false)
    private Boolean isFavorite;
}
