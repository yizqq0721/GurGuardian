<template>
  <div class="fg-page">
    <PageHeader
      title="周边资源"
      breadcrumb="工具 / 周边资源"
      description="以当前位置为圆心查找宠物医院等医疗资源与可散步的公园，并可查看步行路线。"
    />

    <div v-if="!amapKeyConfigured" class="fg-callout key-callout">
      未配置高德 JS Key（VITE_AMAP_JS_KEY），地图与标记不可用；请在 .env.local 中填写后重启前端。
    </div>

    <!-- 从遛弯提醒深链进来时，打卡结果回写到该提醒 -->
    <section v-if="linkedReminderId" class="link-banner fg-card">
      <div class="banner-main">
        <MapPin :size="20" class="fg-icon banner-ico" />
        <div>
          <p class="banner-title">正在为「{{ linkedReminderTitle }}」找遛弯地点</p>
          <p class="banner-hint fg-muted">
            选一处公园，走完后点卡片上的「完成遛弯打卡」，地点会记进这次打卡的备注。
          </p>
        </div>
      </div>
      <el-button text size="small" @click="backToReminder">返回提醒</el-button>
    </section>

    <!-- 正在定位 -->
    <div v-if="geoStatus === 'locating'" class="state-card fg-card">
      <span class="fg-dot"></span>
      <span>正在获取当前位置…</span>
    </div>

    <!-- 定位失败 / 未授权 -->
    <div v-else-if="geoStatus !== 'ok'" class="state-card fg-card">
      <EmptyState variant="warning" :description="geoMessage">
        <div class="state-actions">
          <el-button type="primary" @click="locate">重新定位</el-button>
          <span class="state-hint">定位需要 HTTPS 访问，并在浏览器弹窗中允许「位置」权限。</span>
        </div>
      </EmptyState>
    </div>

    <template v-else>
      <!-- 工具条 -->
      <section class="toolbar fg-card">
        <div class="locate-info">
          <span class="fg-dot fg-dot--success"></span>
          <span class="locate-text">已定位{{ accuracyText }}</span>
          <el-button size="small" @click="locate">
            <LocateFixed :size="14" class="fg-icon" />
            重新定位
          </el-button>
        </div>
        <div class="filters">
          <el-segmented v-model="category" :options="categoryOptions" size="small" />
          <el-select v-model="radius" size="small" class="radius-select">
            <el-option label="1 公里内" :value="1000" />
            <el-option label="3 公里内" :value="3000" />
            <el-option label="5 公里内" :value="5000" />
          </el-select>
        </div>
      </section>

      <!-- 地图 -->
      <section v-if="amapKeyConfigured" class="map-card fg-card">
        <div ref="mapEl" class="map"></div>
        <div v-if="mapError" class="map-error-overlay">
          <p>{{ mapError }}</p>
        </div>
      </section>

      <!-- 步行路线信息条 -->
      <section v-if="routeInfo" class="route-bar fg-card">
        <div class="route-main">
          <Footprints :size="20" class="fg-icon route-icon" />
          <div class="route-text">
            <p class="route-title">步行至 {{ routeInfo.place.name }}</p>
            <p class="route-meta">
              全程 <span class="fg-num">{{ formatDistance(routeInfo.distanceMeters) }}</span>
              <span class="route-sep">·</span>
              约 <span class="fg-num">{{ formatDuration(routeInfo.durationSeconds) }}</span>
            </p>
          </div>
        </div>
        <div class="route-actions">
          <a class="gaode-link" :href="gaodeWalkUrl" target="_blank" rel="noopener">
            在高德步行导航
            <ExternalLink :size="14" class="fg-icon" />
          </a>
          <el-button text size="small" @click="clearRoute()">清除路线</el-button>
        </div>
      </section>

      <!-- 结果列表 -->
      <section class="results">
        <h2 class="fg-section-title">
          {{ categoryLabel }} · {{ radiusLabel }}内
          <span v-if="placesStatus === 'ok'" class="fg-chip">{{ places.length }} 处</span>
        </h2>

        <div v-if="placesStatus === 'loading'" class="loading-line">
          <span class="fg-dot"></span>
          <span>正在查询周边{{ categoryLabel }}…</span>
        </div>

        <div v-else-if="placesStatus === 'error'" class="fg-callout fg-callout--danger error-line">
          <span>{{ placesError }}</span>
          <el-button type="primary" plain size="small" @click="loadPlaces">重试</el-button>
        </div>

        <EmptyState
          v-else-if="!places.length"
          variant="search"
          :description="`${radiusLabel}内没有找到${categoryLabel}。`"
        >
          <el-button v-if="radius < 5000" size="small" @click="radius = 5000">扩大到 5 公里</el-button>
        </EmptyState>

        <div v-else class="place-list">
          <article
            v-for="p in visiblePlaces"
            :id="`place-card-${p.id}`"
            :key="p.id"
            class="place-card fg-card"
            :class="{ 'is-active': p.id === activeId }"
            @click="selectPlace(p)"
          >
            <div class="place-head">
              <span
                class="place-kind"
                :class="category === 'medical' ? 'place-kind--medical' : 'place-kind--park'"
              >
                <Stethoscope v-if="category === 'medical'" :size="13" class="fg-icon" />
                <Trees v-else :size="13" class="fg-icon" />
                {{ category === 'medical' ? '医院' : '公园' }}
              </span>
              <h3 class="place-name">{{ p.name }}</h3>
              <span class="fg-chip">{{ typeLabel(p.type) }}</span>
              <span class="place-distance fg-num">{{ formatDistance(p.distanceMeters) }}</span>
            </div>
            <p v-if="p.address" class="place-meta">{{ p.address }}</p>
            <p v-if="p.tel" class="place-meta">
              <span class="meta-label">电话</span>{{ normalizeTel(p.tel) }}
            </p>
            <div class="place-actions">
              <el-button
                size="small"
                type="primary"
                plain
                :loading="walkingId === p.id"
                @click.stop="walkTo(p)"
              >
                <Footprints :size="14" class="fg-icon" />
                步行路线
              </el-button>
              <el-button
                v-if="linkedReminderId && category === 'park'"
                type="primary"
                size="small"
                :loading="checkinId === p.id"
                @click.stop="checkinPlace(p)"
              >完成遛弯打卡</el-button>
              <a v-else class="gaode-link" :href="gaodeMarkerUrl(p)" target="_blank" rel="noopener" @click.stop>
                在高德打开
                <ExternalLink :size="14" class="fg-icon" />
              </a>
            </div>
          </article>
        </div>

        <div v-if="places.length > 4" class="list-toggle">
          <el-button text size="small" @click="listExpanded = !listExpanded">
            <ChevronDown
              :size="14"
              class="fg-icon toggle-chevron"
              :class="{ 'is-open': listExpanded }"
            />
            {{ listExpanded ? '收起' : `展开其余 ${places.length - 4} 处` }}
          </el-button>
        </div>
      </section>
    </template>

    <p class="fg-disclaimer">
      周边信息来自高德地图开放平台，距离为直线距离；步行路线为高德规划结果，出行请以实际路况为准。
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'
import { ExternalLink, ChevronDown, Footprints, LocateFixed, MapPin, Stethoscope, Trees } from 'lucide-vue-next'
import PageHeader from '@/components/PageHeader.vue'
import EmptyState from '@/components/EmptyState.vue'
import { placesApi } from '@/api/places'
import { reminderApi } from '@/api/reminder'
import { AMAP_JS_KEY, loadAMap } from '@/utils/amap'
import { saveGeo, wgs84ToGcj02 } from '@/utils/geo'
import type { NearbyPlace, PlaceCategory, WalkRoute } from '@/types'

const DEFAULT_CENTER = { lng: 116.397428, lat: 39.90923 } // 未定位前的兜底视图：天安门

const amapKeyConfigured = Boolean(AMAP_JS_KEY)

const route = useRoute()
const router = useRouter()

/* 从提醒页「找遛弯点」深链进来时，记录来源提醒用于回写打卡 */
const linkedReminderId = computed(() => {
  const id = Number(route.query.reminderId)
  return Number.isInteger(id) && id > 0 ? id : null
})
const linkedReminderTitle = computed(() => {
  const title = route.query.reminderTitle
  return typeof title === 'string' && title.trim() ? title.trim() : '遛弯提醒'
})
const linkedPetId = computed(() => {
  const id = Number(route.query.petId)
  return Number.isInteger(id) && id > 0 ? id : undefined
})

const mapEl = ref<HTMLDivElement>()

const geoStatus = ref<'locating' | 'ok' | 'denied' | 'error'>('locating')
const geoMessage = ref('定位未成功')
const accuracy = ref<number | null>(null)
const center = ref<{ lng: number; lat: number } | null>(null)

const category = ref<PlaceCategory>(route.query.category === 'park' ? 'park' : 'medical')
const radius = ref(3000)
const categoryOptions = [
  { label: '宠物医疗', value: 'medical' },
  { label: '散步公园', value: 'park' },
]

const places = ref<NearbyPlace[]>([])
const placesStatus = ref<'idle' | 'loading' | 'ok' | 'error'>('idle')
const placesError = ref('')
const activeId = ref('')
const listExpanded = ref(false)
const visiblePlaces = computed(() => (listExpanded.value ? places.value : places.value.slice(0, 4)))

const routeInfo = ref<{ place: NearbyPlace; distanceMeters: number; durationSeconds: number } | null>(null)
const walkingId = ref('')
const checkinId = ref('')
const mapError = ref('')

let AMapRef: any = null
let map: any = null
let mapInitPending = false
let userMarker: any = null
let routeLine: any = null
let routeEndMarker: any = null
let markerList: any[] = []

const categoryLabel = computed(() => (category.value === 'medical' ? '宠物医疗' : '散步公园'))
const radiusLabel = computed(() => (radius.value === 1000 ? '1 公里' : radius.value === 5000 ? '5 公里' : '3 公里'))
const accuracyText = computed(() =>
  accuracy.value ? `（±${Math.round(accuracy.value)} 米）` : '',
)

const gaodeWalkUrl = computed(() => {
  if (!routeInfo.value || !center.value) return ''
  const p = routeInfo.value.place
  return `https://uri.amap.com/navigation?from=${center.value.lng},${center.value.lat},我的位置` +
    `&to=${p.lng},${p.lat},${encodeURIComponent(p.name)}&mode=walk&policy=1&src=furguardian&coordinate=gaode&callnative=0`
})

function gaodeMarkerUrl(p: NearbyPlace) {
  return `https://uri.amap.com/marker?position=${p.lng},${p.lat}&name=${encodeURIComponent(p.name)}` +
    '&src=furguardian&coordinate=gaode&callnative=0'
}

function formatDistance(meters: number) {
  return meters < 1000 ? `${meters} 米` : `${(meters / 1000).toFixed(1)} 公里`
}

function formatDuration(seconds: number) {
  return `${Math.max(1, Math.round(seconds / 60))} 分钟`
}

function typeLabel(type: string) {
  const last = type.split(';').filter(Boolean).pop()
  return last || '周边'
}

function normalizeTel(tel: string) {
  return tel.split(';').filter(Boolean).join(' / ')
}

/* ---------- 定位 ---------- */

function locate() {
  if (!('geolocation' in navigator)) {
    geoStatus.value = 'error'
    geoMessage.value = '当前浏览器不支持定位，请更换现代浏览器后重试。'
    return
  }
  geoStatus.value = 'locating'
  navigator.geolocation.getCurrentPosition(
    (pos) => {
      // 浏览器给的是 WGS-84，高德底图与接口都用 GCJ-02，必须换算
      const [lng, lat] = wgs84ToGcj02(pos.coords.longitude, pos.coords.latitude)
      saveGeo(lat, lng)
      center.value = { lng, lat }
      accuracy.value = pos.coords.accuracy ?? null
      geoStatus.value = 'ok'
      clearRoute()
      if (map) {
        map.setZoomAndCenter(15, [lng, lat])
        renderUserMarker()
      } else {
        // 高德脚本可能先于定位加载完，当时容器还没挂载，这里补建地图
        initMap()
      }
      loadPlaces()
    },
    (err) => {
      geoStatus.value = err.code === err.PERMISSION_DENIED ? 'denied' : 'error'
      geoMessage.value = err.code === err.PERMISSION_DENIED
        ? '未获得定位权限，无法查询周边资源。请在浏览器地址栏的权限设置中允许「位置」。'
        : '定位失败，请检查系统定位服务或网络后重试。'
    },
    { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 },
  )
}

/* ---------- 周边查询 ---------- */

async function loadPlaces() {
  if (!center.value) return
  placesStatus.value = 'loading'
  try {
    places.value = await placesApi.nearby({
      lat: center.value.lat,
      lng: center.value.lng,
      category: category.value,
      radius: radius.value,
    })
    placesStatus.value = 'ok'
    activeId.value = ''
    listExpanded.value = false
    renderMarkers(true)
  } catch (e) {
    placesStatus.value = 'error'
    placesError.value = (e as Error).message || '周边查询失败，请稍后重试'
  }
}

watch(category, () => {
  if (geoStatus.value !== 'ok') return
  clearRoute()
  loadPlaces()
})

watch(radius, () => {
  if (geoStatus.value !== 'ok') return
  loadPlaces()
})

/* ---------- 地图渲染 ---------- */

async function initMap() {
  if (!amapKeyConfigured || map || mapInitPending) return
  mapInitPending = true
  try {
    const AMap = await loadAMap()
    AMapRef = AMap
    await nextTick()
    // 定位成功前地图容器不渲染；此时若容器还没出现，定位回调会再调一次本函数
    if (!mapEl.value || map) return
    map = new AMap.Map(mapEl.value, {
      viewMode: '2D',
      zoom: 14,
      center: [DEFAULT_CENTER.lng, DEFAULT_CENTER.lat],
      mapStyle: 'amap://styles/whitesmoke',
      rotateEnable: false,
      pitchEnable: false,
      resizeEnable: true,
    })
    if (geoStatus.value === 'ok' && center.value) {
      map.setZoomAndCenter(15, [center.value.lng, center.value.lat])
      renderUserMarker()
    }
    if (places.value.length) {
      renderMarkers(true)
    }
  } catch (e) {
    mapError.value = (e as Error).message
  } finally {
    mapInitPending = false
  }
}

function renderUserMarker() {
  if (!map || !AMapRef || !center.value) return
  userMarker?.setMap(null)
  userMarker = new AMapRef.Marker({
    position: [center.value.lng, center.value.lat],
    content: '<div class="nby-me"></div>',
    offset: new AMapRef.Pixel(-7, -7),
    zIndex: 130,
  })
  userMarker.setMap(map)
}

function renderMarkers(fitView = false) {
  markerList.forEach((m) => m.setMap(null))
  markerList = []
  if (!map || !AMapRef) return
  for (const p of places.value) {
    const marker = new AMapRef.Marker({
      position: [p.lng, p.lat],
      content: pinHtml(p.id === activeId.value),
      offset: new AMapRef.Pixel(-15, -15),
      zIndex: p.id === activeId.value ? 120 : 100,
    })
    marker.on('click', () => selectMarker(p))
    marker.setMap(map)
    markerList.push(marker)
  }
  // 手机地图卡片只有 300px 高，按定位点 zoom 15 铺开时周边标记几乎全在视口外
  if (fitView && markerList.length) {
    const overlays = userMarker ? [...markerList, userMarker] : markerList
    map.setFitView(overlays, false, [40, 40, 40, 40], 15)
  }
}

function pinHtml(active: boolean) {
  /* 十字在手机小图上仍像普通医疗点，医院改用爪印；公园用松树，两者一眼可分 */
  const glyph = category.value === 'medical'
    ? '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="4" r="2"/><circle cx="18" cy="8" r="2"/><circle cx="20" cy="16" r="2"/><path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z"/></svg>'
    : '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="m17 14 3 3.3a1 1 0 0 1-.7 1.7H4.7a1 1 0 0 1-.7-1.7L7 14h-.3a1 1 0 0 1-.7-1.7L9 9h-.2A1 1 0 0 1 8 7.3L12 3l4 4.3a1 1 0 0 1-.8 1.7H15l3 3.3a1 1 0 0 1-.7 1.7H17Z"/><path d="M12 22v-3"/></svg>'
  return `<div class="nby-pin${active ? ' is-active' : ''}">${glyph}</div>`
}

function selectPlace(p: NearbyPlace) {
  activeId.value = p.id
  renderMarkers()
  if (map && AMapRef) {
    map.setZoom(Math.max(map.getZoom() ?? 15, 15))
    map.panTo([p.lng, p.lat])
  }
}

function selectMarker(p: NearbyPlace) {
  selectPlace(p)
  document.getElementById(`place-card-${p.id}`)?.scrollIntoView({ behavior: 'smooth', block: 'center' })
}

/* ---------- 步行路线 ---------- */

async function walkTo(p: NearbyPlace) {
  if (!center.value) return
  walkingId.value = p.id
  activeId.value = p.id
  renderMarkers()
  try {
    const route = await placesApi.walk(center.value, { lat: p.lat, lng: p.lng })
    drawRoute(route, p)
    routeInfo.value = {
      place: p,
      distanceMeters: route.distanceMeters,
      durationSeconds: route.durationSeconds,
    }
  } catch {
    // 失败提示已由请求拦截器统一弹出
  } finally {
    walkingId.value = ''
  }
}

function drawRoute(route: WalkRoute, p: NearbyPlace) {
  if (!map || !AMapRef) return
  routeLine?.setMap(null)
  const accent = getComputedStyle(document.documentElement).getPropertyValue('--fg-accent').trim() || '#1f5c4a'
  routeLine = new AMapRef.Polyline({
    path: route.polyline.map(([lng, lat]) => new AMapRef.LngLat(lng, lat)),
    strokeColor: accent,
    strokeWeight: 5,
    strokeOpacity: 0.85,
    lineJoin: 'round',
    lineCap: 'round',
    showDir: true,
    isOutline: true,
    outlineColor: '#ffffff',
    outlineWeight: 1,
    zIndex: 90,
  })
  routeLine.setMap(map)
  map.setFitView([routeLine], false, [60, 60, 60, 60])

  // 目的地画一个终点徽标，避免路线尽头没有锚点
  routeEndMarker?.setMap(null)
  routeEndMarker = new AMapRef.Marker({
    position: [p.lng, p.lat],
    content: '<div class="nby-end"></div>',
    offset: new AMapRef.Pixel(-5, -5),
    zIndex: 125,
  })
  routeEndMarker.setMap(map)
}

function clearRoute() {
  routeLine?.setMap(null)
  routeLine = null
  routeEndMarker?.setMap(null)
  routeEndMarker = null
  routeInfo.value = null
}

/* ---------- 遛弯打卡回写 ---------- */

function backToReminder() {
  router.push({
    path: '/reminders',
    query: linkedPetId.value ? { pet: String(linkedPetId.value) } : {},
  })
}

async function checkinPlace(place: NearbyPlace) {
  const id = linkedReminderId.value
  if (!id) return
  checkinId.value = place.id
  try {
    await reminderApi.checkin(id, {
      doneDate: dayjs().format('YYYY-MM-DD'),
      note: place.name.slice(0, 255),
    })
    ElMessage.success(`已用「${place.name}」完成遛弯打卡`)
    backToReminder()
  } catch {
    // 失败提示已由请求拦截器统一弹出
  } finally {
    checkinId.value = ''
  }
}

/* ---------- 生命周期 ---------- */

onMounted(() => {
  initMap()
  locate()
})

onBeforeUnmount(() => {
  routeLine?.setMap(null)
  routeEndMarker?.setMap(null)
  markerList.forEach((m) => m.setMap(null))
  map?.destroy()
  map = null
  AMapRef = null
})
</script>

<style scoped>
.key-callout {
  margin-bottom: var(--fg-s5);
}

/* ---------- 提醒深链提示条 ---------- */
.link-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: var(--fg-s3) var(--fg-s4);
  margin-bottom: var(--fg-s5);
  border-left: 3px solid var(--fg-accent);
}

.banner-main {
  display: flex;
  align-items: flex-start;
  gap: var(--fg-s3);
  min-width: 0;
}

.banner-ico {
  flex-shrink: 0;
  margin-top: 2px;
  color: var(--fg-accent);
}

.banner-title {
  margin: 0;
  font-weight: 600;
}

.banner-hint {
  margin: var(--fg-s1) 0 0;
  font-size: var(--fg-text-label);
}

.state-card {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  color: var(--fg-ink-muted);
}

.state-card .fg-dot {
  background: var(--fg-accent);
}

.state-actions {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--fg-s2);
  margin-top: var(--fg-s2);
}

.state-hint {
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

/* ---------- 工具条 ---------- */
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: var(--fg-s3) var(--fg-s5);
  margin-bottom: var(--fg-s5);
}

.locate-info {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  color: var(--fg-ink);
  font-size: var(--fg-text-body);
}

.filters {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.radius-select {
  width: 112px;
}

/* ---------- 地图 ---------- */
.map-card {
  padding: 0;
  overflow: hidden;
  margin-bottom: var(--fg-s5);
}

.map {
  width: 100%;
  height: 400px;
  background: var(--fg-paper);
}

.map-error-overlay {
  padding: var(--fg-s4) var(--fg-s5);
  border-top: var(--fg-line-w) solid var(--fg-line);
  color: var(--fg-ink-muted);
}

.map-error-overlay p {
  margin: 0;
}

/* 地图标记注入的是原生 DOM，样式必须穿过 scoped 作用域 */
.map :deep(.nby-pin) {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: var(--fg-surface);
  border: 2px solid var(--fg-accent);
  color: var(--fg-accent);
  cursor: pointer;
  transition: background var(--fg-motion), color var(--fg-motion);
}

.map :deep(.nby-pin.is-active) {
  background: var(--fg-accent);
  color: var(--fg-surface);
}

.map :deep(.nby-me) {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: var(--fg-accent);
  border: 3px solid var(--fg-surface);
  box-shadow: 0 0 0 6px rgba(31, 92, 74, 0.15);
}

.map :deep(.nby-end) {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--fg-warning);
  border: 2px solid var(--fg-surface);
}

/* ---------- 路线信息条 ---------- */
.route-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: var(--fg-s3) var(--fg-s5);
  margin-bottom: var(--fg-s5);
}

.route-main {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.route-icon {
  color: var(--fg-accent);
}

.route-text p {
  margin: 0;
}

.route-title {
  font-weight: 500;
  color: var(--fg-ink);
}

.route-meta {
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
}

.route-sep {
  margin: 0 var(--fg-s1);
}

.route-actions {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

/* ---------- 结果列表 ---------- */
.results :deep(.empty-state) {
  text-align: center;
}

.loading-line,
.error-line {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  color: var(--fg-ink-muted);
}

.loading-line .fg-dot {
  background: var(--fg-accent);
}

.place-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--fg-s4);
}

.place-card {
  cursor: pointer;
  transition: border-color var(--fg-motion);
  border-left: 3px solid transparent;
  display: flex;
  flex-direction: column;
  height: 196px;
  overflow: hidden;
}

/* 全局 .fg-card + .fg-card 的堆叠间距在网格里会让相邻卡片错位 */
.place-list .place-card {
  margin-top: 0;
}

.place-card:hover {
  border-color: var(--fg-line-strong);
}

.place-card.is-active {
  border-left-color: var(--fg-accent);
  border-top-color: var(--fg-line);
  border-right-color: var(--fg-line);
  border-bottom-color: var(--fg-line);
}

.place-head {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  flex-wrap: nowrap;
}

.place-head .fg-chip {
  flex-shrink: 0;
}

.place-kind {
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  height: 22px;
  padding: 0 var(--fg-s2);
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
  line-height: 1;
}

.place-kind--medical {
  color: #b42318;
  background: #fdeceb;
  border: 1px solid #f2b8b5;
}

.place-kind--park {
  color: #1f7a4d;
  background: #e9f6ee;
  border: 1px solid #b6ddc6;
}

.place-name {
  font-family: var(--fg-font-sans);
  font-size: var(--fg-text-lead);
  font-weight: 500;
  letter-spacing: 0;
  margin: 0;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.place-distance {
  margin-left: auto;
  flex-shrink: 0;
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
}

.place-meta {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.meta-label {
  display: inline-block;
  margin-right: var(--fg-s1);
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.place-actions {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  margin-top: auto;
  padding-top: var(--fg-s3);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.gaode-link {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s1);
  font-size: var(--fg-text-body);
}

/* ---------- 展开/收起 ---------- */
.list-toggle {
  display: flex;
  justify-content: center;
  margin-top: var(--fg-s4);
}

.list-toggle .el-button {
  gap: var(--fg-s1);
}

.toggle-chevron {
  transition: transform var(--fg-motion);
}

.toggle-chevron.is-open {
  transform: rotate(180deg);
}

/* ---------- 移动端 ---------- */
@media (max-width: 767.98px) {
  .map {
    height: 300px;
  }

  .toolbar {
    flex-direction: column;
    align-items: stretch;
  }

  .filters {
    justify-content: space-between;
  }

  .filters :deep(.el-segmented) {
    flex: 1;
  }

  .place-list {
    grid-template-columns: minmax(0, 1fr);
    gap: var(--fg-s3);
  }

  .route-bar {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>