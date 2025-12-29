package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("glossary_history")
public class GlossaryHistory {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long termId;
    private LocalDateTime viewTime;
}
