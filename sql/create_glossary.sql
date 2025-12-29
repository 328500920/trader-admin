-- 交易术语词典表
USE trader_db;

-- 术语分类表
CREATE TABLE IF NOT EXISTS glossary_category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    icon VARCHAR(50) COMMENT '图标',
    parent_id BIGINT DEFAULT 0 COMMENT '父分类ID',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态: 1启用 0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_parent_id (parent_id)
) COMMENT '术语分类表';

-- 术语表
CREATE TABLE IF NOT EXISTS glossary_term (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    
    -- 基础信息
    name VARCHAR(100) NOT NULL COMMENT '术语名称',
    name_en VARCHAR(100) COMMENT '英文名称',
    category_id BIGINT NOT NULL COMMENT '分类ID',
    
    -- 内容
    brief TEXT NOT NULL COMMENT '简短定义',
    detail TEXT COMMENT '详细解释(Markdown)',
    application TEXT COMMENT '应用场景(Markdown)',
    example TEXT COMMENT '示例(Markdown)',
    
    -- 关联
    related_terms VARCHAR(500) COMMENT '相关术语ID(JSON数组)',
    related_chapters VARCHAR(500) COMMENT '关联课程章节ID(JSON数组)',
    
    -- 属性
    difficulty TINYINT DEFAULT 1 COMMENT '难度: 1入门 2进阶 3高级',
    tags VARCHAR(200) COMMENT '标签(JSON数组)',
    pinyin VARCHAR(200) COMMENT '拼音(用于搜索)',
    
    -- 统计
    view_count INT DEFAULT 0 COMMENT '查看次数',
    favorite_count INT DEFAULT 0 COMMENT '收藏次数',
    
    -- 系统字段
    status TINYINT DEFAULT 1 COMMENT '状态: 1启用 0禁用',
    create_by BIGINT COMMENT '创建人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_category_id (category_id),
    INDEX idx_difficulty (difficulty),
    INDEX idx_name (name)
) COMMENT '术语表';

-- 用户收藏表
CREATE TABLE IF NOT EXISTS glossary_favorite (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    term_id BIGINT NOT NULL COMMENT '术语ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE KEY uk_user_term (user_id, term_id),
    INDEX idx_user_id (user_id)
) COMMENT '术语收藏表';

-- 查看历史表
CREATE TABLE IF NOT EXISTS glossary_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    term_id BIGINT NOT NULL COMMENT '术语ID',
    view_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '查看时间',
    
    INDEX idx_user_id (user_id),
    INDEX idx_view_time (view_time)
) COMMENT '术语查看历史表';

-- 初始化分类数据
INSERT INTO glossary_category (name, icon, parent_id, sort_order) VALUES
('技术分析', 'TrendCharts', 0, 1),
('交易操作', 'Operation', 0, 2),
('市场数据', 'DataLine', 0, 3),
('链上数据', 'Link', 0, 4),
('基本面', 'Document', 0, 5),
('交易心理', 'Memo', 0, 6);

-- 初始化术语数据
INSERT INTO glossary_term (name, name_en, category_id, brief, detail, application, example, difficulty, tags, pinyin) VALUES
('OI', 'Open Interest', 3, '市场上所有未平仓的合约总数，是衡量市场参与度和流动性的重要指标', 
'## 什么是OI\n\nOI（Open Interest）即未平仓合约数，表示市场上所有尚未平仓的多头和空头合约总和。\n\n## 计算方式\n\n- **新开仓**：OI 增加\n- **平仓**：OI 减少\n- **换手**（一方平仓，另一方开仓）：OI 不变',
'### 1. 判断趋势强度\n- 价格上涨 + OI 上涨 = 趋势强劲\n- 价格上涨 + OI 下降 = 趋势可能反转\n\n### 2. 识别市场情绪\n- OI 快速增加 = 新资金入场\n- OI 快速减少 = 资金离场',
'BTC 价格从 90,000 涨到 95,000，同时 OI 从 20 亿增加到 25 亿，说明有大量新资金做多入场，上涨趋势可能延续。',
1, '["合约","持仓","市场数据"]', 'OI'),

('资金费率', 'Funding Rate', 3, '永续合约多空双方定期支付的费用，用于锚定现货价格',
'## 什么是资金费率\n\n资金费率是永续合约特有的机制，每隔一段时间（通常8小时）多空双方互相支付费用，目的是让合约价格贴近现货价格。\n\n## 计算规则\n\n- 资金费率 > 0：多头支付给空头（市场偏多）\n- 资金费率 < 0：空头支付给多头（市场偏空）\n- 费率越高，说明市场情绪越极端',
'### 1. 判断市场情绪\n- 费率持续为正且较高 = 市场过热，可能回调\n- 费率持续为负 = 市场恐慌，可能反弹\n\n### 2. 套利策略\n- 高费率时可做空合约 + 做多现货',
'BTC 资金费率达到 0.1%（8小时），意味着做多需要每8小时支付 0.1% 的费用，年化成本约 109%，市场极度过热。',
1, '["合约","费率","永续"]', 'zijinfeilv'),

('MACD', 'Moving Average Convergence Divergence', 1, '指数平滑异同移动平均线，用于判断趋势方向和动能强弱',
'## 什么是MACD\n\nMACD由三部分组成：\n- **DIF线**：快速EMA - 慢速EMA\n- **DEA线**：DIF的移动平均\n- **柱状图**：DIF - DEA\n\n## 常用参数\n\n默认参数：12, 26, 9',
'### 1. 金叉死叉\n- DIF上穿DEA = 金叉，买入信号\n- DIF下穿DEA = 死叉，卖出信号\n\n### 2. 背离\n- 顶背离：价格新高，MACD不创新高\n- 底背离：价格新低，MACD不创新低',
'BTC在4H级别，DIF从下方上穿DEA形成金叉，同时柱状图由绿转红，可以考虑做多。',
2, '["指标","趋势","动能"]', 'MACD'),

('止损', 'Stop Loss', 2, '预设的亏损退出点，用于控制单笔交易的最大损失',
'## 什么是止损\n\n止损是交易中最重要的风险管理工具，在开仓时就设定好最大可接受的亏损幅度。\n\n## 止损类型\n\n- **固定止损**：固定价格或百分比\n- **移动止损**：随价格移动调整\n- **时间止损**：超过预期时间未盈利则退出',
'### 1. 技术止损\n- 设在支撑位下方\n- 设在前低下方\n\n### 2. 资金止损\n- 单笔亏损不超过总资金的1-2%',
'做多BTC，入场价95000，止损设在93000（-2.1%），如果价格跌破93000自动平仓，避免更大损失。',
1, '["风控","仓位","纪律"]', 'zhisun'),

('杠杆', 'Leverage', 2, '用较少的保证金控制较大的仓位，放大收益和风险',
'## 什么是杠杆\n\n杠杆允许交易者用少量资金控制更大的头寸。例如10倍杠杆，100美元可以控制1000美元的仓位。\n\n## 风险提示\n\n- 杠杆放大收益，也放大亏损\n- 高杠杆容易被清算\n- 新手建议使用低杠杆（1-3倍）',
'### 杠杆选择建议\n- 趋势明确：可适当提高杠杆\n- 震荡行情：降低杠杆\n- 新手：不超过3倍',
'使用10倍杠杆做多BTC，价格上涨10%，收益100%；但价格下跌10%，亏损100%，可能被清算。',
1, '["合约","风险","保证金"]', 'ganggan'),

('K线', 'Candlestick', 1, '显示开盘价、收盘价、最高价、最低价的图表形式',
'## K线组成\n\n- **实体**：开盘价和收盘价之间\n- **上影线**：最高价到实体顶部\n- **下影线**：最低价到实体底部\n\n## 颜色含义\n\n- 阳线（绿/白）：收盘价 > 开盘价\n- 阴线（红/黑）：收盘价 < 开盘价',
'### 常见K线形态\n- 锤子线：下跌末端的反转信号\n- 吞没形态：趋势反转信号\n- 十字星：市场犹豫，可能反转',
'一根阳线，开盘90000，收盘95000，最高96000，最低89500。实体部分从90000到95000，上影线到96000，下影线到89500。',
1, '["图表","形态","基础"]', 'Kxian'),

('RSI', 'Relative Strength Index', 1, '相对强弱指标，衡量价格变动的速度和幅度',
'## 什么是RSI\n\nRSI是一个动量指标，数值在0-100之间波动。\n\n## 常用参数\n\n默认周期：14\n\n## 超买超卖\n\n- RSI > 70：超买区域\n- RSI < 30：超卖区域',
'### 1. 超买超卖\n- RSI进入超买区不一定立即下跌\n- 需要配合其他信号确认\n\n### 2. 背离\n- 价格新高，RSI不创新高 = 顶背离\n- 价格新低，RSI不创新低 = 底背离',
'BTC价格创新高100000，但RSI从之前的85降到75，形成顶背离，预示上涨动能减弱。',
2, '["指标","动量","超买超卖"]', 'RSI'),

('清算', 'Liquidation', 2, '因保证金不足被交易所强制平仓',
'## 什么是清算\n\n当亏损达到一定程度，保证金不足以维持仓位时，交易所会强制平仓，这就是清算。\n\n## 清算价格计算\n\n清算价格与杠杆倍数、保证金率相关。杠杆越高，清算价格越接近开仓价。',
'### 如何避免清算\n- 使用较低杠杆\n- 设置止损\n- 不要满仓操作\n- 关注清算地图',
'10倍杠杆做多BTC，开仓价95000，清算价约85500。如果价格跌到85500，仓位会被强制平仓，损失全部保证金。',
1, '["合约","风险","强平"]', 'qingsuan'),

('多空比', 'Long/Short Ratio', 3, '市场上多头和空头仓位的比例',
'## 什么是多空比\n\n多空比反映市场参与者的持仓倾向。\n\n## 解读方式\n\n- 多空比 > 1：多头占优\n- 多空比 < 1：空头占优\n- 极端值往往预示反转',
'### 逆向指标\n- 多空比极高时，可能是顶部\n- 多空比极低时，可能是底部\n\n### 注意事项\n- 不同平台数据可能不同\n- 需要结合其他指标使用',
'BTC多空比达到2.5（多头是空头的2.5倍），市场极度看多，此时要警惕回调风险。',
1, '["情绪","持仓","市场数据"]', 'duokongbi'),

('支撑位', 'Support Level', 1, '价格下跌时可能遇到买盘支撑的价格区域',
'## 什么是支撑位\n\n支撑位是价格下跌过程中，买方力量集中的区域，价格在此处容易止跌反弹。\n\n## 支撑位来源\n\n- 前期低点\n- 均线位置\n- 整数关口\n- 成交密集区',
'### 1. 入场参考\n- 价格回调到支撑位可以考虑做多\n- 止损设在支撑位下方\n\n### 2. 支撑转阻力\n- 支撑位被跌破后，会变成阻力位',
'BTC在90000有强支撑（前期多次在此反弹），价格回调到90500时可以考虑做多，止损设在89500。',
1, '["技术分析","价格","入场"]', 'zhichengwei'),

('阻力位', 'Resistance Level', 1, '价格上涨时可能遇到卖盘阻力的价格区域',
'## 什么是阻力位\n\n阻力位是价格上涨过程中，卖方力量集中的区域，价格在此处容易遇阻回落。\n\n## 阻力位来源\n\n- 前期高点\n- 均线位置\n- 整数关口\n- 成交密集区',
'### 1. 止盈参考\n- 价格接近阻力位可以考虑止盈\n- 突破阻力位可以加仓\n\n### 2. 阻力转支撑\n- 阻力位被突破后，会变成支撑位',
'BTC在100000有强阻力（历史高点），价格涨到99500时可以考虑减仓，等待突破确认后再加仓。',
1, '["技术分析","价格","止盈"]', 'zuliwei'),

('FOMO', 'Fear Of Missing Out', 6, '错失恐惧，害怕错过行情而冲动入场的心理',
'## 什么是FOMO\n\nFOMO是一种常见的交易心理陷阱，表现为看到价格上涨就急于追高，害怕错过赚钱机会。\n\n## FOMO的危害\n\n- 追高被套\n- 打乱交易计划\n- 情绪化交易',
'### 如何克服FOMO\n- 制定交易计划并严格执行\n- 记住：市场永远有机会\n- 错过不是损失，追高才是\n- 保持交易日记，复盘FOMO交易',
'BTC从90000涨到95000，你没有入场。看到还在涨，FOMO心理驱使你在97000追高，结果价格回调到93000，被套4%。',
1, '["心理","情绪","纪律"]', 'FOMO');
