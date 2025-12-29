-- 交易心理日记表
USE trader_db;

-- 每日情绪记录表
CREATE TABLE IF NOT EXISTS psychology_daily (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    record_date DATE NOT NULL COMMENT '记录日期',
    
    -- 情绪评分
    mood_score INT NOT NULL COMMENT '整体情绪1-10',
    mood_tags VARCHAR(200) COMMENT '情绪标签(JSON数组)',
    
    -- 身心状态
    sleep_quality TINYINT COMMENT '睡眠质量: 1很差-5很好',
    physical_state TINYINT COMMENT '身体状态: 1疲惫 2一般 3精力充沛',
    external_pressure INT COMMENT '外部压力1-10',
    
    -- 心理陷阱
    traps VARCHAR(200) COMMENT '触发的心理陷阱(JSON数组)',
    
    -- 文字记录
    daily_plan TEXT COMMENT '今日计划',
    daily_reflection TEXT COMMENT '今日反思',
    
    -- 系统字段
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uk_user_date (user_id, record_date),
    INDEX idx_user_id (user_id),
    INDEX idx_record_date (record_date)
) COMMENT '每日情绪记录表';

-- 交易情绪记录表
CREATE TABLE IF NOT EXISTS psychology_trade (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    trade_log_id BIGINT COMMENT '关联交易记录ID',
    record_date DATE NOT NULL COMMENT '记录日期',
    
    -- 情绪评分
    entry_mood INT COMMENT '开仓情绪1-10',
    holding_mood INT COMMENT '持仓情绪1-10',
    exit_mood INT COMMENT '平仓情绪1-10',
    
    -- 心理陷阱
    traps VARCHAR(200) COMMENT '触发的心理陷阱(JSON数组)',
    
    -- 描述
    description TEXT COMMENT '情绪描述',
    
    -- 系统字段
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_trade_log_id (trade_log_id),
    INDEX idx_record_date (record_date)
) COMMENT '交易情绪记录表';
