package com.trader.controller;

import com.trader.common.Result;
import com.trader.entity.SysUser;
import com.trader.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> params) {
        String username = params.get("username");
        String password = params.get("password");
        return Result.success(authService.login(username, password));
    }

    @PostMapping("/logout")
    public Result<Void> logout() {
        return Result.success();
    }

    @GetMapping("/info")
    public Result<SysUser> getUserInfo() {
        SysUser user = authService.getUserInfo();
        user.setPassword(null);
        return Result.success(user);
    }

    @PutMapping("/password")
    public Result<Void> changePassword(@RequestBody Map<String, String> params) {
        authService.changePassword(params.get("oldPassword"), params.get("newPassword"));
        return Result.success();
    }

    @PutMapping("/profile")
    public Result<Void> updateProfile(@RequestBody SysUser user) {
        authService.updateProfile(user);
        return Result.success();
    }
}
