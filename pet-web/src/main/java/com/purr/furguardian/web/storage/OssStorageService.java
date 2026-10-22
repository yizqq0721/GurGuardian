package com.purr.furguardian.web.storage;

import com.aliyun.oss.ClientException;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSException;
import com.aliyun.oss.model.ObjectMetadata;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.web.config.OssProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.UUID;

@Service
public class OssStorageService {

    private static final Logger log = LoggerFactory.getLogger(OssStorageService.class);
    private static final long MAX_AVATAR_SIZE = 5L * 1024 * 1024;
    private static final String AVATAR_DIR = "pet-avatar";
    private static final DateTimeFormatter DATE_PATH = DateTimeFormatter.ofPattern("yyyyMMdd");

    private final OSS ossClient;
    private final OssProperties properties;

    public OssStorageService(OSS ossClient, OssProperties properties) {
        this.ossClient = ossClient;
        this.properties = properties;
    }

    public String uploadAvatar(MultipartFile file, Long userId) {
        if (file == null || file.isEmpty()) {
            throw new BizException(ErrorCode.BAD_REQUEST, "请选择要上传的图片");
        }
        if (file.getSize() > MAX_AVATAR_SIZE) {
            throw new BizException(ErrorCode.BAD_REQUEST, "图片大小不能超过 5MB");
        }

        String extension = resolveExtension(file.getContentType());
        validateMagicBytes(file, extension);

        String objectKey = "%s/%d/%s/%s.%s".formatted(
                AVATAR_DIR,
                userId,
                LocalDate.now().format(DATE_PATH),
                UUID.randomUUID().toString().replace("-", ""),
                extension);

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentType(contentTypeOf(extension));
        metadata.setContentLength(file.getSize());
        metadata.setCacheControl("public, max-age=31536000, immutable");

        try (InputStream in = file.getInputStream()) {
            ossClient.putObject(properties.getBucket(), objectKey, in, metadata);
        } catch (IOException e) {
            log.error("读取头像文件失败, userId={}", userId, e);
            throw new BizException(ErrorCode.INTERNAL_ERROR, "读取上传文件失败");
        } catch (OSSException | ClientException e) {
            log.error("上传头像到 OSS 失败, userId={}, endpoint={}, bucket={}",
                    userId, properties.getEndpoint(), properties.getBucket(), e);
            throw new BizException(ErrorCode.INTERNAL_ERROR, "图片上传失败，请稍后重试");
        }

        return buildPublicUrl(objectKey);
    }

    private String resolveExtension(String contentType) {
        if (contentType == null || contentType.isBlank()) {
            throw new BizException(ErrorCode.BAD_REQUEST, "仅支持 JPG、PNG、WebP 格式的图片");
        }
        return switch (contentType.toLowerCase(Locale.ROOT)) {
            case "image/jpeg", "image/jpg" -> "jpg";
            case "image/png" -> "png";
            case "image/webp" -> "webp";
            default -> throw new BizException(ErrorCode.BAD_REQUEST, "仅支持 JPG、PNG、WebP 格式的图片");
        };
    }

    private String contentTypeOf(String extension) {
        return switch (extension) {
            case "jpg" -> "image/jpeg";
            case "png" -> "image/png";
            case "webp" -> "image/webp";
            default -> throw new IllegalArgumentException("Unsupported extension: " + extension);
        };
    }

    private void validateMagicBytes(MultipartFile file, String extension) {
        byte[] header = new byte[12];
        int read;
        try (InputStream in = file.getInputStream()) {
            read = in.readNBytes(header, 0, header.length);
        } catch (IOException e) {
            log.error("读取头像文件头失败", e);
            throw new BizException(ErrorCode.INTERNAL_ERROR, "读取上传文件失败");
        }

        boolean valid = switch (extension) {
            case "jpg" -> read >= 3
                    && (header[0] & 0xFF) == 0xFF
                    && (header[1] & 0xFF) == 0xD8
                    && (header[2] & 0xFF) == 0xFF;
            case "png" -> read >= 8
                    && (header[0] & 0xFF) == 0x89
                    && header[1] == 'P' && header[2] == 'N' && header[3] == 'G'
                    && (header[4] & 0xFF) == 0x0D && (header[5] & 0xFF) == 0x0A
                    && (header[6] & 0xFF) == 0x1A && (header[7] & 0xFF) == 0x0A;
            case "webp" -> read >= 12
                    && header[0] == 'R' && header[1] == 'I' && header[2] == 'F' && header[3] == 'F'
                    && header[8] == 'W' && header[9] == 'E' && header[10] == 'B' && header[11] == 'P';
            default -> false;
        };
        if (!valid) {
            throw new BizException(ErrorCode.BAD_REQUEST, "图片内容与文件格式不符，请重新选择");
        }
    }

    private String buildPublicUrl(String objectKey) {
        String baseUrl = properties.getPublicBaseUrl();
        if (baseUrl != null && !baseUrl.isBlank()) {
            return baseUrl.replaceAll("/+$", "") + "/" + objectKey;
        }
        String endpoint = properties.getEndpoint()
                .replaceFirst("^https?://", "")
                .replaceAll("/+$", "");
        return "https://" + properties.getBucket() + "." + endpoint + "/" + objectKey;
    }
}
