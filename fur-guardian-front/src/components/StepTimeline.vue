<template>
  <ol class="step-timeline">
    <li v-for="(s, i) in steps" :key="s.label" class="step">
      <span class="idx fg-mono">{{ String(i + 1).padStart(2, '0') }}</span>
      <div class="body">
        <div class="row">
          <div class="left">
            <p class="label">{{ s.label }}</p>
            <p v-if="s.formula" class="formula fg-mono">{{ s.formula }}</p>
          </div>
          <p v-if="s.result" class="result fg-num">{{ s.result }}</p>
        </div>
        <details v-if="s.why" class="why">
          <summary>{{ s.whyTitle || '为什么这样算？' }}</summary>
          <p>{{ s.why }}</p>
        </details>
      </div>
    </li>
  </ol>
</template>

<script setup lang="ts">
export interface TimelineStep {
  label: string
  formula?: string
  result?: string
  why?: string
  whyTitle?: string
}

defineProps<{ steps: TimelineStep[] }>()
</script>

<style scoped>
.step-timeline {
  list-style: none;
  margin: 0;
  padding: 0;
}

.step {
  position: relative;
  display: flex;
  gap: var(--fg-s4);
  padding: var(--fg-s3) 0;
}

/* 竖向发丝轴 */
.step::before {
  content: '';
  position: absolute;
  left: 11px;
  top: 0;
  bottom: 0;
  width: 1px;
  background: var(--fg-line);
}

.step:first-child::before {
  top: var(--fg-s4);
}

.step:last-child::before {
  bottom: auto;
  height: 50%;
}

.idx {
  position: relative;
  z-index: 1;
  flex: none;
  width: 24px;
  height: 24px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: var(--fg-surface);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: 50%;
  color: var(--fg-ink-muted);
  font-size: var(--fg-text-label);
}

.body {
  flex: 1;
  min-width: 0;
}

.row {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s4);
  min-height: 40px;
}

.label {
  margin: 0;
  font-size: var(--fg-text-body);
  color: var(--fg-ink);
}

.formula {
  margin: var(--fg-s1) 0 0;
  color: var(--fg-ink-muted);
}

.result {
  margin: 0;
  flex: none;
  font-size: var(--fg-text-lead);
  font-weight: 600;
  text-align: right;
  color: var(--fg-ink);
}

.why {
  margin-top: var(--fg-s2);
}

.why summary {
  cursor: pointer;
  font-size: var(--fg-text-label);
  color: var(--fg-accent);
  list-style: none;
}

.why summary::-webkit-details-marker {
  display: none;
}

.why p {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
  line-height: 1.7;
  color: var(--fg-ink-muted);
  max-width: 60ch;
}

/* 响应式新增：<768px 收紧间距，结果允许折行 */
@media (max-width: 767.98px) {
  .step {
    gap: var(--fg-s3);
    padding: var(--fg-s2) 0;
  }

  .row {
    flex-wrap: wrap;
    row-gap: 2px;
    min-height: 0;
  }

  .result {
    margin-left: auto;
    font-size: var(--fg-text-lead);
  }

  .why p {
    max-width: none;
  }
}
</style>
