package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 实战案例实体类
 */
@Data
@TableName("learn_case")
public class LearnCase {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /** 章节ID */
    private Long chapterId;
    
    /** 案例标题 */
    private String title;
    
    /** 案例类型：success成功/failure失败/analysis分析 */
    private String caseType;
    
    /** 交易品种：BTC/ETH等 */
    private String symbol;
    
    /** 时间周期：1H/4H/1D等 */
    private String timeframe;
    
    /** 入场日期 */
    private LocalDate entryDate;
    
    /** 案例背景 */
    private String background;
    
    /** 分析过程 */
    private String analysis;
    
    /** 入场设置 */
    private String entrySetup;
    
    /** 实际结果 */
    private String result;
    
    /** 经验总结 */
    private String lessons;
    
    /** 完整案例内容(Markdown) */
    private String content;
    
    /** 图片链接JSON数组 */
    private String imageUrls;
    
    /** 排序 */
    private Integer sortOrder;
    
    /** 状态：0禁用 1启用 */
    private Integer status;
    
    /** 创建人 */
    private Long createBy;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    /** 关联的章节信息（非数据库字段） */
    @TableField(exist = false)
    private LearnChapter chapter;
}
