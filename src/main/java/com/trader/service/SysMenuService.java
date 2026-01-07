package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.trader.entity.SysMenu;
import com.trader.mapper.SysMenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 系统菜单服务
 */
@Service
public class SysMenuService {
    
    @Autowired
    private SysMenuMapper menuMapper;
    
    /**
     * 获取用户可见菜单（树形结构）
     */
    public List<SysMenu> getUserMenus(String role) {
        // 查询所有可见菜单
        List<SysMenu> allMenus = menuMapper.selectList(
            new QueryWrapper<SysMenu>()
                .eq("visible", 1)
                .orderByAsc("sort_order")
        );
        
        // 管理员返回所有可见菜单
        if ("admin".equals(role)) {
            return buildMenuTree(allMenus);
        }
        
        // 其他角色根据权限过滤
        List<SysMenu> filtered = allMenus.stream()
            .filter(menu -> hasRolePermission(menu, role))
            .collect(Collectors.toList());
        
        return buildMenuTree(filtered);
    }
    
    /**
     * 检查菜单对指定角色是否可见
     */
    private boolean hasRolePermission(SysMenu menu, String role) {
        if ("teacher".equals(role)) {
            return menu.getRoleTeacher() != null && menu.getRoleTeacher() == 1;
        }
        if ("student".equals(role)) {
            return menu.getRoleStudent() != null && menu.getRoleStudent() == 1;
        }
        return false;
    }
    
    /**
     * 获取所有菜单（树形结构，用于管理）
     */
    public List<SysMenu> getAllMenus() {
        List<SysMenu> allMenus = menuMapper.selectList(
            new QueryWrapper<SysMenu>().orderByAsc("sort_order")
        );
        return buildMenuTree(allMenus);
    }
    
    /**
     * 构建菜单树
     */
    private List<SysMenu> buildMenuTree(List<SysMenu> menus) {
        // 按父ID分组
        Map<Long, List<SysMenu>> parentMap = menus.stream()
            .collect(Collectors.groupingBy(SysMenu::getParentId));
        
        // 设置子菜单
        menus.forEach(menu -> {
            List<SysMenu> children = parentMap.get(menu.getId());
            menu.setChildren(children != null ? children : new ArrayList<>());
        });
        
        // 返回顶级菜单
        return menus.stream()
            .filter(menu -> menu.getParentId() == 0)
            .collect(Collectors.toList());
    }
    
    /**
     * 更新菜单
     */
    public void updateMenu(SysMenu menu) {
        menu.setUpdateTime(null); // 让数据库自动更新
        menuMapper.updateById(menu);
    }
    
    /**
     * 批量更新菜单
     */
    public void batchUpdateMenus(List<SysMenu> menus) {
        for (SysMenu menu : menus) {
            menu.setUpdateTime(null);
            menuMapper.updateById(menu);
        }
    }
    
    /**
     * 根据ID获取菜单
     */
    public SysMenu getById(Long id) {
        return menuMapper.selectById(id);
    }
}
