package com.purr.furguardian.web.controller.user;

import com.purr.furguardian.biz.service.MailSettingsService;
import com.purr.furguardian.biz.service.MailSettingsService.MailSettings;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.user.MailSettingsDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user/mail-settings")
@Tag(name = "用户资料")
public class MailSettingsController {

    private final MailSettingsService mailSettingsService;

    public MailSettingsController(MailSettingsService mailSettingsService) {
        this.mailSettingsService = mailSettingsService;
    }

    @GetMapping
    @Operation(summary = "邮件提醒设置")
    public Result<MailSettings> get() {
        return Result.ok(mailSettingsService.get(UserContext.getUserId()));
    }

    @PutMapping
    @Operation(summary = "保存邮件提醒设置", description = "邮箱留空会清除设置并关闭邮件提醒")
    public Result<MailSettings> update(@RequestBody @Valid MailSettingsDTO dto) {
        return Result.ok(mailSettingsService.save(
                UserContext.getUserId(), dto.getEmail(), dto.isEnabled()));
    }
}
