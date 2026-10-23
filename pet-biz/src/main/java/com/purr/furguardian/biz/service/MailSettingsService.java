package com.purr.furguardian.biz.service;

public interface MailSettingsService {

    record MailSettings(String email, boolean enabled) {}

    MailSettings get(Long userId);

    MailSettings save(Long userId, String email, boolean enabled);
}
