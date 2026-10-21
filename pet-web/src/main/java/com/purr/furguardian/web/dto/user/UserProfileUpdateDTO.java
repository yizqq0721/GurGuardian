package com.purr.furguardian.web.dto.user;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;

public class UserProfileUpdateDTO {

    @Size(max = 50, message = "昵称最长 50 个字符")
    @Schema(description = "展示名", example = "豆豆爸")
    private String nickname;

    @Size(max = 64, message = "常用城市最长 64 个字符")
    @Schema(description = "常用城市，用于遛弯天气查询", example = "杭州")
    private String location;

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}
