package com.purr.furguardian.biz.service;

import com.purr.furguardian.ai.service.LlmService;
import dev.langchain4j.model.chat.ChatModel;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.Duration;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class LlmServiceTest {

    @Test
    @DisplayName("正常返回模型内容")
    void should_returnContent_when_modelSucceeds() {
        ChatModel model = mock(ChatModel.class);
        when(model.chat(anyString())).thenReturn("多喝水");
        LlmService service = new LlmService(model, Runnable::run);

        assertEquals("多喝水", service.chatWithTimeout("system", "user", Duration.ofSeconds(1)));
    }

    @Test
    @DisplayName("模型异常时降级返回 null")
    void should_returnNull_when_modelThrows() {
        ChatModel model = mock(ChatModel.class);
        when(model.chat(anyString())).thenThrow(new IllegalStateException("boom"));
        LlmService service = new LlmService(model, Runnable::run);

        assertNull(service.chatWithTimeout("system", "user", Duration.ofSeconds(1)));
    }

    @Test
    @DisplayName("超过超时时间返回 null，不阻塞调用线程")
    void should_returnNull_when_timeoutExceeded() {
        ChatModel model = mock(ChatModel.class);
        when(model.chat(anyString())).thenAnswer(invocation -> {
            Thread.sleep(5_000);
            return "迟到的回答";
        });
        ExecutorService pool = Executors.newSingleThreadExecutor();
        try {
            LlmService service = new LlmService(model, pool);
            long start = System.currentTimeMillis();

            assertNull(service.chatWithTimeout("system", "user", Duration.ofMillis(100)));

            long elapsed = System.currentTimeMillis() - start;
            // 超时后应立刻返回，而不是等模型线程跑完
            org.junit.jupiter.api.Assertions.assertTrue(elapsed < 2_000, "耗时 " + elapsed + "ms");
        } finally {
            pool.shutdownNow();
        }
    }
}
