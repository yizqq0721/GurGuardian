<template>
  <div v-loading="loading && !streaming">
    <template v-if="streaming || streamText">
      <p class="tip-content">
        {{ streamText }}<span v-if="streaming" class="cursor">▍</span>
      </p>
      <p class="fg-muted" style="font-size: 12px">正在基于知识库生成，生成完成后可查看来源。</p>
    </template>
    <template v-else-if="tip">
      <p class="tip-content">{{ tip.content }}</p>
      <div class="tip-foot">
        <span v-if="tip.sourceName" class="fg-muted">来源：{{ tip.sourceName }}</span>
        <span class="tip-actions">
          <el-button size="small" text :loading="streaming" @click="regenerate">🔄 换一条</el-button>
          <el-button
            size="small"
            text
            :type="tip.feedback === 'like' ? 'primary' : ''"
            @click="sendFeedback('like')"
          >👍 有用</el-button>
          <el-button
            size="small"
            text
            :type="tip.feedback === 'dislike' ? 'danger' : ''"
            @click="sendFeedback('dislike')"
          >👎 没帮助</el-button>
        </span>
      </div>
    </template>
    <el-empty v-else description="暂无今日 Tip" :image-size="60" />
    <DisclaimerBar />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { tipApi } from '@/api/tip'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
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
  line-height: 1.8;
  margin: 0 0 8px;
}

.cursor {
  animation: blink 0.8s infinite;
  color: var(--fg-primary);
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
  gap: 4px;
}
</style>
