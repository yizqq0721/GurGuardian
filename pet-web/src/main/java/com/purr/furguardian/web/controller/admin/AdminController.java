package com.purr.furguardian.web.controller.admin;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.purr.furguardian.biz.dto.admin.AdminUserDetail;
import com.purr.furguardian.biz.dto.admin.AdminUserSummary;
import com.purr.furguardian.biz.service.AdminService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.admin.AdminUserStatusDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@Tag(name = "管理后台")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @GetMapping("/users")
    @Operation(summary = "用户列表")
    public Result<Page<AdminUserSummary>> listUsers(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String keyword) {
        return Result.ok(adminService.listUsers(UserContext.getUserId(), page, size, keyword));
    }

    @GetMapping("/users/{id}")
    @Operation(summary = "用户详情")
    public Result<AdminUserDetail> userDetail(@PathVariable Long id) {
        return Result.ok(adminService.getUserDetail(UserContext.getUserId(), id));
    }

    @PutMapping("/users/{id}/status")
    @Operation(summary = "启用/禁用用户")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestBody @Valid AdminUserStatusDTO dto) {
        adminService.updateUserStatus(UserContext.getUserId(), id, dto.getStatus());
        return Result.ok();
    }
}
