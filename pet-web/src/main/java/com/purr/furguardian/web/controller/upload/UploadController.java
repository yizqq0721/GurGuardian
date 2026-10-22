package com.purr.furguardian.web.controller.upload;

import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.upload.AvatarUploadVO;
import com.purr.furguardian.web.storage.OssStorageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/upload")
@Tag(name = "文件上传")
public class UploadController {

    private final OssStorageService ossStorageService;

    public UploadController(OssStorageService ossStorageService) {
        this.ossStorageService = ossStorageService;
    }

    @PostMapping(value = "/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "上传宠物头像（JPG/PNG/WebP，最大 5MB）")
    public Result<AvatarUploadVO> uploadAvatar(@RequestPart("file") MultipartFile file) {
        String url = ossStorageService.uploadAvatar(file, UserContext.getUserId());
        return Result.ok(new AvatarUploadVO(url));
    }
}
