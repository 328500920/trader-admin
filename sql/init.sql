-- 交易员成长平台数据库初始化脚本
-- MySQL 5.7

CREATE DATABASE IF NOT EXISTS trader_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE trader_db;

-- 用户表
CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    nickname VARCHAR(50) COMMENT '昵称',
    avatar VARCHAR(255) COMMENT '头像URL',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    status TINYINT DEFAULT 1 COMMENT '状态：0禁用 1启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    last_login_time DATETIME COMMENT '最后登录时间',
    INDEX idx_username (username),
    INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 角色表
CREATE TABLE sys_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(255) COMMENT '描述',
    status TINYINT DEFAULT 1 COMMENT '状态：0禁用 1启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 课程表
CREATE TABLE learn_course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '课程ID',
    title VARCHAR(100) NOT NULL COMMENT '课程标题',
    description TEXT COMMENT '课程描述',
    cover_image VARCHAR(255) COMMENT '封面图片',
    stage INT NOT NULL COMMENT '阶段：1/2/3',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态：0草稿 1发布',
    create_by BIGINT COMMENT '创建人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_stage (stage)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- 章节表
CREATE TABLE learn_chapter (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '章节ID',
    course_id BIGINT NOT NULL COMMENT '课程ID',
    title VARCHAR(100) NOT NULL COMMENT '章节标题',
    content LONGTEXT COMMENT '章节内容（Markdown）',
    week_number INT COMMENT '周数',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_course_id (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='章节表';

-- 学习任务表
CREATE TABLE learn_task (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
    chapter_id BIGINT NOT NULL COMMENT '章节ID',
    task_content VARCHAR(500) NOT NULL COMMENT '任务内容',
    sort_order INT DEFAULT 0 COMMENT '排序',
    INDEX idx_chapter_id (chapter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习任务表';

-- 学习进度表
CREATE TABLE learn_progress (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    chapter_id BIGINT NOT NULL COMMENT '章节ID',
    is_completed TINYINT DEFAULT 0 COMMENT '是否完成',
    complete_time DATETIME COMMENT '完成时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_chapter (user_id, chapter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习进度表';

-- 任务完成记录表
CREATE TABLE learn_task_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    task_id BIGINT NOT NULL COMMENT '任务ID',
    is_completed TINYINT DEFAULT 0 COMMENT '是否完成',
    complete_time DATETIME COMMENT '完成时间',
    UNIQUE KEY uk_user_task (user_id, task_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='任务完成记录表';

-- 学习笔记表
CREATE TABLE learn_note (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '笔记ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    chapter_id BIGINT COMMENT '关联章节ID',
    title VARCHAR(100) COMMENT '笔记标题',
    content LONGTEXT COMMENT '笔记内容',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习笔记表';

-- 交易日志表
CREATE TABLE trade_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '交易ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    trade_date DATE NOT NULL COMMENT '交易日期',
    symbol VARCHAR(20) NOT NULL COMMENT '交易品种',
    direction TINYINT NOT NULL COMMENT '方向：1做多 2做空',
    strategy VARCHAR(50) COMMENT '使用策略',
    entry_price DECIMAL(20,8) NOT NULL COMMENT '入场价格',
    entry_time DATETIME COMMENT '入场时间',
    entry_reason TEXT COMMENT '入场理由',
    exit_price DECIMAL(20,8) COMMENT '出场价格',
    exit_time DATETIME COMMENT '出场时间',
    exit_reason VARCHAR(50) COMMENT '出场原因',
    stop_loss DECIMAL(20,8) COMMENT '止损价',
    take_profit DECIMAL(20,8) COMMENT '止盈价',
    position_size DECIMAL(20,8) COMMENT '仓位大小',
    profit_loss DECIMAL(20,8) COMMENT '盈亏金额',
    profit_loss_percent DECIMAL(10,4) COMMENT '盈亏百分比',
    status TINYINT DEFAULT 0 COMMENT '状态：0持仓中 1已平仓',
    macro_analysis TEXT COMMENT '宏观分析',
    chain_analysis TEXT COMMENT '链上分析',
    sentiment_analysis TEXT COMMENT '情绪分析',
    technical_analysis TEXT COMMENT '技术分析',
    review TEXT COMMENT '交易复盘',
    emotion_score INT COMMENT '情绪评分',
    discipline_followed TINYINT COMMENT '是否遵守纪律',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_trade_date (trade_date),
    INDEX idx_symbol (symbol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='交易日志表';

-- 交易截图表
CREATE TABLE trade_image (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    trade_id BIGINT NOT NULL COMMENT '交易ID',
    image_url VARCHAR(255) NOT NULL COMMENT '图片URL',
    image_type VARCHAR(20) COMMENT '图片类型',
    description VARCHAR(255) COMMENT '图片描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_trade_id (trade_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='交易截图表';

-- 绩效汇总表
CREATE TABLE trade_summary (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    summary_month VARCHAR(7) NOT NULL COMMENT '统计月份',
    total_trades INT DEFAULT 0 COMMENT '总交易次数',
    win_trades INT DEFAULT 0 COMMENT '盈利次数',
    lose_trades INT DEFAULT 0 COMMENT '亏损次数',
    win_rate DECIMAL(5,2) COMMENT '胜率',
    total_profit DECIMAL(20,8) DEFAULT 0 COMMENT '总盈利',
    total_loss DECIMAL(20,8) DEFAULT 0 COMMENT '总亏损',
    net_profit DECIMAL(20,8) DEFAULT 0 COMMENT '净盈亏',
    profit_factor DECIMAL(10,4) COMMENT '盈亏比',
    max_profit DECIMAL(20,8) COMMENT '最大单笔盈利',
    max_loss DECIMAL(20,8) COMMENT '最大单笔亏损',
    max_drawdown DECIMAL(10,4) COMMENT '最大回撤',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_user_month (user_id, summary_month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='绩效汇总表';

-- 帖子表
CREATE TABLE community_post (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '帖子ID',
    user_id BIGINT NOT NULL COMMENT '作者ID',
    title VARCHAR(200) NOT NULL COMMENT '标题',
    content LONGTEXT NOT NULL COMMENT '内容',
    category VARCHAR(50) COMMENT '分类',
    view_count INT DEFAULT 0 COMMENT '浏览量',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    comment_count INT DEFAULT 0 COMMENT '评论数',
    is_top TINYINT DEFAULT 0 COMMENT '是否置顶',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_category (category),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='帖子表';

-- 评论表
CREATE TABLE community_comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论ID',
    post_id BIGINT NOT NULL COMMENT '帖子ID',
    user_id BIGINT NOT NULL COMMENT '评论者ID',
    parent_id BIGINT DEFAULT 0 COMMENT '父评论ID',
    content TEXT NOT NULL COMMENT '评论内容',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_post_id (post_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- 点赞表
CREATE TABLE community_like (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    target_type TINYINT NOT NULL COMMENT '目标类型：1帖子 2评论',
    target_id BIGINT NOT NULL COMMENT '目标ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_target (user_id, target_type, target_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点赞表';

-- 检查清单模板表
CREATE TABLE tool_checklist (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    name VARCHAR(100) NOT NULL COMMENT '清单名称',
    description VARCHAR(255) COMMENT '描述',
    items TEXT COMMENT '清单项JSON',
    is_system TINYINT DEFAULT 0 COMMENT '是否系统预设',
    create_by BIGINT COMMENT '创建人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检查清单模板表';

-- 常用链接表
CREATE TABLE tool_link (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    name VARCHAR(100) NOT NULL COMMENT '链接名称',
    url VARCHAR(500) NOT NULL COMMENT '链接地址',
    icon VARCHAR(100) COMMENT '图标',
    category VARCHAR(50) COMMENT '分类',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='常用链接表';

-- 学习资料表
CREATE TABLE learn_material (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '资料ID',
    chapter_id BIGINT NOT NULL COMMENT '章节ID',
    title VARCHAR(200) NOT NULL COMMENT '资料标题',
    description VARCHAR(500) COMMENT '资料描述',
    material_type VARCHAR(20) NOT NULL COMMENT '资料类型：markdown/pdf/video/link',
    content LONGTEXT COMMENT '资料内容（markdown类型）',
    file_url VARCHAR(500) COMMENT '文件URL（pdf/video类型）',
    link_url VARCHAR(500) COMMENT '外部链接（link类型）',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态：0禁用 1启用',
    create_by BIGINT COMMENT '创建人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_chapter_id (chapter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习资料表';

-- 每日分析记录表
CREATE TABLE tool_daily_analysis (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    analysis_date DATE NOT NULL COMMENT '分析日期',
    macro_events TEXT COMMENT '今日重要事件',
    fed_attitude VARCHAR(20) COMMENT '美联储态度',
    dxy_trend VARCHAR(20) COMMENT 'DXY趋势',
    stock_trend VARCHAR(20) COMMENT '美股走势',
    exchange_flow VARCHAR(20) COMMENT '交易所流向',
    whale_action VARCHAR(50) COMMENT '巨鲸动向',
    fear_greed_index INT COMMENT '恐惧贪婪指数',
    funding_rate DECIMAL(10,4) COMMENT '资金费率',
    long_short_ratio DECIMAL(10,4) COMMENT '多空比',
    btc_price DECIMAL(20,8) COMMENT 'BTC价格',
    weekly_trend VARCHAR(20) COMMENT '周线趋势',
    daily_trend VARCHAR(20) COMMENT '日线趋势',
    key_support DECIMAL(20,8) COMMENT '关键支撑',
    key_resistance DECIMAL(20,8) COMMENT '关键阻力',
    overall_score INT COMMENT '综合评分',
    market_view VARCHAR(50) COMMENT '市场观点',
    today_strategy VARCHAR(50) COMMENT '今日策略',
    notes TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_date (user_id, analysis_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='每日分析记录表';

-- 初始化数据
INSERT INTO sys_role (role_name, role_code, description) VALUES 
('管理员', 'admin', '系统管理员'),
('普通用户', 'user', '普通用户');

-- 默认管理员账号 admin/admin123 (BCrypt加密)
INSERT INTO sys_user (username, password, nickname, role_id, status) VALUES 
('admin', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '管理员', 1, 1);

-- 普通用户 subt/2025#Subt (BCrypt加密)
INSERT INTO sys_user (username, password, nickname, role_id, status) VALUES 
('subt', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQKRZf5xYpUI9Yjl8Aq3YHJqC5Gy', 'Subt', 2, 1);

-- 系统预设检查清单
INSERT INTO tool_checklist (name, description, items, is_system) VALUES 
('交易前检查清单', '每次交易前必须检查的事项', '[{"text":"是否符合交易计划？","checked":false},{"text":"止损位是否设置？","checked":false},{"text":"仓位是否合理（<5%）？","checked":false},{"text":"情绪是否稳定？","checked":false},{"text":"是否有重大消息面？","checked":false},{"text":"技术面是否支持？","checked":false}]', 1);

-- 常用链接
INSERT INTO tool_link (name, url, category, sort_order) VALUES 
('Binance', 'https://www.binance.com', '交易所', 1),
('TradingView', 'https://www.tradingview.com', '图表工具', 2),
('CoinGlass', 'https://www.coinglass.com', '数据分析', 3),
('Fear & Greed Index', 'https://alternative.me/crypto/fear-and-greed-index/', '市场情绪', 4),
('Glassnode', 'https://glassnode.com', '链上数据', 5),
('CoinMarketCap', 'https://coinmarketcap.com', '行情数据', 6);
