package com.purr.furguardian.ai.agent;

import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.service.ReminderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;

/** 用户点「确认」后才走到这里：按服务端保存的计划落库。 */
@Service
public class AgentActionService {

    private static final Logger log = LoggerFactory.getLogger(AgentActionService.class);

    private final AgentPlanStore planStore;
    private final ReminderService reminderService;

    public AgentActionService(AgentPlanStore planStore, ReminderService reminderService) {
        this.planStore = planStore;
        this.reminderService = reminderService;
    }

    public AgentPlanStore.Confirmed confirmReminder(Long userId, String token) {
        AgentPlanStore.Confirmed confirmed = planStore.confirm(token, userId, plan -> {
            ReminderDO reminder = new ReminderDO();
            reminder.setPetId(plan.petId());
            reminder.setTitle(plan.title());
            reminder.setReminderType(plan.reminderType());
            reminder.setRemindTime(LocalTime.parse(plan.remindTime()));
            reminder.setRemindDate(plan.remindDate() == null ? null : LocalDate.parse(plan.remindDate()));
            reminder.setRepeatRule(plan.repeatRule());
            reminder.setRepeatDays(plan.repeatDays());
            reminder.setEnabled(1);
            return reminderService.createReminder(userId, reminder);
        });
        log.info("agent action confirmed userId={} action=reminder.create reminderId={} repeated={} summary=\"{}\"",
                userId, confirmed.reminderId(), confirmed.repeated(), confirmed.summary());
        return confirmed;
    }
}
