package com.purr.furguardian.web.dto.user;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;

public class MailSettingsDTO {

    @Size(max = 128, message = "邮箱地址过长")
    @Schema(description = "接收提醒的邮箱，留空表示清除并关闭邮件提醒", example = "pet@example.com")
    private String email;

    @Schema(description = "是否开启邮件提醒")
    private boolean enabled;

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
}
