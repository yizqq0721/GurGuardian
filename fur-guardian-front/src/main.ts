import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import 'element-plus/dist/index.css'

// 自托管字体：只引入实际用到的字重与子集，避免断网/CDN 被墙时退化成系统字体
import '@fontsource/noto-serif-sc/latin-600.css'
import '@fontsource/noto-serif-sc/chinese-simplified-600.css'
import '@fontsource/noto-sans-sc/latin-400.css'
import '@fontsource/noto-sans-sc/latin-500.css'
import '@fontsource/noto-sans-sc/chinese-simplified-400.css'
import '@fontsource/noto-sans-sc/chinese-simplified-500.css'
import '@fontsource/inter/latin-400.css'
import '@fontsource/inter/latin-500.css'
import '@fontsource/inter/latin-600.css'
import '@fontsource/ibm-plex-mono/latin-400.css'
import '@fontsource/ibm-plex-mono/latin-500.css'

// tokens.css 必须在 element-plus 之后，才能覆盖 EP 的 CSS 变量
import '@/styles/tokens.css'
import '@/styles/index.css'
// 响应式新增：移动端全局适配（仅 <768px 生效）
import '@/styles/responsive.css'
// App 壳：仅 APK/HAP 带 ?app=1 进入，手机浏览器不受影响
import '@/styles/app-shell.css'
import App from './App.vue'
import router from './router'
import { isAppShell, stripAppFlag } from '@/utils/appMode'

document.documentElement.classList.toggle('app-shell', isAppShell)

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.use(ElementPlus, { locale: zhCn })
app.mount('#app')

router.isReady().then(stripAppFlag)
