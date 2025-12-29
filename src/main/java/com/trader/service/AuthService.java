package com.trader.service;

import com.trader.common.BusinessException;
import com.trader.entity.SysUser;
import com.trader.mapper.SysUserMapper;
import com.trader.security.JwtUtils;
import com.trader.security.LoginUser;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final JwtUtils jwtUtils;
    private final SysUserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    public Map<String, Object> login(String username, String password) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username, password));
        LoginUser loginUser = (LoginUser) authentication.getPrincipal();
        String token = jwtUtils.generateToken(loginUser.getUserId(), loginUser.getUsername(), loginUser.getRoleCode());
        
        // 更新最后登录时间
        SysUser user = new SysUser();
        user.setId(loginUser.getUserId());
        user.setLastLoginTime(LocalDateTime.now());
        userMapper.updateById(user);

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        return result;
    }

    public SysUser getUserInfo() {
        Long userId = SecurityUtils.getUserId();
        return userMapper.selectUserWithRole(userId);
    }

    public void changePassword(String oldPassword, String newPassword) {
        Long userId = SecurityUtils.getUserId();
        SysUser user = userMapper.selectById(userId);
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new BusinessException("原密码错误");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userMapper.updateById(user);
    }

    public void updateProfile(SysUser profile) {
        Long userId = SecurityUtils.getUserId();
        SysUser user = new SysUser();
        user.setId(userId);
        user.setNickname(profile.getNickname());
        user.setEmail(profile.getEmail());
        user.setPhone(profile.getPhone());
        user.setAvatar(profile.getAvatar());
        userMapper.updateById(user);
    }
}
