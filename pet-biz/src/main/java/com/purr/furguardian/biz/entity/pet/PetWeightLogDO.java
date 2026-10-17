package com.purr.furguardian.biz.entity.pet;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("pet_weight_logs")
public class PetWeightLogDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long petId;
    private Long userId;
    private BigDecimal weightKg;
    private Integer bcs;
    private LocalDate recordedAt;
    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public BigDecimal getWeightKg() { return weightKg; }
    public void setWeightKg(BigDecimal weightKg) { this.weightKg = weightKg; }
    public Integer getBcs() { return bcs; }
    public void setBcs(Integer bcs) { this.bcs = bcs; }
    public LocalDate getRecordedAt() { return recordedAt; }
    public void setRecordedAt(LocalDate recordedAt) { this.recordedAt = recordedAt; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
