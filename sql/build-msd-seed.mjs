#!/usr/bin/env node
/**
 * 把 MSD 兽医手册语料（中文摘要 md）切分成 knowledge_docs 条目，输出幂等 SQL。
 *
 *   node sql/build-msd-seed.mjs [语料根目录] > sql/knowledge_seed_msd.sql
 *
 * 语料根目录默认 E:/华为云比赛/ziliao/msd兽医手册知识，
 * 只收各板块 summaries 下的单页摘要 .md，跳过汇总稿、主题速查、data、_cache。
 */
import fs from 'node:fs'
import path from 'node:path'

const DEFAULT_ROOT = 'E:/华为云比赛/ziliao/msd兽医手册知识'
const ROOT = process.argv[2] || DEFAULT_ROOT

const MAX_CHUNK = 1200      // 单条正文字符上限（Redis 向量按整条嵌入，太长会稀释语义）
const HARD_SPLIT = 2000     // 超过这个长度的段落强制切
const SKIP_DIRS = new Set(['data', '_cache'])

const SECTION_TOPIC = {
  '01-犬常见疾病': '犬病',
  '02-猫常见疾病': '猫病',
  '03-中毒专题': '中毒',
  '04-生殖与营养': '营养',
  '05-急诊与重症': '急诊',
}

const SEVERITY_MAP = {
  'informational': 'informational',
  'caution': 'caution',
  'emergency': 'emergency',
  '科普': 'informational',
  '注意': 'caution',
  '急症': 'emergency',
}

/** 单页摘要在 <板块>/summaries/<子板块>/<页面>.md；只收这一层，不收板块汇总稿 */
function collect(dir) {
  const out = []
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name)
    if (e.isDirectory()) {
      if (SKIP_DIRS.has(e.name)) continue
      if (e.name === 'summaries') out.push(...collectSummaries(full))
      else out.push(...collect(full))
    }
  }
  return out
}

function collectSummaries(dir) {
  const out = []
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name)
    if (e.isDirectory()) out.push(...collectSummaries(full))
    else if (e.name.endsWith('.md') && !e.name.startsWith('_')) out.push(full)
  }
  return out
}

/** YAML front matter：支持 `key: value` 与 `key:` + `- item` 两种写法 */
function parseFrontMatter(text) {
  const m = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/)
  if (!m) return { fm: {}, body: text }
  const fm = {}
  let listKey = null
  for (const line of m[1].split(/\r?\n/)) {
    const item = line.match(/^\s*-\s*(.+)$/)
    if (item && listKey) {
      fm[listKey].push(item[1].trim().replace(/^["']|["']$/g, ''))
      continue
    }
    const kv = line.match(/^([A-Za-z_][\w-]*):\s*(.*)$/)
    if (!kv) continue
    const key = kv[1]
    const value = kv[2].trim().replace(/^["']|["']$/g, '')
    if (value === '') {
      listKey = key
      fm[key] = []
    } else {
      listKey = null
      fm[key] = value
    }
  }
  return { fm, body: text.slice(m[0].length) }
}

/** 口径与限制段是编纂声明，不是可检索知识；版权与来源链接已在 front matter 与页首保留 */
const META_SECTION_RE = /口径与限制/
/** 摘要稿的通用小标题，不当作主题标签 */
const GENERIC_HEADINGS = new Set(['摘要', '关键要点', '何时就医', '核心内容', '概述'])
const denum = (h) => h.replace(/^\d+(\.\d+)*[\.、]?\s*/, '').trim()

function stripMetaSections(body) {
  const parts = body.split(/\n(?=#{2,3} )/)
  const kept = []
  for (const p of parts) {
    const head = p.match(/^(#{2,3})\s*(.+)$/m)
    const h = head ? denum(head[2]) : ''
    if (META_SECTION_RE.test(h)) continue
    kept.push(p)
  }
  return kept.join('\n')
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

function headingOf(chunk, fallback) {
  const first = chunk.split(/\r?\n/)[0].trim()
  const h = first.replace(/^\d+(\.\d+)*[\.、]?\s*/, '')
  return h && h.length <= 60 ? h : fallback
}

const q = (s) => `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''").replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/g, '')}'`
const cut = (s, n) => (s.length > n ? s.slice(0, n) : s)
const asList = (v) => (Array.isArray(v) ? v : v ? [v] : [])

const files = collect(ROOT).sort()

const rows = []
const usedTitles = new Set()
const unmapped = new Set()
const stats = new Map()

for (const file of files) {
  const raw = fs.readFileSync(file, 'utf8')
  const { fm, body: fmBody } = parseFrontMatter(raw)
  const rel = path.relative(ROOT, file).split(path.sep)
  const section = fm.section || rel[0]
  const topic = SECTION_TOPIC[section] || '知识'
  if (!SECTION_TOPIC[section]) unmapped.add(section)

  const docTitle = cut(fm.title || rel[rel.length - 1].replace(/\.md$/, ''), 120)
  const shortDoc = cut((docTitle.split(/[：:（(]/)[0] || docTitle).replace(/\s+/g, ' ').trim() || docTitle, 28)

  const body = stripMetaSections(fmBody).replace(/^#\s+.*\r?\n+/, '')
  const sourceUrl = cut(fm.source_url || '', 500)
  const sourceName = cut(fm.source_name || 'MSD Veterinary Manual', 200)
  const severity = SEVERITY_MAP[fm.severity] || 'informational'

  const tags = [
    ...asList(fm.topics),
    ...asList(fm.disease_tags),
    fm.subsection_zh || '',
  ].filter(Boolean)
  const h2s = [...body.matchAll(/^##\s+(.+)$/gm)]
    .map((m) => m[1].trim().replace(/^\d+[\.、]?\s*/, ''))
    .filter((h) => !GENERIC_HEADINGS.has(h))
    .slice(0, 3)
  const topics = cut([...new Set([topic, ...tags, ...h2s])].filter((t) => t.length <= 20).join(','), 200)

  // 按 ## / ### 切段，小节合并到 MAX_CHUNK，超长小节再按段落/句子拆
  const sections = body.split(/\n(?=#{2,3} )/).map((s) => s.trim()).filter(Boolean)
  const rowStart = rows.length
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
        species: cut(asList(fm.species).join(','), 20),
        life_stage: cut(asList(fm.life_stage).join(','), 50),
        topics,
        severity,
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

  // 整篇塞进一条时标题直接用篇名，避免「· 第 1 段」这类噪声
  if (rows.length - rowStart === 1) {
    const row = rows[rowStart]
    let title = cut(docTitle, 200)
    let n = 2
    while (usedTitles.has(title) && title !== row.title) title = cut(`${docTitle} (${n++})`, 200)
    usedTitles.delete(row.title)
    row.title = title
    usedTitles.add(title)
  }

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
out.push('-- FurGuardian 知识库语料扩充：MSD 兽医手册（犬猫常见病 / 中毒 / 生殖营养 / 急诊）')
out.push(`-- 由 sql/build-msd-seed.mjs 生成，语料根目录 ${ROOT}`)
out.push(`-- 共 ${files.length} 篇中文摘要 → ${rows.length} 条，按 ## / ### 标题切分，单条 ≤ ${MAX_CHUNK} 字`)
out.push(`-- 生成时间 ${new Date().toISOString().slice(0, 10)}`)
out.push('-- 幂等：先按本批 title 精确 DELETE，可反复执行')
out.push('-- 不入库的内容：板块汇总稿、主题速查、口径与限制段、data / _cache 中间文件')
out.push('-- ============================================================')
out.push('')
out.push('SET NAMES utf8mb4;')
out.push('')
out.push('USE fur_guardian;')
out.push('')
out.push('-- 幂等删除（仅本批生成的标题，不影响既有 WSAVA / 食材营养条目）')
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
