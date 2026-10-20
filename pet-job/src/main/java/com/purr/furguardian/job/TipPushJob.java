package com.purr.furguardian.job;

import com.purr.furguardian.ai.service.TipGenerationService;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class TipPushJob {

    private static final Logger log = LoggerFactory.getLogger(TipPushJob.class);

    private final PetMapper petMapper;
    private final TipGenerationService tipGenerationService;

    public TipPushJob(PetMapper petMapper,
                      TipGenerationService tipGenerationService) {
        this.petMapper = petMapper;
        this.tipGenerationService = tipGenerationService;
    }

    @Scheduled(cron = "0 0 7 * * ?")
    public void pushDailyTips() {
        log.info("开始执行每日Tip推送任务...");

        List<PetDO> allPets = petMapper.selectList(null);
        int success = 0;
        int fail = 0;

        for (PetDO pet : allPets) {
            try {
                tipGenerationService.generateTipDirect(pet.getUserId(), pet.getId(), false);
                success++;
                log.info("Tip生成成功: petId={}", pet.getId());
            } catch (Exception e) {
                fail++;
                log.error("Tip生成失败: petId={}, error={}", pet.getId(), e.getMessage());
            }
        }

        log.info("每日Tip推送完成: 成功{}条, 失败{}条", success, fail);
    }
}
