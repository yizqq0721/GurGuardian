package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.mapper.feeding.FeedingLogMapper;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.pet.PetProfileExtMapper;
import com.purr.furguardian.biz.mapper.pet.PetWeightLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderMapper;
import com.purr.furguardian.biz.mapper.report.FeedingPlanMapper;
import com.purr.furguardian.biz.mapper.report.WeeklyReportMapper;
import com.purr.furguardian.biz.mapper.tip.TipMapper;
import org.apache.ibatis.builder.MapperBuilderAssistant;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

class PetServiceImplTest {

    @BeforeAll
    static void initLambdaCache() {
        // LambdaUpdateWrapper 依赖 MyBatis-Plus 的实体元数据缓存，纯单测不会自动注册
        if (TableInfoHelper.getTableInfo(PetDO.class) == null) {
            TableInfoHelper.initTableInfo(
                    new MapperBuilderAssistant(new MybatisConfiguration(), ""), PetDO.class);
        }
    }

    private final PetMapper petMapper = mock(PetMapper.class);
    private final PetWeightLogMapper weightLogMapper = mock(PetWeightLogMapper.class);
    private final PetProfileExtMapper profileExtMapper = mock(PetProfileExtMapper.class);
    private final ReminderMapper reminderMapper = mock(ReminderMapper.class);
    private final ReminderLogMapper reminderLogMapper = mock(ReminderLogMapper.class);
    private final FeedingLogMapper feedingLogMapper = mock(FeedingLogMapper.class);
    private final FeedingPlanMapper feedingPlanMapper = mock(FeedingPlanMapper.class);
    private final WeeklyReportMapper reportMapper = mock(WeeklyReportMapper.class);
    private final TipMapper tipMapper = mock(TipMapper.class);

    private final PetServiceImpl service = new PetServiceImpl(petMapper, weightLogMapper,
            profileExtMapper, reminderMapper, reminderLogMapper, feedingLogMapper,
            feedingPlanMapper, reportMapper, tipMapper);

    private PetDO ownedPet() {
        PetDO pet = new PetDO();
        pet.setId(2L);
        pet.setUserId(1L);
        return pet;
    }

    @Test
    @DisplayName("删除宠物时清理所有关联数据")
    void should_deleteRelatedRows_when_deletingPet() {
        when(petMapper.selectOne(any())).thenReturn(ownedPet());

        service.deletePet(1L, 2L);

        verify(reminderLogMapper).delete(any());
        verify(reminderMapper).delete(any());
        verify(feedingLogMapper).delete(any());
        verify(feedingPlanMapper).delete(any());
        verify(reportMapper).delete(any());
        verify(tipMapper).delete(any());
        verify(profileExtMapper).delete(any());
        verify(weightLogMapper).delete(any());
        verify(petMapper).deleteById(2L);
    }

    @Test
    @DisplayName("更新宠物时显式写入可空字段，支持清空品种/头像/生日")
    void should_updateWithExplicitSet_when_updatingPet() {
        when(petMapper.selectOne(any())).thenReturn(ownedPet());
        PetDO update = new PetDO();
        update.setName("豆豆");
        update.setSpecies("dog");
        update.setSex("male");
        update.setNeutered(0);
        update.setActivityLevel("MODERATE");
        update.setBcs(5);
        update.setPhysiology("NORMAL");

        service.updatePet(1L, 2L, update);

        verify(petMapper).update(isNull(), any());
        verify(petMapper, never()).updateById(any(PetDO.class));
    }
}
