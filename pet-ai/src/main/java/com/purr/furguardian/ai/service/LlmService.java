package com.purr.furguardian.ai.service;

import dev.langchain4j.model.chat.ChatModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

@Service
public class LlmService {

    private static final Logger log = LoggerFactory.getLogger(LlmService.class);
    private static final Duration DEFAULT_TIMEOUT = Duration.ofSeconds(30);

    private final ChatModel chatModel;
    private final Executor executor;

    public LlmService(ChatModel chatModel, @Qualifier("llmExecutor") Executor executor) {
        this.chatModel = chatModel;
        this.executor = executor;
    }

    public String chat(String systemPrompt, String userPrompt) {
        String prompt = systemPrompt + "\n\n" + userPrompt;
        return chatModel.chat(prompt);
    }

    public String chatWithTimeout(String systemPrompt, String userPrompt, Duration timeout) {
        // 不用 commonPool：LLM 是阻塞 IO，占满公共线程池会拖慢同进程的其它并行任务
        CompletableFuture<String> future = CompletableFuture.supplyAsync(
                () -> chat(systemPrompt, userPrompt), executor);
        try {
            return future.get(timeout.toMillis(), TimeUnit.MILLISECONDS);
        } catch (TimeoutException e) {
            future.cancel(true);
            log.warn("LLM调用超时({}ms)，已取消", timeout.toMillis());
        } catch (InterruptedException e) {
            future.cancel(true);
            Thread.currentThread().interrupt();
            log.warn("LLM调用被中断，已取消");
        } catch (Exception e) {
            log.warn("LLM调用失败: {}", e.getClass().getSimpleName());
        }
        return null;
    }

    public String chatWithTimeout(String systemPrompt, String userPrompt) {
        return chatWithTimeout(systemPrompt, userPrompt, DEFAULT_TIMEOUT);
    }
}
