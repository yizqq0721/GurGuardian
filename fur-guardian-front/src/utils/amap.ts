/* ============================================================
   高德 JS API 2.0 轻量加载器。
   - 只在进入周边页时才注入 script（不拖慢首屏）；
   - 模块级 Promise 去重，重复调用共享同一次加载；
   - 安全密钥必须在脚本加载前挂到 window._AMapSecurityConfig，
     2021-12 以后申请的 Web 端 Key 默认启用安全密钥，漏挂会鉴权失败。
   ============================================================ */

export const AMAP_JS_KEY: string = import.meta.env.VITE_AMAP_JS_KEY || ''

let loadPromise: Promise<any> | null = null

export function loadAMap(): Promise<any> {
  if (loadPromise) {
    return loadPromise
  }
  if (!AMAP_JS_KEY) {
    return Promise.reject(new Error('未配置高德 JS Key（VITE_AMAP_JS_KEY）'))
  }

  const securityCode: string = import.meta.env.VITE_AMAP_SECURITY_CODE || ''
  ;(window as any)._AMapSecurityConfig = { securityJsCode: securityCode }

  loadPromise = new Promise((resolve, reject) => {
    const script = document.createElement('script')
    script.src = `https://webapi.amap.com/maps?v=2.0&key=${encodeURIComponent(AMAP_JS_KEY)}`
    script.async = true
    script.onload = () => resolve((window as any).AMap)
    script.onerror = () => {
      loadPromise = null
      reject(new Error('高德地图脚本加载失败，请检查网络后重试'))
    }
    document.head.appendChild(script)
  })
  return loadPromise
}