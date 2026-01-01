package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.LearnWrongQuestion;
import org.apache.ibatis.annotations.Mapper;

/**
 * 错题记录Mapper
 */
@Mapper
public interface LearnWrongQuestionMapper extends BaseMapper<LearnWrongQuestion> {
}
