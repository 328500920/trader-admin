package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.LearnQuiz;
import org.apache.ibatis.annotations.Mapper;

/**
 * 测验题目Mapper接口
 */
@Mapper
public interface LearnQuizMapper extends BaseMapper<LearnQuiz> {
}
