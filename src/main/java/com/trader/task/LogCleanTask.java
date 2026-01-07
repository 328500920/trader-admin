package com.trader.task;

import com.trader.mapper.SysOperationLogMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 日志清理定时任务
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LogCleanTask {
    
    private final SysOperationLogMapper logMapper;
    
    /**
     * 每天凌晨3点清理半年前的日志
     */
    @Scheduled(cron = "0 0 3 * * ?")
    public void cleanOldLogs() {
        try {
            int count = logMapper.cleanOldLogs();
            if (count > 0) {
                log.info("清理操作日志完成，删除{}条记录", count);
            }
        } catch (Exception e) {
            log.error("清理操作日志失败", e);
        }
    }
}
