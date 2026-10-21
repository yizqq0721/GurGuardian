package com.purr.furguardian.web.controller.user;

import com.purr.furguardian.biz.service.UserProfileService;
import com.purr.furguardian.biz.service.UserProfileService.UserProfile;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.user.UserProfileUpdateDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user/profile")
@Tag(name = "用户资料")
public class UserProfileController {

    private final UserProfileService userProfileService;

    public UserProfileController(UserProfileService userProfileService) {
        this.userProfileService = userProfileService;
    }

    @GetMapping
    @Operation(summary = "用户资料")
    public Result<UserProfile> profile() {
        return Result.ok(userProfileService.get(UserContext.getUserId()));
    }

    @PutMapping
    @Operation(summary = "修改昵称与常用城市")
    public Result<UserProfile> update(@RequestBody @Valid UserProfileUpdateDTO dto) {
        return Result.ok(userProfileService.update(
                UserContext.getUserId(), dto.getNickname(), dto.getLocation()));
    }
}
