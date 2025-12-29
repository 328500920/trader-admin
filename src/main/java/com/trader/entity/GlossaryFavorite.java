package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("glossary_favorite")
public class GlossaryFavorite {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long termId;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
