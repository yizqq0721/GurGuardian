package com.purr.furguardian.web.dto.user;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;

public class UserProfileUpdateDTO {

    @Size(max = 50, message = "昵称最长 50 个字符")
    @Schema(description = "展示名", example = "豆豆爸")
    private String nickname;

    @Size(max = 64, message = "当前位置最长 64 个字符")
    @Schema(description = "当前位置，精确到区/县，用于天气与遛弯建议", example = "杭州市西湖区")
    private String location;

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}
