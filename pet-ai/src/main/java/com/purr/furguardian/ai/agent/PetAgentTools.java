package com.purr.furguardian.ai.agent;

import com.purr.furguardian.biz.entity.feeding.FeedingLogDO;
import com.purr.furguardian.biz.entity.knowledge.KnowledgeDocDO;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.PetWeightLogDO;
import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.entity.reminder.ReminderLogDO;
import com.purr.furguardian.biz.service.FeedingLogService;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.biz.service.ReminderService;
import com.purr.furguardian.knowledge.service.KnowledgeRetrievalService;
import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class PetAgentTools {

    private static final DateTimeFormatter DATE = DateTimeFormatter.ofPattern("M月d日");
    private static final DateTimeFormatter TIME = DateTimeFormatter.ofPattern("HH:mm");
    private static final String[] WEEKDAYS = {"一", "二", "三", "四", "五", "六", "日"};
    private static final Map<String, String> TYPE_LABEL = Map.of(
            "FEED", "喂食", "WALK", "遛弯", "WATER", "喂水", "GROOMING", "梳毛",
            "DEWORM", "驱虫", "VACCINE", "疫苗", "BATH", "洗澡", "CUSTOM", "自定义");

    private final PetService petService;
    private final FeedingLogService feedingLogService;
    private final ReminderService reminderService;
    private final KnowledgeRetrievalService retrievalService;

    public PetAgentTools(PetService petService,
                         FeedingLogService feedingLogService,
                         ReminderService reminderService,
                         KnowledgeRetrievalService retrievalService) {
        this.petService = petService;
        this.feedingLogService = feedingLogService;
        this.reminderService = reminderService;
        this.retrievalService = retrievalService;
    }

    @Tool("读取当前宠物的档案：品种、性别、年龄、绝育情况、体况评分BCS、活动量。")
    public String petProfile() {
        return AgentContext.guard("petProfile", "宠物档案", "档案", this::petProfileData);
    }

    private String petProfileData() {
        AgentContext.State ctx = AgentContext.current();
        PetDO pet = petService.getPet(ctx.userId, ctx.petId);
        String age = ageText(pet.getBirthday());
        String bcs = pet.getBcs() == null ? "未记录" : pet.getBcs() + "/9（" + bcsLabel(pet.getBcs()) + "）";
        String text = "宠物档案：" + pet.getName()
                + "，" + speciesLabel(pet.getSpecies())
                + (pet.getBreed() == null || pet.getBreed().isBlank() ? "" : "·" + pet.getBreed())
                + "，性别" + sexLabel(pet.getSex())
                + (pet.getNeutered() != null && pet.getNeutered() == 1 ? "，已绝育" : "")
                + "，年龄" + age
                + "，当前BCS " + bcs
                + (pet.getActivityLevel() == null ? "" : "，活动量" + activityLabel(pet.getActivityLevel()));
        AgentContext.record("petProfile", "宠物档案", pet.getName() + "·" + age);
        return text;
    }

    @Tool("查询当前宠物最近若干天的体重记录：起止体重、变化量、BCS 变化和逐条记录。问体重、胖瘦、长肉或掉秤时使用。")
    public String weightTrend(@P("回溯天数，7 表示最近 7 天") int days) {
        return AgentContext.guard("weightTrend", "体重趋势", "体重", () -> weightTrendData(days));
    }

    private String weightTrendData(int days) {
        AgentContext.State ctx = AgentContext.current();
        int window = clamp(days);
        LocalDate start = LocalDate.now().minusDays(window - 1L);
        List<PetWeightLogDO> all = petService.getWeightHistory(ctx.userId, ctx.petId);
        List<PetWeightLogDO> recent = all.stream()
                .filter(l -> l.getRecordedAt() != null && !l.getRecordedAt().isBefore(start))
                .filter(l -> l.getWeightKg() != null)
                .toList();
        if (recent.isEmpty()) {
            AgentContext.record("weightTrend", "体重趋势", "近" + window + "天无记录");
            return all.isEmpty()
                    ? "近" + window + "天没有体重记录，历史记录也为空。"
                    : latestWeightText(all.get(all.size() - 1), window);
        }

        PetWeightLogDO first = recent.get(0);
        PetWeightLogDO last = recent.get(recent.size() - 1);
        BigDecimal delta = last.getWeightKg().subtract(first.getWeightKg());
        StringBuilder text = new StringBuilder("近").append(window).append("天体重记录").append(recent.size()).append("条：")
                .append(DATE.format(first.getRecordedAt())).append(" ").append(kg(first.getWeightKg())).append("kg")
                .append(" → ").append(DATE.format(last.getRecordedAt())).append(" ").append(kg(last.getWeightKg())).append("kg")
                .append("，变化").append(signKg(delta)).append("kg。");
        if (first.getBcs() != null && last.getBcs() != null && !first.getBcs().equals(last.getBcs())) {
            text.append("BCS ").append(first.getBcs()).append(" → ").append(last.getBcs()).append("。");
        }
        text.append(" 逐条：")
                .append(recent.stream().skip(Math.max(0, recent.size() - 6))
                        .map(l -> DATE.format(l.getRecordedAt()) + " " + kg(l.getWeightKg()) + "kg"
                                + (l.getBcs() == null ? "" : " BCS" + l.getBcs()))
                        .collect(Collectors.joining("；")))
                .append("。");
        AgentContext.record("weightTrend", "体重趋势",
                "近" + window + "天 " + kg(first.getWeightKg()) + "→" + kg(last.getWeightKg()) + "kg（" + signKg(delta) + "）");
        return text.toString();
    }

    @Tool("查询当前宠物最近若干天的喂食打卡汇总：有记录的天数、餐数、有记录日均克数与热量、未打卡日期、最近一餐。问吃没吃饱、喂养是否规律时使用。未打卡只表示没有记录，不等于没有喂食。")
    public String feedingSummary(@P("回溯天数，7 表示最近 7 天") int days) {
        return AgentContext.guard("feedingSummary", "喂食打卡", "喂食", () -> feedingSummaryData(days));
    }

    private String feedingSummaryData(int days) {
        AgentContext.State ctx = AgentContext.current();
        int window = clamp(days);
        LocalDate today = LocalDate.now();
        LocalDate start = today.minusDays(window - 1L);
        List<FeedingLogDO> logs = feedingLogService.listLogs(ctx.userId, ctx.petId, start, today);
        if (logs.isEmpty()) {
            AgentContext.record("feedingSummary", "喂食打卡", "近" + window + "天无记录");
            return "近" + window + "天没有任何喂食打卡记录（只代表没记录，不代表没喂食）。";
        }

        Map<LocalDate, List<FeedingLogDO>> byDate = logs.stream()
                .filter(l -> l.getFedDate() != null)
                .collect(Collectors.groupingBy(FeedingLogDO::getFedDate));
        int covered = byDate.size();
        BigDecimal grams = sum(logs.stream().map(FeedingLogDO::getGrams).toList());
        BigDecimal kcal = sum(logs.stream().map(FeedingLogDO::getKcal).filter(Objects::nonNull).toList());
        long kcalMeals = logs.stream().filter(l -> l.getKcal() != null).count();
        // 热量分母只算有热量数据的天，否则缺数据的餐次会被摊薄成偏低的日均
        long kcalDays = logs.stream()
                .filter(l -> l.getKcal() != null && l.getFedDate() != null)
                .map(FeedingLogDO::getFedDate)
                .distinct()
                .count();

        StringBuilder text = new StringBuilder("近").append(window).append("天喂食打卡：")
                .append(covered).append("/").append(window).append("天有记录，共").append(logs.size()).append("餐，有记录日均")
                .append(avg(grams, covered)).append("g");
        if (kcalMeals > 0) {
            text.append(" / ").append(avg(kcal, (int) kcalDays)).append("kcal（")
                    .append(kcalMeals).append("餐有热量数据，按").append(kcalDays).append("天计）");
        } else {
            text.append("（所选食品没有热量数据）");
        }
        text.append("。未打卡只表示没有记录，不代表没有喂食。");

        FeedingLogDO latest = logs.get(0);
        LocalDate activeFrom = start;
        PetDO pet = petService.getPet(ctx.userId, ctx.petId);
        if (pet.getCreatedAt() != null && pet.getCreatedAt().toLocalDate().isAfter(activeFrom)) {
            activeFrom = pet.getCreatedAt().toLocalDate();
        }
        List<LocalDate> missingDates = activeFrom.datesUntil(today.plusDays(1))
                .filter(d -> !byDate.containsKey(d))
                .toList();
        text.append("最近一餐 ").append(DATE.format(latest.getFedDate()))
                .append(latest.getGrams() == null ? "" : " " + kg(latest.getGrams()) + "g").append("。");
        if (!missingDates.isEmpty()) {
            // 直接给出未记录天数和日期，避免模型自己做减法算错
            text.append("其余").append(missingDates.size()).append("天没有记录：")
                    .append(missingDates.stream().limit(5).map(DATE::format).collect(Collectors.joining("、")))
                    .append(missingDates.size() > 5 ? " 等" : "")
                    .append("。");
        }
        AgentContext.record("feedingSummary", "喂食打卡", "近" + window + "天打卡" + covered + "/" + window + "天");
        return text.toString();
    }

    @Tool("查询当前宠物的提醒执行情况：近若干天各提醒应做/已完成次数与漏做日期、今天要做且未打卡的、未来若干天到期的疫苗/驱虫事件、已过期未完成的事件。问有没有漏做、这周遛弯或喂食是否规律、接下来该做什么时使用。")
    public String reminderStatus(@P("回溯与后看的天数，7 表示近 7 天执行情况和未来 7 天事件") int days) {
        return AgentContext.guard("reminderStatus", "提醒与打卡", "提醒", () -> reminderStatusData(days));
    }

    private String reminderStatusData(int days) {
        AgentContext.State ctx = AgentContext.current();
        int window = clamp(days);
        LocalDate today = LocalDate.now();
        List<ReminderDO> reminders = reminderService.listReminders(ctx.userId, ctx.petId);
        if (reminders.isEmpty()) {
            AgentContext.record("reminderStatus", "提醒与打卡", "无启用提醒");
            return "当前没有启用中的提醒。";
        }

        List<ReminderLogDO> logs = reminderService.getLogs(ctx.userId, ctx.petId, today.minusDays(365), today);
        Set<Long> doneToday = logs.stream()
                .filter(l -> today.equals(l.getDoneDate()))
                .map(ReminderLogDO::getReminderId)
                .collect(Collectors.toSet());
        List<ReminderDO> dueToday = reminders.stream().filter(r -> isDueOn(r, today)).toList();
        List<ReminderDO> pendingToday = dueToday.stream().filter(r -> !doneToday.contains(r.getId())).toList();
        List<ReminderDO> overdue = reminders.stream()
                .filter(this::isDated)
                .filter(r -> r.getRemindDate().isBefore(today))
                .filter(r -> logs.stream().noneMatch(l -> l.getReminderId().equals(r.getId())
                        && r.getRemindDate().equals(l.getDoneDate())))
                .toList();
        List<ReminderDO> upcoming = reminders.stream()
                .filter(this::isDated)
                .filter(r -> !r.getRemindDate().isBefore(today) && !r.getRemindDate().isAfter(today.plusDays(window)))
                .toList();

        StringBuilder text = new StringBuilder("启用提醒").append(reminders.size()).append("条。");
        if (!dueToday.isEmpty()) {
            text.append("今天应做").append(dueToday.size()).append("条，已完成")
                    .append(dueToday.size() - pendingToday.size()).append("条");
            if (!pendingToday.isEmpty()) {
                text.append("，未完成：").append(titles(pendingToday, 5));
            }
            text.append("。");
        } else {
            text.append("今天没有到期事项。");
        }
        if (!upcoming.isEmpty()) {
            text.append("未来").append(window).append("天事件：")
                    .append(upcoming.stream().limit(5)
                            .map(r -> dateText(r.getRemindDate()) + " " + typeLabel(r) + "·" + r.getTitle())
                            .collect(Collectors.joining("；")))
                    .append("。");
        }
        if (!overdue.isEmpty()) {
            text.append("已过期未完成：")
                    .append(overdue.stream().limit(5)
                            .map(r -> dateText(r.getRemindDate()) + " " + typeLabel(r) + "·" + r.getTitle())
                            .collect(Collectors.joining("；")))
                    .append("。");
        }
        text.append("周期提醒：")
                .append(reminders.stream().filter(r -> !isDated(r)).limit(6)
                        .map(r -> schedule(r) + " " + typeLabel(r) + "·" + r.getTitle())
                        .collect(Collectors.joining("；")))
                .append("。");

        String adherence = adherenceText(reminders, logs, window, today);
        if (!adherence.isEmpty()) {
            text.append(adherence);
        }

        String summary = dueToday.isEmpty()
                ? "今天无到期事项"
                : "今日 " + (dueToday.size() - pendingToday.size()) + "/" + dueToday.size() + " 完成";
        if (!overdue.isEmpty()) {
            summary += "，过期 " + overdue.size() + " 条";
        }
        AgentContext.record("reminderStatus", "提醒与打卡", summary);
        return text.toString();
    }

    @Tool("检索宠物营养与健康知识库（WSAVA 等权威来源），用于通用科普问题。涉及这只宠物自身数据的问题优先使用其它工具。")
    public String searchKnowledge(@P("检索关键词，例如：牛磺酸需求、驱虫频率") String query) {
        return AgentContext.guard("searchKnowledge", "知识库检索", "知识库",
                () -> searchKnowledgeData(query));
    }

    private String searchKnowledgeData(String query) {
        if (query == null || query.isBlank()) {
            return "检索关键词为空，无法查询知识库。";
        }
        AgentContext.State ctx = AgentContext.current();
        PetDO pet = petService.getPet(ctx.userId, ctx.petId);
        List<KnowledgeDocDO> docs = retrievalService.search(query, pet.getSpecies(), lifeStage(pet.getBirthday()), 3);
        if (docs.isEmpty()) {
            AgentContext.record("searchKnowledge", "知识库检索", "无命中");
            return "知识库没有检索到与「" + query + "」相关的内容。";
        }
        AgentContext.recordDocs(docs);
        AgentContext.record("searchKnowledge", "知识库检索", "命中 " + docs.size() + " 条");
        return docs.stream()
                .map(d -> "[" + d.getId() + "] " + d.getTitle() + "：" + truncate(d.getContent(), 200)
                        + "（来源：" + d.getSourceName() + "）")
                .collect(Collectors.joining("\n"));
    }

    @Tool("为当前宠物新建或修改一条提醒的待确认计划（不会直接创建）。用户要求新增或调整提醒、安排疫苗/驱虫/喂食/遛弯时间时使用。只提案，由用户在界面上确认后才会真正保存。")
    public String proposeReminder(
            @P("提醒标题，例如：狂犬疫苗加强针") String title,
            @P("提醒类型：FEED 喂食 / WALK 遛弯 / WATER 喂水 / GROOMING 梳毛 / DEWORM 驱虫 / VACCINE 疫苗 / BATH 洗澡 / CUSTOM 自定义") String reminderType,
            @P("计划日期 yyyy-MM-dd；周期提醒可留空") String date,
            @P("提醒时间 HH:mm，例如 09:00") String time,
            @P("重复规则：ONCE 仅一次 / DAILY 每天 / WEEKLY 每周 / MONTHLY 每月 / YEARLY 每年") String repeatRule,
            @P("WEEKLY 时指定星期，逗号分隔且 1=周一 … 7=周日，例如 1,3,5；其它情况留空") String repeatDays) {
        return AgentContext.guard("proposeReminder", "生成提醒计划", "提醒计划",
                () -> proposeReminderData(title, reminderType, date, time, repeatRule, repeatDays));
    }

    private String proposeReminderData(String title, String reminderType, String date, String time,
                                       String repeatRule, String repeatDays) {
        AgentContext.State ctx = AgentContext.current();
        String cleanTitle = title == null ? "" : title.trim();
        if (cleanTitle.isEmpty()) {
            return "提案失败：标题不能为空。请补一个具体的提醒标题后重试。";
        }
        if (cleanTitle.length() > 50) {
            cleanTitle = cleanTitle.substring(0, 50);
        }

        String type = reminderType == null ? "CUSTOM" : reminderType.trim().toUpperCase();
        if (!TYPE_LABEL.containsKey(type)) {
            return "提案失败：提醒类型「" + reminderType + "」不支持，请从 FEED/WALK/WATER/GROOMING/DEWORM/VACCINE/BATH/CUSTOM 中选择。";
        }

        LocalDate remindDate = null;
        if (date != null && !date.isBlank()) {
            try {
                remindDate = LocalDate.parse(date.trim());
            } catch (Exception e) {
                return "提案失败：日期「" + date + "」无法识别，请用 yyyy-MM-dd 格式重试。";
            }
            if (remindDate.isBefore(LocalDate.now())) {
                return "提案失败：日期 " + remindDate + " 已经过去了，请按用户消息里的【今天】重新换算。";
            }
        }

        LocalTime remindTime;
        try {
            remindTime = time == null || time.isBlank() ? LocalTime.of(9, 0) : LocalTime.parse(time.trim());
        } catch (Exception e) {
            return "提案失败：时间「" + time + "」无法识别，请用 HH:mm 格式重试。";
        }

        boolean datedType = "VACCINE".equals(type) || "DEWORM".equals(type);
        String rule = repeatRule == null || repeatRule.isBlank() ? "DAILY" : repeatRule.trim().toUpperCase();
        if (!Set.of("ONCE", "DAILY", "WEEKLY", "MONTHLY", "YEARLY").contains(rule)) {
            return "提案失败：重复规则「" + repeatRule + "」不支持，请从 ONCE/DAILY/WEEKLY/MONTHLY/YEARLY 中选择。";
        }
        if (datedType) {
            if (remindDate == null) {
                return "提案失败：" + TYPE_LABEL.get(type) + "必须指定具体日期，请用 yyyy-MM-dd 重试。";
            }
            rule = "ONCE";
        }
        if ("ONCE".equals(rule) && remindDate == null) {
            return "提案失败：仅一次的提醒必须指定具体日期，请用 yyyy-MM-dd 重试。";
        }

        String days = null;
        if ("WEEKLY".equals(rule)) {
            days = normalizeRepeatDays(repeatDays);
            if (days == null) {
                return "提案失败：每周重复需要 1-7 的星期数字，例如 1,3,5。";
            }
        }

        String when = remindDate == null
                ? "从今天起 " + scheduleText(rule, days, remindTime)
                : dateText(remindDate) + " " + TIME.format(remindTime);
        String cadence = switch (rule) {
            case "ONCE" -> "仅一次";
            case "DAILY" -> "每天";
            case "WEEKLY" -> "每" + weekdayText(days);
            case "MONTHLY" -> "每月";
            default -> "每年";
        };
        String summary = when + (remindDate == null ? "" : " · " + cadence)
                + " · " + TYPE_LABEL.get(type) + "·" + cleanTitle;

        AgentContext.propose(new AgentContext.PendingAction(
                "reminder.create", ctx.petId, cleanTitle, type,
                remindDate == null ? null : remindDate.toString(),
                remindTime.toString(), rule, days, summary));
        AgentContext.record("proposeReminder", "生成提醒计划", summary);
        return "已生成待确认的提醒计划：" + summary
                + "。请注意：还没有保存，必须由用户在界面上点击确认后才会创建。";
    }

    private String latestWeightText(PetWeightLogDO last, int window) {
        LocalDate date = last.getRecordedAt();
        return "近" + window + "天没有体重记录。最近一次是 "
                + (date == null ? "未知日期" : DATE.format(date)) + " " + kg(last.getWeightKg()) + "kg"
                + (last.getBcs() == null ? "" : "，BCS " + last.getBcs() + "/9") + "。";
    }

    private boolean isDated(ReminderDO reminder) {
        return "ONCE".equals(reminder.getRepeatRule()) && reminder.getRemindDate() != null;
    }

    /** 只有带日期的仅一次提醒只在当天出现；周期提醒按重复规则判断当天是否应做。 */
    private boolean isDueOn(ReminderDO reminder, LocalDate date) {
        if (isDated(reminder)) {
            return reminder.getRemindDate().equals(date);
        }
        String rule = reminder.getRepeatRule() == null ? "DAILY" : reminder.getRepeatRule();
        LocalDate anchor = reminder.getCreatedAt() == null ? null : reminder.getCreatedAt().toLocalDate();
        return switch (rule) {
            case "WEEKLY" -> weeklyDue(reminder, date, anchor);
            case "MONTHLY" -> anchor == null || date.getDayOfMonth() == anchor.getDayOfMonth();
            case "YEARLY" -> anchor == null
                    || (date.getMonth() == anchor.getMonth() && date.getDayOfMonth() == anchor.getDayOfMonth());
            default -> true;
        };
    }

    private boolean weeklyDue(ReminderDO reminder, LocalDate date, LocalDate anchor) {
        String days = reminder.getRepeatDays();
        if (days != null && !days.isBlank()) {
            int dayOfWeek = date.getDayOfWeek().getValue();
            for (String part : days.split("[,，、\\s]+")) {
                if (part.matches("[1-7]") && Integer.parseInt(part) == dayOfWeek) {
                    return true;
                }
            }
            return false;
        }
        return anchor == null || date.getDayOfWeek() == anchor.getDayOfWeek();
    }

    /**
     * 近 N 天应做/已完成统计。起点取「提醒创建日」与「最早打卡日」中更早者：
     * 演示数据会先建提醒再回填历史打卡，只看创建日会导致历史全部不可见。
     */
    private String adherenceText(List<ReminderDO> reminders, List<ReminderLogDO> logs,
                                 int window, LocalDate today) {
        LocalDate windowStart = today.minusDays(window - 1L);
        int dueTotal = 0;
        int doneTotal = 0;
        List<String> parts = new ArrayList<>();
        for (ReminderDO reminder : reminders) {
            LocalDate from = activeFrom(reminder, logs, windowStart);
            List<LocalDate> dueDates = new ArrayList<>();
            for (LocalDate date = from; !date.isAfter(today); date = date.plusDays(1)) {
                if (isDueOn(reminder, date)) {
                    dueDates.add(date);
                }
            }
            if (dueDates.isEmpty()) {
                continue;
            }
            Set<LocalDate> doneDates = logs.stream()
                    .filter(l -> reminder.getId().equals(l.getReminderId()) && l.getDoneDate() != null)
                    .map(ReminderLogDO::getDoneDate)
                    .collect(Collectors.toSet());
            long done = dueDates.stream().filter(doneDates::contains).count();
            dueTotal += dueDates.size();
            doneTotal += (int) done;
            StringBuilder part = new StringBuilder(typeLabel(reminder) + "·" + reminder.getTitle())
                    .append(" ").append(done).append("/").append(dueDates.size());
            if (done < dueDates.size()) {
                List<String> missing = dueDates.stream()
                        .filter(d -> !doneDates.contains(d))
                        .limit(3)
                        .map(this::dateText)
                        .toList();
                part.append("（缺").append(String.join("、", missing))
                        .append(dueDates.size() - done > 3 ? " 等" : "").append("）");
            }
            parts.add(part.toString());
        }
        if (dueTotal == 0) {
            return "";
        }
        StringBuilder text = new StringBuilder("近").append(window).append("天所有提醒合计 ")
                .append(doneTotal).append("/").append(dueTotal).append(" 次打卡；分类：")
                .append(parts.stream().limit(8).collect(Collectors.joining("；")));
        if (parts.size() > 8) {
            text.append("；其余 ").append(parts.size() - 8).append(" 项略");
        }
        return text.append("。").toString();
    }

    private LocalDate activeFrom(ReminderDO reminder, List<ReminderLogDO> logs, LocalDate windowStart) {
        LocalDate created = reminder.getCreatedAt() == null ? null : reminder.getCreatedAt().toLocalDate();
        LocalDate earliestDone = logs.stream()
                .filter(l -> reminder.getId().equals(l.getReminderId()) && l.getDoneDate() != null)
                .map(ReminderLogDO::getDoneDate)
                .min(LocalDate::compareTo)
                .orElse(null);
        LocalDate anchor = earliestDone == null ? created
                : (created == null || earliestDone.isBefore(created) ? earliestDone : created);
        return anchor != null && anchor.isAfter(windowStart) ? anchor : windowStart;
    }

    private String dateText(LocalDate date) {
        return DATE.format(date) + "（周" + WEEKDAYS[date.getDayOfWeek().getValue() - 1] + "）";
    }

    private String schedule(ReminderDO reminder) {
        String time = reminder.getRemindTime() == null ? "" : " " + TIME.format(reminder.getRemindTime());
        String rule = reminder.getRepeatRule() == null ? "DAILY" : reminder.getRepeatRule();
        return switch (rule) {
            case "WEEKLY" -> "每周" + (reminder.getRepeatDays() == null ? "" : "（" + reminder.getRepeatDays() + "）") + time;
            case "MONTHLY" -> "每月" + time;
            case "YEARLY" -> "每年" + time;
            default -> "每天" + time;
        };
    }

    private String scheduleText(String rule, String days, LocalTime time) {
        String clock = " " + TIME.format(time);
        return switch (rule) {
            case "WEEKLY" -> "每" + weekdayText(days) + clock;
            case "MONTHLY" -> "每月" + clock;
            case "YEARLY" -> "每年" + clock;
            default -> "每天" + clock;
        };
    }

    private String weekdayText(String days) {
        if (days == null || days.isBlank()) {
            return "";
        }
        String[] labels = {"一", "二", "三", "四", "五", "六", "日"};
        String normalized = normalizeRepeatDays(days);
        if (normalized == null) {
            return "";
        }
        if ("1,2,3,4,5".equals(normalized)) {
            return "周一至周五";
        }
        return java.util.Arrays.stream(normalized.split(","))
                .map(s -> "周" + labels[Integer.parseInt(s) - 1])
                .collect(Collectors.joining("、"));
    }

    /** 归一成 "1,3,5"：去重、排序、只保留 1-7；没有合法值返回 null。 */
    private String normalizeRepeatDays(String repeatDays) {
        if (repeatDays == null) {
            return null;
        }
        java.util.TreeSet<Integer> values = new java.util.TreeSet<>();
        for (String part : repeatDays.split("[,，、\\s]+")) {
            if (part.matches("[1-7]")) {
                values.add(Integer.parseInt(part));
            }
        }
        if (values.isEmpty()) {
            return null;
        }
        return values.stream().map(String::valueOf).collect(Collectors.joining(","));
    }

    private String titles(List<ReminderDO> reminders, int limit) {
        return reminders.stream().limit(limit)
                .map(r -> typeLabel(r) + "·" + r.getTitle())
                .collect(Collectors.joining("、"));
    }

    private String typeLabel(ReminderDO reminder) {
        return TYPE_LABEL.getOrDefault(reminder.getReminderType(), reminder.getReminderType());
    }

    private String ageText(LocalDate birthday) {
        if (birthday == null) {
            return "未知";
        }
        Period period = Period.between(birthday, LocalDate.now());
        if (period.getYears() > 0) {
            return period.getYears() + "岁" + (period.getMonths() > 0 ? period.getMonths() + "个月" : "");
        }
        return Math.max(period.getMonths(), 0) + "个月";
    }

    private String speciesLabel(String species) {
        if (species == null) {
            return "宠物";
        }
        return switch (species.toLowerCase()) {
            case "cat" -> "猫";
            case "dog" -> "犬";
            default -> species;
        };
    }

    private String sexLabel(String sex) {
        if (sex == null) {
            return "未知";
        }
        return switch (sex.toLowerCase()) {
            case "male" -> "公";
            case "female" -> "母";
            default -> sex;
        };
    }

    private String activityLabel(String level) {
        return switch (level) {
            case "SEDENTARY" -> "久坐";
            case "LOW" -> "低";
            case "MODERATE" -> "中";
            case "HIGH" -> "高";
            case "WORKING" -> "工作犬";
            default -> level;
        };
    }

    private String bcsLabel(int bcs) {
        if (bcs <= 3) {
            return "偏瘦";
        }
        if (bcs <= 5) {
            return "理想";
        }
        if (bcs <= 7) {
            return "偏重";
        }
        return "肥胖";
    }

    private String lifeStage(LocalDate birthday) {
        if (birthday == null) {
            return "adult";
        }
        long months = java.time.temporal.ChronoUnit.MONTHS.between(birthday, LocalDate.now());
        if (months < 12) {
            return "young";
        }
        return months >= 84 ? "senior" : "adult";
    }

    private int clamp(int days) {
        int value = days <= 0 ? 7 : days;
        return Math.min(Math.max(value, 1), 90);
    }

    private BigDecimal sum(List<BigDecimal> values) {
        return values.stream().filter(Objects::nonNull).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private String avg(BigDecimal total, int days) {
        if (days <= 0) {
            return "0";
        }
        return total.divide(BigDecimal.valueOf(days), 0, RoundingMode.HALF_UP).toPlainString();
    }

    private String kg(BigDecimal value) {
        if (value == null) {
            return "0";
        }
        return value.setScale(2, RoundingMode.HALF_UP).stripTrailingZeros().toPlainString();
    }

    private String signKg(BigDecimal value) {
        return (value.signum() > 0 ? "+" : "") + kg(value);
    }

    private String truncate(String text, int max) {
        if (text == null) {
            return "";
        }
        return text.length() <= max ? text : text.substring(0, max) + "…";
    }
}
