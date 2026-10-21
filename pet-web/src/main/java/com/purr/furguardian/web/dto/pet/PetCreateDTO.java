package com.purr.furguardian.web.dto.pet;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

import java.time.LocalDate;

public class PetCreateDTO {

    @NotBlank(message = "宠物昵称不能为空")
    @Schema(description = "宠物昵称", example = "豆豆")
    private String name;

    @NotBlank(message = "物种不能为空")
    @Schema(description = "物种: dog/cat", example = "dog")
    private String species;

    @Schema(description = "品种", example = "玩具贵宾")
    private String breed;

    @Schema(description = "宠物头像标识", example = "萌犬肖像集2-01.png")
    private String avatar;

    @NotBlank(message = "性别不能为空")
    @Schema(description = "性别: male/female", example = "male")
    private String sex;

    @Schema(description = "是否绝育", example = "true")
    private Boolean neutered = false;

    @Schema(description = "出生日期", example = "2023-10-01")
    private LocalDate birthday;

    @Schema(description = "活动量: SEDENTARY/LOW/MODERATE/HIGH/WORKING", example = "LOW")
    private String activityLevel = "MODERATE";

    @Min(1) @Max(9)
    @Schema(description = "体况评分1-9", example = "5")
    private Integer bcs = 5;

    @Schema(description = "生理状态: NORMAL/PREGNANT/LACTATING", example = "NORMAL")
    private String physiology = "NORMAL";

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }
    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    public String getSex() { return sex; }
    public void setSex(String sex) { this.sex = sex; }
    public Boolean getNeutered() { return neutered; }
    public void setNeutered(Boolean neutered) { this.neutered = neutered; }
    public LocalDate getBirthday() { return birthday; }
    public void setBirthday(LocalDate birthday) { this.birthday = birthday; }
    public String getActivityLevel() { return activityLevel; }
    public void setActivityLevel(String activityLevel) { this.activityLevel = activityLevel; }
    public Integer getBcs() { return bcs; }
    public void setBcs(Integer bcs) { this.bcs = bcs; }
    public String getPhysiology() { return physiology; }
    public void setPhysiology(String physiology) { this.physiology = physiology; }
}
