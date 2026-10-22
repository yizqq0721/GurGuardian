import request from './request'
import type { GeoAddress, NearbyPlace, PlaceCategory, WalkRoute } from '@/types'

export const placesApi = {
  nearby(params: { lat: number; lng: number; category: PlaceCategory; radius: number }) {
    return request.get<NearbyPlace[]>('/api/places/nearby', { params })
  },
  walk(from: { lat: number; lng: number }, to: { lat: number; lng: number }) {
    return request.get<WalkRoute>('/api/places/walk', {
      params: { fromLat: from.lat, fromLng: from.lng, toLat: to.lat, toLng: to.lng },
    })
  },
  regeo(point: { lat: number; lng: number }) {
    return request.get<GeoAddress>('/api/places/regeo', { params: point, silent: true })
  },
}