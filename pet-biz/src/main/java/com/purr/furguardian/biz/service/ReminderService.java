package com.purr.furguardian.biz.service;

import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.entity.reminder.ReminderLogDO;

import java.time.LocalDate;
import java.util.List;

public interface ReminderService {

    Long createReminder(Long userId, ReminderDO reminder);

    void updateReminder(Long userId, Long reminderId, ReminderDO reminder);

    void deleteReminder(Long userId, Long reminderId);

    List<ReminderDO> listReminders(Long userId, Long petId);

    void checkIn(Long userId, Long reminderId, LocalDate doneDate, String note);

    List<ReminderLogDO> getLogs(Long userId, Long petId, LocalDate startDate, LocalDate endDate);
}
