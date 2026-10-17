package com.purr.furguardian.biz.entity.knowledge;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("knowledge_docs")
public class KnowledgeDocDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String content;
    private String species;
    private String lifeStage;
    private String breedTags;
    private String topics;
    private String severity;
    private String sourceName;
    private String sourceType;
    private String sourceUrl;
    private String reviewStatus;
    private String embeddingId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }
    public String getLifeStage() { return lifeStage; }
    public void setLifeStage(String lifeStage) { this.lifeStage = lifeStage; }
    public String getBreedTags() { return breedTags; }
    public void setBreedTags(String breedTags) { this.breedTags = breedTags; }
    public String getTopics() { return topics; }
    public void setTopics(String topics) { this.topics = topics; }
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    public String getSourceName() { return sourceName; }
    public void setSourceName(String sourceName) { this.sourceName = sourceName; }
    public String getSourceType() { return sourceType; }
    public void setSourceType(String sourceType) { this.sourceType = sourceType; }
    public String getSourceUrl() { return sourceUrl; }
    public void setSourceUrl(String sourceUrl) { this.sourceUrl = sourceUrl; }
    public String getReviewStatus() { return reviewStatus; }
    public void setReviewStatus(String reviewStatus) { this.reviewStatus = reviewStatus; }
    public String getEmbeddingId() { return embeddingId; }
    public void setEmbeddingId(String embeddingId) { this.embeddingId = embeddingId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
