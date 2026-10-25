import { createRouter, createWebHistory } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { isAppShell } from '@/utils/appMode'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'landing',
      component: () => import('@/views/LandingView.vue'),
      meta: { public: true, title: '首页' },
    },
    {
      path: '/auth',
      name: 'auth',
      component: () => import('@/views/AuthView.vue'),
      meta: { public: true, title: '登录' },
    },
    {
      path: '/onboarding',
      name: 'onboarding',
      component: () => import('@/views/OnboardingView.vue'),
      meta: { title: '创建宠物档案' },
    },
    {
      path: '/',
      component: () => import('@/layouts/AppLayout.vue'),
      children: [
        { path: 'admin/users', name: 'admin-users', component: () => import('@/views/AdminUsersView.vue'), meta: { title: '用户管理', admin: true } },
        { path: 'pets', name: 'pets', component: () => import('@/views/PetsView.vue'), meta: { title: '我的宠物' } },
        { path: 'pets/:id', name: 'pet-home', component: () => import('@/views/PetHomeView.vue'), meta: { title: '宠物主页' } },
        { path: 'pets/:id/profile', name: 'pet-profile', component: () => import('@/views/PetProfileView.vue'), meta: { title: '宠物档案' } },
        { path: 'pets/:id/nutrition', name: 'nutrition', component: () => import('@/views/NutritionView.vue'), meta: { title: '营养方案' } },
        { path: 'foods', name: 'foods', component: () => import('@/views/FoodsView.vue'), meta: { title: '我的食品库' } },
        { path: 'foods/new', name: 'food-new', component: () => import('@/views/FoodFormView.vue'), meta: { title: '录入食品' } },
        { path: 'foods/:id/edit', name: 'food-edit', component: () => import('@/views/FoodFormView.vue'), meta: { title: '编辑食品' } },
        { path: 'reminders', name: 'reminders', component: () => import('@/views/RemindersView.vue'), meta: { title: '提醒管理' } },
        { path: 'reminders/calendar', name: 'reminder-calendar', component: () => import('@/views/ReminderCalendarView.vue'), meta: { title: '待办日历' } },
        { path: 'reports', name: 'reports', component: () => import('@/views/ReportsView.vue'), meta: { title: '周报列表' } },
        { path: 'reports/:id', name: 'report-detail', component: () => import('@/views/ReportDetailView.vue'), meta: { title: '周报详情' } },
        { path: 'knowledge', name: 'knowledge', component: () => import('@/views/KnowledgeView.vue'), meta: { title: '知识库' } },
        { path: 'nearby', name: 'nearby', component: () => import('@/views/NearbyView.vue'), meta: { title: '周边资源' } },
        { path: 'profile', name: 'profile', component: () => import('@/views/UserProfileView.vue'), meta: { title: '用户信息' } },
        { path: 'settings', name: 'settings', component: () => import('@/views/SettingsView.vue'), meta: { title: '设置' } },
      ],
    },
    { path: '/:pathMatch(.*)*', redirect: '/' },
  ],
})

router.beforeEach((to) => {
  document.title = to.meta.title ? `${to.meta.title} · FurGuardian` : 'FurGuardian · 养宠智能助手'
  const userStore = useUserStore()
  // App 壳里不展示营销落地页：已登录直接进宠物页，未登录直接进登录页
  if (isAppShell && to.name === 'landing') {
    return userStore.isLoggedIn ? { name: 'pets' } : { name: 'auth' }
  }
  if (!to.meta.public && !userStore.isLoggedIn) {
    ElMessage({ message: '请先登录', type: 'warning', grouping: true })
    return { name: 'auth', query: { redirect: to.fullPath } }
  }
  if (to.meta.admin && !userStore.isAdmin) {
    ElMessage({ message: '无权限访问管理后台', type: 'error', grouping: true })
    return { name: 'pets' }
  }
  return true
})

export default router
