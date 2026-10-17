package com.purr.furguardian.biz.service;

public interface AuthService {

    Long register(String username, String password, String nickname);

    String login(String username, String password);

    void logout(String token);

    Long getUserIdByUsername(String username);

    String getNicknameByUsername(String username);
}
