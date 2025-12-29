-- 数字货币码表
USE trader_db;

CREATE TABLE IF NOT EXISTS crypto_currency (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL COMMENT '货币代码，如BTC',
    name VARCHAR(50) NOT NULL COMMENT '货币名称，如Bitcoin',
    name_cn VARCHAR(50) COMMENT '中文名称，如比特币',
    logo VARCHAR(255) COMMENT '图标URL',
    sort_order INT DEFAULT 0 COMMENT '排序权重，越小越靠前',
    status TINYINT DEFAULT 1 COMMENT '状态: 1启用 0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uk_code (code),
    INDEX idx_status (status),
    INDEX idx_sort (sort_order)
) COMMENT '数字货币码表';

-- 插入30个常用币种
INSERT INTO crypto_currency (code, name, name_cn, sort_order) VALUES
('BTC', 'Bitcoin', '比特币', 1),
('ETH', 'Ethereum', '以太坊', 2),
('BNB', 'BNB', '币安币', 3),
('SOL', 'Solana', '索拉纳', 4),
('XRP', 'Ripple', '瑞波币', 5),
('DOGE', 'Dogecoin', '狗狗币', 6),
('ADA', 'Cardano', '艾达币', 7),
('AVAX', 'Avalanche', '雪崩', 8),
('SHIB', 'Shiba Inu', '柴犬币', 9),
('DOT', 'Polkadot', '波卡', 10),
('LINK', 'Chainlink', '链接', 11),
('TRX', 'TRON', '波场', 12),
('MATIC', 'Polygon', '马蹄', 13),
('UNI', 'Uniswap', 'UNI', 14),
('ATOM', 'Cosmos', '阿童木', 15),
('LTC', 'Litecoin', '莱特币', 16),
('ETC', 'Ethereum Classic', '以太经典', 17),
('FIL', 'Filecoin', '文件币', 18),
('APT', 'Aptos', 'APT', 19),
('ARB', 'Arbitrum', 'ARB', 20),
('OP', 'Optimism', 'OP', 21),
('NEAR', 'NEAR Protocol', 'NEAR', 22),
('INJ', 'Injective', 'INJ', 23),
('SUI', 'Sui', 'SUI', 24),
('SEI', 'Sei', 'SEI', 25),
('PEPE', 'Pepe', '青蛙币', 26),
('WIF', 'dogwifhat', 'WIF', 27),
('ORDI', 'ORDI', 'ORDI', 28),
('STX', 'Stacks', 'STX', 29),
('IMX', 'Immutable', 'IMX', 30);
