package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_operation_log")
public class SysOperationLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String username;
    private String operationType;
    private String module;
    private String description;
    private String method;
    private String requestUrl;
    private String requestParams;
    private Integer responseCode;
    private String ip;
    private String userAgent;
    private Long executionTime;
    private Integer status;
    private String errorMsg;
    private LocalDateTime createdAt;
}
