package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.LearnVideoProgress;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface LearnVideoProgressMapper extends BaseMapper<LearnVideoProgress> {
    
    @Select("SELECT * FROM learn_video_progress WHERE user_id = #{userId} AND video_id = #{videoId}")
    LearnVideoProgress findByUserAndVideo(Long userId, Long videoId);
}
