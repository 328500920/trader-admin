package com.trader.controller;

import com.trader.annotation.OperationLog;
import com.trader.annotation.OperationLog.OperationType;
import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.SysUser;
import com.trader.security.RequireRole;
import com.trader.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@RequireRole("admin")
public class UserController {
    private final UserService userService;

    @GetMapping("/list")
    public Result<PageResult<SysUser>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(userService.list(pageNum, pageSize, keyword));
    }

    @PostMapping
    @OperationLog(module = "用户管理", type = OperationType.CREATE, description = "创建用户")
    public Result<Void> create(@RequestBody SysUser user) {
        userService.create(user);
        return Result.success();
    }

    @PutMapping("/{id}")
    @OperationLog(module = "用户管理", type = OperationType.UPDATE, description = "修改用户")
    public Result<Void> update(@PathVariable Long id, @RequestBody SysUser user) {
        user.setId(id);
        userService.update(user);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @OperationLog(module = "用户管理", type = OperationType.DELETE, description = "删除用户")
    public Result<Void> delete(@PathVariable Long id) {
        userService.delete(id);
        return Result.success();
    }

    @PutMapping("/{id}/status")
    @OperationLog(module = "用户管理", type = OperationType.UPDATE, description = "修改用户状态")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params) {
        userService.updateStatus(id, params.get("status"));
        return Result.success();
    }

    @PutMapping("/{id}/reset-password")
    @OperationLog(module = "用户管理", type = OperationType.UPDATE, description = "重置用户密码")
    public Result<Void> resetPassword(@PathVariable Long id, @RequestBody Map<String, String> params) {
        userService.resetPassword(id, params.get("password"));
        return Result.success();
    }

    @PutMapping("/{id}/role")
    @OperationLog(module = "用户管理", type = OperationType.UPDATE, description = "修改用户角色")
    public Result<Void> updateRole(@PathVariable Long id, @RequestBody Map<String, String> params) {
        userService.updateRole(id, params.get("role"));
        return Result.success();
    }
}
