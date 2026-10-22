package com.purr.furguardian.web.controller.reminder;

import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.entity.reminder.ReminderLogDO;
import com.purr.furguardian.biz.service.ReminderService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.reminder.CheckInDTO;
import com.purr.furguardian.web.dto.reminder.ReminderCreateDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/reminder")
@Tag(name = "提醒管理")
public class ReminderController {

    private final ReminderService reminderService;

    public ReminderController(ReminderService reminderService) {
        this.reminderService = reminderService;
    }

    @PostMapping
    @Operation(summary = "创建提醒")
    public Result<Long> create(@RequestBody @Valid ReminderCreateDTO dto) {
        ReminderDO reminder = toEntity(dto);
        Long id = reminderService.createReminder(UserContext.getUserId(), reminder);
        return Result.ok(id);
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新提醒")
    public Result<Void> update(@PathVariable Long id, @RequestBody @Valid ReminderCreateDTO dto) {
        ReminderDO reminder = toEntity(dto);
        reminderService.updateReminder(UserContext.getUserId(), id, reminder);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除提醒")
    public Result<Void> delete(@PathVariable Long id) {
        reminderService.deleteReminder(UserContext.getUserId(), id);
        return Result.ok();
    }

    @GetMapping("/list")
    @Operation(summary = "提醒列表")
    public Result<List<ReminderDO>> list(@RequestParam(required = false) Long petId) {
        return Result.ok(reminderService.listReminders(UserContext.getUserId(), petId));
    }

    @PostMapping("/{id}/checkin")
    @Operation(summary = "打卡")
    public Result<Void> checkIn(@PathVariable Long id, @RequestBody CheckInDTO dto) {
        reminderService.checkIn(UserContext.getUserId(), id, dto.getDoneDate(), dto.getNote());
        return Result.ok();
    }

    @GetMapping("/logs")
    @Operation(summary = "打卡记录")
    public Result<List<ReminderLogDO>> logs(
            @RequestParam Long petId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.ok(reminderService.getLogs(UserContext.getUserId(), petId, startDate, endDate));
    }

    private ReminderDO toEntity(ReminderCreateDTO dto) {
        ReminderDO reminder = new ReminderDO();
        reminder.setPetId(dto.getPetId());
        reminder.setTitle(dto.getTitle());
        reminder.setReminderType(dto.getReminderType());
        reminder.setRemindTime(dto.getRemindTime());
        reminder.setRelativeMin(dto.getRelativeMin());
        reminder.setRemindDate(dto.getRemindDate());
        reminder.setRepeatRule(dto.getRepeatRule());
        reminder.setRepeatDays(dto.getRepeatDays());
        reminder.setEnabled(1);
        return reminder;
    }
}
