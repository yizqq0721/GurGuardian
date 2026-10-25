<template>
  <router-link
    v-if="!userStore.location"
    to="/profile"
    class="weather-chip is-idle"
    aria-label="设置常用城市"
  >
    <MapPin :size="16" class="fg-icon" />
    <span class="chip-text">设置城市</span>
  </router-link>

  <el-popover
    v-else
    placement="bottom-end"
    :width="320"
    trigger="click"
    popper-class="weather-popper"
  >
    <template #reference>
      <button type="button" class="weather-chip" :class="levelClass" :aria-label="chipLabel">
        <Loader2 v-if="state === 'loading'" :size="16" class="fg-icon spin" />
        <component v-else :is="weatherIcon" :size="16" class="fg-icon" />
        <span v-if="weather" class="chip-temp fg-num">{{ weather.high }}°</span>
        <span class="chip-text">{{ weather ? weather.text : '天气' }}</span>
      </button>
    </template>

    <div class="wx-panel" :class="levelClass">
      <div class="wx-head">
        <span class="wx-loc">
          <MapPin :size="14" class="fg-icon" />
          <span>{{ userStore.location }}</span>
        </span>
        <router-link class="wx-locate" to="/profile">修改城市</router-link>
      </div>

      <template v-if="weather">
        <div class="wx-main">
          <component :is="weatherIcon" :size="36" class="wx-ico" />
          <div class="wx-summary">
            <p class="wx-temp fg-num">
              {{ weather.high }}°<span class="wx-low"> / {{ weather.low }}°</span>
            </p>
            <p class="wx-text">
              {{ weather.text
              }}<template v-if="weather.textNight && weather.textNight !== weather.text">转{{ weather.textNight }}</template>
            </p>
          </div>
        </div>
        <p class="wx-meta">
          {{ weather.windDirection }}风 {{ weather.windScale }}级<template v-if="weather.humidity"> · 湿度 {{ weather.humidity }}%</template>
        </p>
        <div class="wx-advice">
          <span class="wx-tag">{{ walkLabel }}</span>
          <span>{{ weather.advice }}</span>
        </div>
        <router-link class="wx-link" to="/reminders">
          查看遛弯提醒
          <ArrowRight :size="13" class="fg-icon" />
        </router-link>
      </template>

      <p v-else-if="state === 'loading'" class="wx-empty">正在获取今日天气…</p>
      <p v-else class="wx-empty">
        暂时取不到天气，请稍后重试。
        <button type="button" class="wx-retry" @click="loadWeather">重试</button>
      </p>
    </div>
  </el-popover>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import {
  ArrowRight,
  CloudLightning,
  CloudRain,
  CloudSun,
  Loader2,
  MapPin,
  Snowflake,
  Sun,
  Wind,
} from 'lucide-vue-next'
import { weatherApi } from '@/api/weather'
import { useUserStore } from '@/stores/user'
import type { WeatherToday } from '@/types'

const userStore = useUserStore()

const weather = ref<WeatherToday | null>(null)
const state = ref<'idle' | 'loading' | 'ready' | 'unavailable'>('idle')

const levelClass = computed(() =>
  weather.value ? `is-${weather.value.level.toLowerCase()}` : '',
)

const weatherIcon = computed(() => {
  const w = weather.value
  if (!w) return CloudSun
  const text = `${w.text}${w.textNight ?? ''}`
  if (text.includes('雷')) return CloudLightning
  if (text.includes('雪')) return Snowflake
  if (text.includes('雨')) return CloudRain
  if (text.includes('晴')) return Sun
  if (text.includes('风') || Number(w.windScale) >= 5) return Wind
  return CloudSun
})

const walkLabel = computed(() => {
  if (weather.value?.level === 'GOOD') return '适合遛狗'
  if (weather.value?.level === 'AVOID') return '不宜遛狗'
  return '谨慎遛狗'
})

const chipLabel = computed(() => {
  if (state.value === 'loading') return '正在获取今日天气'
  if (!weather.value) return '查看今日天气'
  return `今日${weather.value.text}，${weather.value.high}度，${walkLabel.value}`
})

async function loadWeather() {
  if (!userStore.location) {
    weather.value = null
    state.value = 'idle'
    return
  }
  if (state.value === 'loading') return
  state.value = 'loading'
  try {
    weather.value = await weatherApi.today()
    state.value = weather.value ? 'ready' : 'unavailable'
  } catch {
    state.value = 'unavailable'
  }
}

let refreshTimer: number | undefined

onMounted(() => {
  void loadWeather()
  refreshTimer = window.setInterval(() => void loadWeather(), 30 * 60 * 1000)
})

onBeforeUnmount(() => {
  if (refreshTimer) window.clearInterval(refreshTimer)
})

watch(() => userStore.location, () => {
  weather.value = null
  void loadWeather()
})
</script>

<style scoped>
.weather-chip {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 32px;
  padding: 0 10px;
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: 999px;
  background: var(--fg-surface);
  color: var(--fg-ink);
  font-family: inherit;
  font-size: var(--fg-text-label);
  white-space: nowrap;
  cursor: pointer;
  transition: border-color var(--fg-motion), background var(--fg-motion);
}

.weather-chip:hover {
  border-color: var(--fg-line-strong);
  background: var(--fg-paper);
}

.weather-chip:disabled {
  cursor: default;
  opacity: 0.7;
}

.weather-chip.is-idle {
  color: var(--fg-ink-muted);
}

.weather-chip.is-good .fg-icon {
  color: var(--fg-success);
}

.weather-chip.is-caution .fg-icon {
  color: var(--fg-warning);
}

.weather-chip.is-avoid .fg-icon {
  color: var(--fg-danger);
}

.chip-temp {
  font-weight: 600;
  color: var(--fg-ink);
}

.spin {
  animation: wx-spin 0.9s linear infinite;
}

@keyframes wx-spin {
  to {
    transform: rotate(360deg);
  }
}

.wx-panel {
  color: var(--fg-ink);
}

.wx-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s3);
  padding-bottom: var(--fg-s3);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.wx-loc {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  min-width: 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.wx-loc span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.wx-locate {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  flex: none;
  padding: 0;
  border: none;
  background: none;
  color: var(--fg-accent);
  font-family: inherit;
  font-size: var(--fg-text-label);
  cursor: pointer;
}

.wx-locate:disabled {
  cursor: default;
  opacity: 0.6;
}

.wx-main {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  padding: var(--fg-s3) 0 var(--fg-s2);
}

.wx-ico {
  flex: none;
  color: var(--fg-accent);
}

.wx-panel.is-caution .wx-ico {
  color: var(--fg-warning);
}

.wx-panel.is-avoid .wx-ico {
  color: var(--fg-danger);
}

.wx-summary {
  min-width: 0;
}

.wx-temp {
  margin: 0;
  font-size: 28px;
  line-height: 1.15;
  font-weight: 600;
}

.wx-low {
  font-size: var(--fg-text-body);
  font-weight: 400;
  color: var(--fg-ink-muted);
}

.wx-text {
  margin: 2px 0 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.wx-meta {
  margin: 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.wx-advice {
  display: flex;
  align-items: flex-start;
  gap: var(--fg-s2);
  margin-top: var(--fg-s3);
  padding: var(--fg-s2) var(--fg-s3);
  border-radius: var(--fg-radius);
  background: var(--fg-paper);
  font-size: var(--fg-text-label);
  line-height: 1.5;
}

.wx-panel.is-good .wx-advice {
  background: var(--fg-accent-soft);
  color: var(--fg-accent);
}

.wx-panel.is-caution .wx-advice {
  background: var(--fg-warning-soft);
  color: var(--fg-warning);
}

.wx-panel.is-avoid .wx-advice {
  background: var(--fg-danger-soft);
  color: var(--fg-danger);
}

.wx-tag {
  flex: none;
  font-weight: 600;
}

.wx-link {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  margin-top: var(--fg-s3);
  font-size: var(--fg-text-label);
  color: var(--fg-accent);
}

.wx-empty {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.wx-retry {
  padding: 0;
  border: none;
  background: none;
  color: var(--fg-accent);
  font-family: inherit;
  font-size: inherit;
  cursor: pointer;
}

@media (max-width: 1199.98px) {
  .chip-text {
    display: none;
  }

  .weather-chip.is-idle .chip-text {
    display: inline;
  }
}
</style>
