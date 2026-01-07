package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("learn_video_course")
public class LearnVideoCourse {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String description;
    private String coverUrl;
    private String videoUrl;
    private Integer duration;
    private Long fileSize;
    private String category;
    private String tags;
    private Integer sortOrder;
    private Integer status;
    private Integer viewCount;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // 非数据库字段
    @TableField(exist = false)
    private Integer userProgress; // 用户观看进度
    @TableField(exist = false)
    private Boolean isCompleted; // 用户是否看完
}
