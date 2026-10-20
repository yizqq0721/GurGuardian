<template>
  <div class="bcs-scale">
    <div class="scale" role="radiogroup" aria-label="体况评分 BCS">
      <button
        v-for="n in 9"
        :key="n"
        type="button"
        role="radio"
        :aria-checked="modelValue === n"
        class="seg"
        :class="{ 'is-active': modelValue === n }"
        @click="emit('update:modelValue', n)"
      >
        <svg width="34" height="20" viewBox="0 0 34 20" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true">
          <path :d="silhouette(n)" stroke-linejoin="round" />
        </svg>
        <span class="n fg-num">{{ n }}</span>
      </button>
    </div>
    <div class="ends fg-label">
      <span>偏瘦</span>
      <span>理想</span>
      <span>偏胖</span>
    </div>
    <p class="desc" :class="descClass">{{ modelValue }} 分 · {{ group.label }} —— {{ group.desc }}</p>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { bcsGroup } from '@/utils/constants'

const props = defineProps<{ modelValue: number }>()
const emit = defineEmits<{ (e: 'update:modelValue', v: number): void }>()

const group = computed(() => bcsGroup(props.modelValue))

const descClass = computed(() => {
  if (props.modelValue >= 8) return 'is-danger'
  if (props.modelValue === 4 || props.modelValue === 5) return 'is-ok'
  return 'is-warn'
})

/** 1-9 的体型侧视轮廓：从肋骨可见到腹部下垂 */
function silhouette(n: number) {
  const belly = 4 + (n - 1) * 1.35
  const waist = 13 - (n - 1) * 1.1
  return `M3 15 C3 6 9 3 17 3 C25 3 ${29 + n * 0.2} 6 ${29 + n * 0.2} 15 M${waist} 15 C${waist} ${15 + belly} ${29 - belly * 0.4} ${15 + belly} ${29 - belly * 0.4} 15`
}
</script>

<style scoped>
.scale {
  display: grid;
  grid-template-columns: repeat(9, 1fr);
  gap: 0;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  overflow: hidden;
}

.seg {
  appearance: none;
  background: var(--fg-surface);
  border: none;
  border-right: var(--fg-line-w) solid var(--fg-line);
  padding: var(--fg-s3) 0 var(--fg-s2);
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--fg-s1);
  color: var(--fg-ink-muted);
  transition: background var(--fg-motion), color var(--fg-motion);
}

.seg:last-child {
  border-right: none;
}

.seg:hover {
  background: var(--fg-paper);
  color: var(--fg-ink);
}

.seg.is-active {
  background: var(--fg-accent-soft);
  color: var(--fg-accent);
}

.n {
  font-size: var(--fg-text-label);
  font-weight: 500;
}

.ends {
  display: flex;
  justify-content: space-between;
  margin-top: var(--fg-s2);
}

.desc {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
}

.desc.is-ok {
  color: var(--fg-accent);
}

.desc.is-warn {
  color: var(--fg-warning);
}

.desc.is-danger {
  color: var(--fg-danger);
}

/* 响应式新增：<768px 缩小轮廓，避免 9 列在窄屏被裁切 */
@media (max-width: 767.98px) {
  .seg {
    padding: var(--fg-s2) 0;
  }

  .seg svg {
    width: 100%;
    max-width: 30px;
    height: auto;
  }
}
</style>
