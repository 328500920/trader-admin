package com.trader.security;

import com.trader.common.BusinessException;
import com.trader.entity.SysUser;
import com.trader.mapper.SysUserMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;

/**
 * 角色权限拦截器
 */
@Component
@RequiredArgsConstructor
public class RoleInterceptor implements HandlerInterceptor {
    
    private final SysUserMapper userMapper;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        // 尝试获取当前用户并设置到request属性中
        Long userId = SecurityUtils.getUserId();
        if (userId != null) {
            SysUser user = userMapper.selectById(userId);
            if (user != null) {
                request.setAttribute("user", user);
            }
        }

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        
        // 先检查方法上的注解
        RequireRole methodAnnotation = handlerMethod.getMethodAnnotation(RequireRole.class);
        // 再检查类上的注解
        RequireRole classAnnotation = handlerMethod.getBeanType().getAnnotation(RequireRole.class);
        
        RequireRole requireRole = methodAnnotation != null ? methodAnnotation : classAnnotation;
        
        if (requireRole == null) {
            return true; // 没有注解，不需要权限校验
        }

        // 获取当前用户角色
        if (userId == null) {
            throw new BusinessException("未登录");
        }

        SysUser user = (SysUser) request.getAttribute("user");
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        String userRole = user.getRole();
        if (userRole == null) {
            userRole = "student"; // 默认学员
        }

        // 检查用户角色是否在允许列表中
        String[] allowedRoles = requireRole.value();
        boolean hasPermission = Arrays.asList(allowedRoles).contains(userRole);

        if (!hasPermission) {
            throw new BusinessException("权限不足");
        }

        return true;
    }
}
