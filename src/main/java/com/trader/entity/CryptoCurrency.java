package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("crypto_currency")
public class CryptoCurrency {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String code;
    private String name;
    private String nameCn;
    private String logo;
    private Integer sortOrder;
    private Integer status;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
