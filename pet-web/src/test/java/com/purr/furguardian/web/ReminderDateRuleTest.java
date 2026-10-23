package com.purr.furguardian.web;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.mapper.reminder.ReminderLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderMapper;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.biz.service.impl.ReminderServiceImpl;
import com.purr.furguardian.common.exception.BizException;
import org.apache.ibatis.builder.MapperBuilderAssistant;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

class ReminderDateRuleTest {

    @BeforeAll
    static void initLambdaCache() {
        // LambdaUpdateWrapper 依赖 MyBatis-Plus 的实体元数据缓存，纯单测不会自动注册
        if (TableInfoHelper.getTableInfo(ReminderDO.class) == null) {
            TableInfoHelper.initTableInfo(
                    new MapperBuilderAssistant(new MybatisConfiguration(), ""), ReminderDO.class);
        }
    }

    private final ReminderMapper reminderMapper = mock(ReminderMapper.class);
    private final PetService petService = mock(PetService.class);
    private final ReminderServiceImpl service =
            new ReminderServiceImpl(reminderMapper, mock(ReminderLogMapper.class), petService);

    private ReminderDO reminder(String type, String rule, LocalDate date) {
        ReminderDO reminder = new ReminderDO();
        reminder.setPetId(1L);
        reminder.setTitle("t");
        reminder.setReminderType(type);
        reminder.setRepeatRule(rule);
        reminder.setRepeatDays("1,3");
        reminder.setRemindDate(date);
        return reminder;
    }

    @Test
    void vaccineWithoutDateIsRejected() {
        BizException ex = assertThrows(BizException.class,
                () -> service.createReminder(9L, reminder("VACCINE", "YEARLY", null)));
        assertEquals(400, ex.getCode());
        assertEquals("请先选择提醒日期", ex.getMessage());
        verifyNoInteractions(reminderMapper);
    }

    @Test
    void dewormIgnoresRotationAndForcesOnce() {
        ReminderDO r = reminder("DEWORM", "MONTHLY", LocalDate.of(2026, 11, 5));
        when(reminderMapper.insert(r)).thenReturn(1);
        service.createReminder(9L, r);
        assertEquals("ONCE", r.getRepeatRule());
        assertNull(r.getRepeatDays());
        assertEquals(LocalDate.of(2026, 11, 5), r.getRemindDate());
        verify(reminderMapper).insert(r);
        verify(petService).getPet(9L, 1L);
    }

    @Test
    void onceWithoutDateIsRejectedForRegularType() {
        BizException ex = assertThrows(BizException.class,
                () -> service.createReminder(9L, reminder("FEED", "ONCE", null)));
        assertEquals(400, ex.getCode());
        verifyNoInteractions(reminderMapper);
    }

    @Test
    void dailyReminderKeepsRotationAndNeedsNoDate() {
        ReminderDO r = reminder("FEED", "DAILY", null);
        r.setRepeatDays(null);
        when(reminderMapper.insert(r)).thenReturn(1);
        service.createReminder(9L, r);
        assertEquals("DAILY", r.getRepeatRule());
        assertNull(r.getRemindDate());
        verify(reminderMapper).insert(r);
    }

    @Test
    void updatingVaccineWithoutDateIsRejectedBeforeLookup() {
        BizException ex = assertThrows(BizException.class,
                () -> service.updateReminder(9L, 5L, reminder("VACCINE", null, null)));
        assertEquals(400, ex.getCode());
        verifyNoInteractions(reminderMapper);
    }

    @Test
    void updatingToDatedOncePersistsDate() {
        ReminderDO existing = reminder("FEED", "DAILY", null);
        existing.setId(5L);
        when(reminderMapper.selectOne(any())).thenReturn(existing);
        ReminderDO r = reminder("FEED", "ONCE", LocalDate.of(2026, 10, 30));
        service.updateReminder(9L, 5L, r);
        assertEquals("ONCE", r.getRepeatRule());
        assertNull(r.getRepeatDays());
        verify(reminderMapper).update(isNull(), any());
        verify(petService).getPet(9L, 1L);
    }
}
