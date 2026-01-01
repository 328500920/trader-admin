package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.LearnCheckin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

/**
 * 学习打卡记录Mapper
 */
@Mapper
public interface LearnCheckinMapper extends BaseMapper<LearnCheckin> {
    
    /**
     * 获取用户指定日期范围的打卡记录
     */
    @Select("SELECT * FROM learn_checkin WHERE user_id = #{userId} " +
            "AND checkin_date BETWEEN #{startDate} AND #{endDate} " +
            "ORDER BY checkin_date")
    List<LearnCheckin> getByDateRange(@Param("userId") Long userId, 
                                       @Param("startDate") LocalDate startDate,
                                       @Param("endDate") LocalDate endDate);
    
    /**
     * 获取用户当前连续打卡天数
     */
    @Select("SELECT COUNT(*) FROM (" +
            "  SELECT checkin_date FROM learn_checkin " +
            "  WHERE user_id = #{userId} AND study_minutes > 0 " +
            "  AND checkin_date <= #{today} " +
            "  ORDER BY checkin_date DESC " +
            ") t WHERE checkin_date >= DATE_SUB(#{today}, INTERVAL (SELECT COUNT(*) FROM learn_checkin " +
            "  WHERE user_id = #{userId} AND study_minutes > 0 AND checkin_date <= #{today}) DAY)")
    Integer getCurrentStreak(@Param("userId") Long userId, @Param("today") LocalDate today);
    
    /**
     * 获取用户总打卡天数
     */
    @Select("SELECT COUNT(*) FROM learn_checkin WHERE user_id = #{userId} AND study_minutes > 0")
    Integer getTotalCheckinDays(@Param("userId") Long userId);
    
    /**
     * 获取用户总学习时长
     */
    @Select("SELECT COALESCE(SUM(study_minutes), 0) FROM learn_checkin WHERE user_id = #{userId}")
    Integer getTotalStudyMinutes(@Param("userId") Long userId);
}
