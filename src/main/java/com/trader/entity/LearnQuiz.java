package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 测验题目实体类
 */
@Data
@TableName("learn_quiz")
public class LearnQuiz {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /** 章节ID */
    private Long chapterId;
    
    /** 题目内容 */
    private String question;
    
    /** 题型：single单选/multiple多选/judge判断/calculate计算/short简答 */
    private String questionType;
    
    /** 选项JSON：[{"key":"A","value":"选项内容"}] */
    private String options;
    
    /** 正确答案：A/AB/true/false/具体答案 */
    private String answer;
    
    /** 答案解析 */
    private String explanation;
    
    /** 难度：1基础 2进阶 3挑战 */
    private Integer difficulty;
    
    /** 分值 */
    private Integer points;
    
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
