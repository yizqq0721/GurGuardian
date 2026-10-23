package com.purr.furguardian.biz.service;

import com.purr.furguardian.biz.entity.feeding.FeedingLogDO;

import java.time.LocalDate;
import java.util.List;

public interface FeedingLogService {

    Long createLog(Long userId, FeedingLogDO log);

    List<FeedingLogDO> listLogs(Long userId, Long petId, LocalDate startDate, LocalDate endDate);
}
