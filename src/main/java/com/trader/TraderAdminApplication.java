package com.trader;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.trader.mapper")
@EnableAsync
@EnableScheduling
public class TraderAdminApplication {
    public static void main(String[] args) {
        SpringApplication.run(TraderAdminApplication.class, args);
    }
}
