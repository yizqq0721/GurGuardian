package com.purr.furguardian.web.dto.auth;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public class LoginDTO {

    @NotBlank(message = "用户名不能为空")
    @Schema(description = "登录账号", example = "demo")
    private String username;

    @NotBlank(message = "密码不能为空")
    @Schema(description = "密码", example = "demo123")
    private String password;

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
