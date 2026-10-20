<template>
  <div class="app-layout">
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
          <PetSwitcher />
          <el-dropdown trigger="click" @command="handleCommand">
            <button type="button" class="user-entry">
              <span>{{ userStore.nickname || '用户' }}</span>
              <ChevronDown :size="16" class="fg-icon" />
            </button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="settings">设置</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </header>

    <main class="app-main">
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { PawPrint, ChevronDown } from 'lucide-vue-next'
import { ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { usePetStore } from '@/stores/pet'
import PetSwitcher from '@/components/PetSwitcher.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const petStore = usePetStore()

const navItems = [
  { path: '/pets', label: '我的宠物' },
  { path: '/foods', label: '食品库' },
  { path: '/reminders', label: '提醒' },
  { path: '/reports', label: '周报' },
  { path: '/knowledge', label: '知识库' },
]

function isActive(path: string) {
  return route.path === path || route.path.startsWith(`${path}/`)
}

onMounted(() => {
  petStore.fetchPets()
})

async function handleCommand(cmd: string) {
  if (cmd === 'settings') {
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
  background: var(--fg-paper);
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 100;
  height: var(--fg-topbar-h);
  background: var(--fg-surface);
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
</style>
