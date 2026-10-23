package com.purr.furguardian.biz.service;

public interface UserProfileService {

    record UserProfile(Long userId, String username, String nickname, String location) {}

    UserProfile get(Long userId);

    UserProfile update(Long userId, String nickname, String location);

    String locationOf(Long userId);
}
