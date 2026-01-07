package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.LearnVideoCourse;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface LearnVideoCourseMapper extends BaseMapper<LearnVideoCourse> {
    
    @Update("UPDATE learn_video_course SET view_count = view_count + 1 WHERE id = #{id}")
    int incrementViewCount(Long id);
}
