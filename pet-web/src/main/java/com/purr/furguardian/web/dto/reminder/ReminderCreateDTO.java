package com.purr.furguardian.web.dto.reminder;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalTime;

public class ReminderCreateDTO {

    @NotNull(message = "宠物ID不能为空")
    @Schema(description = "宠物ID", example = "1")
    private Long petId;

    @NotBlank(message = "提醒标题不能为空")
    @Schema(description = "提醒标题", example = "早餐")
    private String title;

    @NotBlank(message = "提醒类型不能为空")
    @Schema(description = "类型: FEED/WALK/WATER/GROOMING/DEWORM/VACCINE/BATH/CUSTOM", example = "FEED")
    private String reminderType;

    @Schema(description = "提醒时间", example = "08:00")
    private LocalTime remindTime;

    @Schema(description = "相对时间(分钟)", example = "30")
    private Integer relativeMin;

    @Schema(description = "重复规则: DAILY/WEEKLY/MONTHLY/YEARLY/ONCE", example = "DAILY")
    private String repeatRule = "DAILY";

    @Schema(description = "重复日: 1,3,5 或 MON,WED,FRI", example = "1,2,3,4,5")
    private String repeatDays;

    public Long getPetId() { return petId; }
    public void setPetId(Long petId) { this.petId = petId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getReminderType() { return reminderType; }
    public void setReminderType(String reminderType) { this.reminderType = reminderType; }
    public LocalTime getRemindTime() { return remindTime; }
    public void setRemindTime(LocalTime remindTime) { this.remindTime = remindTime; }
    public Integer getRelativeMin() { return relativeMin; }
    public void setRelativeMin(Integer relativeMin) { this.relativeMin = relativeMin; }
    public String getRepeatRule() { return repeatRule; }
    public void setRepeatRule(String repeatRule) { this.repeatRule = repeatRule; }
    public String getRepeatDays() { return repeatDays; }
    public void setRepeatDays(String repeatDays) { this.repeatDays = repeatDays; }
}
