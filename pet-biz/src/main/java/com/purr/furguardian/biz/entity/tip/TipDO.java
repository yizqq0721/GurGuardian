package com.purr.furguardian.biz.entity.tip;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("tips")
public class TipDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long petId;
    private Long userId;
    private LocalDate tipDate;
    private String content;
    private Long sourceDocId;
    private String sourceName;
    private String feedback;
    private Integer isMock;
    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public LocalDate getTipDate() { return tipDate; }
    public void setTipDate(LocalDate tipDate) { this.tipDate = tipDate; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Long getSourceDocId() { return sourceDocId; }
    public void setSourceDocId(Long sourceDocId) { this.sourceDocId = sourceDocId; }
    public String getSourceName() { return sourceName; }
    public void setSourceName(String sourceName) { this.sourceName = sourceName; }
    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }
    public Integer getIsMock() { return isMock; }
    public void setIsMock(Integer isMock) { this.isMock = isMock; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
