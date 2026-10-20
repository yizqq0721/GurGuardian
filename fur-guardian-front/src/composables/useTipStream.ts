import { onBeforeUnmount, ref } from 'vue'

export interface TipStreamResult {
  content: string
  source: string
  mock: boolean
}

interface SseFrame {
  event: string
  data: string
}

/**
 * 基于 fetch 的 SSE 读取（EventSource 无法携带 Authorization 头）。
 * 后端接口：GET /api/tip/stream?petId=xx&refresh=xx，返回 event: tip + JSON 数据。
 */
export function useTipStream() {
  const streaming = ref(false)
  const result = ref<TipStreamResult | null>(null)
  const error = ref<string | null>(null)
  let controller: AbortController | null = null

  async function start(petId: number, options: { mock?: boolean; refresh?: boolean } = {}) {
    stop()
    result.value = null
    error.value = null
    streaming.value = true
    controller = new AbortController()

    const params = new URLSearchParams({
      petId: String(petId),
      mock: String(Boolean(options.mock)),
      refresh: String(Boolean(options.refresh)),
    })

    try {
      const resp = await fetch(`/api/tip/stream?${params.toString()}`, {
        headers: { Authorization: `Bearer ${localStorage.getItem('fg_token') || ''}` },
        signal: controller.signal,
      })
      if (!resp.ok || !resp.body) throw new Error(`生成失败（${resp.status}）`)

      const reader = resp.body.pipeThrough(new TextDecoderStream()).getReader()
      let buffer = ''
      let received = false

      for (;;) {
        const { done, value } = await reader.read()
        if (done) break
        buffer += value.replace(/\r\n/g, '\n')

        let boundary = buffer.indexOf('\n\n')
        while (boundary >= 0) {
          const frame = parseFrame(buffer.slice(0, boundary))
          buffer = buffer.slice(boundary + 2)
          boundary = buffer.indexOf('\n\n')
          if (!frame) continue
          if (frame.event === 'error') throw new Error(frame.data || '生成失败，请稍后重试')

          const payload = parsePayload(frame.data)
          if (payload) {
            result.value = payload
            received = true
          }
        }
      }

      if (!received) throw new Error('生成失败，请稍后重试')
      return result.value
    } catch (e) {
      if ((e as Error).name !== 'AbortError') {
        error.value = e instanceof Error && e.message ? e.message : '生成失败，请稍后重试'
        throw e
      }
      return null
    } finally {
      streaming.value = false
      controller = null
    }
  }

  function parseFrame(raw: string): SseFrame | null {
    let event = 'message'
    const data: string[] = []
    for (const line of raw.split('\n')) {
      if (line.startsWith('event:')) {
        event = line.slice(6).trim()
      } else if (line.startsWith('data:')) {
        data.push(line.slice(5).replace(/^ /, ''))
      }
    }
    return data.length ? { event, data: data.join('\n') } : null
  }

  function parsePayload(data: string): TipStreamResult | null {
    try {
      const raw = JSON.parse(data) as { content?: unknown; source?: unknown; mock?: unknown }
      return {
        content: typeof raw.content === 'string' ? raw.content : '',
        source: typeof raw.source === 'string' ? raw.source : '',
        mock: Boolean(raw.mock),
      }
    } catch {
      return data ? { content: data, source: '', mock: false } : null
    }
  }

  function stop() {
    controller?.abort()
    controller = null
    streaming.value = false
  }

  onBeforeUnmount(stop)

  return { streaming, result, error, start, stop }
}
