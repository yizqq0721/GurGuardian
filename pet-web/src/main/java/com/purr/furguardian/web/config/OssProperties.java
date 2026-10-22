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
