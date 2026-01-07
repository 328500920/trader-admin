package com.trader.service;

import com.trader.common.BusinessException;
import com.trader.entity.AiUsageQuota;
import com.trader.mapper.AiUsageQuotaMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AiQuotaService {
    
    private final AiUsageQuotaMapper quotaMapper;
    
    // 从配置文件读取每日限制，-1表示无限制
    @Value("${ai.quota.admin:-1}")
    private int adminLimit;
    
    @Value("${ai.quota.teacher:10}")
    private int teacherLimit;
    
    @Value("${ai.quota.student:3}")
    private int studentLimit;

    /**
     * 获取角色的每日限制
     */
    private int getDailyLimit(String role) {
        switch (role) {
            case "admin": return adminLimit;
            case "teacher": return teacherLimit;
            default: return studentLimit;
        }
    }

    /**
     * 获取用户今日配额信息
     */
    public Map<String, Object> getQuotaInfo() {
        Long userId = SecurityUtils.getUserId();
        String role = SecurityUtils.getRole();
        LocalDate today = LocalDate.now();
        
        int limit = getDailyLimit(role);
        int used = 0;
        
        AiUsageQuota quota = quotaMapper.findByUserAndDate(userId, today);
        if (quota != null) {
            used = quota.getUsedCount();
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("limit", limit);
        result.put("used", used);
        result.put("remaining", limit == -1 ? -1 : Math.max(0, limit - used));
        result.put("unlimited", limit == -1);
        
        return result;
    }

    /**
     * 检查是否可以使用
     */
    public boolean canUse() {
        String role = SecurityUtils.getRole();
        int limit = getDailyLimit(role);
        
        // 无限制
        if (limit == -1) {
            return true;
        }
        
        Long userId = SecurityUtils.getUserId();
        LocalDate today = LocalDate.now();
        
        AiUsageQuota quota = quotaMapper.findByUserAndDate(userId, today);
        if (quota == null) {
            return true;
        }
        
        return quota.getUsedCount() < limit;
    }

    /**
     * 检查并消耗配额
     */
    @Transactional
    public void checkAndConsume() {
        if (!canUse()) {
            String role = SecurityUtils.getRole();
            int limit = getDailyLimit(role);
            throw new BusinessException("今日AI分析次数已用完（限制" + limit + "次/天）");
        }
        
        Long userId = SecurityUtils.getUserId();
        LocalDate today = LocalDate.now();
        
        AiUsageQuota quota = quotaMapper.findByUserAndDate(userId, today);
        if (quota == null) {
            quota = new AiUsageQuota();
            quota.setUserId(userId);
            quota.setUsageDate(today);
            quota.setUsedCount(1);
            quotaMapper.insert(quota);
        } else {
            quota.setUsedCount(quota.getUsedCount() + 1);
            quotaMapper.updateById(quota);
        }
    }
}
