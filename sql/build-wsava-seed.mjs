#!/usr/bin/env node
/**
 * 把 WSAVA 语料库（中文摘要 md）切分成 knowledge_docs 条目，输出幂等 SQL。
 *
 *   node sql/build-wsava-seed.mjs [语料根目录] > sql/knowledge_seed_wsava.sql
 *
 * 语料根目录默认 E:/华为云比赛/ziliao/document-content-main/document-content-main，
 * 只收 wsava营养知识 / wsava全球指南知识 下的 .md，跳过 raw_extracts、_cache、pdf。
 */
import fs from 'node:fs'
import path from 'node:path'

const DEFAULT_ROOT = 'E:/华为云比赛/ziliao/document-content-main/document-content-main'
const ROOT = process.argv[2] || DEFAULT_ROOT
const ROOTS = ['wsava营养知识', 'wsava全球指南知识']

const MAX_CHUNK = 1200      // 单条正文字符上限（Redis 向量按整条嵌入，太长会稀释语义）
const HARD_SPLIT = 2000     // 超过这个长度的段落强制切
const SKIP_DIRS = new Set(['raw_extracts', '_cache', 'pdf'])

const SECTION_TOPIC = {
  'nutrition': '营养',
  'wsava营养知识': '营养',
  'animal-welfare-guidelines': '动物福利',
  'dental-guidelines': '口腔护理',
  'gastrointestinal-guidelines': '消化',
  'hereditary-disease': '遗传病',
  'liver-disease-guidelines': '肝病',
  'microchip-identification-guidelines': '身份识别',
  'pain-guidelines': '疼痛管理',
  'professional-wellness-guidelines': '兽医职业健康',
  'renal-standardization-guidelines': '肾病',
  'reproduction-guidelines': '生殖',
  'vaccination-guidelines': '疫苗',
  'wsava全球指南知识': '指南索引',
}

const CAUTION_RE = /中毒|致命|致死|死亡|梗阻|阻塞|窒息|急诊|紧急|危险|禁用|慎用|禁忌|休克|脱水|不良事件|危及/

function collect(dir) {
  const out = []
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (e.isDirectory()) {
      if (SKIP_DIRS.has(e.name)) continue
      out.push(...collect(path.join(dir, e.name)))
    } else if (e.name.endsWith('.md') && !e.name.startsWith('_')) {
      out.push(path.join(dir, e.name))
    }
  }
  return out
}

/** 极简 YAML front matter 解析：只取 `key: value` 一层 */
function parseFrontMatter(text) {
  const m = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/)
  if (!m) return { fm: {}, body: text }
  const fm = {}
  for (const line of m[1].split(/\r?\n/)) {
    const kv = line.match(/^([A-Za-z_][\w-]*):\s*(.*)$/)
    if (kv) fm[kv[1]] = kv[2].trim().replace(/^["']|["']$/g, '')
  }
  return { fm, body: text.slice(m[0].length) }
}

/** 元数据段：摘要稿自身的编纂说明、参考文献转录、中英对照表——不是可检索知识 */
const META_SECTION_RE = /关键词索引|参考文献|引用文献|文献转录|文献目录|References?\b|Bibliography|中英文?对照表|分块首尾|跨块断裂|核对表|抽取稿异常|抽取异常|缺失登记|本稿覆盖/
const denum = (h) => h.replace(/^\d+(\.\d+)*[\.、]?\s*/, '').trim()

function stripMetaSections(body) {
  const parts = body.split(/\n(?=#{2,3} )/)
  const kept = []
  const keywords = []
  let h2 = ''
  for (const p of parts) {
    const head = p.match(/^(#{2,3})\s*(.+)$/m)
    const level = head ? head[1].length : 0
    const h = head ? denum(head[2]) : ''
    if (level === 2) h2 = h
    if (/关键词索引/.test(h)) {
      const zh = p.match(/中文：(.+)/)
      if (zh) keywords.push(...zh[1].split(/[、,，]/).map((s) => s.trim()).filter(Boolean))
      else keywords.push(...(p.match(/`([^`]+)`/g) || []).map((s) => s.slice(1, -1)))
      continue
    }
    // 命中元数据段时，连同其下的 ### 子段（如「分块 023」）一起丢弃
    if (META_SECTION_RE.test(h) || META_SECTION_RE.test(h2)) continue
    kept.push(p)
  }
  return { body: kept.join('\n'), keywords }
}

/** 正文清洗：去掉 hr、blockquote 的来源行、heading 标记 */
function cleanSection(text) {
  return text
    .split(/\r?\n/)
    .filter((l) => !/^(-{3,}|\*{3,}|_{3,})\s*$/.test(l.trim()))
    .filter((l) => !/^>\s*(来源|原文|原文档)\s*[:：]/.test(l.trim()))
    .map((l) => l.replace(/^(#{1,6})\s+/, ''))
    .join('\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim()
}

function splitOversized(text) {
  if (text.length <= HARD_SPLIT) return [text]
  const paras = text.split(/\n\s*\n/)
  const out = []
  let buf = ''
  for (const p of paras) {
    if (buf && buf.length + p.length + 2 > MAX_CHUNK) {
      out.push(buf.trim())
      buf = ''
    }
    if (p.length > HARD_SPLIT) {
      if (buf.trim()) { out.push(buf.trim()); buf = '' }
      // 超长段落按句子硬切，避免截断表格行
      let rest = p
      while (rest.length > HARD_SPLIT) {
        const win = rest.slice(0, HARD_SPLIT)
        const cut = Math.max(win.lastIndexOf('。'), win.lastIndexOf('\n'), win.lastIndexOf('；'))
        const at = cut > HARD_SPLIT * 0.5 ? cut + 1 : HARD_SPLIT
        out.push(rest.slice(0, at).trim())
        rest = rest.slice(at)
      }
      buf = rest
      continue
    }
    buf += (buf ? '\n\n' : '') + p
  }
  if (buf.trim()) out.push(buf.trim())
  return out.filter(Boolean)
}

function inferSpecies(text) {
  const dog = /犬|狗|\bdogs?\b/i.test(text)
  const cat = /猫|\bcats?\b/i.test(text)
  // 同时涉及或都不涉及 → 留空：检索侧按 species LIKE '%dog%' 过滤，'both' 会被漏掉
  if (dog === cat) return ''
  return dog ? 'dog' : 'cat'
}

function inferLifeStage(text) {
  const young = /幼犬|幼猫|幼龄|断奶|离乳|pupp(y|ies)|kitten/i.test(text)
  const senior = /老年|老龄|高龄|senior|geriatric/i.test(text)
  if (young === senior) return ''
  return young ? 'young' : 'senior'
}

function headingOf(chunk, fallback) {
  const first = chunk.split(/\r?\n/)[0].trim()
  const h = first.replace(/^\d+(\.\d+)*[\.、]?\s*/, '')
  return h && h.length <= 60 ? h : fallback
}

const q = (s) => `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''").replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/g, '')}'`
const cut = (s, n) => (s.length > n ? s.slice(0, n) : s)

let files = []
for (const r of ROOTS) {
  const dir = path.join(ROOT, r)
  if (fs.existsSync(dir)) files.push(...collect(dir))
}
files.sort()

const rows = []
const usedTitles = new Set()
const unmapped = new Set()
const stats = new Map()

for (const file of files) {
  const raw = fs.readFileSync(file, 'utf8')
  const { fm, body: fmBody } = parseFrontMatter(raw)
  const rel = path.relative(ROOT, file).split(path.sep)
  const section = fm.section || rel[rel.length - 2] || 'nutrition'
  const topic = SECTION_TOPIC[section] || '知识'
  if (!SECTION_TOPIC[section]) unmapped.add(section)

  const h1 = fmBody.match(/^#\s+(.+)$/m)
  const docTitle = cut(fm.title || (h1 ? h1[1].trim() : ''), 120)
    || rel[rel.length - 1].replace(/^\d+-/, '').replace(/\.md$/, '')
  // 标题只取主标题（副标题留在 source_name 里），否则拼出来的条目标题能长到 100+ 字
  const shortDoc = cut((docTitle.split(/[：:（(]/)[0] || docTitle).replace(/\s+/g, ' ').trim() || docTitle, 28)

  const { body, keywords } = stripMetaSections(fmBody)
  // 只认 front matter 里的 source_url：正文首个链接在索引类文档里会指向无关页面
  const sourceUrl = cut(fm.source_url || '', 500)
  const sourceName = cut(docTitle, 200)

  const kw = (keywords.length ? keywords : [])
    .filter((k) => k.length >= 2 && k.length <= 10)
    .slice(0, 5)
  const h2s = [...body.matchAll(/^##\s+(.+)$/gm)].map((m) => m[1].trim().replace(/^\d+[\.、]?\s*/, '')).slice(0, 3)
  const topics = cut([...new Set([topic, ...kw, ...h2s])].filter((t) => t.length <= 20).join(','), 200)

  // 按 ## / ### 切段，小节合并到 MAX_CHUNK，超长小节再按段落/句子拆
  const sections = body.split(/\n(?=#{2,3} )/).map((s) => s.trim()).filter(Boolean)
  let buf = ''
  let bufHeading = ''
  let part = 0
  const push = (text, heading) => {
    for (const piece of splitOversized(text)) {
      let h = (heading || headingOf(piece, '')).replace(/[（(]中文整理稿[）)]/g, '').trim()
      h = cut(denum(h), 40)
      const dup = h === shortDoc || (h.length > 8 && (shortDoc.includes(h) || h.includes(shortDoc)))
      if (!h || dup) h = `第 ${++part} 段`
      let title = cut(`${shortDoc} · ${h}`.replace(/\s+/g, ' '), 200)
      let n = 2
      while (usedTitles.has(title)) title = cut(`${shortDoc} · ${h} (${n++})`, 200)
      usedTitles.add(title)
      rows.push({
        title,
        content: piece,
        species: inferSpecies(piece),
        life_stage: inferLifeStage(piece),
        topics,
        severity: CAUTION_RE.test(piece) ? 'caution' : 'informational',
        source_name: sourceName,
        source_type: 'official',
        source_url: sourceUrl,
      })
    }
  }

  for (const s of sections) {
    const cleaned = cleanSection(s)
    if (!cleaned) continue
    const heading = headingOf(cleaned, '')
    if (buf && buf.length + cleaned.length + 2 > MAX_CHUNK) {
      push(buf, bufHeading)
      buf = ''
      bufHeading = ''
    }
    if (cleaned.length > MAX_CHUNK) {
      push(cleaned, heading)
      continue
    }
    buf += (buf ? '\n\n' : '') + cleaned
    if (!bufHeading) bufHeading = heading
  }
  if (buf.trim()) push(buf, bufHeading)

  const rec = stats.get(topic) || { files: 0, rows: 0, chars: 0 }
  rec.files++
  stats.set(topic, rec)
}

for (const r of rows) {
  const rec = stats.get(r.topics.split(',')[0])
  if (rec) { rec.rows++; rec.chars += r.content.length }
}

const COLS = '(title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status)'
const out = []
out.push('-- ============================================================')
out.push('-- FurGuardian 知识库语料扩充：WSAVA 全球指南 + 全球营养委员会')
out.push(`-- 由 sql/build-wsava-seed.mjs 生成，语料根目录 ${ROOT}`)
out.push(`-- 共 ${files.length} 篇中文摘要 → ${rows.length} 条，按 ## / ### 标题切分，单条 ≤ ${MAX_CHUNK} 字`)
out.push(`-- 生成时间 ${new Date().toISOString().slice(0, 10)}`)
out.push('-- 幂等：先按本批 title 精确 DELETE，可反复执行')
out.push('-- 不入库的内容：raw_extracts 英文原文、PDF、关键词索引段、参考文献段')
out.push('-- ============================================================')
out.push('')
out.push('SET NAMES utf8mb4;')
out.push('')
out.push('USE fur_guardian;')
out.push('')
out.push('-- 幂等删除（仅本批生成的标题，不影响原有 80 条种子）')
const titles = rows.map((r) => r.title)
for (let i = 0; i < titles.length; i += 200) {
  out.push(`DELETE FROM knowledge_docs WHERE title IN (${titles.slice(i, i + 200).map((t) => q(t)).join(', ')});`)
}
out.push('')
for (let i = 0; i < rows.length; i += 40) {
  out.push(`INSERT INTO knowledge_docs ${COLS} VALUES`)
  const vals = rows.slice(i, i + 40).map((r) => `(${[
    q(r.title), q(r.content), q(r.species), q(r.life_stage), q(''), q(r.topics),
    q(r.severity), q(r.source_name), q(r.source_type), q(r.source_url), q('approved'),
  ].join(', ')})`)
  out.push(vals.join(',\n') + ';')
  out.push('')
}

process.stdout.write(out.join('\n'))

process.stderr.write(`\n文件 ${files.length} 篇 → 条目 ${rows.length} 条\n`)
process.stderr.write('主题分布:\n')
for (const [k, v] of [...stats.entries()].sort((a, b) => b[1].rows - a[1].rows)) {
  process.stderr.write(`  ${k.padEnd(10)} 文件${String(v.files).padStart(3)}  条目${String(v.rows).padStart(4)}  字数${String(v.chars).padStart(8)}\n`)
}
const lens = rows.map((r) => r.content.length).sort((a, b) => a - b)
process.stderr.write(`正文长度 中位${lens[Math.floor(lens.length / 2)]} / 最长${lens[lens.length - 1]}\n`)
const sp = {}
for (const r of rows) sp[r.species || '(通用)'] = (sp[r.species || '(通用)'] || 0) + 1
process.stderr.write(`species: ${JSON.stringify(sp)}\n`)
const sv = {}
for (const r of rows) sv[r.severity] = (sv[r.severity] || 0) + 1
process.stderr.write(`severity: ${JSON.stringify(sv)}\n`)
if (unmapped.size) process.stderr.write(`未映射 section（已归入「知识」）: ${[...unmapped].join(', ')}\n`)
