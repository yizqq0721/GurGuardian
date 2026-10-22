package com.purr.furguardian.web.dto.admin;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class AdminUserStatusDTO {

    @NotNull(message = "状态不能为空")
    @Min(value = 0, message = "状态值只能为 0 或 1")
    @Max(value = 1, message = "状态值只能为 0 或 1")
    @Schema(description = "1 启用 / 0 禁用", example = "1")
    private Integer status;

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
}
