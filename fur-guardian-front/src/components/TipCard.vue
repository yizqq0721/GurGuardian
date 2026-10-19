<template>
  <div v-loading="loading && !streaming" class="tip-card">
    <template v-if="streaming || streamText">
      <p class="tip-content">
        {{ streamText }}<span v-if="streaming" class="cursor" aria-hidden="true" />
      </p>
      <p class="gen-note">正在基于知识库生成，生成完成后可查看来源。</p>
    </template>

    <template v-else-if="tip">
      <p class="tip-content">{{ tip.content }}</p>

      <div class="tip-foot">
        <SourceChip v-if="tip.sourceName" :label="`来源 · ${tip.sourceName}`" />
        <span class="tip-actions">
          <button
            type="button"
            class="fb-btn"
            :disabled="streaming"
            @click="regenerate"
          >
            <RefreshCw :size="20" class="fg-icon" :class="{ 'is-spin': streaming }" />
            换一条
          </button>
          <button
            type="button"
            class="fb-btn"
            :class="{ 'is-active': tip.feedback === 'like' }"
            @click="sendFeedback('like')"
          >
            <ThumbsUp :size="20" class="fg-icon" />
            有用
          </button>
          <button
            type="button"
            class="fb-btn"
            :class="{ 'is-active': tip.feedback === 'dislike' }"
            @click="sendFeedback('dislike')"
          >
            <ThumbsDown :size="20" class="fg-icon" />
            没帮助
          </button>
        </span>
      </div>
    </template>

    <EmptyState v-else variant="default" description="暂无今日 Tip" />

    <DisclaimerBar />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { RefreshCw, ThumbsDown, ThumbsUp } from 'lucide-vue-next'
import { tipApi } from '@/api/tip'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import EmptyState from '@/components/EmptyState.vue'
import SourceChip from '@/components/SourceChip.vue'
import { useTipStream } from '@/composables/useTipStream'
import type { Tip } from '@/types'

const props = defineProps<{ petId: number }>()

const loading = ref(false)
const tip = ref<Tip | null>(null)
const { streaming, content: streamContent, start } = useTipStream()

const streamText = computed(() => streamContent.value)

onMounted(fetchTip)

async function fetchTip() {
  loading.value = true
  try {
    tip.value = await tipApi.today(props.petId)
  } catch {
    tip.value = null
  } finally {
    loading.value = false
  }
}

async function regenerate() {
  try {
    await start(props.petId)
    // 流式结束后刷新正式 Tip（含来源与 id）
    await fetchTip()
  } catch {
    ElMessage.warning('生成失败，展示已有内容')
    fetchTip()
  }
}

async function sendFeedback(feedback: 'like' | 'dislike') {
  if (!tip.value) return
  await tipApi.feedback(tip.value.id, feedback)
  tip.value.feedback = feedback
  ElMessage.success('感谢反馈')
}
</script>

<style scoped>
.tip-content {
  margin: 0 0 var(--fg-s3);
  font-size: var(--fg-text-body);
  line-height: 1.7;
  color: var(--fg-ink);
}

.gen-note {
  margin: 0;
  font-size: var(--fg-text-label);
  line-height: 1.6;
  color: var(--fg-ink-muted);
}

/* 流式光标：用色块画，不靠字符 */
.cursor {
  display: inline-block;
  width: 2px;
  height: 1em;
  margin-left: var(--fg-s1);
  vertical-align: -0.15em;
  background: var(--fg-accent);
  animation: blink 0.8s step-end infinite;
}

@keyframes blink {
  50% {
    opacity: 0;
  }
}

.tip-foot {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s2);
}

.tip-actions {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s1);
}

/* 反馈按钮：默认与正文同色，激活才用 accent */
.fb-btn {
  appearance: none;
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s1);
  height: 28px;
  padding: 0 var(--fg-s2);
  border: none;
  border-radius: 6px;
  background: none;
  color: var(--fg-ink);
  font-family: inherit;
  font-size: var(--fg-text-label);
  cursor: pointer;
  transition: background var(--fg-motion), color var(--fg-motion);
}

.fb-btn:hover:not(:disabled) {
  background: var(--fg-accent-soft);
  color: var(--fg-accent);
}

.fb-btn:disabled {
  cursor: default;
  color: var(--fg-ink-muted);
}

.fb-btn.is-active {
  color: var(--fg-accent);
}

.is-spin {
  animation: spin 0.9s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.tip-card :deep(.empty-state) {
  padding: var(--fg-s4) 0;
}
</style>
