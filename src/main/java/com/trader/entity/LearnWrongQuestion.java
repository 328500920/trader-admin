package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 错题记录实体
 */
@Data
@TableName("learn_wrong_question")
public class LearnWrongQuestion {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 题目ID
     */
    private Long quizId;
    
    /**
     * 错误次数
     */
    private Integer wrongCount;
    
    /**
     * 最近错误时间
     */
    private LocalDateTime lastWrongTime;
    
    /**
     * 是否已掌握
     */
    private Integer isMastered;
    
    /**
     * 掌握时间
     */
    private LocalDateTime masteredTime;
    
    /**
     * 用户答案
     */
    private String userAnswer;
    
    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    /**
     * 关联的题目信息（非数据库字段）
     */
    @TableField(exist = false)
    private LearnQuiz quiz;
}
