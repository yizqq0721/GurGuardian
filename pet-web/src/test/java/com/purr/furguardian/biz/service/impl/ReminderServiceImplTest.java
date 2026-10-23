package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.mapper.reminder.ReminderLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderMapper;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.apache.ibatis.builder.MapperBuilderAssistant;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InOrder;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class ReminderServiceImplTest {

    @BeforeAll
    static void initLambdaCache() {
        // LambdaUpdateWrapper 依赖 MyBatis-Plus 的实体元数据缓存，纯单测不会自动注册
        if (TableInfoHelper.getTableInfo(ReminderDO.class) == null) {
            TableInfoHelper.initTableInfo(
                    new MapperBuilderAssistant(new MybatisConfiguration(), ""), ReminderDO.class);
        }
    }

    private final ReminderMapper reminderMapper = mock(ReminderMapper.class);
    private final ReminderLogMapper logMapper = mock(ReminderLogMapper.class);
    private final PetService petService = mock(PetService.class);
    private final ReminderServiceImpl service = new ReminderServiceImpl(reminderMapper, logMapper, petService);

    private ReminderDO reminder() {
        ReminderDO reminder = new ReminderDO();
        reminder.setPetId(2L);
        reminder.setTitle("喂药");
        reminder.setReminderType("FEED");
        reminder.setRepeatRule("DAILY");
        return reminder;
    }

    @Test
    @DisplayName("创建提醒时必须选择宠物")
    void should_rejectCreate_when_petIdMissing() {
        ReminderDO reminder = reminder();
        reminder.setPetId(null);

        BizException ex = assertThrows(BizException.class,
                () -> service.createReminder(9L, reminder));

        assertEquals(ErrorCode.BAD_REQUEST.getCode(), ex.getCode());
        verifyNoInteractions(reminderMapper);
    }

    @Test
    @DisplayName("不能用别人的 petId 创建提醒")
    void should_rejectCreate_when_petNotOwned() {
        when(petService.getPet(9L, 2L))
                .thenThrow(new BizException(ErrorCode.DATA_NOT_FOUND, "宠物不存在"));

        BizException ex = assertThrows(BizException.class,
                () -> service.createReminder(9L, reminder()));

        assertEquals(ErrorCode.DATA_NOT_FOUND.getCode(), ex.getCode());
        verifyNoInteractions(reminderMapper);
    }

    @Test
    @DisplayName("更新提醒时同样校验宠物归属")
    void should_rejectUpdate_when_petNotOwned() {
        ReminderDO existing = reminder();
        existing.setId(5L);
        existing.setUserId(9L);
        existing.setCreatedAt(LocalDateTime.now());
        when(reminderMapper.selectOne(any())).thenReturn(existing);
        when(petService.getPet(9L, 2L))
                .thenThrow(new BizException(ErrorCode.DATA_NOT_FOUND, "宠物不存在"));

        BizException ex = assertThrows(BizException.class,
                () -> service.updateReminder(9L, 5L, reminder()));

        assertEquals(ErrorCode.DATA_NOT_FOUND.getCode(), ex.getCode());
        verify(reminderMapper, never()).update(any(), any());
    }

    @Test
    @DisplayName("删除提醒时先清理打卡记录")
    void should_deleteLogsBeforeReminder_when_deleting() {
        ReminderDO existing = reminder();
        existing.setId(5L);
        existing.setUserId(9L);
        when(reminderMapper.selectOne(any())).thenReturn(existing);

        service.deleteReminder(9L, 5L);

        InOrder order = inOrder(logMapper, reminderMapper);
        order.verify(logMapper).delete(any());
        order.verify(reminderMapper).deleteById(5L);
    }
}
