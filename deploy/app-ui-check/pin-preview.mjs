import { spawn } from 'node:child_process'
import { writeFileSync } from 'node:fs'

const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const PORT = 9334
const OUT = 'E:/华为云比赛/2版本/deploy/app-ui-check/pin-preview.png'
const PAGE = 'file:///E:/华为云比赛/2版本/deploy/app-ui-check/pin-preview.html'

const edge = spawn(EDGE, [
  '--headless=new',
  `--remote-debugging-port=${PORT}`,
  '--user-data-dir=C:/Windows/Temp/fg-edge-pin',
  '--window-size=760,720',
  '--hide-scrollbars',
  '--disable-gpu',
  '--no-first-run',
  'about:blank',
], { stdio: 'ignore' })

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))
for (let i = 0; i < 60; i++) {
  try {
    if ((await fetch(`http://127.0.0.1:${PORT}/json/version`)).ok) break
  } catch {}
  await sleep(300)
}
const target = await (await fetch(`http://127.0.0.1:${PORT}/json/new?about:blank`, { method: 'PUT' })).json()
const ws = new WebSocket(target.webSocketDebuggerUrl)
await new Promise((res, rej) => { ws.addEventListener('open', res); ws.addEventListener('error', rej) })
let id = 0
const pending = new Map()
ws.addEventListener('message', (ev) => {
  const m = JSON.parse(ev.data)
  if (m.id && pending.has(m.id)) {
    const { resolve, reject } = pending.get(m.id)
    pending.delete(m.id)
    m.error ? reject(new Error(JSON.stringify(m.error))) : resolve(m.result)
  }
})
const send = (method, params = {}) => {
  const n = ++id
  ws.send(JSON.stringify({ id: n, method, params }))
  return new Promise((resolve, reject) => pending.set(n, { resolve, reject }))
}
await send('Page.enable')
await send('Emulation.setDeviceMetricsOverride', { width: 760, height: 720, deviceScaleFactor: 2, mobile: false })
await send('Page.navigate', { url: PAGE })
await sleep(1500)
const { data } = await send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true })
writeFileSync(OUT, Buffer.from(data, 'base64'))
console.log('saved', OUT)
edge.kill()
process.exit(0)
