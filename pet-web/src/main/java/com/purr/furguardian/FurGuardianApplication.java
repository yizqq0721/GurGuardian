package com.purr.furguardian;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.purr.furguardian.biz.mapper.**")
public class FurGuardianApplication {

    public static void main(String[] args) {
        SpringApplication.run(FurGuardianApplication.class, args);
    }
}
