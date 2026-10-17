<template>
  <el-container class="app-layout">
    <el-header class="app-header" height="60px">
      <div class="header-inner">
        <router-link to="/pets" class="logo">
          <span class="logo-icon">🐾</span>
          <span class="logo-text">FurGuardian</span>
        </router-link>

        <el-menu
          :default-active="activeMenu"
          mode="horizontal"
          :ellipsis="false"
          router
          class="nav-menu"
        >
          <el-menu-item index="/pets">我的宠物</el-menu-item>
          <el-menu-item index="/foods">食品库</el-menu-item>
          <el-menu-item index="/reminders">提醒</el-menu-item>
          <el-menu-item index="/reports">周报</el-menu-item>
          <el-menu-item index="/knowledge">知识库</el-menu-item>
        </el-menu>

        <div class="header-right">
          <PetSwitcher />
          <el-dropdown @command="handleCommand">
            <span class="user-entry">
              {{ userStore.nickname || '用户' }}
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="settings">设置</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </el-header>

    <el-main class="app-main">
      <router-view />
    </el-main>
  </el-container>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowDown } from '@element-plus/icons-vue'
import { ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { usePetStore } from '@/stores/pet'
import PetSwitcher from '@/components/PetSwitcher.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const petStore = usePetStore()

const activeMenu = computed(() => {
  const path = route.path
  if (path.startsWith('/foods')) return '/foods'
  if (path.startsWith('/reminders')) return '/reminders'
  if (path.startsWith('/reports')) return '/reports'
  if (path.startsWith('/knowledge')) return '/knowledge'
  return '/pets'
})

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
}

.app-header {
  background: #fff;
  border-bottom: 1px solid var(--fg-border);
  padding: 0;
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-inner {
  max-width: 1200px;
  margin: 0 auto;
  height: 60px;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 0 24px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 700;
  font-size: 18px;
  color: var(--fg-ink);
}

.logo-icon {
  font-size: 22px;
}

.nav-menu {
  flex: 1;
  border-bottom: none;
  background: transparent;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-entry {
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 4px;
  color: var(--fg-ink);
}

.app-main {
  padding: 0;
}
</style>
