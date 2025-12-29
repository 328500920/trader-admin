package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {
    @Select("SELECT u.*, r.role_name, r.role_code FROM sys_user u LEFT JOIN sys_role r ON u.role_id = r.id WHERE u.username = #{username}")
    SysUser selectByUsername(String username);

    @Select("SELECT u.*, r.role_name, r.role_code FROM sys_user u LEFT JOIN sys_role r ON u.role_id = r.id WHERE u.id = #{id}")
    SysUser selectUserWithRole(Long id);
}
