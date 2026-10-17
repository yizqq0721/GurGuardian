<template>
  <div v-loading="loading">
    <el-empty v-if="!loading && !tip" description="暂无今日 Tip" :image-size="60" />
    <template v-if="tip">
      <p class="tip-content">{{ tip.content }}</p>
      <div class="tip-foot">
        <span v-if="tip.sourceName" class="fg-muted">来源：{{ tip.sourceName }}</span>
        <span class="tip-actions">
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
      <DisclaimerBar />
    </template>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { tipApi } from '@/api/tip'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import type { Tip } from '@/types'

const props = defineProps<{ petId: number }>()

const loading = ref(false)
const tip = ref<Tip | null>(null)

onMounted(async () => {
  loading.value = true
  try {
    tip.value = await tipApi.today(props.petId)
  } catch {
    tip.value = null
  } finally {
    loading.value = false
  }
})

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

.tip-foot {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
