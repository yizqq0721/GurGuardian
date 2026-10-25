import { spawn } from 'node:child_process'

const EDGE = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const PORT = 9336
const BASE = 'http://127.0.0.1:5173'

const edge = spawn(EDGE, [
  '--headless=new', `--remote-debugging-port=${PORT}`,
  '--user-data-dir=C:/Windows/Temp/fg-edge-pinprobe',
  '--window-size=390,844', '--hide-scrollbars', '--disable-gpu', '--no-first-run', 'about:blank',
], { stdio: 'ignore' })
const sleep = (ms) => new Promise((r) => setTimeout(r, ms))
for (let i = 0; i < 60; i++) {
  try { if ((await fetch(`http://127.0.0.1:${PORT}/json/version`)).ok) break } catch {}
  await sleep(300)
}
const target = await (await fetch(`http://127.0.0.1:${PORT}/json/new?about:blank`, { method: 'PUT' })).json()
const ws = new WebSocket(target.webSocketDebuggerUrl)
await new Promise((res, rej) => { ws.addEventListener('open', res); ws.addEventListener('error', rej) })
let seq = 0
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
  const id = ++seq
  ws.send(JSON.stringify({ id, method, params }))
  return new Promise((resolve, reject) => pending.set(id, { resolve, reject }))
}
const evaluate = async (expression) => {
  const r = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true })
  if (r.exceptionDetails) throw new Error(JSON.stringify(r.exceptionDetails))
  return r.result.value
}
await send('Page.enable')
await send('Runtime.enable')
await send('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 2, mobile: true })
await send('Browser.grantPermissions', { origin: BASE, permissions: ['geolocation'] })
await send('Emulation.setGeolocationOverride', { latitude: 30.2741, longitude: 120.1551, accuracy: 25 })
await send('Page.navigate', { url: `${BASE}/auth` })
await sleep(2000)
await evaluate(`(async () => {
  const r = await fetch('/api/auth/login', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({username:'demo',password:'123456'})});
  const j = await r.json();
  localStorage.setItem('fg_token', j.data.token);
  localStorage.setItem('fg_user', JSON.stringify({userId:j.data.userId, nickname:j.data.nickname, isAdmin: !!j.data.isAdmin}));
})()`)
await send('Page.navigate', { url: `${BASE}/nearby?app=1` })
await sleep(8000)
const info = await evaluate(`(() => {
  const map = document.querySelector('.map').getBoundingClientRect();
  const pins = [...document.querySelectorAll('.nby-pin')].map((el) => {
    const r = el.getBoundingClientRect();
    const wrap = el.closest('.amap-marker');
    return { x: Math.round(r.x), y: Math.round(r.y), w: r.width, h: r.height, display: getComputedStyle(el).display,
      wrapTransform: wrap ? getComputedStyle(wrap).transform : null, wrapDisplay: wrap ? getComputedStyle(wrap).display : null };
  });
  const centers = [...document.querySelectorAll('.amap-marker')].slice(0, 3).map((el) => {
    const r = el.getBoundingClientRect();
    return { x: Math.round(r.x), y: Math.round(r.y), html: el.innerHTML.slice(0, 80) };
  });
  return JSON.stringify({ map: { x: map.x, y: map.y, w: map.width, h: map.height }, pins: pins.slice(0, 6), count: pins.length, centers });
})()`)
console.log(info)
edge.kill()
process.exit(0)
