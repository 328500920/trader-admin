/*
 Navicat Premium Data Transfer

 Source Server         : 110.40.171.244（trader)
 Source Server Type    : MySQL
 Source Server Version : 50738
 Source Host           : 110.40.171.244:33306
 Source Schema         : trader_db

 Target Server Type    : MySQL
 Target Server Version : 50738
 File Encoding         : 65001

 Date: 30/12/2025 13:32:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for community_comment
-- ----------------------------
DROP TABLE IF EXISTS `community_comment`;
CREATE TABLE `community_comment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` bigint(20) NOT NULL COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '评论者ID',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父评论ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_id`(`post_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评论表';

-- ----------------------------
-- Records of community_comment
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for community_like
-- ----------------------------
DROP TABLE IF EXISTS `community_like`;
CREATE TABLE `community_like`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `target_type` tinyint(4) NOT NULL COMMENT '目标类型：1帖子 2评论',
  `target_id` bigint(20) NOT NULL COMMENT '目标ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_target`(`user_id`, `target_type`, `target_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '点赞表';

-- ----------------------------
-- Records of community_like
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for community_post
-- ----------------------------
DROP TABLE IF EXISTS `community_post`;
CREATE TABLE `community_post`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '作者ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览量',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int(11) NULL DEFAULT 0 COMMENT '评论数',
  `is_top` tinyint(4) NULL DEFAULT 0 COMMENT '是否置顶',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帖子表';

-- ----------------------------
-- Records of community_post
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for crypto_currency
-- ----------------------------
DROP TABLE IF EXISTS `crypto_currency`;
CREATE TABLE `crypto_currency`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '货币代码，如BTC',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '货币名称，如Bitcoin',
  `name_cn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '中文名称，如比特币',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '图标URL',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序权重，越小越靠前',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1启用 0禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_sort`(`sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '数字货币码表';

-- ----------------------------
-- Records of crypto_currency
-- ----------------------------
BEGIN;
INSERT INTO `crypto_currency` (`id`, `code`, `name`, `name_cn`, `logo`, `sort_order`, `status`, `create_time`, `update_time`) VALUES (1, 'BTC', 'Bitcoin', '比特币', NULL, 1, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (2, 'ETH', 'Ethereum', '以太坊', NULL, 2, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (3, 'BNB', 'BNB', '币安币', NULL, 3, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (4, 'SOL', 'Solana', '索拉纳', NULL, 4, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (5, 'XRP', 'Ripple', '瑞波币', NULL, 5, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (6, 'DOGE', 'Dogecoin', '狗狗币', NULL, 6, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (7, 'ADA', 'Cardano', '艾达币', NULL, 7, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (8, 'AVAX', 'Avalanche', '雪崩', NULL, 8, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (9, 'SHIB', 'Shiba Inu', '柴犬币', NULL, 9, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (10, 'DOT', 'Polkadot', '波卡', NULL, 10, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (11, 'LINK', 'Chainlink', '链接', NULL, 11, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (12, 'TRX', 'TRON', '波场', NULL, 12, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (13, 'MATIC', 'Polygon', '马蹄', NULL, 13, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (14, 'UNI', 'Uniswap', 'UNI', NULL, 14, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (15, 'ATOM', 'Cosmos', '阿童木', NULL, 15, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (16, 'LTC', 'Litecoin', '莱特币', NULL, 16, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (17, 'ETC', 'Ethereum Classic', '以太经典', NULL, 17, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (18, 'FIL', 'Filecoin', '文件币', NULL, 18, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (19, 'APT', 'Aptos', 'APT', NULL, 19, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (20, 'ARB', 'Arbitrum', 'ARB', NULL, 20, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (21, 'OP', 'Optimism', 'OP', NULL, 21, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (22, 'NEAR', 'NEAR Protocol', 'NEAR', NULL, 22, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (23, 'INJ', 'Injective', 'INJ', NULL, 23, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (24, 'SUI', 'Sui', 'SUI', NULL, 24, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (25, 'SEI', 'Sei', 'SEI', NULL, 25, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (26, 'PEPE', 'Pepe', '青蛙币', NULL, 26, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (27, 'WIF', 'dogwifhat', 'WIF', NULL, 27, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (28, 'ORDI', 'ORDI', 'ORDI', NULL, 28, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (29, 'STX', 'Stacks', 'STX', NULL, 29, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19'), (30, 'IMX', 'Immutable', 'IMX', NULL, 30, 1, '2025-12-29 11:55:19', '2025-12-29 11:55:19');
COMMIT;

-- ----------------------------
-- Table structure for glossary_category
-- ----------------------------
DROP TABLE IF EXISTS `glossary_category`;
CREATE TABLE `glossary_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '分类名称',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '图标',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父分类ID',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1启用 0禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语分类表';

-- ----------------------------
-- Records of glossary_category
-- ----------------------------
BEGIN;
INSERT INTO `glossary_category` (`id`, `name`, `icon`, `parent_id`, `sort_order`, `status`, `create_time`) VALUES (1, '技术分析', 'TrendCharts', 0, 1, 1, '2025-12-29 11:27:23'), (2, '交易操作', 'Operation', 0, 2, 1, '2025-12-29 11:27:23'), (3, '市场数据', 'DataLine', 0, 3, 1, '2025-12-29 11:27:23'), (4, '链上数据', 'Link', 0, 4, 1, '2025-12-29 11:27:23'), (5, '基本面', 'Document', 0, 5, 1, '2025-12-29 11:27:23'), (6, '交易心理', 'Memo', 0, 6, 1, '2025-12-29 11:27:23');
COMMIT;

-- ----------------------------
-- Table structure for glossary_favorite
-- ----------------------------
DROP TABLE IF EXISTS `glossary_favorite`;
CREATE TABLE `glossary_favorite`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `term_id` bigint(20) NOT NULL COMMENT '术语ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_term`(`user_id`, `term_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语收藏表';

-- ----------------------------
-- Records of glossary_favorite
-- ----------------------------
BEGIN;
INSERT INTO `glossary_favorite` (`id`, `user_id`, `term_id`, `create_time`) VALUES (1, 3, 3, '2025-12-29 11:38:07');
COMMIT;

-- ----------------------------
-- Table structure for glossary_history
-- ----------------------------
DROP TABLE IF EXISTS `glossary_history`;
CREATE TABLE `glossary_history`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `term_id` bigint(20) NOT NULL COMMENT '术语ID',
  `view_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '查看时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_view_time`(`view_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语查看历史表';

-- ----------------------------
-- Records of glossary_history
-- ----------------------------
BEGIN;
INSERT INTO `glossary_history` (`id`, `user_id`, `term_id`, `view_time`) VALUES (2, 3, 1, '2025-12-29 11:37:29'), (4, 3, 2, '2025-12-29 11:37:43'), (8, 3, 7, '2025-12-29 11:38:02'), (10, 3, 3, '2025-12-29 11:38:07');
COMMIT;

-- ----------------------------
-- Table structure for glossary_term
-- ----------------------------
DROP TABLE IF EXISTS `glossary_term`;
CREATE TABLE `glossary_term`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '术语名称',
  `name_en` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '英文名称',
  `category_id` bigint(20) NOT NULL COMMENT '分类ID',
  `brief` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '简短定义',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '详细解释(Markdown)',
  `application` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '应用场景(Markdown)',
  `example` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '示例(Markdown)',
  `related_terms` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '相关术语ID(JSON数组)',
  `related_chapters` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '关联课程章节ID(JSON数组)',
  `difficulty` tinyint(4) NULL DEFAULT 1 COMMENT '难度: 1入门 2进阶 3高级',
  `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '标签(JSON数组)',
  `pinyin` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '拼音(用于搜索)',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '查看次数',
  `favorite_count` int(11) NULL DEFAULT 0 COMMENT '收藏次数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1启用 0禁用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category_id`(`category_id`) USING BTREE,
  INDEX `idx_difficulty`(`difficulty`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语表';

-- ----------------------------
-- Records of glossary_term
-- ----------------------------
BEGIN;
INSERT INTO `glossary_term` (`id`, `name`, `name_en`, `category_id`, `brief`, `detail`, `application`, `example`, `related_terms`, `related_chapters`, `difficulty`, `tags`, `pinyin`, `view_count`, `favorite_count`, `status`, `create_by`, `create_time`, `update_time`) VALUES (1, 'OI', 'Open Interest', 3, '市场上所有未平仓的合约总数，是衡量市场参与度和流动性的重要指标', '## 什么是OI\n\nOI（Open Interest）即未平仓合约数，表示市场上所有尚未平仓的多头和空头合约总和。\n\n## 计算方式\n\n- **新开仓**：OI 增加\n- **平仓**：OI 减少\n- **换手**（一方平仓，另一方开仓）：OI 不变', '### 1. 判断趋势强度\n- 价格上涨 + OI 上涨 = 趋势强劲\n- 价格上涨 + OI 下降 = 趋势可能反转\n\n### 2. 识别市场情绪\n- OI 快速增加 = 新资金入场\n- OI 快速减少 = 资金离场', 'BTC 价格从 90,000 涨到 95,000，同时 OI 从 20 亿增加到 25 亿，说明有大量新资金做多入场，上涨趋势可能延续。', NULL, NULL, 1, '[\"合约\",\"持仓\",\"市场数据\"]', 'OI', 2, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (2, '资金费率', 'Funding Rate', 3, '永续合约多空双方定期支付的费用，用于锚定现货价格', '## 什么是资金费率\n\n资金费率是永续合约特有的机制，每隔一段时间（通常8小时）多空双方互相支付费用，目的是让合约价格贴近现货价格。\n\n## 计算规则\n\n- 资金费率 > 0：多头支付给空头（市场偏多）\n- 资金费率 < 0：空头支付给多头（市场偏空）\n- 费率越高，说明市场情绪越极端', '### 1. 判断市场情绪\n- 费率持续为正且较高 = 市场过热，可能回调\n- 费率持续为负 = 市场恐慌，可能反弹\n\n### 2. 套利策略\n- 高费率时可做空合约 + 做多现货', 'BTC 资金费率达到 0.1%（8小时），意味着做多需要每8小时支付 0.1% 的费用，年化成本约 109%，市场极度过热。', NULL, NULL, 1, '[\"合约\",\"费率\",\"永续\"]', 'zijinfeilv', 2, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (3, 'MACD', 'Moving Average Convergence Divergence', 1, '指数平滑异同移动平均线，用于判断趋势方向和动能强弱', '## 什么是MACD\n\nMACD由三部分组成：\n- **DIF线**：快速EMA - 慢速EMA\n- **DEA线**：DIF的移动平均\n- **柱状图**：DIF - DEA\n\n## 常用参数\n\n默认参数：12, 26, 9', '### 1. 金叉死叉\n- DIF上穿DEA = 金叉，买入信号\n- DIF下穿DEA = 死叉，卖出信号\n\n### 2. 背离\n- 顶背离：价格新高，MACD不创新高\n- 底背离：价格新低，MACD不创新低', 'BTC在4H级别，DIF从下方上穿DEA形成金叉，同时柱状图由绿转红，可以考虑做多。', NULL, NULL, 2, '[\"指标\",\"趋势\",\"动能\"]', 'MACD', 4, 1, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (4, '止损', 'Stop Loss', 2, '预设的亏损退出点，用于控制单笔交易的最大损失', '## 什么是止损\n\n止损是交易中最重要的风险管理工具，在开仓时就设定好最大可接受的亏损幅度。\n\n## 止损类型\n\n- **固定止损**：固定价格或百分比\n- **移动止损**：随价格移动调整\n- **时间止损**：超过预期时间未盈利则退出', '### 1. 技术止损\n- 设在支撑位下方\n- 设在前低下方\n\n### 2. 资金止损\n- 单笔亏损不超过总资金的1-2%', '做多BTC，入场价95000，止损设在93000（-2.1%），如果价格跌破93000自动平仓，避免更大损失。', NULL, NULL, 1, '[\"风控\",\"仓位\",\"纪律\"]', 'zhisun', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (5, '杠杆', 'Leverage', 2, '用较少的保证金控制较大的仓位，放大收益和风险', '## 什么是杠杆\n\n杠杆允许交易者用少量资金控制更大的头寸。例如10倍杠杆，100美元可以控制1000美元的仓位。\n\n## 风险提示\n\n- 杠杆放大收益，也放大亏损\n- 高杠杆容易被清算\n- 新手建议使用低杠杆（1-3倍）', '### 杠杆选择建议\n- 趋势明确：可适当提高杠杆\n- 震荡行情：降低杠杆\n- 新手：不超过3倍', '使用10倍杠杆做多BTC，价格上涨10%，收益100%；但价格下跌10%，亏损100%，可能被清算。', NULL, NULL, 1, '[\"合约\",\"风险\",\"保证金\"]', 'ganggan', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (6, 'K线', 'Candlestick', 1, '显示开盘价、收盘价、最高价、最低价的图表形式', '## K线组成\n\n- **实体**：开盘价和收盘价之间\n- **上影线**：最高价到实体顶部\n- **下影线**：最低价到实体底部\n\n## 颜色含义\n\n- 阳线（绿/白）：收盘价 > 开盘价\n- 阴线（红/黑）：收盘价 < 开盘价', '### 常见K线形态\n- 锤子线：下跌末端的反转信号\n- 吞没形态：趋势反转信号\n- 十字星：市场犹豫，可能反转', '一根阳线，开盘90000，收盘95000，最高96000，最低89500。实体部分从90000到95000，上影线到96000，下影线到89500。', NULL, NULL, 1, '[\"图表\",\"形态\",\"基础\"]', 'Kxian', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (7, 'RSI', 'Relative Strength Index', 1, '相对强弱指标，衡量价格变动的速度和幅度', '## 什么是RSI\n\nRSI是一个动量指标，数值在0-100之间波动。\n\n## 常用参数\n\n默认周期：14\n\n## 超买超卖\n\n- RSI > 70：超买区域\n- RSI < 30：超卖区域', '### 1. 超买超卖\n- RSI进入超买区不一定立即下跌\n- 需要配合其他信号确认\n\n### 2. 背离\n- 价格新高，RSI不创新高 = 顶背离\n- 价格新低，RSI不创新低 = 底背离', 'BTC价格创新高100000，但RSI从之前的85降到75，形成顶背离，预示上涨动能减弱。', NULL, NULL, 2, '[\"指标\",\"动量\",\"超买超卖\"]', 'RSI', 2, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (8, '清算', 'Liquidation', 2, '因保证金不足被交易所强制平仓', '## 什么是清算\n\n当亏损达到一定程度，保证金不足以维持仓位时，交易所会强制平仓，这就是清算。\n\n## 清算价格计算\n\n清算价格与杠杆倍数、保证金率相关。杠杆越高，清算价格越接近开仓价。', '### 如何避免清算\n- 使用较低杠杆\n- 设置止损\n- 不要满仓操作\n- 关注清算地图', '10倍杠杆做多BTC，开仓价95000，清算价约85500。如果价格跌到85500，仓位会被强制平仓，损失全部保证金。', NULL, NULL, 1, '[\"合约\",\"风险\",\"强平\"]', 'qingsuan', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (9, '多空比', 'Long/Short Ratio', 3, '市场上多头和空头仓位的比例', '## 什么是多空比\n\n多空比反映市场参与者的持仓倾向。\n\n## 解读方式\n\n- 多空比 > 1：多头占优\n- 多空比 < 1：空头占优\n- 极端值往往预示反转', '### 逆向指标\n- 多空比极高时，可能是顶部\n- 多空比极低时，可能是底部\n\n### 注意事项\n- 不同平台数据可能不同\n- 需要结合其他指标使用', 'BTC多空比达到2.5（多头是空头的2.5倍），市场极度看多，此时要警惕回调风险。', NULL, NULL, 1, '[\"情绪\",\"持仓\",\"市场数据\"]', 'duokongbi', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (10, '支撑位', 'Support Level', 1, '价格下跌时可能遇到买盘支撑的价格区域', '## 什么是支撑位\n\n支撑位是价格下跌过程中，买方力量集中的区域，价格在此处容易止跌反弹。\n\n## 支撑位来源\n\n- 前期低点\n- 均线位置\n- 整数关口\n- 成交密集区', '### 1. 入场参考\n- 价格回调到支撑位可以考虑做多\n- 止损设在支撑位下方\n\n### 2. 支撑转阻力\n- 支撑位被跌破后，会变成阻力位', 'BTC在90000有强支撑（前期多次在此反弹），价格回调到90500时可以考虑做多，止损设在89500。', NULL, NULL, 1, '[\"技术分析\",\"价格\",\"入场\"]', 'zhichengwei', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (11, '阻力位', 'Resistance Level', 1, '价格上涨时可能遇到卖盘阻力的价格区域', '## 什么是阻力位\n\n阻力位是价格上涨过程中，卖方力量集中的区域，价格在此处容易遇阻回落。\n\n## 阻力位来源\n\n- 前期高点\n- 均线位置\n- 整数关口\n- 成交密集区', '### 1. 止盈参考\n- 价格接近阻力位可以考虑止盈\n- 突破阻力位可以加仓\n\n### 2. 阻力转支撑\n- 阻力位被突破后，会变成支撑位', 'BTC在100000有强阻力（历史高点），价格涨到99500时可以考虑减仓，等待突破确认后再加仓。', NULL, NULL, 1, '[\"技术分析\",\"价格\",\"止盈\"]', 'zuliwei', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23'), (12, 'FOMO', 'Fear Of Missing Out', 6, '错失恐惧，害怕错过行情而冲动入场的心理', '## 什么是FOMO\n\nFOMO是一种常见的交易心理陷阱，表现为看到价格上涨就急于追高，害怕错过赚钱机会。\n\n## FOMO的危害\n\n- 追高被套\n- 打乱交易计划\n- 情绪化交易', '### 如何克服FOMO\n- 制定交易计划并严格执行\n- 记住：市场永远有机会\n- 错过不是损失，追高才是\n- 保持交易日记，复盘FOMO交易', 'BTC从90000涨到95000，你没有入场。看到还在涨，FOMO心理驱使你在97000追高，结果价格回调到93000，被套4%。', NULL, NULL, 1, '[\"心理\",\"情绪\",\"纪律\"]', 'FOMO', 0, 0, 1, NULL, '2025-12-29 11:27:23', '2025-12-29 11:27:23');
COMMIT;

-- ----------------------------
-- Table structure for learn_chapter
-- ----------------------------
DROP TABLE IF EXISTS `learn_chapter`;
CREATE TABLE `learn_chapter`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '章节ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '章节标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '章节内容（Markdown）',
  `week_number` int(11) NULL DEFAULT NULL COMMENT '周数',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '章节表';

-- ----------------------------
-- Records of learn_chapter
-- ----------------------------
BEGIN;
INSERT INTO `learn_chapter` (`id`, `course_id`, `title`, `content`, `week_number`, `sort_order`, `status`, `create_time`, `update_time`) VALUES (1, 1, '第1周：K线基础与市场认知', '## 学习目标\r\n- 理解K线的基本构成（开盘价、收盘价、最高价、最低价）\r\n- 掌握常见K线形态（锤子线、十字星、吞没形态等）\r\n- 了解数字货币市场的基本特点\r\n\r\n## 学习内容\r\n### K线基础\r\n- K线的四个价格要素\r\n- 阳线与阴线的含义\r\n- 实体与影线的意义\r\n\r\n### 常见K线形态\r\n- 单根K线形态：锤子线、上吊线、十字星\r\n- 双K线形态：吞没形态、孕线形态\r\n- 三K线形态：早晨之星、黄昏之星\r\n\r\n## 实践任务\r\n- [ ] 在TradingView上观察BTC日线图，识别至少10种K线形态\r\n- [ ] 记录每种形态出现后的价格走势\r\n- [ ] 总结K线形态的成功率', 1, 1, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (2, 1, '第2周：支撑阻力与趋势线', '## 学习目标\r\n- 掌握支撑位和阻力位的识别方法\r\n- 学会绘制趋势线\r\n- 理解趋势的三种类型\r\n\r\n## 学习内容\r\n### 支撑与阻力\r\n- 支撑位的形成原理\r\n- 阻力位的形成原理\r\n- 支撑阻力的转换\r\n\r\n### 趋势线\r\n- 上升趋势线的绘制\r\n- 下降趋势线的绘制\r\n- 趋势线的有效性判断\r\n\r\n## 实践任务\r\n- [ ] 在BTC/ETH图表上标注关键支撑阻力位\r\n- [ ] 绘制当前的趋势线\r\n- [ ] 记录价格触及支撑阻力时的反应', 2, 2, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (3, 1, '第3周：移动平均线系统', '## 学习目标\r\n- 理解移动平均线的计算原理\r\n- 掌握常用均线周期的选择\r\n- 学会使用均线判断趋势\r\n\r\n## 学习内容\r\n### 移动平均线基础\r\n- SMA与EMA的区别\r\n- 常用均线周期：7/20/50/100/200\r\n- 均线的滞后性\r\n\r\n### 均线交易策略\r\n- 金叉与死叉\r\n- 均线支撑与阻力\r\n- 多均线系统\r\n\r\n## 实践任务\r\n- [ ] 设置20/50/200均线组合\r\n- [ ] 观察均线金叉死叉后的走势\r\n- [ ] 统计均线策略的胜率', 3, 3, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (4, 1, '第4周：MACD指标深度学习', '## 学习目标\r\n- 理解MACD的计算原理\r\n- 掌握MACD的各种信号\r\n- 学会MACD与价格的背离分析\r\n\r\n## 学习内容\r\n### MACD基础\r\n- DIF线与DEA线\r\n- MACD柱状图\r\n- 零轴的意义\r\n\r\n### MACD信号\r\n- 金叉与死叉\r\n- 零轴上下的意义\r\n- 顶背离与底背离\r\n\r\n## 实践任务\r\n- [ ] 找出近期BTC的MACD背离案例\r\n- [ ] 记录MACD信号的准确率\r\n- [ ] 结合K线形态验证MACD信号', 4, 4, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (5, 1, '第5周：RSI与布林带', '## 学习目标\r\n- 掌握RSI指标的使用\r\n- 理解布林带的原理和应用\r\n- 学会超买超卖的判断\r\n\r\n## 学习内容\r\n### RSI指标\r\n- RSI的计算方法\r\n- 超买超卖区域\r\n- RSI背离\r\n\r\n### 布林带\r\n- 布林带的三条线\r\n- 布林带收窄与扩张\r\n- 布林带突破策略\r\n\r\n## 实践任务\r\n- [ ] 观察RSI在70/30区域的价格反应\r\n- [ ] 记录布林带收窄后的突破方向\r\n- [ ] 结合RSI和布林带制定交易计划', 5, 5, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (6, 1, '第6周：成交量分析', '## 学习目标\r\n- 理解成交量的重要性\r\n- 掌握量价关系分析\r\n- 学会识别异常成交量\r\n\r\n## 学习内容\r\n### 成交量基础\r\n- 成交量的意义\r\n- 量价配合原则\r\n- 缩量与放量\r\n\r\n### 量价分析\r\n- 上涨放量的含义\r\n- 下跌缩量的含义\r\n- 天量与地量\r\n\r\n## 实践任务\r\n- [ ] 分析BTC重要转折点的成交量特征\r\n- [ ] 记录量价背离的案例\r\n- [ ] 总结成交量对趋势的验证作用', 6, 6, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (7, 1, '第7周：基本面与消息面分析', '## 学习目标\r\n- 了解影响加密货币的宏观因素\r\n- 掌握重要经济数据的解读\r\n- 学会评估消息面的影响\r\n\r\n## 学习内容\r\n### 宏观经济因素\r\n- 美联储政策对加密货币的影响\r\n- 美元指数(DXY)与BTC的关系\r\n- 美股与加密货币的联动\r\n\r\n### 消息面分析\r\n- 监管政策的影响\r\n- 项目基本面评估\r\n- 市场情绪指标\r\n\r\n## 实践任务\r\n- [ ] 关注本周重要经济数据发布\r\n- [ ] 记录消息发布后的市场反应\r\n- [ ] 建立自己的消息面分析框架', 7, 7, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (8, 1, '第8周：链上数据入门', '## 学习目标\r\n- 了解链上数据的类型\r\n- 掌握常用链上指标\r\n- 学会使用链上数据辅助决策\r\n\r\n## 学习内容\r\n### 链上数据基础\r\n- 交易所流入流出\r\n- 巨鲸地址追踪\r\n- 活跃地址数\r\n\r\n### 常用链上指标\r\n- MVRV比率\r\n- SOPR指标\r\n- 矿工持仓变化\r\n\r\n## 实践任务\r\n- [ ] 注册Glassnode/CryptoQuant账号\r\n- [ ] 观察交易所净流入流出数据\r\n- [ ] 记录链上数据与价格的关系', 8, 8, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (9, 2, '第9周：交易系统构建', '## 学习目标\r\n- 理解交易系统的组成要素\r\n- 设计自己的交易规则\r\n- 建立入场和出场标准\r\n\r\n## 学习内容\r\n### 交易系统要素\r\n- 市场选择\r\n- 入场信号\r\n- 出场信号\r\n- 仓位管理\r\n- 风险控制\r\n\r\n### 系统设计原则\r\n- 简单有效\r\n- 可执行性\r\n- 可量化\r\n\r\n## 实践任务\r\n- [ ] 写出自己的交易系统规则\r\n- [ ] 定义明确的入场条件\r\n- [ ] 定义明确的出场条件', 9, 1, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (10, 2, '第10周：风险管理基础', '## 学习目标\r\n- 理解风险管理的重要性\r\n- 掌握仓位计算方法\r\n- 学会设置止损止盈\r\n\r\n## 学习内容\r\n### 风险管理原则\r\n- 单笔风险控制在1-2%\r\n- 总仓位控制\r\n- 相关性风险\r\n\r\n### 仓位计算\r\n- 固定金额法\r\n- 固定比例法\r\n- 凯利公式\r\n\r\n## 实践任务\r\n- [ ] 计算自己的单笔最大风险金额\r\n- [ ] 制定仓位管理规则\r\n- [ ] 设计止损止盈策略', 10, 2, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (11, 2, '第11周：趋势跟随策略', '## 学习目标\r\n- 掌握趋势跟随的核心理念\r\n- 学会识别趋势的开始和结束\r\n- 建立趋势跟随交易系统\r\n\r\n## 学习内容\r\n### 趋势跟随原理\r\n- 趋势的定义\r\n- 趋势的持续性\r\n- 顺势而为\r\n\r\n### 趋势跟随策略\r\n- 均线突破策略\r\n- 通道突破策略\r\n- 动量策略\r\n\r\n## 实践任务\r\n- [ ] 回测趋势跟随策略\r\n- [ ] 记录策略的胜率和盈亏比\r\n- [ ] 优化策略参数', 11, 3, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (12, 2, '第12周：震荡交易策略', '## 学习目标\r\n- 识别震荡市场\r\n- 掌握区间交易方法\r\n- 学会在震荡中获利\r\n\r\n## 学习内容\r\n### 震荡市场特征\r\n- 价格在区间内波动\r\n- 成交量萎缩\r\n- 指标钝化\r\n\r\n### 震荡交易策略\r\n- 支撑阻力交易\r\n- 布林带回归策略\r\n- RSI超买超卖策略\r\n\r\n## 实践任务\r\n- [ ] 识别当前市场是趋势还是震荡\r\n- [ ] 在震荡区间内模拟交易\r\n- [ ] 记录震荡策略的表现', 12, 4, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (13, 2, '第13周：突破交易策略', '## 学习目标\r\n- 识别有效突破\r\n- 过滤假突破\r\n- 建立突破交易系统\r\n\r\n## 学习内容\r\n### 突破类型\r\n- 水平突破\r\n- 趋势线突破\r\n- 形态突破\r\n\r\n### 突破确认\r\n- 成交量确认\r\n- 收盘价确认\r\n- 回踩确认\r\n\r\n## 实践任务\r\n- [ ] 找出近期的突破案例\r\n- [ ] 分析突破成功和失败的原因\r\n- [ ] 制定突破交易规则', 13, 5, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (14, 2, '第14周：多时间框架分析', '## 学习目标\r\n- 理解多时间框架的意义\r\n- 学会从大到小分析\r\n- 建立多周期交易系统\r\n\r\n## 学习内容\r\n### 时间框架选择\r\n- 周线定方向\r\n- 日线找机会\r\n- 4小时精确入场\r\n\r\n### 多周期共振\r\n- 趋势一致性\r\n- 信号共振\r\n- 时间周期配合\r\n\r\n## 实践任务\r\n- [ ] 分析BTC的周线、日线、4小时图\r\n- [ ] 找出多周期共振的交易机会\r\n- [ ] 记录多周期分析的效果', 14, 6, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (15, 2, '第15周：交易心理学', '## 学习目标\r\n- 认识常见的交易心理陷阱\r\n- 学会控制情绪\r\n- 建立正确的交易心态\r\n\r\n## 学习内容\r\n### 常见心理陷阱\r\n- 贪婪与恐惧\r\n- 过度交易\r\n- 报复性交易\r\n- 确认偏误\r\n\r\n### 心理控制方法\r\n- 交易日志\r\n- 冥想与放松\r\n- 规则化交易\r\n\r\n## 实践任务\r\n- [ ] 记录每笔交易时的情绪状态\r\n- [ ] 识别自己的心理弱点\r\n- [ ] 制定情绪管理计划', 15, 7, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (16, 2, '第16周：模拟交易实战', '## 学习目标\r\n- 在模拟环境中验证策略\r\n- 积累交易经验\r\n- 完善交易系统\r\n\r\n## 学习内容\r\n### 模拟交易要点\r\n- 像真实交易一样对待\r\n- 严格执行规则\r\n- 详细记录每笔交易\r\n\r\n### 交易复盘\r\n- 每日复盘\r\n- 每周总结\r\n- 策略优化\r\n\r\n## 实践任务\r\n- [ ] 完成至少20笔模拟交易\r\n- [ ] 计算策略的实际表现\r\n- [ ] 总结需要改进的地方', 16, 8, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (17, 3, '第17周：小资金实盘开始', '## 学习目标\r\n- 从模拟过渡到实盘\r\n- 控制初始资金规模\r\n- 适应真实市场环境\r\n\r\n## 学习内容\r\n### 实盘准备\r\n- 资金规划\r\n- 心理准备\r\n- 风险预案\r\n\r\n### 小资金策略\r\n- 降低仓位\r\n- 减少交易频率\r\n- 专注执行\r\n\r\n## 实践任务\r\n- [ ] 投入不超过总资金10%开始实盘\r\n- [ ] 严格执行已验证的策略\r\n- [ ] 记录实盘与模拟的差异', 17, 1, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (18, 3, '第18周：交易日志深度分析', '## 学习目标\r\n- 建立完善的交易日志系统\r\n- 学会从日志中发现问题\r\n- 持续改进交易表现\r\n\r\n## 学习内容\r\n### 交易日志要素\r\n- 入场理由\r\n- 出场理由\r\n- 情绪状态\r\n- 市场环境\r\n\r\n### 日志分析方法\r\n- 统计分析\r\n- 模式识别\r\n- 问题诊断\r\n\r\n## 实践任务\r\n- [ ] 完善交易日志模板\r\n- [ ] 分析过去一个月的交易记录\r\n- [ ] 找出最大的改进点', 18, 2, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (19, 3, '第19周：高级技术分析', '## 学习目标\r\n- 学习高级图表形态\r\n- 掌握斐波那契工具\r\n- 理解市场结构\r\n\r\n## 学习内容\r\n### 高级形态\r\n- 头肩顶/底\r\n- 双顶/双底\r\n- 三角形态\r\n- 旗形与楔形\r\n\r\n### 斐波那契工具\r\n- 回撤位\r\n- 扩展位\r\n- 时间周期\r\n\r\n## 实践任务\r\n- [ ] 识别当前市场的图表形态\r\n- [ ] 使用斐波那契工具分析\r\n- [ ] 结合形态制定交易计划', 19, 3, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (20, 3, '第20周：市场情绪深度分析', '## 学习目标\r\n- 深入理解市场情绪\r\n- 掌握情绪指标的使用\r\n- 学会逆向思维\r\n\r\n## 学习内容\r\n### 情绪指标\r\n- 恐惧贪婪指数\r\n- 资金费率\r\n- 多空比\r\n- 社交媒体情绪\r\n\r\n### 逆向交易\r\n- 极端情绪的识别\r\n- 逆向交易时机\r\n- 风险控制\r\n\r\n## 实践任务\r\n- [ ] 每日记录市场情绪指标\r\n- [ ] 分析情绪与价格的关系\r\n- [ ] 尝试在极端情绪时逆向交易', 20, 4, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (21, 3, '第21周：资金管理进阶', '## 学习目标\r\n- 学习高级资金管理技术\r\n- 理解复利的力量\r\n- 建立长期盈利思维\r\n\r\n## 学习内容\r\n### 高级资金管理\r\n- 金字塔加仓\r\n- 分批止盈\r\n- 动态仓位调整\r\n\r\n### 复利增长\r\n- 复利计算\r\n- 回撤控制\r\n- 长期目标设定\r\n\r\n## 实践任务\r\n- [ ] 计算不同复利率下的资金增长\r\n- [ ] 制定资金增长计划\r\n- [ ] 设定合理的收益目标', 21, 5, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (22, 3, '第22周：交易系统优化', '## 学习目标\r\n- 评估交易系统表现\r\n- 识别优化方向\r\n- 避免过度优化\r\n\r\n## 学习内容\r\n### 系统评估指标\r\n- 胜率\r\n- 盈亏比\r\n- 最大回撤\r\n- 夏普比率\r\n\r\n### 优化方法\r\n- 参数优化\r\n- 规则优化\r\n- 过滤条件优化\r\n\r\n## 实践任务\r\n- [ ] 计算系统的各项指标\r\n- [ ] 识别系统的弱点\r\n- [ ] 进行有针对性的优化', 22, 6, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (23, 3, '第23周：多策略组合', '## 学习目标\r\n- 理解策略组合的意义\r\n- 学会策略相关性分析\r\n- 建立多策略交易系统\r\n\r\n## 学习内容\r\n### 策略组合原理\r\n- 分散风险\r\n- 平滑收益曲线\r\n- 适应不同市场\r\n\r\n### 组合构建\r\n- 策略相关性\r\n- 资金分配\r\n- 动态调整\r\n\r\n## 实践任务\r\n- [ ] 分析已有策略的相关性\r\n- [ ] 设计策略组合方案\r\n- [ ] 测试组合的表现', 23, 7, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (24, 3, '第24周：总结与展望', '## 学习目标\r\n- 回顾半年学习成果\r\n- 总结交易经验\r\n- 制定未来发展计划\r\n\r\n## 学习内容\r\n### 学习总结\r\n- 知识体系回顾\r\n- 技能掌握评估\r\n- 交易表现分析\r\n\r\n### 未来规划\r\n- 持续学习方向\r\n- 资金规模扩展\r\n- 长期职业规划\r\n\r\n## 实践任务\r\n- [ ] 写一份半年学习总结\r\n- [ ] 分析自己的交易数据\r\n- [ ] 制定下一阶段的目标', 24, 8, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59');
COMMIT;

-- ----------------------------
-- Table structure for learn_course
-- ----------------------------
DROP TABLE IF EXISTS `learn_course`;
CREATE TABLE `learn_course`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '课程描述',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面图片',
  `stage` int(11) NOT NULL COMMENT '阶段：1/2/3',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0草稿 1发布',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_stage`(`stage`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程表';

-- ----------------------------
-- Records of learn_course
-- ----------------------------
BEGIN;
INSERT INTO `learn_course` (`id`, `title`, `description`, `cover_image`, `stage`, `sort_order`, `status`, `create_by`, `create_time`, `update_time`) VALUES (1, '阶段一：基础构建期', '第1-8周，建立交易基础知识体系，包括K线技术、技术指标、基本面分析等', NULL, 1, 1, 1, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (2, '阶段二：策略整合与实战期', '第9-16周，整合所学知识，建立交易系统，开始模拟实战', NULL, 2, 2, 1, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59'), (3, '阶段三：进阶与稳定期', '第17-24周，实盘交易，持续优化，追求稳定盈利', NULL, 3, 3, 1, 1, '2025-12-14 23:46:59', '2025-12-14 23:46:59');
COMMIT;

-- ----------------------------
-- Table structure for learn_material
-- ----------------------------
DROP TABLE IF EXISTS `learn_material`;
CREATE TABLE `learn_material`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '资料ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资料标题',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资料描述',
  `material_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资料类型：markdown/pdf/video/link',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '资料内容（markdown类型）',
  `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件URL（pdf/video类型）',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部链接（link类型）',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习资料表';

-- ----------------------------
-- Records of learn_material
-- ----------------------------
BEGIN;
INSERT INTO `learn_material` (`id`, `chapter_id`, `title`, `description`, `material_type`, `content`, `file_url`, `link_url`, `sort_order`, `status`, `create_by`, `create_time`, `update_time`) VALUES (1, 1, '常见的K线形态及其价格走势分析', '详细介绍18种常见K线形态，包括形态特征、价格走势预测和成功率统计', 'markdown', '# 常见的K线形态及其价格走势分析\r\n\r\n## 一、单根K线形态\r\n\r\n### 1. 锤子线（Hammer）\r\n\r\n**形态特征**：下影线长度至少是实体的2倍，上影线很短或没有，出现在下跌趋势末端。\r\n\r\n**价格走势**：\r\n- 出现后通常预示下跌趋势可能反转\r\n- 多头开始入场，价格有望上涨\r\n- 需要后续阳线确认\r\n\r\n**成功率**：约60-65%（需配合成交量确认可提高至70%）\r\n\r\n---\r\n\r\n### 2. 倒锤子线（Inverted Hammer）\r\n\r\n**形态特征**：上影线长度至少是实体的2倍，下影线很短或没有，出现在下跌趋势末端。\r\n\r\n**价格走势**：\r\n- 表明买方尝试推高价格\r\n- 若次日高开，确认反转信号\r\n- 可能开启上涨行情\r\n\r\n**成功率**：约55-60%\r\n\r\n---\r\n\r\n### 3. 上吊线（Hanging Man）\r\n\r\n**形态特征**：与锤子线形态相同，但出现在上涨趋势末端。\r\n\r\n**价格走势**：\r\n- 预示上涨动能减弱\r\n- 空头开始试探性打压\r\n- 可能出现趋势反转下跌\r\n\r\n**成功率**：约55-60%\r\n\r\n---\r\n\r\n### 4. 射击之星（Shooting Star）\r\n\r\n**形态特征**：上影线长，实体小，下影线很短或没有，出现在上涨趋势末端。\r\n\r\n**价格走势**：\r\n- 多头冲高后被空头打压\r\n- 强烈的见顶信号\r\n- 后续大概率下跌\r\n\r\n**成功率**：约65-70%\r\n\r\n---\r\n\r\n### 5. 十字星（Doji）\r\n\r\n**形态特征**：开盘价与收盘价几乎相等，形成十字形状。\r\n\r\n**价格走势**：\r\n- 表示多空力量均衡\r\n- 趋势可能发生转变\r\n- 需结合位置和后续K线判断方向\r\n\r\n**成功率**：约50%（单独使用意义不大，需配合其他信号）\r\n\r\n---\r\n\r\n### 6. 大阳线/大阴线\r\n\r\n**形态特征**：实体很长，影线很短。\r\n\r\n**价格走势**：\r\n- 大阳线：强烈看涨信号，多头占绝对优势\r\n- 大阴线：强烈看跌信号，空头占绝对优势\r\n- 通常预示趋势延续\r\n\r\n**成功率**：约70-75%（趋势延续）\r\n\r\n---\r\n\r\n## 二、双K线组合形态\r\n\r\n### 7. 看涨吞没（Bullish Engulfing）\r\n\r\n**形态特征**：第二根阳线实体完全包住第一根阴线实体，出现在下跌趋势中。\r\n\r\n**价格走势**：\r\n- 强烈的反转信号\r\n- 多头力量压倒空头\r\n- 后续上涨概率高\r\n\r\n**成功率**：约63-68%\r\n\r\n---\r\n\r\n### 8. 看跌吞没（Bearish Engulfing）\r\n\r\n**形态特征**：第二根阴线实体完全包住第一根阳线实体，出现在上涨趋势中。\r\n\r\n**价格走势**：\r\n- 强烈的见顶信号\r\n- 空头力量压倒多头\r\n- 后续下跌概率高\r\n\r\n**成功率**：约65-70%\r\n\r\n---\r\n\r\n### 9. 乌云盖顶（Dark Cloud Cover）\r\n\r\n**形态特征**：第一根为大阳线，第二根阴线高开后收盘价深入阳线实体50%以上。\r\n\r\n**价格走势**：\r\n- 上涨趋势中的反转信号\r\n- 多头动能衰竭\r\n- 预示价格将下跌\r\n\r\n**成功率**：约60-65%\r\n\r\n---\r\n\r\n### 10. 刺透形态（Piercing Pattern）\r\n\r\n**形态特征**：第一根为大阴线，第二根阳线低开后收盘价深入阴线实体50%以上。\r\n\r\n**价格走势**：\r\n- 下跌趋势中的反转信号\r\n- 空头动能衰竭\r\n- 预示价格将上涨\r\n\r\n**成功率**：约60-64%\r\n\r\n---\r\n\r\n### 11. 平头顶部/底部\r\n\r\n**形态特征**：两根或多根K线的最高价（顶部）或最低价（底部）几乎相等。\r\n\r\n**价格走势**：\r\n- 平头顶部：形成阻力，价格可能下跌\r\n- 平头底部：形成支撑，价格可能上涨\r\n\r\n**成功率**：约55-60%\r\n\r\n---\r\n\r\n## 三、三K线组合形态\r\n\r\n### 12. 早晨之星（Morning Star）\r\n\r\n**形态特征**：\r\n1. 第一根：大阴线\r\n2. 第二根：小实体（星线），向下跳空\r\n3. 第三根：大阳线，深入第一根阴线实体\r\n\r\n**价格走势**：\r\n- 经典的底部反转形态\r\n- 空头力量耗尽，多头接管\r\n- 后续上涨概率很高\r\n\r\n**成功率**：约70-78%\r\n\r\n---\r\n\r\n### 13. 黄昏之星（Evening Star）\r\n\r\n**形态特征**：\r\n1. 第一根：大阳线\r\n2. 第二根：小实体（星线），向上跳空\r\n3. 第三根：大阴线，深入第一根阳线实体\r\n\r\n**价格走势**：\r\n- 经典的顶部反转形态\r\n- 多头力量耗尽，空头接管\r\n- 后续下跌概率很高\r\n\r\n**成功率**：约72-79%\r\n\r\n---\r\n\r\n### 14. 三只乌鸦（Three Black Crows）\r\n\r\n**形态特征**：连续三根阴线，每根开盘价在前一根实体内，收盘价创新低。\r\n\r\n**价格走势**：\r\n- 强烈的看跌信号\r\n- 空头完全控制市场\r\n- 下跌趋势确立\r\n\r\n**成功率**：约75-80%\r\n\r\n---\r\n\r\n### 15. 红三兵（Three White Soldiers）\r\n\r\n**形态特征**：连续三根阳线，每根开盘价在前一根实体内，收盘价创新高。\r\n\r\n**价格走势**：\r\n- 强烈的看涨信号\r\n- 多头完全控制市场\r\n- 上涨趋势确立\r\n\r\n**成功率**：约70-75%\r\n\r\n---\r\n\r\n### 16. 三内升/三内降\r\n\r\n**形态特征**：\r\n- 三内升：看跌吞没后第三根阳线收盘高于第二根\r\n- 三内降：看涨吞没后第三根阴线收盘低于第二根\r\n\r\n**价格走势**：\r\n- 确认吞没形态的有效性\r\n- 增强反转信号的可靠性\r\n\r\n**成功率**：约65-70%\r\n\r\n---\r\n\r\n## 四、持续形态\r\n\r\n### 17. 上升三法（Rising Three Methods）\r\n\r\n**形态特征**：\r\n1. 一根大阳线\r\n2. 三根小阴线（在阳线范围内）\r\n3. 一根大阳线突破\r\n\r\n**价格走势**：\r\n- 上涨趋势中的整理形态\r\n- 整理后继续上涨\r\n- 是加仓的好时机\r\n\r\n**成功率**：约65-70%\r\n\r\n---\r\n\r\n### 18. 下降三法（Falling Three Methods）\r\n\r\n**形态特征**：\r\n1. 一根大阴线\r\n2. 三根小阳线（在阴线范围内）\r\n3. 一根大阴线突破\r\n\r\n**价格走势**：\r\n- 下跌趋势中的整理形态\r\n- 整理后继续下跌\r\n- 是做空的好时机\r\n\r\n**成功率**：约65-70%\r\n\r\n---\r\n\r\n## 五、K线形态成功率总结\r\n\r\n| 形态名称 | 类型 | 成功率 | 可靠性 |\r\n|---------|------|--------|--------|\r\n| 早晨之星 | 反转（看涨） | 70-78% | ⭐⭐⭐⭐⭐ |\r\n| 黄昏之星 | 反转（看跌） | 72-79% | ⭐⭐⭐⭐⭐ |\r\n| 三只乌鸦 | 反转（看跌） | 75-80% | ⭐⭐⭐⭐⭐ |\r\n| 红三兵 | 反转（看涨） | 70-75% | ⭐⭐⭐⭐ |\r\n| 射击之星 | 反转（看跌） | 65-70% | ⭐⭐⭐⭐ |\r\n| 看跌吞没 | 反转（看跌） | 65-70% | ⭐⭐⭐⭐ |\r\n| 看涨吞没 | 反转（看涨） | 63-68% | ⭐⭐⭐⭐ |\r\n| 上升/下降三法 | 持续 | 65-70% | ⭐⭐⭐⭐ |\r\n| 锤子线 | 反转（看涨） | 60-65% | ⭐⭐⭐ |\r\n| 乌云盖顶 | 反转（看跌） | 60-65% | ⭐⭐⭐ |\r\n| 刺透形态 | 反转（看涨） | 60-64% | ⭐⭐⭐ |\r\n| 倒锤子线 | 反转（看涨） | 55-60% | ⭐⭐⭐ |\r\n| 上吊线 | 反转（看跌） | 55-60% | ⭐⭐⭐ |\r\n| 十字星 | 不确定 | ~50% | ⭐⭐ |\r\n\r\n---\r\n\r\n## 六、提高K线形态成功率的方法\r\n\r\n### 1. 结合趋势判断\r\n\r\n- 顺势交易成功率更高\r\n- 反转形态需在明确趋势末端出现\r\n\r\n### 2. 配合成交量\r\n\r\n- 放量突破更可靠\r\n- 缩量反转需谨慎\r\n\r\n### 3. 关注关键位置\r\n\r\n- 支撑/阻力位出现的形态更有效\r\n- 整数关口的形态意义更大\r\n\r\n### 4. 多周期验证\r\n\r\n- 大周期形态优先级更高\r\n- 多周期共振信号更可靠\r\n\r\n### 5. 等待确认\r\n\r\n- 不要在形态完成前入场\r\n- 等待后续K线确认\r\n\r\n---\r\n\r\n## 七、重要提示\r\n\r\n1. **成功率仅供参考**：以上数据来源于历史统计，实际交易中会因市场环境、品种特性等因素有所不同。\r\n\r\n2. **不要单独使用K线形态**：应结合其他技术指标（均线、MACD、RSI等）和基本面分析。\r\n\r\n3. **严格止损**：即使是高成功率的形态也可能失败，必须设置止损保护资金。\r\n\r\n4. **仓位管理**：根据形态可靠性调整仓位大小，高可靠性形态可适当加大仓位。\r\n\r\n5. **持续学习**：在实盘中不断验证和总结，形成自己的交易系统。', NULL, NULL, 1, 1, 1, '2025-12-20 22:52:16', '2025-12-20 22:52:16'), (2, 2, '支撑阻力位识别与交易策略', '详解支撑阻力的形成原理、识别方法和实战交易策略', 'markdown', '# 支撑阻力位识别与交易策略\r\n\r\n## 一、支撑位与阻力位的本质\r\n\r\n### 1. 什么是支撑位\r\n\r\n**定义**：价格下跌过程中，买方力量集中的价格区域，能够阻止价格继续下跌。\r\n\r\n**形成原因**：\r\n- 前期低点：交易者记忆中的\"便宜价格\"\r\n- 整数关口：心理价位（如BTC的50000、60000）\r\n- 均线位置：MA20、MA50、MA200等\r\n- 斐波那契回撤位：38.2%、50%、61.8%\r\n\r\n### 2. 什么是阻力位\r\n\r\n**定义**：价格上涨过程中，卖方力量集中的价格区域，能够阻止价格继续上涨。\r\n\r\n**形成原因**：\r\n- 前期高点：套牢盘解套卖出\r\n- 整数关口：获利了结心理\r\n- 下降趋势线：技术性卖压\r\n- 前期成交密集区：筹码堆积\r\n\r\n---\r\n\r\n## 二、识别支撑阻力的方法\r\n\r\n### 1. 水平支撑阻力\r\n\r\n**识别要点**：\r\n- 找出价格多次触及但未突破的水平线\r\n- 触及次数越多，该位置越重要\r\n- 时间跨度越长，有效性越强\r\n\r\n**有效性评估**：\r\n| 触及次数 | 时间跨度 | 有效性 |\r\n|---------|---------|--------|\r\n| 2次 | < 1周 | 弱 |\r\n| 3次 | 1-4周 | 中 |\r\n| 4次+ | > 1月 | 强 |\r\n\r\n### 2. 动态支撑阻力\r\n\r\n**常用均线**：\r\n- MA7/MA20：短期支撑阻力\r\n- MA50：中期趋势参考\r\n- MA200：长期牛熊分界线\r\n\r\n**使用技巧**：\r\n- 上涨趋势中，均线是支撑\r\n- 下跌趋势中，均线是阻力\r\n- 多条均线汇聚处更有效\r\n\r\n### 3. 趋势线支撑阻力\r\n\r\n**绘制规则**：\r\n- 上升趋势线：连接两个以上的低点\r\n- 下降趋势线：连接两个以上的高点\r\n- 至少需要3个触点才算有效\r\n\r\n---\r\n\r\n## 三、支撑阻力的转换\r\n\r\n### 核心原则：突破后角色互换\r\n\r\n**支撑变阻力**：\r\n- 价格跌破支撑位后\r\n- 原支撑位变成新的阻力位\r\n- 反弹到该位置容易受阻\r\n\r\n**阻力变支撑**：\r\n- 价格突破阻力位后\r\n- 原阻力位变成新的支撑位\r\n- 回踩该位置容易获得支撑\r\n\r\n### 实战应用\r\n\r\n```\r\n突破买入策略：\r\n1. 价格突破阻力位\r\n2. 等待回踩确认（原阻力变支撑）\r\n3. 在支撑位附近入场做多\r\n4. 止损设在支撑位下方\r\n```\r\n\r\n---\r\n\r\n## 四、交易策略\r\n\r\n### 1. 支撑位做多策略\r\n\r\n**入场条件**：\r\n- 价格回落到重要支撑位\r\n- 出现看涨K线形态（锤子线、吞没等）\r\n- 成交量萎缩后放量\r\n\r\n**止损设置**：支撑位下方1-2%\r\n\r\n**止盈目标**：前期高点或下一阻力位\r\n\r\n### 2. 阻力位做空策略\r\n\r\n**入场条件**：\r\n- 价格上涨到重要阻力位\r\n- 出现看跌K线形态（射击之星、吞没等）\r\n- 上涨动能减弱\r\n\r\n**止损设置**：阻力位上方1-2%\r\n\r\n**止盈目标**：前期低点或下一支撑位\r\n\r\n### 3. 突破交易策略\r\n\r\n**有效突破特征**：\r\n- 收盘价突破（非影线突破）\r\n- 突破时成交量放大\r\n- 突破幅度超过1-3%\r\n\r\n**假突破识别**：\r\n- 仅影线突破，收盘回到区间内\r\n- 突破时成交量萎缩\r\n- 快速回落到原区间\r\n\r\n---\r\n\r\n## 五、实战技巧\r\n\r\n### 1. 支撑阻力是区域而非精确点位\r\n\r\n- 不要期望价格精确触及某个价格\r\n- 应该将支撑阻力视为一个区域（±1-2%）\r\n- 在区域内分批建仓更安全\r\n\r\n### 2. 结合多重确认\r\n\r\n- 水平支撑 + 均线支撑 = 更强支撑\r\n- 阻力位 + 斐波那契位 = 更强阻力\r\n- 多重确认提高交易成功率\r\n\r\n### 3. 关注突破后的回踩\r\n\r\n- 真正的突破往往会有回踩确认\r\n- 回踩不破是最佳入场时机\r\n- 回踩跌破说明是假突破\r\n\r\n---\r\n\r\n## 六、常见错误\r\n\r\n1. **过度依赖单一支撑阻力**：应结合多个因素判断\r\n2. **忽视时间周期**：大周期的支撑阻力更重要\r\n3. **不设止损**：支撑阻力可能被突破，必须止损\r\n4. **追涨杀跌**：应该在支撑买入，在阻力卖出\r\n5. **频繁交易**：只在重要位置交易，减少噪音干扰', NULL, NULL, 1, 1, 1, '2025-12-20 23:56:13', '2025-12-20 23:56:13'), (3, 3, '移动平均线完全指南', '深入讲解均线原理、常用均线组合和实战交易系统', 'markdown', '# 移动平均线完全指南\r\n\r\n## 一、均线基础知识\r\n\r\n### 1. SMA vs EMA\r\n\r\n**简单移动平均线（SMA）**：\r\n- 计算方式：N日收盘价之和 ÷ N\r\n- 特点：平滑，反应较慢\r\n- 适用：判断长期趋势\r\n\r\n**指数移动平均线（EMA）**：\r\n- 计算方式：给近期价格更高权重\r\n- 特点：灵敏，反应较快\r\n- 适用：短期交易信号\r\n\r\n### 2. 常用均线周期\r\n\r\n| 周期 | 用途 | 适用场景 |\r\n|-----|------|---------|\r\n| MA7 | 超短期趋势 | 日内交易 |\r\n| MA20 | 短期趋势 | 波段交易 |\r\n| MA50 | 中期趋势 | 趋势跟踪 |\r\n| MA100 | 中长期趋势 | 趋势确认 |\r\n| MA200 | 长期趋势 | 牛熊分界 |\r\n\r\n---\r\n\r\n## 二、均线的核心用法\r\n\r\n### 1. 趋势判断\r\n\r\n**多头排列**：\r\n- MA7 > MA20 > MA50 > MA200\r\n- 价格在所有均线上方\r\n- 表示强势上涨趋势\r\n\r\n**空头排列**：\r\n- MA7 < MA20 < MA50 < MA200\r\n- 价格在所有均线下方\r\n- 表示强势下跌趋势\r\n\r\n### 2. 金叉与死叉\r\n\r\n**金叉（买入信号）**：\r\n- 短期均线上穿长期均线\r\n- 常用组合：MA7上穿MA20、MA20上穿MA50\r\n- 在零轴上方的金叉更可靠\r\n\r\n**死叉（卖出信号）**：\r\n- 短期均线下穿长期均线\r\n- 常用组合：MA7下穿MA20、MA20下穿MA50\r\n- 在零轴下方的死叉更可靠\r\n\r\n### 3. 均线支撑与阻力\r\n\r\n**上涨趋势中**：\r\n- 均线是动态支撑\r\n- 价格回踩均线是买入机会\r\n- MA20是最常用的回踩均线\r\n\r\n**下跌趋势中**：\r\n- 均线是动态阻力\r\n- 价格反弹到均线是卖出机会\r\n- 反弹不过均线继续看跌\r\n\r\n---\r\n\r\n## 三、经典均线交易系统\r\n\r\n### 1. 双均线系统\r\n\r\n**参数设置**：MA20 + MA50\r\n\r\n**交易规则**：\r\n- MA20上穿MA50：买入\r\n- MA20下穿MA50：卖出\r\n- 价格在双均线上方持有\r\n\r\n**优点**：简单易执行\r\n**缺点**：震荡市假信号多\r\n\r\n### 2. 三均线系统\r\n\r\n**参数设置**：MA7 + MA20 + MA50\r\n\r\n**交易规则**：\r\n- 三线多头排列：做多\r\n- 三线空头排列：做空\r\n- MA7回踩MA20是加仓点\r\n\r\n### 3. 葛兰碧八大法则\r\n\r\n**四个买入信号**：\r\n1. 均线由下降转为走平或上升，价格从下方突破均线\r\n2. 价格跌破均线后快速回升突破均线\r\n3. 价格在均线上方回落但未跌破均线又上涨\r\n4. 价格跌破均线后远离均线，可能反弹\r\n\r\n**四个卖出信号**：\r\n1. 均线由上升转为走平或下降，价格从上方跌破均线\r\n2. 价格突破均线后快速回落跌破均线\r\n3. 价格在均线下方反弹但未突破均线又下跌\r\n4. 价格突破均线后远离均线，可能回调\r\n\r\n---\r\n\r\n## 四、均线的局限性\r\n\r\n### 1. 滞后性\r\n\r\n- 均线是滞后指标\r\n- 信号出现时趋势可能已走完一段\r\n- 解决方案：结合其他领先指标\r\n\r\n### 2. 震荡市失效\r\n\r\n- 横盘震荡时频繁金叉死叉\r\n- 产生大量假信号\r\n- 解决方案：加入趋势过滤条件\r\n\r\n### 3. 参数敏感\r\n\r\n- 不同参数效果差异大\r\n- 没有万能参数\r\n- 解决方案：根据品种和周期调整\r\n\r\n---\r\n\r\n## 五、实战建议\r\n\r\n1. **大周期定方向**：先看日线/周线均线排列\r\n2. **小周期找入场**：在4小时/1小时找具体入场点\r\n3. **均线+K线形态**：均线附近出现反转K线再入场\r\n4. **严格止损**：跌破关键均线止损出场\r\n5. **顺势交易**：只在均线多头排列时做多', NULL, NULL, 1, 1, 1, '2025-12-20 23:56:13', '2025-12-20 23:56:13'), (4, 4, 'MACD指标深度解析与实战应用', '全面讲解MACD的计算原理、信号识别和背离交易策略', 'markdown', '# MACD指标深度解析与实战应用\r\n\r\n## 一、MACD基础原理\r\n\r\n### 1. MACD的组成\r\n\r\n**DIF线（快线）**：\r\n- 计算：EMA12 - EMA26\r\n- 反映短期与中期趋势的差异\r\n- 快速反应价格变化\r\n\r\n**DEA线（慢线）**：\r\n- 计算：DIF的9日EMA\r\n- 对DIF进行平滑处理\r\n- 产生交叉信号\r\n\r\n**MACD柱状图**：\r\n- 计算：(DIF - DEA) × 2\r\n- 红柱：DIF > DEA，多头动能\r\n- 绿柱：DIF < DEA，空头动能\r\n\r\n### 2. 零轴的意义\r\n\r\n**零轴上方**：\r\n- DIF > 0，短期均线在长期均线上方\r\n- 市场处于多头趋势\r\n- 做多为主\r\n\r\n**零轴下方**：\r\n- DIF < 0，短期均线在长期均线下方\r\n- 市场处于空头趋势\r\n- 做空或观望\r\n\r\n---\r\n\r\n## 二、MACD交易信号\r\n\r\n### 1. 金叉与死叉\r\n\r\n**金叉买入信号**：\r\n- DIF上穿DEA\r\n- 零轴上方金叉：强势买入信号\r\n- 零轴下方金叉：弱势反弹信号\r\n\r\n**死叉卖出信号**：\r\n- DIF下穿DEA\r\n- 零轴下方死叉：强势卖出信号\r\n- 零轴上方死叉：弱势回调信号\r\n\r\n### 2. 柱状图信号\r\n\r\n**红柱变化**：\r\n- 红柱放大：多头动能增强\r\n- 红柱缩小：多头动能减弱\r\n- 红柱转绿：趋势可能反转\r\n\r\n**绿柱变化**：\r\n- 绿柱放大：空头动能增强\r\n- 绿柱缩小：空头动能减弱\r\n- 绿柱转红：趋势可能反转\r\n\r\n---\r\n\r\n## 三、MACD背离（核心技术）\r\n\r\n### 1. 顶背离（看跌信号）\r\n\r\n**定义**：价格创新高，但MACD未创新高\r\n\r\n**识别要点**：\r\n- 价格形成更高的高点\r\n- DIF或MACD柱形成更低的高点\r\n- 通常出现在上涨趋势末端\r\n\r\n**交易策略**：\r\n- 出现顶背离后减仓或平仓\r\n- 等待MACD死叉确认后做空\r\n- 止损设在新高上方\r\n\r\n**成功率**：约65-75%\r\n\r\n### 2. 底背离（看涨信号）\r\n\r\n**定义**：价格创新低，但MACD未创新低\r\n\r\n**识别要点**：\r\n- 价格形成更低的低点\r\n- DIF或MACD柱形成更高的低点\r\n- 通常出现在下跌趋势末端\r\n\r\n**交易策略**：\r\n- 出现底背离后关注买入机会\r\n- 等待MACD金叉确认后做多\r\n- 止损设在新低下方\r\n\r\n**成功率**：约60-70%\r\n\r\n### 3. 隐藏背离\r\n\r\n**隐藏顶背离**：\r\n- 价格形成更低的高点\r\n- MACD形成更高的高点\r\n- 预示下跌趋势延续\r\n\r\n**隐藏底背离**：\r\n- 价格形成更高的低点\r\n- MACD形成更低的低点\r\n- 预示上涨趋势延续\r\n\r\n---\r\n\r\n## 四、MACD实战技巧\r\n\r\n### 1. 多周期MACD分析\r\n\r\n**周线MACD**：\r\n- 判断大趋势方向\r\n- 金叉做多，死叉做空\r\n\r\n**日线MACD**：\r\n- 寻找入场时机\r\n- 与周线方向一致时入场\r\n\r\n**4小时MACD**：\r\n- 精确入场点位\r\n- 短线交易参考\r\n\r\n### 2. MACD + 其他指标\r\n\r\n**MACD + 均线**：\r\n- MACD金叉 + 价格站上MA20 = 强买入\r\n- MACD死叉 + 价格跌破MA20 = 强卖出\r\n\r\n**MACD + RSI**：\r\n- MACD底背离 + RSI超卖 = 高概率反转\r\n- MACD顶背离 + RSI超买 = 高概率见顶\r\n\r\n### 3. 柱状图缩头战法\r\n\r\n**红柱缩头**：\r\n- 红柱开始缩小\r\n- 预示上涨动能减弱\r\n- 可以考虑减仓\r\n\r\n**绿柱缩头**：\r\n- 绿柱开始缩小\r\n- 预示下跌动能减弱\r\n- 可以考虑建仓\r\n\r\n---\r\n\r\n## 五、MACD的局限性\r\n\r\n1. **滞后性**：信号出现时趋势可能已走完一段\r\n2. **震荡市失效**：横盘时频繁金叉死叉\r\n3. **背离不一定反转**：可能出现多次背离后才反转\r\n4. **参数固定**：默认参数不一定适合所有品种\r\n\r\n---\r\n\r\n## 六、MACD交易系统示例\r\n\r\n```\r\n入场条件：\r\n1. 周线MACD在零轴上方（大趋势向上）\r\n2. 日线MACD金叉\r\n3. 价格站上MA20\r\n4. 出现看涨K线形态\r\n\r\n出场条件：\r\n1. 日线MACD死叉\r\n2. 或价格跌破MA20\r\n3. 或达到目标止盈位\r\n\r\n止损设置：\r\n- 入场价下方2-3%\r\n- 或前期低点下方\r\n```', NULL, NULL, 1, 1, 1, '2025-12-20 23:56:13', '2025-12-20 23:56:13'), (5, 5, 'RSI与布林带实战指南', '详解RSI超买超卖、布林带突破策略及组合应用', 'markdown', '# RSI与布林带实战指南\r\n\r\n## 一、RSI指标详解\r\n\r\n### 1. RSI基础知识\r\n\r\n**计算公式**：\r\nRSI = 100 - 100/(1 + RS)\r\nRS = N日内上涨平均值 / N日内下跌平均值\r\n\r\n**常用参数**：\r\n- RSI(14)：最常用，平衡灵敏度和稳定性\r\n- RSI(7)：更灵敏，适合短线\r\n- RSI(21)：更稳定，适合中长线\r\n\r\n### 2. RSI区域划分\r\n\r\n| RSI值 | 区域 | 市场状态 |\r\n|------|------|---------|\r\n| > 80 | 极度超买 | 强烈卖出信号 |\r\n| 70-80 | 超买区 | 注意风险 |\r\n| 30-70 | 正常区 | 趋势延续 |\r\n| 20-30 | 超卖区 | 关注买入 |\r\n| < 20 | 极度超卖 | 强烈买入信号 |\r\n\r\n### 3. RSI交易信号\r\n\r\n**超买超卖策略**：\r\n- RSI > 70 后回落跌破70：卖出信号\r\n- RSI < 30 后反弹突破30：买入信号\r\n- 注意：强势趋势中RSI可能长期超买/超卖\r\n\r\n**RSI背离**：\r\n- 价格新高，RSI未新高：顶背离，看跌\r\n- 价格新低，RSI未新低：底背离，看涨\r\n- 背离是RSI最有价值的信号\r\n\r\n**RSI中轴线**：\r\n- RSI > 50：多头占优\r\n- RSI < 50：空头占优\r\n- RSI突破/跌破50是趋势确认信号\r\n\r\n---\r\n\r\n## 二、布林带详解\r\n\r\n### 1. 布林带组成\r\n\r\n**中轨**：20日简单移动平均线（MA20）\r\n**上轨**：中轨 + 2倍标准差\r\n**下轨**：中轨 - 2倍标准差\r\n\r\n**带宽**：(上轨 - 下轨) / 中轨\r\n- 带宽收窄：波动率降低，即将突破\r\n- 带宽扩张：波动率增加，趋势形成\r\n\r\n### 2. 布林带形态\r\n\r\n**收口形态（Squeeze）**：\r\n- 上下轨距离缩小\r\n- 表示市场处于盘整\r\n- 预示即将出现大行情\r\n\r\n**开口形态**：\r\n- 上下轨距离扩大\r\n- 表示趋势正在形成\r\n- 顺势交易的好时机\r\n\r\n**喇叭口形态**：\r\n- 上下轨急剧扩张\r\n- 表示波动剧烈\r\n- 注意风险控制\r\n\r\n### 3. 布林带交易策略\r\n\r\n**突破策略**：\r\n- 价格突破上轨：可能开启上涨趋势\r\n- 价格跌破下轨：可能开启下跌趋势\r\n- 需要成交量配合确认\r\n\r\n**回归策略**：\r\n- 价格触及上轨后回落：短线卖出\r\n- 价格触及下轨后反弹：短线买入\r\n- 适用于震荡市场\r\n\r\n**中轨策略**：\r\n- 价格站上中轨：看多\r\n- 价格跌破中轨：看空\r\n- 中轨是趋势分界线\r\n\r\n---\r\n\r\n## 三、RSI + 布林带组合策略\r\n\r\n### 1. 超卖 + 下轨买入\r\n\r\n**入场条件**：\r\n- RSI < 30（超卖）\r\n- 价格触及布林带下轨\r\n- 出现看涨K线形态\r\n\r\n**止损**：下轨下方1-2%\r\n**止盈**：中轨或上轨\r\n\r\n### 2. 超买 + 上轨卖出\r\n\r\n**入场条件**：\r\n- RSI > 70（超买）\r\n- 价格触及布林带上轨\r\n- 出现看跌K线形态\r\n\r\n**止损**：上轨上方1-2%\r\n**止盈**：中轨或下轨\r\n\r\n### 3. 背离 + 布林带确认\r\n\r\n**底部信号**：\r\n- RSI底背离\r\n- 价格在布林带下轨附近\r\n- 布林带开始收口\r\n\r\n**顶部信号**：\r\n- RSI顶背离\r\n- 价格在布林带上轨附近\r\n- 布林带开始收口\r\n\r\n---\r\n\r\n## 四、实战技巧\r\n\r\n### 1. RSI使用技巧\r\n\r\n- 强势上涨中，RSI可能长期在50-80区间\r\n- 强势下跌中，RSI可能长期在20-50区间\r\n- 不要机械地在70卖出、30买入\r\n- 结合趋势判断更重要\r\n\r\n### 2. 布林带使用技巧\r\n\r\n- 布林带收口后的突破方向很重要\r\n- 沿着上轨/下轨运行是强势信号\r\n- 价格回到中轨是趋势减弱信号\r\n- 假突破后往往反向运动\r\n\r\n### 3. 多周期分析\r\n\r\n- 大周期确定方向\r\n- 小周期寻找入场点\r\n- RSI和布林带在不同周期的共振更可靠\r\n\r\n---\r\n\r\n## 五、常见错误\r\n\r\n1. **逆势抄底摸顶**：超买可以更超买，超卖可以更超卖\r\n2. **忽视趋势**：震荡指标在趋势市中容易失效\r\n3. **单一指标决策**：应结合多个指标和K线形态\r\n4. **不设止损**：任何策略都可能失败\r\n5. **过度交易**：只在高概率信号出现时交易', NULL, NULL, 1, 1, 1, '2025-12-20 23:56:13', '2025-12-20 23:56:13'), (6, 6, '成交量分析与量价关系', '深入讲解成交量的意义、量价配合原则和实战应用', 'markdown', '# 成交量分析与量价关系\r\n\r\n## 一、成交量基础\r\n\r\n### 1. 成交量的意义\r\n\r\n**成交量代表**：\r\n- 市场参与度\r\n- 资金流入流出\r\n- 多空双方的博弈强度\r\n\r\n**核心原则**：\r\n- 量是价的先行指标\r\n- 没有成交量配合的价格变动不可靠\r\n- 成交量是验证趋势的重要工具\r\n\r\n### 2. 成交量的类型\r\n\r\n| 类型 | 特征 | 含义 |\r\n|-----|------|------|\r\n| 放量 | 成交量明显放大 | 市场活跃，趋势可能延续或反转 |\r\n| 缩量 | 成交量明显萎缩 | 市场观望，趋势可能减弱 |\r\n| 天量 | 历史级别大成交量 | 可能是阶段性顶部或底部 |\r\n| 地量 | 极度萎缩的成交量 | 可能是底部信号 |\r\n\r\n---\r\n\r\n## 二、量价关系核心法则\r\n\r\n### 1. 量价配合（健康趋势）\r\n\r\n**上涨放量**：\r\n- 价格上涨，成交量放大\r\n- 说明买方积极，上涨有支撑\r\n- 趋势健康，可以持有或加仓\r\n\r\n**下跌缩量**：\r\n- 价格下跌，成交量萎缩\r\n- 说明卖压不大，只是正常回调\r\n- 回调结束后可能继续上涨\r\n\r\n### 2. 量价背离（趋势警告）\r\n\r\n**上涨缩量**：\r\n- 价格上涨，成交量萎缩\r\n- 说明买方力量减弱\r\n- 上涨可能难以持续\r\n\r\n**下跌放量**：\r\n- 价格下跌，成交量放大\r\n- 说明卖压沉重\r\n- 下跌可能加速\r\n\r\n### 3. 特殊量价形态\r\n\r\n**天量天价**：\r\n- 成交量创新高，价格也创新高\r\n- 可能是阶段性顶部\r\n- 主力可能在出货\r\n\r\n**地量地价**：\r\n- 成交量极度萎缩，价格处于低位\r\n- 可能是阶段性底部\r\n- 卖方力量耗尽\r\n\r\n---\r\n\r\n## 三、成交量形态分析\r\n\r\n### 1. 堆量\r\n\r\n**特征**：成交量逐步放大，形成\"量堆\"\r\n\r\n**含义**：\r\n- 上涨中堆量：主力在吸筹或拉升\r\n- 下跌中堆量：主力在出货\r\n\r\n### 2. 突放巨量\r\n\r\n**特征**：某一天成交量突然放大数倍\r\n\r\n**含义**：\r\n- 上涨中突放巨量：可能见顶\r\n- 下跌中突放巨量：可能见底（恐慌盘）\r\n- 需要结合位置判断\r\n\r\n### 3. 缩量整理\r\n\r\n**特征**：价格横盘，成交量持续萎缩\r\n\r\n**含义**：\r\n- 上涨后缩量整理：蓄势待涨\r\n- 下跌后缩量整理：可能筑底\r\n- 等待放量突破方向\r\n\r\n---\r\n\r\n## 四、成交量实战策略\r\n\r\n### 1. 放量突破买入\r\n\r\n**条件**：\r\n- 价格突破重要阻力位\r\n- 成交量明显放大（至少1.5倍以上）\r\n- 收盘价站稳突破位\r\n\r\n**操作**：\r\n- 突破当日或次日买入\r\n- 止损设在突破位下方\r\n- 目标看前期高点\r\n\r\n### 2. 缩量回踩买入\r\n\r\n**条件**：\r\n- 上涨趋势中的回调\r\n- 回调时成交量萎缩\r\n- 价格回到支撑位\r\n\r\n**操作**：\r\n- 在支撑位附近买入\r\n- 止损设在支撑位下方\r\n- 目标看前期高点\r\n\r\n### 3. 放量滞涨卖出\r\n\r\n**条件**：\r\n- 价格在高位\r\n- 成交量放大但价格不涨\r\n- 可能出现长上影线\r\n\r\n**操作**：\r\n- 减仓或清仓\r\n- 等待回调后再判断\r\n- 可能是主力出货\r\n\r\n---\r\n\r\n## 五、加密货币成交量特点\r\n\r\n### 1. 24小时交易\r\n\r\n- 没有开盘收盘概念\r\n- 成交量分布更均匀\r\n- 关注UTC时间的日成交量\r\n\r\n### 2. 多交易所分散\r\n\r\n- 成交量分散在多个交易所\r\n- 需要看聚合数据\r\n- 单一交易所数据可能失真\r\n\r\n### 3. 合约与现货\r\n\r\n- 合约成交量通常大于现货\r\n- 关注现货成交量更有参考价值\r\n- 合约成交量反映投机情绪\r\n\r\n---\r\n\r\n## 六、成交量指标\r\n\r\n### 1. OBV（能量潮）\r\n\r\n**计算**：\r\n- 上涨日：OBV = 前日OBV + 当日成交量\r\n- 下跌日：OBV = 前日OBV - 当日成交量\r\n\r\n**用法**：\r\n- OBV上升：资金流入\r\n- OBV下降：资金流出\r\n- OBV与价格背离是重要信号\r\n\r\n### 2. 成交量均线\r\n\r\n**常用参数**：5日、10日、20日\r\n\r\n**用法**：\r\n- 成交量 > 均线：放量\r\n- 成交量 < 均线：缩量\r\n- 均线金叉死叉判断量能趋势\r\n\r\n---\r\n\r\n## 七、实战要点\r\n\r\n1. **量在价先**：成交量变化往往领先于价格\r\n2. **突破看量**：有效突破必须有成交量配合\r\n3. **顶部放量**：高位放量要警惕\r\n4. **底部缩量**：低位缩量可能是底部\r\n5. **结合位置**：同样的量在不同位置含义不同', NULL, NULL, 1, 1, 1, '2025-12-20 23:56:13', '2025-12-20 23:56:13'), (7, 7, '加密货币基本面与消息面分析框架', '系统讲解影响加密货币的宏观因素、消息面解读和分析框架', 'markdown', '# 加密货币基本面与消息面分析框架\r\n\r\n## 一、宏观经济因素\r\n\r\n### 1. 美联储政策\r\n\r\n**利率决议**：\r\n- 加息：利空加密货币（资金流向传统市场）\r\n- 降息：利好加密货币（流动性增加）\r\n- 维持不变：看市场预期\r\n\r\n**量化宽松/紧缩**：\r\n- QE（印钱）：利好加密货币\r\n- QT（缩表）：利空加密货币\r\n\r\n**关注时间**：\r\n- FOMC会议（每年8次）\r\n- 美联储主席讲话\r\n- 会议纪要发布\r\n\r\n### 2. 美元指数（DXY）\r\n\r\n**负相关关系**：\r\n- DXY上涨 → BTC通常下跌\r\n- DXY下跌 → BTC通常上涨\r\n\r\n**关注要点**：\r\n- DXY突破关键位置\r\n- DXY与BTC的背离\r\n- 美元强弱周期\r\n\r\n### 3. 美股走势\r\n\r\n**正相关关系**：\r\n- 纳斯达克与BTC高度相关\r\n- 美股大跌时BTC通常跟跌\r\n- 风险偏好影响两者\r\n\r\n**关注指标**：\r\n- 纳斯达克指数\r\n- 标普500指数\r\n- VIX恐慌指数\r\n\r\n### 4. 重要经济数据\r\n\r\n| 数据 | 发布时间 | 影响 |\r\n|-----|---------|------|\r\n| CPI通胀 | 每月中旬 | 高通胀利好BTC |\r\n| 非农就业 | 每月第一个周五 | 影响美联储决策 |\r\n| GDP | 每季度 | 经济健康度 |\r\n| PMI | 每月初 | 经济景气度 |\r\n\r\n---\r\n\r\n## 二、加密货币行业因素\r\n\r\n### 1. 监管政策\r\n\r\n**利好消息**：\r\n- ETF获批\r\n- 国家承认合法地位\r\n- 机构入场政策放开\r\n\r\n**利空消息**：\r\n- 交易所被起诉\r\n- 国家禁止交易\r\n- 稳定币监管收紧\r\n\r\n**关注地区**：\r\n- 美国SEC/CFTC动态\r\n- 中国政策变化\r\n- 欧盟MiCA法规\r\n\r\n### 2. 技术发展\r\n\r\n**比特币**：\r\n- 减半事件（约4年一次）\r\n- 闪电网络发展\r\n- Taproot等升级\r\n\r\n**以太坊**：\r\n- 合并（PoS转型）\r\n- Layer2发展\r\n- EIP提案\r\n\r\n### 3. 机构动态\r\n\r\n**关注对象**：\r\n- MicroStrategy持仓变化\r\n- 灰度GBTC流入流出\r\n- 贝莱德等传统机构动态\r\n\r\n**影响分析**：\r\n- 机构买入：长期利好\r\n- 机构卖出：短期利空\r\n- 新机构入场：市场信心增强\r\n\r\n---\r\n\r\n## 三、消息面分析框架\r\n\r\n### 1. 消息分类\r\n\r\n**按影响程度**：\r\n- 重大消息：ETF、减半、重大监管\r\n- 中等消息：交易所上币、合作公告\r\n- 轻微消息：日常新闻、小项目动态\r\n\r\n**按时效性**：\r\n- 突发消息：需要快速反应\r\n- 预期消息：提前布局\r\n- 长期趋势：影响大方向\r\n\r\n### 2. 消息解读原则\r\n\r\n**买预期，卖事实**：\r\n- 利好消息公布前上涨\r\n- 消息落地后可能回调\r\n- 典型案例：ETF获批前后\r\n\r\n**市场已经Price In**：\r\n- 预期内的消息影响有限\r\n- 超预期的消息影响大\r\n- 关注市场预期差\r\n\r\n**消息的持续性**：\r\n- 一次性消息：影响短暂\r\n- 持续性消息：影响深远\r\n- 判断消息的长期影响\r\n\r\n### 3. 消息来源\r\n\r\n**官方渠道**：\r\n- 项目官方Twitter/Blog\r\n- 交易所公告\r\n- 监管机构官网\r\n\r\n**媒体渠道**：\r\n- CoinDesk、The Block\r\n- 彭博社、路透社\r\n- 中文媒体：金色财经等\r\n\r\n**社交媒体**：\r\n- Twitter加密KOL\r\n- Reddit、Discord社区\r\n- 注意辨别真假消息\r\n\r\n---\r\n\r\n## 四、建立分析框架\r\n\r\n### 1. 每日分析清单\r\n\r\n```\r\n□ 美股期货/亚盘表现\r\n□ DXY走势\r\n□ 重要经济数据发布\r\n□ 加密货币新闻头条\r\n□ 链上数据异常\r\n□ 社交媒体情绪\r\n```\r\n\r\n### 2. 每周分析清单\r\n\r\n```\r\n□ 美联储官员讲话\r\n□ 重要经济数据回顾\r\n□ 监管政策动态\r\n□ 机构持仓变化\r\n□ 技术发展进展\r\n□ 市场情绪指标\r\n```\r\n\r\n### 3. 消息影响评估\r\n\r\n**评估维度**：\r\n1. 消息真实性（来源可靠吗？）\r\n2. 影响范围（整个市场还是单个币种？）\r\n3. 影响时长（短期还是长期？）\r\n4. 市场预期（是否已经Price In？）\r\n5. 当前位置（高位利好还是低位利好？）\r\n\r\n---\r\n\r\n## 五、实战建议\r\n\r\n### 1. 不要追消息\r\n\r\n- 消息出来时往往已经晚了\r\n- 主力可能借消息出货\r\n- 等待市场消化后再决策\r\n\r\n### 2. 技术面优先\r\n\r\n- 消息面辅助判断\r\n- 技术面决定入场点\r\n- 两者结合效果最好\r\n\r\n### 3. 建立信息渠道\r\n\r\n- 关注可靠的信息源\r\n- 过滤噪音信息\r\n- 培养信息敏感度\r\n\r\n### 4. 记录和复盘\r\n\r\n- 记录重要消息和市场反应\r\n- 总结消息与价格的关系\r\n- 提高消息解读能力', NULL, NULL, 1, 1, 1, '2025-12-20 23:56:13', '2025-12-20 23:56:13'), (8, 8, '链上数据分析入门指南', '系统介绍链上数据类型、常用指标和分析工具', 'markdown', '# 链上数据分析入门指南\r\n\r\n## 一、链上数据概述\r\n\r\n### 1. 什么是链上数据\r\n\r\n**定义**：记录在区块链上的所有交易和地址信息\r\n\r\n**特点**：\r\n- 公开透明：任何人都可以查看\r\n- 不可篡改：数据真实可靠\r\n- 实时更新：反映最新市场动态\r\n\r\n**价值**：\r\n- 了解大户/机构动向\r\n- 判断市场供需关系\r\n- 预测价格走势\r\n\r\n### 2. 链上数据类型\r\n\r\n| 类型 | 内容 | 用途 |\r\n|-----|------|------|\r\n| 交易数据 | 转账记录、交易量 | 判断市场活跃度 |\r\n| 地址数据 | 持币地址、活跃地址 | 判断用户增长 |\r\n| 交易所数据 | 流入流出、余额 | 判断买卖压力 |\r\n| 矿工数据 | 算力、持仓 | 判断矿工行为 |\r\n| 巨鲸数据 | 大户持仓、转账 | 跟踪聪明钱 |\r\n\r\n---\r\n\r\n## 二、核心链上指标\r\n\r\n### 1. 交易所流入流出\r\n\r\n**交易所净流入**：\r\n- 净流入 > 0：币流入交易所，可能卖出，利空\r\n- 净流入 < 0：币流出交易所，可能囤币，利好\r\n\r\n**关注要点**：\r\n- 大额流入可能预示抛压\r\n- 持续流出表示长期持有意愿\r\n- 结合价格位置判断\r\n\r\n### 2. 交易所余额\r\n\r\n**余额变化**：\r\n- 余额增加：潜在卖压增加\r\n- 余额减少：潜在卖压减少\r\n\r\n**历史对比**：\r\n- 当前余额 vs 历史高点\r\n- 余额占总供应量比例\r\n- 长期趋势判断\r\n\r\n### 3. 活跃地址数\r\n\r\n**定义**：每日参与交易的唯一地址数量\r\n\r\n**解读**：\r\n- 活跃地址增加：网络使用增加，利好\r\n- 活跃地址减少：网络活跃度下降\r\n- 与价格背离是重要信号\r\n\r\n### 4. 新增地址数\r\n\r\n**定义**：每日新创建的地址数量\r\n\r\n**解读**：\r\n- 新增地址增加：新用户入场\r\n- 新增地址减少：市场热度下降\r\n- 牛市通常伴随新增地址激增\r\n\r\n---\r\n\r\n## 三、高级链上指标\r\n\r\n### 1. MVRV比率\r\n\r\n**计算**：市值 / 已实现市值\r\n\r\n**解读**：\r\n- MVRV > 3.5：市场过热，可能见顶\r\n- MVRV < 1：市场低估，可能见底\r\n- MVRV = 1：市值等于成本价\r\n\r\n**历史数据**：\r\n- 2017年顶部：MVRV ≈ 4.5\r\n- 2021年顶部：MVRV ≈ 3.5\r\n- 熊市底部：MVRV ≈ 0.8-1\r\n\r\n### 2. SOPR（支出产出利润率）\r\n\r\n**计算**：卖出价格 / 买入价格\r\n\r\n**解读**：\r\n- SOPR > 1：卖出者盈利\r\n- SOPR < 1：卖出者亏损\r\n- SOPR = 1：盈亏平衡点\r\n\r\n**应用**：\r\n- 牛市中SOPR回落到1是买入机会\r\n- 熊市中SOPR反弹到1是卖出机会\r\n\r\n### 3. NUPL（未实现净盈亏）\r\n\r\n**计算**：(市值 - 已实现市值) / 市值\r\n\r\n**解读**：\r\n- NUPL > 0.75：极度贪婪，可能见顶\r\n- NUPL 0.5-0.75：乐观\r\n- NUPL 0.25-0.5：希望\r\n- NUPL 0-0.25：焦虑\r\n- NUPL < 0：投降，可能见底\r\n\r\n### 4. 长期持有者供应量\r\n\r\n**定义**：持币超过155天的地址持有量\r\n\r\n**解读**：\r\n- LTH供应增加：长期看好，利好\r\n- LTH供应减少：长期持有者卖出，利空\r\n- LTH行为往往领先于价格\r\n\r\n---\r\n\r\n## 四、巨鲸追踪\r\n\r\n### 1. 巨鲸定义\r\n\r\n**比特币**：\r\n- 持有 > 1000 BTC：巨鲸\r\n- 持有 > 10000 BTC：超级巨鲸\r\n\r\n**以太坊**：\r\n- 持有 > 10000 ETH：巨鲸\r\n\r\n### 2. 巨鲸行为分析\r\n\r\n**巨鲸买入信号**：\r\n- 大额从交易所流出\r\n- 巨鲸地址余额增加\r\n- 新巨鲸地址出现\r\n\r\n**巨鲸卖出信号**：\r\n- 大额流入交易所\r\n- 巨鲸地址余额减少\r\n- 休眠地址激活\r\n\r\n### 3. 追踪工具\r\n\r\n- Whale Alert（Twitter）\r\n- Glassnode巨鲸指标\r\n- Santiment巨鲸追踪\r\n\r\n---\r\n\r\n## 五、链上数据工具\r\n\r\n### 1. 免费工具\r\n\r\n| 工具 | 网址 | 特点 |\r\n|-----|------|------|\r\n| Glassnode | glassnode.com | 专业全面 |\r\n| CryptoQuant | cryptoquant.com | 交易所数据强 |\r\n| Santiment | santiment.net | 社交+链上 |\r\n| IntoTheBlock | intotheblock.com | 可视化好 |\r\n\r\n### 2. 使用建议\r\n\r\n**入门阶段**：\r\n- 先熟悉2-3个核心指标\r\n- 每日观察交易所流入流出\r\n- 关注MVRV和SOPR\r\n\r\n**进阶阶段**：\r\n- 建立自己的指标组合\r\n- 结合技术分析使用\r\n- 开发自己的分析框架\r\n\r\n---\r\n\r\n## 六、链上分析实战\r\n\r\n### 1. 判断市场周期\r\n\r\n**牛市特征**：\r\n- 交易所余额持续下降\r\n- 活跃地址持续增加\r\n- MVRV > 2\r\n- 长期持有者开始卖出\r\n\r\n**熊市特征**：\r\n- 交易所余额增加\r\n- 活跃地址减少\r\n- MVRV < 1\r\n- 长期持有者持续买入\r\n\r\n### 2. 寻找买卖点\r\n\r\n**买入信号**：\r\n- 交易所大额流出\r\n- MVRV接近1\r\n- SOPR < 1后反弹\r\n- 巨鲸开始买入\r\n\r\n**卖出信号**：\r\n- 交易所大额流入\r\n- MVRV > 3\r\n- SOPR持续 > 1\r\n- 巨鲸开始卖出\r\n\r\n### 3. 注意事项\r\n\r\n1. **链上数据有滞后性**：不适合短线交易\r\n2. **需要结合其他分析**：不能单独使用\r\n3. **数据可能被操纵**：大户可能故意制造假象\r\n4. **不同周期参考不同指标**：灵活运用\r\n5. **持续学习更新**：链上分析在不断发展', NULL, NULL, 1, 1, 1, '2025-12-20 23:56:13', '2025-12-20 23:56:13'), (9, 9, '交易系统构建完全指南', '系统讲解交易系统的组成要素、设计原则和构建方法', 'markdown', '# 交易系统构建完全指南\r\n\r\n## 一、什么是交易系统\r\n\r\n### 1. 定义\r\n\r\n**交易系统**：一套完整的、可执行的交易规则集合，包括市场选择、入场、出场、仓位管理和风险控制。\r\n\r\n**核心特点**：\r\n- 规则明确：每个决策都有明确标准\r\n- 可重复执行：不依赖主观判断\r\n- 可量化验证：能够回测和统计\r\n\r\n### 2. 为什么需要交易系统\r\n\r\n**没有系统的问题**：\r\n- 情绪化交易\r\n- 决策不一致\r\n- 无法复盘改进\r\n- 长期难以盈利\r\n\r\n**有系统的优势**：\r\n- 克服人性弱点\r\n- 保持交易一致性\r\n- 可以持续优化\r\n- 实现稳定盈利\r\n\r\n---\r\n\r\n## 二、交易系统的五大要素\r\n\r\n### 1. 市场选择\r\n\r\n**选择标准**：\r\n- 流动性好（BTC、ETH等主流币）\r\n- 波动适中（太小无利润，太大风险高）\r\n- 自己熟悉的品种\r\n\r\n**建议**：\r\n- 新手专注1-2个品种\r\n- 深入了解品种特性\r\n- 不要频繁切换\r\n\r\n### 2. 入场信号\r\n\r\n**技术面入场**：\r\n- K线形态（锤子线、吞没等）\r\n- 指标信号（MACD金叉、RSI超卖等）\r\n- 突破信号（阻力突破、趋势线突破）\r\n\r\n**入场规则示例**：\r\n```\r\n做多入场条件（全部满足）：\r\n1. 日线MA20 > MA50（趋势向上）\r\n2. 价格回踩MA20获得支撑\r\n3. 4小时MACD金叉\r\n4. 出现看涨K线形态\r\n```\r\n\r\n### 3. 出场信号\r\n\r\n**止盈出场**：\r\n- 固定目标位（如2R、3R）\r\n- 技术位止盈（前高、阻力位）\r\n- 移动止盈（跟踪止损）\r\n\r\n**止损出场**：\r\n- 固定止损（入场价下方2%）\r\n- 技术位止损（支撑位下方）\r\n- 时间止损（持仓超过N天未盈利）\r\n\r\n**出场规则示例**：\r\n```\r\n出场条件（满足任一）：\r\n1. 价格达到2倍风险收益（2R）\r\n2. 价格跌破MA20\r\n3. 4小时MACD死叉\r\n4. 止损价触发\r\n```\r\n\r\n### 4. 仓位管理\r\n\r\n**固定比例法**：\r\n- 每笔交易风险固定为总资金的1-2%\r\n- 根据止损距离计算仓位大小\r\n\r\n**仓位计算公式**：\r\n```\r\n仓位 = (总资金 × 风险比例) / 止损金额\r\n例：10000U × 2% / 100U = 2U仓位\r\n```\r\n\r\n### 5. 风险控制\r\n\r\n**单笔风险**：不超过总资金的2%\r\n**总仓位**：不超过总资金的30%\r\n**相关性**：避免同时持有高相关品种\r\n**最大回撤**：设定最大可接受回撤（如20%）\r\n\r\n---\r\n\r\n## 三、交易系统设计原则\r\n\r\n### 1. 简单有效\r\n\r\n- 规则越简单越好执行\r\n- 3-5个条件足够\r\n- 复杂不等于有效\r\n\r\n### 2. 顺势而为\r\n\r\n- 大趋势方向交易\r\n- 不要逆势抄底摸顶\r\n- 趋势是最好的朋友\r\n\r\n### 3. 严格止损\r\n\r\n- 每笔交易必须有止损\r\n- 止损后不要后悔\r\n- 小亏是交易的一部分\r\n\r\n### 4. 让利润奔跑\r\n\r\n- 不要过早止盈\r\n- 使用移动止损\r\n- 盈亏比至少1:2\r\n\r\n### 5. 可执行性\r\n\r\n- 规则必须明确无歧义\r\n- 自己能够严格执行\r\n- 不需要盯盘的更好\r\n\r\n---\r\n\r\n## 四、交易系统示例\r\n\r\n### 趋势跟踪系统\r\n\r\n```\r\n【市场】BTC/USDT 4小时图\r\n\r\n【入场条件】\r\n1. MA20 > MA50 > MA100（多头排列）\r\n2. 价格回踩MA20不破\r\n3. RSI > 50\r\n4. 出现看涨K线（锤子线/吞没）\r\n\r\n【出场条件】\r\n止盈：价格达到前期高点或2R\r\n止损：MA20下方1%\r\n\r\n【仓位】\r\n单笔风险2%，根据止损计算仓位\r\n\r\n【执行频率】\r\n每4小时检查一次信号\r\n```\r\n\r\n---\r\n\r\n## 五、系统验证与优化\r\n\r\n### 1. 回测验证\r\n\r\n- 使用历史数据测试\r\n- 至少100笔交易样本\r\n- 统计胜率、盈亏比、最大回撤\r\n\r\n### 2. 模拟交易\r\n\r\n- 用模拟盘验证\r\n- 至少1个月时间\r\n- 记录每笔交易\r\n\r\n### 3. 小资金实盘\r\n\r\n- 用小资金验证\r\n- 观察实盘与回测差异\r\n- 逐步增加资金\r\n\r\n### 4. 持续优化\r\n\r\n- 定期复盘交易记录\r\n- 找出系统弱点\r\n- 小幅调整优化\r\n\r\n---\r\n\r\n## 六、常见错误\r\n\r\n1. **过度优化**：针对历史数据过度拟合\r\n2. **频繁修改**：系统还没验证就修改\r\n3. **不执行系统**：有系统但不遵守\r\n4. **追求完美**：没有100%胜率的系统\r\n5. **忽视风控**：只关注入场不关注风险', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40'), (10, 10, '交易风险管理完全手册', '深入讲解风险管理原则、仓位计算和止损策略', 'markdown', '# 交易风险管理完全手册\r\n\r\n## 一、风险管理的重要性\r\n\r\n### 1. 为什么风险管理最重要\r\n\r\n**残酷的数学**：\r\n- 亏损50%需要盈利100%才能回本\r\n- 亏损90%需要盈利900%才能回本\r\n- 保住本金是第一要务\r\n\r\n**职业交易员的共识**：\r\n- 风险管理 > 入场技术\r\n- 活下来才能等到机会\r\n- 长期盈利靠的是风控\r\n\r\n### 2. 风险的类型\r\n\r\n| 类型 | 描述 | 应对方法 |\r\n|-----|------|---------|\r\n| 市场风险 | 价格波动带来的亏损 | 止损、仓位控制 |\r\n| 流动性风险 | 无法按预期价格成交 | 选择流动性好的品种 |\r\n| 系统性风险 | 整个市场崩盘 | 分散投资、控制总仓位 |\r\n| 操作风险 | 人为失误 | 规范操作流程 |\r\n| 黑天鹅风险 | 极端事件 | 永远不要满仓 |\r\n\r\n---\r\n\r\n## 二、仓位管理\r\n\r\n### 1. 固定金额法\r\n\r\n**方法**：每笔交易投入固定金额\r\n\r\n**示例**：\r\n- 总资金：10000U\r\n- 每笔投入：1000U（10%）\r\n- 优点：简单易执行\r\n- 缺点：没有考虑止损距离\r\n\r\n### 2. 固定比例法（推荐）\r\n\r\n**方法**：每笔交易风险固定为总资金的一定比例\r\n\r\n**计算公式**：\r\n```\r\n仓位大小 = (总资金 × 风险比例) / (入场价 - 止损价)\r\n\r\n示例：\r\n总资金：10000U\r\n风险比例：2%（200U）\r\n入场价：50000\r\n止损价：49000（2%止损）\r\n仓位 = 200 / 1000 = 0.2 BTC\r\n```\r\n\r\n**推荐风险比例**：\r\n- 保守：1%\r\n- 标准：2%\r\n- 激进：3%（不推荐超过）\r\n\r\n### 3. 凯利公式\r\n\r\n**公式**：f = (bp - q) / b\r\n\r\n其中：\r\n- f = 最优仓位比例\r\n- b = 盈亏比\r\n- p = 胜率\r\n- q = 败率（1-p）\r\n\r\n**示例**：\r\n- 胜率50%，盈亏比2:1\r\n- f = (2×0.5 - 0.5) / 2 = 25%\r\n- 实际使用建议取1/2或1/4凯利值\r\n\r\n---\r\n\r\n## 三、止损策略\r\n\r\n### 1. 固定百分比止损\r\n\r\n**方法**：入场价下方固定百分比\r\n\r\n**常用设置**：\r\n- 短线：1-2%\r\n- 波段：3-5%\r\n- 长线：5-10%\r\n\r\n**优点**：简单明确\r\n**缺点**：可能被正常波动扫损\r\n\r\n### 2. 技术位止损\r\n\r\n**方法**：根据技术分析设置止损\r\n\r\n**常用位置**：\r\n- 前期低点下方\r\n- 支撑位下方\r\n- 均线下方\r\n- 趋势线下方\r\n\r\n**优点**：更合理\r\n**缺点**：止损距离不固定\r\n\r\n### 3. ATR止损\r\n\r\n**方法**：使用ATR（平均真实波幅）设置止损\r\n\r\n**计算**：\r\n- 止损 = 入场价 - N × ATR\r\n- N通常取1.5-3\r\n\r\n**优点**：适应市场波动\r\n**缺点**：需要计算\r\n\r\n### 4. 移动止损（跟踪止损）\r\n\r\n**方法**：随着盈利移动止损位\r\n\r\n**策略**：\r\n- 盈利1R后，止损移到成本价\r\n- 盈利2R后，止损移到1R位置\r\n- 持续跟踪保护利润\r\n\r\n---\r\n\r\n## 四、止盈策略\r\n\r\n### 1. 固定盈亏比止盈\r\n\r\n**方法**：设定固定的盈亏比目标\r\n\r\n**常用设置**：\r\n- 保守：1.5:1\r\n- 标准：2:1\r\n- 激进：3:1\r\n\r\n### 2. 分批止盈\r\n\r\n**方法**：分多次止盈\r\n\r\n**示例**：\r\n- 1R时平仓1/3\r\n- 2R时平仓1/3\r\n- 剩余1/3跟踪止损\r\n\r\n**优点**：锁定部分利润，保留上涨空间\r\n\r\n### 3. 技术位止盈\r\n\r\n**方法**：在技术阻力位止盈\r\n\r\n**常用位置**：\r\n- 前期高点\r\n- 斐波那契扩展位\r\n- 整数关口\r\n\r\n---\r\n\r\n## 五、资金管理规则\r\n\r\n### 1. 单笔风险控制\r\n\r\n- 单笔亏损不超过总资金2%\r\n- 连续亏损后降低仓位\r\n- 盈利后可适当增加仓位\r\n\r\n### 2. 总仓位控制\r\n\r\n- 总仓位不超过30-50%\r\n- 单一品种不超过20%\r\n- 保留现金应对机会\r\n\r\n### 3. 回撤控制\r\n\r\n- 设定最大回撤线（如20%）\r\n- 达到回撤线暂停交易\r\n- 复盘后再重新开始\r\n\r\n### 4. 盈利保护\r\n\r\n- 盈利后提取部分利润\r\n- 不要把所有盈利再投入\r\n- 建立安全垫\r\n\r\n---\r\n\r\n## 六、风险管理清单\r\n\r\n### 交易前检查\r\n\r\n```\r\n□ 止损位置是否明确？\r\n□ 仓位大小是否合理？\r\n□ 单笔风险是否在2%以内？\r\n□ 总仓位是否在控制范围？\r\n□ 是否有足够的风险回报比？\r\n```\r\n\r\n### 交易中检查\r\n\r\n```\r\n□ 是否严格执行止损？\r\n□ 是否过早止盈？\r\n□ 是否追加仓位？\r\n□ 情绪是否稳定？\r\n```\r\n\r\n### 交易后复盘\r\n\r\n```\r\n□ 是否遵守了交易计划？\r\n□ 风险控制是否到位？\r\n□ 有什么可以改进的？\r\n```\r\n\r\n---\r\n\r\n## 七、实战建议\r\n\r\n1. **永远使用止损**：没有止损的交易是赌博\r\n2. **控制单笔风险**：2%是黄金法则\r\n3. **不要加仓摊平**：亏损时加仓是大忌\r\n4. **保持耐心**：等待高概率机会\r\n5. **接受亏损**：亏损是交易的一部分\r\n6. **持续学习**：风险管理需要不断完善', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40'), (11, 11, '趋势跟随交易策略详解', '系统讲解趋势跟随的核心理念、识别方法和交易系统', 'markdown', '# 趋势跟随交易策略详解\r\n\r\n## 一、趋势跟随的核心理念\r\n\r\n### 1. 什么是趋势跟随\r\n\r\n**定义**：识别市场趋势方向，顺势建仓，持有直到趋势结束\r\n\r\n**核心思想**：\r\n- 趋势一旦形成，倾向于延续\r\n- 不预测顶底，只跟随趋势\r\n- 截断亏损，让利润奔跑\r\n\r\n### 2. 趋势跟随的优势\r\n\r\n- 不需要预测市场\r\n- 能够捕捉大行情\r\n- 规则明确易执行\r\n- 长期期望值为正\r\n\r\n### 3. 趋势跟随的挑战\r\n\r\n- 震荡市会频繁止损\r\n- 需要承受回撤\r\n- 胜率通常不高（30-40%）\r\n- 需要耐心等待趋势\r\n\r\n---\r\n\r\n## 二、趋势的识别\r\n\r\n### 1. 道氏理论定义\r\n\r\n**上升趋势**：\r\n- 高点不断抬高\r\n- 低点不断抬高\r\n- 形成上升通道\r\n\r\n**下降趋势**：\r\n- 高点不断降低\r\n- 低点不断降低\r\n- 形成下降通道\r\n\r\n### 2. 均线判断法\r\n\r\n**多头趋势**：\r\n- 价格 > MA20 > MA50 > MA200\r\n- 均线多头排列\r\n- 均线向上发散\r\n\r\n**空头趋势**：\r\n- 价格 < MA20 < MA50 < MA200\r\n- 均线空头排列\r\n- 均线向下发散\r\n\r\n### 3. 趋势线判断法\r\n\r\n**上升趋势线**：\r\n- 连接两个以上低点\r\n- 价格在趋势线上方运行\r\n- 趋势线被有效跌破则趋势结束\r\n\r\n**下降趋势线**：\r\n- 连接两个以上高点\r\n- 价格在趋势线下方运行\r\n- 趋势线被有效突破则趋势结束\r\n\r\n---\r\n\r\n## 三、经典趋势跟随策略\r\n\r\n### 1. 海龟交易法则\r\n\r\n**入场规则**：\r\n- 突破20日最高价做多\r\n- 突破20日最低价做空\r\n\r\n**出场规则**：\r\n- 跌破10日最低价平多\r\n- 突破10日最高价平空\r\n\r\n**仓位管理**：\r\n- 使用ATR计算仓位\r\n- 单位仓位 = 账户1% / ATR\r\n\r\n### 2. 均线突破策略\r\n\r\n**入场规则**：\r\n- 价格突破MA50做多\r\n- 价格跌破MA50做空\r\n\r\n**出场规则**：\r\n- 价格跌破MA20平多\r\n- 价格突破MA20平空\r\n\r\n**过滤条件**：\r\n- MA50方向与交易方向一致\r\n- 成交量放大确认\r\n\r\n### 3. 通道突破策略\r\n\r\n**入场规则**：\r\n- 突破布林带上轨做多\r\n- 跌破布林带下轨做空\r\n\r\n**出场规则**：\r\n- 价格回到中轨平仓\r\n- 或使用移动止损\r\n\r\n---\r\n\r\n## 四、趋势跟随系统设计\r\n\r\n### 完整系统示例\r\n\r\n```\r\n【系统名称】均线趋势跟踪系统\r\n【适用品种】BTC/USDT\r\n【时间周期】日线\r\n\r\n【趋势判断】\r\n- MA50 > MA200：只做多\r\n- MA50 < MA200：只做空\r\n\r\n【入场条件】\r\n做多：\r\n1. MA50 > MA200（大趋势向上）\r\n2. 价格回踩MA50获得支撑\r\n3. 出现看涨K线形态\r\n4. 成交量放大\r\n\r\n【出场条件】\r\n止损：MA50下方2%\r\n止盈：移动止损，跌破MA20平仓\r\n\r\n【仓位管理】\r\n单笔风险：2%\r\n仓位计算：风险金额 / 止损距离\r\n```\r\n\r\n---\r\n\r\n## 五、趋势跟随的关键技巧\r\n\r\n### 1. 多周期确认\r\n\r\n- 周线定大方向\r\n- 日线找入场点\r\n- 4小时精确入场\r\n\r\n### 2. 等待回调入场\r\n\r\n- 不追涨杀跌\r\n- 等待价格回调到支撑\r\n- 回调不破是最佳入场点\r\n\r\n### 3. 金字塔加仓\r\n\r\n- 趋势确认后可以加仓\r\n- 每次加仓量递减\r\n- 加仓后调整止损\r\n\r\n### 4. 移动止损保护利润\r\n\r\n- 盈利后移动止损到成本\r\n- 随着趋势发展持续移动\r\n- 保护已有利润\r\n\r\n---\r\n\r\n## 六、趋势跟随的心理建设\r\n\r\n### 1. 接受低胜率\r\n\r\n- 趋势跟随胜率通常30-40%\r\n- 靠大盈利覆盖小亏损\r\n- 不要因为连续止损而放弃\r\n\r\n### 2. 耐心等待\r\n\r\n- 趋势不是每天都有\r\n- 大部分时间在等待\r\n- 宁可错过不可做错\r\n\r\n### 3. 坚持系统\r\n\r\n- 不要因为几次亏损就修改系统\r\n- 给系统足够的验证时间\r\n- 相信概率和期望值\r\n\r\n---\r\n\r\n## 七、常见错误\r\n\r\n1. **逆势交易**：在下跌趋势中抄底\r\n2. **过早止盈**：趋势还没结束就平仓\r\n3. **不止损**：希望价格回来\r\n4. **频繁交易**：震荡市强行交易\r\n5. **追涨杀跌**：在趋势末端入场', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40'), (12, 12, '震荡市场交易策略', '详解震荡市场的识别、区间交易和网格策略', 'markdown', '# 震荡市场交易策略\r\n\r\n## 一、震荡市场的识别\r\n\r\n### 1. 震荡市场特征\r\n\r\n**价格特征**：\r\n- 价格在一定区间内波动\r\n- 没有明显的趋势方向\r\n- 高点和低点相对稳定\r\n\r\n**技术指标特征**：\r\n- 均线走平或缠绕\r\n- ADX < 25（趋势强度弱）\r\n- 布林带收窄\r\n\r\n**成交量特征**：\r\n- 成交量萎缩\r\n- 没有明显放量\r\n\r\n### 2. 震荡与趋势的区分\r\n\r\n| 特征 | 趋势市场 | 震荡市场 |\r\n|-----|---------|---------|\r\n| 均线 | 多头/空头排列 | 缠绕走平 |\r\n| ADX | > 25 | < 25 |\r\n| 布林带 | 开口扩张 | 收口收窄 |\r\n| 高低点 | 不断抬高/降低 | 相对稳定 |\r\n\r\n### 3. 震荡区间的确定\r\n\r\n**水平区间**：\r\n- 找出多次触及的高点（阻力）\r\n- 找出多次触及的低点（支撑）\r\n- 形成水平通道\r\n\r\n**区间有效性**：\r\n- 至少2次触及上下边界\r\n- 时间跨度越长越有效\r\n- 触及次数越多越可靠\r\n\r\n---\r\n\r\n## 二、震荡交易策略\r\n\r\n### 1. 区间交易策略\r\n\r\n**核心思想**：在支撑买入，在阻力卖出\r\n\r\n**做多条件**：\r\n1. 价格接近区间下沿（支撑）\r\n2. 出现看涨K线形态\r\n3. RSI进入超卖区（< 30）\r\n\r\n**做空条件**：\r\n1. 价格接近区间上沿（阻力）\r\n2. 出现看跌K线形态\r\n3. RSI进入超买区（> 70）\r\n\r\n**止损设置**：\r\n- 做多止损：支撑位下方1-2%\r\n- 做空止损：阻力位上方1-2%\r\n\r\n**止盈设置**：\r\n- 做多止盈：阻力位附近\r\n- 做空止盈：支撑位附近\r\n\r\n### 2. 布林带回归策略\r\n\r\n**做多条件**：\r\n1. 价格触及布林带下轨\r\n2. RSI < 30\r\n3. 出现看涨K线\r\n\r\n**做空条件**：\r\n1. 价格触及布林带上轨\r\n2. RSI > 70\r\n3. 出现看跌K线\r\n\r\n**出场**：\r\n- 价格回到布林带中轨\r\n\r\n### 3. RSI超买超卖策略\r\n\r\n**做多条件**：\r\n1. RSI < 30后反弹突破30\r\n2. 价格在支撑区域\r\n\r\n**做空条件**：\r\n1. RSI > 70后回落跌破70\r\n2. 价格在阻力区域\r\n\r\n---\r\n\r\n## 三、网格交易策略\r\n\r\n### 1. 网格交易原理\r\n\r\n**核心思想**：\r\n- 在价格区间内设置多个买卖点\r\n- 价格下跌时分批买入\r\n- 价格上涨时分批卖出\r\n- 赚取波动差价\r\n\r\n### 2. 网格设置方法\r\n\r\n**等差网格**：\r\n```\r\n区间：45000 - 55000\r\n网格数：10\r\n间距：1000\r\n\r\n买入价格：45000, 46000, 47000...\r\n卖出价格：46000, 47000, 48000...\r\n```\r\n\r\n**等比网格**：\r\n```\r\n区间：45000 - 55000\r\n比例：2%\r\n\r\n买入价格：45000, 45900, 46818...\r\n更适合大区间\r\n```\r\n\r\n### 3. 网格交易注意事项\r\n\r\n**优点**：\r\n- 不需要判断方向\r\n- 自动化执行\r\n- 震荡市稳定盈利\r\n\r\n**缺点**：\r\n- 趋势市会被套\r\n- 资金利用率低\r\n- 需要足够的资金\r\n\r\n**风险控制**：\r\n- 设置总止损线\r\n- 不要在下跌趋势中使用\r\n- 控制总仓位\r\n\r\n---\r\n\r\n## 四、震荡市的风险管理\r\n\r\n### 1. 识别假突破\r\n\r\n**假突破特征**：\r\n- 突破时成交量不大\r\n- 快速回到区间内\r\n- 影线突破而非实体\r\n\r\n**应对方法**：\r\n- 等待收盘确认\r\n- 等待回踩确认\r\n- 设置合理止损\r\n\r\n### 2. 震荡转趋势的信号\r\n\r\n**突破信号**：\r\n- 放量突破区间\r\n- 收盘价站稳突破位\r\n- 回踩不破\r\n\r\n**应对方法**：\r\n- 突破后停止区间交易\r\n- 转为趋势跟踪策略\r\n- 或观望等待确认\r\n\r\n### 3. 仓位控制\r\n\r\n- 震荡交易仓位要小\r\n- 单笔风险控制在1%\r\n- 不要重仓博弈\r\n\r\n---\r\n\r\n## 五、震荡交易系统示例\r\n\r\n```\r\n【系统名称】区间震荡交易系统\r\n【适用条件】ADX < 25，布林带收窄\r\n\r\n【区间确定】\r\n- 上沿：近期2次以上触及的高点\r\n- 下沿：近期2次以上触及的低点\r\n\r\n【做多条件】\r\n1. 价格触及区间下沿\r\n2. RSI < 35\r\n3. 出现看涨K线（锤子线/吞没）\r\n\r\n【做空条件】\r\n1. 价格触及区间上沿\r\n2. RSI > 65\r\n3. 出现看跌K线（射击之星/吞没）\r\n\r\n【止损】\r\n- 做多：下沿下方1.5%\r\n- 做空：上沿上方1.5%\r\n\r\n【止盈】\r\n- 做多：上沿附近或中轨\r\n- 做空：下沿附近或中轨\r\n\r\n【退出条件】\r\n- 价格有效突破区间\r\n- ADX > 25\r\n- 转为趋势策略\r\n```\r\n\r\n---\r\n\r\n## 六、实战建议\r\n\r\n1. **先判断市场状态**：趋势还是震荡\r\n2. **不要在趋势市用震荡策略**：会被反复止损\r\n3. **控制仓位**：震荡交易利润有限\r\n4. **设置严格止损**：防止假突破变真突破\r\n5. **关注突破信号**：及时切换策略', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40'), (13, 13, '突破交易策略完全指南', '详解突破类型、有效突破识别和突破交易系统', 'markdown', '# 突破交易策略完全指南\r\n\r\n## 一、突破交易概述\r\n\r\n### 1. 什么是突破\r\n\r\n**定义**：价格突破重要的支撑/阻力位，开启新的趋势\r\n\r\n**突破的意义**：\r\n- 供需关系发生变化\r\n- 新的趋势可能开始\r\n- 提供明确的入场信号\r\n\r\n### 2. 突破的类型\r\n\r\n| 类型 | 描述 | 特点 |\r\n|-----|------|------|\r\n| 水平突破 | 突破水平支撑/阻力 | 最常见 |\r\n| 趋势线突破 | 突破上升/下降趋势线 | 趋势反转信号 |\r\n| 形态突破 | 突破图表形态 | 目标明确 |\r\n| 均线突破 | 突破重要均线 | 趋势确认 |\r\n\r\n---\r\n\r\n## 二、有效突破的识别\r\n\r\n### 1. 有效突破的特征\r\n\r\n**成交量确认**：\r\n- 突破时成交量明显放大\r\n- 至少是平均成交量的1.5倍\r\n- 量价配合是关键\r\n\r\n**收盘价确认**：\r\n- 收盘价站稳突破位\r\n- 不是仅影线突破\r\n- 日线收盘更可靠\r\n\r\n**突破幅度**：\r\n- 突破幅度超过1-3%\r\n- 幅度太小可能是假突破\r\n- 根据品种波动性调整\r\n\r\n**时间确认**：\r\n- 突破后能维持2-3根K线\r\n- 不是快速回落\r\n- 时间越长越可靠\r\n\r\n### 2. 假突破的识别\r\n\r\n**假突破特征**：\r\n- 突破时成交量萎缩\r\n- 快速回到原区间\r\n- 仅影线突破\r\n- 突破后无法维持\r\n\r\n**假突破的原因**：\r\n- 主力诱多/诱空\r\n- 止损盘触发后回落\r\n- 市场缺乏跟风盘\r\n\r\n### 3. 突破确认方法\r\n\r\n**回踩确认法**：\r\n- 等待突破后回踩\r\n- 回踩不破原突破位\r\n- 回踩后再入场\r\n\r\n**收盘确认法**：\r\n- 等待日线收盘\r\n- 收盘价站稳突破位\r\n- 次日确认后入场\r\n\r\n**成交量确认法**：\r\n- 突破时放量\r\n- 回踩时缩量\r\n- 再次上涨时放量\r\n\r\n---\r\n\r\n## 三、突破交易策略\r\n\r\n### 1. 即时突破策略\r\n\r\n**入场**：突破发生时立即入场\r\n\r\n**优点**：\r\n- 不会错过行情\r\n- 入场价格好\r\n\r\n**缺点**：\r\n- 假突破风险高\r\n- 需要快速反应\r\n\r\n**适用**：\r\n- 重大消息驱动的突破\r\n- 成交量明显放大的突破\r\n\r\n### 2. 回踩突破策略（推荐）\r\n\r\n**入场**：等待突破后回踩再入场\r\n\r\n**优点**：\r\n- 过滤假突破\r\n- 风险回报比更好\r\n- 止损更明确\r\n\r\n**缺点**：\r\n- 可能错过强势突破\r\n- 需要耐心等待\r\n\r\n**入场条件**：\r\n1. 价格有效突破阻力\r\n2. 回踩到原阻力位（现支撑）\r\n3. 出现看涨K线形态\r\n4. 成交量萎缩后放量\r\n\r\n### 3. 形态突破策略\r\n\r\n**常见突破形态**：\r\n- 头肩底/顶\r\n- 双底/双顶\r\n- 三角形\r\n- 旗形/楔形\r\n\r\n**交易方法**：\r\n- 等待形态完成\r\n- 突破颈线入场\r\n- 目标位 = 形态高度\r\n\r\n---\r\n\r\n## 四、突破交易系统\r\n\r\n### 系统示例\r\n\r\n```\r\n【系统名称】回踩突破交易系统\r\n【适用品种】BTC/USDT\r\n【时间周期】4小时\r\n\r\n【突破确认】\r\n1. 价格突破重要阻力位\r\n2. 突破时成交量放大（> 1.5倍均量）\r\n3. 收盘价站稳突破位\r\n\r\n【入场条件】\r\n1. 突破确认后等待回踩\r\n2. 回踩到原阻力位（现支撑）\r\n3. 回踩时成交量萎缩\r\n4. 出现看涨K线形态\r\n\r\n【止损设置】\r\n- 支撑位下方1-2%\r\n- 或回踩低点下方\r\n\r\n【止盈设置】\r\n- 第一目标：前期高点\r\n- 第二目标：突破幅度的1-1.5倍\r\n- 使用移动止损保护利润\r\n\r\n【仓位管理】\r\n- 单笔风险2%\r\n- 可在回踩确认后加仓\r\n```\r\n\r\n---\r\n\r\n## 五、不同形态的突破交易\r\n\r\n### 1. 水平阻力突破\r\n\r\n**入场**：突破后回踩原阻力\r\n**止损**：原阻力下方\r\n**目标**：前期高点或等距测量\r\n\r\n### 2. 下降趋势线突破\r\n\r\n**入场**：突破趋势线后回踩\r\n**止损**：趋势线下方\r\n**目标**：前期高点\r\n\r\n### 3. 三角形突破\r\n\r\n**入场**：突破三角形边界\r\n**止损**：三角形内\r\n**目标**：三角形最宽处的距离\r\n\r\n### 4. 头肩底突破\r\n\r\n**入场**：突破颈线后回踩\r\n**止损**：右肩下方\r\n**目标**：头部到颈线的距离\r\n\r\n---\r\n\r\n## 六、突破交易的风险管理\r\n\r\n### 1. 止损设置\r\n\r\n- 突破位下方1-2%\r\n- 或回踩低点下方\r\n- 不要设置太紧\r\n\r\n### 2. 仓位控制\r\n\r\n- 首次入场用小仓位\r\n- 确认后可以加仓\r\n- 总仓位不超过计划\r\n\r\n### 3. 假突破应对\r\n\r\n- 严格执行止损\r\n- 不要补仓摊平\r\n- 等待下次机会\r\n\r\n---\r\n\r\n## 七、实战技巧\r\n\r\n1. **等待确认**：不要急于入场\r\n2. **关注成交量**：量价配合是关键\r\n3. **设置合理止损**：给价格波动空间\r\n4. **分批入场**：降低假突破风险\r\n5. **顺势突破**：大趋势方向的突破更可靠\r\n6. **避免追高**：突破后涨太多不要追', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40');
INSERT INTO `learn_material` (`id`, `chapter_id`, `title`, `description`, `material_type`, `content`, `file_url`, `link_url`, `sort_order`, `status`, `create_by`, `create_time`, `update_time`) VALUES (14, 14, '多时间框架分析方法', '系统讲解多周期分析的原理、方法和实战应用', 'markdown', '# 多时间框架分析方法\r\n\r\n## 一、多时间框架分析概述\r\n\r\n### 1. 什么是多时间框架分析\r\n\r\n**定义**：同时分析多个时间周期的图表，从大到小确定交易方向和入场点\r\n\r\n**核心思想**：\r\n- 大周期定方向\r\n- 中周期找机会\r\n- 小周期精入场\r\n\r\n### 2. 为什么需要多周期分析\r\n\r\n**单一周期的问题**：\r\n- 只见树木不见森林\r\n- 容易逆势交易\r\n- 入场点不精确\r\n\r\n**多周期的优势**：\r\n- 把握大趋势方向\r\n- 提高交易胜率\r\n- 优化入场点位\r\n\r\n---\r\n\r\n## 二、时间框架的选择\r\n\r\n### 1. 常用时间框架组合\r\n\r\n| 交易类型 | 大周期 | 中周期 | 小周期 |\r\n|---------|-------|-------|-------|\r\n| 日内交易 | 4小时 | 1小时 | 15分钟 |\r\n| 波段交易 | 日线 | 4小时 | 1小时 |\r\n| 趋势交易 | 周线 | 日线 | 4小时 |\r\n| 长线投资 | 月线 | 周线 | 日线 |\r\n\r\n### 2. 时间框架比例\r\n\r\n**推荐比例**：4-6倍\r\n\r\n**示例**：\r\n- 日线 → 4小时 → 1小时（6:4:1）\r\n- 4小时 → 1小时 → 15分钟（4:4:1）\r\n\r\n**原则**：\r\n- 比例太大：信息断层\r\n- 比例太小：信息重复\r\n\r\n---\r\n\r\n## 三、多周期分析方法\r\n\r\n### 1. 自上而下分析法\r\n\r\n**步骤**：\r\n\r\n**第一步：大周期定方向**\r\n- 判断大趋势（上涨/下跌/震荡）\r\n- 确定交易方向（只做多/只做空/双向）\r\n- 识别关键支撑阻力\r\n\r\n**第二步：中周期找机会**\r\n- 在大趋势方向寻找交易机会\r\n- 识别回调或突破信号\r\n- 确定大致入场区域\r\n\r\n**第三步：小周期精入场**\r\n- 在入场区域等待信号\r\n- 寻找精确入场点\r\n- 设置止损止盈\r\n\r\n### 2. 实战示例\r\n\r\n```\r\n【大周期-周线】\r\n- MA20 > MA50，多头趋势\r\n- 价格在MA20上方\r\n- 结论：只做多\r\n\r\n【中周期-日线】\r\n- 价格回调到MA20附近\r\n- RSI回落到50附近\r\n- 结论：寻找做多机会\r\n\r\n【小周期-4小时】\r\n- 等待MACD金叉\r\n- 出现看涨K线形态\r\n- 结论：入场做多\r\n```\r\n\r\n---\r\n\r\n## 四、多周期共振\r\n\r\n### 1. 什么是多周期共振\r\n\r\n**定义**：多个时间周期同时发出相同方向的信号\r\n\r\n**共振类型**：\r\n- 趋势共振：多周期趋势方向一致\r\n- 信号共振：多周期同时出现买卖信号\r\n- 位置共振：多周期支撑阻力重合\r\n\r\n### 2. 共振的威力\r\n\r\n**单周期信号**：胜率约50-55%\r\n**双周期共振**：胜率约60-65%\r\n**三周期共振**：胜率约70-75%\r\n\r\n### 3. 寻找共振机会\r\n\r\n**趋势共振示例**：\r\n- 周线：多头趋势\r\n- 日线：多头趋势\r\n- 4小时：出现做多信号\r\n- 结论：高概率做多机会\r\n\r\n**位置共振示例**：\r\n- 周线支撑位：50000\r\n- 日线MA50：50200\r\n- 4小时布林带下轨：49800\r\n- 结论：50000附近是强支撑\r\n\r\n---\r\n\r\n## 五、多周期交易系统\r\n\r\n### 系统示例\r\n\r\n```\r\n【系统名称】三周期趋势跟踪系统\r\n【时间框架】周线 + 日线 + 4小时\r\n\r\n【周线分析】\r\n- 判断大趋势方向\r\n- MA20 > MA50 = 多头\r\n- MA20 < MA50 = 空头\r\n\r\n【日线分析】\r\n- 寻找回调机会\r\n- 价格回调到MA20附近\r\n- RSI回落到40-50区间\r\n\r\n【4小时入场】\r\n- 等待入场信号\r\n- MACD金叉\r\n- 出现看涨K线\r\n\r\n【交易规则】\r\n- 只在大趋势方向交易\r\n- 等待三周期共振\r\n- 小周期触发入场\r\n\r\n【止损设置】\r\n- 4小时图前低下方\r\n- 或日线MA20下方\r\n\r\n【止盈设置】\r\n- 第一目标：日线前高\r\n- 第二目标：周线阻力\r\n- 使用移动止损\r\n```\r\n\r\n---\r\n\r\n## 六、常见问题与解决\r\n\r\n### 1. 周期冲突怎么办\r\n\r\n**情况**：大周期看多，小周期看空\r\n\r\n**解决方案**：\r\n- 以大周期为准\r\n- 等待小周期转向\r\n- 或者不交易\r\n\r\n### 2. 错过入场怎么办\r\n\r\n**情况**：小周期信号出现时没看到\r\n\r\n**解决方案**：\r\n- 等待下一次回调\r\n- 不要追涨杀跌\r\n- 设置价格提醒\r\n\r\n### 3. 止损放哪个周期\r\n\r\n**建议**：\r\n- 入场周期设止损\r\n- 参考上一级周期支撑\r\n- 不要设置太紧\r\n\r\n---\r\n\r\n## 七、实战技巧\r\n\r\n### 1. 分析顺序\r\n\r\n- 先看大周期，再看小周期\r\n- 不要被小周期波动干扰\r\n- 大周期决定交易方向\r\n\r\n### 2. 入场时机\r\n\r\n- 大周期趋势明确\r\n- 中周期出现回调\r\n- 小周期出现反转信号\r\n\r\n### 3. 持仓管理\r\n\r\n- 用小周期管理短线仓位\r\n- 用大周期管理长线仓位\r\n- 根据周期调整预期\r\n\r\n### 4. 避免过度分析\r\n\r\n- 不要看太多周期\r\n- 3个周期足够\r\n- 简单有效最重要', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40'), (15, 15, '交易心理学与情绪管理', '深入分析交易心理陷阱、情绪管理方法和心态建设', 'markdown', '# 交易心理学与情绪管理\r\n\r\n## 一、交易心理的重要性\r\n\r\n### 1. 为什么心理最重要\r\n\r\n**交易成功的三要素**：\r\n- 交易系统：30%\r\n- 资金管理：30%\r\n- 交易心理：40%\r\n\r\n**现实情况**：\r\n- 大多数人有好的系统却无法执行\r\n- 情绪化交易是亏损的主要原因\r\n- 心理是最难克服的障碍\r\n\r\n### 2. 人性的弱点\r\n\r\n| 弱点 | 表现 | 后果 |\r\n|-----|------|------|\r\n| 贪婪 | 不止盈、重仓 | 利润回吐、爆仓 |\r\n| 恐惧 | 不敢入场、过早止盈 | 错过机会 |\r\n| 希望 | 不止损、死扛 | 巨额亏损 |\r\n| 后悔 | 追涨杀跌 | 高买低卖 |\r\n\r\n---\r\n\r\n## 二、常见心理陷阱\r\n\r\n### 1. 贪婪与恐惧\r\n\r\n**贪婪的表现**：\r\n- 盈利后不止盈，想赚更多\r\n- 重仓交易，想快速致富\r\n- 频繁交易，不想错过任何机会\r\n\r\n**恐惧的表现**：\r\n- 该入场时不敢入场\r\n- 盈利一点就急于平仓\r\n- 亏损后不敢再交易\r\n\r\n**应对方法**：\r\n- 制定明确的交易计划\r\n- 严格执行止盈止损\r\n- 控制仓位大小\r\n\r\n### 2. 过度交易\r\n\r\n**原因**：\r\n- 想快速赚钱\r\n- 无聊时随意交易\r\n- 亏损后想快速回本\r\n\r\n**危害**：\r\n- 手续费侵蚀利润\r\n- 增加犯错概率\r\n- 精力消耗过大\r\n\r\n**应对方法**：\r\n- 设定每日/每周交易次数上限\r\n- 只在高概率机会交易\r\n- 培养耐心等待的习惯\r\n\r\n### 3. 报复性交易\r\n\r\n**表现**：\r\n- 亏损后立即加大仓位\r\n- 想一笔交易回本\r\n- 情绪激动时交易\r\n\r\n**危害**：\r\n- 往往导致更大亏损\r\n- 恶性循环\r\n- 可能爆仓\r\n\r\n**应对方法**：\r\n- 亏损后强制休息\r\n- 设定每日最大亏损限额\r\n- 冷静后再交易\r\n\r\n### 4. 确认偏误\r\n\r\n**表现**：\r\n- 只看支持自己观点的信息\r\n- 忽视相反的信号\r\n- 固执己见不止损\r\n\r\n**危害**：\r\n- 错过止损时机\r\n- 逆势加仓\r\n- 巨额亏损\r\n\r\n**应对方法**：\r\n- 主动寻找反面证据\r\n- 设置客观的止损条件\r\n- 尊重市场\r\n\r\n### 5. 锚定效应\r\n\r\n**表现**：\r\n- 执着于某个价格（如成本价）\r\n- 不愿意在亏损时卖出\r\n- 等待回本\r\n\r\n**危害**：\r\n- 错过止损时机\r\n- 资金被套\r\n- 错过其他机会\r\n\r\n**应对方法**：\r\n- 忘记成本价\r\n- 只看当前市场状况\r\n- 该止损就止损\r\n\r\n---\r\n\r\n## 三、情绪管理方法\r\n\r\n### 1. 交易前准备\r\n\r\n**心理准备**：\r\n- 接受可能亏损\r\n- 明确风险承受能力\r\n- 保持平常心\r\n\r\n**计划准备**：\r\n- 写下交易计划\r\n- 明确入场出场条件\r\n- 设定止损止盈\r\n\r\n### 2. 交易中控制\r\n\r\n**情绪监控**：\r\n- 觉察自己的情绪状态\r\n- 情绪激动时暂停交易\r\n- 不要在极端情绪下决策\r\n\r\n**执行纪律**：\r\n- 严格按计划执行\r\n- 不临时改变计划\r\n- 相信系统\r\n\r\n### 3. 交易后复盘\r\n\r\n**记录情绪**：\r\n- 记录每笔交易时的情绪\r\n- 分析情绪对决策的影响\r\n- 找出情绪化交易的模式\r\n\r\n**总结改进**：\r\n- 哪些情绪导致了错误决策\r\n- 如何避免类似情况\r\n- 制定改进措施\r\n\r\n---\r\n\r\n## 四、建立正确的交易心态\r\n\r\n### 1. 概率思维\r\n\r\n**核心认知**：\r\n- 单笔交易结果不重要\r\n- 长期期望值才重要\r\n- 亏损是交易的一部分\r\n\r\n**实践方法**：\r\n- 关注系统的长期表现\r\n- 不因单笔亏损沮丧\r\n- 不因单笔盈利狂喜\r\n\r\n### 2. 风险意识\r\n\r\n**核心认知**：\r\n- 保住本金是第一要务\r\n- 活下来才能等到机会\r\n- 控制风险比追求利润重要\r\n\r\n**实践方法**：\r\n- 每笔交易都设止损\r\n- 控制仓位大小\r\n- 不要孤注一掷\r\n\r\n### 3. 耐心等待\r\n\r\n**核心认知**：\r\n- 好机会不是每天都有\r\n- 等待是交易的一部分\r\n- 宁可错过不可做错\r\n\r\n**实践方法**：\r\n- 只在高概率机会交易\r\n- 不要因为无聊而交易\r\n- 培养耐心\r\n\r\n### 4. 持续学习\r\n\r\n**核心认知**：\r\n- 市场永远在变化\r\n- 没有人能完全掌握市场\r\n- 学习是终身的事\r\n\r\n**实践方法**：\r\n- 每天复盘总结\r\n- 学习新的知识\r\n- 向优秀交易者学习\r\n\r\n---\r\n\r\n## 五、实用心理技巧\r\n\r\n### 1. 交易日志\r\n\r\n**记录内容**：\r\n- 交易计划和执行情况\r\n- 入场出场时的情绪\r\n- 事后反思\r\n\r\n**作用**：\r\n- 发现情绪化交易模式\r\n- 提高自我认知\r\n- 持续改进\r\n\r\n### 2. 冥想与放松\r\n\r\n**方法**：\r\n- 每天10-15分钟冥想\r\n- 交易前深呼吸放松\r\n- 保持身心健康\r\n\r\n**作用**：\r\n- 提高情绪控制能力\r\n- 减少冲动决策\r\n- 保持冷静\r\n\r\n### 3. 设定规则\r\n\r\n**规则示例**：\r\n- 连续亏损3次后休息一天\r\n- 单日亏损超过5%停止交易\r\n- 情绪激动时不交易\r\n\r\n**作用**：\r\n- 强制执行纪律\r\n- 避免情绪化交易\r\n- 保护资金\r\n\r\n---\r\n\r\n## 六、心理建设清单\r\n\r\n### 交易前\r\n\r\n```\r\n□ 我接受这笔交易可能亏损\r\n□ 我的仓位在承受范围内\r\n□ 我有明确的止损计划\r\n□ 我的情绪状态稳定\r\n□ 我不是为了回本而交易\r\n```\r\n\r\n### 交易中\r\n\r\n```\r\n□ 我按计划执行\r\n□ 我不临时改变止损\r\n□ 我不因波动而恐慌\r\n□ 我保持耐心\r\n```\r\n\r\n### 交易后\r\n\r\n```\r\n□ 我记录了这笔交易\r\n□ 我分析了情绪影响\r\n□ 我总结了经验教训\r\n□ 我为下次交易做好准备\r\n```', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40'), (16, 16, '模拟交易实战指南', '系统讲解模拟交易的方法、记录和复盘技巧', 'markdown', '# 模拟交易实战指南\r\n\r\n## 一、模拟交易的意义\r\n\r\n### 1. 为什么要模拟交易\r\n\r\n**验证系统**：\r\n- 检验交易系统是否有效\r\n- 发现系统的问题\r\n- 优化系统参数\r\n\r\n**积累经验**：\r\n- 熟悉交易流程\r\n- 培养交易习惯\r\n- 建立交易信心\r\n\r\n**零成本学习**：\r\n- 不用真金白银\r\n- 可以大胆尝试\r\n- 从错误中学习\r\n\r\n### 2. 模拟交易的目标\r\n\r\n**短期目标**（1个月）：\r\n- 熟悉交易平台操作\r\n- 执行至少20笔交易\r\n- 建立交易记录习惯\r\n\r\n**中期目标**（3个月）：\r\n- 验证交易系统有效性\r\n- 统计系统的胜率和盈亏比\r\n- 形成稳定的交易风格\r\n\r\n---\r\n\r\n## 二、模拟交易的正确方法\r\n\r\n### 1. 像真实交易一样对待\r\n\r\n**心态要求**：\r\n- 把模拟资金当真钱\r\n- 认真对待每一笔交易\r\n- 不要因为是模拟就随意\r\n\r\n**行为要求**：\r\n- 严格执行交易计划\r\n- 遵守风险管理规则\r\n- 记录每一笔交易\r\n\r\n### 2. 设定合理的模拟资金\r\n\r\n**建议金额**：\r\n- 与计划实盘资金相同\r\n- 或略高于实盘资金\r\n- 不要设置过大金额\r\n\r\n**原因**：\r\n- 培养真实的仓位感\r\n- 避免过度冒险\r\n- 更接近实盘体验\r\n\r\n### 3. 制定交易计划\r\n\r\n**每日计划**：\r\n```\r\n日期：____\r\n市场分析：\r\n- 大趋势方向：____\r\n- 关键支撑阻力：____\r\n- 今日交易计划：____\r\n\r\n交易机会：\r\n- 品种：____\r\n- 方向：____\r\n- 入场条件：____\r\n- 止损位：____\r\n- 止盈位：____\r\n```\r\n\r\n---\r\n\r\n## 三、交易记录模板\r\n\r\n### 1. 基本信息\r\n\r\n```\r\n交易编号：____\r\n日期时间：____\r\n品种：____\r\n方向：多/空\r\n入场价：____\r\n止损价：____\r\n止盈价：____\r\n仓位大小：____\r\n```\r\n\r\n### 2. 交易理由\r\n\r\n```\r\n入场理由：\r\n- 技术面：____\r\n- 基本面：____\r\n- 情绪面：____\r\n\r\n出场理由：\r\n- 止盈/止损/其他：____\r\n```\r\n\r\n### 3. 交易结果\r\n\r\n```\r\n出场价：____\r\n盈亏金额：____\r\n盈亏比例：____\r\n持仓时间：____\r\n```\r\n\r\n### 4. 交易复盘\r\n\r\n```\r\n执行评分（1-10）：____\r\n情绪状态：____\r\n做得好的地方：____\r\n需要改进的地方：____\r\n经验教训：____\r\n```\r\n\r\n---\r\n\r\n## 四、交易复盘方法\r\n\r\n### 1. 每日复盘\r\n\r\n**复盘内容**：\r\n- 今日交易回顾\r\n- 执行情况评估\r\n- 情绪状态分析\r\n- 明日计划制定\r\n\r\n**复盘时间**：\r\n- 每天交易结束后\r\n- 花15-30分钟\r\n- 形成习惯\r\n\r\n### 2. 每周复盘\r\n\r\n**复盘内容**：\r\n- 本周交易统计\r\n- 胜率和盈亏比\r\n- 系统表现评估\r\n- 问题总结\r\n\r\n**统计指标**：\r\n```\r\n本周交易次数：____\r\n盈利次数：____\r\n亏损次数：____\r\n胜率：____%\r\n平均盈利：____\r\n平均亏损：____\r\n盈亏比：____\r\n总盈亏：____\r\n```\r\n\r\n### 3. 每月复盘\r\n\r\n**复盘内容**：\r\n- 月度交易总结\r\n- 系统优化建议\r\n- 心理状态评估\r\n- 下月目标设定\r\n\r\n**分析维度**：\r\n- 最佳交易分析\r\n- 最差交易分析\r\n- 错过的机会\r\n- 不该做的交易\r\n\r\n---\r\n\r\n## 五、常见问题与解决\r\n\r\n### 1. 模拟盈利实盘亏损\r\n\r\n**原因**：\r\n- 模拟时心态轻松\r\n- 实盘时情绪紧张\r\n- 执行力下降\r\n\r\n**解决方案**：\r\n- 模拟时严格要求自己\r\n- 实盘从小资金开始\r\n- 逐步增加资金\r\n\r\n### 2. 模拟交易不认真\r\n\r\n**原因**：\r\n- 没有真实损失\r\n- 缺乏紧迫感\r\n- 态度不端正\r\n\r\n**解决方案**：\r\n- 设定模拟交易目标\r\n- 记录并复盘每笔交易\r\n- 把模拟当实盘对待\r\n\r\n### 3. 急于进入实盘\r\n\r\n**建议**：\r\n- 至少模拟1-3个月\r\n- 完成50-100笔交易\r\n- 系统表现稳定后再实盘\r\n\r\n---\r\n\r\n## 六、模拟到实盘的过渡\r\n\r\n### 1. 过渡条件\r\n\r\n**系统验证**：\r\n- 模拟交易至少1个月\r\n- 交易次数超过30笔\r\n- 系统期望值为正\r\n\r\n**心理准备**：\r\n- 能够严格执行系统\r\n- 情绪控制良好\r\n- 接受可能的亏损\r\n\r\n### 2. 过渡方法\r\n\r\n**第一阶段**：\r\n- 用计划资金的10%开始\r\n- 严格执行系统\r\n- 观察实盘与模拟差异\r\n\r\n**第二阶段**：\r\n- 稳定后增加到30%\r\n- 继续验证系统\r\n- 调整心态\r\n\r\n**第三阶段**：\r\n- 逐步增加到计划资金\r\n- 保持交易纪律\r\n- 持续复盘改进\r\n\r\n---\r\n\r\n## 七、模拟交易检查清单\r\n\r\n### 开始前\r\n\r\n```\r\n□ 选择了合适的模拟平台\r\n□ 设定了合理的模拟资金\r\n□ 制定了交易系统规则\r\n□ 准备了交易记录模板\r\n□ 设定了模拟交易目标\r\n```\r\n\r\n### 进行中\r\n\r\n```\r\n□ 每笔交易都有计划\r\n□ 严格执行止损止盈\r\n□ 记录每一笔交易\r\n□ 每日进行复盘\r\n□ 控制交易频率\r\n```\r\n\r\n### 结束后\r\n\r\n```\r\n□ 统计了交易数据\r\n□ 分析了系统表现\r\n□ 总结了经验教训\r\n□ 优化了交易系统\r\n□ 制定了实盘计划\r\n```', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:40', '2025-12-21 00:09:40'), (17, 17, '小资金实盘交易指南', '从模拟到实盘的过渡方法、心理调适和风险控制', 'markdown', '# 小资金实盘交易指南\r\n\r\n## 一、从模拟到实盘的转变\r\n\r\n### 1. 实盘与模拟的区别\r\n\r\n| 方面 | 模拟交易 | 实盘交易 |\r\n|-----|---------|---------|\r\n| 资金 | 虚拟资金 | 真实资金 |\r\n| 心理 | 相对轻松 | 压力较大 |\r\n| 执行 | 容易执行 | 可能犹豫 |\r\n| 滑点 | 几乎没有 | 可能存在 |\r\n| 情绪 | 影响小 | 影响大 |\r\n\r\n### 2. 实盘前的准备\r\n\r\n**资金准备**：\r\n- 只用闲钱交易\r\n- 亏完不影响生活\r\n- 建议初始资金1000-5000U\r\n\r\n**心理准备**：\r\n- 接受可能全部亏损\r\n- 把它当作学费\r\n- 不要有暴富心理\r\n\r\n**系统准备**：\r\n- 模拟验证过的系统\r\n- 明确的交易规则\r\n- 完善的风险管理\r\n\r\n---\r\n\r\n## 二、小资金实盘策略\r\n\r\n### 1. 资金分配\r\n\r\n**建议分配**：\r\n- 总资金的10-20%用于实盘\r\n- 其余资金作为后备\r\n- 逐步增加实盘资金\r\n\r\n**示例**：\r\n```\r\n总可投资资金：10000U\r\n初始实盘资金：1000U（10%）\r\n后备资金：9000U\r\n\r\n第一阶段：1000U实盘\r\n稳定盈利后：增加到2000U\r\n持续稳定后：增加到5000U\r\n```\r\n\r\n### 2. 仓位控制\r\n\r\n**小资金仓位原则**：\r\n- 单笔风险不超过总资金2%\r\n- 小资金可适当放宽到3%\r\n- 但绝不超过5%\r\n\r\n**仓位计算示例**：\r\n```\r\n资金：1000U\r\n单笔风险：2%（20U）\r\n止损距离：2%\r\n仓位 = 20U / 2% = 1000U\r\n实际可用仓位：1000U（满仓）\r\n\r\n建议：降低仓位到500U\r\n保留资金应对连续亏损\r\n```\r\n\r\n### 3. 交易频率\r\n\r\n**建议频率**：\r\n- 每周1-3笔交易\r\n- 只做高概率机会\r\n- 不要过度交易\r\n\r\n**原因**：\r\n- 小资金经不起频繁止损\r\n- 手续费占比较高\r\n- 需要精选机会\r\n\r\n---\r\n\r\n## 三、实盘心理调适\r\n\r\n### 1. 常见心理问题\r\n\r\n**害怕亏损**：\r\n- 表现：不敢入场，过早止盈\r\n- 原因：真金白银的压力\r\n- 解决：接受亏损是交易的一部分\r\n\r\n**急于求成**：\r\n- 表现：重仓、频繁交易\r\n- 原因：想快速赚钱\r\n- 解决：设定合理预期\r\n\r\n**患得患失**：\r\n- 表现：盯盘、情绪波动\r\n- 原因：对结果过度关注\r\n- 解决：关注过程而非结果\r\n\r\n### 2. 心理调适方法\r\n\r\n**设定合理预期**：\r\n- 第一年目标：不亏或小亏\r\n- 月收益预期：5-10%\r\n- 接受波动和回撤\r\n\r\n**建立交易routine**：\r\n- 固定时间分析市场\r\n- 固定时间复盘\r\n- 不要全天盯盘\r\n\r\n**保持生活平衡**：\r\n- 交易只是生活的一部分\r\n- 保持其他兴趣爱好\r\n- 不要让交易影响生活\r\n\r\n---\r\n\r\n## 四、实盘风险控制\r\n\r\n### 1. 止损纪律\r\n\r\n**铁律**：\r\n- 每笔交易必须设止损\r\n- 止损触发必须执行\r\n- 不要移动止损（除非是移动止盈）\r\n\r\n**止损设置**：\r\n- 技术位止损优先\r\n- 最大止损不超过3%\r\n- 考虑滑点因素\r\n\r\n### 2. 每日风险限额\r\n\r\n**建议设置**：\r\n- 每日最大亏损：总资金的5%\r\n- 达到限额后停止交易\r\n- 第二天再重新开始\r\n\r\n**示例**：\r\n```\r\n资金：1000U\r\n每日最大亏损：50U\r\n单笔风险：20U\r\n最多亏损2-3笔后停止\r\n```\r\n\r\n### 3. 回撤控制\r\n\r\n**回撤限额**：\r\n- 最大回撤：20%\r\n- 达到10%回撤：减少仓位\r\n- 达到20%回撤：暂停交易复盘\r\n\r\n---\r\n\r\n## 五、实盘交易清单\r\n\r\n### 交易前\r\n\r\n```\r\n□ 市场分析完成\r\n□ 交易计划明确\r\n□ 入场点位确定\r\n□ 止损位置设定\r\n□ 止盈目标明确\r\n□ 仓位大小计算\r\n□ 风险在承受范围内\r\n□ 情绪状态稳定\r\n```\r\n\r\n### 交易中\r\n\r\n```\r\n□ 按计划入场\r\n□ 止损单已设置\r\n□ 不频繁查看\r\n□ 不临时改变计划\r\n□ 记录交易信息\r\n```\r\n\r\n### 交易后\r\n\r\n```\r\n□ 记录交易结果\r\n□ 分析执行情况\r\n□ 总结经验教训\r\n□ 更新交易日志\r\n□ 准备下次交易\r\n```\r\n\r\n---\r\n\r\n## 六、第一个月目标\r\n\r\n### 量化目标\r\n\r\n```\r\n交易次数：10-15笔\r\n胜率目标：40%以上\r\n盈亏比目标：1.5:1以上\r\n最大回撤：< 15%\r\n```\r\n\r\n### 学习目标\r\n\r\n```\r\n□ 适应实盘交易节奏\r\n□ 克服实盘心理障碍\r\n□ 严格执行交易系统\r\n□ 建立完善的交易记录\r\n□ 发现并改进问题\r\n```\r\n\r\n---\r\n\r\n## 七、常见错误与避免\r\n\r\n1. **一开始就重仓**：应该从小仓位开始\r\n2. **不设止损**：每笔交易必须有止损\r\n3. **频繁交易**：只做高概率机会\r\n4. **情绪化交易**：严格按计划执行\r\n5. **急于加大资金**：稳定后再增加\r\n6. **不做记录**：每笔交易都要记录', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51'), (18, 18, '交易日志与数据分析', '建立完善的交易日志系统，通过数据分析持续改进', 'markdown', '# 交易日志与数据分析\r\n\r\n## 一、交易日志的重要性\r\n\r\n### 1. 为什么要记录交易日志\r\n\r\n**发现问题**：\r\n- 找出亏损的原因\r\n- 识别重复犯的错误\r\n- 发现情绪化交易模式\r\n\r\n**持续改进**：\r\n- 基于数据优化系统\r\n- 量化交易表现\r\n- 追踪进步\r\n\r\n**建立纪律**：\r\n- 强制自己思考\r\n- 提高执行力\r\n- 培养专业习惯\r\n\r\n### 2. 记录什么内容\r\n\r\n**基本信息**：\r\n- 日期时间\r\n- 交易品种\r\n- 方向（多/空）\r\n- 入场价、出场价\r\n- 仓位大小\r\n- 盈亏结果\r\n\r\n**分析信息**：\r\n- 入场理由\r\n- 出场理由\r\n- 市场环境\r\n- 技术形态\r\n\r\n**心理信息**：\r\n- 入场时情绪\r\n- 持仓时情绪\r\n- 出场时情绪\r\n- 事后反思\r\n\r\n---\r\n\r\n## 二、交易日志模板\r\n\r\n### 完整交易记录\r\n\r\n```\r\n═══════════════════════════════════════\r\n交易编号：#001\r\n日期：2024-01-15\r\n品种：BTC/USDT\r\n方向：做多\r\n\r\n【入场信息】\r\n入场时间：14:30\r\n入场价格：42500\r\n止损价格：41500（-2.35%）\r\n止盈价格：45000（+5.88%）\r\n仓位大小：0.1 BTC\r\n风险金额：100U（2%）\r\n\r\n【入场理由】\r\n技术面：\r\n- 日线MA20上穿MA50\r\n- 4小时MACD金叉\r\n- 价格突破42000阻力后回踩确认\r\n\r\n基本面：\r\n- ETF预期利好\r\n- 市场情绪偏多\r\n\r\n【出场信息】\r\n出场时间：2024-01-18 10:00\r\n出场价格：44200\r\n盈亏金额：+170U\r\n盈亏比例：+4%\r\n持仓时间：3天\r\n\r\n【出场理由】\r\n- 接近目标位\r\n- 4小时RSI超买\r\n- 锁定利润\r\n\r\n【交易复盘】\r\n执行评分：8/10\r\n情绪状态：入场时略紧张，持仓时平稳\r\n\r\n做得好的：\r\n- 严格按计划入场\r\n- 没有提前止盈\r\n- 情绪控制良好\r\n\r\n需要改进的：\r\n- 可以等更好的入场点\r\n- 止盈可以更有耐心\r\n\r\n经验教训：\r\n- 回踩确认入场效果好\r\n- 趋势交易要有耐心\r\n═══════════════════════════════════════\r\n```\r\n\r\n---\r\n\r\n## 三、数据统计与分析\r\n\r\n### 1. 基础统计指标\r\n\r\n**交易次数统计**：\r\n```\r\n总交易次数：____\r\n盈利次数：____\r\n亏损次数：____\r\n持平次数：____\r\n```\r\n\r\n**胜率计算**：\r\n```\r\n胜率 = 盈利次数 / 总交易次数 × 100%\r\n目标：40-60%\r\n```\r\n\r\n**盈亏比计算**：\r\n```\r\n平均盈利 = 总盈利 / 盈利次数\r\n平均亏损 = 总亏损 / 亏损次数\r\n盈亏比 = 平均盈利 / 平均亏损\r\n目标：> 1.5\r\n```\r\n\r\n**期望值计算**：\r\n```\r\n期望值 = (胜率 × 平均盈利) - (败率 × 平均亏损)\r\n期望值 > 0 才能长期盈利\r\n```\r\n\r\n### 2. 进阶分析维度\r\n\r\n**按时间分析**：\r\n- 哪个时间段交易效果好\r\n- 周几交易效果好\r\n- 持仓多久效果好\r\n\r\n**按品种分析**：\r\n- 哪个品种胜率高\r\n- 哪个品种盈亏比好\r\n- 应该专注哪个品种\r\n\r\n**按策略分析**：\r\n- 趋势策略 vs 震荡策略\r\n- 突破策略 vs 回调策略\r\n- 哪种策略更适合自己\r\n\r\n**按情绪分析**：\r\n- 情绪好时交易效果\r\n- 情绪差时交易效果\r\n- 情绪对决策的影响\r\n\r\n---\r\n\r\n## 四、常见问题诊断\r\n\r\n### 1. 胜率低的原因\r\n\r\n**可能原因**：\r\n- 逆势交易\r\n- 入场时机不好\r\n- 止损设置太紧\r\n\r\n**解决方案**：\r\n- 只顺势交易\r\n- 等待回调入场\r\n- 给止损更多空间\r\n\r\n### 2. 盈亏比低的原因\r\n\r\n**可能原因**：\r\n- 过早止盈\r\n- 止损太宽\r\n- 不让利润奔跑\r\n\r\n**解决方案**：\r\n- 使用移动止损\r\n- 优化止损位置\r\n- 培养持仓耐心\r\n\r\n### 3. 频繁止损的原因\r\n\r\n**可能原因**：\r\n- 震荡市使用趋势策略\r\n- 止损设置太紧\r\n- 入场点位不好\r\n\r\n**解决方案**：\r\n- 识别市场状态\r\n- 根据ATR设置止损\r\n- 等待更好的入场点\r\n\r\n### 4. 大亏的原因\r\n\r\n**可能原因**：\r\n- 没有止损\r\n- 仓位太重\r\n- 逆势加仓\r\n\r\n**解决方案**：\r\n- 严格执行止损\r\n- 控制仓位大小\r\n- 禁止亏损加仓\r\n\r\n---\r\n\r\n## 五、改进行动计划\r\n\r\n### 1. 问题识别\r\n\r\n```\r\n通过数据分析发现的主要问题：\r\n1. ____________________\r\n2. ____________________\r\n3. ____________________\r\n```\r\n\r\n### 2. 改进措施\r\n\r\n```\r\n针对问题1的改进措施：\r\n- 具体行动：____\r\n- 执行时间：____\r\n- 验证方法：____\r\n\r\n针对问题2的改进措施：\r\n- 具体行动：____\r\n- 执行时间：____\r\n- 验证方法：____\r\n```\r\n\r\n### 3. 效果追踪\r\n\r\n```\r\n改进前数据：\r\n- 胜率：____%\r\n- 盈亏比：____\r\n- 期望值：____\r\n\r\n改进后数据（1个月后）：\r\n- 胜率：____%\r\n- 盈亏比：____\r\n- 期望值：____\r\n\r\n改进效果评估：____\r\n```\r\n\r\n---\r\n\r\n## 六、数据分析工具\r\n\r\n### 1. Excel/表格\r\n\r\n**优点**：\r\n- 简单易用\r\n- 自定义强\r\n- 免费\r\n\r\n**适合**：\r\n- 初学者\r\n- 交易次数不多\r\n\r\n### 2. 专业交易日志软件\r\n\r\n**推荐**：\r\n- Tradervue\r\n- Edgewonk\r\n- TraderSync\r\n\r\n**优点**：\r\n- 自动统计\r\n- 可视化分析\r\n- 专业报告\r\n\r\n### 3. 自建系统\r\n\r\n**适合**：\r\n- 有编程能力\r\n- 需要定制化分析\r\n- 交易量大\r\n\r\n---\r\n\r\n## 七、日志分析习惯\r\n\r\n### 每日\r\n\r\n- 记录当日交易\r\n- 简单复盘\r\n- 5-10分钟\r\n\r\n### 每周\r\n\r\n- 统计周数据\r\n- 分析问题\r\n- 制定改进计划\r\n- 30分钟\r\n\r\n### 每月\r\n\r\n- 全面数据分析\r\n- 系统优化\r\n- 目标调整\r\n- 1-2小时', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51'), (19, 19, '高级图表形态与斐波那契分析', '深入学习复杂图表形态和斐波那契工具的应用', 'markdown', '# 高级图表形态与斐波那契分析\r\n\r\n## 一、经典反转形态\r\n\r\n### 1. 头肩顶/头肩底\r\n\r\n**头肩顶（看跌）**：\r\n```\r\n形态结构：\r\n    头\r\n   /  \\\r\n左肩    右肩\r\n  \\    /\r\n   颈线\r\n```\r\n\r\n**识别要点**：\r\n- 左肩、头、右肩依次形成\r\n- 头部最高，两肩相对对称\r\n- 颈线连接两个低点\r\n\r\n**交易方法**：\r\n- 入场：跌破颈线后做空\r\n- 止损：右肩高点上方\r\n- 目标：头部到颈线的距离\r\n\r\n**成功率**：约70%\r\n\r\n**头肩底（看涨）**：\r\n- 形态相反\r\n- 突破颈线做多\r\n- 目标计算方法相同\r\n\r\n### 2. 双顶/双底\r\n\r\n**双顶（M顶）**：\r\n```\r\n  顶1   顶2\r\n   \\   /\r\n    \\ /\r\n    颈线\r\n```\r\n\r\n**识别要点**：\r\n- 两个高点相近\r\n- 中间有明显回调\r\n- 第二个顶部成交量减少\r\n\r\n**交易方法**：\r\n- 入场：跌破颈线\r\n- 止损：第二个顶部上方\r\n- 目标：顶部到颈线的距离\r\n\r\n**双底（W底）**：\r\n- 形态相反\r\n- 突破颈线做多\r\n\r\n### 3. 三重顶/三重底\r\n\r\n**特点**：\r\n- 比双顶/双底多一个顶/底\r\n- 更可靠但出现频率低\r\n- 交易方法类似\r\n\r\n---\r\n\r\n## 二、持续形态\r\n\r\n### 1. 三角形\r\n\r\n**对称三角形**：\r\n```\r\n    /\\\r\n   /  \\\r\n  /    \\\r\n /      \\\r\n/________\\\r\n```\r\n\r\n**特点**：\r\n- 高点降低，低点抬高\r\n- 波动逐渐收窄\r\n- 突破方向不确定\r\n\r\n**交易方法**：\r\n- 等待突破方向\r\n- 突破后顺势交易\r\n- 目标：三角形最宽处\r\n\r\n**上升三角形**：\r\n- 水平阻力 + 上升支撑\r\n- 通常向上突破\r\n- 看涨形态\r\n\r\n**下降三角形**：\r\n- 下降阻力 + 水平支撑\r\n- 通常向下突破\r\n- 看跌形态\r\n\r\n### 2. 旗形与楔形\r\n\r\n**旗形**：\r\n```\r\n上升旗形：\r\n     /|\r\n    / |\r\n   /  |\r\n  /   |\r\n /    |\r\n旗杆  旗面\r\n```\r\n\r\n**特点**：\r\n- 急涨/急跌后的整理\r\n- 旗面与趋势方向相反\r\n- 突破后继续原趋势\r\n\r\n**楔形**：\r\n- 类似三角形但倾斜\r\n- 上升楔形看跌\r\n- 下降楔形看涨\r\n\r\n### 3. 矩形\r\n\r\n**特点**：\r\n- 水平支撑和阻力\r\n- 价格在区间内波动\r\n- 突破后趋势延续\r\n\r\n**交易方法**：\r\n- 区间内高抛低吸\r\n- 突破后顺势交易\r\n- 目标：矩形高度\r\n\r\n---\r\n\r\n## 三、斐波那契工具\r\n\r\n### 1. 斐波那契回撤\r\n\r\n**关键比例**：\r\n- 23.6%：浅回调\r\n- 38.2%：正常回调\r\n- 50%：中等回调\r\n- 61.8%：深度回调（黄金分割）\r\n- 78.6%：极深回调\r\n\r\n**使用方法**：\r\n1. 找出一段明确的趋势\r\n2. 从起点拉到终点\r\n3. 观察价格在回撤位的反应\r\n\r\n**交易应用**：\r\n- 38.2%-61.8%是最常用的入场区域\r\n- 回撤到这些位置+看涨信号=做多\r\n- 结合其他支撑阻力更有效\r\n\r\n### 2. 斐波那契扩展\r\n\r\n**关键比例**：\r\n- 100%：等距目标\r\n- 127.2%：常见目标\r\n- 161.8%：黄金扩展\r\n- 200%：双倍目标\r\n- 261.8%：极限目标\r\n\r\n**使用方法**：\r\n1. 找出一段趋势（A到B）\r\n2. 找出回调低点（C）\r\n3. 从A-B-C画出扩展\r\n4. 预测目标位置\r\n\r\n### 3. 斐波那契时间\r\n\r\n**应用**：\r\n- 预测时间周期\r\n- 重要时间节点\r\n- 结合价格分析\r\n\r\n---\r\n\r\n## 四、形态交易系统\r\n\r\n### 系统示例\r\n\r\n```\r\n【系统名称】形态突破交易系统\r\n\r\n【形态识别】\r\n- 头肩形态\r\n- 双顶/双底\r\n- 三角形\r\n- 旗形\r\n\r\n【入场条件】\r\n1. 形态完整形成\r\n2. 突破颈线/边界\r\n3. 成交量放大确认\r\n4. 回踩确认（可选）\r\n\r\n【止损设置】\r\n- 头肩：右肩外侧\r\n- 双顶/底：第二个顶/底外侧\r\n- 三角形：三角形内\r\n- 旗形：旗面外侧\r\n\r\n【止盈设置】\r\n- 第一目标：形态高度\r\n- 第二目标：1.5倍形态高度\r\n- 使用移动止损\r\n\r\n【仓位管理】\r\n- 单笔风险2%\r\n- 确认后可加仓\r\n```\r\n\r\n---\r\n\r\n## 五、斐波那契交易策略\r\n\r\n### 回调买入策略\r\n\r\n```\r\n【条件】\r\n1. 明确的上涨趋势\r\n2. 价格回调到38.2%-61.8%区域\r\n3. 出现看涨K线形态\r\n4. 其他指标确认（RSI、MACD）\r\n\r\n【入场】\r\n在斐波那契支撑区域入场\r\n\r\n【止损】\r\n61.8%下方或78.6%下方\r\n\r\n【止盈】\r\n前高或斐波那契扩展位\r\n```\r\n\r\n### 扩展目标策略\r\n\r\n```\r\n【使用场景】\r\n突破后预测目标位\r\n\r\n【方法】\r\n1. 画出斐波那契扩展\r\n2. 127.2%作为第一目标\r\n3. 161.8%作为第二目标\r\n4. 分批止盈\r\n```\r\n\r\n---\r\n\r\n## 六、实战技巧\r\n\r\n### 1. 形态识别技巧\r\n\r\n- 在日线以上周期寻找形态\r\n- 形态越大越可靠\r\n- 等待形态完成再交易\r\n- 结合成交量确认\r\n\r\n### 2. 斐波那契使用技巧\r\n\r\n- 选择明显的波段\r\n- 多个斐波那契位重合更有效\r\n- 结合水平支撑阻力\r\n- 不要过度依赖\r\n\r\n### 3. 常见错误\r\n\r\n- 过早判断形态\r\n- 不等待突破确认\r\n- 止损设置不合理\r\n- 忽视大趋势方向', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51'), (20, 20, '市场情绪分析与逆向交易', '深入理解市场情绪指标和逆向交易策略', 'markdown', '# 市场情绪分析与逆向交易\r\n\r\n## 一、市场情绪概述\r\n\r\n### 1. 什么是市场情绪\r\n\r\n**定义**：市场参与者整体的心理状态和预期\r\n\r\n**情绪周期**：\r\n```\r\n极度贪婪 → 乐观 → 中性 → 恐惧 → 极度恐惧\r\n    ↑                                    ↓\r\n    ←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←\r\n```\r\n\r\n**情绪与价格的关系**：\r\n- 极度贪婪时往往是顶部\r\n- 极度恐惧时往往是底部\r\n- 情绪是反向指标\r\n\r\n### 2. 为什么要分析情绪\r\n\r\n**辅助判断顶底**：\r\n- 技术分析的补充\r\n- 识别极端情况\r\n- 提高交易胜率\r\n\r\n**理解市场行为**：\r\n- 为什么会暴涨暴跌\r\n- 大众心理如何影响价格\r\n- 如何利用情绪获利\r\n\r\n---\r\n\r\n## 二、情绪指标详解\r\n\r\n### 1. 恐惧贪婪指数\r\n\r\n**数据来源**：Alternative.me\r\n\r\n**指数范围**：0-100\r\n- 0-25：极度恐惧\r\n- 25-45：恐惧\r\n- 45-55：中性\r\n- 55-75：贪婪\r\n- 75-100：极度贪婪\r\n\r\n**计算因素**：\r\n- 波动率（25%）\r\n- 市场动量（25%）\r\n- 社交媒体（15%）\r\n- 调查（15%）\r\n- 比特币主导地位（10%）\r\n- 谷歌趋势（10%）\r\n\r\n**使用方法**：\r\n- 极度恐惧（<20）：考虑买入\r\n- 极度贪婪（>80）：考虑卖出\r\n- 作为参考而非唯一依据\r\n\r\n### 2. 资金费率\r\n\r\n**定义**：永续合约多空双方的费用交换\r\n\r\n**解读**：\r\n- 正费率：多头付给空头，市场偏多\r\n- 负费率：空头付给多头，市场偏空\r\n- 费率越高，情绪越极端\r\n\r\n**极端值参考**：\r\n- 费率 > 0.1%：过度乐观\r\n- 费率 < -0.1%：过度悲观\r\n\r\n**交易应用**：\r\n- 高正费率 + 价格滞涨 = 可能回调\r\n- 高负费率 + 价格企稳 = 可能反弹\r\n\r\n### 3. 多空比\r\n\r\n**定义**：多头持仓与空头持仓的比例\r\n\r\n**数据来源**：\r\n- 交易所公布的多空比\r\n- 大户持仓比例\r\n- 散户持仓比例\r\n\r\n**解读**：\r\n- 多空比过高：多头拥挤，注意风险\r\n- 多空比过低：空头拥挤，可能反弹\r\n\r\n### 4. 未平仓合约（OI）\r\n\r\n**定义**：市场上未平仓的合约总量\r\n\r\n**解读**：\r\n- OI增加 + 价格上涨：趋势健康\r\n- OI增加 + 价格下跌：趋势健康\r\n- OI减少 + 价格变化：趋势可能结束\r\n\r\n**极端情况**：\r\n- OI创新高：市场过热\r\n- OI大幅下降：大量平仓，趋势可能反转\r\n\r\n### 5. 社交媒体情绪\r\n\r\n**监测渠道**：\r\n- Twitter/X\r\n- Reddit\r\n- Telegram群组\r\n- 微博、微信群\r\n\r\n**情绪信号**：\r\n- 全民喊多：可能见顶\r\n- 全民恐慌：可能见底\r\n- 无人关注：可能是底部\r\n\r\n---\r\n\r\n## 三、逆向交易策略\r\n\r\n### 1. 逆向交易的原理\r\n\r\n**核心思想**：\r\n- 大众通常是错的\r\n- 极端情绪往往是反转信号\r\n- 在别人恐惧时贪婪，在别人贪婪时恐惧\r\n\r\n**适用条件**：\r\n- 情绪达到极端\r\n- 有技术面配合\r\n- 风险可控\r\n\r\n### 2. 极度恐惧买入策略\r\n\r\n**入场条件**：\r\n1. 恐惧贪婪指数 < 20\r\n2. 资金费率为负\r\n3. 价格在重要支撑位\r\n4. 出现看涨K线形态\r\n\r\n**止损设置**：\r\n- 支撑位下方\r\n- 或固定百分比（5-10%）\r\n\r\n**止盈设置**：\r\n- 恐惧指数回到50以上\r\n- 或技术阻力位\r\n\r\n### 3. 极度贪婪卖出策略\r\n\r\n**入场条件**：\r\n1. 恐惧贪婪指数 > 80\r\n2. 资金费率异常高\r\n3. 价格在重要阻力位\r\n4. 出现看跌K线形态\r\n\r\n**止损设置**：\r\n- 阻力位上方\r\n- 或固定百分比\r\n\r\n**止盈设置**：\r\n- 贪婪指数回到50以下\r\n- 或技术支撑位\r\n\r\n---\r\n\r\n## 四、情绪分析实战框架\r\n\r\n### 每日情绪检查清单\r\n\r\n```\r\n□ 恐惧贪婪指数：____\r\n□ 资金费率：____%\r\n□ 多空比：____\r\n□ 未平仓合约变化：____\r\n□ 社交媒体情绪：____\r\n□ 综合评估：____\r\n```\r\n\r\n### 情绪交易决策表\r\n\r\n| 情绪状态 | 技术面 | 操作建议 |\r\n|---------|-------|---------|\r\n| 极度恐惧 | 支撑位 | 分批买入 |\r\n| 极度恐惧 | 破位 | 观望 |\r\n| 极度贪婪 | 阻力位 | 分批卖出 |\r\n| 极度贪婪 | 突破 | 谨慎追多 |\r\n| 中性 | - | 按技术面交易 |\r\n\r\n---\r\n\r\n## 五、注意事项\r\n\r\n### 1. 情绪可以更极端\r\n\r\n- 极度恐惧可以更恐惧\r\n- 极度贪婪可以更贪婪\r\n- 不要过早抄底摸顶\r\n\r\n### 2. 结合技术分析\r\n\r\n- 情绪只是辅助工具\r\n- 需要技术面确认\r\n- 不能单独使用\r\n\r\n### 3. 控制风险\r\n\r\n- 逆向交易风险较高\r\n- 必须设置止损\r\n- 仓位要小\r\n\r\n### 4. 耐心等待\r\n\r\n- 极端情绪不常见\r\n- 等待最佳机会\r\n- 不要强行交易\r\n\r\n---\r\n\r\n## 六、情绪指标工具\r\n\r\n| 工具 | 网址 | 主要指标 |\r\n|-----|------|---------|\r\n| Alternative.me | alternative.me | 恐惧贪婪指数 |\r\n| Coinglass | coinglass.com | 资金费率、OI |\r\n| CryptoQuant | cryptoquant.com | 链上情绪 |\r\n| Santiment | santiment.net | 社交情绪 |\r\n| LunarCrush | lunarcrush.com | 社交媒体分析 |', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51'), (21, 21, '高级资金管理与复利增长', '学习高级资金管理技术和长期复利增长策略', 'markdown', '# 高级资金管理与复利增长\r\n\r\n## 一、复利的力量\r\n\r\n### 1. 复利计算\r\n\r\n**复利公式**：\r\n```\r\n终值 = 本金 × (1 + 收益率)^期数\r\n```\r\n\r\n**复利增长示例**：\r\n| 月收益 | 1年后 | 3年后 | 5年后 |\r\n|-------|-------|-------|-------|\r\n| 5% | 1.80倍 | 5.89倍 | 19.22倍 |\r\n| 10% | 3.14倍 | 30.91倍 | 304.48倍 |\r\n| 15% | 5.35倍 | 153.15倍 | 4383.99倍 |\r\n\r\n**关键认知**：\r\n- 稳定的小收益比大起大落更重要\r\n- 时间是复利最好的朋友\r\n- 避免大回撤是关键\r\n\r\n### 2. 回撤对复利的影响\r\n\r\n**回撤恢复表**：\r\n| 回撤 | 需要盈利 |\r\n|-----|---------|\r\n| 10% | 11.1% |\r\n| 20% | 25% |\r\n| 30% | 42.9% |\r\n| 50% | 100% |\r\n| 70% | 233% |\r\n| 90% | 900% |\r\n\r\n**结论**：\r\n- 控制回撤比追求高收益更重要\r\n- 大回撤会严重损害复利效果\r\n- 稳定盈利是长期成功的关键\r\n\r\n---\r\n\r\n## 二、高级仓位管理\r\n\r\n### 1. 动态仓位调整\r\n\r\n**根据账户盈亏调整**：\r\n```\r\n盈利时：\r\n- 账户增长20%：仓位可增加10%\r\n- 账户增长50%：仓位可增加20%\r\n\r\n亏损时：\r\n- 账户回撤10%：仓位减少20%\r\n- 账户回撤20%：仓位减少50%\r\n```\r\n\r\n**根据市场状态调整**：\r\n```\r\n趋势明确时：\r\n- 仓位可以适当增加\r\n- 最大不超过计划的150%\r\n\r\n震荡/不确定时：\r\n- 仓位减少到计划的50-70%\r\n- 或者不交易\r\n```\r\n\r\n### 2. 金字塔加仓法\r\n\r\n**原理**：趋势确认后逐步加仓\r\n\r\n**方法**：\r\n```\r\n第一仓：50%计划仓位\r\n确认后第二仓：30%计划仓位\r\n再确认第三仓：20%计划仓位\r\n```\r\n\r\n**规则**：\r\n- 只在盈利时加仓\r\n- 每次加仓量递减\r\n- 加仓后调整止损到成本价\r\n\r\n**示例**：\r\n```\r\n计划仓位：1 BTC\r\n入场价：50000\r\n\r\n第一仓：0.5 BTC @ 50000\r\n价格涨到52000，加仓\r\n第二仓：0.3 BTC @ 52000\r\n价格涨到54000，加仓\r\n第三仓：0.2 BTC @ 54000\r\n\r\n平均成本：51400\r\n止损移到51400（保本）\r\n```\r\n\r\n### 3. 分批止盈法\r\n\r\n**方法**：\r\n```\r\n第一目标（1R）：平仓30%\r\n第二目标（2R）：平仓30%\r\n剩余40%：移动止损跟踪\r\n```\r\n\r\n**优点**：\r\n- 锁定部分利润\r\n- 保留上涨空间\r\n- 心理压力小\r\n\r\n---\r\n\r\n## 三、资金曲线管理\r\n\r\n### 1. 理想的资金曲线\r\n\r\n**特征**：\r\n- 稳步上升\r\n- 回撤可控（<20%）\r\n- 没有大起大落\r\n\r\n**目标**：\r\n- 月度正收益\r\n- 季度稳定增长\r\n- 年度目标达成\r\n\r\n### 2. 回撤控制策略\r\n\r\n**预防措施**：\r\n- 严格止损\r\n- 控制单笔风险\r\n- 分散交易\r\n\r\n**回撤应对**：\r\n```\r\n回撤5%：正常波动，继续交易\r\n回撤10%：减少仓位50%\r\n回撤15%：减少仓位70%\r\n回撤20%：暂停交易，复盘\r\n```\r\n\r\n### 3. 盈利保护策略\r\n\r\n**定期提取利润**：\r\n```\r\n每月盈利超过10%：提取50%利润\r\n每季度：提取累计利润的30%\r\n```\r\n\r\n**建立安全垫**：\r\n```\r\n初始资金：10000U\r\n盈利5000U后：\r\n- 提取5000U作为安全垫\r\n- 用10000U继续交易\r\n- 即使全亏也不伤本金\r\n```\r\n\r\n---\r\n\r\n## 四、长期资金规划\r\n\r\n### 1. 阶段性目标\r\n\r\n**第一阶段（1-6个月）**：\r\n- 目标：不亏或小亏\r\n- 重点：学习和验证系统\r\n- 资金：小资金实盘\r\n\r\n**第二阶段（6-12个月）**：\r\n- 目标：稳定盈利\r\n- 重点：完善系统和心态\r\n- 资金：逐步增加\r\n\r\n**第三阶段（1-3年）**：\r\n- 目标：持续复利增长\r\n- 重点：扩大规模\r\n- 资金：达到目标规模\r\n\r\n### 2. 收益预期管理\r\n\r\n**合理预期**：\r\n- 月收益：5-15%\r\n- 年收益：50-200%\r\n- 最大回撤：<20%\r\n\r\n**不合理预期**：\r\n- 月翻倍\r\n- 稳赚不赔\r\n- 快速致富\r\n\r\n### 3. 风险预算\r\n\r\n**年度风险预算**：\r\n```\r\n总资金：10000U\r\n年度最大可亏损：2000U（20%）\r\n每月风险预算：约170U\r\n每周风险预算：约40U\r\n```\r\n\r\n---\r\n\r\n## 五、资金管理规则总结\r\n\r\n### 核心规则\r\n\r\n```\r\n1. 单笔风险 ≤ 2%\r\n2. 总仓位 ≤ 30%\r\n3. 最大回撤 ≤ 20%\r\n4. 盈利时可适当加仓\r\n5. 亏损时必须减仓\r\n6. 定期提取利润\r\n```\r\n\r\n### 禁止事项\r\n\r\n```\r\n1. 禁止满仓操作\r\n2. 禁止亏损加仓\r\n3. 禁止不设止损\r\n4. 禁止借钱交易\r\n5. 禁止情绪化调整仓位\r\n```\r\n\r\n---\r\n\r\n## 六、实战建议\r\n\r\n1. **稳定优先**：追求稳定收益而非暴利\r\n2. **控制回撤**：回撤是复利的最大敌人\r\n3. **耐心复利**：时间会放大收益\r\n4. **定期复盘**：监控资金曲线\r\n5. **保护本金**：本金是一切的基础\r\n6. **长期思维**：用年为单位思考', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51'), (22, 22, '交易系统评估与优化方法', '学习如何评估交易系统表现并进行科学优化', 'markdown', '# 交易系统评估与优化方法\r\n\r\n## 一、系统评估指标\r\n\r\n### 1. 基础指标\r\n\r\n**胜率（Win Rate）**：\r\n```\r\n胜率 = 盈利次数 / 总交易次数 × 100%\r\n\r\n评估标准：\r\n- 趋势系统：30-50%正常\r\n- 震荡系统：50-70%正常\r\n```\r\n\r\n**盈亏比（Risk/Reward）**：\r\n```\r\n盈亏比 = 平均盈利 / 平均亏损\r\n\r\n评估标准：\r\n- 最低要求：1.5:1\r\n- 良好：2:1以上\r\n- 优秀：3:1以上\r\n```\r\n\r\n**期望值（Expectancy）**：\r\n```\r\n期望值 = (胜率 × 平均盈利) - (败率 × 平均亏损)\r\n\r\n评估标准：\r\n- 必须 > 0\r\n- 越高越好\r\n```\r\n\r\n### 2. 进阶指标\r\n\r\n**最大回撤（Max Drawdown）**：\r\n```\r\n最大回撤 = (峰值 - 谷值) / 峰值 × 100%\r\n\r\n评估标准：\r\n- 优秀：< 15%\r\n- 良好：15-25%\r\n- 可接受：25-35%\r\n- 需改进：> 35%\r\n```\r\n\r\n**夏普比率（Sharpe Ratio）**：\r\n```\r\n夏普比率 = (收益率 - 无风险利率) / 收益标准差\r\n\r\n评估标准：\r\n- > 1：可接受\r\n- > 2：良好\r\n- > 3：优秀\r\n```\r\n\r\n**盈利因子（Profit Factor）**：\r\n```\r\n盈利因子 = 总盈利 / 总亏损\r\n\r\n评估标准：\r\n- > 1.5：可接受\r\n- > 2：良好\r\n- > 3：优秀\r\n```\r\n\r\n**恢复因子（Recovery Factor）**：\r\n```\r\n恢复因子 = 净利润 / 最大回撤\r\n\r\n评估标准：\r\n- > 3：良好\r\n- > 5：优秀\r\n```\r\n\r\n---\r\n\r\n## 二、系统诊断\r\n\r\n### 1. 常见问题诊断\r\n\r\n**问题：胜率低**\r\n```\r\n可能原因：\r\n- 逆势交易\r\n- 入场时机不好\r\n- 止损太紧\r\n\r\n解决方案：\r\n- 只顺势交易\r\n- 等待回调入场\r\n- 根据ATR设置止损\r\n```\r\n\r\n**问题：盈亏比低**\r\n```\r\n可能原因：\r\n- 过早止盈\r\n- 止损太宽\r\n- 不让利润奔跑\r\n\r\n解决方案：\r\n- 使用移动止损\r\n- 优化止损位置\r\n- 分批止盈\r\n```\r\n\r\n**问题：回撤大**\r\n```\r\n可能原因：\r\n- 仓位太重\r\n- 不止损\r\n- 连续亏损不减仓\r\n\r\n解决方案：\r\n- 降低单笔风险\r\n- 严格执行止损\r\n- 亏损后减仓\r\n```\r\n\r\n### 2. 系统健康检查表\r\n\r\n```\r\n□ 期望值是否为正？\r\n□ 最大回撤是否可接受？\r\n□ 盈利因子是否 > 1.5？\r\n□ 胜率和盈亏比是否匹配？\r\n□ 系统在不同市场状态表现如何？\r\n□ 最近表现是否与历史一致？\r\n```\r\n\r\n---\r\n\r\n## 三、系统优化方法\r\n\r\n### 1. 参数优化\r\n\r\n**优化对象**：\r\n- 均线周期\r\n- 指标参数\r\n- 止损止盈比例\r\n\r\n**优化方法**：\r\n```\r\n1. 确定优化范围\r\n   例：MA周期从10到50\r\n\r\n2. 回测不同参数\r\n   MA10, MA15, MA20...\r\n\r\n3. 选择稳健参数\r\n   不选最优，选次优但稳定的\r\n\r\n4. 样本外验证\r\n   用新数据验证\r\n```\r\n\r\n**注意事项**：\r\n- 避免过度优化\r\n- 参数要有逻辑意义\r\n- 保持参数简单\r\n\r\n### 2. 规则优化\r\n\r\n**入场规则优化**：\r\n```\r\n原规则：MACD金叉入场\r\n优化后：MACD金叉 + 价格在MA20上方\r\n\r\n效果：过滤逆势信号\r\n```\r\n\r\n**出场规则优化**：\r\n```\r\n原规则：固定止盈2R\r\n优化后：1R止盈50%，剩余移动止损\r\n\r\n效果：锁定利润同时保留空间\r\n```\r\n\r\n**过滤条件优化**：\r\n```\r\n添加过滤：\r\n- 趋势过滤：只在趋势方向交易\r\n- 时间过滤：避开重要数据发布\r\n- 波动过滤：ATR过低时不交易\r\n```\r\n\r\n### 3. 避免过度优化\r\n\r\n**过度优化的特征**：\r\n- 参数过于精确（如MA17而非MA20）\r\n- 规则过于复杂\r\n- 历史表现完美但实盘差\r\n\r\n**避免方法**：\r\n- 使用简单参数（整数、常用值）\r\n- 规则不超过5个\r\n- 样本外测试验证\r\n- 保持逻辑合理性\r\n\r\n---\r\n\r\n## 四、优化流程\r\n\r\n### 标准优化流程\r\n\r\n```\r\n1. 收集数据\r\n   - 至少100笔交易\r\n   - 覆盖不同市场状态\r\n\r\n2. 计算指标\r\n   - 胜率、盈亏比、期望值\r\n   - 最大回撤、盈利因子\r\n\r\n3. 诊断问题\r\n   - 找出主要问题\r\n   - 分析原因\r\n\r\n4. 制定优化方案\r\n   - 针对性改进\r\n   - 一次只改一个变量\r\n\r\n5. 回测验证\r\n   - 用历史数据测试\r\n   - 对比优化前后\r\n\r\n6. 样本外验证\r\n   - 用新数据验证\r\n   - 确认改进有效\r\n\r\n7. 小资金实盘验证\r\n   - 实盘测试\r\n   - 观察实际效果\r\n\r\n8. 正式应用\r\n   - 确认有效后应用\r\n   - 持续监控\r\n```\r\n\r\n---\r\n\r\n## 五、持续改进\r\n\r\n### 1. 定期评估\r\n\r\n**每月评估**：\r\n- 计算月度指标\r\n- 对比历史表现\r\n- 识别问题\r\n\r\n**每季度评估**：\r\n- 全面系统评估\r\n- 考虑是否需要优化\r\n- 制定改进计划\r\n\r\n### 2. 记录变更\r\n\r\n```\r\n变更日志：\r\n日期：____\r\n变更内容：____\r\n变更原因：____\r\n预期效果：____\r\n实际效果：____\r\n```\r\n\r\n### 3. 版本管理\r\n\r\n```\r\n系统版本：v1.0\r\n- 基础趋势跟踪系统\r\n\r\n系统版本：v1.1\r\n- 添加趋势过滤条件\r\n\r\n系统版本：v1.2\r\n- 优化止盈策略\r\n```\r\n\r\n---\r\n\r\n## 六、优化注意事项\r\n\r\n1. **不要频繁修改**：给系统足够的验证时间\r\n2. **一次改一个**：便于评估效果\r\n3. **保持简单**：复杂不等于有效\r\n4. **尊重数据**：基于数据而非感觉\r\n5. **接受不完美**：没有完美的系统\r\n6. **持续学习**：市场在变化，系统也要进化', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51'), (23, 23, '多策略组合与资产配置', '学习策略组合原理和构建方法，实现收益平滑', 'markdown', '# 多策略组合与资产配置\r\n\r\n## 一、策略组合的意义\r\n\r\n### 1. 为什么需要多策略\r\n\r\n**单一策略的问题**：\r\n- 在某些市场状态下失效\r\n- 收益曲线波动大\r\n- 心理压力大\r\n\r\n**多策略的优势**：\r\n- 适应不同市场状态\r\n- 平滑收益曲线\r\n- 降低整体风险\r\n\r\n### 2. 策略组合的目标\r\n\r\n**主要目标**：\r\n- 降低最大回撤\r\n- 提高夏普比率\r\n- 稳定收益\r\n\r\n**次要目标**：\r\n- 减少空仓时间\r\n- 提高资金利用率\r\n- 分散风险\r\n\r\n---\r\n\r\n## 二、策略相关性分析\r\n\r\n### 1. 什么是策略相关性\r\n\r\n**定义**：两个策略收益之间的关联程度\r\n\r\n**相关系数**：\r\n- +1：完全正相关（同涨同跌）\r\n- 0：不相关\r\n- -1：完全负相关（一涨一跌）\r\n\r\n### 2. 理想的策略组合\r\n\r\n**低相关性组合**：\r\n- 策略A盈利时，策略B可能亏损\r\n- 策略A亏损时，策略B可能盈利\r\n- 整体收益更稳定\r\n\r\n**组合示例**：\r\n```\r\n策略A：趋势跟踪（趋势市盈利）\r\n策略B：均值回归（震荡市盈利）\r\n相关性：低或负相关\r\n组合效果：无论趋势还是震荡都有策略盈利\r\n```\r\n\r\n### 3. 相关性计算\r\n\r\n**简单方法**：\r\n- 观察两个策略的收益曲线\r\n- 是否同涨同跌\r\n- 主观判断相关性\r\n\r\n**量化方法**：\r\n- 计算收益的相关系数\r\n- 使用Excel或Python\r\n- 相关系数 < 0.3 为低相关\r\n\r\n---\r\n\r\n## 三、常见策略组合\r\n\r\n### 1. 趋势 + 震荡组合\r\n\r\n**策略A：趋势跟踪**\r\n- 适用：趋势市场\r\n- 特点：胜率低，盈亏比高\r\n\r\n**策略B：区间交易**\r\n- 适用：震荡市场\r\n- 特点：胜率高，盈亏比低\r\n\r\n**组合效果**：\r\n- 趋势市：策略A盈利，策略B小亏\r\n- 震荡市：策略B盈利，策略A小亏\r\n- 整体：收益更稳定\r\n\r\n### 2. 多周期组合\r\n\r\n**策略A：日线趋势**\r\n- 持仓时间：数天到数周\r\n- 交易频率：低\r\n\r\n**策略B：4小时波段**\r\n- 持仓时间：数小时到数天\r\n- 交易频率：中\r\n\r\n**策略C：1小时短线**\r\n- 持仓时间：数小时\r\n- 交易频率：高\r\n\r\n**组合效果**：\r\n- 不同时间维度捕捉机会\r\n- 提高资金利用率\r\n\r\n### 3. 多品种组合\r\n\r\n**策略应用于多个品种**：\r\n- BTC趋势策略\r\n- ETH趋势策略\r\n- 其他主流币策略\r\n\r\n**组合效果**：\r\n- 分散单一品种风险\r\n- 捕捉不同品种机会\r\n\r\n---\r\n\r\n## 四、资金分配方法\r\n\r\n### 1. 等权重分配\r\n\r\n**方法**：每个策略分配相同资金\r\n\r\n**示例**：\r\n```\r\n总资金：10000U\r\n策略A：3333U\r\n策略B：3333U\r\n策略C：3334U\r\n```\r\n\r\n**优点**：简单\r\n**缺点**：没有考虑策略表现差异\r\n\r\n### 2. 风险平价分配\r\n\r\n**方法**：根据策略波动率分配，使每个策略贡献相同风险\r\n\r\n**示例**：\r\n```\r\n策略A波动率：10%\r\n策略B波动率：20%\r\n策略C波动率：15%\r\n\r\n分配比例：\r\n策略A：40%\r\n策略B：20%\r\n策略C：26.7%\r\n```\r\n\r\n**优点**：风险更均衡\r\n**缺点**：计算复杂\r\n\r\n### 3. 表现加权分配\r\n\r\n**方法**：表现好的策略分配更多资金\r\n\r\n**示例**：\r\n```\r\n策略A夏普比率：2.0\r\n策略B夏普比率：1.5\r\n策略C夏普比率：1.0\r\n\r\n分配比例：\r\n策略A：44%\r\n策略B：33%\r\n策略C：22%\r\n```\r\n\r\n**优点**：优化收益\r\n**缺点**：可能过度集中\r\n\r\n---\r\n\r\n## 五、组合管理\r\n\r\n### 1. 定期再平衡\r\n\r\n**频率**：每月或每季度\r\n\r\n**方法**：\r\n```\r\n1. 计算当前各策略资金占比\r\n2. 与目标占比对比\r\n3. 调整到目标占比\r\n```\r\n\r\n**示例**：\r\n```\r\n目标：A:B:C = 40:30:30\r\n当前：A:B:C = 50:25:25\r\n操作：从A转移资金到B和C\r\n```\r\n\r\n### 2. 动态调整\r\n\r\n**根据市场状态调整**：\r\n```\r\n趋势市场：\r\n- 增加趋势策略权重\r\n- 减少震荡策略权重\r\n\r\n震荡市场：\r\n- 增加震荡策略权重\r\n- 减少趋势策略权重\r\n```\r\n\r\n**根据策略表现调整**：\r\n```\r\n策略连续亏损：\r\n- 减少该策略权重\r\n- 或暂停该策略\r\n\r\n策略持续盈利：\r\n- 可适当增加权重\r\n- 但不要过度集中\r\n```\r\n\r\n### 3. 风险监控\r\n\r\n**监控指标**：\r\n- 组合整体回撤\r\n- 各策略相关性变化\r\n- 单一策略占比\r\n\r\n**风险控制**：\r\n- 组合最大回撤 < 20%\r\n- 单一策略占比 < 50%\r\n- 相关性过高时调整\r\n\r\n---\r\n\r\n## 六、组合构建步骤\r\n\r\n### 实操流程\r\n\r\n```\r\n1. 选择策略\r\n   - 至少2-3个策略\r\n   - 逻辑不同\r\n   - 经过验证\r\n\r\n2. 分析相关性\r\n   - 计算历史相关性\r\n   - 选择低相关策略\r\n\r\n3. 确定权重\r\n   - 初始等权重\r\n   - 或根据风险分配\r\n\r\n4. 回测组合\r\n   - 测试组合表现\r\n   - 对比单一策略\r\n\r\n5. 实盘验证\r\n   - 小资金测试\r\n   - 观察实际效果\r\n\r\n6. 持续优化\r\n   - 定期再平衡\r\n   - 动态调整\r\n```\r\n\r\n---\r\n\r\n## 七、注意事项\r\n\r\n1. **不要过度分散**：2-4个策略足够\r\n2. **确保策略独立**：不要用相似的策略\r\n3. **控制总风险**：组合风险不能叠加\r\n4. **定期评估**：策略相关性可能变化\r\n5. **保持简单**：复杂组合难以管理\r\n6. **耐心验证**：给组合足够的时间', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51'), (24, 24, '交易员成长总结与未来规划', '回顾半年学习成果，制定长期发展规划', 'markdown', '# 交易员成长总结与未来规划\r\n\r\n## 一、半年学习回顾\r\n\r\n### 1. 知识体系总结\r\n\r\n**第一阶段：基础构建（第1-8周）**\r\n```\r\n✓ K线形态与市场认知\r\n✓ 支撑阻力与趋势线\r\n✓ 移动平均线系统\r\n✓ MACD指标应用\r\n✓ RSI与布林带\r\n✓ 成交量分析\r\n✓ 基本面与消息面\r\n✓ 链上数据入门\r\n```\r\n\r\n**第二阶段：策略整合（第9-16周）**\r\n```\r\n✓ 交易系统构建\r\n✓ 风险管理基础\r\n✓ 趋势跟随策略\r\n✓ 震荡交易策略\r\n✓ 突破交易策略\r\n✓ 多时间框架分析\r\n✓ 交易心理学\r\n✓ 模拟交易实战\r\n```\r\n\r\n**第三阶段：进阶稳定（第17-24周）**\r\n```\r\n✓ 小资金实盘\r\n✓ 交易日志分析\r\n✓ 高级技术分析\r\n✓ 市场情绪分析\r\n✓ 资金管理进阶\r\n✓ 系统优化方法\r\n✓ 多策略组合\r\n✓ 总结与规划\r\n```\r\n\r\n### 2. 能力评估清单\r\n\r\n**技术分析能力**\r\n```\r\n□ 能够识别主要K线形态\r\n□ 能够画出支撑阻力和趋势线\r\n□ 能够使用均线判断趋势\r\n□ 能够使用MACD、RSI等指标\r\n□ 能够分析成交量\r\n□ 能够识别图表形态\r\n```\r\n\r\n**交易系统能力**\r\n```\r\n□ 有明确的交易系统规则\r\n□ 能够严格执行系统\r\n□ 能够评估系统表现\r\n□ 能够优化系统\r\n```\r\n\r\n**风险管理能力**\r\n```\r\n□ 每笔交易都设止损\r\n□ 能够计算合理仓位\r\n□ 能够控制回撤\r\n□ 有资金管理规则\r\n```\r\n\r\n**心理控制能力**\r\n```\r\n□ 能够控制贪婪和恐惧\r\n□ 不会报复性交易\r\n□ 能够接受亏损\r\n□ 能够保持耐心\r\n```\r\n\r\n---\r\n\r\n## 二、交易数据分析\r\n\r\n### 1. 数据统计模板\r\n\r\n```\r\n═══════════════════════════════════════\r\n半年交易数据统计\r\n\r\n【基础数据】\r\n总交易次数：____\r\n盈利次数：____\r\n亏损次数：____\r\n胜率：____%\r\n\r\n【盈亏数据】\r\n总盈利：____U\r\n总亏损：____U\r\n净盈亏：____U\r\n盈亏比：____\r\n\r\n【风险数据】\r\n最大单笔盈利：____U\r\n最大单笔亏损：____U\r\n最大回撤：____%\r\n最长连续亏损：____次\r\n\r\n【效率数据】\r\n平均持仓时间：____\r\n月均交易次数：____\r\n资金利用率：____%\r\n═══════════════════════════════════════\r\n```\r\n\r\n### 2. 表现评估\r\n\r\n**优秀标准**：\r\n- 胜率 > 45%\r\n- 盈亏比 > 2\r\n- 最大回撤 < 20%\r\n- 期望值 > 0\r\n\r\n**需要改进的信号**：\r\n- 胜率 < 35%\r\n- 盈亏比 < 1.5\r\n- 最大回撤 > 30%\r\n- 期望值 < 0\r\n\r\n---\r\n\r\n## 三、经验教训总结\r\n\r\n### 1. 成功交易分析\r\n\r\n```\r\n最成功的3笔交易：\r\n\r\n交易1：\r\n- 品种/方向：____\r\n- 盈利：____\r\n- 成功原因：____\r\n- 可复制的经验：____\r\n\r\n交易2：\r\n- 品种/方向：____\r\n- 盈利：____\r\n- 成功原因：____\r\n- 可复制的经验：____\r\n\r\n交易3：\r\n- 品种/方向：____\r\n- 盈利：____\r\n- 成功原因：____\r\n- 可复制的经验：____\r\n```\r\n\r\n### 2. 失败交易分析\r\n\r\n```\r\n最失败的3笔交易：\r\n\r\n交易1：\r\n- 品种/方向：____\r\n- 亏损：____\r\n- 失败原因：____\r\n- 避免方法：____\r\n\r\n交易2：\r\n- 品种/方向：____\r\n- 亏损：____\r\n- 失败原因：____\r\n- 避免方法：____\r\n\r\n交易3：\r\n- 品种/方向：____\r\n- 亏损：____\r\n- 失败原因：____\r\n- 避免方法：____\r\n```\r\n\r\n### 3. 关键教训\r\n\r\n```\r\n我学到的最重要的5个教训：\r\n\r\n1. ____________________\r\n2. ____________________\r\n3. ____________________\r\n4. ____________________\r\n5. ____________________\r\n```\r\n\r\n---\r\n\r\n## 四、未来发展规划\r\n\r\n### 1. 短期目标（3个月）\r\n\r\n```\r\n交易目标：\r\n- 月均收益：____%\r\n- 最大回撤：< ___%\r\n- 交易次数：____次/月\r\n\r\n学习目标：\r\n- 深入学习：____\r\n- 改进方向：____\r\n- 新技能：____\r\n\r\n行动计划：\r\n- 每日：____\r\n- 每周：____\r\n- 每月：____\r\n```\r\n\r\n### 2. 中期目标（1年）\r\n\r\n```\r\n资金目标：\r\n- 起始资金：____U\r\n- 目标资金：____U\r\n- 年化收益：____%\r\n\r\n能力目标：\r\n- 形成稳定的交易风格\r\n- 建立完善的交易系统\r\n- 实现持续稳定盈利\r\n\r\n里程碑：\r\n- 3个月：____\r\n- 6个月：____\r\n- 9个月：____\r\n- 12个月：____\r\n```\r\n\r\n### 3. 长期愿景（3-5年）\r\n\r\n```\r\n职业规划：\r\n□ 成为全职交易员\r\n□ 管理更大资金\r\n□ 建立交易团队\r\n□ 其他：____\r\n\r\n财务目标：\r\n- 3年目标：____\r\n- 5年目标：____\r\n\r\n持续学习：\r\n- 高级技术分析\r\n- 量化交易\r\n- 其他市场\r\n```\r\n\r\n---\r\n\r\n## 五、持续成长建议\r\n\r\n### 1. 保持学习\r\n\r\n**学习资源**：\r\n- 经典交易书籍\r\n- 优秀交易员分享\r\n- 市场研究报告\r\n- 实盘复盘总结\r\n\r\n**推荐书单**：\r\n- 《股票大作手回忆录》\r\n- 《交易心理分析》\r\n- 《海龟交易法则》\r\n- 《专业投机原理》\r\n\r\n### 2. 建立交易圈子\r\n\r\n**好处**：\r\n- 交流学习\r\n- 互相监督\r\n- 信息共享\r\n- 心理支持\r\n\r\n**方式**：\r\n- 加入交易社群\r\n- 参加线下活动\r\n- 找到交易伙伴\r\n\r\n### 3. 保持健康\r\n\r\n**身体健康**：\r\n- 规律作息\r\n- 适当运动\r\n- 健康饮食\r\n\r\n**心理健康**：\r\n- 不要过度沉迷\r\n- 保持其他兴趣\r\n- 维护社交关系\r\n\r\n---\r\n\r\n## 六、写给未来的自己\r\n\r\n```\r\n致一年后的自己：\r\n\r\n回顾这半年的学习，我最大的收获是：\r\n____________________\r\n\r\n我最需要改进的是：\r\n____________________\r\n\r\n我对未来的期望是：\r\n____________________\r\n\r\n我承诺会坚持：\r\n____________________\r\n\r\n签名：____\r\n日期：____\r\n```\r\n\r\n---\r\n\r\n## 七、结语\r\n\r\n交易是一场马拉松，不是短跑。\r\n\r\n半年的学习只是开始，真正的成长在于：\r\n- 持续学习和实践\r\n- 不断复盘和改进\r\n- 保持耐心和纪律\r\n- 控制风险和情绪\r\n\r\n记住：\r\n- 保护本金是第一要务\r\n- 稳定盈利比暴利更重要\r\n- 时间是最好的朋友\r\n- 享受交易的过程\r\n\r\n祝你在交易之路上越走越远！', NULL, NULL, 1, 1, 1, '2025-12-21 00:09:51', '2025-12-21 00:09:51');
COMMIT;

-- ----------------------------
-- Table structure for learn_note
-- ----------------------------
DROP TABLE IF EXISTS `learn_note`;
CREATE TABLE `learn_note`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '笔记ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `chapter_id` bigint(20) NULL DEFAULT NULL COMMENT '关联章节ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '笔记标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '笔记内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习笔记表';

-- ----------------------------
-- Records of learn_note
-- ----------------------------
BEGIN;
INSERT INTO `learn_note` (`id`, `user_id`, `chapter_id`, `title`, `content`, `create_time`, `update_time`) VALUES (1, 2, 10, '第10周：风险管理基础 - 笔记', '学习笔记', '2025-12-26 20:49:05', '2025-12-26 20:49:05');
COMMIT;

-- ----------------------------
-- Table structure for learn_progress
-- ----------------------------
DROP TABLE IF EXISTS `learn_progress`;
CREATE TABLE `learn_progress`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `is_completed` tinyint(4) NULL DEFAULT 0 COMMENT '是否完成',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_chapter`(`user_id`, `chapter_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习进度表';

-- ----------------------------
-- Records of learn_progress
-- ----------------------------
BEGIN;
INSERT INTO `learn_progress` (`id`, `user_id`, `chapter_id`, `is_completed`, `complete_time`, `create_time`) VALUES (1, 2, 1, 1, '2025-12-26 20:22:39', '2025-12-26 20:22:39'), (2, 2, 10, 1, '2025-12-26 20:48:53', '2025-12-26 20:48:53');
COMMIT;

-- ----------------------------
-- Table structure for learn_task
-- ----------------------------
DROP TABLE IF EXISTS `learn_task`;
CREATE TABLE `learn_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `task_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务内容',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 151 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习任务表';

-- ----------------------------
-- Records of learn_task
-- ----------------------------
BEGIN;
INSERT INTO `learn_task` (`id`, `chapter_id`, `task_content`, `sort_order`) VALUES (1, 1, '完成本周学习内容阅读', 1), (2, 2, '完成本周学习内容阅读', 1), (3, 3, '完成本周学习内容阅读', 1), (4, 4, '完成本周学习内容阅读', 1), (5, 5, '完成本周学习内容阅读', 1), (6, 6, '完成本周学习内容阅读', 1), (7, 7, '完成本周学习内容阅读', 1), (8, 8, '完成本周学习内容阅读', 1), (16, 1, '完成实践任务', 2), (17, 2, '完成实践任务', 2), (18, 3, '完成实践任务', 2), (19, 4, '完成实践任务', 2), (20, 5, '完成实践任务', 2), (21, 6, '完成实践任务', 2), (22, 7, '完成实践任务', 2), (23, 8, '完成实践任务', 2), (31, 1, '记录学习笔记', 3), (32, 2, '记录学习笔记', 3), (33, 3, '记录学习笔记', 3), (34, 4, '记录学习笔记', 3), (35, 5, '记录学习笔记', 3), (36, 6, '记录学习笔记', 3), (37, 7, '记录学习笔记', 3), (38, 8, '记录学习笔记', 3), (46, 9, '完成本周学习内容阅读', 1), (47, 10, '完成本周学习内容阅读', 1), (48, 11, '完成本周学习内容阅读', 1), (49, 12, '完成本周学习内容阅读', 1), (50, 13, '完成本周学习内容阅读', 1), (51, 14, '完成本周学习内容阅读', 1), (52, 15, '完成本周学习内容阅读', 1), (53, 16, '完成本周学习内容阅读', 1), (61, 9, '完成实践任务', 2), (62, 10, '完成实践任务', 2), (63, 11, '完成实践任务', 2), (64, 12, '完成实践任务', 2), (65, 13, '完成实践任务', 2), (66, 14, '完成实践任务', 2), (67, 15, '完成实践任务', 2), (68, 16, '完成实践任务', 2), (76, 9, '记录学习笔记', 3), (77, 10, '记录学习笔记', 3), (78, 11, '记录学习笔记', 3), (79, 12, '记录学习笔记', 3), (80, 13, '记录学习笔记', 3), (81, 14, '记录学习笔记', 3), (82, 15, '记录学习笔记', 3), (83, 16, '记录学习笔记', 3), (91, 17, '完成本周学习内容阅读', 1), (92, 18, '完成本周学习内容阅读', 1), (93, 19, '完成本周学习内容阅读', 1), (94, 20, '完成本周学习内容阅读', 1), (95, 21, '完成本周学习内容阅读', 1), (96, 22, '完成本周学习内容阅读', 1), (97, 23, '完成本周学习内容阅读', 1), (98, 24, '完成本周学习内容阅读', 1), (106, 17, '完成实践任务', 2), (107, 18, '完成实践任务', 2), (108, 19, '完成实践任务', 2), (109, 20, '完成实践任务', 2), (110, 21, '完成实践任务', 2), (111, 22, '完成实践任务', 2), (112, 23, '完成实践任务', 2), (113, 24, '完成实践任务', 2), (121, 17, '记录学习笔记', 3), (122, 18, '记录学习笔记', 3), (123, 19, '记录学习笔记', 3), (124, 20, '记录学习笔记', 3), (125, 21, '记录学习笔记', 3), (126, 22, '记录学习笔记', 3), (127, 23, '记录学习笔记', 3), (128, 24, '记录学习笔记', 3), (136, 17, '完成本周交易复盘', 4), (137, 18, '完成本周交易复盘', 4), (138, 19, '完成本周交易复盘', 4), (139, 20, '完成本周交易复盘', 4), (140, 21, '完成本周交易复盘', 4), (141, 22, '完成本周交易复盘', 4), (142, 23, '完成本周交易复盘', 4), (143, 24, '完成本周交易复盘', 4);
COMMIT;

-- ----------------------------
-- Table structure for learn_task_record
-- ----------------------------
DROP TABLE IF EXISTS `learn_task_record`;
CREATE TABLE `learn_task_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `task_id` bigint(20) NOT NULL COMMENT '任务ID',
  `is_completed` tinyint(4) NULL DEFAULT 0 COMMENT '是否完成',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_task`(`user_id`, `task_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务完成记录表';

-- ----------------------------
-- Records of learn_task_record
-- ----------------------------
BEGIN;
INSERT INTO `learn_task_record` (`id`, `user_id`, `task_id`, `is_completed`, `complete_time`) VALUES (1, 2, 2, 0, '2025-12-26 20:41:01');
COMMIT;

-- ----------------------------
-- Table structure for psychology_daily
-- ----------------------------
DROP TABLE IF EXISTS `psychology_daily`;
CREATE TABLE `psychology_daily`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `record_date` date NOT NULL COMMENT '记录日期',
  `mood_score` int(11) NOT NULL COMMENT '整体情绪1-10',
  `mood_tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '情绪标签(JSON数组)',
  `sleep_quality` tinyint(4) NULL DEFAULT NULL COMMENT '睡眠质量: 1很差-5很好',
  `physical_state` tinyint(4) NULL DEFAULT NULL COMMENT '身体状态: 1疲惫 2一般 3精力充沛',
  `external_pressure` int(11) NULL DEFAULT NULL COMMENT '外部压力1-10',
  `traps` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '触发的心理陷阱(JSON数组)',
  `daily_plan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '今日计划',
  `daily_reflection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '今日反思',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id`, `record_date`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_record_date`(`record_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '每日情绪记录表';

-- ----------------------------
-- Records of psychology_daily
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for psychology_trade
-- ----------------------------
DROP TABLE IF EXISTS `psychology_trade`;
CREATE TABLE `psychology_trade`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `trade_log_id` bigint(20) NULL DEFAULT NULL COMMENT '关联交易记录ID',
  `record_date` date NOT NULL COMMENT '记录日期',
  `entry_mood` int(11) NULL DEFAULT NULL COMMENT '开仓情绪1-10',
  `holding_mood` int(11) NULL DEFAULT NULL COMMENT '持仓情绪1-10',
  `exit_mood` int(11) NULL DEFAULT NULL COMMENT '平仓情绪1-10',
  `traps` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '触发的心理陷阱(JSON数组)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '情绪描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_trade_log_id`(`trade_log_id`) USING BTREE,
  INDEX `idx_record_date`(`record_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '交易情绪记录表';

-- ----------------------------
-- Records of psychology_trade
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_code`(`role_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` (`id`, `role_name`, `role_code`, `description`, `status`, `create_time`) VALUES (1, '管理员', 'admin', '系统管理员', 1, '2025-12-14 23:45:49'), (2, '普通用户', 'user', '普通用户', 1, '2025-12-14 23:45:49');
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_role_id`(`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `avatar`, `email`, `phone`, `role_id`, `status`, `create_time`, `update_time`, `last_login_time`) VALUES (1, 'admin', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '管理员', NULL, NULL, NULL, 1, 1, '2025-12-14 23:45:50', '2025-12-26 20:18:26', '2025-12-26 20:18:26'), (2, 'subt', '$2a$10$k8Gh8KHYRGb9KmcaNAFaO.DRP4M5IZdse.qk7aJMM/xttF3SOUSH2', 'Subt', '密码:cssc2013', '328500921@qq.com', NULL, 2, 1, '2025-12-15 00:50:35', '2025-12-30 12:18:17', '2025-12-30 12:18:17'), (3, 'test', '$2a$10$k8Gh8KHYRGb9KmcaNAFaO.DRP4M5IZdse.qk7aJMM/xttF3SOUSH2', 'Subt', NULL, NULL, NULL, 2, 1, '2025-12-26 20:50:59', '2025-12-28 19:52:46', '2025-12-28 19:52:46');
COMMIT;

-- ----------------------------
-- Table structure for tool_checklist
-- ----------------------------
DROP TABLE IF EXISTS `tool_checklist`;
CREATE TABLE `tool_checklist`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '清单名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '清单项JSON',
  `is_system` tinyint(4) NULL DEFAULT 0 COMMENT '是否系统预设',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '检查清单模板表';

-- ----------------------------
-- Records of tool_checklist
-- ----------------------------
BEGIN;
INSERT INTO `tool_checklist` (`id`, `name`, `description`, `items`, `is_system`, `create_by`, `create_time`) VALUES (1, '交易前检查清单', '每次交易前必须检查的事项', '[{\"text\":\"是否符合交易计划？\",\"checked\":false},{\"text\":\"止损位是否设置？\",\"checked\":false},{\"text\":\"仓位是否合理（<5%）？\",\"checked\":false},{\"text\":\"情绪是否稳定？\",\"checked\":false},{\"text\":\"是否有重大消息面？\",\"checked\":false},{\"text\":\"技术面是否支持？\",\"checked\":false}]', 1, NULL, '2025-12-14 23:45:50');
COMMIT;

-- ----------------------------
-- Table structure for tool_daily_analysis
-- ----------------------------
DROP TABLE IF EXISTS `tool_daily_analysis`;
CREATE TABLE `tool_daily_analysis`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `analysis_date` date NOT NULL COMMENT '分析日期',
  `macro_events` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '今日重要事件',
  `fed_attitude` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '美联储态度',
  `dxy_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'DXY趋势',
  `stock_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '美股走势',
  `exchange_flow` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易所流向',
  `whale_action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '巨鲸动向',
  `fear_greed_index` int(11) NULL DEFAULT NULL COMMENT '恐惧贪婪指数',
  `funding_rate` decimal(10, 4) NULL DEFAULT NULL COMMENT '资金费率',
  `long_short_ratio` decimal(10, 4) NULL DEFAULT NULL COMMENT '多空比',
  `btc_price` decimal(20, 8) NULL DEFAULT NULL COMMENT 'BTC价格',
  `weekly_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '周线趋势',
  `daily_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日线趋势',
  `key_support` decimal(20, 8) NULL DEFAULT NULL COMMENT '关键支撑',
  `key_resistance` decimal(20, 8) NULL DEFAULT NULL COMMENT '关键阻力',
  `overall_score` int(11) NULL DEFAULT NULL COMMENT '综合评分',
  `market_view` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市场观点',
  `today_strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '今日策略',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id`, `analysis_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '每日分析记录表';

-- ----------------------------
-- Records of tool_daily_analysis
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tool_link
-- ----------------------------
DROP TABLE IF EXISTS `tool_link`;
CREATE TABLE `tool_link`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '链接名称',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '链接地址',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '常用链接表';

-- ----------------------------
-- Records of tool_link
-- ----------------------------
BEGIN;
INSERT INTO `tool_link` (`id`, `name`, `url`, `icon`, `category`, `sort_order`, `status`) VALUES (1, 'Binance', 'https://www.binance.com', NULL, '交易所', 1, 1), (2, 'TradingView', 'https://www.tradingview.com', NULL, '图表工具', 2, 1), (3, 'CoinGlass', 'https://www.coinglass.com', NULL, '数据分析', 3, 1), (4, 'Fear & Greed Index', 'https://alternative.me/crypto/fear-and-greed-index/', NULL, '市场情绪', 4, 1), (5, 'Glassnode', 'https://glassnode.com', NULL, '链上数据', 5, 1), (6, 'CoinMarketCap', 'https://coinmarketcap.com', NULL, '行情数据', 6, 1);
COMMIT;

-- ----------------------------
-- Table structure for trade_image
-- ----------------------------
DROP TABLE IF EXISTS `trade_image`;
CREATE TABLE `trade_image`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `trade_id` bigint(20) NOT NULL COMMENT '交易ID',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片URL',
  `image_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片类型',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_trade_id`(`trade_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易截图表';

-- ----------------------------
-- Records of trade_image
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for trade_log
-- ----------------------------
DROP TABLE IF EXISTS `trade_log`;
CREATE TABLE `trade_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '交易ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `trade_date` date NOT NULL COMMENT '交易日期',
  `symbol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '交易品种',
  `direction` tinyint(4) NOT NULL COMMENT '方向：1做多 2做空',
  `strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用策略',
  `entry_price` decimal(20, 8) NOT NULL COMMENT '入场价格',
  `entry_time` datetime NULL DEFAULT NULL COMMENT '入场时间',
  `entry_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '入场理由',
  `exit_price` decimal(20, 8) NULL DEFAULT NULL COMMENT '出场价格',
  `exit_time` datetime NULL DEFAULT NULL COMMENT '出场时间',
  `exit_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出场原因',
  `stop_loss` decimal(20, 8) NULL DEFAULT NULL COMMENT '止损价',
  `take_profit` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈价',
  `position_size` decimal(20, 8) NULL DEFAULT NULL COMMENT '仓位大小',
  `profit_loss` decimal(20, 8) NULL DEFAULT NULL COMMENT '盈亏金额',
  `profit_loss_percent` decimal(10, 4) NULL DEFAULT NULL COMMENT '盈亏百分比',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态：0持仓中 1已平仓',
  `macro_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '宏观分析',
  `chain_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '链上分析',
  `sentiment_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '情绪分析',
  `technical_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '技术分析',
  `review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '交易复盘',
  `emotion_score` int(11) NULL DEFAULT NULL COMMENT '情绪评分',
  `discipline_followed` tinyint(4) NULL DEFAULT NULL COMMENT '是否遵守纪律',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_trade_date`(`trade_date`) USING BTREE,
  INDEX `idx_symbol`(`symbol`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易日志表';

-- ----------------------------
-- Records of trade_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for trade_plan
-- ----------------------------
DROP TABLE IF EXISTS `trade_plan`;
CREATE TABLE `trade_plan`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `symbol` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '交易对',
  `direction` tinyint(4) NOT NULL COMMENT '方向: 1做多 2做空',
  `plan_time` datetime NULL DEFAULT NULL COMMENT '计划执行时间',
  `entry_price` decimal(20, 8) NOT NULL COMMENT '入场价格',
  `stop_loss_price` decimal(20, 8) NOT NULL COMMENT '止损价格',
  `take_profit_1` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈目标1',
  `take_profit_2` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈目标2',
  `take_profit_3` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈目标3',
  `position_ratio` decimal(5, 2) NULL DEFAULT NULL COMMENT '仓位比例%',
  `leverage` int(11) NULL DEFAULT 1 COMMENT '杠杆倍数',
  `risk_amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '风险金额',
  `entry_reasons` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '入场理由(JSON数组)',
  `technical_signals` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '技术信号(JSON数组)',
  `market_trend` tinyint(4) NULL DEFAULT NULL COMMENT '市场趋势: 1上涨 2震荡 3下跌',
  `confidence` int(11) NULL DEFAULT NULL COMMENT '信心指数1-10',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '备注',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1待执行 2已执行 3已取消 4已过期',
  `execute_time` datetime NULL DEFAULT NULL COMMENT '实际执行时间',
  `trade_log_id` bigint(20) NULL DEFAULT NULL COMMENT '关联交易记录ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_plan_time`(`plan_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '交易计划表';

-- ----------------------------
-- Records of trade_plan
-- ----------------------------
BEGIN;
INSERT INTO `trade_plan` (`id`, `user_id`, `symbol`, `direction`, `plan_time`, `entry_price`, `stop_loss_price`, `take_profit_1`, `take_profit_2`, `take_profit_3`, `position_ratio`, `leverage`, `risk_amount`, `entry_reasons`, `technical_signals`, `market_trend`, `confidence`, `remark`, `status`, `execute_time`, `trade_log_id`, `create_time`, `update_time`) VALUES (1, 3, 'ETH', 2, '2025-12-29 03:00:00', 3050.00000000, 3040.00000000, 2960.00000000, 2930.00000000, 2890.00000000, 2.00, 10, 100.00000000, '[]', NULL, 3, 5, '突破3000，这个到达3050阻力位，压力巨大。', 1, NULL, NULL, '2025-12-29 11:14:31', '2025-12-29 11:14:31');
COMMIT;

-- ----------------------------
-- Table structure for trade_summary
-- ----------------------------
DROP TABLE IF EXISTS `trade_summary`;
CREATE TABLE `trade_summary`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `summary_month` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '统计月份',
  `total_trades` int(11) NULL DEFAULT 0 COMMENT '总交易次数',
  `win_trades` int(11) NULL DEFAULT 0 COMMENT '盈利次数',
  `lose_trades` int(11) NULL DEFAULT 0 COMMENT '亏损次数',
  `win_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '胜率',
  `total_profit` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '总盈利',
  `total_loss` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '总亏损',
  `net_profit` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '净盈亏',
  `profit_factor` decimal(10, 4) NULL DEFAULT NULL COMMENT '盈亏比',
  `max_profit` decimal(20, 8) NULL DEFAULT NULL COMMENT '最大单笔盈利',
  `max_loss` decimal(20, 8) NULL DEFAULT NULL COMMENT '最大单笔亏损',
  `max_drawdown` decimal(10, 4) NULL DEFAULT NULL COMMENT '最大回撤',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_month`(`user_id`, `summary_month`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '绩效汇总表';

-- ----------------------------
-- Records of trade_summary
-- ----------------------------
BEGIN;
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
