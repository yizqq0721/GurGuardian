<template>
  <div class="markdown-body" v-html="safeHtml" />
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { marked } from 'marked'
import DOMPurify from 'dompurify'

const props = defineProps<{ content?: string }>()

marked.setOptions({ gfm: true, breaks: true })

const safeHtml = computed(() => {
  const html = marked.parse(props.content || '') as string
  return DOMPurify.sanitize(html, { USE_PROFILES: { html: true } })
})
</script>

<style scoped>
.markdown-body {
  font-size: var(--fg-text-lead);
  line-height: 1.8;
  color: var(--fg-ink);
  word-break: break-word;
}

.markdown-body :deep(> :first-child) {
  margin-top: 0;
}

.markdown-body :deep(> :last-child) {
  margin-bottom: 0;
}

.markdown-body :deep(h1),
.markdown-body :deep(h2),
.markdown-body :deep(h3),
.markdown-body :deep(h4) {
  margin: 1.4em 0 0.6em;
  font-family: var(--fg-font-serif);
  font-weight: 600;
  line-height: 1.4;
  letter-spacing: -0.01em;
}

.markdown-body :deep(h1) {
  font-size: 1.5em;
}

.markdown-body :deep(h2) {
  font-size: 1.3em;
}

.markdown-body :deep(h3) {
  font-size: 1.12em;
}

.markdown-body :deep(h4) {
  font-size: 1em;
}

.markdown-body :deep(p) {
  margin: 0 0 1em;
}

.markdown-body :deep(ul),
.markdown-body :deep(ol) {
  margin: 0 0 1em;
  padding-left: 1.5em;
}

.markdown-body :deep(li) {
  margin: 0.3em 0;
}

.markdown-body :deep(li > ul),
.markdown-body :deep(li > ol) {
  margin: 0.3em 0 0;
}

.markdown-body :deep(strong) {
  font-weight: 600;
}

.markdown-body :deep(a) {
  color: var(--fg-accent);
  text-decoration: underline;
  text-underline-offset: 2px;
}

.markdown-body :deep(blockquote) {
  margin: 0 0 1em;
  padding: var(--fg-s2) 0 var(--fg-s2) var(--fg-s4);
  border-left: var(--fg-line-w) solid var(--fg-line-strong);
  color: var(--fg-ink-muted);
}

.markdown-body :deep(blockquote p) {
  margin: 0;
}

.markdown-body :deep(code) {
  padding: 0.1em 0.35em;
  border-radius: 4px;
  background: var(--fg-paper);
  font-family: var(--fg-font-mono);
  font-size: 0.9em;
}

.markdown-body :deep(pre) {
  margin: 0 0 1em;
  padding: var(--fg-s3);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-paper);
  overflow-x: auto;
}

.markdown-body :deep(pre code) {
  padding: 0;
  background: none;
  font-size: var(--fg-text-label);
}

.markdown-body :deep(hr) {
  margin: 1.5em 0;
  border: none;
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.markdown-body :deep(table) {
  width: 100%;
  margin: 0 0 1em;
  border-collapse: collapse;
  font-size: var(--fg-text-body);
  line-height: 1.6;
}

.markdown-body :deep(th),
.markdown-body :deep(td) {
  padding: var(--fg-s2) var(--fg-s3);
  border: var(--fg-line-w) solid var(--fg-line);
  text-align: left;
  vertical-align: top;
}

.markdown-body :deep(th) {
  background: var(--fg-paper);
  font-weight: 600;
  white-space: nowrap;
}

.markdown-body :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: var(--fg-radius);
}
</style>
