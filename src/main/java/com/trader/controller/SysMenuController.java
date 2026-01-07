package com.trader.controller;

import com.trader.common.Result;
import com.trader.entity.SysMenu;
import com.trader.entity.SysUser;
import com.trader.security.RequireRole;
import com.trader.service.SysMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 系统菜单控制器
 */
@RestController
@RequestMapping("/menu")
public class SysMenuController {
    
    @Autowired
    private SysMenuService menuService;
    
    /**
     * 获取当前用户可见菜单
     */
    @GetMapping("/user")
    public Result<List<SysMenu>> getUserMenus(HttpServletRequest request) {
        SysUser user = (SysUser) request.getAttribute("user");
        if (user == null) {
            return Result.error("未登录");
        }
        List<SysMenu> menus = menuService.getUserMenus(user.getRole());
        return Result.success(menus);
    }
    
    /**
     * 获取所有菜单（管理用）
     */
    @GetMapping("/list")
    @RequireRole({"admin"})
    public Result<List<SysMenu>> getAllMenus() {
        List<SysMenu> menus = menuService.getAllMenus();
        return Result.success(menus);
    }
    
    /**
     * 更新菜单配置
     */
    @PutMapping("/{id}")
    @RequireRole({"admin"})
    public Result<Void> updateMenu(@PathVariable Long id, @RequestBody SysMenu menu) {
        menu.setId(id);
        menuService.updateMenu(menu);
        return Result.success();
    }
    
    /**
     * 批量更新菜单
     */
    @PutMapping("/batch")
    @RequireRole({"admin"})
    public Result<Void> batchUpdateMenus(@RequestBody List<SysMenu> menus) {
        menuService.batchUpdateMenus(menus);
        return Result.success();
    }
}
