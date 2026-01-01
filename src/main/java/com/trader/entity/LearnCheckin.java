package com.trader.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 学习打卡记录实体
 */
@Data
@TableName("learn_checkin")
public class LearnCheckin {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 打卡日期
     */
    private LocalDate checkinDate;
    
    /**
     * 学习时长(分钟)
     */
    private Integer studyMinutes;
    
    /**
     * 完成章节数
     */
    private Integer chaptersCompleted;
    
    /**
     * 完成测验数
     */
    private Integer quizzesCompleted;
    
    /**
     * 查看案例数
     */
    private Integer casesViewed;
    
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
}
