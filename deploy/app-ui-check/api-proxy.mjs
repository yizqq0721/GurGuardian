import { createServer } from 'node:http'

const TARGET = 'https://47.98.17.243'
const server = createServer(async (req, res) => {
  try {
    const upstream = await fetch(TARGET + req.url, {
      method: req.method,
      headers: { ...req.headers, host: new URL(TARGET).host },
      body: ['GET', 'HEAD'].includes(req.method) ? undefined : req,
      duplex: 'half',
      redirect: 'manual',
    })
    res.writeHead(upstream.status, Object.fromEntries(upstream.headers))
    res.end(Buffer.from(await upstream.arrayBuffer()))
  } catch (e) {
    res.writeHead(502, { 'content-type': 'text/plain' })
    res.end(String(e))
  }
})
server.listen(8080, '127.0.0.1', () => console.log('proxy 8080 ->', TARGET))
