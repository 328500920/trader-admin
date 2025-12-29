package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("learn_course")
public class LearnCourse {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String description;
    private String coverImage;
    private Integer stage;
    private Integer sortOrder;
    private Integer status;
    private Long createBy;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableField(exist = false)
    private List<LearnChapter> chapters;
    @TableField(exist = false)
    private Integer chapterCount;
    @TableField(exist = false)
    private Integer completedCount;
}
