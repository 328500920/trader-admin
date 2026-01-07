# 交易X光 - 建设方案

## 一、功能概述

"交易X光"是一个基于 AI 大模型的交易数据智能分析功能，通过对用户的成交记录和仓位历史进行深度分析，帮助用户发现交易中的问题、识别行为模式、提供改进建议。

### 1.1 核心价值
- 🔍 **透视交易行为**：像X光一样透视用户的交易习惯和模式
- 📊 **量化分析**：将主观的交易表现转化为客观的数据指标
- 💡 **智能建议**：基于 AI 分析给出个性化的改进建议
- 📈 **持续跟踪**：保存历史分析报告，追踪进步轨迹

### 1.2 目标用户
所有使用交易日志功能的学员

---

## 二、功能设计

### 2.1 入口位置
- 菜单路径：交易日志 → 交易X光
- 路由：`/trade/xray`

### 2.2 页面布局

```
┌─────────────────────────────────────────────────────────────────┐
│  🔬 交易X光 - AI智能分析                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────── 数据选择区 ───────────────┐                    │
│  │                                           │                    │
│  │  📅 分析周期:  [最近7天 ▼]                 │                    │
│  │              或 自定义: [开始] ~ [结束]    │                    │
│  │                                           │                    │
│  │  📊 数据范围:  ☑ 成交记录  ☑ 仓位历史      │                    │
│  │                                           │                    │
│  │  🪙 交易对:    [全部 ▼]                    │                    │
│  │                                           │                    │
│  │  📋 数据预览:  128 条成交, 45 个仓位       │                    │
│  │                                           │                    │
│  │              [🚀 开始AI分析]               │                    │
│  └───────────────────────────────────────────┘                    │
│                                                                 │
│  ┌─────────────── 分析结果区 ───────────────┐                    │
│  │                                           │                    │
│  │  ┌─────────── 综合评分 ───────────┐       │                    │
│  │  │     🎯 72/100                  │       │                    │
│  │  │     ████████████░░░░ 良好      │       │                    │
│  │  └────────────────────────────────┘       │                    │
│  │                                           │                    │
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐     │                    │
│  │  │胜率 │ │盈亏比│ │风控 │ │纪律 │ │心态 │     │                    │
│  │  │ 65%│ │ 1.8│ │ B+ │ │ A- │ │ B  │     │                    │
│  │  │ 🟢 │ │ 🟢 │ │ 🟡 │ │ 🟢 │ │ 🟡 │     │                    │
│  │  └────┘ └────┘ └────┘ └────┘ └────┘     │                    │
│  │                                           │                    │
│  │  ┌─────────── AI诊断报告 ─────────┐       │                    │
│  │  │                                │       │                    │
│  │  │ ✅ 优势发现                     │       │                    │
│  │  │ • 趋势判断准确率较高            │       │                    │
│  │  │ • 止损执行坚决，风控意识强      │       │                    │
│  │  │                                │       │                    │
│  │  │ ⚠️ 问题诊断                     │       │                    │
│  │  │ • 交易频率过高，手续费侵蚀利润  │       │                    │
│  │  │ • 盈利单平仓过早，亏损单死扛    │       │                    │
│  │  │ • 夜间交易胜率明显低于日间      │       │                    │
│  │  │                                │       │                    │
│  │  │ 💡 改进建议                     │       │                    │
│  │  │ 1. 减少交易频率，专注高胜率机会 │       │                    │
│  │  │ 2. 设置移动止盈，让利润奔跑     │       │                    │
│  │  │ 3. 避免在22:00后开新仓         │       │                    │
│  │  │                                │       │                    │
│  │  └────────────────────────────────┘       │                    │
│  │                                           │                    │
│  │  ┌─────────── 数据图表 ───────────┐       │                    │
│  │  │ [盈亏分布] [时段分析] [币种表现]│       │                    │
│  │  │                                │       │                    │
│  │  │      (ECharts 图表区域)        │       │                    │
│  │  │                                │       │                    │
│  │  └────────────────────────────────┘       │                    │
│  │                                           │                    │
│  └───────────────────────────────────────────┘                    │
│                                                                 │
│  ┌─────────────── 历史报告 ───────────────┐                      │
│  │  📄 2025-01-05 分析报告  评分:72  [查看] │                      │
│  │  📄 2024-12-28 分析报告  评分:68  [查看] │                      │
│  │  📄 2024-12-21 分析报告  评分:65  [查看] │                      │
│  └───────────────────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 交互流程

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ 选择条件  │ → │ 预览数据  │ → │ 开始分析  │ → │ 展示结果  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │              │               │               │
     ▼              ▼               ▼               ▼
  时间范围      显示数据量      调用DeepSeek    渲染报告
  数据类型      确认无误        流式输出        保存历史
  交易对筛选                    打字机效果
```

### 2.4 分析维度

| 维度 | 指标 | 说明 |
|------|------|------|
| **胜率分析** | 胜率、连胜/连亏 | 盈利交易占比，最大连胜/连亏次数 |
| **盈亏比** | 平均盈亏比、期望值 | 平均盈利/平均亏损，单笔期望收益 |
| **风控评估** | 最大回撤、止损率 | 最大亏损幅度，止损执行情况 |
| **交易纪律** | 计划执行率 | 是否按计划交易，有无冲动交易 |
| **时间分析** | 最佳时段、持仓时长 | 不同时段胜率，平均持仓时间 |
| **币种分析** | 各币种表现 | 最擅长/最差的交易对 |
| **行为模式** | 交易频率、情绪识别 | 是否过度交易，情绪化交易识别 |

---

## 三、技术方案

### 3.1 技术架构

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   前端Vue   │ ←→  │  后端Java   │ ←→  │  DeepSeek   │
│             │     │             │     │    API      │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                    │
      ▼                   ▼                    ▼
  页面交互            数据聚合             AI分析
  图表展示            Prompt构建          流式响应
  历史记录            结果解析
```

### 3.2 多模型支持架构

**支持的大模型：**

| 模型 | 提供商 | API地址 | 特点 |
|------|--------|---------|------|
| DeepSeek | 深度求索 | api.deepseek.com | 性价比高，中文能力强 |
| 通义千问 | 阿里云 | dashscope.aliyuncs.com | 稳定可靠，国内访问快 |

**架构设计：**

```
┌─────────────────────────────────────────────────────────────┐
│                      AiModelService                          │
│                     (统一调用入口)                            │
├─────────────────────────────────────────────────────────────┤
│                           │                                  │
│              ┌────────────┴────────────┐                    │
│              ▼                         ▼                    │
│    ┌─────────────────┐      ┌─────────────────┐            │
│    │ DeepSeekClient  │      │  QwenClient     │            │
│    │ (DeepSeek实现)   │      │ (通义千问实现)   │            │
│    └─────────────────┘      └─────────────────┘            │
│              │                         │                    │
│              ▼                         ▼                    │
│    ┌─────────────────┐      ┌─────────────────┐            │
│    │ DeepSeek API    │      │ 通义千问 API     │            │
│    └─────────────────┘      └─────────────────┘            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │ sys_ai_model    │
                    │ (模型配置表)     │
                    └─────────────────┘
```

### 3.3 数据库设计

**AI模型配置表：sys_ai_model**

```sql
CREATE TABLE sys_ai_model (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '模型名称(显示用)',
    provider VARCHAR(30) NOT NULL COMMENT '提供商: deepseek/qwen',
    model VARCHAR(50) NOT NULL COMMENT '模型标识: deepseek-chat/qwen-turbo',
    api_url VARCHAR(200) NOT NULL COMMENT 'API地址',
    api_key VARCHAR(200) NOT NULL COMMENT 'API密钥(加密存储)',
    max_tokens INT DEFAULT 4096 COMMENT '最大token数',
    temperature DECIMAL(2,1) DEFAULT 0.7 COMMENT '温度参数',
    is_active TINYINT DEFAULT 0 COMMENT '是否启用: 0否 1是(只能有一个启用)',
    sort_order INT DEFAULT 0 COMMENT '排序',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_provider (provider),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI模型配置表';

-- 初始化数据
INSERT INTO sys_ai_model (name, provider, model, api_url, api_key, is_active, sort_order) VALUES
('DeepSeek', 'deepseek', 'deepseek-chat', 'https://api.deepseek.com/v1/chat/completions', '', 1, 1),
('通义千问', 'qwen', 'qwen-turbo', 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions', '', 0, 2);
```

**分析报告表：trade_xray_report**

```sql
CREATE TABLE trade_xray_report (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    model_id BIGINT COMMENT '使用的模型ID',
    model_name VARCHAR(50) COMMENT '使用的模型名称',
    start_date DATE NOT NULL COMMENT '分析开始日期',
    end_date DATE NOT NULL COMMENT '分析结束日期',
    trade_count INT DEFAULT 0 COMMENT '成交记录数',
    position_count INT DEFAULT 0 COMMENT '仓位数',
    
    -- 评分数据
    total_score INT COMMENT '综合评分(0-100)',
    win_rate DECIMAL(5,2) COMMENT '胜率',
    profit_loss_ratio DECIMAL(5,2) COMMENT '盈亏比',
    risk_score VARCHAR(10) COMMENT '风控评分',
    discipline_score VARCHAR(10) COMMENT '纪律评分',
    
    -- AI分析结果
    strengths TEXT COMMENT '优势(JSON数组)',
    problems TEXT COMMENT '问题(JSON数组)',
    suggestions TEXT COMMENT '建议(JSON数组)',
    full_report TEXT COMMENT '完整AI报告',
    
    -- 统计数据
    statistics JSON COMMENT '详细统计数据',
    
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='交易X光分析报告';
```

**AI使用次数表：ai_usage_quota**

```sql
CREATE TABLE ai_usage_quota (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    usage_date DATE NOT NULL COMMENT '使用日期',
    used_count INT DEFAULT 0 COMMENT '已使用次数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_date (user_id, usage_date),
    INDEX idx_usage_date (usage_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI使用次数配额';
```

**使用次数限制规则：**

| 角色 | 每日限制 | 说明 |
|------|---------|------|
| admin | 无限制 | 管理员不限制 |
| teacher | 10次 | 教师每天10次 |
| student | 3次 | 学员每天3次 |

### 3.4 API 接口设计

| 接口 | 方法 | 说明 |
|------|------|------|
| `/trade/xray/preview` | GET | 预览待分析数据量 |
| `/trade/xray/analyze` | POST | 开始AI分析（SSE流式） |
| `/trade/xray/reports` | GET | 获取历史报告列表 |
| `/trade/xray/report/{id}` | GET | 获取报告详情 |
| `/trade/xray/quota` | GET | 获取今日剩余次数 |
| `/ai/model/list` | GET | 获取模型列表（管理员） |
| `/ai/model/active` | GET | 获取当前启用的模型 |
| `/ai/model` | POST | 新增模型配置（管理员） |
| `/ai/model/{id}` | PUT | 更新模型配置（管理员） |
| `/ai/model/{id}/activate` | PUT | 启用指定模型（管理员） |

### 3.5 Prompt 设计

```
你是一位专业的加密货币交易分析师，请根据以下交易数据进行深度分析：

## 交易数据概览
- 分析周期：{startDate} 至 {endDate}
- 成交记录：{tradeCount} 笔
- 仓位数量：{positionCount} 个

## 成交记录明细
{tradeRecords}

## 仓位历史明细
{positionHistory}

请从以下维度进行分析，并给出评分和建议：

1. **胜率分析**：计算胜率，分析连胜/连亏情况
2. **盈亏比分析**：计算平均盈亏比，评估风险收益
3. **风控评估**：分析止损执行情况，最大回撤
4. **交易纪律**：是否存在冲动交易、过度交易
5. **时间分析**：不同时段的交易表现
6. **行为模式**：识别交易习惯和潜在问题

请按以下JSON格式输出分析结果：
{
  "totalScore": 75,
  "metrics": {
    "winRate": "65%",
    "profitLossRatio": "1.8",
    "riskScore": "B+",
    "disciplineScore": "A-"
  },
  "strengths": ["优势1", "优势2"],
  "problems": ["问题1", "问题2"],
  "suggestions": ["建议1", "建议2", "建议3"],
  "summary": "总结性评价..."
}
```

---

## 四、文件清单

### 4.1 后端文件

| 文件路径 | 说明 |
|---------|------|
| `entity/SysAiModel.java` | AI模型配置实体 |
| `entity/TradeXrayReport.java` | 分析报告实体 |
| `entity/AiUsageQuota.java` | AI使用配额实体 |
| `mapper/SysAiModelMapper.java` | 模型配置Mapper |
| `mapper/TradeXrayReportMapper.java` | 报告Mapper |
| `mapper/AiUsageQuotaMapper.java` | 配额Mapper |
| `service/AiModelService.java` | AI模型统一调用服务 |
| `service/impl/DeepSeekClient.java` | DeepSeek实现 |
| `service/impl/QwenClient.java` | 通义千问实现 |
| `service/TradeXrayService.java` | X光业务逻辑 |
| `service/AiQuotaService.java` | 配额管理服务 |
| `controller/TradeXrayController.java` | X光控制器 |
| `controller/AiModelController.java` | 模型管理控制器 |

### 4.2 前端文件

| 文件路径 | 说明 |
|---------|------|
| `views/trade/xray/index.vue` | 交易X光主页面 |
| `views/system/ai-model/index.vue` | AI模型管理页面（管理员） |
| `api/xray.js` | X光API接口 |
| `api/ai.js` | AI模型API接口 |
| `router/index.js` | 添加路由 |

### 4.3 SQL文件

| 文件路径 | 说明 |
|---------|------|
| `sql/create_trade_xray.sql` | 创建所有相关表 |

---

## 五、模型管理界面

管理员可在"系统管理"下管理AI模型配置：

```
┌─────────────────────────────────────────────────────────────────┐
│  🤖 AI模型管理                                    [+ 新增模型]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 模型名称    │ 提供商    │ 模型标识      │ 状态   │ 操作   │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ DeepSeek   │ deepseek │ deepseek-chat │ ✅启用 │ 编辑   │   │
│  │ 通义千问    │ qwen     │ qwen-turbo    │ ⚪禁用 │ 编辑 启用│   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  💡 提示：同一时间只能启用一个模型                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 六、开发计划

| 阶段 | 任务 | 预计工作量 |
|------|------|-----------|
| 1 | 数据库表创建（3张表） | 5分钟 |
| 2 | 后端实体和Mapper | 15分钟 |
| 3 | AI模型服务（多模型支持） | 25分钟 |
| 4 | 配额管理服务 | 10分钟 |
| 5 | X光业务Service | 20分钟 |
| 6 | Controller接口 | 15分钟 |
| 7 | 前端X光页面 | 30分钟 |
| 8 | 前端模型管理页面 | 20分钟 |
| 9 | 路由配置 | 5分钟 |
| 10 | 联调测试 | 15分钟 |

---

## 七、配置说明

API Key 通过数据库 `sys_ai_model` 表管理，管理员可在"系统管理 → AI模型管理"页面配置。

**获取 API Key：**
- DeepSeek：https://platform.deepseek.com/
- 通义千问：https://dashscope.console.aliyun.com/

---

## 八、后续扩展

1. **对比分析**：支持不同时间段的对比
2. **目标设定**：设定改进目标，追踪进度
3. **周报/月报**：定期自动生成分析报告
4. **分享功能**：生成报告图片分享
