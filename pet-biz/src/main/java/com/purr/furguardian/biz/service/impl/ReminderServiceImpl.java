package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.entity.reminder.ReminderLogDO;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderMapper;
import com.purr.furguardian.biz.service.ReminderService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Service
public class ReminderServiceImpl implements ReminderService {

    private final ReminderMapper reminderMapper;
    private final ReminderLogMapper logMapper;
    private final PetMapper petMapper;

    public ReminderServiceImpl(ReminderMapper reminderMapper, ReminderLogMapper logMapper, PetMapper petMapper) {
        this.reminderMapper = reminderMapper;
        this.logMapper = logMapper;
        this.petMapper = petMapper;
    }

    @Override
    public Long createReminder(Long userId, ReminderDO reminder) {
        reminder.setId(null);
        reminder.setUserId(userId);
        reminder.setCreatedAt(LocalDateTime.now());
        reminder.setUpdatedAt(LocalDateTime.now());
        reminderMapper.insert(reminder);
        return reminder.getId();
    }

    @Override
    public void updateReminder(Long userId, Long reminderId, ReminderDO reminder) {
        ReminderDO existing = getReminder(userId, reminderId);
        reminder.setId(reminderId);
        reminder.setUserId(userId);
        reminder.setUpdatedAt(LocalDateTime.now());
        reminderMapper.updateById(reminder);
    }

    @Override
    public void deleteReminder(Long userId, Long reminderId) {
        getReminder(userId, reminderId);
        reminderMapper.deleteById(reminderId);
    }

    @Override
    public List<ReminderDO> listReminders(Long userId, Long petId) {
        LambdaQueryWrapper<ReminderDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ReminderDO::getUserId, userId);
        if (petId != null) {
            wrapper.eq(ReminderDO::getPetId, petId);
        }
        wrapper.eq(ReminderDO::getEnabled, 1).orderByAsc(ReminderDO::getRemindTime);
        return reminderMapper.selectList(wrapper);
    }

    @Override
    public void checkIn(Long userId, Long reminderId, LocalDate doneDate, String note) {
        ReminderDO reminder = getReminder(userId, reminderId);
        ReminderLogDO log = new ReminderLogDO();
        log.setReminderId(reminderId);
        log.setPetId(reminder.getPetId());
        log.setUserId(userId);
        log.setDoneDate(doneDate != null ? doneDate : LocalDate.now());
        log.setDoneTime(LocalTime.now());
        log.setNote(note);
        log.setCreatedAt(LocalDateTime.now());
        logMapper.insert(log);
    }

    @Override
    public List<ReminderLogDO> getLogs(Long userId, Long petId, LocalDate startDate, LocalDate endDate) {
        LambdaQueryWrapper<ReminderLogDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ReminderLogDO::getUserId, userId)
                .eq(ReminderLogDO::getPetId, petId)
                .ge(startDate != null, ReminderLogDO::getDoneDate, startDate)
                .le(endDate != null, ReminderLogDO::getDoneDate, endDate)
                .orderByDesc(ReminderLogDO::getDoneDate);
        return logMapper.selectList(wrapper);
    }

    private ReminderDO getReminder(Long userId, Long reminderId) {
        LambdaQueryWrapper<ReminderDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ReminderDO::getId, reminderId).eq(ReminderDO::getUserId, userId);
        ReminderDO reminder = reminderMapper.selectOne(wrapper);
        if (reminder == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "提醒不存在");
        }
        return reminder;
    }
}
