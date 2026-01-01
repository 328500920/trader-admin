package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户测验记录实体类
 */
@Data
@TableName("learn_quiz_record")
public class LearnQuizRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /** 用户ID */
    private Long userId;
    
    /** 章节ID */
    private Long chapterId;
    
    /** 总题数 */
    private Integer totalQuestions;
    
    /** 正确数 */
    private Integer correctCount;
    
    /** 得分 */
    private Integer score;
    
    /** 用时(秒) */
    private Integer timeSpent;
    
    /** 答题详情JSON */
    private String answers;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    /** 关联的章节信息（非数据库字段） */
    @TableField(exist = false)
    private LearnChapter chapter;
}
