<template>
  <figure class="bcs-ref">
    <figcaption class="ref-hd">
      <span class="ref-title">{{ speciesLabel }} BCS 参考图</span>
      <span class="ref-hint fg-muted">WSAVA 9 分制 · 点击放大</span>
    </figcaption>
    <el-image
      class="ref-img"
      :src="src"
      :alt="`${speciesLabel}体况评分参考图`"
      fit="contain"
      :preview-src-list="[src]"
      :initial-index="0"
      preview-teleported
      hide-on-click-modal
    />
    <p class="ref-src fg-muted">来源：WSAVA Global Nutrition Committee</p>
  </figure>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import dogBcs from '@/photo/BCS-picture/狗BCS.webp'
import catBcs from '@/photo/BCS-picture/猫BCS.webp'
import type { Species } from '@/types'

const props = defineProps<{ species: Species }>()

const speciesLabel = computed(() => (props.species === 'cat' ? '猫' : '犬'))
const src = computed(() => (props.species === 'cat' ? catBcs : dogBcs))
</script>

<style scoped>
.bcs-ref {
  margin: var(--fg-s6) 0 0;
  padding: var(--fg-s3) var(--fg-s3) var(--fg-s2);
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
}

.ref-hd {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s3);
  margin-bottom: var(--fg-s2);
}

.ref-title {
  font-size: var(--fg-text-body);
  font-weight: 500;
  color: var(--fg-ink);
}

.ref-hint,
.ref-src {
  font-size: var(--fg-text-label);
  line-height: 1.6;
}

.ref-img {
  display: block;
  width: 100%;
  cursor: zoom-in;
}

.ref-img :deep(img) {
  display: block;
  width: 100%;
  height: auto;
}

.ref-src {
  margin: var(--fg-s2) 0 0;
}
</style>
