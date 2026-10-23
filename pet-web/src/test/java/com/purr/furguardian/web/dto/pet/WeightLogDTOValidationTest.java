package com.purr.furguardian.web.dto.pet;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class WeightLogDTOValidationTest {

    private final Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

    private WeightLogDTO valid() {
        WeightLogDTO dto = new WeightLogDTO();
        dto.setWeightKg(new BigDecimal("5.0"));
        dto.setBcs(5);
        dto.setRecordedAt(LocalDate.now());
        return dto;
    }

    private Set<ConstraintViolation<WeightLogDTO>> violations(WeightLogDTO dto) {
        return validator.validate(dto);
    }

    @Test
    @DisplayName("合法体重记录通过校验")
    void should_pass_when_valid() {
        assertTrue(violations(valid()).isEmpty());
    }

    @Test
    @DisplayName("体重不能为空")
    void should_fail_when_weightMissing() {
        WeightLogDTO dto = valid();
        dto.setWeightKg(null);
        assertEquals(1, violations(dto).size());
    }

    @Test
    @DisplayName("体重必须大于 0.1kg 且不超过 500kg")
    void should_fail_when_weightOutOfRange() {
        WeightLogDTO tooSmall = valid();
        tooSmall.setWeightKg(new BigDecimal("0.05"));
        assertEquals(1, violations(tooSmall).size());

        WeightLogDTO tooLarge = valid();
        tooLarge.setWeightKg(new BigDecimal("500.5"));
        assertEquals(1, violations(tooLarge).size());
    }

    @Test
    @DisplayName("体重最多保留两位小数")
    void should_fail_when_weightHasTooManyDecimals() {
        WeightLogDTO dto = valid();
        dto.setWeightKg(new BigDecimal("5.123"));
        assertEquals(1, violations(dto).size());
    }

    @Test
    @DisplayName("体况评分必须在 1-9 之间")
    void should_fail_when_bcsOutOfRange() {
        WeightLogDTO dto = valid();
        dto.setBcs(10);
        assertEquals(1, violations(dto).size());
    }

    @Test
    @DisplayName("记录日期不能晚于今天")
    void should_fail_when_recordedAtInFuture() {
        WeightLogDTO dto = valid();
        dto.setRecordedAt(LocalDate.now().plusDays(1));
        assertEquals(1, violations(dto).size());
    }
}
