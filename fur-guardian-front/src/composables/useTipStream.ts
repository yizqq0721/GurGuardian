import { onBeforeUnmount, ref } from 'vue'

/**
 * 基于 fetch 的 SSE 读取（EventSource 无法携带 Authorization 头）。
 * 后端接口：GET /api/tip/stream?petId=xx，text/event-stream，逐字推送。
 */
export function useTipStream() {
  const streaming = ref(false)
  const content = ref('')
  let controller: AbortController | null = null

  async function start(petId: number, mock = false) {
    stop()
    content.value = ''
    streaming.value = true
    controller = new AbortController()
    try {
      const resp = await fetch(`/api/tip/stream?petId=${petId}&mock=${mock}`, {
        headers: { Authorization: `Bearer ${localStorage.getItem('fg_token') || ''}` },
        signal: controller.signal,
      })
      if (!resp.ok || !resp.body) throw new Error(`stream failed: ${resp.status}`)
      const reader = resp.body.pipeThrough(new TextDecoderStream()).getReader()
      let buffer = ''
      for (;;) {
        const { done, value } = await reader.read()
        if (done) break
        buffer += value
        // SSE 帧以 \n\n 分隔，data: 开头
        const frames = buffer.split('\n\n')
        buffer = frames.pop() ?? ''
        for (const frame of frames) {
          const line = frame.split('\n').find((l) => l.startsWith('data:'))
          if (line) content.value += line.slice(5).replace(/^ /, '')
        }
      }
    } catch (e) {
      if ((e as Error).name !== 'AbortError') throw e
    } finally {
      streaming.value = false
    }
  }

  function stop() {
    controller?.abort()
    controller = null
    streaming.value = false
  }

  onBeforeUnmount(stop)

  return { streaming, content, start, stop }
}
