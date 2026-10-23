package com.purr.furguardian.web.dto.upload;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "头像上传结果")
public class AvatarUploadVO {

    @Schema(description = "可直接访问的头像 URL",
            example = "https://fur-guardian.oss-cn-beijing.aliyuncs.com/pet-avatar/1/20261021/9f2c1a.png")
    private String url;

    public AvatarUploadVO() {
    }

    public AvatarUploadVO(String url) {
        this.url = url;
    }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
}
