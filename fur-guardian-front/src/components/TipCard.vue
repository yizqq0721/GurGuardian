<template>
  <div class="tip-card">
    <!-- 生成中：加载动画，不展示半成品或原始 SSE 数据 -->
    <template v-if="busy">
      <div class="tip-generating" role="status" aria-live="polite">
        <span class="gen-spinner" aria-hidden="true" />
        <span class="gen-text">正在结合知识库生成新的 Tip…</span>
      </div>
      <div class="gen-skeleton" aria-hidden="true">
        <span class="sk-line" style="width: 92%" />
        <span class="sk-line" style="width: 78%" />
        <span class="sk-line" style="width: 56%" />
      </div>
    </template>

    <template v-else-if="tip">
      <Transition name="tip-swap" mode="out-in">
        <p :key="tip.id" class="tip-content">{{ tip.content }}</p>
      </Transition>

      <div class="tip-foot">
        <SourceChip v-if="tip.sourceName" :label="`来源 · ${tip.sourceName}`" />
        <span class="tip-actions">
          <button
            type="button"
            class="fb-btn"
            :disabled="busy"
            @click="regenerate"
          >
            <RefreshCw :size="20" class="fg-icon" />
            换一条
          </button>
          <button
            type="button"
            class="fb-btn"
            :class="{ 'is-active': tip.feedback === 1, 'is-bump': bump === 'like' }"
            :disabled="feedbackBusy"
            @click="sendFeedback('like')"
          >
            <ThumbsUp :size="20" class="fg-icon fb-icon" />
            有用
          </button>
          <button
            type="button"
            class="fb-btn"
            :class="{ 'is-active': tip.feedback === 0, 'is-bump': bump === 'dislike' }"
            :disabled="feedbackBusy"
            @click="sendFeedback('dislike')"
          >
            <ThumbsDown :size="20" class="fg-icon fb-icon" />
            没帮助
          </button>
        </span>
      </div>
    </template>

    <template v-else-if="loading">
      <div class="gen-skeleton" aria-hidden="true">
        <span class="sk-line" style="width: 90%" />
        <span class="sk-line" style="width: 72%" />
        <span class="sk-line" style="width: 48%" />
      </div>
    </template>

    <EmptyState v-else variant="default" description="暂无今日 Tip" />

    <DisclaimerBar />
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
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
const feedbackBusy = ref(false)
const bump = ref<'like' | 'dislike' | null>(null)
let bumpTimer: ReturnType<typeof setTimeout> | undefined

const { streaming, start, stop } = useTipStream()
const busy = computed(() => loading.value || streaming.value)

onMounted(fetchTip)
onBeforeUnmount(() => clearTimeout(bumpTimer))

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
  if (busy.value) return
  try {
    await start(props.petId, { refresh: true })
    // SSE 只负责触发生成，正式内容（id/来源/反馈）仍从 /today 回读
    await fetchTip()
  } catch (e) {
    ElMessage.warning((e as Error).message || '生成失败，请稍后重试')
  }
}

async function sendFeedback(feedback: 'like' | 'dislike') {
  if (!tip.value || feedbackBusy.value) return
  const value = feedback === 'like' ? 1 : 0
  const previous = tip.value.feedback
  tip.value.feedback = value
  feedbackBusy.value = true
  bump.value = feedback
  clearTimeout(bumpTimer)
  bumpTimer = setTimeout(() => (bump.value = null), 420)

  try {
    await tipApi.feedback(tip.value.id, feedback)
  } catch {
    tip.value.feedback = previous
  } finally {
    feedbackBusy.value = false
  }
}

onBeforeUnmount(stop)
</script>

<style scoped>
.tip-content {
  margin: 0 0 var(--fg-s3);
  font-size: var(--fg-text-body);
  line-height: 1.7;
  color: var(--fg-ink);
  white-space: pre-wrap;
}

/* ---------- 生成中 ---------- */
.tip-generating {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  margin-bottom: var(--fg-s3);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.gen-spinner {
  width: 16px;
  height: 16px;
  flex: none;
  border: 2px solid var(--fg-line);
  border-top-color: var(--fg-accent);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

.gen-text {
  letter-spacing: 0.01em;
}

.gen-skeleton {
  display: flex;
  flex-direction: column;
  gap: var(--fg-s2);
  margin-bottom: var(--fg-s3);
}

.sk-line {
  display: block;
  height: 12px;
  border-radius: 4px;
  background: linear-gradient(
    90deg,
    var(--fg-line) 0%,
    var(--fg-paper) 45%,
    var(--fg-line) 90%
  );
  background-size: 220% 100%;
  animation: shimmer 1.2s ease-in-out infinite;
}

@keyframes shimmer {
  0% {
    background-position: 120% 0;
  }
  100% {
    background-position: -120% 0;
  }
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* ---------- 内容切换 ---------- */
.tip-swap-enter-active,
.tip-swap-leave-active {
  transition: opacity 0.22s ease, transform 0.22s ease;
}

.tip-swap-enter-from {
  opacity: 0;
  transform: translateY(4px);
}

.tip-swap-leave-to {
  opacity: 0;
  transform: translateY(-4px);
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

/* 点击时图标弹一下，作为反馈已提交的即时反馈 */
.fb-btn.is-bump .fb-icon {
  animation: bump 0.42s ease;
}

@keyframes bump {
  0% {
    transform: scale(1);
  }
  35% {
    transform: scale(1.35) rotate(-6deg);
  }
  70% {
    transform: scale(0.92) rotate(3deg);
  }
  100% {
    transform: scale(1);
  }
}

.tip-card :deep(.empty-state) {
  padding: var(--fg-s4) 0;
}
</style>
