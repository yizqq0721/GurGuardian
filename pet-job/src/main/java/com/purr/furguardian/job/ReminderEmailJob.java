package com.purr.furguardian.job;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.reminder.ReminderDO;
import com.purr.furguardian.biz.entity.reminder.ReminderLogDO;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderLogMapper;
import com.purr.furguardian.biz.mapper.reminder.ReminderMapper;
import com.purr.furguardian.biz.schedule.ReminderSchedule;
import com.purr.furguardian.biz.service.MailSettingsService;
import com.purr.furguardian.biz.service.MailSettingsService.MailSettings;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class ReminderEmailJob {

    private static final Logger log = LoggerFactory.getLogger(ReminderEmailJob.class);
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");
    private static final LocalTime UNTIMED_AFTER = LocalTime.of(8, 0);
    private static final String SENT_KEY_PREFIX = "fg:mail:sent:";

    private final ReminderMapper reminderMapper;
    private final ReminderLogMapper reminderLogMapper;
    private final PetMapper petMapper;
    private final MailSettingsService mailSettingsService;
    private final StringRedisTemplate redisTemplate;
    private final ObjectProvider<JavaMailSender> mailSenderProvider;

    @Value("${spring.mail.username:}")
    private String from;

    @Value("${furguardian.mail.app-url:http://localhost:5173}")
    private String appUrl;

    private boolean missingMailConfigLogged = false;

    public ReminderEmailJob(ReminderMapper reminderMapper,
                            ReminderLogMapper reminderLogMapper,
                            PetMapper petMapper,
                            MailSettingsService mailSettingsService,
                            StringRedisTemplate redisTemplate,
                            ObjectProvider<JavaMailSender> mailSenderProvider) {
        this.reminderMapper = reminderMapper;
        this.reminderLogMapper = reminderLogMapper;
        this.petMapper = petMapper;
        this.mailSettingsService = mailSettingsService;
        this.redisTemplate = redisTemplate;
        this.mailSenderProvider = mailSenderProvider;
    }

    @Scheduled(cron = "${furguardian.mail.scan-cron:0 */5 * * * *}")
    public void sendDueReminderEmails() {
        JavaMailSender mailSender = mailSenderProvider.getIfAvailable();
        if (mailSender == null || from == null || from.isBlank()) {
            if (!missingMailConfigLogged) {
                log.info("未配置 spring.mail，提醒邮件任务暂不发送；配置 SMTP 后自动生效");
                missingMailConfigLogged = true;
            }
            return;
        }

        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();

        List<ReminderDO> reminders = reminderMapper.selectList(
                new LambdaQueryWrapper<ReminderDO>().eq(ReminderDO::getEnabled, 1));
        if (reminders.isEmpty()) {
            return;
        }

        Set<Long> doneIds = reminderLogMapper.selectList(
                        new LambdaQueryWrapper<ReminderLogDO>().eq(ReminderLogDO::getDoneDate, today))
                .stream()
                .map(ReminderLogDO::getReminderId)
                .collect(Collectors.toSet());

        String sentKey = SENT_KEY_PREFIX + today;
        Set<String> sentIds = redisTemplate.opsForSet().members(sentKey);

        Map<Long, List<ReminderDO>> pendingByUser = reminders.stream()
                .filter(r -> r.getUserId() != null)
                .filter(r -> ReminderSchedule.isDueOn(r, today))
                .filter(r -> isTimeReached(r, now))
                .filter(r -> !doneIds.contains(r.getId()))
                .filter(r -> sentIds == null || !sentIds.contains(String.valueOf(r.getId())))
                .collect(Collectors.groupingBy(ReminderDO::getUserId));

        if (pendingByUser.isEmpty()) {
            return;
        }

        Map<Long, String> petNames = petNamesOf(pendingByUser);

        pendingByUser.forEach((userId, list) -> {
            MailSettings settings = mailSettingsService.get(userId);
            if (!settings.enabled() || settings.email().isBlank()) {
                return;
            }
            try {
                send(mailSender, settings.email(), list, petNames);
                List<String> ids = list.stream().map(r -> String.valueOf(r.getId())).toList();
                redisTemplate.opsForSet().add(sentKey, ids.toArray(String[]::new));
                redisTemplate.expire(sentKey, Duration.ofDays(2));
                log.info("提醒邮件已发送: userId={}, count={}", userId, list.size());
            } catch (Exception e) {
                log.error("提醒邮件发送失败: userId={}, error={}", userId, e.getMessage());
            }
        });
    }

    private void send(JavaMailSender mailSender, String to, List<ReminderDO> reminders,
                      Map<Long, String> petNames) throws Exception {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, false, StandardCharsets.UTF_8.name());
        helper.setFrom(from);
        helper.setTo(to);
        helper.setSubject("FurGuardian 提醒：" + reminders.size() + " 项待完成");

        StringBuilder text = new StringBuilder("你好，以下提醒到点了：\n\n");
        reminders.stream()
                .sorted(Comparator.comparing(ReminderDO::getRemindTime,
                        Comparator.nullsLast(Comparator.naturalOrder())))
                .forEach(r -> {
                    text.append("· ")
                            .append(r.getRemindTime() == null ? "今天" : r.getRemindTime().format(TIME_FMT))
                            .append("  ")
                            .append(r.getTitle());
                    String petName = petNames.get(r.getPetId());
                    if (petName != null && !petName.isBlank()) {
                        text.append("（").append(petName).append("）");
                    }
                    text.append('\n');
                });
        text.append("\n完成后到「提醒」页打卡：").append(appUrl).append("/reminders\n");
        text.append("\n此邮件由 FurGuardian 自动发送，可在设置页随时关闭邮件提醒。\n");

        helper.setText(text.toString(), false);
        mailSender.send(message);
    }

    private Map<Long, String> petNamesOf(Map<Long, List<ReminderDO>> pendingByUser) {
        Set<Long> petIds = pendingByUser.values().stream()
                .flatMap(List::stream)
                .map(ReminderDO::getPetId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (petIds.isEmpty()) {
            return Map.of();
        }
        return petMapper.selectBatchIds(petIds).stream()
                .collect(Collectors.toMap(PetDO::getId, PetDO::getName, (a, b) -> a));
    }

    private static boolean isTimeReached(ReminderDO reminder, LocalTime now) {
        LocalTime time = reminder.getRemindTime();
        return time == null ? !now.isBefore(UNTIMED_AFTER) : !now.isBefore(time);
    }
}
