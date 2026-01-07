package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.AiUsageQuota;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;

@Mapper
public interface AiUsageQuotaMapper extends BaseMapper<AiUsageQuota> {
    
    @Select("SELECT * FROM ai_usage_quota WHERE user_id = #{userId} AND usage_date = #{date}")
    AiUsageQuota findByUserAndDate(Long userId, LocalDate date);
}
