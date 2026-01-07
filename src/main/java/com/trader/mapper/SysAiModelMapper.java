package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.SysAiModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface SysAiModelMapper extends BaseMapper<SysAiModel> {
    
    @Select("SELECT * FROM sys_ai_model WHERE is_active = 1 LIMIT 1")
    SysAiModel findActiveModel();
    
    @Update("UPDATE sys_ai_model SET is_active = 0 WHERE is_active = 1")
    int deactivateAll();
}
