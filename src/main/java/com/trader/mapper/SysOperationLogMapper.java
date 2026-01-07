package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.SysOperationLog;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SysOperationLogMapper extends BaseMapper<SysOperationLog> {
    
    /**
     * 清理半年前的日志
     */
    @Delete("DELETE FROM sys_operation_log WHERE created_at < DATE_SUB(NOW(), INTERVAL 6 MONTH)")
    int cleanOldLogs();
}
