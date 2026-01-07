package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("learn_video_progress")
public class LearnVideoProgress {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long videoId;
    private Integer progress;
    private Integer isCompleted;
    private Integer watchCount;
    private LocalDateTime lastWatchTime;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
