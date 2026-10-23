package com.purr.furguardian.web.controller.feeding;

import com.purr.furguardian.biz.entity.feeding.FeedingLogDO;
import com.purr.furguardian.biz.service.FeedingLogService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.feeding.FeedingLogCreateDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/feeding")
@Tag(name = "喂养记录")
public class FeedingLogController {

    private final FeedingLogService feedingLogService;

    public FeedingLogController(FeedingLogService feedingLogService) {
        this.feedingLogService = feedingLogService;
    }

    @PostMapping
    @Operation(summary = "记录一次喂食")
    public Result<Long> create(@RequestBody @Valid FeedingLogCreateDTO dto) {
        FeedingLogDO log = new FeedingLogDO();
        log.setPetId(dto.getPetId());
        log.setFoodId(dto.getFoodId());
        log.setGrams(dto.getGrams());
        log.setFedDate(dto.getFedDate());
        log.setMealIndex(dto.getMealIndex());
        return Result.ok(feedingLogService.createLog(UserContext.getUserId(), log));
    }

    @GetMapping("/list")
    @Operation(summary = "喂食记录列表")
    public Result<List<FeedingLogDO>> list(
            @RequestParam(required = false) Long petId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.ok(feedingLogService.listLogs(UserContext.getUserId(), petId, startDate, endDate));
    }
}
