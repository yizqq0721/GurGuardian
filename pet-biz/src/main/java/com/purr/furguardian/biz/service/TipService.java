package com.purr.furguardian.biz.service;

import com.purr.furguardian.biz.entity.tip.TipDO;

import java.time.LocalDate;
import java.util.List;

public interface TipService {

    void saveTip(TipDO tip);

    TipDO getTodayTip(Long userId, Long petId, LocalDate date);

    List<TipDO> listTips(Long userId, Long petId, int limit);

    void updateFeedback(Long userId, Long tipId, String feedback);
}
