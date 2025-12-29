package com.trader;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.trader.mapper")
public class TraderAdminApplication {
    public static void main(String[] args) {
        SpringApplication.run(TraderAdminApplication.class, args);
    }
}
