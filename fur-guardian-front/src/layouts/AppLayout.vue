<template>
  <!-- App 壳：APK / HAP 带 ?app=1 进入，桌面与手机浏览器始终走下面的网页布局 -->
  <div v-if="isAppShell" class="app-shell-root">
    <header class="appbar">
      <div class="appbar-side">
        <button v-if="canGoBack" type="button" class="appbar-btn" aria-label="返回" @click="goBack">
          <ChevronLeft :size="24" class="fg-icon" />
        </button>
      </div>
      <h1 class="appbar-title">{{ appTitle }}</h1>
      <div class="appbar-side appbar-side--right">
        <PetSwitcher v-if="showPetSwitcher" />
      </div>
    </header>

    <main class="app-body">
      <router-view />
    </main>

    <nav class="tabbar" aria-label="主导航">
      <router-link
        v-for="tab in tabs"
        :key="tab.path"
        :to="tab.path"
        class="tabbar-item"
        :class="{ 'is-active': isTabActive(tab.path) }"
      >
        <component :is="tab.icon" :size="23" class="tabbar-icon" />
        <span class="tabbar-label">{{ tab.label }}</span>
      </router-link>
    </nav>
  </div>

  <div v-else class="app-layout">
    <header class="topbar">
      <div class="topbar-inner">
        <router-link to="/pets" class="wordmark">
          <PawPrint :size="20" class="wordmark-icon" />
          <span>FurGuardian</span>
        </router-link>

        <nav class="nav">
          <router-link
            v-for="item in navItems"
            :key="item.path"
            :to="item.path"
            class="nav-item"
            :class="{ 'is-active': isActive(item.path) }"
          >{{ item.label }}</router-link>
        </nav>

        <div class="topbar-right">
          <WeatherWidget />
          <PetSwitcher />
          <el-dropdown trigger="click" @command="handleCommand">
            <button type="button" class="user-entry">
              <span>{{ userStore.nickname || '用户' }}</span>
              <ChevronDown :size="16" class="fg-icon" />
            </button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">用户信息</el-dropdown-item>
                <el-dropdown-item command="settings">设置</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>

        <!-- 响应式新增：移动端汉堡按钮（桌面端 display:none） -->
        <button
          type="button"
          class="nav-toggle"
          :aria-label="mobileNavOpen ? '关闭导航菜单' : '打开导航菜单'"
          :aria-expanded="mobileNavOpen"
          aria-controls="mobile-nav"
          @click="mobileNavOpen = !mobileNavOpen"
        >
          <component :is="mobileNavOpen ? X : Menu" :size="22" class="fg-icon" />
        </button>
      </div>
    </header>

    <!-- 响应式新增：移动端折叠导航（桌面端不显示） -->
    <transition name="mobile-nav">
      <div v-if="mobileNavOpen" class="mobile-nav-mask" @click="closeMobileNav"></div>
    </transition>
    <transition name="mobile-nav">
      <nav v-if="mobileNavOpen" id="mobile-nav" class="mobile-nav" aria-label="移动端导航">
        <router-link
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          class="mobile-nav-item"
          :class="{ 'is-active': isActive(item.path) }"
          @click="closeMobileNav"
        >{{ item.label }}</router-link>

        <div class="mobile-nav-divider"></div>

        <router-link
          to="/profile"
          class="mobile-nav-item"
          :class="{ 'is-active': route.path === '/profile' }"
          @click="closeMobileNav"
        >用户信息</router-link>
        <router-link
          to="/settings"
          class="mobile-nav-item"
          :class="{ 'is-active': route.path === '/settings' }"
          @click="closeMobileNav"
        >设置</router-link>
        <button type="button" class="mobile-nav-item mobile-nav-item--danger" @click="logoutFromMobile">
          退出登录
        </button>
      </nav>
    </transition>

    <main class="app-main">
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  PawPrint,
  ChevronDown,
  ChevronLeft,
  Menu,
  X,
  Bell,
  BookOpen,
  MapPin,
  UserRound,
} from 'lucide-vue-next'
import { ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { usePetStore } from '@/stores/pet'
import PetSwitcher from '@/components/PetSwitcher.vue'
import WeatherWidget from '@/components/WeatherWidget.vue'
import { useReminderNotify } from '@/composables/useReminderNotify'
import { isAppShell } from '@/utils/appMode'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const petStore = usePetStore()

useReminderNotify()

const navItems = computed(() => {
  const items = [
    { path: '/pets', label: '我的宠物' },
    { path: '/foods', label: '食品库' },
    { path: '/reminders', label: '提醒' },
    { path: '/reports', label: '周报' },
    { path: '/knowledge', label: '知识库' },
    { path: '/nearby', label: '周边' },
  ]
  if (userStore.isAdmin) {
    items.push({ path: '/admin/users', label: '用户管理' })
  }
  return items
})

function isActive(path: string) {
  return route.path === path || route.path.startsWith(`${path}/`)
}

/* ---------- App 壳：底部任务栏 ---------- */
const tabs = [
  { path: '/pets', label: '宠物', title: '我的宠物', icon: PawPrint },
  { path: '/reminders', label: '提醒', title: '提醒', icon: Bell },
  { path: '/knowledge', label: '知识', title: '知识问答', icon: BookOpen },
  { path: '/nearby', label: '周边', title: '周边资源', icon: MapPin },
  { path: '/settings', label: '我的', title: '我的', icon: UserRound },
]

const tabPath = computed(() => tabs.find((t) => route.path === t.path)?.path ?? '')

const appTitle = computed(() => {
  const tab = tabs.find((t) => t.path === route.path)
  if (tab) return tab.title
  return (route.meta.title as string) || 'FurGuardian'
})

const canGoBack = computed(() => !tabPath.value)

function isTabActive(path: string) {
  if (path === '/settings') return route.path === '/settings' || route.path === '/profile'
  return route.path === path || route.path.startsWith(`${path}/`)
}

function goBack() {
  if (window.history.state?.back) {
    router.back()
    return
  }
  // 直接打开深层页面（没有历史）时，回到它所属的一级入口
  if (/^\/pets\/\d+\/(profile|nutrition)$/.test(route.path)) {
    router.push(route.path.replace(/\/(profile|nutrition)$/, ''))
  } else if (/^\/pets\/\d+/.test(route.path)) {
    router.push('/pets')
  } else if (route.path.startsWith('/reminders/')) {
    router.push('/reminders')
  } else if (route.path.startsWith('/reports/')) {
    router.push('/reports')
  } else if (route.path.startsWith('/foods/')) {
    router.push('/foods')
  } else if (route.path === '/profile') {
    router.push('/settings')
  } else {
    router.push('/pets')
  }
}

const petContextRoutes = ['/reminders', '/knowledge', '/nearby', '/reports', '/foods']
const showPetSwitcher = computed(
  () =>
    petContextRoutes.some((p) => route.path === p || route.path.startsWith(`${p}/`)) ||
    /^\/pets\/\d+/.test(route.path),
)

/* ---------- 响应式新增：移动端汉堡菜单状态 ---------- */
const mobileNavOpen = ref(false)
let desktopMq: MediaQueryList | null = null

function closeMobileNav() {
  mobileNavOpen.value = false
}

function onKeydown(e: KeyboardEvent) {
  if (e.key === 'Escape') closeMobileNav()
}

function onDesktopChange(e: MediaQueryListEvent) {
  if (e.matches) closeMobileNav()
}

watch(mobileNavOpen, (open) => {
  // 展开抽屉时锁定背景滚动
  document.body.style.overflow = open ? 'hidden' : ''
})

// 路由变化后自动收起
watch(() => route.path, closeMobileNav)

// App 壳切换一级页面时回到顶部
watch(
  () => route.fullPath,
  () => {
    if (isAppShell) window.scrollTo({ top: 0, left: 0 })
  },
)

onMounted(() => {
  petStore.fetchPets()
  void userStore.fetchProfile(true).catch(() => {
    // 资料刷新失败不阻塞页面，继续使用本地缓存
  })
  window.addEventListener('keydown', onKeydown)
  desktopMq = window.matchMedia('(min-width: 768px)')
  desktopMq.addEventListener('change', onDesktopChange)
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeydown)
  desktopMq?.removeEventListener('change', onDesktopChange)
  document.body.style.overflow = ''
})

async function logoutFromMobile() {
  closeMobileNav()
  try {
    await handleCommand('logout')
  } catch {
    // 用户取消退出
  }
}

async function handleCommand(cmd: string) {
  if (cmd === 'profile') {
    router.push('/profile')
  } else if (cmd === 'settings') {
    router.push('/settings')
  } else if (cmd === 'logout') {
    await ElMessageBox.confirm('确定退出登录吗？', '提示', { type: 'warning' })
    await userStore.logout()
    petStore.reset()
    router.push('/auth')
  }
}
</script>

<style scoped>
.app-layout {
  min-height: 100vh;
  background: transparent;
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 100;
  height: var(--fg-topbar-h);
  background-color: var(--fg-surface);
  background-image:
    linear-gradient(90deg, rgba(253, 251, 246, 0.78), rgba(250, 248, 242, 0.68)),
    url('/backgrounds/topbar-bg.png');
  background-position: center bottom;
  background-size: cover;
  background-repeat: no-repeat;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.topbar-inner {
  max-width: var(--fg-content-w);
  height: var(--fg-topbar-h);
  margin: 0 auto;
  padding: 0 var(--fg-s5);
  display: flex;
  align-items: center;
  gap: var(--fg-s6);
}

.wordmark {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  font-family: var(--fg-font-serif);
  font-size: 18px;
  font-weight: 600;
  letter-spacing: -0.01em;
  color: var(--fg-ink);
}

.wordmark-icon {
  color: var(--fg-accent);
}

.nav {
  display: flex;
  align-items: center;
  gap: var(--fg-s5);
  flex: 1;
  height: 100%;
}

.nav-item {
  position: relative;
  height: 100%;
  display: inline-flex;
  align-items: center;
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
  transition: color var(--fg-motion);
}

.nav-item:hover {
  color: var(--fg-ink);
}

.nav-item.is-active {
  color: var(--fg-ink);
  font-weight: 500;
}

.nav-item.is-active::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: -1px;
  height: 2px;
  background: var(--fg-accent);
}

.topbar-right {
  display: flex;
  align-items: center;
  gap: var(--fg-s4);
}

.user-entry {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  height: 32px;
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-body);
  color: var(--fg-ink);
}

.user-entry:hover {
  color: var(--fg-accent);
}

.app-main {
  min-height: calc(100vh - var(--fg-topbar-h));
}

/* ============================================================
   响应式新增：移动端汉堡导航
   以下基础规则在桌面端不参与任何布局（元素默认隐藏）。
   ============================================================ */
.nav-toggle {
  display: none;
}

.mobile-nav,
.mobile-nav-mask {
  display: none;
}

.mobile-nav-enter-active,
.mobile-nav-leave-active {
  transition: opacity var(--fg-motion), transform var(--fg-motion);
}

.mobile-nav-enter-from,
.mobile-nav-leave-to {
  opacity: 0;
}

.mobile-nav-enter-from.mobile-nav,
.mobile-nav-leave-to.mobile-nav {
  transform: translateY(-8px);
}

/* 响应式新增：6 个导航项在 768~1024px 会挤压品牌与右侧入口，先收窄间距 */
@media (max-width: 1023.98px) {
  .topbar-inner {
    gap: var(--fg-s4);
  }

  .nav {
    gap: var(--fg-s3);
  }
}

@media (max-width: 767.98px) {
  /* ---------- 响应式新增：顶栏紧凑化 ---------- */
  .topbar-inner {
    gap: var(--fg-s2);
    padding: 0 var(--fg-s3);
  }

  .wordmark {
    flex: none;
    font-size: 16px;
    gap: var(--fg-s1);
  }

  /* 横向导航改为汉堡菜单 */
  .nav {
    display: none;
  }

  .topbar-right {
    margin-left: auto;
    gap: var(--fg-s2);
    min-width: 0;
  }

  .topbar-right :deep(.pet-switcher) {
    width: auto;
    max-width: 92px;
  }

  .topbar-right :deep(.weather-chip) {
    height: 34px;
    padding: 0 8px;
  }

  .topbar-right :deep(.pet-switcher .el-select__wrapper) {
    padding-right: 2px;
  }

  /* 用户名入口收进折叠菜单 */
  .user-entry {
    display: none;
  }

  .nav-toggle {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    width: 44px;
    height: 44px;
    padding: 0;
    border: var(--fg-line-w) solid var(--fg-line);
    border-radius: var(--fg-radius);
    background: var(--fg-surface);
    color: var(--fg-ink);
    cursor: pointer;
  }

  .nav-toggle:active {
    background: var(--fg-paper);
  }

  /* ---------- 响应式新增：折叠导航面板 ---------- */
  .mobile-nav-mask {
    display: block;
    position: fixed;
    inset: var(--fg-topbar-h) 0 0;
    z-index: 98;
    background: rgba(22, 24, 26, 0.32);
  }

  .mobile-nav {
    display: flex;
    flex-direction: column;
    position: fixed;
    top: var(--fg-topbar-h);
    left: 0;
    right: 0;
    z-index: 99;
    max-height: calc(100vh - var(--fg-topbar-h));
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
    padding: var(--fg-s2) var(--fg-s4) calc(var(--fg-s4) + env(safe-area-inset-bottom));
    background: var(--fg-surface);
    border-bottom: var(--fg-line-w) solid var(--fg-line);
  }

  .mobile-nav-item {
    display: flex;
    align-items: center;
    min-height: 48px;
    padding: 0 var(--fg-s3);
    border: none;
    border-radius: var(--fg-radius);
    background: none;
    font-family: inherit;
    font-size: var(--fg-text-lead);
    color: var(--fg-ink);
    text-align: left;
    cursor: pointer;
  }

  .mobile-nav-item.is-active {
    background: var(--fg-accent-soft);
    color: var(--fg-accent);
    font-weight: 500;
  }

  .mobile-nav-divider {
    height: var(--fg-line-w);
    margin: var(--fg-s2) 0;
    background: var(--fg-line);
  }

  .mobile-nav-item--danger {
    color: var(--fg-danger);
  }
}

/* 超窄屏兜底：隐藏品牌文字，保证顶栏不溢出 */
@media (max-width: 359.98px) {
  .wordmark span {
    display: none;
  }
}

/* ============================================================
   App 壳：固定顶栏 + QQ 式底部任务栏
   ============================================================ */
.app-shell-root {
  min-height: 100vh;
}

.appbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 120;
  display: flex;
  align-items: center;
  height: calc(var(--fg-appbar-h) + env(safe-area-inset-top));
  padding: env(safe-area-inset-top) 6px 0;
  background: rgba(253, 251, 246, 0.94);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.appbar-side {
  flex: none;
  display: flex;
  align-items: center;
  width: 88px;
  min-width: 0;
}

.appbar-side--right {
  justify-content: flex-end;
  padding-right: 4px;
}

.appbar-title {
  flex: 1;
  min-width: 0;
  margin: 0;
  text-align: center;
  font-family: var(--fg-font-serif);
  font-size: 17px;
  font-weight: 600;
  letter-spacing: -0.01em;
  color: var(--fg-ink);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.appbar-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  padding: 0;
  border: 0;
  border-radius: 999px;
  background: none;
  color: var(--fg-ink);
  cursor: pointer;
}

.appbar-btn:active {
  background: var(--fg-paper);
}

.appbar-side--right :deep(.pet-switcher) {
  width: 84px;
}

.appbar-side--right :deep(.pet-switcher .el-select__wrapper) {
  min-height: 32px;
  padding: 0 2px 0 8px;
  background: var(--fg-paper);
  box-shadow: none;
  font-size: 13px;
}

.appbar-side--right :deep(.pet-current) {
  gap: 4px;
  font-size: 13px;
  color: var(--fg-ink-muted);
  max-width: 84px;
  overflow: hidden;
  white-space: nowrap;
}

.tabbar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 120;
  display: flex;
  align-items: stretch;
  height: calc(var(--fg-tabbar-h) + env(safe-area-inset-bottom));
  padding-bottom: env(safe-area-inset-bottom);
  background: rgba(255, 255, 255, 0.96);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.tabbar-item {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 3px;
  color: var(--fg-ink-muted);
  text-decoration: none;
  -webkit-user-select: none;
  user-select: none;
}

.tabbar-item.is-active {
  color: var(--fg-accent);
}

.tabbar-icon {
  transition: transform var(--fg-motion);
}

.tabbar-item.is-active .tabbar-icon {
  transform: translateY(-1px);
}

.tabbar-item:active .tabbar-icon {
  transform: scale(0.92);
}

.tabbar-label {
  font-size: 11px;
  line-height: 1;
  letter-spacing: 0.02em;
}

.tabbar-item.is-active .tabbar-label {
  font-weight: 600;
}
</style>
