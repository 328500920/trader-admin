package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 专题内容实体类
 */
@Data
@TableName("learn_topic")
public class LearnTopic {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /** 专题标题 */
    private String title;
    
    /** 副标题 */
    private String subtitle;
    
    /** 专题描述 */
    private String description;
    
    /** 封面图片 */
    private String coverImage;
    
    /** 专题内容(Markdown) */
    private String content;
    
    /** 专题类型：supplement补充/advanced进阶/special专题 */
    private String topicType;
    
    /** 关联周数(可选) */
    private Integer relatedWeek;
    
    /** 难度：1入门 2进阶 3高级 */
    private Integer difficulty;
    
    /** 预计学习时间(分钟) */
    private Integer estimatedTime;
    
    /** 排序 */
    private Integer sortOrder;
    
    /** 状态：0草稿 1发布 */
    private Integer status;
    
    /** 创建人 */
    private Long createBy;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
