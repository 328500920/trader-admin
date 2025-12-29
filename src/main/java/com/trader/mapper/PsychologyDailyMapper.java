package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.PsychologyDaily;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface PsychologyDailyMapper extends BaseMapper<PsychologyDaily> {
    
    @Select("SELECT record_date as recordDate, mood_score as moodScore, traps " +
            "FROM psychology_daily " +
            "WHERE user_id = #{userId} " +
            "AND record_date BETWEEN #{startDate} AND #{endDate} " +
            "ORDER BY record_date")
    List<Map<String, Object>> getCalendarData(@Param("userId") Long userId,
                                               @Param("startDate") LocalDate startDate,
                                               @Param("endDate") LocalDate endDate);
    
    @Select("SELECT AVG(mood_score) as avgMood, COUNT(*) as totalDays " +
            "FROM psychology_daily " +
            "WHERE user_id = #{userId} " +
            "AND record_date BETWEEN #{startDate} AND #{endDate}")
    Map<String, Object> getMoodStats(@Param("userId") Long userId,
                                      @Param("startDate") LocalDate startDate,
                                      @Param("endDate") LocalDate endDate);
}
