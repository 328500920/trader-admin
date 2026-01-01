package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 外部资源实体类
 */
@Data
@TableName("learn_resource")
public class LearnResource {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /** 章节ID */
    private Long chapterId;
    
    /** 资源标题 */
    private String title;
    
    /** 资源类型：video视频/article文章/tool工具/chart图表/book书籍/report报告 */
    private String resourceType;
    
    /** 平台：youtube/bilibili/tradingview/medium等 */
    private String platform;
    
    /** 资源链接 */
    private String url;
    
    /** 资源描述 */
    private String description;
    
    /** 作者/来源 */
    private String author;
    
    /** 语言：zh中文/en英文 */
    private String language;
    
    /** 是否免费：0付费 1免费 */
    private Integer isFree;
    
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
    
    /** 关联的章节信息（非数据库字段） */
    @TableField(exist = false)
    private LearnChapter chapter;
}
