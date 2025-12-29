package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("trade_plan")
public class TradePlan {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    
    // 基础信息
    private String symbol;
    private Integer direction; // 1做多 2做空
    private LocalDateTime planTime;
    
    // 价格设置
    private BigDecimal entryPrice;
    private BigDecimal stopLossPrice;
    @TableField("take_profit_1")
    private BigDecimal takeProfit1;
    @TableField("take_profit_2")
    private BigDecimal takeProfit2;
    @TableField("take_profit_3")
    private BigDecimal takeProfit3;
    
    // 仓位管理
    private BigDecimal positionRatio;
    private Integer leverage;
    private BigDecimal riskAmount;
    
    // 交易逻辑
    private String entryReasons; // JSON数组
    private String technicalSignals; // JSON数组
    private Integer marketTrend; // 1上涨 2震荡 3下跌
    private Integer confidence; // 1-10
    private String remark;
    
    // 状态
    private Integer status; // 1待执行 2已执行 3已取消 4已过期
    private LocalDateTime executeTime;
    private Long tradeLogId;
    
    // 系统字段
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // 计算字段（非数据库字段）
    @TableField(exist = false)
    private BigDecimal stopLossPercent; // 止损幅度%
    @TableField(exist = false)
    private BigDecimal riskRewardRatio1; // 盈亏比1
    @TableField(exist = false)
    private BigDecimal riskRewardRatio2; // 盈亏比2
    @TableField(exist = false)
    private BigDecimal riskRewardRatio3; // 盈亏比3
}
