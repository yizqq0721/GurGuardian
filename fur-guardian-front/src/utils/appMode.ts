const STORAGE_KEY = 'fg_app_shell'

/**
 * APK / HAP 壳加载站内地址时带 ?app=1，据此切换到 App 布局。
 * Capacitor 原生环境同样直接判定，避免首次加载丢掉参数。
 * 标记写入 localStorage，后续启动即使不带参数也保持 App 形态；手机浏览器不受影响。
 */
function detectAppShell(): boolean {
  try {
    const capacitor = (window as unknown as { Capacitor?: { isNativePlatform?: () => boolean } }).Capacitor
    if (typeof capacitor?.isNativePlatform === 'function' && capacitor.isNativePlatform()) {
      localStorage.setItem(STORAGE_KEY, '1')
      return true
    }
    if (new URLSearchParams(window.location.search).get('app') === '1') {
      localStorage.setItem(STORAGE_KEY, '1')
      return true
    }
    return localStorage.getItem(STORAGE_KEY) === '1'
  } catch {
    return false
  }
}

export const isAppShell = detectAppShell()

/** 首屏路由已经带上了标记，随后把参数从地址栏去掉，避免分享链接把网页也切成 App 形态 */
export function stripAppFlag() {
  if (!isAppShell) return
  const url = new URL(window.location.href)
  if (!url.searchParams.has('app')) return
  url.searchParams.delete('app')
  window.history.replaceState(window.history.state, '', `${url.pathname}${url.search}${url.hash}`)
}
