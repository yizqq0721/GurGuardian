import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { placesApi } from '@/api/places'
import { userApi } from '@/api/user'
import { requestGeo, type GeoPoint } from '@/utils/geo'
import { useUserStore } from '@/stores/user'
import type { GeoAddress } from '@/types'

/** 获取浏览器定位，反查区/县并保存到当前用户资料。 */
export function useGeoLocation() {
  const locating = ref(false)
  const userStore = useUserStore()

  async function locateAndSave(): Promise<{ point: GeoPoint; address: GeoAddress } | null> {
    if (locating.value) return null
    if (!window.isSecureContext) {
      ElMessage.warning('浏览器只允许在 HTTPS 或 localhost 下定位')
      return null
    }

    locating.value = true
    try {
      const point = await requestGeo()
      const address = await placesApi.regeo(point)
      const profile = await userApi.update({ location: address.label })
      userStore.applyProfile(profile)
      ElMessage.success(`当前位置：${address.label}`)
      return { point, address }
    } catch (e) {
      const reason = e instanceof Error ? e.message : ''
      // 定位本身的失败需要明确提示；接口错误已由请求拦截器提示
      if (reason === 'denied') {
        ElMessage.error('定位权限被拒绝，请在浏览器中允许访问位置')
      } else if (reason === 'unsupported') {
        ElMessage.error('当前浏览器不支持定位')
      } else if (reason === 'unavailable') {
        ElMessage.error('定位失败，请检查系统定位服务或网络')
      }
      return null
    } finally {
      locating.value = false
    }
  }

  return { locating, locateAndSave }
}
