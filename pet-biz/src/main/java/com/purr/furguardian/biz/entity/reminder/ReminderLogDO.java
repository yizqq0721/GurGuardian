package com.purr.furguardian.biz.entity.reminder;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@TableName("reminder_logs")
public class ReminderLogDO {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long reminderId;
    private Long petId;
    private Long userId;
    private LocalDate doneDate;
    private LocalTime doneTime;
    private String note;
    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getReminderId() { return reminderId; }
    public void setReminderId(Long reminderId) { this.reminderId = reminderId; }
    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public LocalDate getDoneDate() { return doneDate; }
    public void setDoneDate(LocalDate doneDate) { this.doneDate = doneDate; }
    public LocalTime getDoneTime() { return doneTime; }
    public void setDoneTime(LocalTime doneTime) { this.doneTime = doneTime; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
