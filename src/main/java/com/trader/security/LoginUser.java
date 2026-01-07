package com.trader.security;

import com.trader.entity.SysUser;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.Collection;
import java.util.Collections;

@Data
public class LoginUser implements UserDetails {
    private Long userId;
    private String username;
    private String password;
    private String roleCode;
    private Integer status;

    public LoginUser(SysUser user) {
        this.userId = user.getId();
        this.username = user.getUsername();
        this.password = user.getPassword();
        // 使用role字段（数据库实际存储的字段），而不是roleCode（非数据库字段）
        this.roleCode = user.getRole();
        this.status = user.getStatus();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + roleCode));
    }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return status == 1; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return status == 1; }
}
