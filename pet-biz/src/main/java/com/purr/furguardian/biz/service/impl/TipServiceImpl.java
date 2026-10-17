package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.tip.TipDO;
import com.purr.furguardian.biz.mapper.tip.TipMapper;
import com.purr.furguardian.biz.service.TipService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class TipServiceImpl implements TipService {

    private final TipMapper tipMapper;

    public TipServiceImpl(TipMapper tipMapper) {
        this.tipMapper = tipMapper;
    }

    @Override
    public void saveTip(TipDO tip) {
        tipMapper.insert(tip);
    }

    @Override
    public TipDO getTodayTip(Long userId, Long petId, LocalDate date) {
        LambdaQueryWrapper<TipDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TipDO::getUserId, userId)
               .eq(TipDO::getPetId, petId)
               .eq(TipDO::getTipDate, date)
               .orderByDesc(TipDO::getCreatedAt)
               .last("LIMIT 1");
        return tipMapper.selectOne(wrapper);
    }

    @Override
    public List<TipDO> listTips(Long userId, Long petId, int limit) {
        LambdaQueryWrapper<TipDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TipDO::getUserId, userId)
               .eq(TipDO::getPetId, petId)
               .orderByDesc(TipDO::getTipDate)
               .last("LIMIT " + limit);
        return tipMapper.selectList(wrapper);
    }

    @Override
    public void updateFeedback(Long userId, Long tipId, String feedback) {
        LambdaQueryWrapper<TipDO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TipDO::getId, tipId)
               .eq(TipDO::getUserId, userId);
        TipDO tip = tipMapper.selectOne(wrapper);
        if (tip != null) {
            tip.setFeedback(feedback);
            tipMapper.updateById(tip);
        }
    }
}
