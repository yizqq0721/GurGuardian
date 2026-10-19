<template>
  <div class="empty-state">
    <svg
      class="art"
      width="120"
      height="90"
      viewBox="0 0 120 90"
      fill="none"
      stroke="currentColor"
      stroke-width="1.5"
      stroke-linecap="round"
      stroke-linejoin="round"
      aria-hidden="true"
    >
      <!-- pets：牵引绳 + 空碗 -->
      <template v-if="variant === 'pets'">
        <path d="M20 62h56a10 10 0 0 1-4 8H24a10 10 0 0 1-4-8Z" />
        <path d="M76 44c0-10 8-16 16-16s14 6 14 14-6 12-12 12" />
        <circle cx="98" cy="26" r="5" />
      </template>

      <!-- foods：粮袋 + 放大镜 -->
      <template v-else-if="variant === 'foods'">
        <path d="M28 30h34v40a6 6 0 0 1-6 6H34a6 6 0 0 1-6-6V30Z" />
        <path d="M34 30v-8h22v8" />
        <circle cx="86" cy="42" r="14" />
        <path d="M96 52l12 12" />
      </template>

      <!-- search：猫剪影 + 问号 -->
      <template v-else-if="variant === 'search'">
        <path d="M30 70V40l-6-14 14 8h18l14-8-6 14v30" />
        <path d="M44 52h2" stroke-linecap="round" />
        <path d="M58 52h2" stroke-linecap="round" />
        <path d="M92 34a10 10 0 0 0-10 10v4" />
        <path d="M92 62a10 10 0 0 0 10-10 10 10 0 0 0-10-10" />
        <circle cx="92" cy="72" r="1.5" fill="currentColor" stroke="none" />
      </template>

      <!-- success：狗 + 对勾 -->
      <template v-else-if="variant === 'success'">
        <path d="M34 74V46c0-10 8-18 18-18s18 8 18 18v28" />
        <path d="M34 46l-10-8 4 14" />
        <path d="M70 46l10-8-4 14" />
        <circle cx="46" cy="52" r="1.5" fill="currentColor" stroke="none" />
        <circle cx="58" cy="52" r="1.5" fill="currentColor" stroke="none" />
        <circle cx="98" cy="30" r="12" />
        <path d="M93 30l4 4 7-8" />
      </template>

      <!-- warning：盾牌 + 脉搏线 -->
      <template v-else-if="variant === 'warning'">
        <path d="M60 14l26 10v22c0 16-11 26-26 30-15-4-26-14-26-30V24l26-10Z" />
        <path d="M44 46h8l4-8 6 14 4-6h10" />
      </template>

      <!-- default：空框 -->
      <template v-else>
        <rect x="26" y="22" width="68" height="46" rx="6" />
        <path d="M26 38h68" />
      </template>
    </svg>

    <p class="line">{{ description }}</p>
    <slot />
  </div>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    description: string
    variant?: 'pets' | 'foods' | 'search' | 'success' | 'warning' | 'default'
  }>(),
  { variant: 'default' },
)
</script>

<style scoped>
.empty-state {
  padding: var(--fg-s7) 0;
  text-align: center;
  color: var(--fg-ink-muted);
}

.art {
  color: var(--fg-accent);
  opacity: 0.55;
}

.line {
  margin: var(--fg-s4) 0 0;
  font-size: var(--fg-text-lead);
  color: var(--fg-ink-muted);
}
</style>
