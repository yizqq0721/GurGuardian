package com.purr.furguardian.biz.schedule;

import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ReminderScheduleTest {

    private ReminderDO reminder(String rule, LocalDate remindDate, String repeatDays) {
        ReminderDO reminder = new ReminderDO();
        reminder.setRepeatRule(rule);
        reminder.setRemindDate(remindDate);
        reminder.setRepeatDays(repeatDays);
        return reminder;
    }

    @Test
    @DisplayName("仅一次提醒只在指定日期到期")
    void onceIsDueOnlyOnItsDate() {
        ReminderDO reminder = reminder("ONCE", LocalDate.of(2026, 10, 23), null);
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 23)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 24)));
    }

    @Test
    @DisplayName("历史 ONCE 数据缺日期时保持每天可见")
    void onceWithoutDateFailsOpen() {
        assertTrue(ReminderSchedule.isDueOn(reminder("ONCE", null, null), LocalDate.of(2026, 10, 23)));
    }

    @Test
    @DisplayName("每周提醒只在勾选的星期到期")
    void weeklyMatchesSelectedWeekday() {
        ReminderDO reminder = reminder("WEEKLY", null, "1,3");
        // 2026-10-19 是周一，2026-10-21 是周三，2026-10-23 是周五
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 19)));
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 21)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 23)));
    }

    @Test
    @DisplayName("每周提醒未勾选星期时每天到期")
    void weeklyWithoutDaysIsDueEveryDay() {
        assertTrue(ReminderSchedule.isDueOn(reminder("WEEKLY", null, null), LocalDate.of(2026, 10, 23)));
    }

    @Test
    @DisplayName("每周提醒的星期配置全是脏数据时不隐藏提醒")
    void weeklyWithInvalidDaysFailsOpen() {
        assertTrue(ReminderSchedule.isDueOn(reminder("WEEKLY", null, "a,9,0"), LocalDate.of(2026, 10, 23)));
    }

    @Test
    @DisplayName("每月提醒只在锚点日到期，不再每天触发")
    void monthlyIsDueOnAnchorDay() {
        ReminderDO reminder = reminder("MONTHLY", LocalDate.of(2026, 9, 15), null);
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 15)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 16)));
    }

    @Test
    @DisplayName("每月 31 号在短月份落到月末")
    void monthlyFallsOnLastDayOfShorterMonth() {
        ReminderDO reminder = reminder("MONTHLY", LocalDate.of(2026, 1, 31), null);
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 2, 28)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 2, 27)));
    }

    @Test
    @DisplayName("每月提醒没有 remindDate 时用创建日期作锚点")
    void monthlyUsesCreatedAtWhenDateMissing() {
        ReminderDO reminder = reminder("MONTHLY", null, null);
        reminder.setCreatedAt(LocalDateTime.of(2026, 3, 10, 8, 30));
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 10)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2026, 10, 11)));
    }

    @Test
    @DisplayName("每年提醒只在锚点月日到期")
    void yearlyIsDueOnAnchorMonthAndDay() {
        ReminderDO reminder = reminder("YEARLY", LocalDate.of(2026, 5, 20), null);
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2027, 5, 20)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2027, 6, 20)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2027, 5, 21)));
    }

    @Test
    @DisplayName("2 月 29 日的年度提醒在平年落到 2 月 28 日")
    void yearlyLeapDayFallsOnFeb28InCommonYear() {
        ReminderDO reminder = reminder("YEARLY", LocalDate.of(2024, 2, 29), null);
        assertTrue(ReminderSchedule.isDueOn(reminder, LocalDate.of(2027, 2, 28)));
        assertFalse(ReminderSchedule.isDueOn(reminder, LocalDate.of(2027, 3, 1)));
    }

    @Test
    @DisplayName("每日提醒与未知规则每天都到期")
    void dailyAndUnknownRulesAreDueEveryDay() {
        assertTrue(ReminderSchedule.isDueOn(reminder("DAILY", null, null), LocalDate.of(2026, 10, 23)));
        assertTrue(ReminderSchedule.isDueOn(reminder(null, null, null), LocalDate.of(2026, 10, 23)));
        assertTrue(ReminderSchedule.isDueOn(reminder("WHATEVER", null, null), LocalDate.of(2026, 10, 23)));
    }
}
