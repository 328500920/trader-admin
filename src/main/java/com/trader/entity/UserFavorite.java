package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户收藏实体
 */
@Data
@TableName("user_favorite")
public class UserFavorite {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 收藏类型: case/resource/topic/quiz/tool
     */
    private String targetType;
    
    /**
     * 收藏目标ID
     */
    private Long targetId;
    
    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    /**
     * 收藏目标详情（非数据库字段）
     */
    @TableField(exist = false)
    private Object targetDetail;
}
