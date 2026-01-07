package com.trader.utils;

import com.trader.security.LoginUser;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class SecurityUtils {
    public static LoginUser getLoginUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof LoginUser) {
            return (LoginUser) authentication.getPrincipal();
        }
        return null;
    }

    public static Long getUserId() {
        LoginUser loginUser = getLoginUser();
        return loginUser != null ? loginUser.getUserId() : null;
    }

    public static String getUsername() {
        LoginUser loginUser = getLoginUser();
        return loginUser != null ? loginUser.getUsername() : null;
    }

    public static boolean isAdmin() {
        LoginUser loginUser = getLoginUser();
        return loginUser != null && "admin".equals(loginUser.getRoleCode());
    }

    public static String getRole() {
        LoginUser loginUser = getLoginUser();
        return loginUser != null ? loginUser.getRoleCode() : "student";
    }
}
