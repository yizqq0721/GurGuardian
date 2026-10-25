<template>
  <div class="fg-page" :class="{ 'chat-page': mode === 'chat' }">
    <!-- ========== A. 知识问答（会话历史） ========== -->
    <template v-if="mode === 'chat'">
      <div v-if="drawerOpen" class="drawer-mask" @click="drawerOpen = false" />

      <aside class="sess-pane" :class="{ 'is-open': drawerOpen }">
        <div class="pane-head">
          <p class="pane-title">知识问答</p>
          <button type="button" class="icon-btn" title="新建对话" aria-label="新建对话" @click="newChat">
            <SquarePen :size="16" class="fg-icon" />
          </button>
        </div>

        <el-input
          v-model="sessKeyword"
          class="sess-search"
          placeholder="搜索会话"
          @keydown.down.prevent="moveSelection(1)"
          @keydown.up.prevent="moveSelection(-1)"
        >
          <template #prefix>
            <Search :size="16" class="fg-icon" />
          </template>
        </el-input>

        <div class="sess-scroll">
          <p v-if="loadingSessions" class="sess-note fg-muted">正在加载会话…</p>
          <p v-else-if="!visibleSessions.length" class="sess-note fg-muted">
            {{ sessions.length ? '没有匹配的会话' : '还没有对话，从右侧问第一个问题开始。' }}
          </p>

          <template v-for="group in sessionGroups" :key="group.label">
            <p class="group-label">{{ group.label }}</p>
            <div
              v-for="s in group.items"
              :key="s.id"
              class="sess-item"
              :class="{ 'is-active': s.id === activeId }"
              role="button"
              tabindex="0"
              @click="openChat(s.id)"
              @keyup.enter="openChat(s.id)"
            >
              <span class="sess-main">
                <span class="sess-title">{{ s.title }}</span>
                <span class="sess-meta fg-muted">
                  <span class="fg-num">{{ s.messageCount }}</span> 条 ·
                  <span class="fg-num">{{ s.sourceCount }}</span> 个来源
                </span>
              </span>
              <span class="sess-right">
                <span class="sess-time fg-muted fg-num">{{ timeText(s.updatedAt) }}</span>
                <el-dropdown trigger="hover" placement="bottom-end" @command="onSessionCommand($event, s)">
                  <button type="button" class="icon-btn sess-more" aria-label="会话操作" @click.stop>
                    <Ellipsis :size="16" class="fg-icon" />
                  </button>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item command="rename">重命名</el-dropdown-item>
                      <el-dropdown-item command="remove">删除</el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </span>
            </div>
          </template>

          <button v-if="sessionsMore" type="button" class="load-older sess-older" @click="loadMoreSessions">
            {{ loadingMoreSessions ? '加载中…' : '加载更早的对话' }}
          </button>
        </div>

        <el-popover
          v-if="stats && stats.total > 0"
          placement="top-end"
          :width="260"
          trigger="hover"
        >
          <template #reference>
            <button type="button" class="feedback-stat">
              <span class="fs-head">
                <span class="fg-label">回答反馈</span>
                <Info :size="14" class="fg-icon" />
              </span>
              <span v-if="stats.useful + stats.useless > 0" class="fs-body">
                <span class="fs-rate fg-num">{{ stats.usefulRate }}%</span>
                <span class="fg-muted fs-note">
                  {{ stats.useful }}/{{ stats.useful + stats.useless }} 条评价有用
                </span>
              </span>
              <span v-else class="fs-empty fg-muted">还没有评价</span>
            </button>
          </template>
          <template v-if="stats.useful + stats.useless > 0">
            <p class="fs-pop-head">最近被标为「没用」的回答</p>
            <ul v-if="stats.recentUseless.length" class="fs-pop-list">
              <li v-for="s in stats.recentUseless" :key="s.messageId">
                <p class="fs-pop-text">{{ s.snippet }}</p>
                <span class="fg-muted fg-num">{{ dayjs(s.createdAt).format('MM-DD HH:mm') }}</span>
              </li>
            </ul>
            <p v-else class="fg-muted fs-pop-empty">还没有差评。</p>
          </template>
          <p v-else class="fg-muted fs-pop-empty">
            回答下方的「有用/没用」会汇总到这里，有用率只统计已评价的回答。
          </p>
        </el-popover>

        <button type="button" class="pane-foot" @click="mode = 'browse'">
          <BookOpen :size="16" class="fg-icon" />
          <span>浏览知识库</span>
          <ChevronRight :size="16" class="fg-icon" />
        </button>
      </aside>

      <section class="conv-pane">
        <header class="conv-head">
          <button type="button" class="icon-btn hist-btn" @click="drawerOpen = true">
            <History :size="16" class="fg-icon" />
            <span>历史</span>
          </button>

          <div class="conv-title">
            <input
              v-if="renaming"
              ref="renameInput"
              v-model="renameValue"
              class="rename-input"
              maxlength="100"
              @keyup.enter="commitRename"
              @blur="commitRename"
              @keyup.esc="renaming = false"
            />
            <h1 v-else-if="activeChat" class="conv-name" title="点击重命名" @click="startRename">
              {{ activeChat.title }}
            </h1>
            <h1 v-else class="conv-name">新对话</h1>
            <p v-if="activeChat" class="conv-meta fg-muted">
              <span class="fg-num">{{ activeChat.messageCount }}</span> 条 ·
              <span class="fg-num">{{ activeChat.sourceCount }}</span> 个来源
            </p>
          </div>

          <button v-if="messages.length" type="button" class="icon-btn export-btn" @click="exportChat">
            <Download :size="16" class="fg-icon" />
            <span>导出</span>
          </button>
        </header>

        <section v-if="reviewBusy || review || reviewError" class="review-panel" aria-live="polite">
          <div class="review-head">
            <div class="review-heading">
              <p class="review-title">本周照护复盘</p>
              <p class="review-sub fg-muted">照护分析先查真实记录，行动计划只基于这份结论提建议</p>
            </div>
            <button type="button" class="icon-btn" aria-label="关闭复盘" @click="closeReview">
              <X :size="16" class="fg-icon" />
            </button>
          </div>

          <div v-if="reviewBusy" class="review-loading">
            <span class="sk-line" style="width: 64%" />
            <span class="sk-line" style="width: 42%" />
            <p class="fg-muted">照护分析 Agent 正在查本周记录，完成后交给行动计划 Agent。</p>
          </div>

          <div v-else-if="reviewError" class="review-error">
            <p>{{ reviewError }}</p>
            <button type="button" class="retry-btn" @click="runWeeklyReview">重试</button>
          </div>

          <div v-else-if="review" class="review-steps">
            <article class="review-card" :class="`is-${review.analysis.status.toLowerCase()}`">
              <div class="card-head">
                <span class="card-index fg-num">01</span>
                <p class="card-kicker">{{ review.analysis.label }}</p>
                <span class="fg-chip card-status">{{ stepStatusText(review.analysis.status) }}</span>
                <span class="card-ms fg-muted fg-num">{{ review.analysis.ms }}ms</span>
              </div>
              <p class="card-text">{{ review.analysis.content }}</p>
              <div v-if="review.analysis.facts.length" class="card-block">
                <span class="fg-label">事实</span>
                <ul class="fact-list">
                  <li v-for="fact in review.analysis.facts" :key="fact">{{ fact }}</li>
                </ul>
              </div>
              <p v-if="review.analysis.missing.length" class="card-missing">
                未取到：{{ review.analysis.missing.join('、') }}
              </p>
              <div v-if="review.analysis.toolCalls.length" class="tool-trace">
                <span class="fg-muted trace-title">已查询</span>
                <span
                  v-for="call in review.analysis.toolCalls"
                  :key="`a-${call.name}-${call.summary}`"
                  class="fg-chip trace-chip"
                >
                  {{ call.label }}<template v-if="call.summary"> · {{ call.summary }}</template>
                </span>
              </div>
            </article>

            <article v-if="review.plan" class="review-card" :class="`is-${review.plan.status.toLowerCase()}`">
              <div class="card-head">
                <span class="card-index fg-num">02</span>
                <p class="card-kicker">{{ review.plan.label }}</p>
                <span class="fg-chip card-status">{{ stepStatusText(review.plan.status) }}</span>
                <span class="card-ms fg-muted fg-num">{{ review.plan.ms }}ms</span>
              </div>
              <p class="card-text">{{ review.plan.content }}</p>
              <p v-if="review.plan.missing.length" class="card-missing">
                未取到：{{ review.plan.missing.join('、') }}
              </p>

              <div v-if="review.sources.length" class="card-block">
                <span class="fg-label">参考来源</span>
                <div class="source-grid">
                  <button
                    v-for="src in review.sources"
                    :key="src.docId"
                    type="button"
                    class="source-card"
                    @click="openReviewSource(src)"
                  >
                    <span class="source-title">{{ src.title }}</span>
                    <span class="fg-muted source-name">{{ src.sourceName }}</span>
                  </button>
                </div>
              </div>

              <div v-if="review.plan.toolCalls.length" class="tool-trace">
                <span class="fg-muted trace-title">已调用</span>
                <span
                  v-for="call in review.plan.toolCalls"
                  :key="`p-${call.name}-${call.summary}`"
                  class="fg-chip trace-chip"
                >
                  {{ call.label }}<template v-if="call.summary"> · {{ call.summary }}</template>
                </span>
              </div>

              <div v-if="reviewPending" class="pending-card">
                <p class="pending-head">
                  <CalendarPlus :size="16" class="fg-icon" />
                  待确认的提醒
                </p>
                <p class="pending-summary">{{ reviewPending.summary }}</p>
                <p class="fg-muted pending-tip">
                  计划 10 分钟内有效，确认后才会写入你的提醒。
                </p>
                <div class="pending-actions">
                  <el-button
                    type="primary"
                    :loading="reviewPendingBusy"
                    :disabled="reviewPendingCreated"
                    @click="confirmReviewPending"
                  >
                    {{ reviewPendingCreated ? '已创建' : '确认创建' }}
                  </el-button>
                  <el-button v-if="!reviewPendingCreated" :disabled="reviewPendingBusy" @click="reviewPending = null">
                    取消
                  </el-button>
                  <router-link v-if="reviewPendingCreated" to="/reminders" class="pending-link">
                    去提醒页看看
                  </router-link>
                </div>
              </div>
            </article>

            <article v-else class="review-card is-failed">
              <div class="card-head">
                <span class="card-index fg-num">02</span>
                <p class="card-kicker">行动计划</p>
                <span class="fg-chip card-status">未完成</span>
              </div>
              <p class="card-text">行动计划这次没能生成，上面的照护分析仍然有效。</p>
            </article>
          </div>
        </section>

        <div ref="threadEl" class="thread" role="log" aria-live="polite">
          <button v-if="messagesMore" type="button" class="load-older" @click="loadMoreMessages">
            {{ loadingMore ? '加载中…' : '加载更早的消息' }}
          </button>

          <!-- 骨架：加载中不显示空状态 -->
          <template v-if="loadingMessages">
            <div v-for="i in 3" :key="i" class="skeleton" :class="{ 'is-user': i === 1 }">
              <span class="sk-line" style="width: 46%" />
              <span class="sk-line" style="width: 78%" />
            </div>
          </template>

          <!-- 欢迎页：没有选中会话，且没有正在提问/错误 -->
          <div v-else-if="!activeId && !asking && !askError" class="welcome">
            <h2 class="welcome-title">问问 FurGuardian</h2>
            <p class="welcome-sub fg-muted">
              喂养、护理、症状都能问。回答只取自已审核的知识库条目，并附上来源。
            </p>
            <div class="welcome-grid">
              <button
                v-for="q in suggested"
                :key="q"
                type="button"
                class="suggest-card"
                @click="askFrom(q)"
              >
                {{ q }}
              </button>
            </div>
            <button type="button" class="welcome-browse fg-muted" @click="mode = 'browse'">
              或浏览知识库
            </button>
          </div>

          <template v-else>
            <template v-for="row in threadRows" :key="row.key">
              <p v-if="row.kind === 'day'" class="day-sep fg-muted">{{ row.label }}</p>

              <div v-else-if="row.kind === 'user'" class="msg is-user">
                <div class="bubble">{{ row.text }}</div>
              </div>

              <div v-else class="msg is-ai">
                <div v-if="row.message.isRedLine" class="fg-callout fg-callout--danger redline">
                  <div class="redline-head">
                    <ShieldAlert :size="16" class="fg-icon" />
                    <strong>建议尽快就医</strong>
                  </div>
                  <p class="redline-text">{{ row.message.content }}</p>
                </div>

                <template v-else>
                  <p class="ai-label fg-muted">
                    AI
                    <span v-if="row.message.isFallback" class="fg-chip fallback-tag">降级回答</span>
                    <span class="ai-time fg-muted fg-num">{{ clockText(row.message.createdAt) }}</span>
                  </p>
                  <p class="ai-body">
                    <template v-for="(seg, i) in row.segments" :key="i">
                      <sup
                        v-if="seg.cite"
                        class="cite"
                        :title="row.message.sources[seg.cite - 1]?.title"
                      >{{ seg.cite }}</sup>
                      <span v-else v-html="inlineBold(seg.text)" />
                    </template>
                  </p>

                  <div v-if="row.message.id === lastTraceId && lastTrace.length" class="tool-trace">
                    <span class="fg-muted trace-title">已查询</span>
                    <span v-for="call in lastTrace" :key="call.name" class="fg-chip trace-chip">
                      {{ call.label }}<template v-if="call.summary"> · {{ call.summary }}</template>
                    </span>
                    <span v-if="lastFailed.length" class="fg-chip trace-chip is-warn">
                      <TriangleAlert :size="12" />
                      {{ lastFailed.join('、') }}未取到
                    </span>
                  </div>

                  <div v-if="row.message.sources.length" class="sources">
                    <p class="fg-label">参考来源</p>
                    <div class="source-grid">
                      <button
                        v-for="src in row.message.sources"
                        :key="src.docId"
                        type="button"
                        class="source-card"
                        @click="openSource(src)"
                      >
                        <span class="source-title">{{ src.title }}</span>
                        <span class="source-meta">
                          <SeverityDot
                            v-if="src.severity"
                            :level="severityLevel(src.severity)"
                            :label="severityLabel(src.severity)"
                          />
                          <span class="fg-muted">{{ sourceTypeLabel(src.sourceType) }}</span>
                        </span>
                        <span class="fg-muted source-name">{{ src.sourceName }}</span>
                      </button>
                    </div>
                  </div>

                  <p class="ai-disclaimer fg-muted">以上建议仅供参考，不构成医疗建议。</p>

                  <div class="answer-actions">
                    <button
                      type="button"
                      class="vote-btn"
                      :class="{ on: row.message.feedback === 1 }"
                      :disabled="feedbackBusy === row.message.id"
                      @click="rate(row.message, true)"
                    >
                      <ThumbsUp :size="14" /> 有用
                    </button>
                    <button
                      type="button"
                      class="vote-btn"
                      :class="{ on: row.message.feedback === 0 }"
                      :disabled="feedbackBusy === row.message.id"
                      @click="rate(row.message, false)"
                    >
                      <ThumbsDown :size="14" /> 没用
                    </button>
                    <span v-if="row.message.feedback != null" class="fg-muted vote-thanks">感谢反馈</span>
                  </div>

                  <div v-if="pendingAction && pendingForId === row.message.id" class="pending-card">
                    <p class="pending-head">
                      <CalendarPlus :size="16" class="fg-icon" />
                      待确认的提醒
                    </p>
                    <p class="pending-summary">{{ pendingAction.summary }}</p>
                    <p class="fg-muted pending-tip">
                      Agent 只生成了计划，确认后才会写入你的提醒（计划 10 分钟内有效）。
                      想调整就直接发消息，例如「改成晚上八点，只在工作日提醒」。
                    </p>
                    <div class="pending-actions">
                      <el-button
                        type="primary"
                        :loading="pendingBusy"
                        :disabled="pendingCreated"
                        @click="confirmPending"
                      >
                        {{ pendingCreated ? '已创建' : '确认创建' }}
                      </el-button>
                      <el-button v-if="!pendingCreated" :disabled="pendingBusy" @click="dismissPending">
                        取消
                      </el-button>
                      <router-link v-if="pendingCreated" to="/reminders" class="pending-link">
                        去提醒页看看
                      </router-link>
                    </div>
                  </div>
                </template>
              </div>
            </template>

            <!-- 生成中：问题先上屏，回答用骨架 -->
            <template v-if="asking">
              <div class="msg is-user">
                <div class="bubble">{{ askingQuestion }}</div>
              </div>
              <div class="msg is-ai">
                <p class="ai-label fg-muted">
                  AI
                  <span class="loading-dot" aria-hidden="true" />
                  <span>正在生成回答…</span>
                </p>
                <div class="skeleton">
                  <span class="sk-line" style="width: 82%" />
                  <span class="sk-line" style="width: 64%" />
                </div>
              </div>
            </template>

            <div v-if="askError" class="fg-callout fg-callout--danger ask-error">
              <div class="redline-head">
                <TriangleAlert :size="16" class="fg-icon" />
                <strong>这次没答上来</strong>
              </div>
              <p class="redline-text">{{ askError }}</p>
              <button type="button" class="retry-btn" @click="submit(askingQuestion)">重试</button>
            </div>

            <p v-if="persistError" class="persist-warn fg-muted">
              这次问答没能存入历史，刷新后会丢失。
            </p>

            <p v-if="!messages.length && !asking && !askError && activeId" class="thread-empty fg-muted">
              这个会话还没有内容，直接提问即可。
            </p>
          </template>
        </div>

        <footer class="composer">
          <div class="chips">
            <button
              type="button"
              class="fg-chip topic-chip review-trigger"
              :disabled="reviewBusy"
              @click="runWeeklyReview"
            >
              <Sparkles :size="14" class="fg-icon" />
              {{ reviewBusy ? '复盘进行中…' : '本周照护复盘' }}
            </button>
            <button
              v-for="q in composerSuggests"
              :key="q"
              type="button"
              class="fg-chip topic-chip"
              @click="draft = q"
            >
              {{ q }}
            </button>
          </div>

          <div class="input-row">
            <el-input
              v-model="draft"
              type="textarea"
              resize="none"
              maxlength="500"
              :autosize="{ minRows: 1, maxRows: 4 }"
              placeholder="描述症状或喂养问题，例如：幼犬一天喂几顿？"
              @keydown.enter.exact.prevent="submit(draft.trim())"
            />
            <button
              type="button"
              class="send-btn"
              :disabled="!draft.trim() || asking"
              aria-label="发送"
              @click="submit(draft.trim())"
            >
              <ArrowUp :size="18" class="fg-icon" />
            </button>
          </div>

          <div class="composer-foot">
            <span class="fg-muted">回答基于知识库检索，不构成医疗建议。</span>
            <span class="fg-muted fg-num">{{ draft.length }}/500</span>
          </div>
        </footer>
      </section>
    </template>

    <!-- ========== B. 浏览知识库（检索，行为保持不变） ========== -->
    <template v-else>
      <PageHeader
        title="知识库"
        description="检索循证的犬猫营养、护理与症状知识，每条结果标注来源与风险等级。"
        breadcrumb="知识库 / 浏览"
      >
        <template #actions>
          <el-button type="primary" size="large" class="back-chat-btn" @click="mode = 'chat'">
            <MessagesSquare :size="18" class="fg-icon" />
            返回知识问答
          </el-button>
          <span v-if="searched" class="fg-muted result-count">
            共 <span class="fg-num">{{ docs.length }}</span> 条结果
          </span>
        </template>
      </PageHeader>

      <!-- 检索 hero：搜索优先 -->
      <section class="fg-card hero">
        <p class="fg-label">关键词检索</p>
        <div class="hero-row">
          <el-input
            v-model="searchQuery"
            class="hero-input"
            placeholder="搜索知识条目，例如：猫 换粮 软便"
            maxlength="200"
            @keyup.enter="search"
          >
            <template #prefix>
              <Search :size="20" class="fg-icon" />
            </template>
          </el-input>
          <el-button type="primary" :loading="searching" @click="search">检索</el-button>
        </div>

        <div class="hero-sep" />

        <div class="hero-filters">
          <div class="filter-block">
            <p class="fg-label">常见主题</p>
            <div class="chips">
              <button
                v-for="t in topics"
                :key="t"
                type="button"
                class="fg-chip topic-chip"
                :class="{ 'is-active': activeTopic === t }"
                @click="pickTopic(t)"
              >
                {{ t }}
              </button>
            </div>
          </div>

          <div class="filter-block">
            <p class="fg-label">限定条件</p>
            <div class="dims">
              <el-select v-model="searchSpecies" class="dim-select" placeholder="物种" clearable>
                <el-option value="dog" label="犬" />
                <el-option value="cat" label="猫" />
              </el-select>
              <el-select v-model="searchLifeStage" class="dim-select" placeholder="生命阶段" clearable>
                <el-option value="young" label="幼年" />
                <el-option value="adult" label="成年" />
                <el-option value="senior" label="老年" />
              </el-select>
            </div>
          </div>
        </div>
      </section>

      <div class="fg-split knowledge-split">
        <div class="main-col">
          <!-- 列表视图 -->
          <section v-if="!activeDoc" class="results">
            <h2 class="fg-section-title">
              <BookOpen :size="20" class="fg-icon" />
              检索结果
            </h2>

            <EmptyState
              v-if="searched && docs.length === 0"
              variant="search"
              description="没有检索到相关条目"
            />
            <p v-else-if="!searched" class="fg-muted list-hint">
              输入关键词或选择主题，结果会显示在这里。
            </p>

            <div v-else class="doc-list">
              <div
                v-for="doc in docs"
                :key="doc.id"
                class="doc-row"
                role="button"
                tabindex="0"
                @click="openDoc(doc)"
                @keyup.enter="openDoc(doc)"
              >
                <div class="row-head">
                  <span class="doc-title">{{ doc.title }}</span>
                  <SeverityDot
                    v-if="doc.severity"
                    class="row-severity"
                    :level="severityLevel(doc.severity)"
                    :label="severityLabel(doc.severity)"
                  />
                </div>

                <p v-if="doc.content" class="doc-excerpt">{{ plainText(doc.content) }}</p>

                <div class="row-meta">
                  <span class="meta-source" @click.stop>
                    <SourceChip :label="doc.sourceName || '未知来源'" :href="doc.sourceUrl" />
                  </span>
                  <span v-if="doc.updatedAt" class="fg-muted meta-date fg-num">{{ dateText(doc.updatedAt) }}</span>
                  <span v-for="t in topicList(doc.topics)" :key="t" class="fg-chip row-topic">{{ t }}</span>
                </div>
              </div>
            </div>
          </section>

          <!-- 文章详情：720px 阅读栏 -->
          <article v-else class="reading">
            <button type="button" class="back-btn" @click="activeDoc = null">
              <ArrowLeft :size="20" class="fg-icon" />
              <span>返回结果列表</span>
            </button>

            <h2 class="reading-title">{{ activeDoc.title }}</h2>

            <p class="reading-meta">
              <span>来源 · {{ activeDoc.sourceName || '未知' }}</span>
              <span v-if="activeDoc.updatedAt" class="fg-num"> · {{ dateText(activeDoc.updatedAt) }}</span>
            </p>

            <div class="reading-tags">
              <SeverityDot
                v-if="activeDoc.severity"
                :level="severityLevel(activeDoc.severity)"
                :label="severityLabel(activeDoc.severity)"
              />
              <span v-if="activeDoc.species" class="fg-chip">{{ speciesLabel(activeDoc.species) }}</span>
              <span v-if="activeDoc.lifeStage" class="fg-chip">{{ lifeStageLabel(activeDoc.lifeStage) }}</span>
              <span v-for="t in topicList(activeDoc.topics, 6)" :key="t" class="fg-chip">{{ t }}</span>
            </div>

            <div class="reading-body">
              <MarkdownContent :content="activeDoc.content" />
            </div>

            <blockquote v-if="activeDoc.sourceName || activeDoc.sourceUrl" class="citation">
              <p class="fg-label">引用出处</p>
              <SourceChip
                :label="activeDoc.sourceName || activeDoc.sourceUrl || ''"
                :href="activeDoc.sourceUrl"
              />
              <p class="citation-note">以上内容摘编自该来源，用于日常喂养参考，不作为诊疗依据。</p>
            </blockquote>

            <section v-if="relatedDocs.length" class="related">
              <h3 class="fg-section-title">相关条目</h3>
              <ul class="related-list">
                <li v-for="r in relatedDocs" :key="r.id">
                  <button type="button" class="related-row" @click="openDoc(r)">
                    <ChevronRight :size="20" class="fg-icon related-arrow" />
                    <span class="related-body">
                      <span class="related-title">{{ r.title }}</span>
                      <span class="fg-muted related-meta">
                        {{ r.sourceName || '未知来源' }}
                        <template v-if="r.updatedAt"> · <span class="fg-num">{{ dateText(r.updatedAt) }}</span></template>
                      </span>
                    </span>
                    <SeverityDot
                      v-if="r.severity"
                      :level="severityLevel(r.severity)"
                      :label="severityLabel(r.severity)"
                    />
                  </button>
                </li>
              </ul>
            </section>

            <DisclaimerBar />
          </article>
        </div>

        <aside class="aside-col">
          <section class="fg-card notice-card">
            <h2 class="fg-section-title">
              <MessagesSquare :size="20" class="fg-icon" />
              问答挪到会话里了
            </h2>
            <p class="fg-muted card-text">
              提问、追问的历史都会保留在「知识问答」，这里只负责按关键词浏览知识库。
            </p>
            <el-button type="primary" class="mode-cta" @click="mode = 'chat'">
              <ArrowLeft :size="16" class="fg-icon" />
              返回知识问答
            </el-button>
          </section>

          <p class="fg-muted aside-note">
            问答与检索均基于已审核的知识库条目；红线症状一律不给出居家处理建议。
          </p>
        </aside>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import dayjs from 'dayjs'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  ArrowLeft,
  ArrowUp,
  BookOpen,
  CalendarPlus,
  ChevronRight,
  Download,
  Ellipsis,
  History,
  Info,
  MessagesSquare,
  Search,
  ShieldAlert,
  Sparkles,
  SquarePen,
  ThumbsDown,
  ThumbsUp,
  TriangleAlert,
  X,
} from 'lucide-vue-next'
import { aiApi } from '@/api/ai'
import { chatApi } from '@/api/knowledge'
import { tipApi } from '@/api/tip'
import { usePetStore } from '@/stores/pet'
import DisclaimerBar from '@/components/DisclaimerBar.vue'
import EmptyState from '@/components/EmptyState.vue'
import MarkdownContent from '@/components/MarkdownContent.vue'
import PageHeader from '@/components/PageHeader.vue'
import SeverityDot from '@/components/SeverityDot.vue'
import SourceChip from '@/components/SourceChip.vue'
import { dateText } from '@/utils/format'
import type {
  AiPendingAction,
  AiToolCall,
  ChatMessage,
  ChatSession,
  ChatSource,
  FeedbackStats,
  KnowledgeDoc,
  WeeklyReviewResp,
} from '@/types'

const petStore = usePetStore()
const route = useRoute()

const LAST_CHAT_KEY = 'fg_last_chat'
const PAGE_SIZE = 10
/** 红线命中时后端把回答和降级响应都标成 fallback，前端无法区分，所以自己判红线、自己出这段文案 */
const REDLINE_TEXT =
  '您描述的症状可能属于紧急情况。请立即带宠物前往最近的宠物医院，本平台不提供居家处理建议。'

const suggested = [
  '幼犬一天喂几顿？',
  '猫可以喝牛奶吗？',
  '换粮怎么过渡？',
  '狗狗掉毛厉害怎么办？',
]
const composerSuggests = suggested.slice(0, 3)

/** 顶栏是 sticky，问答页要自己占满一屏并在内部滚动 */
const mode = ref<'chat' | 'browse'>('chat')
const drawerOpen = ref(false)

const sessions = ref<ChatSession[]>([])
const sessionsCursor = ref<string | null>(null)
const sessionsMore = ref(false)
const loadingSessions = ref(false)
const loadingMoreSessions = ref(false)
const sessKeyword = ref('')

const activeId = ref<number | null>(null)
const messages = ref<ChatMessage[]>([])
const messagesCursor = ref<string | null>(null)
const messagesMore = ref(false)
const loadingMessages = ref(false)
const loadingMore = ref(false)

/** 工具轨迹只保留最近一条回答；服务端不存轨迹，回读消息后用最新 ai 消息 id 挂载 */
const lastTrace = ref<AiToolCall[]>([])
const lastTraceId = ref<number | null>(null)
/** 本次查询失败的工具展示名，和轨迹一起挂在最新回答下 */
const lastFailed = ref<string[]>([])

/** 当前用户的回答反馈读数；侧栏只展示已有评价的情况 */
const stats = ref<FeedbackStats | null>(null)

/** Agent 的写操作只出计划，用户确认后才真正落库 */
const pendingAction = ref<AiPendingAction | null>(null)
const pendingForId = ref<number | null>(null)
const pendingBusy = ref(false)
const pendingCreated = ref(false)
const feedbackBusy = ref<number | null>(null)

const draft = ref('')
const asking = ref(false)
const askingQuestion = ref('')
const askError = ref<string | null>(null)
const persistError = ref(false)
const renaming = ref(false)
const renameValue = ref('')
const renameInput = ref<HTMLInputElement>()
const threadEl = ref<HTMLElement>()

/** 乐观上屏的消息还没有数据库 id，先用负数占位，落库回读后替换 */
let seq = 0

const activeChat = computed(() => sessions.value.find((s) => s.id === activeId.value) ?? null)

const visibleSessions = computed(() => {
  const kw = sessKeyword.value.trim().toLowerCase()
  if (!kw) return sessions.value
  return sessions.value.filter((s) => s.title.toLowerCase().includes(kw))
})

/** 左栏按 今天 / 昨天 / 更早 分组；列表本身已是 updated_at 倒序 */
const sessionGroups = computed(() => {
  const buckets = new Map<string, ChatSession[]>()
  for (const s of visibleSessions.value) {
    const label = groupLabel(s.updatedAt)
    const list = buckets.get(label)
    if (list) list.push(s)
    else buckets.set(label, [s])
  }
  return [...buckets.entries()].map(([label, items]) => ({ label, items }))
})

function groupLabel(value: string) {
  const d = dayjs(value)
  if (d.isSame(dayjs(), 'day')) return '今天'
  if (d.isSame(dayjs().subtract(1, 'day'), 'day')) return '昨天'
  return '更早'
}

type Seg = { text: string; cite?: number }
type Row =
  | { kind: 'day'; key: string; label: string }
  | { kind: 'user'; key: string; text: string }
  | { kind: 'ai'; key: string; message: ChatMessage; segments: Seg[] }

/** 把正文里的 [1] [2] 切成角标；没有来源或角标越界就当普通文本，避免角标对不上号 */
function segments(content: string, count: number): Seg[] {
  if (!count) return [{ text: content }]
  const out: Seg[] = []
  const re = /\[(\d{1,2})\]/g
  let last = 0
  let m: RegExpExecArray | null
  while ((m = re.exec(content))) {
    const n = Number(m[1])
    if (n < 1 || n > count) continue
    if (m.index > last) out.push({ text: content.slice(last, m.index) })
    out.push({ text: '', cite: n })
    last = m.index + m[0].length
  }
  if (last < content.length) out.push({ text: content.slice(last) })
  return out.length ? out : [{ text: content }]
}

/** 模型偶尔会输出 Markdown 加粗；先转义再只放开 **...**，其余标签一律当文本 */
function inlineBold(text: string): string {
  const escaped = text.replace(/[&<>"']/g, (ch) =>
    ch === '&' ? '&amp;' : ch === '<' ? '&lt;' : ch === '>' ? '&gt;' : ch === '"' ? '&quot;' : '&#39;',
  )
  return escaped.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>')
}

const threadRows = computed<Row[]>(() => {
  const rows: Row[] = []
  let day = ''
  for (const m of messages.value) {
    const d = m.createdAt.slice(0, 10)
    if (d !== day) {
      day = d
      rows.push({ kind: 'day', key: `d-${d}`, label: dayLabel(d) })
    }
    rows.push(
      m.role === 'user'
        ? { kind: 'user', key: `m-${m.id}`, text: m.content }
        : { kind: 'ai', key: `m-${m.id}`, message: m, segments: segments(m.content, m.sources.length) },
    )
  }
  return rows
})

function dayLabel(value: string) {
  const d = dayjs(value)
  if (d.isSame(dayjs(), 'day')) return '今天'
  if (d.isSame(dayjs().subtract(1, 'day'), 'day')) return '昨天'
  return d.format('YYYY-MM-DD')
}

function clockText(value: string) {
  return dayjs(value).format('HH:mm')
}

function timeText(value: string) {
  const d = dayjs(value)
  if (d.isSame(dayjs(), 'day')) return d.format('HH:mm')
  if (d.isSame(dayjs().subtract(1, 'day'), 'day')) return '昨天'
  return d.format('MM-DD')
}

function severityLabel(s: string) {
  return s === 'emergency' ? '紧急' : s === 'caution' ? '注意' : '科普'
}

function severityLevel(s: string): 'info' | 'warning' | 'danger' {
  return s === 'emergency' ? 'danger' : s === 'caution' ? 'warning' : 'info'
}

function sourceTypeLabel(t?: string) {
  if (!t) return '知识库'
  if (t === 'standard') return '标准'
  if (t === 'book') return '书籍'
  if (t === 'official') return '官方指南'
  if (t === 'article') return '文章'
  return t
}

function speciesLabel(v: string) {
  return v === 'dog' ? '犬' : v === 'cat' ? '猫' : v === 'both' ? '犬猫通用' : v
}

function lifeStageLabel(v: string) {
  const key = v.toLowerCase()
  if (key === 'young' || key === 'baby') return '幼年'
  if (key === 'adult') return '成年'
  if (key === 'senior') return '老年'
  if (key === 'all') return '全阶段'
  return v
}

async function loadSessions() {
  loadingSessions.value = true
  try {
    const page = await chatApi.sessions({ limit: 20 })
    sessions.value = page.records
    sessionsCursor.value = page.nextCursor
    sessionsMore.value = page.hasMore
  } finally {
    loadingSessions.value = false
  }
}

async function loadMoreSessions() {
  if (!sessionsCursor.value) return
  loadingMoreSessions.value = true
  try {
    const page = await chatApi.sessions({ cursor: sessionsCursor.value, limit: 20 })
    sessions.value = dedupeById([...sessions.value, ...page.records], (s) => s.id)
    sessionsCursor.value = page.nextCursor
    sessionsMore.value = page.hasMore
  } finally {
    loadingMoreSessions.value = false
  }
}

/** silent 用于落库后回读同一页，避免闪一下骨架 */
async function fetchMessages(id: number, silent = false) {
  if (!silent) loadingMessages.value = true
  try {
    const page = await chatApi.messages(id, { limit: PAGE_SIZE })
    messages.value = page.records
    messagesCursor.value = page.nextCursor
    messagesMore.value = page.hasMore
  } finally {
    if (!silent) loadingMessages.value = false
  }
}

/** 头插前记住高度，插完把多出来的那段补回 scrollTop，视图才不会跳到顶 */
async function loadMoreMessages() {
  if (!activeId.value || !messagesCursor.value) return
  const el = threadEl.value
  loadingMore.value = true
  try {
    const page = await chatApi.messages(activeId.value, { cursor: messagesCursor.value, limit: PAGE_SIZE })
    const prevHeight = el?.scrollHeight ?? 0
    const prevTop = el?.scrollTop ?? 0
    messages.value = dedupeById([...page.records, ...messages.value], (m) => m.id)
    messagesCursor.value = page.nextCursor
    messagesMore.value = page.hasMore
    await nextTick()
    if (el) el.scrollTop = el.scrollHeight - prevHeight + prevTop
  } finally {
    loadingMore.value = false
  }
}

async function openChat(id: number) {
  if (id === activeId.value) return
  drawerOpen.value = false
  activeId.value = id
  askError.value = null
  persistError.value = false
  lastTrace.value = []
  lastTraceId.value = null
  lastFailed.value = []
  pendingAction.value = null
  pendingForId.value = null
  pendingCreated.value = false
  localStorage.setItem(LAST_CHAT_KEY, String(id))
  await fetchMessages(id)
  await nextTick()
  scrollToBottom()
}

/** 空白新对话：不落库，第一条问题发出时才建会话 */
function newChat() {
  drawerOpen.value = false
  activeId.value = null
  messages.value = []
  messagesCursor.value = null
  messagesMore.value = false
  askError.value = null
  persistError.value = false
  lastTrace.value = []
  lastTraceId.value = null
  lastFailed.value = []
  pendingAction.value = null
  pendingForId.value = null
  pendingCreated.value = false
  draft.value = ''
  localStorage.removeItem(LAST_CHAT_KEY)
}

function askFrom(q: string) {
  draft.value = q
  submit(q)
}

async function submit(rawQuestion: string) {
  const q = rawQuestion.trim()
  if (!q || asking.value) return
  // 计划还没确认时把 token 带上，服务端才能把「改成八点」识别为修改而不是新提醒
  const priorPending = pendingAction.value && !pendingCreated.value ? pendingAction.value : null
  asking.value = true
  askingQuestion.value = q
  askError.value = null
  persistError.value = false
  lastFailed.value = []
  draft.value = ''
  scrollThreadToBottomSoon()

  let answer: string
  let sources: ChatSource[] = []
  let trace: AiToolCall[] = []
  let failed: string[] = []
  let pending: AiPendingAction | null = null
  let fallback = false
  let redline = false
  try {
    // 红线优先：命中就不调用 LLM。后端把红线和降级都标成 fallback 分不出来，只能自己判
    redline = await tipApi.checkRedline(q).catch(() => false)
    if (redline) {
      answer = REDLINE_TEXT
    } else {
      const resp = await aiApi.query({
        query: q,
        petId: petStore.currentPet?.id,
        sessionId: activeId.value ?? undefined,
        pendingToken: priorPending?.token,
      })
      answer = resp.content
      fallback = resp.isFallback
      sources = resp.sources
      trace = resp.toolCalls ?? []
      failed = resp.failedTools ?? []
      pending = resp.pendingAction ?? null
    }
  } catch (e) {
    // 没答上来的问题不写进历史，只留一条错误条 + 重试；保留问题文本供重试
    askError.value = e instanceof Error && e.message ? e.message : '请求失败，请稍后重试'
    asking.value = false
    return
  }

  try {
    if (!activeId.value) {
      const created = await chatApi.create({ title: q.slice(0, 20), petId: petStore.currentPet?.id })
      sessions.value = dedupeById([created, ...sessions.value], (s) => s.id)
      activeId.value = created.id
      localStorage.setItem(LAST_CHAT_KEY, String(created.id))
    }
    const id = activeId.value
    messages.value = [
      ...messages.value,
      localMessage('user', q),
      localMessage('ai', answer, sources, redline, fallback),
    ]
    scrollThreadToBottomSoon()

    try {
      await chatApi.append(id, {
        question: q,
        answer,
        sourceDocIds: sources.map((s) => s.docId),
        isRedLine: redline,
        isFallback: fallback,
      })
    } catch {
      persistError.value = true
      return
    }
    // 回读同一页：来源卡片要用服务端补全的 sourceType/severity，消息也要换成真实 id
    await fetchMessages(id, true)
    const lastAi = [...messages.value].reverse().find((m) => m.role === 'ai')
    lastTrace.value = trace
    lastTraceId.value = lastAi?.id ?? null
    lastFailed.value = failed
    if (pending) {
      pendingAction.value = pending
      pendingForId.value = lastAi?.id ?? null
      pendingCreated.value = false
    } else if (!priorPending) {
      // 没有可延续的旧计划才清空；追问补充字段时旧卡片要留着，用户才能继续确认
      pendingAction.value = null
      pendingForId.value = null
      pendingCreated.value = false
    }
    await refreshSessions()
  } finally {
    asking.value = false
    askingQuestion.value = ''
    scrollThreadToBottomSoon()
  }
}

function localMessage(
  role: 'user' | 'ai',
  content: string,
  sources: ChatSource[] = [],
  redLine = false,
  fallback = false,
): ChatMessage {
  return {
    id: -++seq,
    role,
    content,
    sources,
    isRedLine: redLine,
    isFallback: fallback,
    createdAt: dayjs().format('YYYY-MM-DDTHH:mm:ss'),
  }
}

/** 反馈按消息 id 落在服务端，刷新后仍保留；失败回滚本地状态 */
async function rate(msg: ChatMessage, useful: boolean) {
  if (msg.id < 0 || feedbackBusy.value === msg.id) return
  const prev = msg.feedback ?? null
  feedbackBusy.value = msg.id
  msg.feedback = useful ? 1 : 0
  try {
    await chatApi.rateMessage(msg.id, useful)
    void loadStats()
  } catch {
    msg.feedback = prev
  } finally {
    feedbackBusy.value = null
  }
}

async function loadStats() {
  try {
    stats.value = await chatApi.feedbackStats()
  } catch {
    /* 读数是附带信息，拉不到不影响问答 */
  }
}

/** Agent 只出计划；确认时只回传 token，落库字段以服务端保存的那份为准 */
async function confirmPending() {
  const action = pendingAction.value
  if (!action || pendingBusy.value || pendingCreated.value) return
  pendingBusy.value = true
  try {
    const created = await aiApi.confirmAction(action.token)
    pendingCreated.value = true
    ElMessage.success(created.repeated ? '这条提醒之前已经创建过了' : '提醒已创建')
  } catch {
    /* 错误提示由 request 拦截器统一处理 */
  } finally {
    pendingBusy.value = false
  }
}

function dismissPending() {
  pendingAction.value = null
  pendingForId.value = null
}

/* ===== 本周照护复盘：照护分析 Agent → 行动计划 Agent ===== */
const reviewBusy = ref(false)
const review = ref<WeeklyReviewResp | null>(null)
const reviewError = ref<string | null>(null)
const reviewPending = ref<AiPendingAction | null>(null)
const reviewPendingBusy = ref(false)
const reviewPendingCreated = ref(false)

async function runWeeklyReview() {
  if (reviewBusy.value) return
  const pet = petStore.currentPet
  if (!pet) {
    reviewError.value = '请先在宠物档案里选择一只宠物'
    review.value = null
    return
  }
  reviewBusy.value = true
  reviewError.value = null
  review.value = null
  reviewPending.value = null
  reviewPendingCreated.value = false
  try {
    const resp = await aiApi.weeklyReview({ petId: pet.id })
    review.value = resp
    reviewPending.value = resp.pendingAction ?? null
  } catch (e) {
    reviewError.value = e instanceof Error && e.message ? e.message : '复盘失败，请稍后重试'
  } finally {
    reviewBusy.value = false
  }
}

function closeReview() {
  review.value = null
  reviewError.value = null
  reviewPending.value = null
  reviewPendingCreated.value = false
}

/** 复盘里的提醒同样只回传服务端 token，规则和普通问答一致 */
async function confirmReviewPending() {
  const action = reviewPending.value
  if (!action || reviewPendingBusy.value || reviewPendingCreated.value) return
  reviewPendingBusy.value = true
  try {
    const created = await aiApi.confirmAction(action.token)
    reviewPendingCreated.value = true
    ElMessage.success(created.repeated ? '这条提醒之前已经创建过了' : '提醒已创建')
  } catch {
    /* 错误提示由 request 拦截器统一处理 */
  } finally {
    reviewPendingBusy.value = false
  }
}

function stepStatusText(status: string) {
  if (status === 'PARTIAL') return '部分数据缺失'
  if (status === 'FAILED') return '未完成'
  return '已完成'
}

function openReviewSource(src: { docId: number; title: string; sourceName: string }) {
  void openSource({ ...src })
}

/** 服务端会刷新 updated_at 和两个计数，重新拉一次比本地猜准 */
async function refreshSessions() {
  try {
    const page = await chatApi.sessions({ limit: 20 })
    sessions.value = page.records
    sessionsCursor.value = page.nextCursor
    sessionsMore.value = page.hasMore
  } catch {
    /* 列表刷新失败不影响已经上屏的问答 */
  }
}

function onSessionCommand(cmd: string, session: ChatSession) {
  if (cmd === 'rename') {
    if (session.id === activeId.value) startRename()
    else renamePrompt(session)
  } else if (cmd === 'remove') {
    removeSession(session)
  }
}

function startRename() {
  const chat = activeChat.value
  if (!chat) return
  renameValue.value = chat.title
  renaming.value = true
  nextTick(() => renameInput.value?.focus())
}

async function commitRename() {
  const chat = activeChat.value
  if (!renaming.value || !chat) return
  renaming.value = false
  const title = renameValue.value.trim()
  if (!title || title === chat.title) return
  const prev = chat.title
  chat.title = title
  try {
    await chatApi.rename(chat.id, title)
  } catch {
    chat.title = prev
  }
}

async function renamePrompt(session: ChatSession) {
  try {
    const { value } = await ElMessageBox.prompt('会话名称', '重命名', {
      inputValue: session.title,
      confirmButtonText: '保存',
      cancelButtonText: '取消',
    })
    const title = (value || '').trim()
    if (!title || title === session.title) return
    session.title = title
    await chatApi.rename(session.id, title)
  } catch {
    /* 取消 */
  }
}

async function removeSession(session: ChatSession) {
  try {
    await ElMessageBox.confirm(`删除「${session.title}」及其全部消息？`, '删除会话', {
      type: 'warning',
      confirmButtonText: '删除',
      cancelButtonText: '取消',
    })
  } catch {
    return
  }
  await chatApi.remove(session.id)
  sessions.value = sessions.value.filter((s) => s.id !== session.id)
  if (session.id === activeId.value) {
    const next = sessions.value[0]
    if (next) {
      await openChat(next.id)
    } else {
      newChat()
    }
  }
  ElMessage.success('已删除')
}

/** ↑/↓ 在左栏移动选中项 */
function moveSelection(delta: number) {
  const list = visibleSessions.value
  if (!list.length) return
  const at = list.findIndex((s) => s.id === activeId.value)
  const next = list[Math.min(Math.max(at + delta, 0), list.length - 1)]
  if (next) openChat(next.id)
}

function exportChat() {
  const chat = activeChat.value
  if (!chat) return
  const lines = [`# ${chat.title}`, '']
  for (const m of messages.value) {
    lines.push(`**${m.role === 'user' ? '我' : 'FurGuardian'}** · ${clockText(m.createdAt)}`)
    lines.push('')
    lines.push(m.content)
    if (m.sources.length) {
      lines.push('')
      lines.push(...m.sources.map((s) => `- 来源：${s.title}（${s.sourceName}）`))
    }
    lines.push('')
  }
  lines.push('> 以上内容由知识库检索生成，不构成医疗建议。')
  const blob = new Blob([lines.join('\n')], { type: 'text/markdown;charset=utf-8' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `${chat.title}.md`
  a.click()
  URL.revokeObjectURL(url)
}

function scrollToBottom() {
  const el = threadEl.value
  if (el) el.scrollTop = el.scrollHeight
}

function scrollThreadToBottomSoon() {
  nextTick(() => scrollToBottom())
}

/** 来源卡片跳到「浏览知识库」里的对应条目 */
async function openSource(src: ChatSource) {
  mode.value = 'browse'
  activeTopic.value = null
  searchQuery.value = src.title
  await search()
  const hit = docs.value.find((d) => d.id === src.docId)
  if (hit) activeDoc.value = hit
}

function dedupeById<T>(rows: T[], idOf: (row: T) => number): T[] {
  const seen = new Set<number>()
  return rows.filter((row) => (seen.has(idOf(row)) ? false : (seen.add(idOf(row)), true)))
}

/* ---------- 以下为「浏览知识库」的原有逻辑 ---------- */

const topics = ['营养', '护理', '症状', '季节']

const searchQuery = ref('')
const searchSpecies = ref<string>()
const searchLifeStage = ref<string>()
const searching = ref(false)
const searched = ref(false)
const docs = ref<KnowledgeDoc[]>([])
const activeTopic = ref<string | null>(null)
const activeDoc = ref<KnowledgeDoc | null>(null)

watch(searchQuery, (value) => {
  if (value !== activeTopic.value) activeTopic.value = null
})

async function search() {
  if (!searchQuery.value.trim()) {
    ElMessage.warning('请输入检索关键词')
    return
  }
  searching.value = true
  try {
    docs.value = await aiApi.search({
      query: searchQuery.value.trim(),
      species: searchSpecies.value,
      lifeStage: searchLifeStage.value,
      topN: 10,
    })
    searched.value = true
    activeDoc.value = null
  } finally {
    searching.value = false
  }
}

function pickTopic(topic: string) {
  activeTopic.value = topic
  searchQuery.value = topic
  search()
}

function openDoc(doc: KnowledgeDoc) {
  activeDoc.value = doc
}

function topicList(topicsField?: string, limit = 3): string[] {
  if (!topicsField) return []
  return topicsField
    .split(/[,，、;；]/)
    .map((t) => t.trim())
    .filter(Boolean)
    .slice(0, limit)
}

/** 列表摘要去掉 markdown 标记，正文详情再由 MarkdownContent 渲染 */
function plainText(content?: string): string {
  if (!content) return ''
  return content
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/!\[[^\]]*]\([^)]*\)/g, ' ')
    .replace(/\[([^\]]*)]\([^)]*\)/g, '$1')
    .replace(/^\s{0,3}#{1,6}\s+/gm, '')
    .replace(/^\s{0,3}>\s?/gm, '')
    .replace(/^\s*[-*+]\s+/gm, '')
    .replace(/^\s*\d+\.\s+/gm, '')
    .replace(/^\s*\|?(?:\s*:?-+:?\s*\|)+.*$/gm, '')
    .replace(/[|*_~`]/g, '')
    .replace(/\s+/g, ' ')
    .trim()
}

const relatedDocs = computed(() => {
  const current = activeDoc.value
  if (!current) return []
  const mine = topicList(current.topics, 99)
  return docs.value
    .filter((d) => d.id !== current.id)
    .filter((d) => topicList(d.topics, 99).some((t) => mine.includes(t)))
    .slice(0, 5)
})

onMounted(async () => {
  await loadSessions()
  void loadStats()
  const last = Number(localStorage.getItem(LAST_CHAT_KEY))
  const restore = sessions.value.find((s) => s.id === last) ?? sessions.value[0]
  if (restore) await openChat(restore.id)

  // 疫苗/驱虫提醒的「问一问」深链：只预填问题，由用户确认后再发送
  const preset = route.query.q
  if (typeof preset === 'string' && preset.trim()) {
    draft.value = preset.trim().slice(0, 500)
  }
})
</script>

<style scoped>
/* ============================================================
   问答页骨架：左 300 会话栏 + 右消息流，整页占满一屏内部滚动
   ============================================================ */
.chat-page {
  display: flex;
  align-items: stretch;
  height: calc(100vh - var(--fg-topbar-h));
  padding-top: 0;
  padding-bottom: 0;
  overflow: hidden;
}

.drawer-mask {
  display: none;
}

/* ---------- 左栏 ---------- */
.sess-pane {
  flex: none;
  width: 300px;
  display: flex;
  flex-direction: column;
  border-right: var(--fg-line-w) solid var(--fg-line);
  background: var(--fg-surface);
}

.pane-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 56px;
  padding: 0 var(--fg-s4);
  flex: none;
}

.pane-title {
  margin: 0;
  font-size: var(--fg-text-body);
  font-weight: 600;
  letter-spacing: 0.02em;
}

.icon-btn {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  transition: color var(--fg-motion);
}

.icon-btn:hover {
  color: var(--fg-accent);
}

.sess-search {
  padding: 0 var(--fg-s4) var(--fg-s3);
}

.sess-search :deep(.el-input__wrapper) {
  height: 36px;
  padding: 0 var(--fg-s3);
}

.sess-scroll {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  padding: 0 var(--fg-s2) var(--fg-s4);
  scrollbar-width: thin;
  scrollbar-color: var(--fg-line) transparent;
}

.sess-note {
  margin: 0;
  padding: var(--fg-s4) var(--fg-s2);
  font-size: var(--fg-text-label);
  line-height: 1.7;
}

.group-label {
  margin: var(--fg-s4) var(--fg-s2) var(--fg-s2);
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--fg-ink-muted);
}

.sess-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  width: 100%;
  min-height: 64px;
  padding: var(--fg-s3) var(--fg-s3) var(--fg-s3) var(--fg-s4);
  border: none;
  border-radius: var(--fg-radius);
  background: none;
  cursor: pointer;
  text-align: left;
  font-family: inherit;
  transition: background-color var(--fg-motion);
}

.sess-item:hover {
  background: var(--fg-paper);
}

.sess-item.is-active {
  background: var(--fg-accent-soft);
}

/* active 左侧 2px 强调竖条 */
.sess-item.is-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 10px;
  bottom: 10px;
  width: 2px;
  border-radius: 1px;
  background: var(--fg-accent);
}

.sess-main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: var(--fg-s1);
}

.sess-title {
  font-size: var(--fg-text-body);
  color: var(--fg-ink);
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.sess-item.is-active .sess-title {
  color: var(--fg-accent);
  font-weight: 500;
}

.sess-meta {
  font-size: var(--fg-text-label);
}

.sess-right {
  flex: none;
  display: flex;
  align-items: center;
  gap: var(--fg-s1);
}

.sess-time {
  font-size: var(--fg-text-label);
}

.sess-more {
  opacity: 0;
}

.sess-item:hover .sess-more,
.sess-item:focus-within .sess-more {
  opacity: 1;
}

.sess-older {
  margin: var(--fg-s3) auto 0;
}

/* 回答反馈读数：只在有评价后出现，悬浮看最近差评 */
.feedback-stat {
  flex: none;
  display: flex;
  flex-direction: column;
  gap: 2px;
  width: calc(100% - 2 * var(--fg-s3));
  margin: 0 var(--fg-s3) var(--fg-s2);
  padding: var(--fg-s3);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-paper);
  font-family: inherit;
  text-align: left;
  cursor: default;
}

.fs-head {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  color: var(--fg-ink-muted);
}

.fs-body {
  display: flex;
  align-items: baseline;
  gap: var(--fg-s2);
}

.fs-rate {
  font-size: var(--fg-text-h3);
  font-weight: 600;
  color: var(--fg-ink);
}

.fs-note {
  font-size: var(--fg-text-label);
}

.fs-empty {
  font-size: var(--fg-text-label);
}

.fs-pop-head {
  margin: 0 0 var(--fg-s3);
  font-size: var(--fg-text-label);
  font-weight: 600;
  color: var(--fg-ink);
}

.fs-pop-list {
  display: flex;
  flex-direction: column;
  gap: var(--fg-s3);
  margin: 0;
  padding: 0;
  list-style: none;
}

.fs-pop-text {
  margin: 0 0 2px;
  font-size: var(--fg-text-label);
  line-height: 1.5;
  color: var(--fg-ink);
}

.fs-pop-empty {
  margin: 0;
  font-size: var(--fg-text-label);
}

.pane-foot {
  flex: none;
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  width: 100%;
  height: 48px;
  padding: 0 var(--fg-s4);
  border-top: var(--fg-line-w) solid var(--fg-line);
  border: none;
  background: none;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-body);
  color: var(--fg-accent);
  transition: background-color var(--fg-motion);
}

.pane-foot:hover {
  background: var(--fg-paper);
}

.pane-foot .fg-icon:last-child {
  margin-left: auto;
  color: var(--fg-ink-muted);
}

/* ---------- 右栏 ---------- */
.conv-pane {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  background: var(--fg-surface);
}

.conv-head {
  flex: none;
  display: flex;
  align-items: center;
  gap: var(--fg-s4);
  min-height: 56px;
  padding: 0 var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.hist-btn {
  display: none;
}

.conv-title {
  flex: 1;
  min-width: 0;
}

.conv-name {
  margin: 0;
  font-family: var(--fg-font-sans);
  font-size: var(--fg-text-lead);
  font-weight: 600;
  line-height: 1.4;
  letter-spacing: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: text;
}

.conv-name:hover {
  color: var(--fg-accent);
}

.conv-meta {
  margin: 0;
  font-size: var(--fg-text-label);
}

.rename-input {
  width: 100%;
  max-width: 420px;
  padding: var(--fg-s1) var(--fg-s2);
  border: var(--fg-line-w) solid var(--fg-accent);
  border-radius: 6px;
  background: var(--fg-surface);
  font-family: inherit;
  font-size: var(--fg-text-lead);
  color: var(--fg-ink);
}

.thread {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  padding: var(--fg-s5) var(--fg-s5) var(--fg-s4);
  scrollbar-width: thin;
  scrollbar-color: var(--fg-line) transparent;
}

.load-older {
  display: block;
  width: auto;
  margin: 0 auto var(--fg-s4);
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
  transition: color var(--fg-motion);
}

.load-older:hover {
  color: var(--fg-accent);
}

.day-sep {
  margin: var(--fg-s5) 0 var(--fg-s4);
  text-align: center;
  font-size: var(--fg-text-label);
}

.msg {
  max-width: 760px;
  margin: 0 auto var(--fg-s5);
}

.msg.is-user {
  display: flex;
  justify-content: flex-end;
  margin-bottom: var(--fg-s4);
}

.bubble {
  max-width: 70%;
  padding: var(--fg-s3) var(--fg-s4);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-paper);
  font-size: var(--fg-text-body);
  line-height: 1.7;
  white-space: pre-wrap;
  word-break: break-word;
}

.msg.is-ai {
  font-size: var(--fg-text-lead);
}

.ai-label {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  margin: 0 0 var(--fg-s2);
  font-size: var(--fg-text-label);
  letter-spacing: 0.04em;
}

.ai-time {
  margin-left: auto;
}

.ai-body {
  margin: 0;
  font-size: var(--fg-text-lead);
  line-height: 1.8;
  white-space: pre-wrap;
  word-break: break-word;
}

.ai-body :deep(strong) {
  font-weight: 600;
}

.cite {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 20px;
  height: 20px;
  margin: 0 var(--fg-s1);
  padding: 0 var(--fg-s1);
  border-radius: 4px;
  background: var(--fg-accent-soft);
  color: var(--fg-accent);
  font-family: var(--fg-font-num);
  font-size: var(--fg-text-label);
  vertical-align: 2px;
  cursor: help;
}

.redline {
  margin: 0;
}

.redline-head {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  font-weight: 600;
}

.redline-text {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-body);
  line-height: 1.7;
}

.fallback-tag {
  height: 20px;
  font-size: var(--fg-text-label);
}

.tool-trace {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: var(--fg-s2);
  margin-top: var(--fg-s3);
}

.trace-title {
  font-size: var(--fg-text-label);
}

.trace-chip {
  font-size: var(--fg-text-label);
}

.trace-chip.is-warn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: var(--fg-danger);
}

.sources {
  margin-top: var(--fg-s4);
}

.sources .fg-label {
  margin: 0 0 var(--fg-s3);
}

.source-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--fg-s3);
}

.source-card {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--fg-s1);
  padding: var(--fg-s3);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-surface);
  cursor: pointer;
  text-align: left;
  font-family: inherit;
  transition: border-color var(--fg-motion), background-color var(--fg-motion);
}

.source-card:hover {
  border-color: var(--fg-accent);
  background: var(--fg-accent-soft);
}

.source-title {
  font-size: var(--fg-text-body);
  color: var(--fg-ink);
  line-height: 1.5;
}

.source-meta {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  font-size: var(--fg-text-label);
}

.source-name {
  font-size: var(--fg-text-label);
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  max-width: 100%;
}

.ai-disclaimer {
  margin: var(--fg-s4) 0 0;
  font-size: var(--fg-text-label);
}

.answer-actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: var(--fg-s2);
  margin-top: var(--fg-s3);
}

.vote-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 2px var(--fg-s2);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: 999px;
  background: transparent;
  color: var(--fg-ink-muted);
  font-family: inherit;
  font-size: var(--fg-text-label);
  cursor: pointer;
  transition: color var(--fg-motion), border-color var(--fg-motion), background-color var(--fg-motion);
}

.vote-btn:hover {
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.vote-btn.on {
  border-color: var(--fg-accent);
  background: var(--fg-accent-soft);
  color: var(--fg-accent);
}

.vote-btn:disabled {
  cursor: default;
  opacity: 0.7;
}

.vote-thanks {
  font-size: var(--fg-text-label);
}

.pending-card {
  max-width: 560px;
  margin-top: var(--fg-s4);
  padding: var(--fg-s4);
  border: var(--fg-line-w) solid var(--fg-accent);
  border-radius: var(--fg-radius);
  background: var(--fg-accent-soft);
}

.pending-head {
  display: flex;
  align-items: center;
  gap: var(--fg-s2);
  margin: 0 0 var(--fg-s2);
  font-size: var(--fg-text-body);
  font-weight: 600;
  color: var(--fg-accent);
}

.pending-summary {
  margin: 0;
  font-size: var(--fg-text-lead);
  line-height: 1.6;
}

.pending-tip {
  margin: var(--fg-s2) 0 var(--fg-s3);
  font-size: var(--fg-text-label);
}

.pending-actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: var(--fg-s3);
}

.pending-link {
  font-size: var(--fg-text-label);
  color: var(--fg-accent);
  text-decoration: underline;
}

.ask-error {
  max-width: 760px;
  margin: 0 auto var(--fg-s5);
}

.retry-btn {
  margin-top: var(--fg-s3);
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-label);
  color: var(--fg-accent);
}

.persist-warn {
  max-width: 760px;
  margin: 0 auto var(--fg-s4);
  text-align: center;
  font-size: var(--fg-text-label);
  color: var(--fg-warning);
}

.thread-empty {
  padding: var(--fg-s6) 0;
  text-align: center;
  font-size: var(--fg-text-label);
}

/* ---------- 欢迎页 ---------- */
.welcome {
  max-width: 640px;
  margin: var(--fg-s7) auto 0;
  text-align: center;
}

.welcome-title {
  font-size: var(--fg-text-h2);
}

.welcome-sub {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-body);
  line-height: 1.8;
}

.welcome-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--fg-s3);
  margin-top: var(--fg-s6);
}

.suggest-card {
  padding: var(--fg-s4);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-surface);
  cursor: pointer;
  text-align: left;
  font-family: inherit;
  font-size: var(--fg-text-body);
  line-height: 1.6;
  color: var(--fg-ink);
  transition: border-color var(--fg-motion), color var(--fg-motion);
}

.suggest-card:hover {
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.welcome-browse {
  margin-top: var(--fg-s5);
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.welcome-browse:hover {
  color: var(--fg-accent);
}

/* ---------- 输入区 ---------- */
.composer {
  flex: none;
  padding: var(--fg-s4) var(--fg-s5) var(--fg-s3);
  border-top: var(--fg-line-w) solid var(--fg-line);
  background: var(--fg-surface);
}

.composer .chips {
  max-width: 760px;
  margin: 0 auto var(--fg-s3);
}

.input-row {
  display: flex;
  align-items: flex-end;
  gap: var(--fg-s3);
  max-width: 760px;
  margin: 0 auto;
}

.input-row :deep(.el-textarea__inner) {
  padding: var(--fg-s3);
  font-size: var(--fg-text-body);
  line-height: 1.7;
}

.send-btn {
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border: none;
  border-radius: 50%;
  background: var(--fg-accent);
  color: #fff;
  cursor: pointer;
  transition: background-color var(--fg-motion), opacity var(--fg-motion);
}

.send-btn:hover:not(:disabled) {
  background: var(--fg-accent-hover);
}

.send-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.composer-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--fg-s3);
  max-width: 760px;
  margin: var(--fg-s2) auto 0;
  font-size: var(--fg-text-label);
}

/* ---------- 本周照护复盘（双 Agent） ---------- */
.review-trigger {
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.review-trigger:disabled {
  opacity: 0.5;
  cursor: default;
}

.review-panel {
  flex: none;
  max-height: 56vh;
  overflow-y: auto;
  overflow-x: hidden;
  overscroll-behavior: contain;
  padding: var(--fg-s4) var(--fg-s5);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  background: var(--fg-paper);
  scrollbar-width: thin;
  scrollbar-color: var(--fg-line) transparent;
}

.review-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: var(--fg-s3);
  min-width: 0;
  max-width: 1000px;
  margin: 0 auto var(--fg-s3);
}

.review-heading {
  min-width: 0;
}

.review-title {
  margin: 0;
  font-size: var(--fg-text-body);
  font-weight: 600;
  color: var(--fg-ink);
}

.review-sub {
  margin: 2px 0 0;
  font-size: var(--fg-text-label);
  overflow-wrap: anywhere;
}

.review-loading {
  display: flex;
  flex-direction: column;
  gap: var(--fg-s2);
  max-width: 1000px;
  margin: 0 auto;
}

.review-loading p {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-label);
}

.review-error {
  max-width: 1000px;
  margin: 0 auto;
  font-size: var(--fg-text-label);
  color: var(--fg-danger);
}

.review-steps {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--fg-s3);
  align-items: start;
  max-width: 1000px;
  margin: 0 auto;
}

.review-card {
  min-width: 0;
  padding: var(--fg-s4);
  border: var(--fg-line-w) solid var(--fg-line);
  border-radius: var(--fg-radius);
  background: var(--fg-surface);
  overflow-wrap: anywhere;
}

.review-card.is-partial {
  border-color: var(--fg-warning);
  background: var(--fg-warning-soft);
}

.review-card.is-failed {
  border-style: dashed;
  color: var(--fg-ink-muted);
}

.card-head {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: var(--fg-s2);
  row-gap: var(--fg-s1);
  margin-bottom: var(--fg-s2);
}

.card-index {
  font-size: var(--fg-text-label);
  color: var(--fg-accent);
}

.card-kicker {
  margin: 0;
  font-size: var(--fg-text-label);
  font-weight: 600;
  color: var(--fg-ink);
}

.card-status {
  margin-left: auto;
}

.card-ms {
  font-size: var(--fg-text-label);
}

.card-text {
  margin: 0 0 var(--fg-s3);
  font-size: var(--fg-text-body);
  line-height: 1.7;
  white-space: pre-wrap;
}

.card-block {
  margin-bottom: var(--fg-s3);
}

.fact-list {
  margin: var(--fg-s1) 0 0;
  padding-left: 1.1em;
  font-size: var(--fg-text-label);
  line-height: 1.7;
}

.fact-list li {
  margin-bottom: 2px;
}

.card-missing {
  margin: 0 0 var(--fg-s2);
  font-size: var(--fg-text-label);
  color: var(--fg-warning);
}

.review-card .tool-trace {
  margin-top: var(--fg-s2);
}

.review-card .source-grid {
  margin-top: var(--fg-s1);
}

.review-card .pending-card {
  position: sticky;
  bottom: calc(var(--fg-s2) * -1);
  z-index: 2;
  margin-top: var(--fg-s3);
  background: var(--fg-surface);
  box-shadow: 0 -8px 16px rgba(0, 0, 0, 0.08);
}

@media (max-width: 767.98px) {
  .review-panel {
    max-height: 50vh;
    max-height: 50dvh;
    padding: var(--fg-s3);
  }

  .review-steps {
    grid-template-columns: minmax(0, 1fr);
    gap: var(--fg-s2);
  }

  .review-card {
    padding: var(--fg-s3);
  }
}

/* ---------- 骨架 ---------- */
.skeleton {
  max-width: 760px;
  margin: 0 auto var(--fg-s5);
  display: flex;
  flex-direction: column;
  gap: var(--fg-s2);
}

.skeleton.is-user {
  align-items: flex-end;
  max-width: 40%;
  margin-left: auto;
}

.sk-line {
  display: block;
  height: 12px;
  border-radius: 4px;
  background: var(--fg-line);
}

.loading-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--fg-accent);
  flex: none;
}

/* ============================================================
   浏览模式（原有样式）
   ============================================================ */
.back-chat-btn .fg-icon {
  margin-right: var(--fg-s2);
}

.mode-cta {
  width: 100%;
  margin-top: var(--fg-s4);
}

.mode-cta .fg-icon {
  margin-right: var(--fg-s2);
}

.result-count {
  font-size: var(--fg-text-label);
  padding-bottom: var(--fg-s1);
}

.hero {
  margin-bottom: var(--fg-s5);
}

.hero .fg-label {
  margin: 0 0 var(--fg-s3);
}

.hero-row {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.hero-input {
  flex: 1;
  min-width: 0;
}

.hero-input :deep(.el-input__wrapper) {
  height: 48px;
  padding: 0 var(--fg-s3);
}

.hero-input :deep(.el-input__prefix) {
  color: var(--fg-ink-muted);
  margin-right: var(--fg-s2);
}

.hero-input :deep(.el-input__inner) {
  font-size: var(--fg-text-lead);
}

.hero-sep {
  border-top: var(--fg-line-w) solid var(--fg-line);
  margin: var(--fg-s4) 0;
}

.hero-filters {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: var(--fg-s5);
  flex-wrap: wrap;
}

.filter-block .fg-label {
  margin: 0 0 var(--fg-s3);
}

.chips {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s2);
}

.topic-chip {
  cursor: pointer;
  font-family: inherit;
  height: 28px;
  padding: 0 var(--fg-s3);
  transition: background-color var(--fg-motion), color var(--fg-motion), border-color var(--fg-motion);
}

.topic-chip:hover {
  border-color: var(--fg-line-strong);
  color: var(--fg-ink);
}

.topic-chip.is-active {
  background: var(--fg-accent-soft);
  border-color: var(--fg-accent);
  color: var(--fg-accent);
}

.dims {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
}

.dim-select {
  width: 120px;
}

.main-col,
.aside-col {
  min-width: 0;
}

.aside-col {
  position: sticky;
  top: calc(var(--fg-topbar-h) + var(--fg-s5));
}

.list-hint {
  margin: 0;
  padding: var(--fg-s4) 0;
}

.doc-list {
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.doc-row {
  display: block;
  width: 100%;
  padding: var(--fg-s4) 0;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  cursor: pointer;
  transition: background-color var(--fg-motion);
}

.doc-row:hover {
  background: var(--fg-paper);
}

.doc-row:hover .doc-title {
  color: var(--fg-accent);
}

.row-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--fg-s4);
}

.doc-title {
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-lead);
  font-weight: 600;
  letter-spacing: -0.01em;
  line-height: 1.5;
  transition: color var(--fg-motion);
}

.row-severity {
  flex: none;
}

.doc-excerpt {
  margin: var(--fg-s2) 0 0;
  font-size: var(--fg-text-body);
  line-height: 1.7;
  color: var(--el-text-color-regular);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.row-meta {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s3);
  margin-top: var(--fg-s3);
  font-size: var(--fg-text-label);
}

.meta-source {
  max-width: 320px;
}

.row-topic {
  height: 20px;
}

.reading {
  max-width: 720px;
}

.back-btn {
  display: inline-flex;
  align-items: center;
  gap: var(--fg-s2);
  padding: 0;
  margin-bottom: var(--fg-s4);
  border: none;
  background: none;
  cursor: pointer;
  font-family: inherit;
  font-size: var(--fg-text-body);
  color: var(--fg-ink-muted);
  transition: color var(--fg-motion);
}

.back-btn:hover {
  color: var(--fg-accent);
}

.reading-title {
  font-family: var(--fg-font-serif);
  font-size: var(--fg-text-h2);
  font-weight: 600;
  line-height: 1.35;
  letter-spacing: -0.02em;
  margin: 0;
}

.reading-meta {
  margin: var(--fg-s3) 0 0;
  font-size: var(--fg-text-label);
  color: var(--fg-ink-muted);
}

.reading-tags {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--fg-s3);
  margin: var(--fg-s4) 0;
  padding-bottom: var(--fg-s4);
  border-bottom: var(--fg-line-w) solid var(--fg-line);
}

.reading-body p {
  margin: 0 0 var(--fg-s4);
  font-size: var(--fg-text-lead);
  line-height: 1.8;
  color: var(--fg-ink);
}

.citation {
  margin: var(--fg-s5) 0 0;
  padding: var(--fg-s3) 0 var(--fg-s3) var(--fg-s4);
  border-left: var(--fg-line-w) solid var(--fg-line-strong);
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--fg-s2);
}

.citation .fg-label {
  margin: 0;
}

.citation-note {
  margin: 0;
  font-size: var(--fg-text-label);
  line-height: 1.7;
  color: var(--fg-ink-muted);
}

.related {
  margin-top: var(--fg-s6);
}

.related-list {
  margin: 0;
  padding: 0;
  list-style: none;
  border-top: var(--fg-line-w) solid var(--fg-line);
}

.related-row {
  display: flex;
  align-items: center;
  gap: var(--fg-s3);
  width: 100%;
  padding: var(--fg-s3) 0;
  border: none;
  border-bottom: var(--fg-line-w) solid var(--fg-line);
  background: none;
  cursor: pointer;
  text-align: left;
  font-family: inherit;
  color: var(--fg-ink);
  transition: color var(--fg-motion);
}

.related-row:hover .related-title {
  color: var(--fg-accent);
}

.related-arrow {
  color: var(--fg-ink-muted);
}

.related-body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: var(--fg-s1);
}

.related-title {
  font-size: var(--fg-text-body);
  font-weight: 500;
  transition: color var(--fg-motion);
}

.related-meta {
  font-size: var(--fg-text-label);
}

.notice-card .card-text {
  margin: 0;
  font-size: var(--fg-text-body);
  line-height: 1.8;
}

.aside-note {
  margin: var(--fg-s4) 0 0;
  padding-top: var(--fg-s3);
  border-top: var(--fg-line-w) solid var(--fg-line);
  font-size: var(--fg-text-label);
  line-height: 1.7;
}

@media (max-width: 1024px) {
  .aside-col {
    position: static;
  }
  .hero-filters {
    align-items: flex-start;
  }
  .hist-btn {
    display: inline-flex;
  }
  .source-grid {
    grid-template-columns: minmax(0, 1fr);
  }
  .sess-pane {
    position: fixed;
    top: var(--fg-topbar-h);
    left: 0;
    bottom: 0;
    width: 300px;
    z-index: 60;
    transform: translateX(-100%);
    transition: transform var(--fg-motion);
  }
  .sess-pane.is-open {
    transform: translateX(0);
  }
  .drawer-mask {
    display: block;
    position: fixed;
    inset: var(--fg-topbar-h) 0 0;
    z-index: 50;
    background: rgba(22, 24, 26, 0.32);
  }
}

@media (max-width: 768px) {
  .thread {
    padding: var(--fg-s4) var(--fg-s3);
  }
  .composer {
    padding: var(--fg-s3) var(--fg-s3) var(--fg-s2);
  }
  .bubble {
    max-width: 86%;
  }
}

/* ===== 响应式新增：移动端（<768px）===== */
@media (max-width: 767.98px) {
  /* 问答：占满动态视口，去掉左右留白 */
  .chat-page {
    height: calc(100vh - var(--fg-topbar-h));
    height: calc(100dvh - var(--fg-topbar-h));
    padding-left: 0;
    padding-right: 0;
  }

  .sess-pane {
    width: min(300px, 88vw);
  }

  .pane-head {
    padding: 0 var(--fg-s3) 0 var(--fg-s4);
  }

  .pane-head .icon-btn,
  .conv-head .icon-btn {
    min-height: 44px;
    padding: 0 var(--fg-s2);
  }

  .sess-search {
    padding: 0 var(--fg-s3) var(--fg-s3);
  }

  .sess-search :deep(.el-input__wrapper) {
    height: 44px;
  }

  /* 触屏没有 hover，会话操作按钮常显 */
  .sess-more {
    opacity: 1;
    min-width: 32px;
    min-height: 44px;
    justify-content: center;
  }

  .conv-head {
    gap: var(--fg-s2);
    padding: 0 var(--fg-s3);
  }

  .export-btn span {
    display: none;
  }

  .rename-input {
    max-width: none;
    min-height: 44px;
  }

  .welcome {
    margin-top: var(--fg-s5);
    padding: 0 var(--fg-s2);
  }

  .welcome-grid {
    grid-template-columns: minmax(0, 1fr);
    margin-top: var(--fg-s4);
  }

  .suggest-card {
    min-height: 44px;
  }

  .welcome-browse {
    min-height: 44px;
    padding: 0 var(--fg-s3);
  }

  .composer {
    padding: var(--fg-s3) var(--fg-s3) calc(var(--fg-s2) + env(safe-area-inset-bottom));
  }

  .composer .chips {
    gap: var(--fg-s1);
  }

  .composer .topic-chip {
    height: 44px;
  }

  .input-row {
    gap: var(--fg-s2);
  }

  .input-row :deep(.el-textarea__inner) {
    min-height: 44px;
    padding: var(--fg-s2) var(--fg-s3);
    font-size: 16px;
    line-height: 1.5;
  }

  .send-btn {
    width: 44px;
    height: 44px;
  }

  .composer-foot {
    flex-wrap: wrap;
    gap: var(--fg-s1);
    margin-top: var(--fg-s2);
  }

  /* 浏览：检索与筛选改为单列 */
  .hero {
    margin-bottom: var(--fg-s4);
  }

  .hero-row {
    flex-direction: column;
    align-items: stretch;
    gap: var(--fg-s2);
  }

  .hero-row :deep(.el-button) {
    width: 100%;
  }

  .hero-filters {
    flex-direction: column;
    gap: var(--fg-s4);
  }

  .filter-block {
    width: 100%;
  }

  .filter-block .chips {
    gap: var(--fg-s1);
  }

  .topic-chip {
    height: 44px;
  }

  .dims {
    width: 100%;
    gap: var(--fg-s2);
  }

  .dim-select {
    flex: 1;
    width: auto;
    min-width: 0;
  }

  .mode-btn {
    min-height: 44px;
    margin-right: var(--fg-s2);
  }

  .aside-col .mode-btn {
    margin-right: 0;
  }

  .back-btn {
    min-height: 44px;
  }

  .reading {
    max-width: none;
  }

  .reading-title {
    font-size: 24px;
  }

  .meta-source {
    max-width: 100%;
    overflow-wrap: anywhere;
  }

  .doc-title {
    overflow-wrap: anywhere;
  }

  .aside-col {
    position: static;
  }
}
</style>
