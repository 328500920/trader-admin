package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("learn_material")
public class LearnMaterial {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long chapterId;
    private String title;
    private String description;
    private String materialType; // markdown/pdf/video/link
    private String content;
    private String fileUrl;
    private String linkUrl;
    private Integer sortOrder;
    private Integer status;
    private Long createBy;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
