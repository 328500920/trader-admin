package com.trader.controller;

import com.trader.common.BusinessException;
import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.LearnCheckin;
import com.trader.entity.SysUser;
import com.trader.entity.TradeLog;
import com.trader.security.RequireRole;
import com.trader.service.StudentService;
import com.trader.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 学员管理接口
 * 仅管理员和讲师可访问
 */
@RestController
@RequestMapping("/student")
@RequiredArgsConstructor
@RequireRole({"admin", "teacher"})
public class StudentController {
    
    private final StudentService studentService;
    private final UserService userService;

    /**
     * 用户列表（不包含管理员）
     */
    @GetMapping("/list")
    public Result<PageResult<SysUser>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(studentService.listNonAdmin(pageNum, pageSize, keyword));
    }

    /**
     * 新增用户（只能是教师或学员）
     */
    @PostMapping
    public Result<Void> create(@RequestBody SysUser user) {
        // 校验角色只能是 teacher 或 student
        if (!"teacher".equals(user.getRole()) && !"student".equals(user.getRole())) {
            throw new BusinessException("只能添加教师或学员");
        }
        userService.create(user);
        return Result.success();
    }

    /**
     * 更新用户（不能修改管理员）
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody SysUser user) {
        // 检查目标用户是否是管理员
        SysUser existUser = userService.getById(id);
        if (existUser != null && "admin".equals(existUser.getRole())) {
            throw new BusinessException("不能修改管理员");
        }
        // 校验新角色只能是 teacher 或 student
        if (user.getRole() != null && !"teacher".equals(user.getRole()) && !"student".equals(user.getRole())) {
            throw new BusinessException("角色只能是教师或学员");
        }
        user.setId(id);
        userService.update(user);
        return Result.success();
    }

    /**
     * 删除用户（不能删除管理员）
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        SysUser existUser = userService.getById(id);
        if (existUser != null && "admin".equals(existUser.getRole())) {
            throw new BusinessException("不能删除管理员");
        }
        userService.delete(id);
        return Result.success();
    }

    /**
     * 修改用户状态（不能修改管理员）
     */
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        SysUser existUser = userService.getById(id);
        if (existUser != null && "admin".equals(existUser.getRole())) {
            throw new BusinessException("不能修改管理员状态");
        }
        userService.updateStatus(id, status);
        return Result.success();
    }

    /**
     * 重置密码（不能重置管理员）
     */
    @PutMapping("/{id}/password")
    public Result<Void> resetPassword(@PathVariable Long id, @RequestBody Map<String, String> body) {
        SysUser existUser = userService.getById(id);
        if (existUser != null && "admin".equals(existUser.getRole())) {
            throw new BusinessException("不能重置管理员密码");
        }
        String password = body.get("password");
        userService.resetPassword(id, password);
        return Result.success();
    }

    /**
     * 修改角色（不能修改管理员，也不能改成管理员）
     */
    @PutMapping("/{id}/role")
    public Result<Void> updateRole(@PathVariable Long id, @RequestParam String role) {
        SysUser existUser = userService.getById(id);
        if (existUser != null && "admin".equals(existUser.getRole())) {
            throw new BusinessException("不能修改管理员角色");
        }
        if ("admin".equals(role)) {
            throw new BusinessException("不能设置为管理员");
        }
        userService.updateRole(id, role);
        return Result.success();
    }

    /**
     * 学员详情
     */
    @GetMapping("/{id}")
    public Result<SysUser> getById(@PathVariable Long id) {
        return Result.success(studentService.getById(id));
    }

    /**
     * 学员学习进度
     */
    @GetMapping("/{id}/progress")
    public Result<Map<String, Object>> getProgress(@PathVariable Long id) {
        return Result.success(studentService.getProgress(id));
    }

    /**
     * 学员交易统计
     */
    @GetMapping("/{id}/trade-stats")
    public Result<Map<String, Object>> getTradeStats(@PathVariable Long id) {
        return Result.success(studentService.getTradeStats(id));
    }

    /**
     * 学员交易日志
     */
    @GetMapping("/{id}/trade")
    public Result<PageResult<TradeLog>> getTradeLogs(
            @PathVariable Long id,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(studentService.getTradeLogs(id, pageNum, pageSize));
    }

    /**
     * 学员打卡记录
     */
    @GetMapping("/{id}/checkin")
    public Result<List<LearnCheckin>> getCheckins(
            @PathVariable Long id,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        if (year == null) year = LocalDate.now().getYear();
        if (month == null) month = LocalDate.now().getMonthValue();
        return Result.success(studentService.getCheckins(id, year, month));
    }
}
