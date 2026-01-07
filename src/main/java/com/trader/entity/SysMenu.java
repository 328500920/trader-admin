package com.trader.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 系统菜单实体
 */
@Data
@TableName("sys_menu")
public class SysMenu {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 父菜单ID，0表示顶级菜单
     */
    private Long parentId;
    
    /**
     * 菜单唯一标识，对应前端路由name
     */
    private String menuKey;
    
    /**
     * 菜单显示名称
     */
    private String menuName;
    
    /**
     * 路由路径
     */
    private String path;
    
    /**
     * 菜单图标
     */
    private String icon;
    
    /**
     * 排序序号
     */
    private Integer sortOrder;
    
    /**
     * 是否显示：1-显示 0-隐藏
     */
    private Integer visible;
    
    /**
     * 管理员可见：1-是 0-否
     */
    private Integer roleAdmin;
    
    /**
     * 教师可见：1-是 0-否
     */
    private Integer roleTeacher;
    
    /**
     * 学员可见：1-是 0-否
     */
    private Integer roleStudent;
    
    /**
     * 备注
     */
    private String remark;
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
    
    /**
     * 子菜单列表（非数据库字段）
     */
    @TableField(exist = false)
    private List<SysMenu> children;
}
