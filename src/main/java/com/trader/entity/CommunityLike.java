package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("community_like")
public class CommunityLike {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Integer targetType;
    private Long targetId;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
