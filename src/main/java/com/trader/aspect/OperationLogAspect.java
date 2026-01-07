package com.trader.aspect;

import cn.hutool.json.JSONUtil;
import com.trader.annotation.OperationLog;
import com.trader.entity.SysOperationLog;
import com.trader.mapper.SysOperationLogMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class OperationLogAspect {
    
    private final SysOperationLogMapper logMapper;

    @Around("@annotation(operationLog)")
    public Object around(ProceedingJoinPoint point, OperationLog operationLog) throws Throwable {
        long startTime = System.currentTimeMillis();
        
        // 获取请求信息
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes != null ? attributes.getRequest() : null;
        
        // 获取当前用户
        Long userId = null;
        String username = null;
        try {
            userId = SecurityUtils.getUserId();
            username = SecurityUtils.getUsername();
        } catch (Exception e) {
            // 登录接口可能还没有用户信息
        }
        
        // 如果是登录操作且没有用户信息，尝试从请求参数获取用户名
        if (username == null && "LOGIN".equals(operationLog.type().getCode())) {
            try {
                Object[] args = point.getArgs();
                if (args != null && args.length > 0) {
                    Object arg = args[0];
                    if (arg instanceof Map) {
                        Object usernameObj = ((Map<?, ?>) arg).get("username");
                        if (usernameObj != null) {
                            username = usernameObj.toString();
                        }
                    } else {
                        // 尝试反射获取username字段
                        try {
                            java.lang.reflect.Field field = arg.getClass().getDeclaredField("username");
                            field.setAccessible(true);
                            Object value = field.get(arg);
                            if (value != null) {
                                username = value.toString();
                            }
                        } catch (Exception ignored) {}
                    }
                }
            } catch (Exception ignored) {}
        }
        
        // 构建日志对象
        SysOperationLog logEntity = new SysOperationLog();
        logEntity.setUserId(userId);
        logEntity.setUsername(username);
        logEntity.setOperationType(operationLog.type().getCode());
        logEntity.setModule(operationLog.module());
        logEntity.setDescription(operationLog.description());
        
        if (request != null) {
            logEntity.setMethod(request.getMethod());
            logEntity.setRequestUrl(request.getRequestURI());
            logEntity.setIp(getClientIp(request));
            logEntity.setUserAgent(request.getHeader("User-Agent"));
            
            // 获取请求参数
            try {
                Map<String, Object> params = getRequestParams(point, request);
                if (!params.isEmpty()) {
                    logEntity.setRequestParams(JSONUtil.toJsonStr(params));
                }
            } catch (Exception e) {
                log.warn("获取请求参数失败", e);
            }
        }
        
        Object result = null;
        try {
            result = point.proceed();
            logEntity.setStatus(1);
            logEntity.setResponseCode(200);
        } catch (Throwable e) {
            logEntity.setStatus(0);
            logEntity.setResponseCode(500);
            logEntity.setErrorMsg(e.getMessage());
            throw e;
        } finally {
            logEntity.setExecutionTime(System.currentTimeMillis() - startTime);
            logEntity.setCreatedAt(LocalDateTime.now());
            
            // 异步保存日志
            saveLogAsync(logEntity);
        }
        
        return result;
    }
    
    /**
     * 异步保存日志
     */
    @Async
    public void saveLogAsync(SysOperationLog logEntity) {
        try {
            logMapper.insert(logEntity);
        } catch (Exception e) {
            log.error("保存操作日志失败", e);
        }
    }
    
    /**
     * 获取请求参数
     */
    private Map<String, Object> getRequestParams(ProceedingJoinPoint point, HttpServletRequest request) {
        Map<String, Object> params = new HashMap<>();
        
        // 敏感字段列表
        java.util.Set<String> sensitiveFields = new java.util.HashSet<>(
            java.util.Arrays.asList("password", "pwd", "oldPassword", "newPassword", "confirmPassword", "token", "secret")
        );
        
        // 获取URL参数
        Map<String, String[]> parameterMap = request.getParameterMap();
        if (parameterMap != null && !parameterMap.isEmpty()) {
            parameterMap.forEach((key, value) -> {
                if (sensitiveFields.contains(key.toLowerCase())) {
                    params.put(key, "******");
                } else if (value != null && value.length == 1) {
                    params.put(key, value[0]);
                } else {
                    params.put(key, value);
                }
            });
        }
        
        // 获取方法参数
        MethodSignature signature = (MethodSignature) point.getSignature();
        String[] paramNames = signature.getParameterNames();
        Object[] args = point.getArgs();
        
        if (paramNames != null && args != null) {
            for (int i = 0; i < paramNames.length; i++) {
                Object arg = args[i];
                String paramName = paramNames[i];
                
                if (arg == null) continue;
                
                // 敏感参数脱敏
                if (sensitiveFields.contains(paramName.toLowerCase())) {
                    params.put(paramName, "******");
                } else if (isSimpleType(arg)) {
                    params.put(paramName, arg);
                } else if (!isIgnoredType(arg)) {
                    try {
                        // 对Map类型参数中的敏感字段脱敏
                        if (arg instanceof Map) {
                            Map<String, Object> maskedMap = maskSensitiveFields((Map<?, ?>) arg, sensitiveFields);
                            params.put(paramName, JSONUtil.toJsonStr(maskedMap));
                        } else {
                            params.put(paramName, JSONUtil.toJsonStr(arg));
                        }
                    } catch (Exception e) {
                        // 忽略序列化失败的参数
                    }
                }
            }
        }
        
        return params;
    }
    
    /**
     * 对Map中的敏感字段脱敏
     */
    private Map<String, Object> maskSensitiveFields(Map<?, ?> original, java.util.Set<String> sensitiveFields) {
        Map<String, Object> masked = new HashMap<>();
        original.forEach((key, value) -> {
            String keyStr = String.valueOf(key);
            if (sensitiveFields.contains(keyStr.toLowerCase())) {
                masked.put(keyStr, "******");
            } else {
                masked.put(keyStr, value);
            }
        });
        return masked;
    }
    
    /**
     * 判断是否为简单类型
     */
    private boolean isSimpleType(Object obj) {
        return obj instanceof String 
                || obj instanceof Number 
                || obj instanceof Boolean;
    }
    
    /**
     * 判断是否为需要忽略的类型
     */
    private boolean isIgnoredType(Object obj) {
        String className = obj.getClass().getName();
        return className.startsWith("javax.servlet")
                || className.startsWith("org.springframework")
                || className.contains("MultipartFile");
    }
    
    /**
     * 获取客户端IP
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 多个代理时取第一个IP
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
