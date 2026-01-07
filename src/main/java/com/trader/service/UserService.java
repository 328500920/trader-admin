package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.BusinessException;
import com.trader.common.PageResult;
import com.trader.entity.SysUser;
import com.trader.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

@Service
@RequiredArgsConstructor
public class UserService {
    private final SysUserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    public PageResult<SysUser> list(int pageNum, int pageSize, String keyword) {
        Page<SysUser> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.like(SysUser::getUsername, keyword).or().like(SysUser::getNickname, keyword);
        }
        wrapper.orderByDesc(SysUser::getCreateTime);
        Page<SysUser> result = userMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    public void create(SysUser user) {
        if (userMapper.selectByUsername(user.getUsername()) != null) {
            throw new BusinessException("用户名已存在");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setStatus(1);
        if (user.getRole() == null) {
            user.setRole("student"); // 默认学员
        }
        userMapper.insert(user);
    }

    public void update(SysUser user) {
        SysUser existing = userMapper.selectById(user.getId());
        if (existing == null) {
            throw new BusinessException("用户不存在");
        }
        user.setPassword(null);
        userMapper.updateById(user);
    }

    public void updateRole(Long id, String role) {
        if (!role.equals("admin") && !role.equals("teacher") && !role.equals("student")) {
            throw new BusinessException("无效的角色");
        }
        SysUser user = new SysUser();
        user.setId(id);
        user.setRole(role);
        userMapper.updateById(user);
    }

    public void delete(Long id) {
        userMapper.deleteById(id);
    }

    public void updateStatus(Long id, Integer status) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setStatus(status);
        userMapper.updateById(user);
    }

    public void resetPassword(Long id, String newPassword) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setPassword(passwordEncoder.encode(newPassword));
        userMapper.updateById(user);
    }

    public SysUser getById(Long id) {
        return userMapper.selectById(id);
    }
}
