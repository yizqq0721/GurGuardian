package com.purr.furguardian.biz.schedule;

import com.purr.furguardian.biz.entity.reminder.ReminderDO;

import java.time.LocalDate;
import java.util.Locale;

/** 提醒是否落在指定日期：邮件扫描与前端站内通知共用同一套周期语义。 */
public final class ReminderSchedule {

    private ReminderSchedule() {
    }

    public static boolean isDueOn(ReminderDO reminder, LocalDate today) {
        if (reminder == null || today == null) {
            return false;
        }
        String rule = reminder.getRepeatRule() == null
                ? "" : reminder.getRepeatRule().trim().toUpperCase(Locale.ROOT);
        return switch (rule) {
            case "ONCE" -> reminder.getRemindDate() == null || reminder.getRemindDate().equals(today);
            case "WEEKLY" -> weeklyDue(reminder.getRepeatDays(), today);
            case "MONTHLY" -> monthlyDue(reminder, today);
            case "YEARLY" -> yearlyDue(reminder, today);
            default -> true;
        };
    }

    private static boolean weeklyDue(String repeatDays, LocalDate today) {
        if (repeatDays == null || repeatDays.isBlank()) {
            return true;
        }
        int weekday = today.getDayOfWeek().getValue();
        boolean hasValidDay = false;
        for (String part : repeatDays.split(",")) {
            try {
                int day = Integer.parseInt(part.trim());
                if (day >= 1 && day <= 7) {
                    hasValidDay = true;
                    if (day == weekday) {
                        return true;
                    }
                }
            } catch (NumberFormatException ignored) {
                // 单个格式错误的值跳过，不影响其它重复日
            }
        }
        // 配置全是脏数据时按「每天」处理，宁可多提醒也不要静默漏掉
        return !hasValidDay;
    }

    /** 月度没有独立的「几号」字段，用提醒日期（或创建日期）的日作为锚点 */
    private static boolean monthlyDue(ReminderDO reminder, LocalDate today) {
        LocalDate anchor = anchorOf(reminder);
        if (anchor == null) {
            return true;
        }
        return today.getDayOfMonth() == Math.min(anchor.getDayOfMonth(), today.lengthOfMonth());
    }

    private static boolean yearlyDue(ReminderDO reminder, LocalDate today) {
        LocalDate anchor = anchorOf(reminder);
        if (anchor == null) {
            return true;
        }
        if (anchor.getMonthValue() != today.getMonthValue()) {
            return false;
        }
        return today.getDayOfMonth() == Math.min(anchor.getDayOfMonth(), today.lengthOfMonth());
    }

    private static LocalDate anchorOf(ReminderDO reminder) {
        if (reminder.getRemindDate() != null) {
            return reminder.getRemindDate();
        }
        return reminder.getCreatedAt() != null ? reminder.getCreatedAt().toLocalDate() : null;
    }
}
