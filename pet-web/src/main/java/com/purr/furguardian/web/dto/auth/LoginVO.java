package com.purr.furguardian.web.dto.auth;

import io.swagger.v3.oas.annotations.media.Schema;

public class LoginVO {

    @Schema(description = "登录令牌", example = "abc123def456")
    private String token;

    @Schema(description = "用户ID", example = "1")
    private Long userId;

    @Schema(description = "展示名", example = "演示用户")
    private String nickname;

    @Schema(description = "是否为管理员", example = "false")
    private Boolean isAdmin;

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public Boolean getIsAdmin() { return isAdmin; }
    public void setIsAdmin(Boolean isAdmin) { this.isAdmin = isAdmin; }
}
