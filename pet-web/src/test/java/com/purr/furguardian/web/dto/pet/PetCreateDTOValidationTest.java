package com.purr.furguardian.web.dto.pet;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertTrue;

class PetCreateDTOValidationTest {

    private final Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

    private PetCreateDTO valid() {
        PetCreateDTO dto = new PetCreateDTO();
        dto.setName("豆豆");
        dto.setSpecies("dog");
        dto.setSex("male");
        dto.setBirthday(LocalDate.of(2023, 10, 1));
        return dto;
    }

    private Set<ConstraintViolation<PetCreateDTO>> violations(PetCreateDTO dto) {
        return validator.validate(dto);
    }

    @Test
    @DisplayName("合法宠物档案通过校验")
    void should_pass_when_valid() {
        assertTrue(violations(valid()).isEmpty());
    }

    @Test
    @DisplayName("物种只接受 dog/cat")
    void should_fail_when_speciesUnknown() {
        PetCreateDTO dto = valid();
        dto.setSpecies("bird");
        assertTrue(!violations(dto).isEmpty());
    }

    @Test
    @DisplayName("性别只接受 male/female")
    void should_fail_when_sexUnknown() {
        PetCreateDTO dto = valid();
        dto.setSex("other");
        assertTrue(!violations(dto).isEmpty());
    }

    @Test
    @DisplayName("活动量只接受预定义枚举")
    void should_fail_when_activityLevelUnknown() {
        PetCreateDTO dto = valid();
        dto.setActivityLevel("EXTREME");
        assertTrue(!violations(dto).isEmpty());
    }

    @Test
    @DisplayName("生理状态只接受预定义枚举")
    void should_fail_when_physiologyUnknown() {
        PetCreateDTO dto = valid();
        dto.setPhysiology("SICK");
        assertTrue(!violations(dto).isEmpty());
    }

    @Test
    @DisplayName("出生日期不能晚于今天")
    void should_fail_when_birthdayInFuture() {
        PetCreateDTO dto = valid();
        dto.setBirthday(LocalDate.now().plusDays(1));
        assertTrue(!violations(dto).isEmpty());
    }
}
