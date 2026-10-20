<template>
  <div class="page-header">
    <div class="head-text">
      <router-link v-if="back" :to="back.to" class="fg-back">
        <ArrowLeft :size="16" class="fg-icon" />
        <span>返回{{ back.label }}</span>
      </router-link>
      <p v-if="breadcrumb" class="fg-label breadcrumb">{{ breadcrumb }}</p>
      <h1 class="fg-h1">{{ title }}</h1>
      <p v-if="description" class="desc">{{ description }}</p>
    </div>
    <div v-if="$slots.actions" class="head-actions">
      <slot name="actions" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeft } from 'lucide-vue-next'

defineProps<{
  title: string
  description?: string
  breadcrumb?: string
  back?: { to: string; label: string }
}>()
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: var(--fg-s5);
  padding-bottom: var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  margin-bottom: var(--fg-s6);
}

.breadcrumb {
  margin: 0 0 var(--fg-s2);
}

.page-header :deep(.fg-h1) {
  font-size: 32px;
}

.desc {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
  max-width: 62ch;
}

.head-actions {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  flex: none;
  padding-bottom: var(--fg-s1);
}

@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
  }
}

/* 响应式新增：<768px 手机端（桌面端不受影响） */
@media (max-width: 767.98px) {
  .page-header {
    flex-wrap: wrap;
    gap: var(--fg-s3);
    padding-bottom: var(--fg-s4);
    margin-bottom: var(--fg-s5);
  }

  .page-header :deep(.fg-h1) {
    font-size: 28px;
  }

  .desc {
    font-size: 13px;
    line-height: 1.6;
  }

  .head-actions {
    width: 100%;
    flex-wrap: wrap;
    gap: var(--fg-s2);
    padding-bottom: 0;
  }
}
</style>
