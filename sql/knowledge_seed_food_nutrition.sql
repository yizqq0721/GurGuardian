-- ============================================================
-- FurGuardian 知识库语料扩充：食材营养数据（猪肝 / 猪心 / 鸡肝 / 鸡心 / 牛肝 / 牛心）
-- 由 sql/build-food-nutrition-seed.mjs 生成，语料根目录 D:/code/养宠智能助手/docs/食材营养数据知识
-- 共 34 篇 → 64 条，按 ## / ### 标题切分；小节合并到 1200 字，超长表格硬切至 ≤ 2000 字
-- 生成时间 2026-10-21
-- 幂等：先按本批 title 精确 DELETE，可反复执行
-- 收录：总索引、跨来源对比、10 份板块说明、3 份食材成分中文稿、USDA/日本八订/中国成分表/INFOODS 逐食材抽取
-- 不入库：PDF、data 原始文件、_cache、FEDIAF/NRC/WSAVA 英文全文抽取
-- 来源差异大，同一食材的不同来源各自成条，不取平均值
-- 入库后由 KnowledgeEmbeddingJob（每日 03:00）处理 embedding_id IS NULL 的条目
-- ============================================================

SET NAMES utf8mb4;

USE fur_guardian;

-- 幂等删除（仅本批生成的标题，不影响原有 80 条种子）
DELETE FROM knowledge_docs WHERE title IN ('食材营养数据知识库 — 总索引 · 第 1 段', '食材营养数据知识库 — 总索引 · USDA FoodData Central', '食材营养数据知识库 — 总索引 · FEDIAF Nutritional Guidelines 2025', '食材营养数据知识库 — 总索引 · ECVCN 与 Balance IT', '食材营养数据知识库 — 总索引 · 切块与元数据', 'USDA FoodData Central · 第 1 段', '猪肝、鸡心等食材营养成分（USDA） · 第 1 段', '猪肝、鸡心等食材营养成分（USDA） · 其他已记录项目', '猪肝、鸡心等食材营养成分（USDA） · 数据说明', '猪肝、鸡心等食材营养成分（USDA） · 版权与使用', '鸡心（生，USDA） · 每 100 g 营养数据', '鸡心（生，USDA） · 每 100 g 营养数据 (2)', '鸡心（生，USDA） · 每 100 g 营养数据 (3)', '鸡心（生，USDA） · 食物份量', '鸡肝（生，USDA） · 每 100 g 营养数据', '鸡肝（生，USDA） · 每 100 g 营养数据 (2)', '鸡肝（生，USDA） · 每 100 g 营养数据 (3)', '鸡肝（生，USDA） · 每 100 g 营养数据 (4)', '鸡肝（生，USDA） · 食物份量', '猪心（生，USDA） · 每 100 g 营养数据', '猪心（生，USDA） · 每 100 g 营养数据 (2)', '猪心（生，USDA） · 每 100 g 营养数据 (3)', '猪心（生，USDA） · 食物份量', '猪肝（生，USDA） · 每 100 g 营养数据', '猪肝（生，USDA） · 每 100 g 营养数据 (2)', '猪肝（生，USDA） · 每 100 g 营养数据 (3)', '猪肝（生，USDA） · 食物份量', '跨来源食材营养对比 · 第 1 段', '跨来源食材营养对比 · 矿物质', '跨来源食材营养对比 · 维生素 A 与牛磺酸', '跨来源食材营养对比 · 差异解读（写知识库时必须说明）', '跨来源食材营养对比 · 器官肉喂食安全要点（不涉及具体剂量）', '日本食品標準成分表 · 第 1 段', '猪肝、鸡心等食材营养成分（日本八订） · 第 1 段', '猪肝、鸡心等食材营养成分（日本八订） · 日文原名与条目对应', '猪肝、鸡心等食材营养成分（日本八订） · 原文文件', '牛心（生，日本八订） · 每 100 g 营养数据', '牛肝（生，日本八订） · 每 100 g 营养数据', '鸡心（生，日本八订） · 每 100 g 营养数据', '鸡肝（生，日本八订） · 每 100 g 营养数据', '猪心（生，日本八订） · 每 100 g 营养数据', '猪肝（生，日本八订） · 每 100 g 营养数据', '中国食物成分表 · 第 1 段', '猪肝、鸡心等食材营养成分（中国第6版） · 第 1 段', '猪肝、鸡心等食材营养成分（中国第6版） · 其他已记录项目', '猪肝、鸡心等食材营养成分（中国第6版） · 原文文件', '鸡心（生，中国第6版） · 每 100 g 营养数据', '鸡肝（生，中国第6版） · 每 100 g 营养数据', '猪心（生，中国第6版） · 每 100 g 营养数据', '猪肝（卤煮，中国第6版） · 每 100 g 营养数据', '猪肝（生，中国第6版） · 每 100 g 营养数据', 'FAO/INFOODS 目录 · 第 1 段', '中国食物成分表第6版（FAO 目录） · 来源记录', '中国食物成分表第6版第2卷（FAO 目录） · 来源记录', 'FAO/INFOODS 食物成分表目录 · 来源记录', '日本食品標準成分表（FAO 目录） · 来源记录', 'FEDIAF 营养指南 2025 · 第 1 段', 'WSAVA 全球营养指南 · 第 1 段', 'WSAVA 全球营养指南 · 与食材数据的关系', 'NRC 犬猫营养需要 2006 · 第 1 段', 'AAFCO 犬猫营养 profiles · 第 1 段', 'GB/T 31216/31217 标准 · 第 1 段', 'GB/T 31216/31217 标准 · 使用限制', 'ECVCN 与 Balance IT · 第 1 段');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('食材营养数据知识库 — 总索引 · 第 1 段', '食材营养数据知识库 — 总索引

> 本知识库由项目成员于 2026-10-20 从推荐的权威数据源抓取整理，用于补录猪肝、鸡心、猪心、鸡肝等具体食材的每 100 g 营养数值，作为后续 RAG 知识库语料。
>
> 结构参照 `docs/wsava全球指南知识`：每个板块一个文件夹，`00-板块说明.md` 记录来源与口径，`raw_extracts/` 存原文抽取，`pdf/` 存原始 PDF（如有），其余中文整理稿以 `01-` 开头。

1. 体量概览

- 板块：10 个
- 原文抽取：29 份 Markdown（约 620,000 字节）
- 原始 PDF：11 份（日本八订电子书、FEDIAF 2025、WSAVA 营养 7 份、NRC 犬猫手册 2 份）
- 原始数据：USDA API JSON、中国平台 HTML/JSON、日本八订 Excel、INFOODS 目录 JSON
- 总计：96 个文件（其中 45 份 Markdown），约 37 MB
- 抓取日期：2026-10-20

2. 覆盖矩阵（每 100 g 生重/可食部）

| 食材 | USDA | 中国第6版 | 日本八订 | 牛磺酸 | 备注 |
| --- | :---: | :---: | :---: | :---: | --- |
| 猪肝 | ✓ | ✓ | ✓ | 仅 USDA | 维生素 A、铜、铁极高 |
| 猪心 | ✓ | ✓ | ✓ | 仅 USDA | 蛋白质与牛磺酸来源 |
| 鸡肝 | ✓ | ✓ | ✓ | 仅 USDA | 维生素 A 极高，来源间差异大 |
| 鸡心 | ✓ | ✓ | ✓ | 仅 USDA | 脂肪/能量来源间差异大 |
| 牛肝 | 仅搜索 JSON | — | ✓ | — | 日本八订铜高达 5.30 mg |
| 牛心 | — | — | ✓ | — | 附加条目 |
| 猪肝（卤煮） | — | ✓ | — | — | 熟制、带卤汁，钠 674.7 mg |

> “—”表示本次未抓取或来源未提供；“仅 USDA”表示中国平台与日本八订本表未列出牛磺酸，不代表含量为零。

3. 板块与文档清单', '', '', '', '营养,食材,知识索引,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,体量概览,覆盖矩阵（每 100 g 生重/可食部）,板块与文档清单', 'informational', '食材营养数据知识库（总索引）', 'article', '', 'approved'),
('食材营养数据知识库 — 总索引 · USDA FoodData Central', '01 [usda-fooddata-central](01-usda-fooddata-central/00-板块说明.md)　USDA FoodData Central

- 官方来源：<https://fdc.nal.usda.gov/>
- 规模：4 条完整食材（猪肝、猪心、鸡肝、鸡心）+ 1 条牛肝搜索记录
- 中文整理稿：[01-食材营养成分-USDA.md](01-usda-fooddata-central/01-食材营养成分-USDA.md)
- 特点：唯一提供牛磺酸（71–76 mg/100 g）的来源；含 FDC ID、完整营养表、API JSON。

02 [japan-mext-food-composition](02-japan-mext-food-composition/00-板块说明.md)　日本食品標準成分表（八訂）増補2023年

- 官方来源：<https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html>
- 规模：6 条（猪肝、猪心、鸡肝、鸡心、牛肝、牛心）；官方 Excel + PDF 全本
- 中文整理稿：[01-食材营养成分-日本八订.md](02-japan-mext-food-composition/01-食材营养成分-日本八订.md)
- 特点：同时含 kcal/kJ、RAE、胆固醇、B12 等；条目带食品番号与日文原名。

03 [china-food-composition](03-china-food-composition/00-板块说明.md)　中国食物成分表（第6版）

- 官方平台：<https://nlc.chinanutri.cn/fq/>
- 规模：5 条（猪肝、猪心、鸡肝、鸡心、猪肝卤煮）
- 中文整理稿：[01-食材营养成分-中国食物成分表.md](03-china-food-composition/01-食材营养成分-中国食物成分表.md)
- 特点：面向中国食材的首选中文来源；保留食部、kJ 原值与 kcal 换算；未列钙与牛磺酸。

04 [fao-infoods](04-fao-infoods/00-板块说明.md)　FAO/INFOODS 目录

- 目录页：<https://www.fao.org/food-composition/tables-and-databases/en>
- 规模：220 条各国成分表索引；中国 2018/2019、日本 2023 三条详情抽取
- 中文整理稿：[infoods-index.md](04-fao-infoods/raw_extracts/infoods-index.md)
- 特点：证明中国第6版无官方免费电子文件、日本八订可免费下载的来源链。', '', '', '', '营养,食材,知识索引,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,体量概览,覆盖矩阵（每 100 g 生重/可食部）,板块与文档清单', 'informational', '食材营养数据知识库（总索引）', 'article', '', 'approved'),
('食材营养数据知识库 — 总索引 · FEDIAF Nutritional Guidelines 2025', '05 [fediaf-nutritional-guidelines](05-fediaf-nutritional-guidelines/00-板块说明.md)　FEDIAF Nutritional Guidelines 2025

- 官方来源：<https://europeanpetfood.org/self-regulation/nutritional-guidelines/>
- 规模：2025 年 9 月版 PDF + 全文抽取（约 39 万字符）
- 用途：犬猫全价/补充食品的营养需要与上下限，不是食材成分表。

06 [wsava-global-nutrition](06-wsava-global-nutrition/00-板块说明.md)　WSAVA Global Nutrition Guidelines 与工具包

- 官方来源：<https://wsava.org/global-guidelines/global-nutrition-guidelines/>
- 规模：7 份 PDF（含中文版指南、生肉基饮食、犬猫零食指南、营养评估表）
- 用途：营养评估、零食原则、生食风险与喂食边界；不含食材每 100 g 数值。

07 [nrc-nutrient-requirements](07-nrc-nutrient-requirements/00-板块说明.md)　NRC 犬猫营养需要

- 官方来源：<https://nap.nationalacademies.org/catalog/10668/nutrient-requirements-of-dogs-and-cats>
- 规模：官方免费犬猫手册 2 份 PDF + 全文抽取；完整 2006 报告为付费/在线阅读，未下载盗版。
- 用途：推荐摄入量、安全上限与缺乏/过量背景。

08 [aafco](08-aafco/00-板块说明.md)　AAFCO

- 官方来源：<https://www.aafco.org/>
- 状态：官网正文动态加载，**未取得公开的 nutrient profiles 文件**；完整 profiles 收录于付费 Official Publication。
- 用途：仅保留来源与获取限制说明，未入库正文。

09 [gb-pet-food-standards](09-gb-pet-food-standards/00-板块说明.md)　GB/T 31216-2014 与 GB/T 31217-2014

- 官方来源：<https://openstd.samr.gov.cn/bzgk/gb/>
- 规模：2 项标准的元数据与官方详情页快照；全文需在官方系统在线预览，本次未取得 PDF。
- 用途：中国犬粮/猫粮营养达标判定的标准索引。', '', '', '', '营养,食材,知识索引,体量概览,覆盖矩阵（每 100 g 生重/可食部）,板块与文档清单', 'caution', '食材营养数据知识库（总索引）', 'article', '', 'approved'),
('食材营养数据知识库 — 总索引 · ECVCN 与 Balance IT', '10 [ecvcn-balanceit](10-ecvcn-balanceit/00-板块说明.md)　ECVCN 与 Balance IT

- ECVCN：<https://www.ecvcn.org/>；Balance IT：<https://balanceit.com/>
- 状态：机构/工具索引与页面快照；不提供可批量下载的食材数据。
- 用途：转诊营养专科、自制配方营养完整性校验的背景说明。

4. 重点文件

- [01-跨来源食材营养对比.md](01-跨来源食材营养对比.md)：猪肝、猪心、鸡肝、鸡心在三大来源下的热量、蛋白质、脂肪、矿物质、维生素 A、牛磺酸对比，以及差异解读与知识库写法建议。**补录 RAG 时优先阅读此文件。**

5. 核心结论（写入知识库前必读）

1. **不同来源差异大，禁止平均**：
   - 猪肝维生素 A：4972（中国）–6502（USDA）–13000（日本）µg RAE/100 g。
   - 鸡肝维生素 A：3296（USDA）–10414（中国）–14000（日本）。
   - 鸡心维生素 A：9（USDA）–910（中国）–700（日本）。
   - 鸡心热量/脂肪：153 kcal/9.33 g（USDA）、171 kcal/11.8 g（中国）、186 kcal/15.5 g（日本）。
2. **牛磺酸只有 USDA 给出数值**（71–76 mg/100 g，生重）；中国平台与日本本表未列出，不能当作零。
3. **生熟与调味影响显著**：猪肝（卤煮）钠 674.7 mg/100 g，远高于生猪肝 68.6 mg；熟制条目不能与生重条目混用。
4. **物种差异显著**：日本八订牛肝铜 5.30 mg/100 g，远高于猪肝（0.65–0.99）与鸡肝（0.32）；不能把“肝脏”当成统一食材。
5. **肝脏风险**：维生素 A 与铜含量高，长期大量喂食存在中毒风险；内脏只宜作为少量加餐，必须煮熟、不调味、去骨，不能替代全价主粮。

6. RAG 入库建议

建议入库

- 各板块 `01-*.md` 中文整理稿；
- `raw_extracts/*.md` 原文抽取（带 YAML frontmatter，适合切块）；
- 根目录跨来源对比文件。

不建议直接入库

- `data/` 下的 HTML、API JSON、Excel：保留作溯源与复核，不作为文本语料；
- `_cache/`：抓取脚本与过程日志，**不要入库**；
- PDF：作为原文存档，若入库需先做文本抽取（本目录已完成大部分）。', '', '', '', '营养,食材,知识索引,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,体量概览,覆盖矩阵（每 100 g 生重/可食部）,板块与文档清单', 'caution', '食材营养数据知识库（总索引）', 'article', '', 'approved'),
('食材营养数据知识库 — 总索引 · 切块与元数据', '切块与元数据

- 一条食材宜单独成块，保留“数值 + 来源 + 条目编号 + 查询日期 + 生重/可食部”；
- `source_name` 写具体版本，如「中国食物成分表（第6版）在线查询平台」「日本食品標準成分表（八訂）増補2023年」「USDA FoodData Central (SR Legacy)」；
- `source_url` 填具体食材页，不填首页；
- `topics` 至少含 `营养,食材,内脏` 与食材名；
- 跨来源数值分别建条，不要合并成一条“平均值”。

7. 已知缺口

1. USDA 牛肝、牛心详情因 API 限流未取；牛肝仅保留搜索 JSON。
2. 中国平台未列钙、牛磺酸；日本八订未列牛磺酸。
3. AAFCO nutrient profiles、GB/T 标准全文、NRC 2006 完整报告受付费/版权/预览限制，未下载。
4. WSAVA 的 `Implementing` 与两份零食指南以信息图为主，文本抽取不完整。
5. 本目录不含“建议喂食克数/频率”：这类剂量需兽医或宠物营养师结合体重、体况、疾病与总热量评估，不能由食材成分表推导。
6. 未收集烹调后牛磺酸保留率、不同部位/品种的系统差异数据。

8. 后续步骤

1. 人工复核本目录数值与来源（重点核对维生素 A 单位口径与生熟标注）。
2. 按 `docs/food-nutrition-data-sources.md` 的格式写入 `knowledge_docs`，每条食材至少一条，来源间差异写入正文。
3. 重新生成向量索引并验证检索能否命中“猪肝”“鸡心”“牛磺酸”等查询。
4. 如需补齐牛肝/牛心 USDA 数据，申请正式 FDC API Key 后重跑 `_cache/crawl_usda.mjs`。
5. 如需引用 AAFCO/GB/NRC 具体阈值，先取得官方现行版并注明章节，不使用二手转述。

9. 相关文档

- [食材营养数据来源（缺口与补录格式）](../food-nutrition-data-sources.md)
- [数据来源参考（项目完整来源清单）](../数据来源参考.md)
- [抓取报告](_crawl_report.md)', '', '', '', '营养,食材,知识索引,内脏,猪肝,鸡心,牛肝,牛心,体量概览,覆盖矩阵（每 100 g 生重/可食部）,板块与文档清单', 'informational', '食材营养数据知识库（总索引）', 'article', '', 'approved'),
('USDA FoodData Central · 第 1 段', 'USDA FoodData Central（美国农业部食物成分数据库）

1. 用途

为猪肝、猪心、鸡肝、鸡心等生鲜内脏提供每 100 g 的热量、蛋白质、脂肪、矿物质、维生素与牛磺酸数值，补足现有知识库只有泛化描述、没有具体食材数值的缺口。

2. 本次抓取

- 抓取方式：FDC 官方 API（`/v1/foods/search` 与 `/v1/food/{fdcId}`），`dataType=SR Legacy`。
- 抓取日期：2026-10-20。
- 完成条目：猪肝、猪心、鸡肝、鸡心（4 条）。
- 未完成：牛肝、牛心（DEMO_KEY 触发 429 限流，仅保留搜索 JSON，未取详情）；日本八订中已有牛肝、牛心数据可替代。
- 原始文件：`data/search-*.json`、`data/food-<fdcId>-*.json`。
- 原文抽取：`raw_extracts/*.md`（每条含 FDC ID、完整营养表、食物份量）。
- 中文整理稿：[01-食材营养成分-USDA.md](01-食材营养成分-USDA.md)。

3. 口径

- 全部为 **raw（生重）**，每 100 g 可食部。
- 热量为 kcal；维生素 A 同时保留 µg RAE 与 IU；牛磺酸单位为 mg。
- “—”表示该食材记录未列出该项目，不是零。

4. 使用限制

1. SR Legacy 为美国常见品种与历史检测数据，不能直接等同于中国市售食材；跨来源比较见根目录 [01-跨来源食材营养对比.md](../01-跨来源食材营养对比.md)。
2. API 使用 DEMO_KEY 仅适合小规模验证；正式批量补录应申请 FDC API Key。
3. 引用时保留 FDC ID、英文描述、查询日期与 `https://fdc.nal.usda.gov/fdc-app.html#/food-details/{fdcId}/nutrients`。

5. 版权

USDA FoodData Central 为美国政府公开数据，通常不受版权限制；中文译名与整理内容为本项目添加。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,用途,本次抓取,口径', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/', 'approved'),
('猪肝、鸡心等食材营养成分（USDA） · 第 1 段', '猪肝、鸡心等食材营养成分（USDA FoodData Central）

> 抓取日期：2026-10-20
> 计量基准：每 100 g **生重、可食部**
> 说明：本文件为中文整理稿，完整营养项目见 `raw_extracts/` 下各食材的原文抽取；原始 API 返回见 `data/`。

1. 四种目标食材关键数值

| 食材 | FDC ID | 热量 kcal | 蛋白质 g | 脂肪 g | 钙 mg | 磷 mg | 铁 mg | 锌 mg | 铜 mg | 维生素 A µg RAE | 维生素 A IU | 牛磺酸 mg | 胆固醇 mg | 维生素 B12 µg |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 猪肝（生） | 167862 | 134 | 21.39 | 3.65 | 9 | 288 | 23.3 | 5.76 | 0.677 | 6502 | 21650 | 71.06 | 301 | 26 |
| 猪心（生） | 168267 | 118 | 17.27 | 4.36 | 5 | 169 | 4.68 | 2.80 | 0.408 | 8 | 25 | 76.21 | 131 | 3.79 |
| 鸡肝（生） | 171060 | 119 | 16.92 | 4.83 | 8 | 297 | 8.99 | 2.67 | 0.492 | 3296 | 11078 | 76.46 | 345 | 16.58 |
| 鸡心（生） | 171458 | 153 | 15.55 | 9.33 | 12 | 177 | 5.96 | 6.59 | 0.346 | 9 | 30 | 73.56 | 136 | 7.29 |', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,四种目标食材关键数值,其他已记录项目,数据说明', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', '', 'approved'),
('猪肝、鸡心等食材营养成分（USDA） · 其他已记录项目', '2. 其他已记录项目

| 食材 | 碳水 g | 钠 mg | 钾 mg | 镁 mg | 维生素 E mg | 硫胺素 mg | 核黄素 mg | 烟酸 mg | 维生素 B6 mg | 维生素 C mg |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 猪肝（生） | 2.47 | 87 | 273 | 18 | — | 0.283 | 3.005 | 15.301 | 6.65 | 25.3 |
| 猪心（生） | 1.33 | 56 | 294 | 19 | 0.63 | 0.613 | 1.185 | 6.765 | 2.515 | 5.3 |
| 鸡肝（生） | 0.73 | 71 | 230 | 19 | 0.70 | 0.305 | 1.778 | 9.728 | 6.233 | 17.9 |
| 鸡心（生） | 0.71 | 74 | 176 | 15 | — | 0.152 | 0.728 | 4.883 | 2.559 | 3.2 |

> “—”表示该食材的 USDA 记录中未列出该项目，不等于含量为零。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,四种目标食材关键数值,其他已记录项目,数据说明', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', '', 'approved'),
('猪肝、鸡心等食材营养成分（USDA） · 数据说明', '3. 数据说明

1. 四条记录均来自 USDA FoodData Central 的 **SR Legacy** 数据集，英文描述分别为：
   - Pork, fresh, variety meats and by-products, liver, raw
   - Pork, fresh, variety meats and by-products, heart, raw
   - Chicken, liver, all classes, raw
   - Chicken, heart, all classes, raw
2. 查询通过 FDC 官方 API 完成：`https://api.nal.usda.gov/fdc/v1/foods/search` 与 `https://api.nal.usda.gov/fdc/v1/food/{fdcId}`。
3. 原始 API JSON 保存在 `data/`，逐项营养表保存在 `raw_extracts/`，每条都带 FDC ID 与查询日期，便于复核。
4. USDA 的“raw”对应生重；未给出“可食部”百分比时，按 100 g 可食部计。
5. 牛肝、牛心为附加条目，因 USDA API 的 DEMO_KEY 触发限流，本次未完成详情抓取；如后续需要，可用正式 API Key 补齐。日本八订中已包含牛肝、牛心数据，见 `02-japan-mext-food-composition/`。
6. USDA 数据为美国常见品种与检测批次，不能直接等同于中国市售猪肝、鸡心的精确值；用于 RAG 时应同时标注来源与数值差异。

4. 原文文件

| 食材 | 原文抽取 | 原始 JSON |
| --- | --- | --- |
| 猪肝（生） | [pork-liver-raw.md](raw_extracts/pork-liver-raw.md) | `data/food-167862-pork-liver-raw.json` |
| 猪心（生） | [pork-heart-raw.md](raw_extracts/pork-heart-raw.md) | `data/food-168267-pork-heart-raw.json` |
| 鸡肝（生） | [chicken-liver-raw.md](raw_extracts/chicken-liver-raw.md) | `data/food-171060-chicken-liver-raw.json` |
| 鸡心（生） | [chicken-heart-raw.md](raw_extracts/chicken-heart-raw.md) | `data/food-171458-chicken-heart-raw.json` |', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,四种目标食材关键数值,其他已记录项目,数据说明', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', '', 'approved'),
('猪肝、鸡心等食材营养成分（USDA） · 版权与使用', '5. 版权与使用

USDA FoodData Central 数据为美国政府公开数据，可用于研究与开发；引用时保留 FDC ID、数据来源与查询日期。本文件中的中文译名为整理时添加，不是 USDA 官方中文名。', '', '', '', '营养,食材,内脏,猪肝,鸡心,四种目标食材关键数值,其他已记录项目,数据说明', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', '', 'approved'),
('鸡心（生，USDA） · 每 100 g 营养数据', 'Nutrients (per 100 g)', '', '', '', '营养,食材,内脏,鸡心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171458/nutrients', 'approved'),
('鸡心（生，USDA） · 每 100 g 营养数据 (2)', '| Nutrient ID | Nutrient | Amount | Unit |
| --- | --- | --- | --- |
| 1003 | Protein | 15.55 | g |
| 1004 | Total lipid (fat) | 9.33 | g |
| 1005 | Carbohydrate, by difference | 0.71 | g |
| 1007 | Ash | 0.85 | g |
| 1008 | Energy | 153 | kcal |
| 1051 | Water | 73.56 | g |
| 1062 | Energy | 640 | kJ |
| 1079 | Fiber, total dietary | 0 | g |
| 1087 | Calcium, Ca | 12 | mg |
| 1089 | Iron, Fe | 5.96 | mg |
| 1090 | Magnesium, Mg | 15 | mg |
| 1091 | Phosphorus, P | 177 | mg |
| 1092 | Potassium, K | 176 | mg |
| 1093 | Sodium, Na | 74 | mg |
| 1095 | Zinc, Zn | 6.59 | mg |
| 1098 | Copper, Cu | 0.346 | mg |
| 1101 | Manganese, Mn | 0.089 | mg |
| 1103 | Selenium, Se | 4.3 | µg |
| 1104 | Vitamin A, IU | 30 | IU |
| 1105 | Retinol | 9 | µg |
| 1106 | Vitamin A, RAE | 9 | µg |
| 1162 | Vitamin C, total ascorbic acid | 3.2 | mg |
| 1165 | Thiamin | 0.152 | mg |
| 1166 | Riboflavin | 0.728 | mg |
| 1167 | Niacin | 4.883 | mg |
| 1170 | Pantothenic acid | 2.559 | mg |
| 1175 | Vitamin B-6 | 0.36 | mg |
| 1177 | Folate, total | 72 | µg |
| 1178 | Vitamin B-12 | 7.29 | µg |
| 1186 | Folic acid | 0 | µg |
| 1187 | Folate, food | 72 | µg |
| 1190 | Folate, DFE | 72 | µg |
| 1210 | Tryptophan | 0.199 | g |
| 1211 | Threonine | 0.704 | g |
| 1212 | Isoleucine | 0.833 | g |
| 1213 | Leucine | 1.355 | g |
| 1214 | Lysine | 1.303 | g |
| 1215 | Methionine | 0.376 | g |
| 1216 | Cystine | 0.211 | g |
| 1217 | Phenylalanine | 0.696 | g |
| 1218 | Tyrosine | 0.557 | g |
| 1219 | Valine | 0.88 | g |
| 1220 | Arginine | 0.997 | g |
| 1221 | Histidine | 0.408 | g |
| 1222 | Alanine | 0.98 | g |
| 1223 | Aspartic acid | 1.512 | g |
| 1224 | Glutamic acid | 2.308 | g |
| 1225 | Glycine | 0.863 | g |
| 1226 | Proline | 0.793 | g |
| 1227 | Serine | 0.627 | g |
| 1253 | Cholesterol | 136 | mg |
| 1258 | Fatty acids, total saturated | 2.66 | g |
| 1262 | SFA 10:0 | 0 | g |
| 1263 | SFA 12:0 | 0 | g |
| 1264 | SFA 14:0 | 0.06 | g |
| 1265 | SFA 16:0 | 1.45 | g |', '', '', '', '营养,食材,内脏,鸡心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171458/nutrients', 'approved'),
('鸡心（生，USDA） · 每 100 g 营养数据 (3)', '| 1266 | SFA 18:0 | 0.78 | g |
| 1268 | MUFA 18:1 | 1.98 | g |
| 1269 | PUFA 18:2 | 1.91 | g |
| 1270 | PUFA 18:3 | 0.07 | g |
| 1271 | PUFA 20:4 | 0.72 | g |
| 1272 | PUFA 22:6 n-3 (DHA) | 0 | g |
| 1275 | MUFA 16:1 | 0.39 | g |
| 1277 | MUFA 20:1 | 0 | g |
| 1278 | PUFA 20:5 n-3 (EPA) | 0 | g |
| 1279 | MUFA 22:1 | 0 | g |
| 1280 | PUFA 22:5 n-3 (DPA) | 0 | g |
| 1292 | Fatty acids, total monounsaturated | 2.37 | g |
| 1293 | Fatty acids, total polyunsaturated | 2.71 | g |', '', '', '', '营养,食材,内脏,鸡心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171458/nutrients', 'approved'),
('鸡心（生，USDA） · 食物份量', 'Food Portions

- undetermined (1.8 g)
- undetermined (6.1 g)', '', '', '', '营养,食材,内脏,鸡心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171458/nutrients', 'approved'),
('鸡肝（生，USDA） · 每 100 g 营养数据', 'Nutrients (per 100 g)', '', '', '', '营养,食材,内脏,鸡肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171060/nutrients', 'approved'),
('鸡肝（生，USDA） · 每 100 g 营养数据 (2)', '| Nutrient ID | Nutrient | Amount | Unit |
| --- | --- | --- | --- |
| 1003 | Protein | 16.92 | g |
| 1004 | Total lipid (fat) | 4.83 | g |
| 1005 | Carbohydrate, by difference | 0.73 | g |
| 1007 | Ash | 1.06 | g |
| 1008 | Energy | 119 | kcal |
| 1018 | Alcohol, ethyl | 0 | g |
| 1051 | Water | 76.46 | g |
| 1057 | Caffeine | 0 | mg |
| 1058 | Theobromine | 0 | mg |
| 1062 | Energy | 496 | kJ |
| 1079 | Fiber, total dietary | 0 | g |
| 1087 | Calcium, Ca | 8 | mg |
| 1089 | Iron, Fe | 8.99 | mg |
| 1090 | Magnesium, Mg | 19 | mg |
| 1091 | Phosphorus, P | 297 | mg |
| 1092 | Potassium, K | 230 | mg |
| 1093 | Sodium, Na | 71 | mg |
| 1095 | Zinc, Zn | 2.67 | mg |
| 1098 | Copper, Cu | 0.492 | mg |
| 1101 | Manganese, Mn | 0.255 | mg |
| 1103 | Selenium, Se | 54.6 | µg |
| 1104 | Vitamin A, IU | 11078 | IU |
| 1105 | Retinol | 3290 | µg |
| 1106 | Vitamin A, RAE | 3296 | µg |
| 1107 | Carotene, beta | 56 | µg |
| 1108 | Carotene, alpha | 11 | µg |
| 1109 | Vitamin E (alpha-tocopherol) | 0.7 | mg |
| 1110 | Vitamin D (D2 + D3), International Units | 0 | IU |
| 1112 | Vitamin D3 (cholecalciferol) | 0 | µg |
| 1114 | Vitamin D (D2 + D3) | 0 | µg |
| 1120 | Cryptoxanthin, beta | 11 | µg |
| 1122 | Lycopene | 40 | µg |
| 1123 | Lutein + zeaxanthin | 0 | µg |
| 1125 | Tocopherol, beta | 0 | mg |
| 1126 | Tocopherol, gamma | 0.31 | mg |
| 1127 | Tocopherol, delta | 0 | mg |
| 1128 | Tocotrienol, alpha | 0 | mg |
| 1129 | Tocotrienol, beta | 0 | mg |
| 1130 | Tocotrienol, gamma | 0 | mg |
| 1131 | Tocotrienol, delta | 0 | mg |
| 1162 | Vitamin C, total ascorbic acid | 17.9 | mg |
| 1165 | Thiamin | 0.305 | mg |
| 1166 | Riboflavin | 1.778 | mg |
| 1167 | Niacin | 9.728 | mg |
| 1170 | Pantothenic acid | 6.233 | mg |
| 1175 | Vitamin B-6 | 0.853 | mg |
| 1177 | Folate, total | 588 | µg |
| 1178 | Vitamin B-12 | 16.58 | µg |
| 1180 | Choline, total | 194.4 | mg |
| 1184 | Vitamin K (Dihydrophylloquinone) | 0 | µg |
| 1185 | Vitamin K (phylloquinone) | 0 | µg |', '', '', '', '营养,食材,内脏,鸡肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171060/nutrients', 'approved'),
('鸡肝（生，USDA） · 每 100 g 营养数据 (3)', '| 1186 | Folic acid | 0 | µg |
| 1187 | Folate, food | 588 | µg |
| 1190 | Folate, DFE | 588 | µg |
| 1198 | Betaine | 16.9 | mg |
| 1210 | Tryptophan | 0.176 | g |
| 1211 | Threonine | 0.725 | g |
| 1212 | Isoleucine | 0.813 | g |
| 1213 | Leucine | 1.512 | g |
| 1214 | Lysine | 1.332 | g |
| 1215 | Methionine | 0.432 | g |
| 1216 | Cystine | 0.272 | g |
| 1217 | Phenylalanine | 0.824 | g |
| 1218 | Tyrosine | 0.653 | g |
| 1219 | Valine | 0.998 | g |
| 1220 | Arginine | 1.093 | g |
| 1221 | Histidine | 0.507 | g |
| 1222 | Alanine | 0.993 | g |
| 1223 | Aspartic acid | 1.593 | g |
| 1224 | Glutamic acid | 2.093 | g |
| 1225 | Glycine | 0.849 | g |
| 1226 | Proline | 0.726 | g |
| 1227 | Serine | 0.735 | g |
| 1228 | Hydroxyproline | 0.043 | g |
| 1242 | Vitamin E, added | 0 | mg |
| 1246 | Vitamin B-12, added | 0 | µg |
| 1253 | Cholesterol | 345 | mg |
| 1257 | Fatty acids, total trans | 0.065 | g |
| 1258 | Fatty acids, total saturated | 1.563 | g |
| 1259 | SFA 4:0 | 0 | g |
| 1260 | SFA 6:0 | 0 | g |
| 1261 | SFA 8:0 | 0 | g |
| 1262 | SFA 10:0 | 0 | g |
| 1263 | SFA 12:0 | 0 | g |
| 1264 | SFA 14:0 | 0.012 | g |
| 1265 | SFA 16:0 | 0.883 | g |
| 1266 | SFA 18:0 | 0.659 | g |
| 1267 | SFA 20:0 | 0 | g |
| 1268 | MUFA 18:1 | 1.127 | g |
| 1269 | PUFA 18:2 | 0.475 | g |
| 1270 | PUFA 18:3 | 0.012 | g |
| 1271 | PUFA 20:4 | 0.326 | g |
| 1272 | PUFA 22:6 n-3 (DHA) | 0 | g |
| 1273 | SFA 22:0 | 0.007 | g |
| 1274 | MUFA 14:1 | 0 | g |
| 1275 | MUFA 16:1 | 0.106 | g |
| 1276 | PUFA 18:4 | 0 | g |
| 1277 | MUFA 20:1 | 0.016 | g |
| 1278 | PUFA 20:5 n-3 (EPA) | 0 | g |
| 1279 | MUFA 22:1 | 0 | g |
| 1280 | PUFA 22:5 n-3 (DPA) | 0 | g |
| 1292 | Fatty acids, total monounsaturated | 1.249 | g |
| 1293 | Fatty acids, total polyunsaturated | 1.306 | g |
| 1299 | SFA 15:0 | 0 | g |
| 1300 | SFA 17:0 | 0.002 | g |
| 1313 | PUFA 20:2 n-6 c,c | 0.005 | g |
| 1316 | PUFA 18:2 n-6 c,c | 0.475 | g |
| 1321 | PUFA 18:3 n-6 c,c,c | 0.006 | g |
| 1323 | MUFA 17:1 | 0 | g |', '', '', '', '营养,食材,内脏,鸡肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171060/nutrients', 'approved'),
('鸡肝（生，USDA） · 每 100 g 营养数据 (4)', '| 1325 | PUFA 20:3 | 0 | g |
| 1333 | MUFA 15:1 | 0 | g |
| 1404 | PUFA 18:3 n-3 c,c,c (ALA) | 0.006 | g |
| 2000 | Total Sugars | 0 | g |', '', '', '', '营养,食材,内脏,鸡肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171060/nutrients', 'approved'),
('鸡肝（生，USDA） · 食物份量', 'Food Portions

- undetermined (44 g)
- undetermined (113 g)', '', '', '', '营养,食材,内脏,鸡肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/171060/nutrients', 'approved'),
('猪心（生，USDA） · 每 100 g 营养数据', 'Nutrients (per 100 g)', '', '', '', '营养,食材,内脏,猪心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/168267/nutrients', 'approved'),
('猪心（生，USDA） · 每 100 g 营养数据 (2)', '| Nutrient ID | Nutrient | Amount | Unit |
| --- | --- | --- | --- |
| 1003 | Protein | 17.27 | g |
| 1004 | Total lipid (fat) | 4.36 | g |
| 1005 | Carbohydrate, by difference | 1.33 | g |
| 1007 | Ash | 0.84 | g |
| 1008 | Energy | 118 | kcal |
| 1018 | Alcohol, ethyl | 0 | g |
| 1051 | Water | 76.21 | g |
| 1057 | Caffeine | 0 | mg |
| 1058 | Theobromine | 0 | mg |
| 1062 | Energy | 494 | kJ |
| 1079 | Fiber, total dietary | 0 | g |
| 1087 | Calcium, Ca | 5 | mg |
| 1089 | Iron, Fe | 4.68 | mg |
| 1090 | Magnesium, Mg | 19 | mg |
| 1091 | Phosphorus, P | 169 | mg |
| 1092 | Potassium, K | 294 | mg |
| 1093 | Sodium, Na | 56 | mg |
| 1095 | Zinc, Zn | 2.8 | mg |
| 1098 | Copper, Cu | 0.408 | mg |
| 1101 | Manganese, Mn | 0.063 | mg |
| 1103 | Selenium, Se | 10.4 | µg |
| 1104 | Vitamin A, IU | 25 | IU |
| 1105 | Retinol | 8 | µg |
| 1106 | Vitamin A, RAE | 8 | µg |
| 1107 | Carotene, beta | 0 | µg |
| 1108 | Carotene, alpha | 0 | µg |
| 1109 | Vitamin E (alpha-tocopherol) | 0.63 | mg |
| 1120 | Cryptoxanthin, beta | 0 | µg |
| 1122 | Lycopene | 0 | µg |
| 1123 | Lutein + zeaxanthin | 0 | µg |
| 1162 | Vitamin C, total ascorbic acid | 5.3 | mg |
| 1165 | Thiamin | 0.613 | mg |
| 1166 | Riboflavin | 1.185 | mg |
| 1167 | Niacin | 6.765 | mg |
| 1170 | Pantothenic acid | 2.515 | mg |
| 1175 | Vitamin B-6 | 0.39 | mg |
| 1177 | Folate, total | 4 | µg |
| 1178 | Vitamin B-12 | 3.79 | µg |
| 1186 | Folic acid | 0 | µg |
| 1187 | Folate, food | 4 | µg |
| 1190 | Folate, DFE | 4 | µg |
| 1210 | Tryptophan | 0.199 | g |
| 1211 | Threonine | 0.757 | g |
| 1212 | Isoleucine | 0.831 | g |
| 1213 | Leucine | 1.558 | g |
| 1214 | Lysine | 1.428 | g |
| 1215 | Methionine | 0.442 | g |
| 1216 | Cystine | 0.309 | g |
| 1217 | Phenylalanine | 0.762 | g |
| 1218 | Tyrosine | 0.591 | g |
| 1219 | Valine | 0.914 | g |
| 1220 | Arginine | 1.16 | g |
| 1221 | Histidine | 0.439 | g |
| 1222 | Alanine | 1.108 | g |
| 1223 | Aspartic acid | 1.563 | g |
| 1224 | Glutamic acid | 2.77 | g |', '', '', '', '营养,食材,内脏,猪心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/168267/nutrients', 'approved'),
('猪心（生，USDA） · 每 100 g 营养数据 (3)', '| 1225 | Glycine | 0.939 | g |
| 1226 | Proline | 0.795 | g |
| 1227 | Serine | 0.812 | g |
| 1242 | Vitamin E, added | 0 | mg |
| 1246 | Vitamin B-12, added | 0 | µg |
| 1253 | Cholesterol | 131 | mg |
| 1258 | Fatty acids, total saturated | 1.16 | g |
| 1259 | SFA 4:0 | 0 | g |
| 1260 | SFA 6:0 | 0 | g |
| 1261 | SFA 8:0 | 0 | g |
| 1262 | SFA 10:0 | 0 | g |
| 1263 | SFA 12:0 | 0.01 | g |
| 1264 | SFA 14:0 | 0.08 | g |
| 1265 | SFA 16:0 | 0.59 | g |
| 1266 | SFA 18:0 | 0.45 | g |
| 1268 | MUFA 18:1 | 0.9 | g |
| 1269 | PUFA 18:2 | 0.77 | g |
| 1270 | PUFA 18:3 | 0.08 | g |
| 1271 | PUFA 20:4 | 0.27 | g |
| 1272 | PUFA 22:6 n-3 (DHA) | 0 | g |
| 1275 | MUFA 16:1 | 0.1 | g |
| 1276 | PUFA 18:4 | 0 | g |
| 1277 | MUFA 20:1 | 0.018 | g |
| 1278 | PUFA 20:5 n-3 (EPA) | 0 | g |
| 1279 | MUFA 22:1 | 0 | g |
| 1280 | PUFA 22:5 n-3 (DPA) | 0 | g |
| 1283 | Phytosterols | 0 | mg |
| 1292 | Fatty acids, total monounsaturated | 1.02 | g |
| 1293 | Fatty acids, total polyunsaturated | 1.12 | g |
| 2000 | Total Sugars | 0 | g |', '', '', '', '营养,食材,内脏,猪心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/168267/nutrients', 'approved'),
('猪心（生，USDA） · 食物份量', 'Food Portions

- undetermined (226 g)
- undetermined (28.35 g)', '', '', '', '营养,食材,内脏,猪心,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/168267/nutrients', 'approved'),
('猪肝（生，USDA） · 每 100 g 营养数据', 'Nutrients (per 100 g)', '', '', '', '营养,食材,内脏,猪肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/167862/nutrients', 'approved'),
('猪肝（生，USDA） · 每 100 g 营养数据 (2)', '| Nutrient ID | Nutrient | Amount | Unit |
| --- | --- | --- | --- |
| 1003 | Protein | 21.39 | g |
| 1004 | Total lipid (fat) | 3.65 | g |
| 1005 | Carbohydrate, by difference | 2.47 | g |
| 1007 | Ash | 1.44 | g |
| 1008 | Energy | 134 | kcal |
| 1018 | Alcohol, ethyl | 0 | g |
| 1051 | Water | 71.06 | g |
| 1062 | Energy | 561 | kJ |
| 1079 | Fiber, total dietary | 0 | g |
| 1087 | Calcium, Ca | 9 | mg |
| 1089 | Iron, Fe | 23.3 | mg |
| 1090 | Magnesium, Mg | 18 | mg |
| 1091 | Phosphorus, P | 288 | mg |
| 1092 | Potassium, K | 273 | mg |
| 1093 | Sodium, Na | 87 | mg |
| 1095 | Zinc, Zn | 5.76 | mg |
| 1098 | Copper, Cu | 0.677 | mg |
| 1101 | Manganese, Mn | 0.344 | mg |
| 1103 | Selenium, Se | 52.7 | µg |
| 1104 | Vitamin A, IU | 21650 | IU |
| 1105 | Retinol | 6502 | µg |
| 1106 | Vitamin A, RAE | 6502 | µg |
| 1162 | Vitamin C, total ascorbic acid | 25.3 | mg |
| 1165 | Thiamin | 0.283 | mg |
| 1166 | Riboflavin | 3.005 | mg |
| 1167 | Niacin | 15.301 | mg |
| 1170 | Pantothenic acid | 6.65 | mg |
| 1175 | Vitamin B-6 | 0.69 | mg |
| 1177 | Folate, total | 212 | µg |
| 1178 | Vitamin B-12 | 26 | µg |
| 1186 | Folic acid | 0 | µg |
| 1187 | Folate, food | 212 | µg |
| 1190 | Folate, DFE | 212 | µg |
| 1210 | Tryptophan | 0.301 | g |
| 1211 | Threonine | 0.91 | g |
| 1212 | Isoleucine | 1.085 | g |
| 1213 | Leucine | 1.906 | g |
| 1214 | Lysine | 1.649 | g |
| 1215 | Methionine | 0.53 | g |
| 1216 | Cystine | 0.404 | g |
| 1217 | Phenylalanine | 1.047 | g |
| 1218 | Tyrosine | 0.729 | g |
| 1219 | Valine | 1.321 | g |
| 1220 | Arginine | 1.317 | g |
| 1221 | Histidine | 0.582 | g |
| 1222 | Alanine | 1.276 | g |
| 1223 | Aspartic acid | 1.937 | g |
| 1224 | Glutamic acid | 2.782 | g |
| 1225 | Glycine | 1.239 | g |
| 1226 | Proline | 1.146 | g |
| 1227 | Serine | 1.157 | g |
| 1253 | Cholesterol | 301 | mg |
| 1258 | Fatty acids, total saturated | 1.17 | g |
| 1259 | SFA 4:0 | 0 | g |
| 1260 | SFA 6:0 | 0 | g |
| 1261 | SFA 8:0 | 0 | g |', '', '', '', '营养,食材,内脏,猪肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/167862/nutrients', 'approved'),
('猪肝（生，USDA） · 每 100 g 营养数据 (3)', '| 1262 | SFA 10:0 | 0 | g |
| 1263 | SFA 12:0 | 0 | g |
| 1264 | SFA 14:0 | 0.02 | g |
| 1265 | SFA 16:0 | 0.44 | g |
| 1266 | SFA 18:0 | 0.7 | g |
| 1268 | MUFA 18:1 | 0.46 | g |
| 1269 | PUFA 18:2 | 0.35 | g |
| 1270 | PUFA 18:3 | 0.03 | g |
| 1271 | PUFA 20:4 | 0.44 | g |
| 1272 | PUFA 22:6 n-3 (DHA) | 0.02 | g |
| 1275 | MUFA 16:1 | 0.03 | g |
| 1276 | PUFA 18:4 | 0 | g |
| 1277 | MUFA 20:1 | 0 | g |
| 1278 | PUFA 20:5 n-3 (EPA) | 0 | g |
| 1279 | MUFA 22:1 | 0 | g |
| 1280 | PUFA 22:5 n-3 (DPA) | 0.03 | g |
| 1283 | Phytosterols | 0 | mg |
| 1292 | Fatty acids, total monounsaturated | 0.52 | g |
| 1293 | Fatty acids, total polyunsaturated | 0.87 | g |', '', '', '', '营养,食材,内脏,猪肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/167862/nutrients', 'approved'),
('猪肝（生，USDA） · 食物份量', 'Food Portions

- undetermined (28.35 g)
- undetermined (113 g)', '', '', '', '营养,食材,内脏,猪肝,Food Portions', 'informational', 'USDA FoodData Central (SR Legacy)', 'official', 'https://fdc.nal.usda.gov/fdc-app.html#/food-details/167862/nutrients', 'approved'),
('跨来源食材营养对比 · 第 1 段', '猪肝、鸡心等食材营养成分：三来源对比

> 整理日期：2026-10-20
> 对比来源：
> - USDA FoodData Central（SR Legacy，生重，每 100 g 可食部）
> - 中国食物成分表（第6版）在线查询平台（生重，除卤煮条目；每 100 g，标注食部）
> - 日本食品標準成分表（八訂）増補2023年（生重，每 100 g 可食部）
>
> 用途：为 `knowledge_docs` 补录具体食材数值提供可追溯底稿。**不同来源差异较大，禁止把三者平均后当作“标准值”。**

1. 热量与三大营养素

| 食材 | 来源 | 热量 kcal | 蛋白质 g | 脂肪 g | 碳水 g |
| --- | --- | ---: | ---: | ---: | ---: |
| 猪肝（生） | USDA | 134 | 21.39 | 3.65 | 2.47 |
| 猪肝（生） | 中国第6版 | 129.8 | 19.3 | 3.5 | 5.0 |
| 猪肝（生） | 日本八订 | 114 | 20.4 | 3.4 | 2.5 |
| 猪心（生） | USDA | 118 | 17.27 | 4.36 | 1.33 |
| 猪心（生） | 中国第6版 | 118.8 | 16.6 | 5.3 | 1.1 |
| 猪心（生） | 日本八订 | 118 | 16.2 | 7.0 | 0.1 |
| 鸡肝（生） | USDA | 119 | 16.92 | 4.83 | 0.73 |
| 鸡肝（生） | 中国第6版 | 121.2 | 16.6 | 4.8 | 2.8 |
| 鸡肝（生） | 日本八订 | 100 | 18.9 | 3.1 | 0.6 |
| 鸡心（生） | USDA | 153 | 15.55 | 9.33 | 0.71 |
| 鸡心（生） | 中国第6版 | 171.4 | 15.9 | 11.8 | 0.6 |
| 鸡心（生） | 日本八订 | 186 | 14.5 | 15.5 | Tr |', '', '', '', '营养,食材,跨来源对比,内脏,猪肝,猪心,鸡肝,鸡心,热量与三大营养素,矿物质,维生素 A 与牛磺酸', 'informational', '食材营养数据知识库（跨来源对比）', 'article', '', 'approved'),
('跨来源食材营养对比 · 矿物质', '2. 矿物质

| 食材 | 来源 | 钙 mg | 磷 mg | 铁 mg | 锌 mg | 铜 mg |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 猪肝（生） | USDA | 9 | 288 | 23.3 | 5.76 | 0.677 |
| 猪肝（生） | 中国第6版 | — | 310 | 22.6 | 5.78 | 0.65 |
| 猪肝（生） | 日本八订 | 5 | 340 | 13.0 | 6.9 | 0.99 |
| 猪心（生） | USDA | 5 | 169 | 4.68 | 2.80 | 0.408 |
| 猪心（生） | 中国第6版 | — | 189 | 4.3 | 1.90 | 0.37 |
| 猪心（生） | 日本八订 | 5 | 170 | 3.5 | 1.7 | 0.35 |
| 鸡肝（生） | USDA | 8 | 297 | 8.99 | 2.67 | 0.492 |
| 鸡肝（生） | 中国第6版 | — | 263 | 12.0 | 2.40 | 0.32 |
| 鸡肝（生） | 日本八订 | 5 | 300 | 9.0 | 3.3 | 0.32 |
| 鸡心（生） | USDA | 12 | 177 | 5.96 | 6.59 | 0.346 |
| 鸡心（生） | 中国第6版 | — | 176 | 4.7 | 1.94 | 0.27 |
| 鸡心（生） | 日本八订 | 5 | 170 | 5.1 | 2.3 | 0.32 |', '', '', '', '营养,食材,跨来源对比,内脏,猪肝,猪心,鸡肝,鸡心,热量与三大营养素,矿物质,维生素 A 与牛磺酸', 'informational', '食材营养数据知识库（跨来源对比）', 'article', '', 'approved'),
('跨来源食材营养对比 · 维生素 A 与牛磺酸', '3. 维生素 A 与牛磺酸

| 食材 | 来源 | 维生素 A µg RAE（或 µg） | 牛磺酸 mg |
| --- | --- | ---: | ---: |
| 猪肝（生） | USDA | 6502（RAE） | 71.06 |
| 猪肝（生） | 中国第6版 | 4972（µg，未细分） | — |
| 猪肝（生） | 日本八订 | 13000（RAE） | — |
| 猪心（生） | USDA | 8（RAE） | 76.21 |
| 猪心（生） | 中国第6版 | 13（µg，未细分） | — |
| 猪心（生） | 日本八订 | 9（RAE） | — |
| 鸡肝（生） | USDA | 3296（RAE） | 76.46 |
| 鸡肝（生） | 中国第6版 | 10414（µg，未细分） | — |
| 鸡肝（生） | 日本八订 | 14000（RAE） | — |
| 鸡心（生） | USDA | 9（RAE） | 73.56 |
| 鸡心（生） | 中国第6版 | 910（µg，未细分） | — |
| 鸡心（生） | 日本八订 | 700（RAE） | — |

> “—”表示该来源未提供，不代表零。USDA 四条均提供牛磺酸；中国平台与日本八订本表未列出牛磺酸。', '', '', '', '营养,食材,跨来源对比,内脏,猪肝,猪心,鸡肝,鸡心,热量与三大营养素,矿物质,维生素 A 与牛磺酸', 'informational', '食材营养数据知识库（跨来源对比）', 'article', '', 'approved'),
('跨来源食材营养对比 · 差异解读（写知识库时必须说明）', '4. 差异解读（写知识库时必须说明）

1. **猪肝维生素 A 差异最大**：USDA 6502、中国 4972、日本 13000 µg RAE/100 g，相差约 2.6 倍。三者都说明猪肝维生素 A 极高，但不应给出单一的“精确值”；引用时应写“约 5000–13000 µg/100 g（因来源与检测方法而异）”。
2. **鸡肝维生素 A 同样差异大**：USDA 3296、中国 10414、日本 14000 µg/100 g。USDA 数值明显偏低，可能与美国样本、检测方法或数据年代有关；面向中国用户时应优先中国食物成分表，并注明来源。
3. **鸡心维生素 A 分歧明显**：USDA 9、中国 910、日本 700 µg/100 g。USDA 的鸡心维生素 A 可能低估；不宜用单一来源断言“鸡心几乎不含维生素 A”。
4. **鸡心脂肪与能量差异大**：USDA 9.33 g/153 kcal、中国 11.8 g/171 kcal、日本 15.5 g/186 kcal，与品种、日龄、去脂程度有关。计算热量时应使用与食材来源匹配的数据。
5. **猪肝铁与铜**：铁 13.0–23.3 mg、铜 0.65–0.99 mg，均属高值；不同来源差异仍在同一量级。
6. **牛肝铜极高**：日本八订牛肝铜 5.30 mg/100 g，远高于猪肝、鸡肝；不能把“肝脏”作为一个统一食材套用。
7. **牛磺酸**：USDA 对四种食材给出 71–76 mg/100 g 的分析值；中国与日本本表未列，不能据此认为不含牛磺酸。烹调（水煮弃汤）可能造成流失，现有数据均为生重。

5. 补录知识库的建议写法

- 每条食材单独一条，正文同时给出**数值区间 + 来源名称 + 具体条目/编号 + 查询日期 + 生重/可食部**。
- 不要写“猪肝含维生素 A 5000 µg”这种脱离来源的绝对表述；建议写“按中国食物成分表第6版，每 100 g 生猪肝（食部 99%）含维生素 A 约 4972 µg；USDA 与日本八订分别为 6502、13000 µg，差异见来源说明”。
- `source_url` 填具体食材页：
  - USDA：`https://fdc.nal.usda.gov/fdc-app.html#/food-details/{fdcId}/nutrients`
  - 中国平台：`https://nlc.chinanutri.cn/fq/foodinfo/{id}.html`
  - 日本八订：官方下载页 `https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html`，正文注明食品番号
- `topics` 至少包含 `营养,食材,内脏` 与食材名，便于检索命中。', '', '', '', '营养,食材,跨来源对比,内脏,猪肝,鸡肝,鸡心,牛肝,热量与三大营养素,矿物质,维生素 A 与牛磺酸', 'informational', '食材营养数据知识库（跨来源对比）', 'article', '', 'approved'),
('跨来源食材营养对比 · 器官肉喂食安全要点（不涉及具体剂量）', '6. 器官肉喂食安全要点（不涉及具体剂量）

以下为现有资料中的共识性边界，补录数值时一并保留：

1. **肝脏**：维生素 A 与铜含量高，长期大量喂食存在中毒风险；NRC 与 Merck Veterinary Manual 均有上限与中毒描述。具体安全上限与个体化喂食量应由兽医或宠物营养师评估。
2. **心脏**：是蛋白质与牛磺酸的食物来源之一，但仍需计入每日总热量，不能替代全价主粮。
3. **内脏总体**：建议作为少量加餐，占每日热量的小比例；必须煮熟、不调味、去骨。生食存在细菌与寄生虫风险（参见 `06-wsava-global-nutrition/` 中 WSAVA 生肉基饮食资料）。
4. **猫的牛磺酸需求**：参见现有知识条目“牛磺酸对猫的必要性”“猫必须从食物获取牛磺酸”；本目录的牛磺酸数值仅作食材成分参考，不构成缺乏症治疗方案。
5. **疾病个体**：肝病、肾病、胰腺炎、肥胖等个体的饮食管理需兽医介入，不能直接套用健康犬猫的食材建议。

7. 来源索引

| 来源 | 目录 | 原始文件 |
| --- | --- | --- |
| USDA FoodData Central | `01-usda-fooddata-central/` | `raw_extracts/*.md`、`data/food-*.json` |
| 日本八订 | `02-japan-mext-food-composition/` | `raw_extracts/*.md`、`data/food-*.json`、官方 Excel/PDF |
| 中国食物成分表第6版 | `03-china-food-composition/` | `raw_extracts/*.md`、`data/foodinfo-*.json`、原始 HTML |
| FAO/INFOODS 目录 | `04-fao-infoods/` | `raw_extracts/*.md`、`data/infoods-*.json` |', '', '', '', '营养,食材,跨来源对比,热量与三大营养素,矿物质,维生素 A 与牛磺酸', 'caution', '食材营养数据知识库（跨来源对比）', 'article', '', 'approved'),
('日本食品標準成分表 · 第 1 段', '日本食品標準成分表（八訂）増補2023年

1. 用途

补充亚洲常见食材的官方成分数据，尤其是猪肝、猪心、鸡肝、鸡心及牛肝、牛心；为跨来源核对提供日本文部科学省口径。

2. 本次抓取

- 官方下载页：<https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html>
- 在线检索：<https://fooddb.mext.go.jp/>
- 已下载：
  - `data/日本食品標準成分表2020年版（八訂）増補2023年_第2章.xlsx`（主数据，工作表 `11肉類`）
  - `pdf/日本食品標準成分表2020年版（八訂）増補2023年.pdf`（电子书）
- 已提取 6 条：猪肝、猪心、鸡肝、鸡心、牛肝、牛心（食品番号 11166、11165、11232、11231、11092、11091）。
- 中文整理稿：[01-食材营养成分-日本八订.md](01-食材营养成分-日本八订.md)。

3. 口径

- 每 100 g **可食部、生重**；Excel 中“生”对应未烹调。
- 能量同时保留 kcal 与 kJ；维生素 A 使用“视黄醇活性当量（µg RAE）”。
- 八订本表未列出牛磺酸；“Tr”为微量，不是零。

4. 目录结构

- `data/`：官方 Excel 与每条结构化 JSON。
- `pdf/`：官方电子书 PDF。
- `raw_extracts/`：每条食材的完整营养表（Markdown，含食品番号与日文原名）。
- `_cache/`：下载与解析过程记录（不用于检索）。

5. 版权

日本政府标准成分表可在注明出处的前提下使用；引用时保留“日本食品標準成分表（八訂）増補2023年”、食品番号与官方下载页。本目录仅用于项目内部 RAG 语料整理。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,用途,本次抓取,口径', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html', 'approved'),
('猪肝、鸡心等食材营养成分（日本八订） · 第 1 段', '猪肝、鸡心等食材营养成分（日本食品标准成分表 八订 增补2023）

> 抓取日期：2026-10-20
> 计量基准：每 100 g **可食部、生重**
> 原始文件：`data/日本食品標準成分表2020年版（八訂）増補2023年_第2章.xlsx`，工作表 `11肉類`
> 官方下载页：<https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html>

1. 六种食材关键数值

| 食材 | 食品番号 | 热量 kcal | 蛋白质 g | 脂肪 g | 碳水 g | 钙 mg | 磷 mg | 铁 mg | 锌 mg | 铜 mg | 维生素 A µg RAE | 胆固醇 mg | 维生素 B12 µg | 食盐相当量 g |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 猪肝（生） | 11166 | 114 | 20.4 | 3.4 | 2.5 | 5 | 340 | 13.0 | 6.9 | 0.99 | 13000 | 250 | 25.0 | 0.1 |
| 猪心（生） | 11165 | 118 | 16.2 | 7.0 | 0.1 | 5 | 170 | 3.5 | 1.7 | 0.35 | 9 | 110 | 2.5 | 0.2 |
| 鸡肝（生） | 11232 | 100 | 18.9 | 3.1 | 0.6 | 5 | 300 | 9.0 | 3.3 | 0.32 | 14000 | 370 | 44.0 | 0.2 |
| 鸡心（生） | 11231 | 186 | 14.5 | 15.5 | Tr | 5 | 170 | 5.1 | 2.3 | 0.32 | 700 | 160 | 1.7 | 0.2 |
| 牛肝（生） | 11092 | 119 | 19.6 | 3.7 | 3.7 | 5 | 330 | 4.0 | 3.8 | 5.30 | 1100 | 240 | 53.0 | 0.1 |
| 牛心（生） | 11091 | 128 | 16.5 | 7.6 | 0.1 | 5 | 170 | 3.3 | 2.1 | 0.42 | 9 | 110 | 12.0 | 0.2 |

> “Tr”表示微量（Trace），不是零；“可食部”按表中 100 g 可食部计。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,六种食材关键数值,日文原名与条目对应,数据说明', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', '', 'approved'),
('猪肝、鸡心等食材营养成分（日本八订） · 日文原名与条目对应', '2. 日文原名与条目对应

| 食品番号 | 日文原名 | 中文整理名 |
| ---: | --- | --- |
| 11166 | ＜畜肉類＞　ぶた　［副生物］　肝臓　生 | 猪肝（生） |
| 11165 | ＜畜肉類＞　ぶた　［副生物］　心臓　生 | 猪心（生） |
| 11232 | ＜鳥肉類＞　にわとり　［副品目］　肝臓　生 | 鸡肝（生） |
| 11231 | ＜鳥肉類＞　にわとり　［副品目］　心臓　生 | 鸡心（生） |
| 11092 | ＜畜肉類＞　うし　［副生物］　肝臓　生 | 牛肝（生） |
| 11091 | ＜畜肉類＞　うし　［副生物］　心臓　生 | 牛心（生） |

3. 数据说明

1. 本表数值来自 Excel 工作表 `11肉類`，字段包括能量、水分、蛋白质、脂肪、碳水化合物、灰分、钠、钾、钙、镁、磷、铁、锌、铜、锰、维生素 A（视黄醇活性当量）、维生素 D、E、K、B1、B2、烟酸、B6、B12、叶酸、泛酸、生物素、维生素 C、食盐相当量等。
2. 每条食材的完整项目已输出到 `raw_extracts/`，原始结构化记录在 `data/food-<食品番号>-<slug>.json`。
3. 八订本表未列出牛磺酸；牛磺酸数据需参考 USDA FoodData Central（见 `01-usda-fooddata-central/`）或氨基酸成分表编，不能把“未列出”当作零。
4. 日本八订的“生”指未烹调生重；不同部位、品种、饲喂方式会造成差异，尤其是鸡心的脂肪与能量。
5. 日本政府标准成分表允许在注明出处的前提下使用；本目录为内部 RAG 语料整理，引用时保留食品番号与官方下载页。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,六种食材关键数值,日文原名与条目对应,数据说明', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', '', 'approved'),
('猪肝、鸡心等食材营养成分（日本八订） · 原文文件', '4. 原文文件

| 食材 | 原文抽取 | 原始 JSON |
| --- | --- | --- |
| 猪肝（生） | [pork-liver.md](raw_extracts/pork-liver.md) | `data/food-11166-pork-liver.json` |
| 猪心（生） | [pork-heart.md](raw_extracts/pork-heart.md) | `data/food-11165-pork-heart.json` |
| 鸡肝（生） | [chicken-liver.md](raw_extracts/chicken-liver.md) | `data/food-11232-chicken-liver.json` |
| 鸡心（生） | [chicken-heart.md](raw_extracts/chicken-heart.md) | `data/food-11231-chicken-heart.json` |
| 牛肝（生） | [beef-liver.md](raw_extracts/beef-liver.md) | `data/food-11092-beef-liver.json` |
| 牛心（生） | [beef-heart.md](raw_extracts/beef-heart.md) | `data/food-11091-beef-heart.json` |

5. 归档文件

- 官方 Excel 全表：`data/日本食品標準成分表2020年版（八訂）増補2023年_第2章.xlsx`（约 1.9 MB，工作表含 `表全体` 与 18 个食品群）
- 官方 PDF 电子书：`pdf/日本食品標準成分表2020年版（八訂）増補2023年.pdf`
- 下载与解析脚本：`../_cache/`（过程产物，不用于检索）', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,牛肝,牛心,六种食材关键数值,日文原名与条目对应,数据说明', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', '', 'approved'),
('牛心（生，日本八订） · 每 100 g 营养数据', '牛心（生）（每 100 g 可食部）

> 日本原文名: ＜畜肉類＞　うし　［副生物］　心臓　生　|　食品番号: 11091　|　索引番号: 1732　|　废弃率: 0%

| 项目 | 数值 | 单位 |
| --- | --- | --- |
| 能量 | 535 | kJ |
| 能量 | 128 | kcal |
| 水分 | 74.8 | g |
| 蛋白质（氨基酸组成） | 13.7 | g |
| 蛋白质 | 16.5 | g |
| 脂肪（脂肪酸甘油三酯当量） | 6.2 | g |
| 胆固醇 | 110 | mg |
| 脂肪 | 7.6 | g |
| 可利用碳水化合物（单糖当量） | (0.1) | g |
| 可利用碳水化合物（质量计） | (0.1) | g |
| 可利用碳水化合物（差减法） | 4.3 | g |
| 膳食纤维总量 | (0) | g |
| 碳水化合物 | 0.1 | g |
| 灰分 | 1.0 | g |
| 钠 | 70 | mg |
| 钾 | 260 | mg |
| 钙 | 5 | mg |
| 镁 | 23 | mg |
| 磷 | 170 | mg |
| 铁 | 3.3 | mg |
| 锌 | 2.1 | mg |
| 铜 | 0.42 | mg |
| 锰 | - | mg |
| 碘 | - | µg |
| 硒 | - | µg |
| 铬 | - | µg |
| 钼 | - | µg |
| 视黄醇 | 9 | µg |
| β-胡萝卜素当量 | Tr | µg |
| 维生素A（视黄醇活性当量） | 9 | µg |
| 维生素D | 0 | µg |
| 维生素E（α-生育酚） | 0.6 | mg |
| 维生素K | 5 | µg |
| 维生素B1 | 0.42 | mg |
| 维生素B2 | 0.90 | mg |
| 烟酸 | 5.8 | mg |
| 烟酸当量 | 9.4 | mg |
| 维生素B6 | 0.29 | mg |
| 维生素B12 | 12.0 | µg |
| 叶酸 | 16 | µg |
| 泛酸 | 2.16 | mg |
| 生物素 | - | µg |
| 维生素C | 4 | mg |
| 食盐相当量 | 0.2 | g |', '', '', '', '营养,食材,内脏,牛心', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html', 'approved'),
('牛肝（生，日本八订） · 每 100 g 营养数据', '牛肝（生）（每 100 g 可食部）

> 日本原文名: ＜畜肉類＞　うし　［副生物］　肝臓　生　|　食品番号: 11092　|　索引番号: 1733　|　废弃率: 0%

| 项目 | 数值 | 单位 |
| --- | --- | --- |
| 能量 | 502 | kJ |
| 能量 | 119 | kcal |
| 水分 | 71.5 | g |
| 蛋白质（氨基酸组成） | 17.4 | g |
| 蛋白质 | 19.6 | g |
| 脂肪（脂肪酸甘油三酯当量） | 2.1 | g |
| 胆固醇 | 240 | mg |
| 脂肪 | 3.7 | g |
| 可利用碳水化合物（单糖当量） | (3.7) | g |
| 可利用碳水化合物（质量计） | (3.3) | g |
| 可利用碳水化合物（差减法） | 7.4 | g |
| 膳食纤维总量 | (0) | g |
| 碳水化合物 | 3.7 | g |
| 灰分 | 1.5 | g |
| 钠 | 55 | mg |
| 钾 | 300 | mg |
| 钙 | 5 | mg |
| 镁 | 17 | mg |
| 磷 | 330 | mg |
| 铁 | 4.0 | mg |
| 锌 | 3.8 | mg |
| 铜 | 5.30 | mg |
| 锰 | - | mg |
| 碘 | 4 | µg |
| 硒 | 50 | µg |
| 铬 | Tr | µg |
| 钼 | 94 | µg |
| 视黄醇 | 1100 | µg |
| β-胡萝卜素当量 | 40 | µg |
| 维生素A（视黄醇活性当量） | 1100 | µg |
| 维生素D | 0 | µg |
| 维生素E（α-生育酚） | 0.3 | mg |
| 维生素K | 1 | µg |
| 维生素B1 | 0.22 | mg |
| 维生素B2 | 3.00 | mg |
| 烟酸 | 14.0 | mg |
| 烟酸当量 | 18.0 | mg |
| 维生素B6 | 0.89 | mg |
| 维生素B12 | 53.0 | µg |
| 叶酸 | 1000 | µg |
| 泛酸 | 6.40 | mg |
| 生物素 | 76.0 | µg |
| 维生素C | 30 | mg |
| 食盐相当量 | 0.1 | g |', '', '', '', '营养,食材,内脏,牛肝', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html', 'approved'),
('鸡心（生，日本八订） · 每 100 g 营养数据', '鸡心（生）（每 100 g 可食部）

> 日本原文名: ＜鳥肉類＞　にわとり　［副品目］　心臓　生　|　食品番号: 11231　|　索引番号: 1907　|　废弃率: 0%

| 项目 | 数值 | 单位 |
| --- | --- | --- |
| 能量 | 773 | kJ |
| 能量 | 186 | kcal |
| 水分 | 69.0 | g |
| 蛋白质（氨基酸组成） | 12.2 | g |
| 蛋白质 | 14.5 | g |
| 脂肪（脂肪酸甘油三酯当量） | 13.2 | g |
| 胆固醇 | 160 | mg |
| 脂肪 | 15.5 | g |
| 可利用碳水化合物（单糖当量） | (Tr) | g |
| 可利用碳水化合物（质量计） | (Tr) | g |
| 可利用碳水化合物（差减法） | 4.6 | g |
| 膳食纤维总量 | (0) | g |
| 碳水化合物 | Tr | g |
| 灰分 | 1.0 | g |
| 钠 | 85 | mg |
| 钾 | 240 | mg |
| 钙 | 5 | mg |
| 镁 | 15 | mg |
| 磷 | 170 | mg |
| 铁 | 5.1 | mg |
| 锌 | 2.3 | mg |
| 铜 | 0.32 | mg |
| 锰 | - | mg |
| 碘 | - | µg |
| 硒 | - | µg |
| 铬 | - | µg |
| 钼 | - | µg |
| 视黄醇 | 700 | µg |
| β-胡萝卜素当量 | Tr | µg |
| 维生素A（视黄醇活性当量） | 700 | µg |
| 维生素D | 0.4 | µg |
| 维生素E（α-生育酚） | 1.0 | mg |
| 维生素K | 51 | µg |
| 维生素B1 | 0.22 | mg |
| 维生素B2 | 1.10 | mg |
| 烟酸 | 6.0 | mg |
| 烟酸当量 | 9.4 | mg |
| 维生素B6 | 0.21 | mg |
| 维生素B12 | 1.7 | µg |
| 叶酸 | 43 | µg |
| 泛酸 | 4.41 | mg |
| 生物素 | - | µg |
| 维生素C | 5 | mg |
| 食盐相当量 | 0.2 | g |', '', '', '', '营养,食材,内脏,鸡心', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html', 'approved'),
('鸡肝（生，日本八订） · 每 100 g 营养数据', '鸡肝（生）（每 100 g 可食部）

> 日本原文名: ＜鳥肉類＞　にわとり　［副品目］　肝臓　生　|　食品番号: 11232　|　索引番号: 1908　|　废弃率: 0%

| 项目 | 数值 | 单位 |
| --- | --- | --- |
| 能量 | 422 | kJ |
| 能量 | 100 | kcal |
| 水分 | 75.7 | g |
| 蛋白质（氨基酸组成） | 16.1 | g |
| 蛋白质 | 18.9 | g |
| 脂肪（脂肪酸甘油三酯当量） | 1.9 | g |
| 胆固醇 | 370 | mg |
| 脂肪 | 3.1 | g |
| 可利用碳水化合物（单糖当量） | (0.6) | g |
| 可利用碳水化合物（质量计） | (0.5) | g |
| 可利用碳水化合物（差减法） | 4.7 | g |
| 膳食纤维总量 | (0) | g |
| 碳水化合物 | 0.6 | g |
| 灰分 | 1.7 | g |
| 钠 | 85 | mg |
| 钾 | 330 | mg |
| 钙 | 5 | mg |
| 镁 | 19 | mg |
| 磷 | 300 | mg |
| 铁 | 9.0 | mg |
| 锌 | 3.3 | mg |
| 铜 | 0.32 | mg |
| 锰 | 0.33 | mg |
| 碘 | 1 | µg |
| 硒 | 60 | µg |
| 铬 | 1 | µg |
| 钼 | 82 | µg |
| 视黄醇 | 14000 | µg |
| β-胡萝卜素当量 | 30 | µg |
| 维生素A（视黄醇活性当量） | 14000 | µg |
| 维生素D | 0.2 | µg |
| 维生素E（α-生育酚） | 0.4 | mg |
| 维生素K | 14 | µg |
| 维生素B1 | 0.38 | mg |
| 维生素B2 | 1.80 | mg |
| 烟酸 | 4.5 | mg |
| 烟酸当量 | 9.0 | mg |
| 维生素B6 | 0.65 | mg |
| 维生素B12 | 44.0 | µg |
| 叶酸 | 1300 | µg |
| 泛酸 | 10.00 | mg |
| 生物素 | 230.0 | µg |
| 维生素C | 20 | mg |
| 食盐相当量 | 0.2 | g |', '', '', '', '营养,食材,内脏,鸡肝', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('猪心（生，日本八订） · 每 100 g 营养数据', '猪心（生）（每 100 g 可食部）

> 日本原文名: ＜畜肉類＞　ぶた　［副生物］　心臓　生　|　食品番号: 11165　|　索引番号: 1817　|　废弃率: 0%

| 项目 | 数值 | 单位 |
| --- | --- | --- |
| 能量 | 497 | kJ |
| 能量 | 118 | kcal |
| 水分 | 75.7 | g |
| 蛋白质（氨基酸组成） | 13.4 | g |
| 蛋白质 | 16.2 | g |
| 脂肪（脂肪酸甘油三酯当量） | 5.0 | g |
| 胆固醇 | 110 | mg |
| 脂肪 | 7.0 | g |
| 可利用碳水化合物（单糖当量） | (0.1) | g |
| 可利用碳水化合物（质量计） | (0.1) | g |
| 可利用碳水化合物（差减法） | 4.8 | g |
| 膳食纤维总量 | (0) | g |
| 碳水化合物 | 0.1 | g |
| 灰分 | 1.0 | g |
| 钠 | 80 | mg |
| 钾 | 270 | mg |
| 钙 | 5 | mg |
| 镁 | 17 | mg |
| 磷 | 170 | mg |
| 铁 | 3.5 | mg |
| 锌 | 1.7 | mg |
| 铜 | 0.35 | mg |
| 锰 | - | mg |
| 碘 | - | µg |
| 硒 | - | µg |
| 铬 | - | µg |
| 钼 | - | µg |
| 视黄醇 | 9 | µg |
| β-胡萝卜素当量 | Tr | µg |
| 维生素A（视黄醇活性当量） | 9 | µg |
| 维生素D | 0.7 | µg |
| 维生素E（α-生育酚） | 0.4 | mg |
| 维生素K | 1 | µg |
| 维生素B1 | 0.38 | mg |
| 维生素B2 | 0.95 | mg |
| 烟酸 | 6.0 | mg |
| 烟酸当量 | 9.5 | mg |
| 维生素B6 | 0.32 | mg |
| 维生素B12 | 2.5 | µg |
| 叶酸 | 5 | µg |
| 泛酸 | 2.70 | mg |
| 生物素 | - | µg |
| 维生素C | 4 | mg |
| 食盐相当量 | 0.2 | g |', '', '', '', '营养,食材,内脏,猪心', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html', 'approved'),
('猪肝（生，日本八订） · 每 100 g 营养数据', '猪肝（生）（每 100 g 可食部）

> 日本原文名: ＜畜肉類＞　ぶた　［副生物］　肝臓　生　|　食品番号: 11166　|　索引番号: 1818　|　废弃率: 0%

| 项目 | 数值 | 单位 |
| --- | --- | --- |
| 能量 | 484 | kJ |
| 能量 | 114 | kcal |
| 水分 | 72.0 | g |
| 蛋白质（氨基酸组成） | 17.3 | g |
| 蛋白质 | 20.4 | g |
| 脂肪（脂肪酸甘油三酯当量） | 1.9 | g |
| 胆固醇 | 250 | mg |
| 脂肪 | 3.4 | g |
| 可利用碳水化合物（单糖当量） | (2.5) | g |
| 可利用碳水化合物（质量计） | (2.3) | g |
| 可利用碳水化合物（差减法） | 7.1 | g |
| 膳食纤维总量 | (0) | g |
| 碳水化合物 | 2.5 | g |
| 灰分 | 1.7 | g |
| 钠 | 55 | mg |
| 钾 | 290 | mg |
| 钙 | 5 | mg |
| 镁 | 20 | mg |
| 磷 | 340 | mg |
| 铁 | 13.0 | mg |
| 锌 | 6.9 | mg |
| 铜 | 0.99 | mg |
| 锰 | - | mg |
| 碘 | 1 | µg |
| 硒 | 67 | µg |
| 铬 | 0 | µg |
| 钼 | 120 | µg |
| 视黄醇 | 13000 | µg |
| β-胡萝卜素当量 | Tr | µg |
| 维生素A（视黄醇活性当量） | 13000 | µg |
| 维生素D | 1.3 | µg |
| 维生素E（α-生育酚） | 0.4 | mg |
| 维生素K | Tr | µg |
| 维生素B1 | 0.34 | mg |
| 维生素B2 | 3.60 | mg |
| 烟酸 | 14.0 | mg |
| 烟酸当量 | 19.0 | mg |
| 维生素B6 | 0.57 | mg |
| 维生素B12 | 25.0 | µg |
| 叶酸 | 810 | µg |
| 泛酸 | 7.19 | mg |
| 生物素 | 80.0 | µg |
| 维生素C | 20 | mg |
| 食盐相当量 | 0.1 | g |', '', '', '', '营养,食材,内脏,猪肝', 'informational', '日本食品標準成分表（八訂）増補2023年', 'official', 'https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html', 'approved'),
('中国食物成分表 · 第 1 段', '中国食物成分表（第6版）在线查询平台

1. 用途

提供面向中国食材的官方成分数据，是猪肝、猪心、鸡肝、鸡心补录时的首选中文来源；同时保留“猪肝（卤煮）”熟制条目，用于说明生熟差异与调味影响。

2. 本次抓取

- 平台：中国疾病预防控制中心营养与健康所 / 中国营养学会「食物营养成分查询平台」。
- 入口：<https://nlc.chinanutri.cn/fq/>；通过站内 `FoodInfoQueryAction!queryFoodInfoList.do` 接口按分类取列表，再抓取 `foodinfo/{id}.html` 详情页。
- 已提取 5 条：
  - 猪肝（ID 797，食部 99%）
  - 猪心（ID 802，食部 97%）
  - 鸡肝（ID 884，食部 100%）
  - 鸡心（ID 885，食部 100%）
  - 猪肝（卤煮）（ID 809，食部 100%，熟制）
- 文件：
  - `data/foodinfo-<id>-<slug>.html`：原始详情页
  - `data/foodinfo-<id>-<slug>.json`：结构化行项目
  - `raw_extracts/*.md`：完整营养表
  - [01-食材营养成分-中国食物成分表.md](01-食材营养成分-中国食物成分表.md)：中文整理稿

3. 口径

- 每 100 g；标注“食部”的按可食部计。
- 平台能量单位为 kJ；整理稿按 1 kcal = 4.184 kJ 换算并同时保留原始 kJ。
- 平台未列出钙、牛磺酸；不代表为零。
- 除“猪肝（卤煮）”外，其余条目按生重理解。

4. 使用限制与版权

1. 平台声明：数据来源于中国食物成分表，未经中国疾控中心营养与健康所允许，任何单位和个人不得用于商业目的。本目录仅用于项目内部非商业研发与检索验证。
2. 数据为第6版在线查询结果；不同版本、产地、饲喂方式会产生差异。
3. 引用时 `source_name` 建议写「中国食物成分表（第6版）在线查询平台」，`source_url` 填具体食材详情页，并注明查询日期与食部。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,用途,本次抓取,口径', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', 'https://nlc.chinanutri.cn/fq/', 'approved'),
('猪肝、鸡心等食材营养成分（中国第6版） · 第 1 段', '猪肝、鸡心等食材营养成分（中国食物成分表 第6版）

> 抓取日期：2026-10-20
> 平台地址：<https://nlc.chinanutri.cn/fq/>
> 计量基准：每 100 g 食物，标注“食部”的按可食部计；除“猪肝（卤煮）”外均为生重
> 版权说明：平台声明数据来源于中国食物成分表，未经中国疾控中心营养与健康所允许，任何单位和个人不得用于商业目的。本目录仅用于项目内部非商业研发。

1. 五种食材关键数值

| 食材 | 平台 ID | 食部 | 能量 kJ | 能量 kcal* | 蛋白质 g | 脂肪 g | 碳水 g | 胆固醇 mg | 维生素 A µg | 磷 mg | 铁 mg | 锌 mg | 铜 mg | 钾 mg | 钠 mg | 镁 mg | 硒 µg |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 猪肝 | 797 | 99% | 543 | 129.8 | 19.3 | 3.5 | 5.0 | 288 | 4972 | 310 | 22.6 | 5.78 | 0.65 | 235 | 68.6 | 24 | 19.20 |
| 猪心 | 802 | 97% | 497 | 118.8 | 16.6 | 5.3 | 1.1 | 151 | 13 | 189 | 4.3 | 1.90 | 0.37 | 260 | 71.2 | 17 | 14.90 |
| 鸡肝 | 884 | 100% | 507 | 121.2 | 16.6 | 4.8 | 2.8 | 356 | 10414 | 263 | 12.0 | 2.40 | 0.32 | 222 | 92.0 | 16 | 38.60 |
| 鸡心 | 885 | 100% | 717 | 171.4 | 15.9 | 11.8 | 0.6 | 194 | 910 | 176 | 4.7 | 1.94 | 0.27 | 220 | 108.4 | 11 | 4.10 |
| 猪肝（卤煮） | 809 | 100% | 851 | 203.4 | 26.4 | 8.3 | 5.6 | 469 | 4200 | 153 | 2.0 | 0.35 | 0.39 | 188 | 674.7 | 12 | 28.70 |

\\* kcal 由平台给出的 kJ 按 1 kcal = 4.184 kJ 换算，保留 1 位小数；平台原始值以 kJ 为准。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,五种食材关键数值,其他已记录项目,数据说明', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', '', 'approved'),
('猪肝、鸡心等食材营养成分（中国第6版） · 其他已记录项目', '2. 其他已记录项目

| 食材 | 水分 g | 灰分 g | 硫胺素 mg | 核黄素 mg | 烟酸 mg | 维生素 C mg |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 猪肝 | 70.7 | 1.5 | 0.21 | 2.08 | 15.00 | 20.0 |
| 猪心 | 76.0 | 1.0 | 0.19 | 0.48 | 6.80 | 4.0 |
| 鸡肝 | 74.4 | 1.4 | 0.33 | 1.10 | 11.90 | — |
| 鸡心 | 70.8 | 0.9 | 0.46 | 0.26 | 11.50 | — |
| 猪肝（卤煮） | 56.4 | 3.3 | 0.36 | 0.42 | — | — |

3. 数据说明

1. 上述数据来自平台详情页，例如猪肝：<https://nlc.chinanutri.cn/fq/foodinfo/797.html>；每条原始页面与结构化 JSON 分别保存在 `data/`。
2. 平台未列出**钙**与**牛磺酸**，因此表中不填；这不代表含量为零。需要钙、牛磺酸时，应参考日本八订或 USDA 数据，并注明来源。
3. 平台条目未注明“生/熟”的，按生重理解；“猪肝（卤煮）”是熟制且带调味卤汁的条目，钠高达 674.7 mg/100 g，不能与生猪肝直接混用。
4. 猪肝、鸡肝的维生素 A 以 µg 计（平台字段为“维生素A(Vitamin)”，未细分 RAE/视黄醇），与 USDA 的 µg RAE 口径可能不同，跨来源比较时只能作为量级参考。
5. 能量换算仅用于统一展示；写入知识库时应同时保留平台原始 kJ 值与换算后的 kcal，并注明换算方法。
6. 平台数据为第6版《中国食物成分表》的在线查询结果；不同版本、不同产地与烹调方式会产生差异。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,五种食材关键数值,其他已记录项目,数据说明', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', '', 'approved'),
('猪肝、鸡心等食材营养成分（中国第6版） · 原文文件', '4. 原文文件

| 食材 | 原文抽取 | 原始页面 | 结构化 JSON |
| --- | --- | --- | --- |
| 猪肝 | [pig-liver.md](raw_extracts/pig-liver.md) | `data/foodinfo-797-pig-liver.html` | `data/foodinfo-797-pig-liver.json` |
| 猪心 | [pig-heart.md](raw_extracts/pig-heart.md) | `data/foodinfo-802-pig-heart.html` | `data/foodinfo-802-pig-heart.json` |
| 鸡肝 | [chicken-liver.md](raw_extracts/chicken-liver.md) | `data/foodinfo-884-chicken-liver.html` | `data/foodinfo-884-chicken-liver.json` |
| 鸡心 | [chicken-heart.md](raw_extracts/chicken-heart.md) | `data/foodinfo-885-chicken-heart.html` | `data/foodinfo-885-chicken-heart.json` |
| 猪肝（卤煮） | [pig-liver-braised.md](raw_extracts/pig-liver-braised.md) | `data/foodinfo-809-pig-liver-braised.html` | `data/foodinfo-809-pig-liver-braised.json` |

5. 引用格式建议

写入 `knowledge_docs` 时，`source_name` 建议写「中国食物成分表（第6版）在线查询平台」，`source_url` 填对应食材详情页，正文标注查询日期与“食部/生重”口径。', '', '', '', '营养,食材,内脏,猪肝,猪心,鸡肝,鸡心,五种食材关键数值,其他已记录项目,数据说明', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', '', 'approved'),
('鸡心（生，中国第6版） · 每 100 g 营养数据', '鸡心（每 100 克）

> 数据来源于中国食物成分表；版权归中国疾病预防控制中心营养与健康所，仅限非商业内部研发使用。

| 类别 | 项目 | 含量 | 同类排名 | 同类均值 |
| --- | --- | --- | --- | --- |
| 能量与相关成分 | 食部(Edible) | 100% | 1 | 79% |
| 能量与相关成分 | 水分(Water) | 70.8g | 7 | 63.5g |
| 能量与相关成分 | 能量(Energy) | 717kJ | 8 | 811kJ |
| 能量与相关成分 | 蛋白质(Protein) | 15.9g | 13 | 18.3g |
| 能量与相关成分 | 脂肪(Fat) | 11.8g | 6 | 10.8g |
| 能量与相关成分 | 胆固醇(Cholesterol) | 194mg | 3 | 145mg |
| 能量与相关成分 | 灰分(Ash) | 0.9g | 9 | 1.5g |
| 能量与相关成分 | 碳水化合物(CHO) | 0.6g | 10 | 6.0g |
| 能量与相关成分 | 总膳食纤维(Dietary fiber) | — | — | — |
| 维生素 | 维生素A(Vitamin) | 910.0μg | 2 | 805.2μg |
| 维生素 | 硫胺素(Thiamin) | 0.46mg | 1 | 0.09mg |
| 维生素 | 核黄素(Riboflavin) | 0.26mg | 2 | 0.19mg |
| 维生素 | 烟酸(Niacin) | 11.50mg | 4 | 7.11mg |
| 维生素 | 维生素C(Vitamin C) | — | — | — |
| 矿物质 | 磷(P) | 176mg | 4 | 150mg |
| 矿物质 | 钾(K) | 220mg | 8 | 208mg |
| 矿物质 | 钠(Na) | 108.4mg | 6 | 280.8mg |
| 矿物质 | 镁(Mg) | 11mg | 12 | 21mg |
| 矿物质 | 铁(Fe) | 4.7mg | 4 | 4.7mg |
| 矿物质 | 锌(Zn) | 1.94mg | 4 | 1.42mg |
| 矿物质 | 硒(Se) | 4.10μg | 13 | 10.79μg |
| 矿物质 | 铜(Cu) | 0.27mg | 3 | 0.25mg |
| 矿物质 | 锰(Mn) | 0.04mg | 7 | 0.09mg |
| 矿物质 | 碘(I) | — | — | — |
| 脂肪酸 | 单不饱和脂肪酸(MUFA) | 42.7% | 6 | 36.9% |
| 脂肪酸 | 多不饱和脂肪酸(PUFA) | 28.8% | 1 | 16.9% |
| 脂肪酸 | 合计(Total) | 100.1% | 4 | 85.8% |', '', '', '', '营养,食材,内脏,鸡心', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', 'https://nlc.chinanutri.cn/fq/foodinfo/885.html', 'approved'),
('鸡肝（生，中国第6版） · 每 100 g 营养数据', '鸡肝（每 100 克）

> 数据来源于中国食物成分表；版权归中国疾病预防控制中心营养与健康所，仅限非商业内部研发使用。

| 类别 | 项目 | 含量 | 同类排名 | 同类均值 |
| --- | --- | --- | --- | --- |
| 能量与相关成分 | 食部(Edible) | 100% | 1 | 79% |
| 能量与相关成分 | 水分(Water) | 74.4g | 2 | 63.5g |
| 能量与相关成分 | 能量(Energy) | 507kJ | 12 | 811kJ |
| 能量与相关成分 | 蛋白质(Protein) | 16.6g | 11 | 18.3g |
| 能量与相关成分 | 脂肪(Fat) | 4.8g | 11 | 10.8g |
| 能量与相关成分 | 胆固醇(Cholesterol) | 356mg | 1 | 145mg |
| 能量与相关成分 | 灰分(Ash) | 1.4g | 4 | 1.5g |
| 能量与相关成分 | 碳水化合物(CHO) | 2.8g | 5 | 6.0g |
| 能量与相关成分 | 总膳食纤维(Dietary fiber) | — | — | — |
| 维生素 | 维生素A(Vitamin) | 10414.0μg | 1 | 805.2μg |
| 维生素 | 硫胺素(Thiamin) | 0.33mg | 2 | 0.09mg |
| 维生素 | 核黄素(Riboflavin) | 1.10mg | 1 | 0.19mg |
| 维生素 | 烟酸(Niacin) | 11.90mg | 3 | 7.11mg |
| 维生素 | 维生素C(Vitamin C) | — | — | — |
| 矿物质 | 磷(P) | 263mg | 1 | 150mg |
| 矿物质 | 钾(K) | 222mg | 7 | 208mg |
| 矿物质 | 钠(Na) | 92.0mg | 7 | 280.8mg |
| 矿物质 | 镁(Mg) | 16mg | 9 | 21mg |
| 矿物质 | 铁(Fe) | 12.0mg | 2 | 4.7mg |
| 矿物质 | 锌(Zn) | 2.40mg | 3 | 1.42mg |
| 矿物质 | 硒(Se) | 38.60μg | 1 | 10.79μg |
| 矿物质 | 铜(Cu) | 0.32mg | 2 | 0.25mg |
| 矿物质 | 锰(Mn) | 0.24mg | 2 | 0.09mg |
| 矿物质 | 碘(I) | — | — | — |
| 脂肪酸 | 单不饱和脂肪酸(MUFA) | 32.2% | 11 | 36.9% |
| 脂肪酸 | 多不饱和脂肪酸(PUFA) | 17.0% | 10 | 16.9% |
| 脂肪酸 | 合计(Total) | 96.2% | 11 | 85.8% |', '', '', '', '营养,食材,内脏,鸡肝', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', 'https://nlc.chinanutri.cn/fq/foodinfo/884.html', 'approved'),
('猪心（生，中国第6版） · 每 100 g 营养数据', '猪心（每 100 克）

> 数据来源于中国食物成分表；版权归中国疾病预防控制中心营养与健康所，仅限非商业内部研发使用。

| 类别 | 项目 | 含量 | 同类排名 | 同类均值 |
| --- | --- | --- | --- | --- |
| 能量与相关成分 | 食部(Edible) | 97% | 30 | 93% |
| 能量与相关成分 | 水分(Water) | 76.0g | 7 | 55.1g |
| 能量与相关成分 | 能量(Energy) | 497kJ | 40 | 1164kJ |
| 能量与相关成分 | 蛋白质(Protein) | 16.6g | 20 | 15.7g |
| 能量与相关成分 | 脂肪(Fat) | 5.3g | 38 | 21.8g |
| 能量与相关成分 | 胆固醇(Cholesterol) | 151mg | 11 | 172mg |
| 能量与相关成分 | 灰分(Ash) | 1.0g | 24 | 2.2g |
| 能量与相关成分 | 碳水化合物(CHO) | 1.1g | 28 | 5.2g |
| 能量与相关成分 | 总膳食纤维(Dietary fiber) | — | — | — |
| 维生素 | 维生素A(Vitamin) | 13.0μg | 19 | 218.5μg |
| 维生素 | 硫胺素(Thiamin) | 0.19mg | 24 | 0.27mg |
| 维生素 | 核黄素(Riboflavin) | 0.48mg | 3 | 0.21mg |
| 维生素 | 烟酸(Niacin) | 6.80mg | 9 | 4.47mg |
| 维生素 | 维生素C(Vitamin C) | 4.0mg | 3 | 0.8mg |
| 矿物质 | 磷(P) | 189mg | 8 | 135mg |
| 矿物质 | 钾(K) | 260mg | 13 | 206mg |
| 矿物质 | 钠(Na) | 71.2mg | 31 | 392.7mg |
| 矿物质 | 镁(Mg) | 17mg | 17 | 17mg |
| 矿物质 | 铁(Fe) | 4.3mg | 10 | 3.1mg |
| 矿物质 | 锌(Zn) | 1.90mg | 26 | 2.12mg |
| 矿物质 | 硒(Se) | 14.90μg | 7 | 11.94μg |
| 矿物质 | 铜(Cu) | 0.37mg | 5 | 0.16mg |
| 矿物质 | 锰(Mn) | 0.05mg | 17 | 0.08mg |
| 矿物质 | 碘(I) | — | — | — |
| 脂肪酸 | 单不饱和脂肪酸(MUFA) | 38.4% | 34 | 39.6% |
| 脂肪酸 | 多不饱和脂肪酸(PUFA) | 20.8% | 6 | 11.3% |
| 脂肪酸 | 合计(Total) | 99.3% | 22 | 83.0% |', '', '', '', '营养,食材,内脏,猪心', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', 'https://nlc.chinanutri.cn/fq/foodinfo/802.html', 'approved'),
('猪肝（卤煮，中国第6版） · 每 100 g 营养数据', '猪肝(卤煮)（每 100 克）

> 数据来源于中国食物成分表；版权归中国疾病预防控制中心营养与健康所，仅限非商业内部研发使用。

| 类别 | 项目 | 含量 | 同类排名 | 同类均值 |
| --- | --- | --- | --- | --- |
| 能量与相关成分 | 食部(Edible) | 100% | 1 | 93% |
| 能量与相关成分 | 水分(Water) | 56.4g | 23 | 55.1g |
| 能量与相关成分 | 能量(Energy) | 851kJ | 30 | 1164kJ |
| 能量与相关成分 | 蛋白质(Protein) | 26.4g | 1 | 15.7g |
| 能量与相关成分 | 脂肪(Fat) | 8.3g | 35 | 21.8g |
| 能量与相关成分 | 胆固醇(Cholesterol) | 469mg | 2 | 172mg |
| 能量与相关成分 | 灰分(Ash) | 3.3g | 11 | 2.2g |
| 能量与相关成分 | 碳水化合物(CHO) | 5.6g | 13 | 5.2g |
| 能量与相关成分 | 总膳食纤维(Dietary fiber) | — | — | — |
| 维生素 | 维生素A(Vitamin) | 4200.0μg | 2 | 218.5μg |
| 维生素 | 硫胺素(Thiamin) | 0.36mg | 13 | 0.27mg |
| 维生素 | 核黄素(Riboflavin) | 0.42mg | 5 | 0.21mg |
| 维生素 | 烟酸(Niacin) | — | — | — |
| 维生素 | 维生素C(Vitamin C) | — | — | — |
| 矿物质 | 磷(P) | 153mg | 20 | 135mg |
| 矿物质 | 钾(K) | 188mg | 25 | 206mg |
| 矿物质 | 钠(Na) | 674.7mg | 11 | 392.7mg |
| 矿物质 | 镁(Mg) | 12mg | 28 | 17mg |
| 矿物质 | 铁(Fe) | 2.0mg | 26 | 3.1mg |
| 矿物质 | 锌(Zn) | 0.35mg | 43 | 2.12mg |
| 矿物质 | 硒(Se) | 28.70μg | 3 | 11.94μg |
| 矿物质 | 铜(Cu) | 0.39mg | 4 | 0.16mg |
| 矿物质 | 锰(Mn) | 0.27mg | 3 | 0.08mg |
| 矿物质 | 碘(I) | — | — | — |
| 脂肪酸 | 单不饱和脂肪酸(MUFA) | 40.7% | 31 | 39.6% |
| 脂肪酸 | 多不饱和脂肪酸(PUFA) | 11.1% | 21 | 11.3% |
| 脂肪酸 | 合计(Total) | 100.0% | 4 | 83.0% |', '', '', '', '营养,食材,内脏,猪肝', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', 'https://nlc.chinanutri.cn/fq/foodinfo/809.html', 'approved'),
('猪肝（生，中国第6版） · 每 100 g 营养数据', '猪肝（每 100 克）

> 数据来源于中国食物成分表；版权归中国疾病预防控制中心营养与健康所，仅限非商业内部研发使用。

| 类别 | 项目 | 含量 | 同类排名 | 同类均值 |
| --- | --- | --- | --- | --- |
| 能量与相关成分 | 食部(Edible) | 99% | 29 | 93% |
| 能量与相关成分 | 水分(Water) | 70.7g | 10 | 55.1g |
| 能量与相关成分 | 能量(Energy) | 543kJ | 39 | 1164kJ |
| 能量与相关成分 | 蛋白质(Protein) | 19.3g | 12 | 15.7g |
| 能量与相关成分 | 脂肪(Fat) | 3.5g | 41 | 21.8g |
| 能量与相关成分 | 胆固醇(Cholesterol) | 288mg | 5 | 172mg |
| 能量与相关成分 | 灰分(Ash) | 1.5g | 21 | 2.2g |
| 能量与相关成分 | 碳水化合物(CHO) | 5.0g | 14 | 5.2g |
| 能量与相关成分 | 总膳食纤维(Dietary fiber) | — | — | — |
| 维生素 | 维生素A(Vitamin) | 4972.0μg | 1 | 218.5μg |
| 维生素 | 硫胺素(Thiamin) | 0.21mg | 23 | 0.27mg |
| 维生素 | 核黄素(Riboflavin) | 2.08mg | 1 | 0.21mg |
| 维生素 | 烟酸(Niacin) | 15.00mg | 1 | 4.47mg |
| 维生素 | 维生素C(Vitamin C) | 20.0mg | 1 | 0.8mg |
| 矿物质 | 磷(P) | 310mg | 1 | 135mg |
| 矿物质 | 钾(K) | 235mg | 15 | 206mg |
| 矿物质 | 钠(Na) | 68.6mg | 32 | 392.7mg |
| 矿物质 | 镁(Mg) | 24mg | 9 | 17mg |
| 矿物质 | 铁(Fe) | 22.6mg | 1 | 3.1mg |
| 矿物质 | 锌(Zn) | 5.78mg | 2 | 2.12mg |
| 矿物质 | 硒(Se) | 19.20μg | 5 | 11.94μg |
| 矿物质 | 铜(Cu) | 0.65mg | 1 | 0.16mg |
| 矿物质 | 锰(Mn) | 0.26mg | 4 | 0.08mg |
| 矿物质 | 碘(I) | — | — | — |
| 脂肪酸 | 单不饱和脂肪酸(MUFA) | 27.3% | 38 | 39.6% |
| 脂肪酸 | 多不饱和脂肪酸(PUFA) | 26.0% | 2 | 11.3% |
| 脂肪酸 | 合计(Total) | 96.6% | 30 | 83.0% |', '', '', '', '营养,食材,内脏,猪肝', 'informational', '中国食物成分表（第6版）在线查询平台', 'official', 'https://nlc.chinanutri.cn/fq/foodinfo/797.html', 'approved'),
('FAO/INFOODS 目录 · 第 1 段', 'FAO/INFOODS 食物成分表与数据库目录

1. 用途

FAO/INFOODS 本身是各国官方食物成分表/数据库的索引，不是单一食材数据源。本目录用于：

- 追溯中国、日本等国家成分表的官方条目与获取方式；
- 在需要其他国家或地区数据时快速定位入口；
- 为“数据来源是否权威、是否可获取”提供证据链。

2. 本次抓取

- 目录页：<https://www.fao.org/food-composition/tables-and-databases/en>，共 11 页、220 条记录。
- 全部标题与链接：`data/infoods-tables-and-databases-links.json`。
- 与本项目直接相关的条目：
  - 中国 2018（第6版第1卷）：Print-only，无官方免费电子文件。
  - 中国 2019（第6版第2卷）：Print-only，FAO 条目给出在线查询平台 <https://nlc.chinanutri.cn/fq/>。
  - 日本 2023（八订）：Free access，指向 <https://fooddb.mext.go.jp/>。
- 原文抽取：
  - [infoods-index.md](raw_extracts/infoods-index.md)
  - [china-2018.md](raw_extracts/china-2018.md)
  - [china-2019.md](raw_extracts/china-2019.md)
  - [japan-2023.md](raw_extracts/japan-2023.md)

3. 结论

- 中国食物成分表第6版没有可直接下载的官方 PDF/Excel；实际可用入口是 nlc.chinanutri.cn 在线查询平台（本知识库已抓取具体食材）。
- 日本八订有官方 Excel/PDF 下载（本知识库已存档）。
- 其他国家条目可按需从 `data/infoods-tables-and-databases-links.json` 检索，不必一次性全部抓取。

4. 版权

FAO/INFOODS 目录页文本与各国数据库条目版权归 FAO 及相应机构；本目录仅保存索引与少量条目说明，具体数据请回到各国官方来源。', '', '', '', '营养,食材,数据来源,用途,本次抓取,结论', 'informational', 'FAO/INFOODS 食物成分数据库目录', 'official', 'https://www.fao.org/food-composition/tables-and-databases/en', 'approved'),
('中国食物成分表第6版（FAO 目录） · 来源记录', '(China, 2018) China Food Composition Table - Standard Edition 6 Release 1

- 获取方式：Print-only（纸质书，未提供电子版）
- 引用：Yang, Y. 2018. China food composition table (standard, 6th edition, volume 1). Beijing, Institute of Nutrition and Food Safety, Chinese Center for Disease Control and Prevention; Peking University Medical Press. 361 pp. ISBN 978-7-5659-1699-1.
- 备注：FAO INFOODS 目录将其标注为 Print-only；未找到官方免费电子文件。', '', '', '', '营养,食材,数据来源', 'informational', 'FAO/INFOODS 食物成分数据库目录', 'official', 'https://www.fao.org/food-composition/tables-and-databases/detail/(china--2018)-china-food-composition-table---standard-edition-6-release-1/en', 'approved'),
('中国食物成分表第6版第2卷（FAO 目录） · 来源记录', '(China, 2019) China Food Composition Table - standard edition 6, volume 2

- 获取方式：Print-only + 在线查询平台
- 引用：Yang, Y. (Ed.). 2019. China Food Composition Table (Standard, 6th Edition, Volume 2). Institute of National and Food Safety, Chinese Center for Disease Control and Prevention. Peking University Medical Press. ISBN: 978-7565919787. 429 pp.
- 备注：FAO 条目给出在线查询平台 https://nlc.chinanutri.cn/fq/ ，本知识库的具体食材数据即来自该平台。', '', '', '', '营养,食材,数据来源', 'informational', 'FAO/INFOODS 食物成分数据库目录', 'official', 'https://www.fao.org/food-composition/tables-and-databases/detail/(china--2019)-china-food-composition-table--standard-edition-6-release-2/en', 'approved'),
('FAO/INFOODS 食物成分表目录 · 来源记录', 'FAO/INFOODS Tables and databases（目录页）

该目录共抓取到 220 条各国/地区食物成分表或数据库记录（11 页，每页 20 条）。完整标题与链接见 `data/infoods-tables-and-databases-links.json`。

与本知识库直接相关的条目

| 国家/地区 | 年份 | 条目 | 获取方式 | 详情 |
| --- | --- | --- | --- | --- |
| China | 2018 | China Food Composition Table - Standard Edition 6 Release 1 | Print-only | [china-2018.md](china-2018.md) |
| China | 2019 | China Food Composition Table - standard edition 6, volume 2 | Print-only + 在线查询平台 | [china-2019.md](china-2019.md) |
| Japan | 2023 | Standard Tables of Food Composition in Japan - 8th edition | Free access | [japan-2023.md](japan-2023.md) |', '', '', '', '营养,食材,数据来源,与本知识库直接相关的条目', 'informational', 'FAO/INFOODS 食物成分数据库目录', 'official', 'https://www.fao.org/food-composition/tables-and-databases/en', 'approved'),
('日本食品標準成分表（FAO 目录） · 来源记录', '(Japan, 2023) Standard Tables of Food Composition in Japan - 8th edition

- 获取方式：Free access（PDF / Excel / 在线检索）
- 引用：Ministry of Education, Culture, Sports, Science and Technology (MEXT). 2023. Standard Tables of Food Composition in Japan – Eighth Revised Edition (supplement 2023). Tokyo, MEXT.
- 备注：官方数据与下载页见 https://fooddb.mext.go.jp/ 与 https://www.mext.go.jp/a_menu/syokuhinseibun/mext_00001.html 。', '', '', '', '营养,食材,数据来源', 'informational', 'FAO/INFOODS 食物成分数据库目录', 'official', 'https://www.fao.org/food-composition/tables-and-databases/detail/(japan--2023)-standard-tables-of-food-composition-in-japan---8th-edition/en', 'approved'),
('FEDIAF 营养指南 2025 · 第 1 段', 'FEDIAF Nutritional Guidelines（2025 版）

1. 用途

FEDIAF（欧洲宠物食品工业联合会）的犬猫全价/补充食品营养指南，用于对照商品粮与自制配方的营养充足性、矿物质与维生素上下限。它**不是食材成分表**，不能提供猪肝、鸡心每 100 g 的具体数值；在本知识库中作为“营养需求与安全上限”的参考。

2. 本次抓取

- 官方页面：<https://europeanpetfood.org/self-regulation/nutritional-guidelines/>
- 直接 PDF：<https://europeanpetfood.org/wp-content/uploads/2025/09/FEDIAF-Nutritional-Guidelines_2025-ONLINE.pdf>
- 版本：September 2025（抓取时页面所列最新在线版）
- 文件：
  - `pdf/FEDIAF-Nutritional-Guidelines-2025.pdf`
  - `raw_extracts/FEDIAF-Nutritional-Guidelines-2025.md`（全文抽取，约 39 万字符）

3. 可检索内容

全文抽取保留原文章节结构，可用于检索：

- 犬猫不同生命阶段的能量与营养需要；
- 蛋白质、脂肪、碳水化合物、矿物质、维生素的推荐值与最高限量；
- 全价食品与补充食品的区别；
- 营养充足性声明与标签相关表述。

4. 使用限制

1. FEDIAF 数值针对**全价/补充宠物食品**，不是单一食材；不能把指南中的 mg/kg 直接当作食材含量。
2. 2025 版为欧洲口径；与中国 GB/T 31216/31217、美国 AAFCO 存在差异，跨标准比较时应分别标注来源。
3. 具体疾病个体（肝病、肾病、胰腺炎等）的饮食管理需兽医介入。

5. 版权

FEDIAF 指南版权归 FEDIAF 所有。本目录仅保存内部研发用副本与文本抽取，不对外分发；引用时保留文件标题、年份与官方 URL。', '', '', '', '营养,营养标准,内脏,猪肝,鸡心,用途,本次抓取,可检索内容', 'informational', 'FEDIAF Nutritional Guidelines 2025', 'standard', 'https://europeanpetfood.org/self-regulation/nutritional-guidelines/', 'approved'),
('WSAVA 全球营养指南 · 第 1 段', 'WSAVA Global Nutrition Guidelines 与工具包

1. 用途

WSAVA 全球营养指南与 GNC 工具包用于：

- 营养评估流程、体况评分（BCS）、肌肉状况评分（MCS）；
- 宠物食品选择、零食上限、生肉基饮食风险；
- 为“内脏只能作为少量加餐、必须煮熟、不能替代全价主粮”等边界提供指南依据。

本目录只收录与食材/喂食安全直接相关的核心 PDF，不重复收录全部 WSAVA 全球指南板块。

2. 本次抓取

官方页面：<https://wsava.org/global-guidelines/global-nutrition-guidelines/>

| 文件 | 说明 | 文本抽取 |
| --- | --- | --- |
| `WSAVA-Nutrition-Assessment-Guidelines-2011-JSAP.pdf` | WSAVA 全球营养评估指南（2011 JSAP 版） | 约 4.7 万字符 |
| `Global-Nutritional-Assesment-Guidelines-Chinese.pdf` | 上述指南的中文版 | 约 1.9 万字符 |
| `Implementing-the-WSAVA-Nutrition-Guidelines.pdf` | 指南实施建议 | 约 0.4 万字符（图表为主） |
| `Nutritional-Assessment-Checklist.pdf` | 营养评估核查表 | 约 0.86 万字符 |
| `Raw-Meat-Based-Diets-for-Pets_WSAVA-Global-Nutrition-Toolkit.pdf` | 生肉基饮食风险 | 约 0.45 万字符 |
| `WSAVA_GuidetoTreats_Cats_251107.pdf` | 猫零食指南（2025-11） | 约 0.6 万字符 |
| `WSAVA_GuidetoTreats_Dogs_251107.pdf` | 犬零食指南（2025-11） | 约 0.78 万字符 |

- PDF 存于 `pdf/`，全文抽取存于 `raw_extracts/`（带 YAML frontmatter）。
- `Implementing` 与两份零食指南以信息图为主，文本抽取不完整；检索时优先使用 PDF 原文或人工整理稿。', '', '', '', '营养,营养指南,用途,本次抓取,与食材数据的关系', 'caution', 'WSAVA Global Nutrition Guidelines', 'guideline', 'https://wsava.org/global-guidelines/global-nutrition-guidelines/', 'approved'),
('WSAVA 全球营养指南 · 与食材数据的关系', '3. 与食材数据的关系

- WSAVA 资料不含猪肝、鸡心每 100 g 成分值；食材数值请用 `01-usda-fooddata-central/`、`02-japan-mext-food-composition/`、`03-china-food-composition/`。
- 本目录用于回答“内脏能不能喂、喂多少原则、生食风险、零食热量占比”等问题；具体剂量与疾病饮食需兽医评估。

4. 版权与署名

WSAVA 营养指南与工具包版权归 World Small Animal Veterinary Association 所有。内部使用时保留原始文件与来源 URL；对外发布或翻译须遵守 WSAVA GNC 的 SOP（先申请、整份翻译、保留 GNC Logo、送审 30 天等）。本目录仅用于内部 RAG 检索验证，不对外分发。', '', '', '', '营养,营养指南,内脏,猪肝,鸡心,用途,本次抓取,与食材数据的关系', 'caution', 'WSAVA Global Nutrition Guidelines', 'guideline', 'https://wsava.org/global-guidelines/global-nutrition-guidelines/', 'approved'),
('NRC 犬猫营养需要 2006 · 第 1 段', 'NRC《Nutrient Requirements of Dogs and Cats》(2006)

1. 用途

美国国家科学院（National Academies）出版的犬猫营养需要权威报告，提供各生命阶段的推荐摄入量、安全上限与缺乏/过量背景，是肝脏维生素 A、铜上限等判断的重要依据。

2. 本次抓取

- 书籍目录页：<https://nap.nationalacademies.org/catalog/10668/nutrient-requirements-of-dogs-and-cats>
- 完整报告为付费/在线阅读，**未下载盗版 PDF**。
- 官方免费提供两份面向宠物主人的科普手册，已下载并抽取：
  - `pdf/NRC-Your-Dogs-Nutritional-Needs.pdf`（约 5.8 MB，全文约 3.8 万字符）
  - `pdf/NRC-Your-Cats-Nutritional-Needs.pdf`（约 2.6 MB，全文约 4.4 万字符）
  - 文本抽取：`raw_extracts/NRC-Your-Dogs-Nutritional-Needs.md`、`raw_extracts/NRC-Your-Cats-Nutritional-Needs.md`
- 目录页快照：`data/nrc-catalog.html`

3. 使用限制

1. 两份免费手册是科普摘要，**不是** NRC 2006 完整报告；不能把手册中的简化表格当作完整需要量数据。
2. 需要精确的推荐摄入量、安全上限与试验依据时，应购买/在线阅读原报告，并在知识条目中注明章节与页码。
3. NRC 数据主要基于实验动物与研究文献，个体化喂食仍需结合体况、疾病与兽医意见。

4. 版权

NRC 报告与手册版权归 National Academies Press 所有；本目录保存官方免费手册与目录页，仅用于内部研发检索，不对外分发。', '', '', '', '营养,营养需求,用途,本次抓取,使用限制', 'informational', 'NRC Nutrient Requirements of Dogs and Cats (2006)', 'book', 'https://nap.nationalacademies.org/catalog/10668/nutrient-requirements-of-dogs-and-cats', 'approved'),
('AAFCO 犬猫营养 profiles · 第 1 段', 'AAFCO（美国饲料管理协会）

1. 用途

AAFCO 的犬猫营养 profiles 用于对照美国全价粮的最低/最高营养值（蛋白质、脂肪、钙、磷、牛磺酸等），可作为跨标准比较的参考。它不是食材成分表，不能提供猪肝、鸡心的每 100 g 数值。

2. 本次抓取情况

- 官网：<https://www.aafco.org/>
- 抓取结果：首页可访问但正文由脚本/样式动态加载，本次仅保存到不完整快照 `data/aafco-home.html`（约 4.8 KB），**未取得营养 profiles 正文**。
- AAFCO 的完整营养 profiles 与官方解释收录于付费的 *AAFCO Official Publication*，官网不提供可批量下载的公开数据集。
- 因此本目录**没有可入库的 AAFCO 数据文件**；如需使用，请通过官方渠道获取现行版 Official Publication，并在知识条目中注明版本与章节。

3. 使用限制

1. AAFCO profiles 是美国口径，与中国 GB/T 31216/31217、欧洲 FEDIAF 存在差异；不可混用同一套阈值。
2. 标签上的“保证分析值”是最小/最大值，不能直接当作精确营养含量。
3. 本知识库不复制受版权保护的 AAFCO 表格；问答中如涉及 AAFCO 标准，应提示用户查阅官方现行版。

4. 版权

AAFCO 出版物与营养 profiles 版权归 AAFCO 所有；本目录仅保留抓取状态说明，不包含其受版权保护的正文。', '', '', '', '营养,营养标准,内脏,猪肝,鸡心,用途,本次抓取情况,使用限制', 'informational', 'AAFCO', 'official', 'https://www.aafco.org/', 'approved'),
('GB/T 31216/31217 标准 · 第 1 段', 'GB/T 31216-2014 / GB/T 31217-2014 全价宠物食品标准

1. 用途

中国全价犬粮、猫粮国家标准，用于营养达标判定（蛋白质、脂肪、钙、磷、赖氨酸、牛磺酸等）。本目录只保存标准元数据与官方检索入口，**不包含标准正文**。

2. 标准元数据

| 项目 | GB/T 31216-2014 | GB/T 31217-2014 |
| --- | --- | --- |
| 中文名称 | 全价宠物食品 犬粮 | 全价宠物食品 猫粮 |
| 英文名称 | Complete pet food — Dog food | Complete pet food — Cat food |
| 标准状态 | 现行 | 现行 |
| 发布日期 | 2014-09-03 | 2014-09-03 |
| 实施日期 | 2015-03-08 | 2015-03-08 |
| CCS | B46 | B46 |
| ICS | 65.120 | 65.120 |
| 主管/归口 | 国家标准委 | 国家标准委 |
| 发布单位 | 国家质量监督检验检疫总局、国家标准化管理委员会 | 同左 |
| 备注 | 2014 年第 21 号公告 | 2014 年第 21 号公告 |
| 修订计划 | 20253042-T-469 | 20253041-T-469 |

3. 官方入口与抓取情况

- 国家标准全文公开系统：<https://openstd.samr.gov.cn/bzgk/gb/>
- 详情页：
  - 犬粮：<https://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=A8758F9C4633B2CCBEE9C82CC3F4A4D1>
  - 猫粮：<https://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=9496ABE283E8EB1FF58DF961B2DBAC9B>
- 已保存：
  - `data/GB-T-31216-2014-detail.html`
  - `data/GB-T-31217-2014-detail.html`
  - `data/GB-T-31216-2014-search.html`
  - `data/GB-T-31217-2014-search.html`
- 详情页提供“在线预览 / 下载标准”按钮，但全文预览依赖浏览器专用组件；本次未直接取得标准 PDF，**目录中不存放标准正文**。', '', '', '', '营养,营养标准,用途,标准元数据,官方入口与抓取情况', 'informational', 'GB/T 31216-2014 / GB/T 31217-2014', 'standard', 'https://openstd.samr.gov.cn/bzgk/gb/', 'approved'),
('GB/T 31216/31217 标准 · 使用限制', '4. 使用限制

1. 标准可能修订；修订计划 20253042-T-469（犬粮）与 20253041-T-469（猫粮）落地后，应更新引用年份与阈值。
2. 营养达标判定应换算**干物质基准（DM%）**后再比较；标签保证值是最小/最大约束，不能作为精确输入。
3. 本目录不复制标准正文，问答中引用条款时应提示查阅官方现行版。

5. 版权

标准文本版权归国家标准化管理委员会及相关起草单位所有；本目录仅保存公开元数据与页面快照，用于内部检索与来源追踪。', '', '', '', '营养,营养标准,用途,标准元数据,官方入口与抓取情况', 'informational', 'GB/T 31216-2014 / GB/T 31217-2014', 'standard', 'https://openstd.samr.gov.cn/bzgk/gb/', 'approved'),
('ECVCN 与 Balance IT · 第 1 段', 'ECVCN 与 Balance IT

本板块不是食材成分数据源，而是专业机构与自制食谱校验工具的索引，用于“何时需要转诊营养专科”“自制配方如何做营养完整性校验”的问答背景。

1. ECVCN（欧洲兽医与比较营养学院）

- 官网：<https://www.ecvcn.org/>
- 性质：欧洲兽医专科认证机构，负责兽医与比较营养（Large/Small animal nutrition）住院医师培训与专科医师（Diplomates）认证。
- 用途：需要营养专科意见时，可作为转诊与专业资质背景；不提供食材成分表或公开配方数据。
- 页面快照：`data/ecvcn-home.html`

2. Balance IT（UC Davis 团队）

- 官网：<https://balanceit.com/>
- 性质：面向兽医与宠物主人的自制犬猫食谱生成与营养完整性校验工具，配套补充剂；强调由 Board-Certified Veterinary Nutritionist® 参与。
- 用途：回答“自制粮如何保证营养完整”时，可提示使用此类工具并由兽医复核；本知识库不复制其配方或数据库。
- 页面快照：`data/balanceit-home.html`

3. 使用边界

1. 两者均不提供可批量下载的食材成分数据；猪肝、鸡心等数值仍以 USDA、中国食物成分表、日本八订为准。
2. 自制配方涉及能量、钙磷比、维生素与矿物质完整性，不能仅凭单一食材数据拼凑；应建议用户咨询兽医或宠物营养师。
3. 本目录只保存公开页面快照，不包含受版权保护的配方或补充剂数据。

4. 版权

ECVCN 与 Balance IT 的页面内容、配方与数据库版权归各自机构所有；本目录仅用于来源索引与内部检索。', '', '', '', '营养,营养资源,内脏,猪肝,鸡心,ECVCN（欧洲兽医与比较营养学院）,使用边界', 'informational', 'ECVCN / Balance IT', 'official', 'https://www.ecvcn.org/', 'approved');
