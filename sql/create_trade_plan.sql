-- 交易计划表
USE trader_db;

CREATE TABLE IF NOT EXISTS trade_plan (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    
    -- 基础信息
    symbol VARCHAR(32) NOT NULL COMMENT '交易对',
    direction TINYINT NOT NULL COMMENT '方向: 1做多 2做空',
    plan_time DATETIME COMMENT '计划执行时间',
    
    -- 价格设置
    entry_price DECIMAL(20,8) NOT NULL COMMENT '入场价格',
    stop_loss_price DECIMAL(20,8) NOT NULL COMMENT '止损价格',
    take_profit_1 DECIMAL(20,8) COMMENT '止盈目标1',
    take_profit_2 DECIMAL(20,8) COMMENT '止盈目标2',
    take_profit_3 DECIMAL(20,8) COMMENT '止盈目标3',
    
    -- 仓位管理
    position_ratio DECIMAL(5,2) COMMENT '仓位比例%',
    leverage INT DEFAULT 1 COMMENT '杠杆倍数',
    risk_amount DECIMAL(20,8) COMMENT '风险金额',
    
    -- 交易逻辑
    entry_reasons VARCHAR(500) COMMENT '入场理由(JSON数组)',
    technical_signals VARCHAR(500) COMMENT '技术信号(JSON数组)',
    market_trend TINYINT COMMENT '市场趋势: 1上涨 2震荡 3下跌',
    confidence INT COMMENT '信心指数1-10',
    remark TEXT COMMENT '备注',
    
    -- 状态
    status TINYINT DEFAULT 1 COMMENT '状态: 1待执行 2已执行 3已取消 4已过期',
    execute_time DATETIME COMMENT '实际执行时间',
    trade_log_id BIGINT COMMENT '关联交易记录ID',
    
    -- 系统字段
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_plan_time (plan_time)
) COMMENT '交易计划表';
