# K线形态图组件设计文档

## 一、项目背景

交易员成长计划的课程教学需要大量K线形态图来辅助教学。目前课程内容主要是文字描述，缺少直观的图表展示。本方案通过前端ECharts组件动态生成K线形态图，提升教学效果。

## 二、技术选型

| 项目 | 选择 | 理由 |
|-----|------|------|
| 图表库 | ECharts | 功能完善，K线图支持好，社区成熟 |
| 集成方式 | Markdown扩展 + 独立页面 | 灵活使用，系统化学习 |
| 数据存储 | JSON配置 | 轻量，易于维护 |

## 三、功能范围

### 3.1 支持的K线形态（第1-6周课程）

#### 第1周：K线基础形态

**单根K线形态：**
| ID | 名称 | 类型 | 说明 |
|----|------|------|------|
| `bullish_candle` | 大阳线 | 看涨 | 强势上涨信号 |
| `bearish_candle` | 大阴线 | 看跌 | 强势下跌信号 |
| `hammer` | 锤子线 | 看涨 | 底部反转信号，长下影线 |
| `inverted_hammer` | 倒锤子 | 看涨 | 底部反转信号，长上影线 |
| `hanging_man` | 上吊线 | 看跌 | 顶部反转信号 |
| `shooting_star` | 射击之星 | 看跌 | 顶部反转信号 |
| `doji` | 十字星 | 中性 | 犹豫/转折信号 |
| `dragonfly_doji` | 蜻蜓十字 | 看涨 | 底部信号 |
| `gravestone_doji` | 墓碑十字 | 看跌 | 顶部信号 |

**双根K线组合：**
| ID | 名称 | 类型 | 说明 |
|----|------|------|------|
| `bullish_engulfing` | 看涨吞没 | 看涨 | 底部反转 |
| `bearish_engulfing` | 看跌吞没 | 看跌 | 顶部反转 |
| `dark_cloud_cover` | 乌云盖顶 | 看跌 | 顶部反转 |
| `piercing_pattern` | 刺透形态 | 看涨 | 底部反转 |

**三根K线组合：**
| ID | 名称 | 类型 | 说明 |
|----|------|------|------|
| `morning_star` | 早晨之星 | 看涨 | 底部反转 |
| `evening_star` | 黄昏之星 | 看跌 | 顶部反转 |
| `three_black_crows` | 三只乌鸦 | 看跌 | 下跌延续 |
| `three_white_soldiers` | 三白兵 | 看涨 | 上涨延续 |

#### 第2周：支撑阻力形态
| ID | 名称 | 说明 |
|----|------|------|
| `support_bounce` | 支撑位反弹 | 价格在支撑位获得支撑 |
| `resistance_rejection` | 阻力位受阻 | 价格在阻力位受阻 |
| `support_break` | 支撑突破 | 支撑位被跌破 |
| `resistance_break` | 阻力突破 | 阻力位被突破 |
| `support_to_resistance` | 支撑变阻力 | 角色转换 |

#### 第3周：均线系统形态
| ID | 名称 | 说明 |
|----|------|------|
| `ma_golden_cross` | 均线金叉 | 短期均线上穿长期均线 |
| `ma_death_cross` | 均线死叉 | 短期均线下穿长期均线 |
| `ma_bullish_alignment` | 均线多头排列 | 上涨趋势 |
| `ma_bearish_alignment` | 均线空头排列 | 下跌趋势 |
| `ma_support` | 均线支撑 | 价格回踩均线获支撑 |

#### 第4周：MACD指标形态
| ID | 名称 | 说明 |
|----|------|------|
| `macd_golden_cross` | MACD金叉 | 买入信号 |
| `macd_death_cross` | MACD死叉 | 卖出信号 |
| `macd_top_divergence` | MACD顶背离 | 见顶信号 |
| `macd_bottom_divergence` | MACD底背离 | 见底信号 |
| `macd_above_zero_cross` | 零轴上方金叉 | 强势买入 |

#### 第5周：RSI与布林带形态
| ID | 名称 | 说明 |
|----|------|------|
| `rsi_overbought` | RSI超买 | 可能回调 |
| `rsi_oversold` | RSI超卖 | 可能反弹 |
| `rsi_divergence` | RSI背离 | 趋势反转信号 |
| `bollinger_squeeze` | 布林带收口 | 即将突破 |
| `bollinger_breakout` | 布林带突破 | 趋势启动 |

#### 第6周：成交量形态
| ID | 名称 | 说明 |
|----|------|------|
| `volume_breakout` | 放量突破 | 有效突破 |
| `volume_pullback` | 缩量回调 | 健康回调 |
| `volume_climax_top` | 天量见顶 | 顶部信号 |
| `volume_climax_bottom` | 地量见底 | 底部信号 |

### 3.2 标注功能

支持以下标注类型：
- **入场点** (entry)：绿色向上箭头
- **止损位** (stopLoss)：红色水平线
- **目标位** (target)：蓝色水平线
- **支撑线** (support)：绿色虚线
- **阻力线** (resistance)：红色虚线
- **均线** (ma)：不同颜色的曲线
- **文字标注** (text)：自定义文字

## 四、数据结构设计

### 4.1 K线形态配置JSON

```json
{
  "id": "hammer",
  "name": "锤子线",
  "category": "single",
  "type": "bullish",
  "description": "长下影线，小实体，出现在下跌末端，预示反转",
  "data": [
    { "date": "Day1", "open": 100, "close": 95, "low": 92, "high": 101 },
    { "date": "Day2", "open": 94, "close": 90, "low": 85, "high": 95 },
    { "date": "Day3", "open": 89, "close": 88, "low": 80, "high": 90 },
    { "date": "Day4", "open": 87, "close": 92, "low": 75, "high": 93, "highlight": true },
    { "date": "Day5", "open": 93, "close": 98, "low": 92, "high": 100 }
  ],
  "annotations": [
    { "type": "entry", "index": 4, "price": 93, "label": "入场点" },
    { "type": "stopLoss", "price": 74, "label": "止损" },
    { "type": "target", "price": 105, "label": "目标" },
    { "type": "text", "index": 3, "price": 77, "label": "锤子线" }
  ],
  "highlights": [3],
  "tips": [
    "下影线长度至少是实体的2倍",
    "出现在下跌趋势末端更有效",
    "需要后续阳线确认"
  ]
}
```

### 4.2 带指标的图表配置

```json
{
  "id": "macd_golden_cross",
  "name": "MACD金叉",
  "data": [...],
  "indicators": {
    "macd": {
      "show": true,
      "fast": 12,
      "slow": 26,
      "signal": 9
    }
  },
  "annotations": [
    { "type": "indicator_cross", "index": 8, "label": "金叉" }
  ]
}
```

## 五、组件设计

### 5.1 目录结构

```
trader-web/src/
├── components/
│   └── CandlestickChart/
│       ├── index.vue           # 主组件
│       ├── patterns.js         # 预设形态数据
│       ├── indicators.js       # 指标计算
│       └── annotations.js      # 标注渲染
├── views/
│   └── learn/
│       └── patterns/
│           └── index.vue       # K线形态图鉴页面
```

### 5.2 组件API

```vue
<CandlestickChart
  :pattern="'hammer'"           // 预设形态ID
  :data="customData"            // 自定义数据（可选）
  :annotations="annotations"    // 标注配置（可选）
  :indicators="indicators"      // 指标配置（可选）
  :height="400"                 // 图表高度
  :showVolume="true"            // 是否显示成交量
  :showTooltip="true"           // 是否显示提示
  :theme="'light'"              // 主题
/>
```

### 5.3 Markdown扩展语法

在Markdown内容中使用以下语法嵌入K线图：

```markdown
## 锤子线形态

下面是锤子线的典型形态：

:::candlestick hammer
:::

也可以自定义配置：

:::candlestick
{
  "pattern": "hammer",
  "showAnnotations": true,
  "height": 350
}
:::
```

## 六、页面设计

### 6.1 K线形态图鉴页面

路由：`/learn/patterns`

功能：
1. 分类展示所有K线形态
2. 支持按类型筛选（看涨/看跌/中性）
3. 支持按周数筛选（第1-6周）
4. 点击形态查看详情和交易要点
5. 支持搜索形态名称

布局：
```
┌─────────────────────────────────────────────┐
│  K线形态图鉴                    [搜索框]     │
├─────────────────────────────────────────────┤
│  [全部] [看涨] [看跌] [中性]                 │
│  [第1周] [第2周] [第3周] [第4周] [第5周] [第6周] │
├─────────────────────────────────────────────┤
│  ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │ 锤子线  │ │ 倒锤子  │ │ 十字星  │       │
│  │ [图表]  │ │ [图表]  │ │ [图表]  │       │
│  │ 看涨    │ │ 看涨    │ │ 中性    │       │
│  └─────────┘ └─────────┘ └─────────┘       │
│  ...                                        │
└─────────────────────────────────────────────┘
```

### 6.2 形态详情弹窗

点击形态卡片后显示详情：
- 大图展示K线形态
- 形态说明
- 识别要点
- 交易建议
- 相关案例链接

## 七、实施计划

### 阶段1：基础组件开发（核心）
1. 安装ECharts依赖
2. 创建CandlestickChart基础组件
3. 实现K线图渲染
4. 实现标注功能

### 阶段2：形态数据库
1. 创建patterns.js预设形态数据
2. 实现第1周单根K线形态（9个）
3. 实现第1周组合K线形态（8个）

### 阶段3：K线形态图鉴页面
1. 创建patterns页面
2. 实现分类筛选
3. 实现形态详情弹窗

### 阶段4：Markdown集成
1. 扩展Markdown解析器
2. 支持:::candlestick语法
3. 在案例详情页集成

### 阶段5：扩展形态
1. 实现第2-6周的形态
2. 添加指标图表支持（均线、MACD、RSI、布林带）
3. 添加成交量图表

### 阶段6：数据更新
1. 更新案例SQL，添加K线图表语法
2. 测试和优化

## 八、技术要点

### 8.1 ECharts K线图配置

```javascript
const option = {
  xAxis: {
    type: 'category',
    data: dates
  },
  yAxis: {
    type: 'value',
    scale: true
  },
  series: [{
    type: 'candlestick',
    data: klineData, // [[open, close, low, high], ...]
    itemStyle: {
      color: '#ef5350',      // 阳线颜色
      color0: '#26a69a',     // 阴线颜色
      borderColor: '#ef5350',
      borderColor0: '#26a69a'
    }
  }],
  // 标注线
  markLine: {
    data: [
      { yAxis: stopLoss, name: '止损' },
      { yAxis: target, name: '目标' }
    ]
  },
  // 标注点
  markPoint: {
    data: [
      { coord: [entryIndex, entryPrice], name: '入场' }
    ]
  }
}
```

### 8.2 暗色主题适配

组件需要支持暗色主题，根据`themeStore.isDark`切换配色。

### 8.3 响应式设计

图表需要响应容器宽度变化，使用`ResizeObserver`监听。

## 九、验收标准

1. CandlestickChart组件可正常渲染K线图
2. 支持所有预设形态（约35个）
3. 标注功能正常显示
4. K线形态图鉴页面可正常访问和筛选
5. Markdown中的:::candlestick语法可正常解析和渲染
6. 暗色主题适配正常
7. 移动端响应式正常

## 十、后续扩展

1. 支持实时K线数据接入
2. 支持用户自定义绘制标注
3. 支持形态识别练习功能
4. 支持导出图表为图片
