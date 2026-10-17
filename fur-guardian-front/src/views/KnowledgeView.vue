<template>
  <div class="fg-page">
    <div class="fg-card" style="margin-bottom: 16px">
      <h2 class="fg-section-title">🤖 AI 养宠问答</h2>
      <div class="ask-row">
        <el-input
          v-model="question"
          placeholder="例如：猫咪换粮后软便怎么办？"
          maxlength="200"
          @keyup.enter="ask"
        />
        <el-button type="primary" :loading="asking" @click="ask">提问</el-button>
      </div>

      <el-alert
        v-if="redlineHit"
        type="error"
        :closable="false"
        show-icon
        title="检测到可能的紧急情况"
        description="描述中包含红线症状关键词。请立即停止居家观察，带宠物前往最近的宠物医院。本平台不提供任何诊疗建议。"
        style="margin-top: 12px"
      />

      <div v-if="answer" class="answer-box">
        <p class="answer-content">{{ answer.content }}</p>
        <el-alert
          v-if="answer.isFallback"
          type="info"
          :closable="false"
          title="智能服务暂不可用，以上为知识库原文内容"
          style="margin-bottom: 8px"
        />
        <div v-if="answer.sources.length" class="sources">
          <span class="fg-muted">参考来源：</span>
          <el-tag v-for="s in answer.sources" :key="s.docId" size="small" effect="plain" style="margin-right: 6px">
            {{ s.title }} · {{ s.sourceName }}
          </el-tag>
        </div>
        <DisclaimerBar />
      </div>
    </div>

    <div class="fg-card">
      <h3 class="fg-section-title">📚 知识库检索</h3>
      <div class="search-row">
        <el-input v-model="searchQuery" placeholder="搜索知识条目" style="width: 280px" @keyup.enter="search" />
        <el-select v-model="searchSpecies" placeholder="物种" clearable style="width: 120px">
          <el-option value="dog" label="犬" />
          <el-option value="cat" label="猫" />
        </el-select>
        <el-select v-model="searchLifeStage" placeholder="生命阶段" clearable style="width: 130px">
          <el-option value="young" label="幼年" />
          <el-option value="adult" label="成年" />
          <el-option value="senior" label="老年" />
        </el-select>
        <el-button :loading="searching" @click="search">检索</el-button>
      </div>

      <el-empty v-if="searched && docs.length === 0" description="没有检索到相关条目" :image-size="60" />
      <div v-for="doc in docs" :key="doc.id" class="doc-item">
        <div class="doc-head">
          <span class="doc-title">{{ doc.title }}</span>
          <el-tag
            v-if="doc.severity"
            size="small"
            :type="doc.severity === 'emergency' ? 'danger' : doc.severity === 'caution' ? 'warning' : 'info'"
            effect="plain"
          >
            {{ severityLabel(doc.severity) }}
          </el-tag>
        </div>
        <p v-if="doc.content" class="doc-content">{{ doc.content }}</p>
        <div class="fg-muted doc-source">
          来源：{{ doc.sourceName || '未知' }}
          <a v-if="doc.sourceUrl" :href="doc.sourceUrl" target="_blank" rel="noopener">（原文链接）</a>
          <span v-if="doc.updatedAt"> · 更新于 {{ doc.updatedAt }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { aiApi } from '@/api/ai'
import { tipApi } from '@/api/tip'
import { usePetStore } from '@/stores/pet'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import type { AiQueryResp, KnowledgeDoc } from '@/types'

const petStore = usePetStore()

const question = ref('')
const asking = ref(false)
const answer = ref<AiQueryResp | null>(null)
const redlineHit = ref(false)

const searchQuery = ref('')
const searchSpecies = ref<string>()
const searchLifeStage = ref<string>()
const searching = ref(false)
const searched = ref(false)
const docs = ref<KnowledgeDoc[]>([])

async function ask() {
  const q = question.value.trim()
  if (!q) {
    ElMessage.warning('请输入问题')
    return
  }
  asking.value = true
  redlineHit.value = false
  try {
    // 红线优先：命中则不展示 AI 回答，直接提示就医
    redlineHit.value = await tipApi.checkRedline(q).catch(() => false)
    if (redlineHit.value) {
      answer.value = null
      return
    }
    answer.value = await aiApi.query({ query: q, petId: petStore.currentPet?.id })
  } finally {
    asking.value = false
  }
}

async function search() {
  if (!searchQuery.value.trim()) {
    ElMessage.warning('请输入检索关键词')
    return
  }
  searching.value = true
  try {
    docs.value = await aiApi.search({
      query: searchQuery.value.trim(),
      species: searchSpecies.value,
      lifeStage: searchLifeStage.value,
      topN: 10,
    })
    searched.value = true
  } finally {
    searching.value = false
  }
}

function severityLabel(s: string) {
  return s === 'emergency' ? '紧急' : s === 'caution' ? '注意' : '科普'
}
</script>

<style scoped>
.ask-row {
  display: flex;
  gap: 12px;
}

.answer-box {
  margin-top: 16px;
  padding: 16px;
  background: #fdf8f3;
  border-radius: 10px;
}

.answer-content {
  margin: 0 0 10px;
  line-height: 1.9;
  white-space: pre-wrap;
}

.sources {
  margin-bottom: 4px;
}

.search-row {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}

.doc-item {
  padding: 14px 0;
  border-bottom: 1px solid var(--fg-border);
}

.doc-item:last-child {
  border-bottom: none;
}

.doc-head {
  display: flex;
  align-items: center;
  gap: 8px;
}

.doc-title {
  font-weight: 600;
}

.doc-content {
  margin: 8px 0;
  font-size: 14px;
  line-height: 1.8;
  color: var(--fg-ink);
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.doc-source {
  font-size: 12px;
}
</style>
