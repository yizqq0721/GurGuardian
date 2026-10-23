package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.PetWeightLogDO;
import com.purr.furguardian.biz.entity.report.WeeklyReportDO;
import com.purr.furguardian.biz.mapper.pet.PetWeightLogMapper;
import com.purr.furguardian.biz.mapper.report.WeeklyReportMapper;
import com.purr.furguardian.biz.service.PetService;
import org.apache.ibatis.builder.MapperBuilderAssistant;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import tools.jackson.databind.ObjectMapper;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

class ReportServiceImplTest {

    @BeforeAll
    static void initLambdaCache() {
        // LambdaUpdateWrapper 依赖 MyBatis-Plus 的实体元数据缓存，纯单测不会自动注册
        if (TableInfoHelper.getTableInfo(WeeklyReportDO.class) == null) {
            TableInfoHelper.initTableInfo(
                    new MapperBuilderAssistant(new MybatisConfiguration(), ""), WeeklyReportDO.class);
        }
    }

    private final PetService petService = mock(PetService.class);
    private final PetWeightLogMapper weightLogMapper = mock(PetWeightLogMapper.class);
    private final WeeklyReportMapper reportMapper = mock(WeeklyReportMapper.class);
    private final ObjectMapper objectMapper = mock(ObjectMapper.class);
    private final ReportServiceImpl service =
            new ReportServiceImpl(petService, weightLogMapper, reportMapper, objectMapper);

    private final LocalDate weekStart = LocalDate.of(2026, 10, 19);

    @BeforeEach
    void setUp() {
        when(objectMapper.writeValueAsString(any())).thenReturn("{}");
        PetDO pet = new PetDO();
        pet.setId(2L);
        pet.setUserId(1L);
        pet.setBirthday(LocalDate.of(2023, 1, 1));
        when(petService.getPet(1L, 2L)).thenReturn(pet);
    }

    @Test
    @DisplayName("首次生成周报时插入记录")
    void should_insert_when_reportDoesNotExist() {
        when(weightLogMapper.selectList(any())).thenReturn(List.of());
        when(reportMapper.selectOne(any())).thenReturn(null);

        WeeklyReportDO report = service.generateWeeklyReport(1L, 2L, weekStart);

        assertEquals(2L, report.getPetId());
        verify(reportMapper).insert(report);
        verify(reportMapper, never()).update(any(), any());
    }

    @Test
    @DisplayName("同一周重复生成时更新原记录，不再插入新行")
    void should_update_when_reportAlreadyExists() {
        when(weightLogMapper.selectList(any())).thenReturn(List.of());

        WeeklyReportDO existing = new WeeklyReportDO();
        existing.setId(99L);
        existing.setCreatedAt(LocalDateTime.of(2026, 10, 20, 8, 0));
        when(reportMapper.selectOne(any())).thenReturn(existing);

        WeeklyReportDO report = service.generateWeeklyReport(1L, 2L, weekStart);

        assertEquals(99L, report.getId());
        assertEquals(existing.getCreatedAt(), report.getCreatedAt());
        verify(reportMapper, never()).insert(any(WeeklyReportDO.class));
        verify(reportMapper).update(isNull(), any());
    }

    @Test
    @DisplayName("本周没有称重时允许把旧指标清空")
    void should_keepNullMetrics_when_noWeightThisWeek() {
        when(weightLogMapper.selectList(any())).thenReturn(List.of());
        when(reportMapper.selectOne(any())).thenReturn(null);

        WeeklyReportDO report = service.generateWeeklyReport(1L, 2L, weekStart);

        assertNull(report.getWeightEndKg());
        assertNull(report.getWeightChangePct());
        verify(reportMapper).insert(report);
    }

    @Test
    @DisplayName("有称重记录时计算环比变化")
    void should_calculateWeightChange_when_weightsPresent() {
        PetWeightLogDO previous = weight(4.0);
        PetWeightLogDO current = weight(4.4);
        // 第一次查询本周体重，第二次查询上一周作为基线
        when(weightLogMapper.selectList(any())).thenReturn(List.of(current), List.of(previous));
        when(reportMapper.selectOne(any())).thenReturn(null);

        WeeklyReportDO report = service.generateWeeklyReport(1L, 2L, weekStart);

        assertEquals(0, new BigDecimal("4.0").compareTo(report.getWeightStartKg()));
        assertEquals(0, new BigDecimal("4.4").compareTo(report.getWeightEndKg()));
        assertEquals(0, new BigDecimal("10.00").compareTo(report.getWeightChangePct()));
    }

    private PetWeightLogDO weight(double kg) {
        PetWeightLogDO log = new PetWeightLogDO();
        log.setWeightKg(BigDecimal.valueOf(kg));
        log.setBcs(5);
        log.setRecordedAt(weekStart);
        return log;
    }
}
