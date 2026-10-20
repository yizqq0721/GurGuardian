package com.purr.furguardian.ai.service;

import dev.langchain4j.model.chat.ChatModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

@Service
public class LlmService {

    private static final Logger log = LoggerFactory.getLogger(LlmService.class);
    private static final Duration DEFAULT_TIMEOUT = Duration.ofSeconds(30);

    private final ChatModel chatModel;

    public LlmService(ChatModel chatModel) {
        this.chatModel = chatModel;
    }

    public String chat(String systemPrompt, String userPrompt) {
        String prompt = systemPrompt + "\n\n" + userPrompt;
        return chatModel.chat(prompt);
    }

    public String chatWithTimeout(String systemPrompt, String userPrompt, Duration timeout) {
        try {
            CompletableFuture<String> future = CompletableFuture.supplyAsync(
                    () -> chat(systemPrompt, userPrompt));
            return future.get(timeout.toMillis(), TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            log.warn("LLM调用超时或失败: {}", e.getMessage());
            return null;
        }
    }

    public String chatWithTimeout(String systemPrompt, String userPrompt) {
        return chatWithTimeout(systemPrompt, userPrompt, DEFAULT_TIMEOUT);
    }
}
