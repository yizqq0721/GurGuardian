package com.purr.furguardian.web.controller.auth;

import com.purr.furguardian.biz.service.AuthService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.auth.LoginDTO;
import com.purr.furguardian.web.dto.auth.LoginVO;
import com.purr.furguardian.web.dto.auth.RegisterDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "账号管理")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    @Operation(summary = "注册")
    public Result<Long> register(@RequestBody @Valid RegisterDTO dto) {
        Long userId = authService.register(dto.getUsername(), dto.getPassword(), dto.getNickname());
        return Result.ok(userId);
    }

    @PostMapping("/login")
    @Operation(summary = "登录")
    public Result<LoginVO> login(@RequestBody @Valid LoginDTO dto) {
        String token = authService.login(dto.getUsername(), dto.getPassword());
        LoginVO vo = new LoginVO();
        vo.setToken(token);
        vo.setUserId(authService.getUserIdByUsername(dto.getUsername()));
        vo.setNickname(authService.getNicknameByUsername(dto.getUsername()));
        vo.setIsAdmin(authService.isAdmin(vo.getUserId()));
        return Result.ok(vo);
    }

    @PostMapping("/logout")
    @Operation(summary = "登出")
    public Result<Void> logout(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            authService.logout(header.substring(7));
        }
        return Result.ok();
    }
}
