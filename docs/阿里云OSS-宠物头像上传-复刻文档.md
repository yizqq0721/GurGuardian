# 阿里云 OSS 宠物头像上传 — 复刻文档

> 完成日期：2026-10-21
> 适用代码：`fur-guardian2`（Spring Boot 4.1.1 / Java 21 + Vue 3 / TypeScript / Vite）
> 目标：在「添加宠物（OnboardingView）」和「宠物档案（PetProfileView）」页面，允许用户上传本地图片作为宠物头像，文件存入阿里云 OSS，数据库仅保存可公开访问的图片 URL。

---

## 1. 功能范围

- 新增后端上传接口 `POST /api/upload/avatar`，接收 `multipart/form-data` 的 `file` 字段。
- 使用阿里云 OSS Java SDK 将图片上传到指定 Bucket。
- 服务端校验：登录态、文件非空、≤ 5MB、仅 JPG/PNG/WebP、文件头（magic bytes）与声明类型一致。
- 返回 OSS 公网直链；前端把 URL 写入 `form.avatar`，随宠物新增/编辑一起保存。
- 更换头像时**保留旧文件**，不删除 OSS 历史对象。
- 数据库无需改表：`pets.avatar` 原本就是 `VARCHAR(255)` 字符串，可直接存 URL；现有 `petAvatarUrl` 已支持 `http(s)` 地址。

调用链路：

```
PetAvatarPicker.vue
  → src/api/upload.ts（FormData + Bearer Token）
    → UploadController#uploadAvatar
      → OssStorageService#uploadAvatar（类型/大小/文件头校验）
        → 阿里云 OSS PutObject
      ← 返回 { url }
  → emit('update:modelValue', url)
  → 页面 form.avatar = url
  → 保存宠物时写入 pets.avatar
```

---

## 2. 新增文件清单（含所属包）

| # | 文件（仓库相对路径） | 所属模块 | 所属包 / 目录 | 职责 |
|---|---|---|---|---|
| 1 | `pet-web/src/main/java/com/purr/furguardian/web/config/OssProperties.java` | pet-web | `com.purr.furguardian.web.config` | 绑定 `aliyun.oss.*` 配置（endpoint、bucket、AccessKey、publicBaseUrl） |
| 2 | `pet-web/src/main/java/com/purr/furguardian/web/config/OssConfig.java` | pet-web | `com.purr.furguardian.web.config` | 创建并管理 `OSS` 客户端 Bean，容器关闭时 `shutdown` |
| 3 | `pet-web/src/main/java/com/purr/furguardian/web/storage/OssStorageService.java` | pet-web | `com.purr.furguardian.web.storage` | 头像校验、对象 key 生成、上传 OSS、拼接公网 URL |
| 4 | `pet-web/src/main/java/com/purr/furguardian/web/dto/upload/AvatarUploadVO.java` | pet-web | `com.purr.furguardian.web.dto.upload` | 上传结果响应体，仅含 `url` |
| 5 | `pet-web/src/main/java/com/purr/furguardian/web/controller/upload/UploadController.java` | pet-web | `com.purr.furguardian.web.controller.upload` | 暴露 `POST /api/upload/avatar` |
| 6 | `fur-guardian-front/src/api/upload.ts` | 前端 | `src/api`（无 Java 包概念） | 前端上传 API 封装 |

> 新包目录：`pet-web` 下新增了 `web/config`、`web/storage`、`web/dto/upload`、`web/controller/upload` 四个包。其中 `web/config` 可能与既有配置类共用目录，文件本身是新增的。

---

## 3. 修改文件清单

| # | 文件 | 改动内容 |
|---|---|---|
| 1 | `pom.xml`（根） | `properties` 增加 `<aliyun-oss.version>3.18.1</aliyun-oss.version>`；`dependencyManagement` 增加 `com.aliyun.oss:aliyun-sdk-oss` |
| 2 | `pet-web/pom.xml` | 增加 `aliyun-sdk-oss` 依赖（版本由根 pom 管理） |
| 3 | `pet-web/src/main/resources/application.yml` | 增加 `spring.servlet.multipart` 大小限制；增加 `aliyun.oss` 非密钥配置 |
| 4 | `pet-web/src/main/resources/application-local.yml.example` | 增加 OSS AccessKey 占位符，提示本地填写 |
| 5 | `pet-common/src/main/java/com/purr/furguardian/common/exception/GlobalExceptionHandler.java` | 增加 `MaxUploadSizeExceededException` 处理，返回「图片大小不能超过 5MB」 |
| 6 | `fur-guardian-front/src/components/PetAvatarPicker.vue` | 头像网格增加「上传」格子、隐藏文件输入、客户端校验、上传中状态、已上传头像预览与「移除上传的图片」 |
| 7 | `pet-web/src/main/resources/application-local.yml`（**仅本地，已被 .gitignore 忽略**） | 填入真实 `access-key-id` / `access-key-secret`，不得提交 |

页面本身**不需要修改**，因为两个页面已经在用同一个头像组件：

```vue
<!-- OnboardingView.vue:40 -->
<PetAvatarPicker v-model="form.avatar" :species="form.species" />

<!-- PetProfileView.vue:49 -->
<PetAvatarPicker v-model="form.avatar" :species="form.species" />
```

---

## 4. 前置准备（阿里云 OSS）

### 4.1 创建 Bucket

本实现使用的参数：

| 配置项 | 值 |
|---|---|
| Bucket | `fur-guardian` |
| Endpoint | `oss-cn-beijing.aliyuncs.com` |
| 地域 | 华北 2（北京） |
| 读写权限 | **公共读**（头像需要通过 `<img>` 直接访问） |

控制台路径：OSS → Bucket 列表 → 创建 Bucket → 填写名称、地域 → 读写权限选择「公共读」。

> 公共读意味着任何拿到 URL 的人都能访问图片。头像属于公开展示内容，可以接受；不要用该 Bucket 存敏感文件。

### 4.2 创建 RAM 子账号并授权

不要使用主账号 AccessKey。建议创建一个专用 RAM 用户（仅编程访问），并授予**最小权限**：

```json
{
  "Version": "1",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "oss:PutObject"
      ],
      "Resource": [
        "acs:oss:*:*:fur-guardian/pet-avatar/*"
      ]
    }
  ]
}
```

说明：

- 上传只调用 `PutObject`，因此只需要该权限。
- 因为 Bucket 是公共读，读取图片不依赖 RAM 的 `GetObject` 权限；如果改成私有读，需要再补 `oss:GetObject` 并改用签名 URL。
- 如果后续要在服务端删除旧头像，需要另加 `oss:DeleteObject`；当前版本**不删除**旧文件。

### 4.3 CORS（可选）

当前上传走自己的后端（浏览器 → Spring Boot → OSS），**不需要**配置 Bucket CORS。

只有未来改成「浏览器直传 OSS」时，才需要给 Bucket 配置 CORS（允许站点来源、`POST`、`Content-Type` 等）。

### 4.4 自定义域名 / CDN（可选）

如果 Bucket 绑定了 CDN 或自定义域名，把该域名填到 `aliyun.oss.public-base-url`，返回的 URL 会优先使用它。留空则使用：

```
https://{bucket}.{endpoint}/{objectKey}
```

---

## 5. 后端实现

### 5.1 Maven 依赖

根 `pom.xml`：

```xml
<properties>
    <!-- ... -->
    <aliyun-oss.version>3.18.1</aliyun-oss.version>
</properties>

<dependencyManagement>
    <dependencies>
        <!-- ... -->
        <dependency>
            <groupId>com.aliyun.oss</groupId>
            <artifactId>aliyun-sdk-oss</artifactId>
            <version>${aliyun-oss.version}</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

`pet-web/pom.xml`：

```xml
<!-- 阿里云 OSS：宠物头像等对象存储 -->
<dependency>
    <groupId>com.aliyun.oss</groupId>
    <artifactId>aliyun-sdk-oss</artifactId>
</dependency>
```

### 5.2 配置项

`pet-web/src/main/resources/application.yml`（可入库，不含密钥）：

```yaml
spring:
  servlet:
    multipart:
      max-file-size: 5MB
      max-request-size: 6MB

aliyun:
  oss:
    endpoint: oss-cn-beijing.aliyuncs.com
    bucket: fur-guardian
    access-key-id: your-oss-access-key-id
    access-key-secret: your-oss-access-key-secret
    # 可选：CDN/自定义域名。留空时返回 https://{bucket}.{endpoint}/{objectKey}
    public-base-url:
```

`pet-web/src/main/resources/application-local.yml`（**本地私有，已 gitignore，不提交**）：

```yaml
aliyun:
  oss:
    access-key-id: "CHANGE_ME_OSS_ACCESS_KEY_ID"
    access-key-secret: "CHANGE_ME_OSS_ACCESS_KEY_SECRET"
```

`application-local.yml.example` 中也加入了同样的占位符，方便新环境复制：

```yaml
# 阿里云 OSS：宠物头像上传。建议使用仅授权该 Bucket PutObject 的 RAM 子账号。
aliyun:
  oss:
    access-key-id: "CHANGE_ME_OSS_ACCESS_KEY_ID"
    access-key-secret: "CHANGE_ME_OSS_ACCESS_KEY_SECRET"
```

配置优先级：环境变量 > `application-local.yml` > `application.yml`。如果不想用本地文件，也可以设置：

```bash
ALIYUN_OSS_ACCESS_KEY_ID=...
ALIYUN_OSS_ACCESS_KEY_SECRET=...
```

> 注意：`application.yml` 中的占位符不会导致启动失败，但第一次上传会因密钥无效而返回「图片上传失败，请稍后重试」。

### 5.3 `OssProperties`（`com.purr.furguardian.web.config`）

```java
package com.purr.furguardian.web.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "aliyun.oss")
public class OssProperties {

    private String endpoint;
    private String bucket;
    private String accessKeyId;
    private String accessKeySecret;
    private String publicBaseUrl;

    public String getEndpoint() { return endpoint; }
    public void setEndpoint(String endpoint) { this.endpoint = endpoint; }
    public String getBucket() { return bucket; }
    public void setBucket(String bucket) { this.bucket = bucket; }
    public String getAccessKeyId() { return accessKeyId; }
    public void setAccessKeyId(String accessKeyId) { this.accessKeyId = accessKeyId; }
    public String getAccessKeySecret() { return accessKeySecret; }
    public void setAccessKeySecret(String accessKeySecret) { this.accessKeySecret = accessKeySecret; }
    public String getPublicBaseUrl() { return publicBaseUrl; }
    public void setPublicBaseUrl(String publicBaseUrl) { this.publicBaseUrl = publicBaseUrl; }
}
```

### 5.4 `OssConfig`（`com.purr.furguardian.web.config`）

```java
package com.purr.furguardian.web.config;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OssConfig {

    @Bean(destroyMethod = "shutdown")
    public OSS ossClient(OssProperties properties) {
        return new OSSClientBuilder().build(
                properties.getEndpoint(),
                properties.getAccessKeyId(),
                properties.getAccessKeySecret());
    }
}
```

> `OSS` 客户端是线程安全的，作为单例 Bean 复用即可，不要在每次上传时 new。

### 5.5 `OssStorageService`（`com.purr.furguardian.web.storage`）

完整实现：

```java
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
```

对象 key 规则：

```
pet-avatar/{userId}/{yyyyMMdd}/{32位UUID}.{jpg|png|webp}
示例：pet-avatar/1/20261021/9f2c1a4b8d6e4f0a9b7c3d2e1f0a9b8c.png
```

设计要点：

- **不使用原始文件名**，避免路径穿越、中文/特殊字符、重名覆盖。
- 按用户与日期分目录，便于排查和后续生命周期管理。
- `Cache-Control: public, max-age=31536000, immutable`：URL 含随机 UUID，内容不会变，可长期缓存。
- 旧头像不删除，天然保留历史；如需清理，另做定时任务或生命周期规则。
- 所有校验失败都抛 `BizException`，由全局异常处理统一转成 `Result`。

### 5.6 `AvatarUploadVO`（`com.purr.furguardian.web.dto.upload`）

```java
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
```

### 5.7 `UploadController`（`com.purr.furguardian.web.controller.upload`）

```java
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
```

登录态说明：

- `WebMvcConfig` 中的 `AuthInterceptor` 拦截 `/api/**`，未排除 `/api/upload/**`，因此该接口自动要求 `Authorization: Bearer <token>`。
- `UserContext.getUserId()` 从拦截器写入的上下文取当前用户 ID，用于生成对象 key。
- 如果项目没有现成的 `UserContext`，可以改为从 `HttpServletRequest` 的鉴权结果中获取用户 ID，或把用户 ID 从请求中移除并使用固定目录。

### 5.8 全局异常处理（修改 `pet-common`）

```java
import org.springframework.web.multipart.MaxUploadSizeExceededException;

@ExceptionHandler(MaxUploadSizeExceededException.class)
public Result<Void> handleUploadTooLarge(MaxUploadSizeExceededException e) {
    return Result.fail(ErrorCode.BAD_REQUEST.getCode(), "图片大小不能超过 5MB");
}
```

作用：文件超过 `spring.servlet.multipart.max-file-size` 时，Spring 在进入 Controller 前就抛异常，需要一个专门的处理器返回友好文案，否则会落到通用 500。

---

## 6. 接口契约

### 6.1 请求

```http
POST /api/upload/avatar
Authorization: Bearer <token>
Content-Type: multipart/form-data; boundary=...

file=<二进制图片>
```

| 参数 | 位置 | 必填 | 说明 |
|---|---|---|---|
| `file` | form-data | 是 | JPG / PNG / WebP，≤ 5MB |

### 6.2 成功响应

HTTP 200，业务 `code` 为 200：

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "url": "https://fur-guardian.oss-cn-beijing.aliyuncs.com/pet-avatar/1/20261021/9f2c1a4b8d6e4f0a9b7c3d2e1f0a9b8c.png"
  }
}
```

> 项目约定：业务错误也返回 HTTP 200，错误信息在响应体 `code` / `message` 中；前端 `request.ts` 会统一拦截并提示。

### 6.3 错误码与文案

| 场景 | 业务 code | message |
|---|---|---|
| 未登录 / token 失效 | 401 | 登录已过期，请重新登录（由拦截器返回） |
| 未选择文件 | 400 | 请选择要上传的图片 |
| 文件超过 5MB | 400 | 图片大小不能超过 5MB |
| 类型不在白名单 | 400 | 仅支持 JPG、PNG、WebP 格式的图片 |
| 文件头与类型不符 | 400 | 图片内容与文件格式不符，请重新选择 |
| OSS 上传失败 | 500 | 图片上传失败，请稍后重试 |
| 读取文件失败 | 500 | 读取上传文件失败 |

---

## 7. 前端实现

### 7.1 API 封装：`fur-guardian-front/src/api/upload.ts`

```ts
import request from './request'

export interface AvatarUploadResult {
  url: string
}

export const uploadApi = {
  avatar(file: File) {
    const data = new FormData()
    data.append('file', file)
    return request.post<AvatarUploadResult>('/api/upload/avatar', data)
  },
}
```

说明：

- 不要手动设置 `Content-Type`，交给浏览器/axios 自动生成带 boundary 的 multipart 头。
- `request.ts` 的请求拦截器会自动附加 `Authorization: Bearer <fg_token>`。
- `request.ts` 的响应拦截器会把 `code === 200` 的响应解包成 `data`，所以调用方直接拿到 `{ url }`。

### 7.2 头像组件：`fur-guardian-front/src/components/PetAvatarPicker.vue`

原有组件只支持预设插画，本次在网格末尾增加一个「上传」格子，并新增：

- 隐藏的 `<input type="file" accept="image/jpeg,image/png,image/webp">`；
- 客户端校验：类型白名单 + ≤ 5MB；
- 上传中状态：格子禁用、显示遮罩与 spinner；
- 已上传头像：格子显示 OSS 图片预览 + 选中对勾，按钮文案变为「重新上传头像」；
- 提示行下方出现「移除上传的图片」；
- `isCustomAvatar` 通过 `/^https?:\/\//` 判断当前值是否为上传 URL；
- 上传成功后 `emit('update:modelValue', url)`，与预设头像共用同一个 `v-model`。

关键脚本：

```ts
const MAX_FILE_SIZE = 5 * 1024 * 1024
const ACCEPTED_TYPES = ['image/jpeg', 'image/png', 'image/webp']

const fileInput = ref<HTMLInputElement>()
const uploading = ref(false)

const isCustomAvatar = computed(() => /^https?:\/\//.test(props.modelValue || ''))

function pickFile() {
  if (uploading.value) return
  fileInput.value?.click()
}

async function onFileChange(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  if (!ACCEPTED_TYPES.includes(file.type)) {
    ElMessage.error('仅支持 JPG、PNG、WebP 格式的图片')
    input.value = ''
    return
  }
  if (file.size > MAX_FILE_SIZE) {
    ElMessage.error('图片大小不能超过 5MB')
    input.value = ''
    return
  }

  uploading.value = true
  try {
    const { url } = await uploadApi.avatar(file)
    emit('update:modelValue', url)
  } catch {
    // request.ts 已统一提示错误
  } finally {
    uploading.value = false
    input.value = ''
  }
}

function clearCustom() {
  emit('update:modelValue', '')
}
```

关键模板（新增的上传格子与文件输入）：

```vue
<button
  type="button"
  class="avatar-opt avatar-upload"
  :class="{ 'is-active': isCustomAvatar }"
  :disabled="uploading"
  :aria-label="isCustomAvatar ? '重新上传头像' : '上传本地图片作为头像'"
  @click="pickFile"
>
  <template v-if="isCustomAvatar">
    <img :src="modelValue || ''" alt="" draggable="false" />
    <span class="pick-mark" aria-hidden="true"><Check :size="11" /></span>
  </template>
  <template v-else>
    <Upload :size="18" aria-hidden="true" />
    <span class="upload-text">{{ uploading ? '上传中' : '上传' }}</span>
  </template>
  <span v-if="uploading" class="upload-mask" aria-hidden="true">
    <span class="spinner" />
  </span>
</button>

<input
  ref="fileInput"
  class="file-input"
  type="file"
  accept="image/jpeg,image/png,image/webp"
  @change="onFileChange"
/>
```

样式要点：

- `.avatar-upload` 使用虚线边框，与预设头像区分；
- `.file-input` 使用 1px + `clip` 的视觉隐藏方式（不要用 `display: none`，否则部分自动化和辅助技术看不到文件输入）；
- `.upload-mask` + `.spinner` 提供上传中反馈；
- `.hint-action` 为「移除上传的图片」文字按钮。

### 7.3 页面接入

`OnboardingView.vue` 与 `PetProfileView.vue` 均已使用：

```vue
<PetAvatarPicker v-model="form.avatar" :species="form.species" />
```

上传成功后 URL 写入 `form.avatar`；点击「继续 / 保存修改」时，按原有宠物新增/编辑接口提交，无需为头像单独调用保存接口。

---

## 8. 构建与启动

### 8.1 后端

```bash
# 仓库根目录
./mvnw -DskipTests package
./mvnw -pl pet-web spring-boot:run
```

或直接运行打包产物（按实际 jar 名调整）：

```bash
java -jar pet-web/target/pet-web-0.0.1-SNAPSHOT.jar
```

默认 `spring.profiles.active: local`，会加载 `application-local.yml`。

### 8.2 前端

```bash
cd fur-guardian-front
npm install
npm run dev
```

开发地址：`http://localhost:5173`（本项目 Vite 可能只监听 IPv6，使用 `localhost` 而不是 `127.0.0.1`）。

### 8.3 构建检查

```bash
# 前端类型检查
cd fur-guardian-front
npx vue-tsc --noEmit
```

---

## 9. 验证步骤

### 9.1 获取登录 token

```bash
curl -s http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"demo123"}'
```

从响应 `data.token` 取出 token。

### 9.2 上传图片

```bash
curl -s http://localhost:8080/api/upload/avatar \
  -H "Authorization: Bearer <TOKEN>" \
  -F "file=@D:/path/to/avatar.png"
```

预期：

```json
{"code":200,"message":"success","data":{"url":"https://fur-guardian.oss-cn-beijing.aliyuncs.com/pet-avatar/..."}}
```

### 9.3 验证公网可访问

```bash
curl -I "<上一步返回的 url>"
```

预期：`HTTP/1.1 200 OK`，`Content-Type: image/png`（或 jpeg/webp）。

### 9.4 负向验证

| 用例 | 命令要点 | 预期 |
|---|---|---|
| 超过 5MB | 上传 6MB 文件 | `code:400`，「图片大小不能超过 5MB」 |
| 非图片类型 | `file=@README.md`（`text/plain`） | `code:400`，「仅支持 JPG、PNG、WebP 格式的图片」 |
| 伪装图片 | 文本文件改名 `.png`，但内容不是 PNG | `code:400`，「图片内容与文件格式不符，请重新选择」 |
| 未登录 | 不带 Authorization | 401（由拦截器返回） |

### 9.5 浏览器端到端验证

1. 打开 `http://localhost:5173`，使用 `demo / demo123` 登录。
2. 进入「添加宠物」页（`/onboarding`）：
   - 点击头像区的「上传」格子；
   - 选择一张 JPG/PNG/WebP；
   - 预期：上传中遮罩出现，随后该格子显示图片预览 + 对勾，按钮变为「重新上传头像」，提示行出现「移除上传的图片」；
   - 打开浏览器 DevTools → Elements，确认 `img.src` 指向 `https://fur-guardian.oss-cn-beijing.aliyuncs.com/pet-avatar/...`。
3. 进入「宠物档案」页（`/pets/{id}/profile`）：
   - 重复上传操作；
   - 预期同上；确认预览正常后可不点击「保存修改」，避免改动演示数据。
4. 点击「移除上传的图片」，预期恢复为预设头像网格、「上传」格子重新出现。

本次实现已在 2026-10-21 完成上述端到端验证：

- 添加宠物页上传成功，页面渲染的图片 URL 为 OSS 直链；
- 宠物档案页上传成功，页面渲染的图片 URL 为 OSS 直链；
- 6MB 文件、`text/plain`、文本伪装 PNG 三种负向用例均返回对应 400 文案；
- 后端 `./mvnw -DskipTests package` 构建成功；
- 前端 `npx vue-tsc --noEmit` 通过。

---

## 10. 部署注意事项

1. **Nginx / 网关请求体限制**
   Spring 的限制是 5MB/6MB，但反向代理可能更早拦截。Nginx 需要：

   ```nginx
   client_max_body_size 6m;
   ```

   否则会在到达 Spring 之前返回 `413 Request Entity Too Large`。

2. **`application-local.yml` 会被打进 jar**
   它虽然被 `.gitignore` 排除，但位于 `src/main/resources` 下，Maven 默认会把它打进 jar。分发 jar 时注意访问控制；更好的做法是生产环境用环境变量或外部配置目录注入密钥。

3. **不要在仓库、文档、聊天中写入真实 AccessKey**
   本文档所有密钥位置均为占位符。泄露后应立即在 RAM 控制台禁用并轮换。

4. **公有读的含义**
   任何拿到 URL 的人都能访问头像；URL 中的 UUID 不可枚举，但不等于访问控制。不要上传敏感图片。

5. **旧文件保留**
   当前不删除旧头像，OSS 存储会随更换次数增长。可按需配置 Bucket 生命周期规则（例如清理 `pet-avatar/` 下超过 N 天的未引用对象需要额外对账，不能直接按时间删，因为可能仍被引用）。

6. **HTTPS**
   返回的 URL 是 `https://`，页面本身也应是 HTTPS，避免混合内容拦截。

7. **自定义域名**
   使用 CDN/自定义域名时，把域名填入 `aliyun.oss.public-base-url`；确认域名已备案并绑定到该 Bucket，且 CDN 回源配置正确。

8. **数据库长度**
   `pets.avatar` 为 `VARCHAR(255)`。当前 OSS 直链长度约 100 字符，够用；如果换成很长的签名 URL 或自定义域名，需要评估是否需要扩容。

9. **安全校验是服务端权威**
   前端的类型/大小校验只用于即时提示；真正的白名单、magic bytes、大小限制都在 `OssStorageService` 中，绕过前端也无法上传非法文件。

---

## 11. 故障排查

| 现象 | 可能原因 | 处理 |
|---|---|---|
| 启动正常，上传返回 500「图片上传失败」 | AccessKey 错误、RAM 无 `PutObject`、Bucket/Endpoint 不匹配 | 检查 `application-local.yml`；用 RAM 策略模拟器验证权限；确认 endpoint 与 Bucket 地域一致 |
| 上传返回 400「仅支持 JPG、PNG、WebP」 | 浏览器给出的 MIME 不在白名单（如 `image/heic`） | 让用户转成 JPG/PNG/WebP；或按需扩展白名单与 magic bytes |
| 上传返回 400「图片内容与文件格式不符」 | 文件扩展名/MIME 与真实内容不一致 | 用图片工具重新导出，不要只改后缀 |
| 上传返回 400「图片大小不能超过 5MB」 | 文件超限，或 Nginx 限制 | 压缩图片；检查 `max-file-size` / `max-request-size` / `client_max_body_size` |
| 上传成功但图片打不开 | Bucket 不是公共读，或 URL 拼错 | 把 Bucket 改为公共读，或改用签名 URL；检查 `public-base-url` |
| 401 / 跳转登录 | token 失效 | 重新登录；确认请求带 `Authorization` |
| 页面看不到「上传」格子 | 前端未使用新版 `PetAvatarPicker.vue` 或 HMR 未生效 | 重启 `npm run dev`，确认组件已更新 |
| 图片显示但保存后丢失 | 页面未把 `form.avatar` 提交到宠物保存接口 | 检查页面表单字段与后端 `PetCreateDTO/ PetUpdateDTO` 是否包含 `avatar` |

---

## 12. 复刻检查清单

- [ ] Bucket 已创建，地域与 endpoint 一致（本实现：`fur-guardian` / `oss-cn-beijing.aliyuncs.com`）。
- [ ] Bucket 读写权限为「公共读」。
- [ ] RAM 子账号已创建，仅授予 `oss:PutObject` 到 `fur-guardian/pet-avatar/*`。
- [ ] 根 `pom.xml` 已加入 `aliyun-oss.version` 与 `dependencyManagement`。
- [ ] `pet-web/pom.xml` 已加入 `aliyun-sdk-oss` 依赖。
- [ ] 新增 `OssProperties`、`OssConfig`、`OssStorageService`、`AvatarUploadVO`、`UploadController`，包路径与本文一致。
- [ ] `application.yml` 已加入 multipart 限制与 `aliyun.oss` 非密钥配置。
- [ ] `application-local.yml`（或环境变量）已填入真实 AccessKey，且文件未被提交。
- [ ] `GlobalExceptionHandler` 已处理 `MaxUploadSizeExceededException`。
- [ ] 前端已新增 `src/api/upload.ts`。
- [ ] `PetAvatarPicker.vue` 已加入上传格子、文件输入、客户端校验、上传中状态与移除入口。
- [ ] 添加宠物页与档案页均使用 `<PetAvatarPicker v-model="form.avatar" :species="form.species" />`。
- [ ] Nginx `client_max_body_size` ≥ 6m。
- [ ] 已完成 curl 正向/负向验证与浏览器端到端验证。

---

## 附：本次改动与 Git 状态

新增：

```
pet-web/src/main/java/com/purr/furguardian/web/config/OssProperties.java
pet-web/src/main/java/com/purr/furguardian/web/config/OssConfig.java
pet-web/src/main/java/com/purr/furguardian/web/storage/OssStorageService.java
pet-web/src/main/java/com/purr/furguardian/web/dto/upload/AvatarUploadVO.java
pet-web/src/main/java/com/purr/furguardian/web/controller/upload/UploadController.java
fur-guardian-front/src/api/upload.ts
```

修改：

```
pom.xml
pet-web/pom.xml
pet-web/src/main/resources/application.yml
pet-web/src/main/resources/application-local.yml.example
pet-common/src/main/java/com/purr/furguardian/common/exception/GlobalExceptionHandler.java
fur-guardian-front/src/components/PetAvatarPicker.vue
```

本地私有、不提交：

```
pet-web/src/main/resources/application-local.yml   # 含真实 AccessKey，已被 .gitignore 忽略
```
