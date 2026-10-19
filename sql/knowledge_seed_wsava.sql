-- ============================================================
-- FurGuardian 知识库语料扩充：WSAVA 全球指南 + 全球营养委员会
-- 由 sql/build-wsava-seed.mjs 生成，语料根目录 E:/华为云比赛/ziliao/document-content-main/document-content-main
-- 共 70 篇中文摘要 → 765 条，按 ## / ### 标题切分，单条 ≤ 1200 字
-- 生成时间 2026-10-19
-- 幂等：先按本批 title 精确 DELETE，可反复执行
-- 不入库的内容：raw_extracts 英文原文、PDF、关键词索引段、参考文献段
-- ============================================================

SET NAMES utf8mb4;

USE fur_guardian;

-- 幂等删除（仅本批生成的标题，不影响原有 80 条种子）
DELETE FROM knowledge_docs WHERE title IN ('WSAVA 全球指南知识库 — 总索引 · 第 1 段', 'WSAVA 全球指南知识库 — 总索引 · animal-welfare-guidelines 动物福利指南', 'WSAVA 全球指南知识库 — 总索引 · dental-guidelines 全球牙科指南', 'WSAVA 全球指南知识库 — 总索引 · gastrointestinal-guidelines 胃肠病学指南', 'WSAVA 全球指南知识库 — 总索引 · hereditary-disease 遗传病委员会立场文件', 'WSAVA 全球指南知识库 — 总索引 · liver-disease-guidelines 犬猫肝病组织学诊断标准', 'WSAVA 全球指南知识库 — 总索引 · pain-guidelines 全球疼痛管理指南', 'WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (2)', 'WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (3)', 'WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (4)', 'WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (5)', 'WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (6)', 'WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines 兽医职业健康指', 'WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (2)', 'WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (3)', 'WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (4)', 'WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (5)', 'WSAVA 全球指南知识库 — 总索引 · renal-standardization-guidelines 肾病数据标准化', 'WSAVA 全球指南知识库 — 总索引 · reproduction-guidelines 犬猫生殖控制指南', 'WSAVA 全球指南知识库 — 总索引 · reproduction-guidelines　犬猫生殖控制指南 (2)', 'WSAVA 全球指南知识库 — 总索引 · reproduction-guidelines　犬猫生殖控制指南 (3)', 'WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines 犬猫疫苗接种指南', 'WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (2)', 'WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (3)', 'WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (4)', 'WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (5)', 'WSAVA 全球指南知识库 — 总索引 · 核心概念速查', 'WSAVA 全球指南知识库 — 总索引 · 板块与核心概念', 'WSAVA 全球指南知识库 — 总索引 · 板块与核心概念 (2)', 'WSAVA 全球指南知识库 — 总索引 · 板块与核心概念 (3)', 'WSAVA 全球指南知识库 — 总索引 · 跨板块通用要点', 'WSAVA 全球指南知识库 — 总索引 · 版本与取代关系', 'WSAVA 全球指南知识库 — 总索引 · 已知缺口', 'WSAVA 全球指南知识库 — 总索引 · 已知缺口 (2)', 'WSAVA 全球指南知识库 — 总索引 · 已知缺口 (3)', 'WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表', 'WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表 (2)', 'WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表 (3)', 'WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表 (4)', 'WSAVA 全球指南知识库 — 总索引 · 适用场景索引', 'WSAVA 全球指南知识库 — 总索引 · RAG 建库建议', 'WSAVA 全球指南知识库 — 总索引 · 工具与可复现流程', 'WSAVA 全球指南知识库 — 总索引 · 版权与来源', 'Animal Welfare Guidelines · 第 1 段', 'Animal Welfare Guidelines · 第 2 段', 'Animal Welfare Guidelines · Endorsements', 'Animal Welfare Guidelines · 已收录（原文已抽取到 raw_extracts/）', 'Animal Welfare Guidelines · 外部引用（期刊论文 / 相关机构，未抓取正文）', 'WSAVA 动物福利指南2018要点 · 文档基本信息', 'WSAVA 动物福利指南2018要点 · 建议与自查清单', 'WSAVA 动物福利指南2018要点 · 五大自由与五大动物福利需求', 'WSAVA 动物福利指南2018要点 · 评估方法与工具', 'WSAVA 动物福利指南2018要点 · 应激的生理反应', 'WSAVA 动物福利指南2018要点 · 疼痛（pain）：定义与相关条款', 'WSAVA 动物福利指南2018要点 · 总则与就诊期应激/疼痛的影响', 'WSAVA 动物福利指南2018要点 · 五大需求的建议条款（原文）', 'WSAVA 动物福利指南2018要点 · 临床团队落地建议（原文汇总）', 'WSAVA 动物福利指南2018要点 · 建议与伦理类型', 'WSAVA 动物福利指南2018要点 · 四步法与其他常见道德问题', 'WSAVA 动物福利指南2018要点 · 沟通技能与虐待识别', 'WSAVA 动物福利指南2018要点 · 外展的四个层级（图 12）', 'WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表', 'WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表 (2)', 'WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表 (3)', 'WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表 (4)', 'WSAVA 动物福利指南2018要点 · 术语表（Glossary）', 'WSAVA 动物福利指南2018要点 · 图目录与抽取残缺说明', 'WSAVA 动物福利宪章 · 文档基本信息', 'WSAVA 动物福利宪章 · 宪章开宗明义：感受力、福利定义与兽医责任', 'WSAVA 动物福利宪章 · 承诺条款（逐条列出）', 'WSAVA 动物福利宪章 · 承诺条款（逐条列出） (2)', 'WSAVA 动物福利宪章 · 承诺条款（逐条列出） (3)', 'WSAVA 动物福利宪章 · 五大动物福利需求（Five Animal Welfare Needs）', 'WSAVA 动物福利宪章 · 宪章与《WSAVA 动物福利指南 2018》的关系', 'Dental Guidelines · 第 1 段', 'Dental Guidelines · Guidelines Translations', 'Dental Guidelines · Endorsements', 'Dental Guidelines · 本板块文档清单', 'Dental Guidelines · 未收录（同一指南的其他语言译本）', 'WSAVA全球牙科指南要点 · 第 1 段', 'WSAVA全球牙科指南要点 · 牙周疾病关键数据', 'WSAVA全球牙科指南要点 · 齿吸收（tooth resorption, TR）', 'WSAVA全球牙科指南要点 · 第 2 节：动物福利', 'WSAVA全球牙科指南要点 · 表 3：用于犬猫之镇静、麻醉前给药和化学保定的药物', 'WSAVA全球牙科指南要点 · 表 5：经常用于动物麻醉和疼痛管理的局部麻醉剂', 'WSAVA全球牙科指南要点 · 第 2 段', 'WSAVA全球牙科指南要点 · 麻醉安全要点', 'WSAVA全球牙科指南要点 · 清醒检查与表 7 口腔健康指标', 'WSAVA全球牙科指南要点 · 全身麻醉下的详细检查步骤（原文 14 步）', 'WSAVA全球牙科指南要点 · 第 5 节：牙周治疗与专业洁牙', 'WSAVA全球牙科指南要点 · 分期与指数（原文方框 3、4、5）', 'WSAVA全球牙科指南要点 · 牙科居家照护（家庭口腔护理）', 'WSAVA全球牙科指南要点 · 第 6 节：牙科放射线学（影像要点）', 'WSAVA全球牙科指南要点 · 第 7 节：拔牙与牙冠切除术（拔牙指征）', 'WSAVA全球牙科指南要点 · 第 8 节、AFD 立场声明与第 9 节设备', '口腔肿瘤与病变识别 · 第 1 段', '口腔肿瘤与病变识别 · 第三个问题：它是否已经扩散到全身（Has It Spread Through T', '口腔肿瘤与病变识别 · 分类框架', '口腔肿瘤与病变识别 · 恶性肿瘤', '口腔肿瘤与病变识别 · 良性肿瘤与类肿瘤病变', '口腔肿瘤与病变识别 · 需与肿瘤鉴别的病变', '犬猫刷牙工具包 · 第 1 段', '犬猫刷牙工具包 · 时间安排与频次', '犬猫刷牙工具包 · 步骤 3：轻柔按摩牙龈（Gently Massage the Gums）', '犬猫刷牙工具包 · 步骤 5：定期检查（Regular Checkups）', '犬猫刷牙工具包 · 补充对照（出自《WSAVA 全球牙科指南》第 5 节「牙科居家照护」）', 'Gastrointestinal Guidelines · 第 1 段', 'Gastrointestinal Guidelines · 已收录（原文已抽取到 raw_extracts/）', '犬猫内镜检查报告表 · 表单背景与适用范围', '犬猫内镜检查报告表 · 基本信息与操作记录项', '犬猫内镜检查报告表 · 食管（ESOPHAGUS）', '犬猫内镜检查报告表 · 十二指肠／空肠（DUODENUM/JEJUNUM）', '犬猫内镜检查报告表 · 问题／并发症', '犬猫内镜检查报告表 · 回肠（ILEUM）', '犬猫内镜检查报告表 · 上下消化道两表差异速查', '犬猫内镜检查报告表 · 可填写项总清单（供精确检索）', '犬猫内镜检查报告表 · 可填写项总清单（供精确检索） (2)', '犬猫内镜检查报告表 · 原文缺失与整理说明', 'Hereditary Disease Guideline · 第 1 段', 'Hereditary Disease Guideline · The Role of Health-Conscious Breeding an', 'Hereditary Disease Guideline · 外部引用（期刊论文 / 相关机构，未抓取正文）', 'WSAVA 遗传病委员会立场文件 · 文件定位与核心主张', 'WSAVA 遗传病委员会立场文件 · 配前健康筛查（pre-breeding health screening）', 'WSAVA 遗传病委员会立场文件 · 多重检测panel 与结果过滤', 'WSAVA 遗传病委员会立场文件 · WSAVA 资助的遗传病检测实验室数据库', 'WSAVA 遗传病委员会立场文件 · 立场要点速查表', 'WSAVA 遗传病委员会立场文件 · 延伸资料', 'Liver Disease Guidelines · 第 1 段', 'Liver Disease Guidelines · Endorsements', 'Liver Disease Guidelines · 本板块文档清单', '犬猫肝病临床与组织学诊断标准 · 本板块资料的性质（重要前提）', '犬猫肝病临床与组织学诊断标准 · 执行摘要（原文逐字对应）', '犬猫肝病临床与组织学诊断标准 · 标准载体的书目信息', '犬猫肝病临床与组织学诊断标准 · 板块页面列出的背书机构（Endorsements）', '犬猫肝病临床与组织学诊断标准 · 使用该名单时必须注意的疑点', '犬猫肝病临床与组织学诊断标准 · 页面全部实质性英文语句（可逐字引用）', '犬猫肝病临床与组织学诊断标准 · 背书名单的文本保真记录', '犬猫肝病临床与组织学诊断标准 · 机构名称中的地域与专科提示（仅由名称字面译出，不涉原页面未提供的信息）', '犬猫肝病临床与组织学诊断标准 · 犬猫肝病标准的可用与不可用信息边界', 'Microchip Identification Gui · 第 1 段', 'Microchip Identification Gui · Guidelines', 'Microchip Identification Gui · Guidelines (2)', 'Microchip Identification Gui · Guidelines (3)', 'Microchip Identification Gui · Microchip implantation sites for small (', 'Microchip Identification Gui · Microchip implantation sites for small ( (2)', 'Microchip Identification Gui · Microchip implantation sites for small ( (3)', 'Microchip Identification Gui · Microchip implantation sites for small ( (4)', 'Microchip Identification Gui · Microchip implantation sites for small ( (5)', 'Microchip Identification Gui · Enhancing Reader Performance', 'Microchip Identification Gui · Enhancing Reader Performance (2)', 'Microchip Identification Gui · Enhancing Reader Performance (3)', 'Microchip Identification Gui · Enhancing Reader Performance (4)', 'Microchip Identification Gui · Microchip FAQs', 'Microchip Identification Gui · Microchip FAQs (2)', 'Microchip Identification Gui · Microchip FAQs (3)', 'Microchip Identification Gui · Microchip FAQs (4)', 'Microchip Identification Gui · 本板块文档清单', 'WSAVA 微芯片识别与应用指南 · 指南定位与执行摘要', 'WSAVA 微芯片识别与应用指南 · 判定一枚芯片是否真正为 ISO 芯片（尤其在美国市场内）', 'WSAVA 微芯片识别与应用指南 · 国家码与厂商码的区别', 'WSAVA 微芯片识别与应用指南 · Annex A 芯片是否算 ISO 标准芯片', 'WSAVA 微芯片识别与应用指南 · 犬与猫（Canine and Feline）', 'WSAVA 微芯片识别与应用指南 · 其他物种推荐部位（原文分类逐条）', 'WSAVA 微芯片识别与应用指南 · 其他物种推荐部位（原文分类逐条） (2)', 'WSAVA 微芯片识别与应用指南 · 其他物种推荐部位（原文分类逐条） (3)', 'WSAVA 微芯片识别与应用指南 · 特殊用途的部位例外（原文 Note）', 'WSAVA 微芯片识别与应用指南 · 扫描动作要领（逐条还原原文顺序）', 'WSAVA 微芯片识别与应用指南 · 登记数据库相关内容（页面正文所含部分）', 'WSAVA 微芯片识别与应用指南 · 各章节要点表', 'WSAVA 微芯片识别与应用指南 · 原文缺失与整理说明', 'Pain Guidelines · 第 1 段', 'Pain Guidelines · Pain Management Protocols', 'Pain Guidelines · Downloads', 'Pain Guidelines · 第 2 段', 'Pain Guidelines · 本板块文档清单', 'Pain Guidelines · 已收录（原文已抽取到 raw_extracts/）', 'Pain Guidelines · 已收录（原文已抽取到 raw_extracts/） (2)', 'Pain Guidelines · 已收录（原文已抽取到 raw_extracts/） (3)', 'Pain Guidelines · 未收录（同一指南的其他语言译本）', 'Pain Guidelines · 版权', '2022 WSAVA 疼痛全球指南——概述与评估 · > 本稿覆盖切片 001-014；治疗与用药部分见 15-、16- 两篇。', '2022 WSAVA 疼痛全球指南——概述与评估 · 文献信息与背景', '2022 WSAVA 疼痛全球指南——概述与评估 · 疼痛的定义与分类（1.1 理解疼痛）', '2022 WSAVA 疼痛全球指南——概述与评估 · 疼痛的生理与病理生理（1.2）', '2022 WSAVA 疼痛全球指南——概述与评估 · 伦理与动物福利（1.3）', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5）', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5） (2)', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5） (3)', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5） (4)', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7）', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (2)', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (3)', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (4)', '2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (5)', '2022 WSAVA 疼痛全球指南——概述与评估 · 镇痛不足与不合理多重用药（1.8）', '2022 WSAVA 疼痛全球指南——概述与评估 · 神经病性疼痛（1.9）', '2022 WSAVA 疼痛全球指南——概述与评估 · 口面部与牙齿疼痛（1.10）', '2022 WSAVA 疼痛全球指南——概述与评估 · 癌症疼痛（1.11）', '2022 WSAVA 疼痛全球指南——概述与评估 · 营养与疼痛的交互（1.12）', '2022 WSAVA 疼痛全球指南——概述与评估 · 各病症疼痛感知水平（1.13）与表 11');
DELETE FROM knowledge_docs WHERE title IN ('2022 WSAVA 疼痛全球指南——概述与评估 · 关于疼痛的常见误解（1.14）', '2022 WSAVA 疼痛全球指南——概述与评估 · 关于疼痛的常见误解（1.14） (2)', '2022 WSAVA 疼痛全球指南——概述与评估 · 关于疼痛的常见误解（1.14） (3)', '2022 WSAVA 疼痛全球指南——概述与评估 · SECTION 2 起始：疼痛治疗的总体方法（2.1）', '猫/犬剖腹产疼痛与麻醉管理 · 剖腹产疼痛管理', '猫/犬剖腹产疼痛与麻醉管理 · 评估要点', '猫/犬剖腹产疼痛与麻醉管理 · 镇痛与麻醉方案（按可及性分层）', '猫/犬剖腹产疼痛与麻醉管理 · 择期手术（Elective situation）', '猫/犬剖腹产疼痛与麻醉管理 · 急诊且母体状况不良（Emergency situation with compr', '猫/犬剖腹产疼痛与麻醉管理 · 无管制药物方案（Protocol without controlled drug', '猫/犬剖腹产疼痛与麻醉管理 · 麻醉与镇痛药物可及性受限（Protocol with limited avail', '猫/犬剖腹产疼痛与麻醉管理 · 禁忌与警示', '猫/犬剖腹产疼痛与麻醉管理 · 术后与新生仔管理要点', '癌性疼痛管理 · 第 1 段', '癌性疼痛管理 · 评估要点与机制', '癌性疼痛管理 · 镇痛方案', '癌性疼痛管理 · 文献出处', '犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 犬去势与卵巢子宫切除疼痛管理', '犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration）', '犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 卵巢子宫切除/卵巢切除术（Ovariohysterectomy/ovariect', '犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 监测与出院辅助', '猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 猫去势与卵巢子宫切除疼痛管理', '猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration）', '猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration） (2)', '猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration） (3)', '猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 卵巢子宫切除/卵巢切除术（Ovariohysterectomy/ovariect', '猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 监测与出院辅助', '退行性关节病 · 第 1 段', '退行性关节病 · 评估要点', '退行性关节病 · 非手术、非药物治疗（Non-surgery, non-drug treatmen', '退行性关节病 · 原文前段列举的其他推荐手段（逐字）', '急诊与重症 · 第 1 段', '急诊与重症 · 评估要点', '急诊与重症 · 镇痛方案', '急诊与重症 · 监测与警示', '内科疾病疼痛 · 内科疾病疼痛管理', '内科疾病疼痛 · 评估要点', '内科疾病疼痛 · 重度疼痛（Severe pain）', '内科疾病疼痛 · 中度疼痛（Moderate pain）', '内科疾病疼痛 · 轻度至中度疼痛（Mild to moderate pain）', '内科疾病疼痛 · 监测与警示', '神经病理性疼痛处理方案 · 第 1 段', '神经病理性疼痛处理方案 · 总论：神经病理性疼痛的处理依据', '神经病理性疼痛处理方案 · 原文列举的病症', '神经病理性疼痛处理方案 · 药物剂量表', '神经病理性疼痛处理方案 · 原文缺失项登记', '骨科手术疼痛管理 · 第 1 段', '骨科手术疼痛管理 · 选择依据与局部麻醉技术', '骨科手术疼痛管理 · 标准方案（Protocol for orthopaedic surgery）', '骨科手术疼痛管理 · 无受管制药物方案与药物受限方案', '骨科手术疼痛管理 · 犬股骨骨折修复示例方案', '骨科手术疼痛管理 · 猫股骨骨折修复示例方案', '骨科手术疼痛管理 · 原文缺失项登记', '幼龄动物 · 第 1 段', '幼龄动物 · 第 2 段', '幼龄动物 · 阿片类（Opioids）', '幼龄动物 · 非甾体抗炎药（NSAIDs）', '幼龄动物 · 局部麻醉药（Local anaesthetics）', '幼龄动物 · 非药物技术（Nonpharmacologic techniques）', '妊娠与哺乳动物疼痛管理 · 第 1 段', '妊娠与哺乳动物疼痛管理 · 母体生理变化对药物处置的影响', '妊娠与哺乳动物疼痛管理 · 妊娠期各类药物（剂量原文均未给出）', '妊娠与哺乳动物疼痛管理 · 哺乳期（Lactation）', '妊娠与哺乳动物疼痛管理 · 哺乳期各类药物', '妊娠与哺乳动物疼痛管理 · 原文缺失与抽取质量问题登记', '软组织手术疼痛管理 · 第 1 段', '软组织手术疼痛管理 · 小型软组织手术（Minor soft tissue surgery）方案', '软组织手术疼痛管理 · 大型软组织手术（Major soft tissue surgery）方案', '软组织手术疼痛管理 · 猫注射部位肉瘤手术切除示例（Major soft tissue surgery）', '软组织手术疼痛管理 · 原文缺失项登记', '感知疼痛等级视觉自评图 · 第 1 段', '感知疼痛等级视觉自评图 · 原文使用说明（逐字要点）', '感知疼痛等级视觉自评图 · 版权与数据来源', '感知疼痛等级视觉自评图 · 重度至难以忍受（Severe-to-excrutiating）', '感知疼痛等级视觉自评图 · 第 2 段', '感知疼痛等级视觉自评图 · 中度（Moderate）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · > 本稿覆盖切片 015-029；评估部分见 01-，特殊情形与附录见 16-。', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 概念与分类', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 适应证', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 12：犬猫阿片类镇痛药及拮抗剂 naloxone 推荐（逐字还原）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 12：犬猫阿片类镇痛药及拮抗剂 naloxone 推荐（逐字还原） (2)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 12：犬猫阿片类镇痛药及拮抗剂 naloxone 推荐（逐字还原） (3)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 禁忌、相互作用与注意事项', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 机制与适应证', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (2)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (3)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (4)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (5)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · NSAIDs 不良反应与禁忌', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 其他抗炎药物', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 机制与适应证 (2)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 14：α2 肾上腺素能受体激动剂/拮抗剂药理学特性（逐字还原）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 输注、口服凝胶、不良反应与禁忌', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 局部麻醉药（Anesthésiques locaux, AL）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 15：局麻药理化性质与最大推荐剂量（逐字还原）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 全身毒性及其处理', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 静脉输注利多卡因', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 给药技术与装置（2.6 Techniques d''administration）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 辅助（adjuvant）治疗（2.7 Traitements adjuvants', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 16：犬猫辅助镇痛药剂量推荐（逐字还原）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 16：犬猫辅助镇痛药剂量推荐（逐字还原） (2)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 16：犬猫辅助镇痛药剂量推荐（逐字还原） (3)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 各辅助药物正文要点', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 各辅助药物正文要点 (2)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 各辅助药物正文要点 (3)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 疼痛患者管理中的非镇痛药物（2.8）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 功能性康复（2.9 Rééducation fonctionnelle）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 冷疗（2.10 Thérapie par le froid）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 大麻素类（2.11 Cannabinoïdes）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 处方粮与补充饲料（2.12 Régimes et aliments complé', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (2)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (3)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (4)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (5)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 抗痛单克隆抗体（2.17 Anticorps monoclonaux contr', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 肌肉骨骼辅助治疗（2.18）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 第 3 节：疼痛管理方案示例（3.1-3.5）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 骨科手术（3.3）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 17：犬猫常用镇静药与麻醉药推荐剂量（逐字还原）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 18：猫去势建议方案（三列并排还原）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 19：猫卵巢子宫切除/卵巢切除建议方案', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 20：犬去势建议方案', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 21：犬卵巢子宫切除/卵巢切除建议方案', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 22：骨科手术建议方案（三列；抽取文本严重错乱，逐段照抄）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 22：骨科手术建议方案（三列；抽取文本严重错乱，逐段照抄） (2)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 22：骨科手术建议方案（三列；抽取文本严重错乱，逐段照抄） (3)', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 区域（loco-régionales）技术（3.5）总则', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · Encadré 7：猫股骨骨折修复方案示例（逐字）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 图 24-26 与图 31 的技术要点（切片内可读部分）', '2022 WSAVA 疼痛全球指南——治疗与药物管理 · 原文缺失与抽取断裂位置汇总', '2022 WSAVA 疼痛全球指南 · 局部区域阻滞技术的续（3.5 章节后半，块 030–031）', '2022 WSAVA 疼痛全球指南 · 睾丸内阻滞（Bloc intratesticulaire）', '2022 WSAVA 疼痛全球指南 · 围手术期方案表（Tableau 23 / 24，块 030–031）', '2022 WSAVA 疼痛全球指南 · Encadré 8：猫注射部位肉瘤（sarcome au site d''inje', '2022 WSAVA 疼痛全球指南 · 眼科方案（3.6，块 031）', '2022 WSAVA 疼痛全球指南 · 牙科方案（3.7，块 031–032）', '2022 WSAVA 疼痛全球指南 · 急诊与重症（3.8，块 031–032）', '2022 WSAVA 疼痛全球指南 · 内科疼痛（Douleur médicale，3.9，块 032）', '2022 WSAVA 疼痛全球指南 · 儿科疼痛（Douleurs pédiatriques，3.10，块 032–03', '2022 WSAVA 疼痛全球指南 · 非甾体抗炎药（儿科）', '2022 WSAVA 疼痛全球指南 · 皮肤病（3.11，块 033–034）', '2022 WSAVA 疼痛全球指南 · 耳部疾病（Maladie de l''oreille / otite extern', '2022 WSAVA 疼痛全球指南 · 慢性神经病理性疼痛患者', '2022 WSAVA 疼痛全球指南 · 肌肉骨骼疼痛 / 骨关节炎（3.13，块 034）', '2022 WSAVA 疼痛全球指南 · 癌性疼痛（3.14，块 034–035）', '2022 WSAVA 疼痛全球指南 · 结语、致谢与利益冲突（块 035）', '2022 WSAVA 疼痛全球指南 · 缩略语表（Abréviations，块 035，逐字照录）', '2022 WSAVA 疼痛全球指南 · 缩略语表（Abréviations，块 035，逐字照录） (2)', '2022 WSAVA 疼痛全球指南 · 缩略语表（Abréviations，块 035，逐字照录） (3)', '2022 WSAVA 疼痛全球指南 · 抽取质量提示（块 030–043）', 'Professional Wellness Guidel · 第 1 段', 'Professional Wellness Guidel · Other Resources', 'Professional Wellness Guidel · Downloads', 'Professional Wellness Guidel · 已收录（原文已抽取到 raw_extracts/）', 'Professional Wellness Guidel · 已收录（原文已抽取到 raw_extracts/） (2)', 'Professional Wellness Guidel · 已收录（原文已抽取到 raw_extracts/） (3)', 'Professional Wellness Guidel · 未收录（同一指南的其他语言译本）', 'WSAVA 兽医职业健康指南 · 范围、目标与预警信号（章节 1）', 'WSAVA 兽医职业健康指南 · 风险背景与预警数据', 'WSAVA 兽医职业健康指南 · 健康幸福（Wellbeing）＝状态', 'WSAVA 兽医职业健康指南 · 章节 1 自评清单', 'WSAVA 兽医职业健康指南 · 全球事实与障碍分类（中文版表 1）', 'WSAVA 兽医职业健康指南 · 四类因素与数值', 'WSAVA 兽医职业健康指南 · 章节 2 自评清单', 'WSAVA 兽医职业健康指南 · 工作场所因素（据 BVA, 2020 等）', 'WSAVA 兽医职业健康指南 · 社会因素与职业积极面', 'WSAVA 兽医职业健康指南 · 兽医常见工作场所压力源（原文注明排名不分先后）', 'WSAVA 兽医职业健康指南 · 压力源的影响：心理健康、倦怠与自杀风险（章节 4）', 'WSAVA 兽医职业健康指南 · 常见心理健康问题', 'WSAVA 兽医职业健康指南 · 自杀风险与求助路径', 'WSAVA 兽医职业健康指南 · 院校层面', 'WSAVA 兽医职业健康指南 · 支持与干预项目', 'WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组）', 'WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (2)', 'WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (3)', 'WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (4)', 'WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (5)', 'WSAVA 兽医职业健康指南 · 求助路径与热线速查', 'WSAVA 兽医职业健康指南 · 改善健康幸福的个人方法', 'WSAVA 兽医职业健康指南 · 中英文版本差异与原文缺失标注', 'WSAVA PWG 福祉提示与疫情期压力管理 · 材料性质与适用范围', 'WSAVA PWG 福祉提示与疫情期压力管理 · 步骤 1：开放讨论，为心理健康去污名化', 'WSAVA PWG 福祉提示与疫情期压力管理 · 步骤 5：伙伴制度（buddy schemes）帮助新成员', 'WSAVA PWG 福祉提示与疫情期压力管理 · 保持掌控感（Stay in control）', 'WSAVA PWG 福祉提示与疫情期压力管理 · 保证足够睡眠（Get enough sleep）', 'WSAVA PWG 福祉提示与疫情期压力管理 · 与主指南的衔接', 'Finding the Balance · 第 1 段', 'Finding the Balance · 主要结果', 'Finding the Balance · 主要结果 (2)', 'Finding the Balance · 主要结果 (3)', 'Finding the Balance · 主要结果 (4)', 'Finding the Balance · 主要结果 (5)', 'Finding the Balance · 主要结果 (6)', 'Finding the Balance · 结论与临床启示', '兽医学生的复原力与正念、自悯的预测作用 · 兽医学生的复原力与正念（Mindfulness）、自悯（Self-Compass', '兽医学生的复原力与正念、自悯的预测作用 · 方法（样本、工具、统计）', '兽医学生的复原力与正念、自悯的预测作用 · 主要结果', '兽医学生的复原力与正念、自悯的预测作用 · 主要结果 (2)');
DELETE FROM knowledge_docs WHERE title IN ('兽医学生的复原力与正念、自悯的预测作用 · 主要结果 (3)', '兽医学生的复原力与正念、自悯的预测作用 · 结论与临床启示', '澳洲兽医学生同情疲劳流行率及相关心理因素 · 澳大利亚兽医学生同情疲劳（Compassion Fatigue）的流行率及相关心', '澳洲兽医学生同情疲劳流行率及相关心理因素 · 方法（样本、工具、统计）', '澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果', '澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果 (2)', '澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果 (3)', '澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果 (4)', '澳洲兽医学生同情疲劳流行率及相关心理因素 · 结论与临床启示', '兽医外科医生自杀 · 研究问题', '兽医外科医生自杀 · 风险量化数据', '兽医外科医生自杀 · 风险量化数据 (2)', '兽医外科医生自杀 · 风险量化数据 (3)', '兽医外科医生自杀 · 自杀方式（表 3，英格兰与威尔士 1982-1996，Kelly and Bun', '兽医外科医生自杀 · 可能的风险影响因素', '兽医外科医生自杀 · 可能的风险影响因素 (2)', '兽医外科医生自杀 · 可能的风险影响因素 (3)', '兽医外科医生自杀 · 可能的风险影响因素 (4)', '兽医外科医生自杀 · 可能的风险影响因素 (5)', '兽医外科医生自杀 · 结论与启示', '兽医学生应对策略与寻求心理帮助污名的横断面分析 · 研究问题', '兽医学生应对策略与寻求心理帮助污名的横断面分析 · 方法', '兽医学生应对策略与寻求心理帮助污名的横断面分析 · 主要结果', '兽医学生应对策略与寻求心理帮助污名的横断面分析 · 主要结果 (2)', '兽医学生应对策略与寻求心理帮助污名的横断面分析 · 结论与启示', 'AVA 毕业生导师计划 · 项目背景', 'AVA 毕业生导师计划 · 项目结构与要求', 'AVA 毕业生导师计划 · 申请与参与方式', 'AVA 毕业生导师计划 · 可迁移的做法', 'Renal Standardization Guidel · 第 1 段', 'WSAVA 肾病数据标准化项目 · > **⚠ 内容完整性警示（必读）**', 'WSAVA 肾病数据标准化项目 · 外部论文（仅标题与链接，正文未抓取）', 'WSAVA 肾病数据标准化项目 · 手册抽取状态与技术记录', 'WSAVA 肾病数据标准化项目 · 板块页面元数据与收录状态（逐字）', 'WSAVA 肾病数据标准化项目 · 常见提问与当前可答复状态', 'Reproduction Control Guideli · 第 1 段', 'Reproduction Control Guideli · Resources', 'Reproduction Control Guideli · Downloads', 'Reproduction Control Guideli · 已收录（原文已抽取到 raw_extracts/）', 'Reproduction Control Guideli · 未收录（同一指南的其他语言译本）', '犬猫生殖控制指南2024-第一部分 · > 本稿覆盖切片 001-011；012-033 见 02-、03- 两篇。', '犬猫生殖控制指南2024-第一部分 · 去除性腺激素的手术绝育', '犬猫生殖控制指南2024-第一部分 · 保留性腺激素的犬猫手术绝育方法', '犬猫生殖控制指南2024-第一部分 · 下调激素', '犬猫生殖控制指南2024-第一部分 · 下调激素 (2)', '犬猫生殖控制指南2024-第一部分 · 下调激素 (3)', '犬猫生殖控制指南2024-第一部分 · 下调激素 (4)', '犬猫生殖控制指南2024-第一部分 · 下调激素 (5)', '犬猫生殖控制指南2024-第一部分 · 下调激素 (6)', '犬猫生殖控制指南2024-第一部分 · 免疫避孕药', '犬猫生殖控制指南2024-第一部分 · 化学去势', '犬猫生殖控制指南2024-第一部分 · 化学去势 (2)', '犬猫生殖控制指南2024-第一部分 · 物理方法', '犬猫生殖控制指南2024-第一部分 · 去除性腺激素绝育的健康益处', '犬猫生殖控制指南2024-第一部分 · 母犬', '犬猫生殖控制指南2024-第一部分 · 母犬 (2)', '犬猫生殖控制指南2024-第一部分 · 母犬 (3)', '犬猫生殖控制指南2024-第一部分 · 公犬', '犬猫生殖控制指南2024-第一部分 · 本稿边界说明', '2024 WSAVA 犬猫生殖控制指南 · > 本稿覆盖切片 012-022；001-011 见 01-，023-033 见', '2024 WSAVA 犬猫生殖控制指南 · 生殖道疾病', '2024 WSAVA 犬猫生殖控制指南 · ~4.3.1.2 乳腺疾病', '2024 WSAVA 犬猫生殖控制指南 · 第 5 章 危害——总论与汇总表（章标题页残缺，仅存"05 去除性腺激素绝育对健', '2024 WSAVA 犬猫生殖控制指南 · 第 5 章——母犬（5.1）', '2024 WSAVA 犬猫生殖控制指南 · ~5.1.7 行为与幼年切除', '2024 WSAVA 犬猫生殖控制指南 · ~5.2.7 其余危害要点', '2024 WSAVA 犬猫生殖控制指南 · 第 5 章——猫（5.3）', '2024 WSAVA 犬猫生殖控制指南 · 第 6 章 繁殖管理伦理（6.1~6.8）', '2024 WSAVA 犬猫生殖控制指南 · 不同情况下对犬猫繁殖控制的建议（表 11、12）', '2024 WSAVA 犬猫生殖控制指南 · 睾丸假体与切片覆盖说明', 'WSAVA犬猫生殖控制指南2024-第三部分 · 剂量·规格·样本量·时间窗速查表（从文献题名照录）', 'WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格', 'WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (2)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (3)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (4)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (5)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数', 'WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (2)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (3)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (4)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (5)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (6)', 'WSAVA犬猫生殖控制指南2024-第三部分 · 时间与年龄段参数（内嵌于题名）', 'WSAVA犬猫生殖控制指南2024-第三部分 · 抽取噪声与缺失说明', 'WSAVA犬猫生殖控制指南2024-第三部分 · 拼写与编码噪声（照录清单）', 'WSAVA犬猫生殖控制指南2024-第三部分 · 链接与网址断裂', '犬猫生殖控制指南2024-执行摘要 · 引言（第 1 章）与使用说明', '犬猫生殖控制指南2024-执行摘要 · 关于「推荐等级」的说明', '犬猫生殖控制指南2024-执行摘要 · 委员会立场：OE 为首选', '犬猫生殖控制指南2024-执行摘要 · 手术部位感染与抗菌药预防', '犬猫生殖控制指南2024-执行摘要 · 激素下调', '犬猫生殖控制指南2024-执行摘要 · 化学去势', '犬猫生殖控制指南2024-执行摘要 · 母犬：获益', '犬猫生殖控制指南2024-执行摘要 · 公犬：获益', '犬猫生殖控制指南2024-执行摘要 · 公母犬共有：健康损害', '犬猫生殖控制指南2024-执行摘要 · 母猫：获益与损害', '犬猫生殖控制指南2024-执行摘要 · 生殖控制的伦理（第 6 章）', '犬猫生殖控制指南2024-执行摘要 · 不同情境下的生殖控制推荐（Recommendations in differen', '犬猫生殖控制指南2024-执行摘要 · 母猫', 'Vaccination Guidelines · 第 1 段', 'Vaccination Guidelines · Resources', 'Vaccination Guidelines · Resources (2)', 'Vaccination Guidelines · Resources (3)', 'Vaccination Guidelines · Resources (4)', 'Vaccination Guidelines · Downloads', 'Vaccination Guidelines · 已收录（原文已抽取到 raw_extracts/）', 'Vaccination Guidelines · 未收录（同一指南的其他语言译本）', 'Vaccination Guidelines · 未收录（同一指南的其他语言译本） (2)', 'Vaccination Guidelines · 未收录（同一指南的其他语言译本） (3)', 'Vaccination Guidelines · 版权', '2024年WSAVA犬猫疫苗接种指南 · 指南目的与证据分级方法', '2024年WSAVA犬猫疫苗接种指南 · 综合预防医疗保健与医疗记录', '2024年WSAVA犬猫疫苗接种指南 · 疫苗类型', '2024年WSAVA犬猫疫苗接种指南 · 母源抗体（maternally derived antibody, MDA）与"', '2024年WSAVA犬猫疫苗接种指南 · 血清学检测协助接种决策', '2024年WSAVA犬猫疫苗接种指南 · 核心疫苗（肠外）', '2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗', '2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗 (2)', '2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗 (3)', '2024年WSAVA犬猫疫苗接种指南 · 不推荐给宠物犬接种的疫苗', '2024年WSAVA犬猫疫苗接种指南 · 核心疫苗', '2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗 (4)', '2024年WSAVA犬猫疫苗接种指南 · 不推荐给宠物猫接种的疫苗', '2024年WSAVA犬猫疫苗接种指南 · 幼犬幼猫基础免疫与 26 周龄复种', '2024年WSAVA犬猫疫苗接种指南 · 成年动物复种间隔与 DOI', '2024年WSAVA犬猫疫苗接种指南 · 疫苗剂量', '2024年WSAVA犬猫疫苗接种指南 · 原则', '2024年WSAVA犬猫疫苗接种指南 · 表 3 收容所中犬的核心疫苗', '2024年WSAVA犬猫疫苗接种指南 · 收容所操作要点与非核心疫苗', '2024年WSAVA犬猫疫苗接种指南 · 定义与报告要求', '2024年WSAVA犬猫疫苗接种指南 · 疫苗缺乏效力与管理不善', '2024年WSAVA犬猫疫苗接种指南 · 猫注射部位肉瘤（FISS）与注射解剖部位', '2024年WSAVA犬猫疫苗接种指南 · 事件处理与相关 FAQ', '2024年WSAVA犬猫疫苗接种指南 · 特殊情形', '2024年WSAVA犬猫疫苗接种指南 · 免疫抑制、患病与感染逆转录病毒的动物', '2024年WSAVA犬猫疫苗接种指南 · 同时接种与操作注意', '2024年WSAVA犬猫疫苗接种指南 · 当代与新兴主题', '2024年WSAVA犬猫疫苗接种指南 · "同一个健康"（One Health）与人畜共患病', '2024年WSAVA犬猫疫苗接种指南 · 健康检查与就诊体验', '2024年WSAVA犬猫疫苗接种指南 · 执行摘要要点（英文执行摘要 4 页浓缩）', '犬猫疫苗接种指南 2015 版 · 文件框架与执行摘要', '犬猫疫苗接种指南 2015 版 · 执行摘要（Executive Summary）核心定义', '犬猫疫苗接种指南 2015 版 · 引言：2015 版相对 2010 版的具体变化', '犬猫疫苗接种指南 2015 版 · 指南的目的：与产品说明书的关系', '犬猫疫苗接种指南 2015 版 · 小动物疫苗学当前议题', '犬猫疫苗接种指南 2015 版 · 疫苗类型', '犬猫疫苗接种指南 2015 版 · 幼犬基础免疫与 6 或 12 月龄加强', '犬猫疫苗接种指南 2015 版 · 成年犬再免疫', '犬猫疫苗接种指南 2015 版 · 血清学检测监测犬疫苗免疫（分块 004）', '犬猫疫苗接种指南 2015 版 · 血清学测定核心疫苗 DOI', '犬猫疫苗接种指南 2015 版 · 被动免疫（分块 004–005）', '犬猫疫苗接种指南 2015 版 · 犬用新疫苗进展（分块 005）', '犬猫疫苗接种指南 2015 版 · 猫疫苗接种指南', '犬猫疫苗接种指南 2015 版 · 基本免疫程序与核心疫苗特点', '犬猫疫苗接种指南 2015 版 · 幼猫基础免疫与 6 或 12 月龄加强', '犬猫疫苗接种指南 2015 版 · 成年猫再免', '犬猫疫苗接种指南 2015 版 · 猫的接种部位与猫注射部位肉瘤（feline injection site sar', '犬猫疫苗接种指南 2015 版 · 猫血清学检测（分块 007）', '犬猫疫苗接种指南 2015 版 · 救助所环境的犬猫免疫', '犬猫疫苗接种指南 2015 版 · 超越疫苗的全面个体化照护', '犬猫疫苗接种指南 2015 版 · 病历记录与不良反应（分块 007–010）', '犬猫疫苗接种指南 2015 版 · 指南总表（表 1–7）', '犬猫疫苗接种指南 2015 版 · 表 1. WSAVA 犬疫苗接种指南（第 1 部分）', '犬猫疫苗接种指南 2015 版 · 表 1. WSAVA 犬疫苗接种指南（第 1 部分） (2)', '犬猫疫苗接种指南 2015 版 · 表 1. WSAVA 犬疫苗接种指南（第 1 部分） (3)', '犬猫疫苗接种指南 2015 版 · 表 1.（续，第 2 部分：E18）', '犬猫疫苗接种指南 2015 版 · 表 2. WSAVA 救助所环境犬免疫指南（E19）', '犬猫疫苗接种指南 2015 版 · 表 3. WSAVA 猫疫苗接种指南（E20）', '犬猫疫苗接种指南 2015 版 · 表 3.（续，E21）', '犬猫疫苗接种指南 2015 版 · 表 4. WSAVA 救助所环境猫免疫指南（E22）', '犬猫疫苗接种指南 2015 版 · 表 5. 6–9 周龄首诊幼犬/幼猫每 3 或 4 周一次的核心免疫程序（E22', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · > 来源机构：WSAVA 疫苗指导小组（Vaccination Guidelin', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 七张数据表横向对照', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 犬细小病毒 2 型（CPV-2）疫苗说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 犬腺病毒（CAV）-2 疫苗说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 犬瘟热病毒（CDV）疫苗说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 猫细小病毒（FPV）疫苗说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 猫疱疹病毒（FHV）-1 疫苗说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 猫杯状病毒（FCV）疫苗说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 狂犬病（rabies）疫苗说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 本范围附录一的完整性说明', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO (2)', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO (3)', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO (4)', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI (2)', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI (3)', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI (4)', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与血清学检测使用相关（QUESTIONS ABOUT THE USE OF SE', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与年度体检相关（QUESTIONS ABOUT THE ANNUAL HEALT', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 第 1 段', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 第 2 段', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫力和 IgG 记忆相对短效（≤1 年）不同，经皮肤试验测定的速发型超敏记忆', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 第 3 段', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 时间表、剂量与阈值速查（照录）', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 禁忌症与注意事项汇总（可检索条目）', 'WSAVA 犬猫疫苗接种指南 2015 版 下 · 术语对照（本稿用词与官方 2015 中文译本对照）', '拉美地区犬猫疫苗建议-上 · > 本稿覆盖切片 001-010；011-019 见 05-。', '拉美地区犬猫疫苗建议-上 · 拉美现状：宠物、职业与教育');
DELETE FROM knowledge_docs WHERE title IN ('拉美地区犬猫疫苗建议-上 · 犬猫疫苗可预防传染病的流行病学（表 1、表 2）', '拉美地区犬猫疫苗建议-上 · 犬传染病文献要点', '拉美地区犬猫疫苗建议-上 · 猫传染病文献要点', '拉美地区犬猫疫苗建议-上 · 拉美疫苗与疫苗实践现状', '拉美地区犬猫疫苗建议-上 · VGG 建议：教育、研究与疫苗供应', '拉美地区犬猫疫苗建议-上 · 核心/非核心定义与犬疫苗理想方案（表 4）', '拉美地区犬猫疫苗建议-上 · 犬疫苗务实方案（表 5）、利什曼与狂犬', '拉美地区犬猫疫苗建议-上 · 犬狂犬病', '拉美地区犬猫疫苗建议-上 · 常见问题精选（切片 001-010）', '拉美地区犬猫疫苗建议 · 第 1 段', '拉美地区犬猫疫苗建议 · 分块 011–019 内容与结构总览', '拉美地区犬猫疫苗建议 · 疫苗产品与品牌相关问题（FAQ，续分块 010）', '拉美地区犬猫疫苗建议 · 体重与疫苗抗原量：小犬应少打吗？', '拉美地区犬猫疫苗建议 · 周龄能否给将满 6 周出售的幼犬接种核心疫苗？', '拉美地区犬猫疫苗建议 · 幼犬应接种几剂核心疫苗？', '拉美地区犬猫疫苗建议 · 品种与 MDA 传递', '拉美地区犬猫疫苗建议 · 易感窗口与幼犬社交化', '拉美地区犬猫疫苗建议 · 犬患过免疫抑制性疾病（犬瘟热、埃希希体病）康复后多久可接种？', '拉美地区犬猫疫苗建议 · 流浪犬捡回家中、家中幼犬核心免疫未完成，该犬数日后出现 CDV 感染征象，幼犬应', '拉美地区犬猫疫苗建议 · 手术后要等多久才能接种？', '拉美地区犬猫疫苗建议 · 年度 Leptospira 加强针错过超过 3 个月，补 1 剂还是 2 剂？', '拉美地区犬猫疫苗建议 · 无既往免疫史的成年犬或猫应接种几剂？', '拉美地区犬猫疫苗建议 · FeLV 检测阳性的猫还要接种（FeLV）吗？', '拉美地区犬猫疫苗建议 · 疫苗可以刚从冰箱取出即注射，还是需要先回温？', '拉美地区犬猫疫苗建议 · 兽医自身应该接种狂犬病疫苗吗？还有其他需接种的职业病吗？', '拉美地区犬猫疫苗建议 · 动物既往有接种后过敏史，还能再接种吗？', '拉美地区犬猫疫苗建议 · 佐剂疫苗导致 FISS 的证据是什么？', '拉美地区犬猫疫苗建议 · 有检测猫抗体滴度的试剂盒吗？', '拉美地区犬猫疫苗建议 · 问卷结构与条目（照录）', '拉美地区犬猫疫苗建议 · 问卷结构与条目（照录） (2)', '拉美地区犬猫疫苗建议 · 问卷结构与条目（照录） (3)', '拉美地区犬猫疫苗建议 · 拉美执业要点速查（本部分 FAQ 数值汇总）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 文献信息与目次（分块 001–002）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 标题与作者', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 原文目次（含页码，照录）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 执行摘要（分块 002）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 执行摘要（分块 002） (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 执行摘要（分块 002） (3)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 引言：与其他指南的关系（分块 002–003）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗三类定义的修订版（分块 003）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 本版相对 2016 版的具体变更（分块 003）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 目的与全球异质性', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 方法学格式', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗作为综合预防保健的一部分（分块 003–004）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 医疗记录与接种证书（分块 004）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 灭活（ killed）疫苗（Inactivated vaccines）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 载体疫苗（Vectored vaccines）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 关键时间参数与「易感窗口」定义', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 血清学检测辅助疫苗接种相关决策（分块 005）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 抗体存在与缺失的解释', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 试剂盒性能与局限', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 对执业者的建议', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 图 2 图例（原文抽取严重串行，照录并标注）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 免疫覆盖率与群免', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗犹豫（vaccination hesitancy）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 覆盖率数据（照录数值）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 「疫苗负荷」实例：澳大利亚 FeLV 疫苗', '2024年WSAVA犬猫疫苗接种指南·英文全典 · Table 1「Vaccines for pet dogs (non-shelt', '2024年WSAVA犬猫疫苗接种指南·英文全典 · Table 1「Vaccines for pet dogs (non-shelt (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · Table 1「Vaccines for pet dogs (non-shelt (3)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 原文中术语与缩写（本切片内出现的）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 本切片的内容缺失与不可复原之处（照实记录）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 第 1 段', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 本稿范围、起点与切片残留说明', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 本稿范围、起点与切片残留说明 (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 本稿范围、起点与切片残留说明 (3)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·犬核心疫苗末行与首个非核心行〔切片 007〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 犬副流感病毒（CPiV）行——非核心疫苗栏起始', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·宠物犬非核心疫苗逐条〔切片 007〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·宠物犬非核心疫苗逐条〔切片 007〕 (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·宠物犬非核心疫苗逐条〔切片 007〕 (3)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 正文·犬：幼犬系列收尾、20 周龄血清学检测与 26+ 周龄复种〔切片 007〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · VGG 的持续立场与早期社会化', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·不推荐用于宠物犬的疫苗〔切片 007–008〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 免疫史不明或不完整的成年犬', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 犬钩端螺旋体病疫苗何时列为核心', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 总览', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 呼吸道病原非核心疫苗', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 犬利什曼病（CanL）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 伯氏疏螺旋体（莱姆病）疫苗', '2024年WSAVA犬猫疫苗接种指南·英文全典 · CCoV 与 Giardia 的补充理由', '2024年WSAVA犬猫疫苗接种指南·英文全典 · FPV+FCV+FHV：注射、活减毒', '2024年WSAVA犬猫疫苗接种指南·英文全典 · FPV+FCV+FHV：注射、灭活', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 狂犬病：重组与灭活〔切片 009〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫非核心疫苗：FIV〔切片 009〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 三大猫核心成分的保护并不等同', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 成年猫的复种频率、二价疫苗与灭活疫苗持久性〔切片 010〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · FeLV 在本版被定为部分地区核心〔切片 010〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 2（续）·猫非核心疫苗与不推荐疫苗〔切片 010〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 正文·猫：FeLV 产品谱、免疫史不明成猫与非核心疫苗〔切片 010〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫非核心疫苗综述（C. felis、B. bronchiseptica、FIV）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 多联产品可得性与免疫抑制猫', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 引用《收容所兽医协会照护标准指南》', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所病原学与入院抗体本底', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所犬猫核心疫苗总述', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 3·收容所犬核心疫苗〔切片 011〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 4·收容所猫核心疫苗〔切片 011〕', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所/庇护所犬猫疫苗接种（承接上半部分的表 4 尾行与正文）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所黏膜疫苗与肠外疫苗要点', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所犬猫的非核心疫苗', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗接种后不良事件（adverse events following vacci', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗剂量与体型、品种风险', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫注射部位肉瘤（FISS）与注射部位', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫注射部位肉瘤（FISS）与注射部位 (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 常见问题（frequently asked questions, FAQs）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（一）：保护持续时间、同接多苗、首末剂龄', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（二）：钩端螺旋体病疫苗专问', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（三）：糖皮质激素、强免疫抑制与抗肿瘤治疗', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（四）：感染 FeLV / FIV 的猫', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（五）：接种频率、年龄下限、操作细节', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（六）：初乳、老年、未免疫成年犬猫方案', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（七）：CAV-2、繁育、犬流感、野生/外来、顺势疗法', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于接种后不良事件的问答', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于接种后不良事件的问答 (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于接种后不良事件的问答 (3)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于使用血清学/"滴度"检测判断动物是否受保护的问答', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于使用血清学/"滴度"检测判断动物是否受保护的问答 (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于使用血清学/"滴度"检测判断动物是否受保护的问答 (3)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 致谢、作者贡献与利益冲突', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 缩写对照（Abbreviations，英文原版列表照录）', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 缩写对照（Abbreviations，英文原版列表照录） (2)', '2024年WSAVA犬猫疫苗接种指南·英文全典 · 缩写对照（Abbreviations，英文原版列表照录） (3)', 'WSAVA 犬猫疫苗速查表 · 宠物犬（非收容所）疫苗速查表', 'WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET DOGS）', 'WSAVA 犬猫疫苗速查表 · 非核心疫苗（NON-CORE VACCINES FOR PET DOGS）', 'WSAVA 犬猫疫苗速查表 · 表头附注与图例（原文措辞照录）', 'WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET CATS）', 'WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET CATS） (2)', 'WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET CATS） (3)', 'WSAVA 犬猫疫苗速查表 · 非核心疫苗（NON-CORE VACCINES FOR PET CATS）', 'WSAVA 犬猫疫苗速查表 · 表头附注与图例（原文措辞照录） (2)', 'WSAVA 犬猫疫苗速查表 · 收容所犬核心疫苗（CORE VACCINES FOR SHELTER DOGS）', 'WSAVA 犬猫疫苗速查表 · 收容所猫核心疫苗（CORE VACCINES FOR SHELTER CATS）', 'WSAVA 犬猫疫苗速查表 · 三表通用缩写与术语（均照抽取稿原文展开）', 'WSAVA 犬猫营养指南知识库 — 总索引 · 第 1 段', 'WSAVA 犬猫营养指南知识库 — 总索引 · 知识库文档清单', 'WSAVA 犬猫营养指南知识库 — 总索引 · 核心概念速查', 'WSAVA 犬猫营养指南知识库 — 总索引 · 场景 3：住院营养支持', 'WSAVA 犬猫营养指南知识库 — 总索引 · 原始PDF文件来源', 'WSAVA 犬猫营养指南知识库 — 总索引 · 版权说明', 'WSAVA 营养评估指南概述 · 第 1 段', 'WSAVA 营养评估指南概述 · 营养——第五大生命体征', 'WSAVA 营养评估指南概述 · 自我评估清单', 'WSAVA 犬猫每日能量需求参考表 · 第 1 段', 'WSAVA 犬猫每日能量需求参考表 · 健康成年犬每日热量需求表', 'WSAVA 犬猫每日能量需求参考表 · 住院动物静息能量需求（RER）速查表', 'WSAVA 犬猫体况评分 · 第 1 段', 'WSAVA 犬猫体况评分 · 猫体况评分标准（9分制）', 'WSAVA 犬猫体况评分 · 犬体况评分标准（9分制）', 'WSAVA 犬猫肌肉状况评分 · 第 1 段', 'WSAVA 犬猫肌肉状况评分 · 监测', 'WSAVA 饮食历史表与营养评估清单 · 第 1 段', 'WSAVA 饮食历史表与营养评估清单 · 筛查评估记录', 'WSAVA 饮食历史表与营养评估清单 · 建议与监测', 'WSAVA 住院犬猫喂养指南 · 第 1 段', 'WSAVA 住院犬猫喂养指南 · 当日评估', 'WSAVA 宠物食品选择指南 · 第 1 段', 'WSAVA 宠物食品选择指南 · 每克或每份食物含有多少热量？', 'WSAVA 宠物生肉基饮食 · 第 1 段', 'WSAVA 宠物生肉基饮食 · 需要关注的临床信号', 'WSAVA 犬猫零食喂养指南 · 第 1 段', 'WSAVA 犬猫零食喂养指南 · 猫的不安全零食', 'WSAVA 犬猫零食喂养指南 · 犬常喂食物/咀嚼物热量', 'WSAVA 互联网营养信息评估指南 · 第 1 段', 'WSAVA 互联网营养信息评估指南 · 营养指南');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('WSAVA 全球指南知识库 — 总索引 · 第 1 段', 'WSAVA 全球指南知识库 — 总索引

> 本知识库由爬虫抓取 WSAVA（World Small Animal Veterinary Association）Global Guidelines 栏目整理，**不含 Global Nutrition Guidelines**（营养部分已单独建档于 `docs/wsava营养知识`）。

- 抓取日期：2026-10-19
- 板块：11 个 —— 动物福利指南、全球牙科指南、胃肠病学指南、遗传病委员会立场文件、犬猫肝病组织学诊断标准、微芯片识别指南、全球疼痛管理指南、兽医职业健康指南、肾病数据标准化指南、犬猫生殖控制指南、犬猫疫苗接种指南
- 体量：原始 PDF 46 份　原文抽取 46 份（约 3,458,580 字符）　中文整理稿 47 份
- 收录策略：只收英文版与中文版，同一指南的小语种译本跳过（见各板块 `00-板块说明.md` 的未收录清单）
- 已知缺口：2 份 PDF 为扫描图片版、正文未能抽取，需 OCR 补全（下表标「是」者）

目录约定

每个板块一个文件夹：`00-板块说明.md` 是板块页面原文与资源清单，`raw_extracts/` 是 PDF 全文抽取（带 YAML frontmatter，可作 RAG 语料），`pdf/` 是原始 PDF 存档，其余 `NN-*.md` 是中文整理稿。根目录下的 `_cache/`（板块页面 JSON、下载与分块清单）与 `_crawl_report.md`（抓取告警、需 OCR 清单）是抓取过程产物，**不要入库**；`docs/tools/chunks/` 是切块中间产物，同样不要入库。

板块与文档清单', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · animal-welfare-guidelines 动物福利指南', '01 animal-welfare-guidelines　动物福利指南

- 板块页面：[00-板块说明.md](01-animal-welfare-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/animal-welfare-guidelines/>　页面更新 2024-05-02
- 规模：原始 PDF 2 份　原文抽取 2 份　中文整理稿 2 份

| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-WSAVA动物福利指南2018要点](01-animal-welfare-guidelines/01-WSAVA%E5%8A%A8%E7%89%A9%E7%A6%8F%E5%88%A9%E6%8C%87%E5%8D%972018%E8%A6%81%E7%82%B9.md) | WSAVA 动物福利指南2018要点 | `WSAVA-Animal-Welfare-Guidelines-2018.md` |
| [02-WSAVA动物福利宪章2020](01-animal-welfare-guidelines/02-WSAVA%E5%8A%A8%E7%89%A9%E7%A6%8F%E5%88%A9%E5%AE%AA%E7%AB%A02020.md) | WSAVA 动物福利宪章（2020） | `WSAVA_Animal_Welfare_Charter_Feb-2020.md` |

<details><summary>原文抽取明细</summary>

| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [WSAVA-Animal-Welfare-Guidelines-2018](01-animal-welfare-guidelines/raw_extracts/WSAVA-Animal-Welfare-Guidelines-2018.md) | en | 80 | 213,353 |  |
| [WSAVA_Animal_Welfare_Charter_Feb-2020](01-animal-welfare-guidelines/raw_extracts/WSAVA_Animal_Welfare_Charter_Feb-2020.md) | en | 3 | 2,816 |  |

</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · dental-guidelines 全球牙科指南', '02 dental-guidelines　全球牙科指南

- 板块页面：[00-板块说明.md](02-dental-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/dental-guidelines/>　页面更新 2026-09-22
- 规模：原始 PDF 3 份　原文抽取 3 份　中文整理稿 3 份

| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-WSAVA全球牙科指南要点](02-dental-guidelines/01-WSAVA%E5%85%A8%E7%90%83%E7%89%99%E7%A7%91%E6%8C%87%E5%8D%97%E8%A6%81%E7%82%B9.md) | WSAVA全球牙科指南要点 | `WSAVA-Global-Dental-Guidelines-JSAPMandarin.md` |
| [02-口腔肿瘤与病变识别](02-dental-guidelines/02-%E5%8F%A3%E8%85%94%E8%82%BF%E7%98%A4%E4%B8%8E%E7%97%85%E5%8F%98%E8%AF%86%E5%88%AB.md) | 口腔肿瘤与病变识别 | `GDC-Oral-Cancer.md`、`WSAVA-Global-Dental-Guidelines-JSAPMandarin.md` |
| [03-犬猫刷牙工具包](02-dental-guidelines/03-%E7%8A%AC%E7%8C%AB%E5%88%B7%E7%89%99%E5%B7%A5%E5%85%B7%E5%8C%85.md) | 犬猫刷牙工具包 | `GDC-Toothbrushing-Toolkit-1.md`、`WSAVA-Global-Dental-Guidelines-JSAPMandarin.md` |

<details><summary>原文抽取明细</summary>

| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [GDC-Oral-Cancer](02-dental-guidelines/raw_extracts/GDC-Oral-Cancer.md) | en | 2 | 2,432 |  |
| [GDC-Toothbrushing-Toolkit-1](02-dental-guidelines/raw_extracts/GDC-Toothbrushing-Toolkit-1.md) | en | 2 | 5,397 |  |
| [WSAVA-Global-Dental-Guidelines-JSAPMandarin](02-dental-guidelines/raw_extracts/WSAVA-Global-Dental-Guidelines-JSAPMandarin.md) | zh | 127 | 243,449 |  |

</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · gastrointestinal-guidelines 胃肠病学指南', '03 gastrointestinal-guidelines　胃肠病学指南

- 板块页面：[00-板块说明.md](03-gastrointestinal-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/gastrointestinal-guidelines/>　页面更新 2024-05-02
- 规模：原始 PDF 2 份　原文抽取 2 份　中文整理稿 1 份

| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-犬猫内镜检查报告表](03-gastrointestinal-guidelines/01-%E7%8A%AC%E7%8C%AB%E5%86%85%E9%95%9C%E6%A3%80%E6%9F%A5%E6%8A%A5%E5%91%8A%E8%A1%A8.md) | 犬猫内镜检查报告表（上消化道／下消化道） | `Final_Upper_Endoscopy_Report_Form.md`、`Final_Lower_Endoscopy_Report_Form.md` |

<details><summary>原文抽取明细</summary>

| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [Final_Lower_Endoscopy_Report_Form](03-gastrointestinal-guidelines/raw_extracts/Final_Lower_Endoscopy_Report_Form.md) | en | 2 | 4,054 |  |
| [Final_Upper_Endoscopy_Report_Form](03-gastrointestinal-guidelines/raw_extracts/Final_Upper_Endoscopy_Report_Form.md) | en | 2 | 3,848 |  |

</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · hereditary-disease 遗传病委员会立场文件', '04 hereditary-disease　遗传病委员会立场文件

- 板块页面：[00-板块说明.md](04-hereditary-disease/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/hereditary-disease/>　页面更新 2026-01-07
- 规模：原始 PDF 1 份　原文抽取 1 份　中文整理稿 1 份

| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-遗传病委员会立场文件](04-hereditary-disease/01-%E9%81%97%E4%BC%A0%E7%97%85%E5%A7%94%E5%91%98%E4%BC%9A%E7%AB%8B%E5%9C%BA%E6%96%87%E4%BB%B6.md) | WSAVA 遗传病委员会立场文件：健康意识育种与基因检测的作用 | `WSAVA-Hereditary-Disease-Committee-Position-Paper-HDC-Edited.md` |

<details><summary>原文抽取明细</summary>

| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [WSAVA-Hereditary-Disease-Committee-Position-Paper-HDC-Edited](04-hereditary-disease/raw_extracts/WSAVA-Hereditary-Disease-Committee-Position-Paper-HDC-Edited.md) | en | 2 | 4,509 |  |

</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · liver-disease-guidelines 犬猫肝病组织学诊断标准', '05 liver-disease-guidelines　犬猫肝病组织学诊断标准

- 板块页面：[00-板块说明.md](05-liver-disease-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/liver-disease-guidelines/>　页面更新 2024-05-02
- 规模：原始 PDF 0 份　原文抽取 0 份　中文整理稿 1 份

| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-犬猫肝病临床与组织学诊断标准](05-liver-disease-guidelines/01-%E7%8A%AC%E7%8C%AB%E8%82%9D%E7%97%85%E4%B8%B4%E5%BA%8A%E4%B8%8E%E7%BB%84%E7%BB%87%E5%AD%A6%E8%AF%8A%E6%96%AD%E6%A0%87%E5%87%86.md) | 犬猫肝病临床与组织学诊断标准（肝脏标准化项目） | `00-板块说明.md` |

06 microchip-identification-guidelines　微芯片识别指南

- 板块页面：[00-板块说明.md](06-microchip-identification-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/microchip-identification-guidelines/>　页面更新 2024-03-26
- 规模：原始 PDF 0 份　原文抽取 0 份　中文整理稿 1 份

| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-微芯片识别与应用指南](06-microchip-identification-guidelines/01-%E5%BE%AE%E8%8A%AF%E7%89%87%E8%AF%86%E5%88%AB%E4%B8%8E%E5%BA%94%E7%94%A8%E6%8C%87%E5%8D%97.md) | WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准） | `00-板块说明.md` |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · pain-guidelines 全球疼痛管理指南', '07 pain-guidelines　全球疼痛管理指南

- 板块页面：[00-板块说明.md](07-pain-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/pain-guidelines/>　页面更新 2025-05-06
- 规模：原始 PDF 15 份　原文抽取 15 份　中文整理稿 16 份', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (2)', '| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-疼痛全球指南2022-概述与评估](07-pain-guidelines/01-%E7%96%BC%E7%97%9B%E5%85%A8%E7%90%83%E6%8C%87%E5%8D%972022-%E6%A6%82%E8%BF%B0%E4%B8%8E%E8%AF%84%E4%BC%B0.md) | 2022 WSAVA 疼痛全球指南——概述与评估（法语译本 001-014 块） | `2022-WSAVA-guidelines-for-the-recognition_final.md` |
| [02-剖腹产疼痛管理](07-pain-guidelines/02-%E5%89%96%E8%85%B9%E4%BA%A7%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 猫/犬剖腹产疼痛与麻醉管理 | `Caesarean-section.md` |
| [03-癌性疼痛管理](07-pain-guidelines/03-%E7%99%8C%E6%80%A7%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 癌性疼痛管理 | `Cancer-Pain.md` |
| [04-犬去势与卵巢子宫切除疼痛管理](07-pain-guidelines/04-%E7%8A%AC%E5%8E%BB%E5%8A%BF%E4%B8%8E%E5%8D%B5%E5%B7%A2%E5%AD%90%E5%AE%AB%E5%88%87%E9%99%A4%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 犬去势与卵巢子宫切除/卵巢切除疼痛管理 | `Castration-and-OVH-Dogs.md` |
| [05-猫去势与卵巢子宫切除疼痛管理](07-pain-guidelines/05-%E7%8C%AB%E5%8E%BB%E5%8A%BF%E4%B8%8E%E5%8D%B5%E5%B7%A2%E5%AD%90%E5%AE%AB%E5%88%87%E9%99%A4%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 猫去势与卵巢子宫切除/卵巢切除疼痛管理 | `Castration-and-OVH-cats.md` |
| [06-退行性关节病疼痛管理](07-pain-guidelines/06-%E9%80%80%E8%A1%8C%E6%80%A7%E5%85%B3%E8%8A%82%E7%97%85%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 退行性关节病（DJD）疼痛管理 | `Degenerative-joint-disease.md` |
| [07-急诊与重症疼痛管理](07-pain-guidelines/07-%E6%80%A5%E8%AF%8A%E4%B8%8E%E9%87%8D%E7%97%87%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 急诊与重症（Emergency and critical care）疼痛管理 | `Emergency-and-critical-care.md` |
| [08-内科疾病疼痛管理](07-pain-guidelines/08-%E5%86%85%E7%A7%91%E7%96%BE%E7%97%85%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 内科疾病疼痛（Medical pain）管理 | `Medical-Pain.md` |
| [09-神经病理性疼痛处理方案](07-pain-guidelines/09-%E7%A5%9E%E7%BB%8F%E7%97%85%E7%90%86%E6%80%A7%E7%96%BC%E7%97%9B%E5%A4%84%E7%90%86%E6%96%B9%E6%A1%88.md) | 神经病理性疼痛处理方案 | `Neuropathic-pain-protocol.md` |
| [10-骨科手术疼痛管理](07-pain-guidelines/10-%E9%AA%A8%E7%A7%91%E6%89%8B%E6%9C%AF%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 骨科手术疼痛管理 | `Orthopedic-surgery.md` |', '', '', '', '指南索引,目录约定,板块与文档清单', 'caution', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (3)', '| [11-幼龄动物疼痛管理](07-pain-guidelines/11-%E5%B9%BC%E9%BE%84%E5%8A%A8%E7%89%A9%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 幼龄动物（儿科）疼痛管理 | `Pediatric-Pain.md` |
| [12-妊娠与哺乳动物疼痛管理](07-pain-guidelines/12-%E5%A6%8A%E5%A8%A0%E4%B8%8E%E5%93%BA%E4%B9%B3%E5%8A%A8%E7%89%A9%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 妊娠与哺乳动物疼痛管理 | `Pregnant-or-lactating-patients.md` |
| [13-软组织手术疼痛管理](07-pain-guidelines/13-%E8%BD%AF%E7%BB%84%E7%BB%87%E6%89%8B%E6%9C%AF%E7%96%BC%E7%97%9B%E7%AE%A1%E7%90%86.md) | 软组织手术疼痛管理 | `Soft-tissue-Surgery.md` |
| [14-疼痛等级视觉自评图](07-pain-guidelines/14-%E7%96%BC%E7%97%9B%E7%AD%89%E7%BA%A7%E8%A7%86%E8%A7%89%E8%87%AA%E8%AF%84%E5%9B%BE.md) | 感知疼痛等级视觉自评图（各病症感知疼痛等级） | `WSAVA-Global-Pain-Council-Perceived-levels-of-pain.md` |
| [15-疼痛全球指南2022-治疗与药物管理](07-pain-guidelines/15-%E7%96%BC%E7%97%9B%E5%85%A8%E7%90%83%E6%8C%87%E5%8D%972022-%E6%B2%BB%E7%96%97%E4%B8%8E%E8%8D%AF%E7%89%A9%E7%AE%A1%E7%90%86.md) | 2022 WSAVA 疼痛全球指南——治疗与药物管理（法语译本切片 015-029） | `2022-WSAVA-guidelines-for-the-recognition_final.md` |
| [16-疼痛全球指南2022-下半部分](07-pain-guidelines/16-%E7%96%BC%E7%97%9B%E5%85%A8%E7%90%83%E6%8C%87%E5%8D%972022-%E4%B8%8B%E5%8D%8A%E9%83%A8%E5%88%86.md) | 2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献（030-043） | `2022-WSAVA-guidelines-for-the-recognition_final.md` |', '', 'young', '', '指南索引,目录约定,板块与文档清单', 'caution', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (4)', '<details><summary>原文抽取明细</summary>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (5)', '| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [2022-WSAVA-guidelines-for-the-recognition_final](07-pain-guidelines/raw_extracts/2022-WSAVA-guidelines-for-the-recognition_final.md) | fr | 78 | 484,934 |  |
| [Caesarean-section](07-pain-guidelines/raw_extracts/Caesarean-section.md) | en | 2 | 8,069 |  |
| [Cancer-Pain](07-pain-guidelines/raw_extracts/Cancer-Pain.md) | en | 1 | 4,658 |  |
| [Castration-and-OVH-cats](07-pain-guidelines/raw_extracts/Castration-and-OVH-cats.md) | en | 2 | 6,359 |  |
| [Castration-and-OVH-Dogs](07-pain-guidelines/raw_extracts/Castration-and-OVH-Dogs.md) | en | 2 | 5,664 |  |
| [Degenerative-joint-disease](07-pain-guidelines/raw_extracts/Degenerative-joint-disease.md) | en | 1 | 4,213 |  |
| [Emergency-and-critical-care](07-pain-guidelines/raw_extracts/Emergency-and-critical-care.md) | en | 1 | 4,355 |  |
| [Medical-Pain](07-pain-guidelines/raw_extracts/Medical-Pain.md) | en | 2 | 4,792 |  |
| [Neuropathic-pain-protocol](07-pain-guidelines/raw_extracts/Neuropathic-pain-protocol.md) | en | 1 | 4,489 |  |
| [Orthopedic-surgery](07-pain-guidelines/raw_extracts/Orthopedic-surgery.md) | en | 2 | 8,781 |  |
| [Pediatric-Pain](07-pain-guidelines/raw_extracts/Pediatric-Pain.md) | en | 2 | 7,373 |  |
| [Pregnant-or-lactating-patients](07-pain-guidelines/raw_extracts/Pregnant-or-lactating-patients.md) | en | 1 | 6,663 |  |
| [Reduced_Chinese_Simplified_2022年WSAVA疼痛识别、评估和治疗指南](07-pain-guidelines/raw_extracts/Reduced_Chinese_Simplified_2022%E5%B9%B4WSAVA%E7%96%BC%E7%97%9B%E8%AF%86%E5%88%AB%E3%80%81%E8%AF%84%E4%BC%B0%E5%92%8C%E6%B2%BB%E7%96%97%E6%8C%87%E5%8D%97.md) | zh | 42 | 1,617 | 是 |
| [Soft-tissue-Surgery](07-pain-guidelines/raw_extracts/Soft-tissue-Surgery.md) | en | 2 | 6,973 |  |
| [WSAVA-Global-Pain-Council-Perceived-levels-of-pain](07-pain-guidelines/raw_extracts/WSAVA-Global-Pain-Council-Perceived-levels-of-pain.md) | en | 1 | 3,864 |  |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · pain-guidelines　全球疼痛管理指南 (6)', '</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines 兽医职业健康指', '08 professional-wellness-guidelines　兽医职业健康指南

- 板块页面：[00-板块说明.md](08-professional-wellness-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/professional-wellness-guidelines/>　页面更新 2025-05-15
- 规模：原始 PDF 10 份　原文抽取 10 份　中文整理稿 8 份', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (2)', '| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-WSAVA兽医职业健康指南](08-professional-wellness-guidelines/01-WSAVA%E5%85%BD%E5%8C%BB%E8%81%8C%E4%B8%9A%E5%81%A5%E5%BA%B7%E6%8C%87%E5%8D%97.md) | WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿 | `WSAVA-professional-wellness-guidelines（Chinese）.md`、`Professional_Wellness_Guidelines-FINAL.md` |
| [02-福祉提示与疫情期压力管理](08-professional-wellness-guidelines/02-%E7%A6%8F%E7%A5%89%E6%8F%90%E7%A4%BA%E4%B8%8E%E7%96%AB%E6%83%85%E6%9C%9F%E5%8E%8B%E5%8A%9B%E7%AE%A1%E7%90%86.md) | WSAVA PWG 福祉提示与疫情期压力管理（Wellbeing Tips & COVID Stress Management）整理稿 | `PWG_Wellbeing_Tips.md`、`Stress-Management-for-Clinicians-during-the-COVID-19-Pandemic_WSAVA-PWG.md` |
| [03-复原力文献综述-JVME](08-professional-wellness-guidelines/03-%E5%A4%8D%E5%8E%9F%E5%8A%9B%E6%96%87%E7%8C%AE%E7%BB%BC%E8%BF%B0-JVME.md) | Finding the Balance：兽医文献中的复原力综述（中文整理稿） | `JVME_Finding-the-Balance-uncovering-resilience-in-veterinary-literature.md` |
| [04-兽医学生复原力与正念自评-JVME](08-professional-wellness-guidelines/04-%E5%85%BD%E5%8C%BB%E5%AD%A6%E7%94%9F%E5%A4%8D%E5%8E%9F%E5%8A%9B%E4%B8%8E%E6%AD%A3%E5%BF%B5%E8%87%AA%E8%AF%84-JVME.md) | 兽医学生的复原力与正念、自悯的预测作用（中文整理稿） | `JVME_Resilience-in-Veterinary-Students-and-the-Predictive-Role-of-Mindfulness-and-Self-Compassion.md` |
| [05-澳洲兽医学生同情疲劳流行率-JVME](08-professional-wellness-guidelines/05-%E6%BE%B3%E6%B4%B2%E5%85%BD%E5%8C%BB%E5%AD%A6%E7%94%9F%E5%90%8C%E6%83%85%E7%96%B2%E5%8A%B3%E6%B5%81%E8%A1%8C%E7%8E%87-JVME.md) | 澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿） | `JVME_The-Prevalence-of-Compassion-Fatigue-among-Veterinary-Students-in-Australia.md` |
| [06-兽医外科医生自杀-VeterinaryRecord](08-professional-wellness-guidelines/06-%E5%85%BD%E5%8C%BB%E5%A4%96%E7%A7%91%E5%8C%BB%E7%94%9F%E8%87%AA%E6%9D%80-VeterinaryRecord.md) | 兽医外科医生自杀：风险升高的可能影响因素结构化综述 | `Veterinary-Record_Veterinary-surgeons-and-suicide.md` |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (3)', '| [07-兽医学生应对策略与求助污名-VeterinaryRecord](08-professional-wellness-guidelines/07-%E5%85%BD%E5%8C%BB%E5%AD%A6%E7%94%9F%E5%BA%94%E5%AF%B9%E7%AD%96%E7%95%A5%E4%B8%8E%E6%B1%82%E5%8A%A9%E6%B1%A1%E5%90%8D-VeterinaryRecord.md) | 兽医学生应对策略与寻求心理帮助污名的横断面分析 | `Veterinary-Record_Cross-sectional-analysis-of-veterinary-student-coping-strategies-and-stigma-in-seeking-psychological-help.md` |
| [08-AVA毕业生导师计划](08-professional-wellness-guidelines/08-AVA%E6%AF%95%E4%B8%9A%E7%94%9F%E5%AF%BC%E5%B8%88%E8%AE%A1%E5%88%92.md) | AVA 毕业生导师计划（AVA Graduate Mentoring Program） | `AVA-Graduate-Mentoring-Program.md` |

<details><summary>原文抽取明细</summary>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (4)', '| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [AVA-Graduate-Mentoring-Program](08-professional-wellness-guidelines/raw_extracts/AVA-Graduate-Mentoring-Program.md) | en | 5 | 10,417 |  |
| [JVME_Finding-the-Balance-uncovering-resilience-in-veterinary-literature](08-professional-wellness-guidelines/raw_extracts/JVME_Finding-the-Balance-uncovering-resilience-in-veterinary-literature.md) | en | 11 | 57,634 |  |
| [JVME_Resilience-in-Veterinary-Students-and-the-Predictive-Role-of-Mindfulness-and-Self-Compassion](08-professional-wellness-guidelines/raw_extracts/JVME_Resilience-in-Veterinary-Students-and-the-Predictive-Role-of-Mindfulness-and-Self-Compassion.md) | en | 10 | 55,451 |  |
| [JVME_The-Prevalence-of-Compassion-Fatigue-among-Veterinary-Students-in-Australia](08-professional-wellness-guidelines/raw_extracts/JVME_The-Prevalence-of-Compassion-Fatigue-among-Veterinary-Students-in-Australia.md) | en | 13 | 70,258 |  |
| [Professional_Wellness_Guidelines-FINAL](08-professional-wellness-guidelines/raw_extracts/Professional_Wellness_Guidelines-FINAL.md) | en | 38 | 14,092 |  |
| [PWG_Wellbeing_Tips](08-professional-wellness-guidelines/raw_extracts/PWG_Wellbeing_Tips.md) | en | 1 | 3,108 |  |
| [Stress-Management-for-Clinicians-during-the-COVID-19-Pandemic_WSAVA-PWG](08-professional-wellness-guidelines/raw_extracts/Stress-Management-for-Clinicians-during-the-COVID-19-Pandemic_WSAVA-PWG.md) | en | 2 | 5,213 |  |
| [Veterinary-Record_Cross-sectional-analysis-of-veterinary-student-coping-strategies-and-stigma-in-seeking-psychological-help](08-professional-wellness-guidelines/raw_extracts/Veterinary-Record_Cross-sectional-analysis-of-veterinary-student-coping-strategies-and-stigma-in-seeking-psychological-help.md) | en | 7 | 44,135 |  |
| [Veterinary-Record_Veterinary-surgeons-and-suicide](08-professional-wellness-guidelines/raw_extracts/Veterinary-Record_Veterinary-surgeons-and-suicide.md) | en | 10 | 88,063 |  |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · professional-wellness-guidelines　兽医职业健康指 (5)', '| [WSAVA-professional-wellness-guidelines（Chinese）](08-professional-wellness-guidelines/raw_extracts/WSAVA-professional-wellness-guidelines%EF%BC%88Chinese%EF%BC%89.md) | zh | 42 | 82,169 |  |

</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · renal-standardization-guidelines 肾病数据标准化', '09 renal-standardization-guidelines　肾病数据标准化指南

- 板块页面：[00-板块说明.md](09-renal-standardization-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/renal-standardization-guidelines/>　页面更新 2024-05-02
- 规模：原始 PDF 1 份　原文抽取 1 份　中文整理稿 1 份

| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-肾病数据标准化项目](09-renal-standardization-guidelines/01-%E8%82%BE%E7%97%85%E6%95%B0%E6%8D%AE%E6%A0%87%E5%87%86%E5%8C%96%E9%A1%B9%E7%9B%AE.md) | WSAVA 肾病数据标准化项目（执行摘要与资料状态） | `00-板块说明.md`、`Renal-Standardization-Brochure.md` |

<details><summary>原文抽取明细</summary>

| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [Renal-Standardization-Brochure](09-renal-standardization-guidelines/raw_extracts/Renal-Standardization-Brochure.md) | en | 2 | 602 | 是 |

</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · reproduction-guidelines 犬猫生殖控制指南', '10 reproduction-guidelines　犬猫生殖控制指南

- 板块页面：[00-板块说明.md](10-reproduction-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/reproduction-guidelines/>　页面更新 2026-03-25
- 规模：原始 PDF 3 份　原文抽取 3 份　中文整理稿 4 份', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · reproduction-guidelines　犬猫生殖控制指南 (2)', '| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-犬猫生殖控制指南2024-第一部分](10-reproduction-guidelines/01-%E7%8A%AC%E7%8C%AB%E7%94%9F%E6%AE%96%E6%8E%A7%E5%88%B6%E6%8C%87%E5%8D%972024-%E7%AC%AC%E4%B8%80%E9%83%A8%E5%88%86.md) | 犬猫生殖控制指南2024-第一部分（中文译本切片001-011） | `（已压缩）附件：《WSAVA犬猫生殖管理指南》（中文版）250422-2-175.md` |
| [02-犬猫生殖控制指南2024-第二部分](10-reproduction-guidelines/02-%E7%8A%AC%E7%8C%AB%E7%94%9F%E6%AE%96%E6%8E%A7%E5%88%B6%E6%8C%87%E5%8D%972024-%E7%AC%AC%E4%BA%8C%E9%83%A8%E5%88%86.md) | 2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）（中文译本切片 012-022） | `（已压缩）附件：《WSAVA犬猫生殖管理指南》（中文版）250422-2-175.md` |
| [03-犬猫生殖控制指南2024-第三部分](10-reproduction-guidelines/03-%E7%8A%AC%E7%8C%AB%E7%94%9F%E6%AE%96%E6%8E%A7%E5%88%B6%E6%8C%87%E5%8D%972024-%E7%AC%AC%E4%B8%89%E9%83%A8%E5%88%86.md) | WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表（023-033） | `（已压缩）附件：《WSAVA犬猫生殖管理指南》（中文版）250422-2-175.md` |
| [04-犬猫生殖控制指南2024-执行摘要](10-reproduction-guidelines/04-%E7%8A%AC%E7%8C%AB%E7%94%9F%E6%AE%96%E6%8E%A7%E5%88%B6%E6%8C%87%E5%8D%972024-%E6%89%A7%E8%A1%8C%E6%91%98%E8%A6%81.md) | 犬猫生殖控制指南2024-执行摘要 | `Executive-Summary.md` |

<details><summary>原文抽取明细</summary>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · reproduction-guidelines　犬猫生殖控制指南 (3)', '| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [Executive-Summary](10-reproduction-guidelines/raw_extracts/Executive-Summary.md) | en | 9 | 28,477 |  |
| [J-of-Small-Animal-Practice-2024-Romagnoli-WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-and-cats](10-reproduction-guidelines/raw_extracts/J-of-Small-Animal-Practice-2024-Romagnoli-WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-and-cats.md) | en | 136 | 691,914 |  |
| [（已压缩）附件：《WSAVA犬猫生殖管理指南》（中文版）250422-2-175](10-reproduction-guidelines/raw_extracts/%EF%BC%88%E5%B7%B2%E5%8E%8B%E7%BC%A9%EF%BC%89%E9%99%84%E4%BB%B6%EF%BC%9A%E3%80%8AWSAVA%E7%8A%AC%E7%8C%AB%E7%94%9F%E6%AE%96%E7%AE%A1%E7%90%86%E6%8C%87%E5%8D%97%E3%80%8B%EF%BC%88%E4%B8%AD%E6%96%87%E7%89%88%EF%BC%89250422-2-175.md) | zh | 174 | 369,286 |  |

</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines 犬猫疫苗接种指南', '11 vaccination-guidelines　犬猫疫苗接种指南

- 板块页面：[00-板块说明.md](11-vaccination-guidelines/00-%E6%9D%BF%E5%9D%97%E8%AF%B4%E6%98%8E.md)　原文 <https://wsava.org/global-guidelines/vaccination-guidelines/>　页面更新 2026-07-29
- 规模：原始 PDF 9 份　原文抽取 9 份　中文整理稿 9 份', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (2)', '| 中文整理稿 | 主题 | 覆盖原文 |
|---|---|---|
| [01-犬猫疫苗接种指南2024](11-vaccination-guidelines/01-%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E6%8E%A5%E7%A7%8D%E6%8C%87%E5%8D%972024.md) | 2024年WSAVA犬猫疫苗接种指南（中文整理稿）（2024 中文译本全部 12 块 + 英文执行摘要） | `Chinese-Ver-2024-Vaccination-Guideline-for-Dogs-Cats.md`、`2024-Guidelines-for-the-Vaccination-of-Dogs-and-Cats.md` |
| [02-犬猫疫苗接种指南2015-上](11-vaccination-guidelines/02-%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E6%8E%A5%E7%A7%8D%E6%8C%87%E5%8D%972015-%E4%B8%8A.md) | 犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7（001-010） | `WSAVA-Vaccination-Guidelines-2015.md` |
| [03-犬猫疫苗接种指南2015-下](11-vaccination-guidelines/03-%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E6%8E%A5%E7%A7%8D%E6%8C%87%E5%8D%972015-%E4%B8%8B.md) | WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）（011-020） | `WSAVA-Vaccination-Guidelines-2015.md` |
| [04-拉美地区犬猫疫苗建议-上](11-vaccination-guidelines/04-%E6%8B%89%E7%BE%8E%E5%9C%B0%E5%8C%BA%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E5%BB%BA%E8%AE%AE-%E4%B8%8A.md) | 拉美地区犬猫疫苗建议-上（英文原文切片 001-010） | `Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners.md` |
| [05-拉美地区犬猫疫苗建议-下](11-vaccination-guidelines/05-%E6%8B%89%E7%BE%8E%E5%9C%B0%E5%8C%BA%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E5%BB%BA%E8%AE%AE-%E4%B8%8B.md) | 拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录（011-019） | `Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners.md` |
| [06-犬猫疫苗接种指南2024-英文全典-一](11-vaccination-guidelines/06-%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E6%8E%A5%E7%A7%8D%E6%8C%87%E5%8D%972024-%E8%8B%B1%E6%96%87%E5%85%A8%E5%85%B8-%E4%B8%80.md) | 2024年WSAVA犬猫疫苗接种指南·英文全典（一）（英文全典切片 001-006） | `WSAVA-Vaccination-guidelines-2024.md` |
| [07-犬猫疫苗接种指南2024-英文全典-二](11-vaccination-guidelines/07-%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E6%8E%A5%E7%A7%8D%E6%8C%87%E5%8D%972024-%E8%8B%B1%E6%96%87%E5%85%A8%E5%85%B8-%E4%BA%8C.md) | 2024年WSAVA犬猫疫苗接种指南·英文全典（二）（英文全典切片 007-011） | `WSAVA-Vaccination-guidelines-2024.md` |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (3)', '| [08-犬猫疫苗接种指南2024-英文全典-三](11-vaccination-guidelines/08-%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E6%8E%A5%E7%A7%8D%E6%8C%87%E5%8D%972024-%E8%8B%B1%E6%96%87%E5%85%A8%E5%85%B8-%E4%B8%89.md) | 2024年WSAVA犬猫疫苗接种指南·英文全典（三）（英文全典切片 012-022） | `WSAVA-Vaccination-guidelines-2024.md` |
| [09-犬猫疫苗速查表三合一](11-vaccination-guidelines/09-%E7%8A%AC%E7%8C%AB%E7%96%AB%E8%8B%97%E9%80%9F%E6%9F%A5%E8%A1%A8%E4%B8%89%E5%90%88%E4%B8%80.md) | WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所） | `Dogs-Vaccination-Table.md`、`Cats-Vaccination-Table.md`、`Shelter-Dogs-and-Cats-Vaccination-Table.md` |

<details><summary>原文抽取明细</summary>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (4)', '| 原文 | 语言 | 页数 | 字符 | 需OCR |
|---|---|---|---|---|
| [2024-Guidelines-for-the-Vaccination-of-Dogs-and-Cats](11-vaccination-guidelines/raw_extracts/2024-Guidelines-for-the-Vaccination-of-Dogs-and-Cats.md) | en | 4 | 8,681 |  |
| [Cats-Vaccination-Table](11-vaccination-guidelines/raw_extracts/Cats-Vaccination-Table.md) | en | 1 | 9,181 |  |
| [Chinese-Ver-2024-Vaccination-Guideline-for-Dogs-Cats](11-vaccination-guidelines/raw_extracts/Chinese-Ver-2024-Vaccination-Guideline-for-Dogs-Cats.md) | zh | 59 | 121,183 |  |
| [Dogs-Vaccination-Table](11-vaccination-guidelines/raw_extracts/Dogs-Vaccination-Table.md) | en | 1 | 9,079 |  |
| [Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners](11-vaccination-guidelines/raw_extracts/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners.md) | en | 35 | 212,299 |  |
| [Shelter-Dogs-and-Cats-Vaccination-Table](11-vaccination-guidelines/raw_extracts/Shelter-Dogs-and-Cats-Vaccination-Table.md) | en | 1 | 3,783 |  |
| [WSAVA-vaccination-guidelines-2015-Chinese](11-vaccination-guidelines/raw_extracts/WSAVA-vaccination-guidelines-2015-Chinese.md) | zh | 45 | 52,921 |  |
| [WSAVA-Vaccination-Guidelines-2015](11-vaccination-guidelines/raw_extracts/WSAVA-Vaccination-Guidelines-2015.md) | en | 45 | 231,983 |  |
| [WSAVA-Vaccination-guidelines-2024](11-vaccination-guidelines/raw_extracts/WSAVA-Vaccination-guidelines-2024.md) | en | 40 | 245,989 |  |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · vaccination-guidelines　犬猫疫苗接种指南 (5)', '</details>', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 核心概念速查', '核心概念速查

> 下表「指南定位」一栏译自各板块页面正文的 Executive Summary（原文见各板块 `00-板块说明.md`），只做导览；具体阈值、剂量、方案一律回到对应整理稿与 `raw_extracts/` 原文。', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 板块与核心概念', '板块与核心概念', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 板块与核心概念 (2)', '| 板块 | 指南定位（页面 Executive Summary 摘译） | 必须记住的核心概念 | 整理稿 |
|---|---|---|---|
| 01 动物福利 | 弥合全球对「福利」认知的差异，帮助兽医团队处理影响福利的伦理与道德问题；指导团队在身体健康诊疗之外，为患者的心理、社会与环境福祉发声 | 福利（welfare）定义、Five Domains 五域模型（Mellor）、NAI 非意外性损伤与虐待识别 SOP、诊所福利承诺条款 | [01](01-animal-welfare-guidelines/01-WSAVA动物福利指南2018要点.md)、[02 宪章](01-animal-welfare-guidelines/02-WSAVA动物福利宪章2020.md) |
| 02 全球牙科 | 口牙疾病是伴侣动物最常见疾病，指南强调兽医牙科重要性并给出最佳实践建议以提升全球诊疗水平 | 牙科分级与牙周探诊记录、刷牙引入流程、口腔肿瘤「三个问题」与 CAA/SCC 鉴别、麻醉（TIVA）与术后镇痛 | [01](02-dental-guidelines/01-WSAVA全球牙科指南要点.md)、[02](02-dental-guidelines/02-口腔肿瘤与病变识别.md)、[03](02-dental-guidelines/03-犬猫刷牙工具包.md) |
| 03 胃肠病学 | 胃肠标准化小组（CGS）为犬猫胃肠道组织病理学评估建立全球标准，使疾病诊断统一、可分期，并支撑对照临床试验 | 上/下消化道内镜报告表结构、6 组病变评分表（Normal 0 / Mild 1 / Moderate 2 / Severe 3）、活检取材与判读项 | [01](03-gastrointestinal-guidelines/01-犬猫内镜检查报告表.md) |
| 04 遗传病 | 遗传病委员会教育并鼓励兽医、团队与繁育者采用「有健康意识的繁育」，确保基因检测与遗传咨询被充分利用以控制遗传病与遗传倾向 | 健康意识繁育、基因检测实验室资质、遗传咨询、品种/疾病检测数据库（PENNGEN、OFA 等外链） | [01](04-hereditary-disease/01-遗传病委员会立场文件.md) |
| 05 肝病 | 肝标准化项目为犬猫肝病组织学评估建立全球标准：统一命名、明确的组织学诊断标准、慢性病程分期与分级定义 | 命名统一、分期（stage）与分级（grade）、组织学判读项（正文为 ScienceDirect 书籍，本库仅页面级） | [01](05-liver-disease-guidelines/01-犬猫肝病临床与组织学诊断标准.md) |
| 06 微芯片识别 | 给出推荐植入部位与地域、物种差异（犬猫之外含农业动物、其他哺乳类、两栖、鸟、爬行类），并专章说明如何保证读取器正常工作 | 真 ISO 芯片 = 64 bit → 15 位数字 ID，前 3 位厂商码，FDX-B 134.2 kHz（ISO 11784 / 11785）；非 ISO 例：HomeAgain 48 bits → 10 位字母数字；扫描先扫本地常用部位，阴性再扫替代部位 | [01](06-microchip-identification-guidelines/01-微芯片识别与应用指南.md) |
| 07 疼痛管理 | 更新后的全球疼痛指南帮助团队理解疼痛管理对患者健康与福利的意义，并给出疼痛治疗的最新思路 | 疼痛定义与急慢性分类、外周/中枢敏化、犬猫量表（FGS、CMPS-SF、UFEPS-SF、CBPI、FMPI、HCPI、LOAD、COAST、CMI/CSOM/FPFF）、五域与伦理、区域阻滞与多模式镇痛、**场景海报不含 mg/kg 剂量（剂量表在 WSAVA Pain Treatise）** | [01 评估](07-pain-guidelines/01-疼痛全球指南2022-概述与评估.md)、[15 治疗](07-pain-guidelines/15-疼痛全球指南2022-治疗与药物管理.md)、[16 区域阻滞与专科](07-pain-guidelines/16-疼痛全球指南2022-下半部分.md)、[02–14 场景海报](07-pain-guidelines/) |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 板块与核心概念 (3)', '| 08 兽医职业健康 | 循证概述伴侣动物兽医行业身心健康挑战的构成要素，并梳理面向领导者、团队成员与学生的现有资源 | 复原力（resilience）、同情疲劳、求助污名、自我关怀作为职业义务、比例死亡比（PMR）等研究指标、诊所文化 6 步 | [01](08-professional-wellness-guidelines/01-WSAVA兽医职业健康指南.md)、[03–08 研究论文](08-professional-wellness-guidelines/) |
| 09 肾病标准化 | 肾病标准化项目旨在改善犬肾小球疾病的诊断，从而改善临床结局 | 犬肾小球疾病分类（WSAVA Renal Pathology Initiative 论文，外链）；**小册子为扫描图片版，正文未抽取** | [01](09-renal-standardization-guidelines/01-肾病数据标准化项目.md) |
| 10 生殖控制 | 帮助会员在保障动物福利、维护人-动物纽带的前提下做出基于证据的生殖管理选择；讨论现行实践与新旧手术/非手术方法及其健康利弊与伦理问题 | OE / OHE / SOHE 术式区别、LH/FSH 与 HPA 轴、激素与非激素避孕（deslorelin、ZP3 疫苗等）、TNR、性腺切除与肿瘤/疾病风险数据 | [01](10-reproduction-guidelines/01-犬猫生殖控制指南2024-第一部分.md)、[02](10-reproduction-guidelines/02-犬猫生殖控制指南2024-第二部分.md)、[03](10-reproduction-guidelines/03-犬猫生殖控制指南2024-第三部分.md)、[04 执行摘要](10-reproduction-guidelines/04-犬猫生殖控制指南2024-执行摘要.md) |
| 11 疫苗接种 | 给出犬猫疫苗的全球最新科学认识与实操建议；VGG 另发布亚洲与拉美区域建议 | **核心疫苗 = 考虑地理分布等因素后所有犬猫都应接种**；非核心按生活方式/暴露风险；母源抗体（MDA）干扰、最小免疫年龄、加强间隔、收容所方案、FISS 与不良事件报告 | [01 现行版](11-vaccination-guidelines/01-犬猫疫苗接种指南2024.md)、[09 速查表](11-vaccination-guidelines/09-犬猫疫苗速查表三合一.md)、[06/07/08 英文全典](11-vaccination-guidelines/06-犬猫疫苗接种指南2024-英文全典-一.md)、[04/05 拉美](11-vaccination-guidelines/04-拉美地区犬猫疫苗建议-上.md)、[02/03 历史版](11-vaccination-guidelines/02-犬猫疫苗接种指南2015-上.md) |', '', '', '', '指南索引,目录约定,板块与文档清单', 'caution', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 跨板块通用要点', '跨板块通用要点

| 概念 | 要点 | 详见 |
|---|---|---|
| 第五生命体征式评估 | WSAVA 把营养、疼痛、福利评估都当作每次就诊的常规项，而非可选项 | 01/01、07/01 |
| 评分工具「量表化」 | 各板块都用 0–3 或 1–9 的分级量表把主观判断变成分数（内镜病变 0–3、BCS 9 分制在营养库、疼痛行为量表） | 03/01、07/01 |
| 指南正文 vs 期刊正文 | 疼痛、牙科、生殖、遗传、肝病、肾病、疫苗的核心正文均先发表于 JSAP/JVME/Vet Record/Sage，网站 PDF 多为摘要、海报或译本 | 各板块 `00-板块说明.md` 的「外部引用」 |
| 剂量表常不在指南内 | 疼痛场景海报、疫苗速查表都明确指向 Treatise / 完整指南或说明「按标签」；RAG 回答剂量问题必须回溯完整版整理稿 | 07/02–14、11/09 |
| 译本 ≠ 更新版 | 网站把同一版本翻译成 8–10 种语言，本库只收英文与中文（疼痛 2022 例外取法语） | 各板块「未收录」表 |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 版本与取代关系', '版本与取代关系

| 板块 | 现行版 | 已被取代 / 归档 | 备注 |
|---|---|---|---|
| 动物福利 | Animal Welfare Guidelines **2018**（站上传 2019/12）＋ Animal Welfare Charter **2020/02** | — | 页面另有 JSAP Guest Editorial 外链 |
| 牙科 | Global Dental Guidelines **2019**（中文 JSAPMandarin 2021/05） | 页面标注 **NEW: 2026 WSAVA Global Dental Guidelines**，仅 Wiley 链接、未抓取 | 2026 版正文需另行获取 |
| 胃肠 | 内镜/活检/组织病理学指南（**2009** Wiley 论文）＋ 上/下内镜报告表（**2020/01**） | — | 表单获 CGS、ESCG 背书 |
| 遗传病 | HDC Position Paper（站上传 2020/01） | — | 单份立场文件 |
| 肝病 | Standards for Clinical and Histological Diagnosis…（ScienceDirect 书籍） | — | 站内无 PDF |
| 微芯片 | 指南正文直接发布在页面（页面更新 2024-03-26） | — | 站内仅有葡语 PDF |
| 疼痛 | Recognition, Assessment and Treatment of Pain **2022**（站内完整正文只有法语 2024/09）＋ 场景海报（多为 **2024/08**，部分 2020/01） | — | 英文完整版在 Wiley（403） |
| 职业健康 | Professional Wellness Guidelines，中文正文 **2024/12** ＋ Infographics **2025/05**（西/法 2025/03） | — | 附 JVME / Veterinary Record 研究论文 |
| 肾病 | Renal Standardization Brochure（2020/01，扫描件） | — | 分类正文在 Vet Pathol 论文（Sage 外链） |
| 生殖 | Guidelines for the Control of Reproduction **2024**（JSAP Romagnoli，2024/05）＋ Executive Summary 2024/06 ＋ 官方中文附件（文件名标注 250422） | — | 日文执行摘要 2025/09 未收录 |
| 疫苗 | **2024**（英文 2024/04 ＋ 执行摘要 2024/05 ＋ 疫苗速查表 2025/06）＋ 拉美建议 2020/01 | **2015** 英文版与中文版（站内标注 2016 Guidelines / 2015 版，PDF 上传 2020/01），已非现行 | 检索疫苗问题默认取 2024；2015 仅作历史对照 |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 已知缺口', '已知缺口', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 已知缺口 (2)', '| # | 缺口 | 影响 | 处置 |
|---|---|---|---|
| 1 | `07-pain-guidelines/pdf/Reduced_Chinese_Simplified_2022年WSAVA疼痛识别、评估和治疗指南.pdf`（42 页，仅抽出 446 字符）与 `09-renal-standardization-guidelines/pdf/Renal-Standardization-Brochure.pdf`（2 页，抽出 0 字符）为扫描图片版 | 这两份 PDF 无法作为语料检索 | 已按决策**不安装 OCR**，仅在 `raw_extracts/` frontmatter 标 `needs_ocr: true`；需要时再补 OCR |
| 2 | 疼痛 2022 指南英文完整版位于 Wiley 付费墙（HTTP 403） | 英文原典不在库内 | 经确认破例以官方**法语**完整版为依据（`language: fr`），中文整理稿为 01 / 15 / 16 |
| 3 | 肝病、微芯片两板块 `raw_extracts/` 为空（站内无英文 PDF） | 无原文可切块，只能依赖页面正文 | 整理稿改以 `00-板块说明.md` 的页面正文为依据，已在文中注明来源 |
| 4 | 疼痛场景海报与疫苗速查表本身不含剂量/完整方案 | 直接问「用多少 mg/kg」无法从这些文档回答 | 整理稿逐处标「原文此处缺失」，并指向完整指南/Treatise |
| 5 | 仍只在期刊平台、站内无 PDF 的正文：牙科 2026 新版（Wiley 链接）、胃肠 2009 论文正文、肝病 ScienceDirect 书籍正文、肾病 Vet Pathol 分类论文、动物福利的 JSAP Guest Editorial 等页面外链 | 这几个板块的核心技术正文不完整 | 只在各 `00-板块说明.md` 的「外部引用」登记链接；未登录抓取。已收录在库的期刊正文（牙科 2019 中文 JSAP、生殖 JSAP 2024、疫苗 2024 英文原典、职业健康 JVME/Veterinary Record/AVA 论文）不属本条 |
| 6 | 站内 87 个 PDF 链接中，41 份小语种译本（西/葡/法/德/意/日/俄等）按「英文＋中文」策略跳过（收录 46 份：英文 40 ＋ 中文 6，无下载失败） | 多语言 RAG 覆盖不足 | 清单在各板块「未收录」表与 `docs/wsava全球指南知识/_cache/download_report.json`，可追加抓取 |
| 7 | 海报与法语 PDF 的抽取噪声：连字（ﬀ/ﬂ）、Wiley 下载水印切断正文、表格串行、原始拼写错误（excrutiating、dypirone、casesarian） | 原文抽取稿局部需人工判读 | 整理稿照录并加〔原文如此〕，不做推测性修正 |
| 8 | 原文自身缺陷（非抽取问题）：2015 疫苗指南 CPV-2 数据表作「26 or 52 **months** of age」而其余各表均作 weeks；FAQ C40「no more frequently than every ___ thereafter」间隔数值在原文即缺失；原文交叉引用「see FAQ 60」「see Q92」在英文抽取中无对应可见编号；法语疼痛指南内科节引用「3.14 章」与本章实际序号不符 | 直接引用可能得到不一致或空洞答案 | 已在 `11/03`、`07/16` 的「异常与缺失登记」小节逐条列出并照录加〔原文如此〕，答题时应提示存在原文不一致 |
| 9 | 超长文档被拆成多份整理稿（疼痛 01/15/16、生殖 01/02/03、疫苗 06/07/08），单篇只覆盖原文的部分切片 | 检索到的片段可能缺少前文（如表头、剂量表主体在另一片） | 各稿 frontmatter 记 `coverage` / `digested_chunks`，并在正文注明续接关系；建库时按 `source_files` 合并同书各稿 |
| 10 | 两份抽取稿**只做原文、不做整理稿**：`10-reproduction` 的 JSAP 2024 英文原典（585,449 字符 / 60 分块）内容已由官方中文译本（同板块附件）完整整理；`11-vaccination` 的 2015 官方中文译本（49,455 字符）仅作 2015 英文版的术语对照，未单独成稿 | 检索这两份时命中的是英文/中文原文而非导读稿 | 属**有意去重**，不是漏整理；', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 已知缺口 (3)', '原文仍在 `raw_extracts/` 可正常入库，`check_chunk_coverage.py` 已把它们登记为已知例外。补充：`10/01` 的四张表已与该英文原典逐格核对（表 2 记有三处与英文版不符：行名 Uterine tumours 译作「输卵管肿瘤」、阴道肿瘤 "1.9 to 3" 作 "1%~3%"、乳腺肿瘤影响因素缺 "gestagens"；表 4 因中英两份抽取都串列而未重构，逐格数值标「原文此处缺失」），核对结论写在正文，未并入 frontmatter 的 `source_files`（该字段只记译本） |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表', '关键缩写对照表

> 释义照录各整理稿首次出现处的写法；完整定义以整理稿正文与 `raw_extracts/` 原文为准。', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表 (2)', '| 缩写 | 含义（释义照录整理稿首现处；括注说明英文全称能否在原文中找到） | 出处 |
|---|---|---|
| WSAVA | World Small Animal Veterinary Association 世界小动物兽医协会 | 全库 |
| VGG | Vaccination Guidelines Group 疫苗接种指南组 | 11/01 |
| PWG | Professional Wellness Guidelines 职业健康指南 / 职业健康小组 | 08/01 |
| HDC | Hereditary Disease Committee 遗传病委员会 | 04/01 |
| CGS / ESCG | Comparative Gastroenterology Society / European Society of Comparative Gastroenterology | 03/01 |
| NAI | Non-Accidental Injury 非意外性损伤 | 01/01 |
| SOP | Standard Operating Procedure 标准操作规程 | 01/01 |
| FAWC | Farm Animal Welfare Committee 农场动物福利委员会 | 01/01 |
| SNS | Sympathetic Nervous System 交感神经系统 | 01/01 |
| CVD | Cardiovascular Disease 心血管疾病 | 01/01 |
| TIVA | Total Intravenous Anaesthesia 全静脉麻醉 | 02/01 |
| SCC | Squamous Cell Carcinoma 鳞状上皮细胞癌 | 02/02 |
| CAA | 口腔肿瘤类型之一（犬颌龈成釉细胞瘤语境，整理稿以「中央型/周边型」描述，原文全称缺失） | 02/02 |
| DJD | Degenerative Joint Disease 退行性关节病 | 07/06 |
| FGS | Grimace Scale 猫鬼脸量表 | 07/01 |
| CMPS-SF | Composite Measure Pain Scale – Short Form 格拉斯哥疼痛测量简表（另有 CMPS-Feline） | 07/01 |
| UFEPS-SF | 猫疼痛评估简表（法语原典缩写，英文全称不在库内） | 07/01 |
| CBPI | Brief Pain Inventory 犬简短疼痛量表 | 07/01 |
| FMPI | Musculoskeletal Pain Index 猫肌肉骨骼疼痛指数 | 07/01 |
| HCPI | Helsinki Chronic Pain Index 赫尔辛基慢性疼痛指数 | 07/01 |
| LOAD | Liverpool Osteoarthritis 利物浦犬骨关节炎问卷/量表 | 07/01 |
| COAST | Osteoarthritis Staging Tool 犬骨关节炎分期工具 | 07/01 |
| CSOM | Client-Specific Outcome Measure 客户特异性结局测量 | 07/01 |
| FPFF | 猫身体功能公式（英文全称不在库内） | 07/01 |
| MiPSC | 猫疼痛筛查清单（6 问，任一「否」即需进一步评估） | 07/01 |
| 4A-Vet | 犬疼痛行为量表（6 项各 0–3 分，最高 18 分，无阈值分） | 07/01 |
| QST | Quantitative Sensory Testing 定量感觉测试 | 07/01 |
| FHS | Hyperaesthesia Syndrome 猫感觉过敏综合征 | 07/01 |
| FOPS | Orofacial Pain Syndrome 猫口面部疼痛综合征 | 07/01 |
| CHEW | 猫健康与福利（问卷缩写，原文全称未展开） | 07/01 |
| EFP | 兽医伦理工具（原文缩写，全称未展开） | 07/01 |
| PA | 误吸性肺炎（aspiration pneumonia 语境下的原文简称） | 07/01 |
| PRN | 必要时（拉丁语处方缩写，原文未展开） | 07/01 |
| TID / BID / SID | 每日三次 / 两次 / 一次（处方缩写，原文未展开） | 07/07 |
| IV / IM / SC / PO | 静脉 / 肌肉 / 皮下 / 口服 | 07/03 |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表 (3)', '| CNS | Central Nervous System 中枢神经系统 | 07/11 |
| TCA | Tricyclic Antidepressant 三环类抗抑郁药 | 07/15 |
| NGF | Nerve Growth Factor 神经生长因子（抗 NGF 单抗） | 07/15 |
| NK-1 | Neurokinin 神经激肽-1 受体 | 07/15 |
| TENS | Transcutaneous… 经皮电刺激 | 07/15 |
| PRP | Platelet-Rich Plasma 富血小板血浆 | 07/15 |
| AH / HA | Hyaluronic Acid 透明质酸 | 07/15 |
| CSM / MSC | Mesenchymal Stem Cells 间充质干细胞 | 07/15 |
| CB | Cannabinoid Receptor 大麻素受体 | 07/15 |
| FLUTD | Lower Urinary Tract Disease 猫下泌尿道疾病 | 07/15 |
| IRIS | 原文仅以缩写出现（肾病相关协会），本库未展开 | 07/15 |
| OE | Ovariectomy 单独卵巢摘除 | 10/01 |
| OHE / SOHE | 卵巢子宫切除（全部 / 部分子宫）；原文以术式缩写出现 | 10/01 |
| LH | Luteinising Hormone 促黄体素 | 10/01 |
| FSH | 促卵泡素（英文全称不在库内） | 10/01 |
| HPA | Hypothalamic–… 下丘脑-垂体-性腺轴 | 10/01 |
| deslorelin | 乙酸地洛瑞林（GnRH 激动剂植入剂） | 10/01 |
| ZP3 / pZP3 | 透明带蛋白 3 / 猪 ZP3（免疫避孕疫苗靶点） | 10/01 |
| TNR | Trap–Neuter–Return 捕获—绝育—放归 | 10/02 |
| HD | Hip Dysplasia 髋关节发育不良 | 10/02 |
| IMHA | Immune-Mediated Haemolytic Anaemia 免疫介导性溶血性贫血 | 10/02 |
| MCT | Mast Cell Tumour 肥大细胞瘤 | 10/02 |
| TCC | Transitional Cell Carcinoma 移行细胞癌 | 10/02 |
| CCL | Cruciate 十字韧带 | 10/02 |
| FIV | 猫免疫缺陷病毒（Immunodeficiency Virus） | 10/02 |
| FIP | 猫传染性腹膜炎（Infectious Peritonitis） | 10/02 |
| LUTD | 下尿路疾病 | 10/02 |
| MDA | Maternally Derived Antibodies 母源抗体 | 11/01 |
| MLV | Modified Live Vaccine 改良活（减毒活）疫苗 | 11/01 |
| CRFK | Crandell（Reese Feline Kidney）猫肾细胞系 | 11/01 |
| AEFV(s) | Adverse Events Following Vaccination 疫苗接种后不良事件 | 11/01 |
| EB1–EB4 | 本版疫苗指南的证据来源分级（EB2＝随兽药注册提交的未发表商业敏感研究等） | 11/01 |
| FISS | Injection-Site Sarcoma 猫注射部位肉瘤 | 11/01 |
| CVL | Leishmania 相关 犬利什曼病 | 11/04 |
| PAHO | 泛美卫生组织（英文全称不在库内，原文多用 OPS） | 11/04 |
| RT-PCR | Reverse Transcript… 聚合酶链反应 | 11/04 |
| AVA / AVMA / WMA | 澳大利亚兽医协会 / 美国兽医协会 / World Medical 世界医师协会 | 08/01 |
| DNP | Doctor of Nursing 美国护理实践博士 | 08/05 |
| PMR | 比例死亡比（英文全称不在本板块原文中） | 08/06 |
| RR | Relative Risk 相对危险度 | 08/06 |
| GAD / PTSD | 广泛性焦虑障碍 / Post-Traumatic 创伤后应激障碍 | 08/01 |
| MDD / ADHD | 重度抑郁障碍 / 注意缺陷多动障碍（英文全称不在库内） | 08/01 |', '', '', '', '指南索引,目录约定,板块与文档清单', 'caution', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 关键缩写对照表 (4)', '| Resilience / Compassion（fatigue） | 复原力 / 同情疲劳（研究主题词） | 08/01、08/03、08/05 |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 适用场景索引', '适用场景索引

| 场景 | 建议检索顺序 |
|---|---|
| 术前/术后镇痛方案（绝育、骨科、软组织、剖腹产、儿科） | `07-pain-guidelines/02–14` 场景海报 → `15`（药物与剂量表）→ `16`（区域阻滞与专科） |
| 慢性疼痛识别与量表选择 | `07-pain-guidelines/01`（概述与评估）→ `07/06`（DJD）→ `07/09`（神经病理性） |
| 急诊与重症、内科癌痛 | `07/07`、`07/08`、`07/03` → 药物部分 `07/15` |
| 口腔诊疗全流程（分级、洁治、拔牙、刷牙宣教） | `02-dental-guidelines/01` → `03`（刷牙工具包） |
| 口腔肿物鉴别与转诊 | `02-dental-guidelines/02` |
| 免疫程序制定（宠物犬 / 宠物猫 / 收容所） | `11/09`（速查表）→ `11/01`（2024 中文译本）→ `11/06`、`11/07`、`11/08`（英文全典） |
| 区域性疾病风险（拉美）与法规/冷链 | `11/04`、`11/05` |
| 历史版本对照（2015 vs 2024 差异） | `11/02`、`11/03` 与 `11/01` 对比 |
| 绝育时机、避孕与 TNR 项目 | `10/01`、`10/02`、`10/03` → 快速要点 `10/04` |
| 胃肠内镜检查与活检报告规范化 | `03/01` |
| 遗传病繁育咨询与基因检测 | `04/01` |
| 犬猫植入芯片部位、芯片制式与扫描核查 | `06/01` |
| 疑似虐待案件识别与报告流程 | `01/01`（NAI 章节）＋ `01/02`（宪章承诺） |
| 兽医团队心理健康、倦怠与求助污名 | `08/01` → `08/03–08`（研究论文） |
| 肝/肾组织学与诊断标准化 | `05/01`、`09/01`（注意缺口：正文在书籍/论文， brochure 需 OCR） |', '', '', '', '指南索引,目录约定,板块与文档清单', 'caution', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('WSAVA 全球指南知识库 — 总索引 · RAG 建库建议', 'RAG 建库建议

1. **两套语料分工**：`NN-*.md` 中文整理稿负责召回与答题口径；`raw_extracts/*.md` 原文负责术语、剂量与英文查询命中。用 frontmatter 的 `source_files` / `local_pdf` 建立二者溯源关系。
2. **切块边界**：整理稿按 `##` 章节切；原文抽取稿表格区按行组切并重复表头（本库抽取阶段已按 12k 字符上限处理，中间产物在 `docs/tools/chunks/`，**不要入库**，与 `raw_extracts/` 内容重复）。
3. **必带元数据**：整理稿统一有 `kb` / `type` / `language` / `section` / `title` / `source_url` / `source_files`；`section_zh`（板块中文名）只有 6 份整理稿带，需要时由 `section` 到本索引「板块与文档清单」的小节标题映射；原文抽取稿另有 `local_pdf` / `pdf_pages` / `extraction_chars` / `needs_ocr`；疫苗类整理稿另带 `version`，方便按现行版加权。
4. **过滤规则**：`needs_ocr: true` 的两份抽取稿排除在检索之外（正文为空或近空，命中会引入噪声）。
5. **版本消歧**：2015 与 2024 疫苗指南、法语疼痛指南与中文海报存在内容重叠，回答时应优先现行版并在引用中写明版本。
6. **剂量类问题的护栏**：场景海报与速查表不含剂量，检索到这些文档时应继续回溯完整指南整理稿（见「已知缺口」第 4 条）。
7. **引用格式**：`板块NN/文档NN#章节号` ＋ `source_url`，便于答案附出处。', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 工具与可复现流程', '工具与可复现流程

| 脚本 | 作用 |
|---|---|
| `docs/tools/wsava_crawler.py` | 抓板块页面（WordPress REST）→ 生成 `00-板块说明.md`；下载英文/中文 PDF → `pdf/`；PyMuPDF 自写块抽取器 → `raw_extracts/*.md` |
| `docs/tools/chunk_extracts.py` | 抽取稿 >40k 字符时切成 ≤12k 分块并生成 `manifest.json` |
| `docs/tools/build_kb_index.py` | 重生成 `00-知识库总索引.md` 的机械清单部分，保留本文件「核心概念速查」起的人工章节 |
| `docs/tools/index_manual_draft.md` | 人工章节的草稿副本；`00-知识库总索引.md` 里的版本才是**正式生效**的那份（改索引请直接改索引文件，`build_kb_index.py` 会原样保留「核心概念速查」之后的全部内容） |
| `docs/tools/check_digests.py` | 校验整理稿 frontmatter 与结构（章节编号、关键词索引、正文长度） |
| `docs/tools/check_coverage.py` | 核对每份 `raw_extracts/` 是否被整理稿 `source_files` 引用 |
| `docs/tools/check_numbers.py` | 反编造抽查：整理稿数字能否在原文抽取稿中找到（`python check_numbers.py <文件名片段>` 打印未溯源数字所在行） |
| `docs/tools/check_chunk_coverage.py` | 核对分块范围：切块的原文抽取稿是否被整理稿的 `coverage`/`digested_chunks` 全数认领、有无缺口与重叠 |
| `docs/tools/check_tables.py` | 整理稿表格列数一致性 + 占位符（`TODO`/`待补`/`待续`/`见下一节`/`<!--`）与末行截断检查；单元格内竖线须写成 `\\|`，否则会被计为分列 |
| `docs/tools/extract_abbrev.py` | 抽取「中文释义（缩写）」候选，供上面的缩写表复核 |
| `docs/tools/normalize_digest_fm.py` | 统一整理稿 frontmatter（`type`、`source_files`、`language`），默认 dry-run，加 `--apply` 写盘 |
| `docs/tools/renumber_vaccination.py` | 疫苗板块整理稿重排（英文全典连号 06/07/08、速查表 09），同步改正文跨稿引用 |
| `docs/tools/check_links.py` | 校验本索引里相对链接（含百分号编码的中文路径）是否指向存在的文件 |', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 全球指南知识库 — 总索引 · 版权与来源', '版权与来源

- 全部内容版权归 World Small Animal Veterinary Association (WSAVA) 各 Task Force / Guidelines Group 及相关权利人；本库仅作**内部知识库研究**用途，不对外分发。
- 抓取范围：<https://wsava.org/global-guidelines/> 下 11 个板块（按用户要求排除 Global Nutrition Guidelines，营养部分见 `docs/wsava营养知识`）。
- 抓取时间：2026-10-19；页面最后更新时间以各 `00-板块说明.md` frontmatter 的 `updated` 为准。
- 许可背景：本次抓取已按用户说明提交申请并获网站同意；未绕过登录或付费墙（Wiley 403 部分未抓取）。
- 原始 PDF 一律保留在 `pdf/`，`raw_extracts/` 只作格式转换，正文内容未作改写。', '', '', '', '指南索引,目录约定,板块与文档清单', 'informational', 'WSAVA 全球指南知识库 — 总索引', 'official', '', 'approved'),
('Animal Welfare Guidelines · 第 1 段', 'Animal Welfare Guidelines（动物福利指南）

板块页面正文（原文）

Guidelines

Animal Welfare

Executive Summary

These Global Guidelines aim to bridge differing perceptions of welfare around the world and help veterinary teams to tackle the ethical questions and moral issues which impact welfare. They also offer guidance to ensure that, in addition to providing physical health advice and therapy to their patients, veterinary teams can advocate for their psychological, social and environmental wellbeing.

Resources

- [JSAP Guest Editorial on Guidelines](https://onlinelibrary.wiley.com/doi/10.1111/jsap.12988)
- [Animal Welfare Charter](https://wsava.org/wp-content/uploads/2020/02/WSAVA_Animal_Welfare_Charter_Feb-2020.pdf) ([Portuguese](https://wsava.org/wp-content/uploads/2020/04/WSAVA-Animal-Welfare-Charter-Feb-2020-Portuguese.pdf))
- [Animal Welfare Worldwide, the Opinion of Practicing Veterinarian](https://www.tandfonline.com/doi/full/10.1080/10888705.2020.1717340)s  
  *Published in the Journal of Applied Animal Welfare Sciences*

Downloads', '', '', '', '动物福利,板块页面正文（原文）,Guidelines,Animal Welfare', 'informational', 'Animal Welfare Guidelines', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('Animal Welfare Guidelines · 第 2 段', 'Animal Welfare Guidelines

[Download PDF](https://wsava.org/wp-content/uploads/2019/12/WSAVA-Animal-Welfare-Guidelines-2018.pdf)

[Read in JSAP](https://onlinelibrary.wiley.com/doi/full/10.1111/jsap.12998)

Translations

[French](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Animal-Welfare-Guidelines-French.pdf)

[Portuguese](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Animal-Welfare-Guidelines-2018-PORTUGUESE.pdf)

[Slovakian](https://wsava.org/wp-content/uploads/2020/01/WSAVA_Animal_Welfare_Guidelines_Slovakian.pdf)

[Spanish](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Animal-Welfare-Guidelines-Spanish.pdf)', '', '', '', '动物福利,板块页面正文（原文）,Guidelines,Animal Welfare', 'informational', 'Animal Welfare Guidelines', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('Animal Welfare Guidelines · Endorsements', 'Endorsements

- Argentina (AVEACA)
- Belgium (SAVAB)
- Bosnia-Herzegovina (BHSAVA)
- Canada (AMVQ)
- Czech Republic (CSAVA)
- Denmark (DSAVA)
- Finland (FAVP)
- Greece (HCAVS)
- Hong Kong (HKVA)
- India (FSAPAI)
- Indonesia (ISAPVA)
- Iran (ISAVA)
- Ireland (VICAS)
- Japan (SJCAP)
- Malaysia (MSAVA)
- North American Veterinary Community (NAVC)
- the Netherlands (NACAM)
- Nepal (VPAN)
- New Zealand (NZVNA)
- New Zealand (NZVA CAV)
- Nigeria (SAVAN)
- Norway (NSAVA)
- Philippines (PAHA)
- Poland (PSAVA)
- Portugal (APMVEAC)
- Serbia (SASAP)
- Singapore (SVA)
- South Korea (KAHA)
- Spain (AVEPA)
- Taiwan (TVMA)
- Thailand (VPAT)
- Tunisia (UGMVT)
- Zimbabwe (VAWZ)
- International Society for Feline Medicine (ISFM)
- International Veterinary Students’ Association (IVSA)
- International Society of Veterinary Ophthalmology (ISVO)
- International Veterinary Academy of Pain Management (IVAPM)
- World Aquatic Veterinary Medicine Assocation (WAVMA)

本板块文档清单

共 7 份 PDF，按「英文 + 中文」策略收录 2 份，跳过小语种译本 5 份。', '', '', '', '动物福利,板块页面正文（原文）,Guidelines,Animal Welfare', 'informational', 'Animal Welfare Guidelines', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('Animal Welfare Guidelines · 已收录（原文已抽取到 raw_extracts/）', '已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Animal Welfare Charter | EN |  | 3 | 1853 | [raw_extracts/WSAVA_Animal_Welfare_Charter_Feb-2020.md](raw_extracts/WSAVA_Animal_Welfare_Charter_Feb-2020.md) |
| Download PDF | EN | 2018 版 | 80 | 181896 | [raw_extracts/WSAVA-Animal-Welfare-Guidelines-2018.md](raw_extracts/WSAVA-Animal-Welfare-Guidelines-2018.md) |

未收录（同一指南的其他语言译本）

- WSAVA-Animal-Welfare-Charter-Feb-2020-Portuguese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/04/WSAVA-Animal-Welfare-Charter-Feb-2020-Portuguese.pdf>
- WSAVA-Animal-Welfare-Guidelines-French.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-Animal-Welfare-Guidelines-French.pdf>
- WSAVA-Animal-Welfare-Guidelines-2018-PORTUGUESE.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-Animal-Welfare-Guidelines-2018-PORTUGUESE.pdf>
- WSAVA_Animal_Welfare_Guidelines_Slovakian.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA_Animal_Welfare_Guidelines_Slovakian.pdf>
- WSAVA-Animal-Welfare-Guidelines-Spanish.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-Animal-Welfare-Guidelines-Spanish.pdf>', '', '', '', '动物福利,板块页面正文（原文）,Guidelines,Animal Welfare', 'informational', 'Animal Welfare Guidelines', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('Animal Welfare Guidelines · 外部引用（期刊论文 / 相关机构，未抓取正文）', '外部引用（期刊论文 / 相关机构，未抓取正文）

- JSAP Guest Editorial on Guidelines — <https://onlinelibrary.wiley.com/doi/10.1111/jsap.12988>
- Animal Welfare Worldwide, the Opinion of Practicing Veterinarian — <https://www.tandfonline.com/doi/full/10.1080/10888705.2020.1717340>
- Read in JSAP — <https://onlinelibrary.wiley.com/doi/full/10.1111/jsap.12998>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '动物福利,板块页面正文（原文）,Guidelines,Animal Welfare', 'informational', 'Animal Welfare Guidelines', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 文档基本信息', '1. 文档基本信息

- 原名 WSAVA Animal Welfare Guidelines for companion animal practitioners and veterinary teams；2018 版，80 页；由动物福利指南小组（Animal Welfare Guidelines Group, AWGG，隶属 WSAVA 动物健康与福利委员会 AWWC）编写，Waltham® 赞助。
- 原文脚注：veterinary clinic（兽医诊所）泛指任何提供兽医服务的场所或情形；本文件主要针对犬与猫，原则可普适应用。
- 定义：**动物福利（Animal welfare）＝动物的身体与心理、社会及环境层面的康乐（physical and psychological, social and environmental well-being of animals）**；原文声明目前**无普遍接受的（universally accepted）定义**。

| 作者（原文照抄） | 资质 | 地区 |
|---|---|---|
| Shane Ryan | BVSc (Hons), MVetStud, CVA, MChiroSc, MRCVS | Singapore |
| Heather Bacon | BSc, BVSc, CertZooMed, MRCVS | UK |
| Nienke Endenburg | PhD | Netherlands |
| Susan Hazel | BVSc, BSc (Vet), PhD, GradCertPublicHealth, MANZCVS (Animal Welfare) | Australia |
| Rod Jouppi | BA, DVM | Canada |
| Natasha Lee | DVM, MSc | Malaysia |
| Kersti Seksel | BVSc (Hons), MRCVS, MA (Hons), DACVB, DECAWBM, FAVA | Australia |
| Gregg Takashima | BS, DVM | USA |

2. 前言（Preamble）

OIE (2012)：兽医「应当成为所有动物福利的首要倡导者」；FVE/CVMA/AVMA 联合声明 (2014)：兽医「必须不断努力成为动物良好福利的首要倡导者」。WSAVA 代表超过 **200,000** 名兽医、隶属 **100 余个**协会（2018）。HABRI (2016)：被告知人-动物联结价值的客户，遵循建议、来做健康预约、购买宠物保险的可能性高出 **77%**。

3. 第 1 章：识别与评估（recognition and assessment）', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 建议与自查清单', '3.1 建议与自查清单

建议（4 条）：制定**动物福利宪章（animal welfare charter）**；促进一切兽医互动中伴侣动物的积极福利状态；向宠物主人社区推广福利知识；诊所照护须同时满足**身体需求与行为需求**。清单（8 条）要点：是否有明示政策承诺与书面宪章、全员是否理解、是否已向客户与社区传达、**兽医誓词（WSAVA Veterinary Oath, 2014）**是否公开展示。

3.2 背景与概念框架

原文数据：北美近 **70%** 的人与至少一只宠物共同生活（Hodgson et al., 2015）；澳大利亚超过 **2,400 万只**；中国犬超过 **2,200 万只**、猫超过 **5,300 万只**。犬猫可因**人工保定（manual restraint）等任何操作**而痛苦（distressed），其持久影响可促成**负面的条件化情绪反应（predispose to a negative conditioned emotional response）**，使未来就诊更困难（Barletta and Raffe, 2017）。

Fraser (2008) 三重叠概念（图 1）：**身体状态与机能**、**心理或精神（情感）状态**、**执行自然行为并按天然状态生活的能力**；福利不等同身体健康。动物感受力（Animal sentience）＝**感受、知觉或主观体验的能力**（NZVA, 2018)，与智力无关。福利沿**连续谱（welfare spectrum，图 2）**分布；判据（Korte et al., 2009）：**除非应对能力不足以应付环境挑战，福利通常不处于风险中**，不能应对则出现受苦、**习得性无助（learned helplessness）**、挫败或焦虑。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 五大自由与五大动物福利需求', '3.3 五大自由与五大动物福利需求

| 年份 | 原文事件 |
|---|---|
| 1965 | 英国对集约化畜牧动物待遇的公众关切促成 Brambell 报告，进而设立农场动物福利委员会（FAWC） |
| FAWC 期间 | 制定**五大自由（Five Freedoms）**，作为满足农场物种福利需求的框架 |
| 2006 | 五大自由被改编为**五大动物福利需求（Five Animal Welfare Needs）**，适用于所有家养动物 |

**原文此处缺失**：抽取稿未逐条列出五大自由的五条内容，本稿不作补全。

推荐主框架——五大动物福利需求：①**对适宜环境的需求（The need for a suitable environment）**；②**对适宜饮食的需求（The need for a suitable diet）**；③**能够表达正常行为模式的需求（The need to be able to exhibit normal behaviour patterns）**；④**与其他动物同住或分开安置的需求（The need to be housed with, or apart from, other animals）**；⑤**免受疼痛、受苦、损伤和疾病的需求（The need to be protected from pain, suffering, injury and disease）**。原文：该清单**并非穷尽式（not definitive）**；福利通过**临床评估与行为观察**监测；五大需求比五大自由**更简单易解、更可实现且支持积极福利状态**。

4. 第 2 章：福利的测量与监测

4.1 建议（原文 5 条）

为照料人员提供科学培训；开展监测方法进展的教育培训并与外部机构共享最佳实践；建立**使用身体/机能与行为状态指标的、基于科学的监测流程**；培育**定期报告与监测**并及时更新记录的员工文化；提供**全生命周期照护（whole-of-life care）**，含针对非常年幼、患病、受伤与老年动物的专门政策。

4.2 五域模型（Five Domains Model）

Mellor（梅西大学）提出，旨在「促进对动物福利作系统化、结构化、全面且自洽的评估」（Mellor, 2017），已扩展以纳入**积极福利**测量。顶行四域**营养（Nutrition）、环境（Environment）、健康（Health）、行为（Behaviour）**影响第五域即**动物的精神/心理状态（mental state）**；例：域 1 未提供食物与水，动物将在域 5 体验饥饿与口渴。**原文此处缺失**：图 5 各域下属具体特征清单仅为图片。', '', 'senior', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 评估方法与工具', '4.3 评估方法与工具

- **生活质量（Quality of Life, QoL）**：动物无法自我报告，故使用人类代测指标（proxy measures）；**由主人或兽医填写的工具必须经过充分信度与效度检验**。多数 QoL 测量是**疾病特异性的，尚无充分验证过的通用方法**（Belshaw et al., 2015）；经验证、由主人产生的一般性评估有 **Canine Symptom Assessment Scale**（PennCHART, 2016）与 **Pet Problem Severity Scale (PPSS)**（Spitznagel et al., 2018）。
- **输入（Inputs）与输出（Outputs）测量（图 6）**：输入＝饲养方式、环境、营养、社会接触类型、兽医照护；输出用于评价输入是否充分，因**可能更准确反映福利状态**而更受推崇。图 6 表注（原文）：`BCS = Body Condition Score; MCS = Muscle Condition Score. Charts available at WSAVA.org (WSAVA, 2018)`。**评估个体福利时应始终结合生理与行为测量**。

4.4 应激、恐惧与焦虑（定义照抄）

| 术语 | 原文定义 |
|---|---|
| 应激源（stressor） | 改变内稳态（homeostasis）平衡、需适应才能维持平衡的事物 |
| 应激（stress） | 伴随受苦与精神痛苦的生理紊乱，或觉察内稳态受威胁时的生物反应（Moberg, 2000）；**剧烈或持续时调节不足，导致病态行为与疾病过程** |
| 恐惧（fear） | 对威胁（threat，Duncan, 1993）和/或**感知到的危险（perceived danger，Boissy, Terlouw and Le Neindre, 1998）**作出的一系列行为反应；**正常恐惧是适应性且短暂的** |
| 焦虑（anxiety） | 暴露于真实或感知到的（perceived）威胁情境的情绪状态，**具有预期性（anticipatory）**（Massar et al., 2011）；**焦虑症是医学问题，不经治疗会随时间加重** |', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'caution', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 应激的生理反应', '4.5 应激的生理反应

**交感神经系统（SNS）**经**肾上腺素（adrenaline, epinephrine）**准备「战或逃」，**下丘脑-垂体-肾上腺轴（HPA axis）**导致**皮质醇（cortisol）**分泌。**持续高水平应激可致肾上腺耗竭（adrenal exhaustion）**：此时皮质醇低，易被误认为低应激。

| 负应激致福利下降（原文 7 项） | 较长时间高度负应激可能导致（原文 5 项） |
|---|---|
| 心率、体温、呼吸频率、血糖升高；活动水平改变（增加或减少）；脚垫出汗；喘气 | 体重下降；体脂增加、体肌肉减少；免疫功能下降伴**中性粒细胞/淋巴细胞比值升高**；生殖功能下降；认知损伤 |

4.6 应激的行为反应：4F

| 模式 | 原文要点 |
|---|---|
| Flight（逃） | 可突然离开环境，也可更隐晦（躲到主人身后或桌下） |
| Fight（战） | 「有攻击性就不是恐惧」是常见误解；吼叫、龇牙、扑冲、吠叫者**很可能处于高度恐惧或焦虑状态** |
| Freeze（僵） | **常被误认为配合或表现良好，实为被吓呆、僵住而任由检查或摆布** |
| Fiddle / Fidget（坐立不安） | 「填补」或冲突行为：不饿时舔唇、不困时打哈欠、不痒时抓挠、像湿了般甩毛；**与疼痛征象非常相似且许多重叠**（Seksel, 2007） |

4.7 猫的两类应对者与身体语言

**Active responders（主动应对者，图 8）**：常处围栏前方、以后腿站立试图攀爬、抓挠路过者、踱步、求关注的叫声，可攻击与破坏；宜给**额外刺激性富集**（玩具、觅食拼图）。**Passive responders（被动应对者，图 7）**：抑制进食与梳理等维护行为、不动、常试图躲藏、被接近时可能嘶或吼；宜给提供**安全感**的富集（躲藏处、供攀爬的层架）（Heath, 2008）。**犬没有类似模型，每只犬都应仔细监测**。**交通灯系统（traffic light system，图 9）**用于评估身体语言、决定是否继续检查。**原文此处缺失**：图 9 红/黄/绿分级具体条目仅为图片。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 疼痛（pain）：定义与相关条款', '4.8 疼痛（pain）：定义与相关条款

- IASP 定义：疼痛是「**与真实或潜在组织损伤相关的、或以此类损伤描述的不愉快感觉和情绪体验**」（Merskey and Bogduk, 1994; IASP, 2018）；**高度厌恶、动物会试图回避**。
- 来源可为组织损伤（伤害性 nociceptive）、组织炎症（炎症性 inflammatory）或神经损伤（神经性 neuropathic）；**同一动物可同时经历多种疼痛**。
- 行为征象可为外显（overt）或隐匿（covert）；**行为绝不应孤立看待，必须结合发生情境**。
- 工业化国家 **17% 至 41%** 人口患急性或慢性疼痛（Blyth et al., 2001）；**家养动物受疼痛的比例「尚不清楚（It is not known）」**。
- 行为的任何改变都可能是疼痛的首个指示，**但这是常规临床环境下我们所拥有的最佳指示**。

4.9 疼痛评估量表（原文第 2、3 章列举，本稿合并为一表）

| 量表（英文原名） | 原文类别 | 出处 |
|---|---|---|
| Glasgow Composite Measure Pain Scale–short form (CMPS-SF) | 犬·经验证 | Reid et al., 2007 |
| Helsinki Chronic Pain Index (HCPI) | 犬·经验证 | Hielm-Björkman, Rita and Tulamo, 2009 |
| Canine Brief Pain Inventory (Canine BPI) | 犬·经验证 | PennCHART, 2013 |
| Colorado State University Canine Acute Pain Scale | 犬·未经验证 | Mich et al., 2010 |
| Glasgow Composite Measure Pain Scale–feline (CMPS-Feline) | 猫·经验证 | Calvo et al., 2014 and WSAVA, 2015 |
| UNESP-Botucatu multidimensional composite pain scale (MCPS) | 猫·经验证 | Brondani et al., 2013 |
| Colorado State University Feline Acute Pain Scale | 猫·未经验证 | VASG, 2006 |

5. 第 3 章：就诊前后的福利需求', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 总则与就诊期应激/疼痛的影响', '5.1 总则与就诊期应激/疼痛的影响

兽医方法、能力与基础设施因地差异显著，**但动物的福利需求保持不变**；启动任何手术、物理或药物治疗或其他干预前必须考量「**不伤害（do no harm）**」。临床影响（原文 5 项）：①使犬猫表现攻击行为，**难以保定、更难治疗、更易被遗弃**；②升高循环皮质醇，**压垮免疫系统并抑制疾病或术后恢复**；③皮质醇与去甲肾上腺素升高使血液生化结果可能误导，**误诊为糖尿病等疾病的风险增加**；④常需要**更高剂量的麻醉药与镇痛药**；⑤使中枢神经系统致敏，导致更严重的疼痛反应（**wind-up**）。原文脚注：**wind-up = 对 C 纤维伤害感受器的反复或高强度刺激，导致脊髓神经元中枢致敏，从而使感知疼痛强度增加**，可通过**先发制人镇痛（pre-emptive analgesia）与适当的术后疼痛管理**避免。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 五大需求的建议条款（原文）', '5.2 五大需求的建议条款（原文）

| 需求 | 原文建议条款 |
|---|---|
| 免受疼痛、受苦、损伤与疾病 | **常规监测身体或行为的压力、挫败、恐惧、疼痛或不适征象**；**不应在其他动物可视或可听范围内操作**（Lloyd, 2017）；行为与心理健康须与身体健康一并考量；**必须使用客观测量**评估疼痛与福利；全员须受**安全人道保定**培训；**必须避免使用惩罚（punishment）**；宜有**安乐死政策**且仅可使用人道方法（参见 WSAVA Pain Guidelines, 2014a） |
| 适宜环境 | **温度、通风、照明（照度与光谱分布）、湿度与噪声水平**须适合该物种；笼舍尺寸须使**动物能自然站立、转身与伸展**；**每只受兽医照护动物的状况每天至少评估两次（at least twice daily）**；**清洁与维护不应造成过度应激，并允许不受打扰的休息**；**地面必须防滑但易于消毒**；**猫受益于高处栖息与躲藏处（图 10）** |
| 适宜饮食 | 须考虑**食物给予方式（肠内 vs 肠外）**与喂食频率；**必须向主人询问饮食相关问题**；**幼年患者食物限制时间不应超过 3 小时（Food should not be restricted for more than 3 hours in juvenile patients）**；**禁食、操作后或疾病恢复后应尽快恢复经口喂食**；**麻醉前禁食时长可达 12 小时，但在麻醉前 3 小时给予半份正常餐可显著降低术中胃食管反流发生率（Savvas, Raptopoulos and Rallis, 2016）；任何禁食方案均可由兽医酌情调整**；**犬应分开喂食以避免打斗**；**猫若无法隐蔽地进食可能不进食**；**诊所内零食热量应计入饮食建议** |
| 与其他动物同住或分开 | 评价个体动物是否享受（陌生）人类接触；**避免种间与种内攻击**；**必须培训员工识别并理解警告行为以防攻击升级**；**动物会把厌恶/奖赏事件与特定人类关联**，应促进接触住院宠物人员的积极印象 |
| 表达正常行为模式 | 必须允许表达与就诊不冲突的物种典型行为，以富集与饲养实践**防止行为挫败**；**猫在较高处感觉更安全、需要能躲藏（见图 10），也需要抓挠**；医疗允许时**运动对所有动物都很重要**；**应激信息素**等标记会扰乱其他动物，应尽快彻底清洁 |

**图 11**（猫病房/住院笼中猫砂盆-休息处-食盆之间的最小推荐距离，改编自 Attard et al., 2013）**原文此处缺失**：具体距离数值仅为图片。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 临床团队落地建议（原文汇总）', '5.3 临床团队落地建议（原文汇总）

- 疼痛与恐惧：制定（最好成文）减少患者疼痛与受苦的规程；**引入疼痛量表的常规使用**（见 4.9）；安全保定技术、培训与书面规程（Low Stress Handling®、Fear Free Pets）；犬猫行为与身体语言识别培训；**一旦需要就立即把温和保定技术与药物干预（抗焦虑药、镇静剂、镇痛药）结合使用**。
- 环境：猫在就诊全程与犬及其他动物分开，理想上分设候诊室、诊室、病房与住院区，**分离须考虑视觉、听觉、嗅觉与触觉要素**；候诊区把猫航空箱**抬放到高架或椅子上**（Ellis et al., 2013）；**指导主人以正向强化训练**让犬猫习惯航空箱与汽车；必要时使用抗焦虑药物与**合成信息素类似物**。
- 饮食：各区域（含候诊室）提供清洁饮水并用个体水盆阻断疾病传播；诊室用零食须**获得主人许可**；动物过肥或过瘦时**即使主人未提出也应讨论营养问题**。
- 行为与社交：纸箱提供高处栖息与躲藏、纸板自制猫抓柱；为犬提供毯子、玩具、觅食拼图（Lloyd, 2017）、KONG™ 与嗅闻垫；**清洁与喂食按可预测规程、尽可能由同一员工执行**；**提供不愉快照护的员工不应同时是主要安抚/喂食提供者**；**主人在场因个体而异**，涉及麻醉的复杂操作一般没有让主人在场的福利理由；**住院宠物受益于定期探视**，但可能加剧**就诊后分离**焦虑。
- 各阶段：到达前需**保定训练及对笼、箱与运输方式的习惯化**并**为焦虑或暴躁动物预先安排抗焦虑药或草本镇静剂**，但**不建议就诊前镇静（Pre-visit sedation is not advised）**；**培训员工在到达时对压力/痛苦水平分诊**；诊断操作**首先只做必要的操作**；手术与操作**前后**监测疼痛、舒适与卫生；住院与安置须**允许患者站立与转身**、**犬应常规遛步**、猫砂**至少每日更换一次**。
- 记录与职业安全：动物对**保定、药物与留置**的反应细节是准确随访与交接的必需，**治疗选项讨论与知情同意（informed consent）都需完整记录**；诊所有**物理性、生物性、化学与废弃物**危害及**心理健康与安全**议题，美国兽医员工最常见伤害是**动物咬伤与抓伤**。

6. 第 4 章：伦理问题与道德议题', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 建议与伦理类型', '6.1 建议与伦理类型

建议（3 条）：推动把专业伦理行为作为执业许可一部分的国家或地区性宣言；把伦理决策培训纳入兽医教育与职业发展；**监管对动物福利构成不必要风险的不合伦理操作**。伦理类型四种：**专业伦理（professional ethics）**、**社会伦理（societal ethics）**、**动物伦理（animal ethics）**、**个人伦理（personal ethics）**；福利科学只提供生理与行为信息，**不指导我们为何应以某种方式对待动物**。

6.2 四种动物伦理理论（Sandøe et al., 2016；Palmer and Sandøe, 2011）

**契约论（Contractarian）**——动物不能订立契约，故人对动物无道德义务；**功利论（Utilitarian）**——以行为后果为标志，利用动物时**必须考虑对动物福利的后果**；**动物权利论（Animal Rights）**——动物有内在价值，常体现为**生命与自由的权利**；**关系论（Relational）**——**人-动物联结越强、动物越依赖人类照护，照顾义务越大**。

6.3 伦理困境、道德问题与道德困扰

**伦理困境（ethical dilemma）**＝两个以上伦理原则冲突（Allen, 2012）；**道德问题/道德冲突（moral problem / moral conflict）**＝知道正确路径却因内外约束而无法行动；二者未解决可造成「**道德困扰（moral distress）**」。原文调查：**57% 受访者每周遇到 1-2 个伦理困境，34% 每周 3-5 个**；困难情形含**便利性安乐死（convenience euthanasia，对身心均健康的动物实施安乐死）**。安乐死方面：**身体与心理疾患均可构成理由**、**延迟安乐死会延长受苦**、**硫酸镁（MgSO4）与氯化钾（KCl）会造成痛苦的死亡，不被视为人道**（AVMA, Leary et al., 2013）。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'caution', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 四步法与其他常见道德问题', '6.4 四步法与其他常见道德问题

处理道德问题四步：**Exploration（探索）**——区分动物福利与其他伦理议题、识别法律问题；**Analysis（分析）**——识别**动物（患者）、兽医（你自己）、主人或监护人（客户）、诊所或商业机构（雇主）**等责任方；**Action（行动）**——列出所有行动（**不作为也是选项**）、与诊所政策一致、**有权礼貌地拒绝提供服务**；**Refinement（优化）**——考虑**当前与未来**福利，如**确保所有接受手术的动物获得充分镇痛**。原文另列议题：选择性繁育（**约束极端品种标准**）；美容性与便利性手术即**剪耳（ear cropping）、断尾（tail docking）、去爪（declawing）、声带切除（debarking）**，风险为**急慢性疼痛与限制自然行为**；先进治疗（**供体动物无法给出同意**）；客户保密（**只可在充分同意后披露**）；绝育（**更长期风险取决于生物性别、绝育时年龄、品种与物种**）；肥胖（**预期寿命与健康相关 QoL 均受损**）。原文强调**专业诚信（professional integrity）是关键**。

7. 第 5 章：就福利与主人的沟通

7.1 建议、以关系为中心的照护与依从性

建议（6 条）要点：维持并更新与客户、宠物主人（**包括动物繁育者**）、同僚及员工的沟通知识；**安乐死与经济问题等敏感话题需要特别的沟通方式**；管理挑战性客户（**囤积者 hoarders、「救助者 rescuers」**）；**防止同情疲劳（compassion fatigue）**；自信识别**不当对待（mistreatment）**情形。**以关系为中心的兽医照护模式（relationship-centred veterinary care model）**（Kanji et al., 2012）优势为**依从性改善、双方满意度提高、医疗过失索赔减少**；**依从性（compliance）**＝「患者遵循所开处方的**一致性与准确性**」（Verker et al., 2008）；**大多数客户只记得兽医在诊室中所说内容的 25% 至 50%**；**信心或自尊是影响行为改变成功最重要的决定因素之一**。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 沟通技能与虐待识别', '7.2 沟通技能与虐待识别

四项技能：**共情（empathy）**（Neumann et al., 2009）、**语言与非语言沟通**（**约 80% 的沟通是非语言的，20% 基于语言内容**，Shaw, 2006）、**开放式提问（open-ended questions）**（先开放式再收窄为**封闭式提问（closed questions）**）、**反映式倾听（reflective listening）**（Cornell and Kopcha, 2007）。

**主动型虐待（active animal abuse）**＝「**社会不可接受的行为（socially unacceptable behaviour）**」，即故意造成不必要的疼痛、受苦和/或死亡（Ascione, 1993），动物可能以**非意外性损伤（non-accidental injuries, NAI）**就诊；**忽视（neglect）或被动型 mistreatment**指不提供充分食物、庇护或必要的兽医照护，**可能源于无知或漠然**。**被毛可掩盖损伤征象**；**诊室里可能有两个受害者——动物与主人**（Ascione et al., 2007）；**必须把保护动物免于进一步伤害置于优先**（Animal Welfare Foundation, 2016）。

8. 第 6 章：外展——诊所以外的福利（Outreach）

8.1 建议与启动前考虑

建议（3 条）：推动**不仅改善诊所内、也改善更广泛社区中动物福利**的活动；与其他机构协作促进社区对福利的理解；推动制定福利与**负责任宠物饲养（responsible pet ownership）**的政策与立法。**2017 年 WSAVA 全球兽医职业调查**识别出的关键议题中许多（**预防医学不足、不当喂食与动物行为问题**）可通过教育解决；**主人倾向于拟人化（anthropomorphise）**。启动前考虑（5 项）：明确可投入的资源；优先处理对本地重要的议题；联系主要利益相关方；**了解你在法律上被允许做什么**；**从小处着手，往大处着想，慷慨行事（start small, think big, be generous）**。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'caution', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 外展的四个层级（图 12）', '8.2 外展的四个层级（图 12）

| 层级 | 原文列出的方式 |
|---|---|
| Level 1: Community engagement | **诊所开放日**、**犬只展示活动**、**捐献时间**（疫苗、绝育或微芯片服务）、**信息活动**、**学校参与**（**12 岁以下儿童被犬咬伤的风险最高**，Fein et al., 2018）、**媒体** |
| Level 2: Organisations, NGOs, Academia | **捐赠**、**筹款**、**地方兽医协会**、**科研合作**、**建议与培训**（**收容所医学原则：生物安全、卫生、预防性医疗保健、疾病识别**）、**低成本绝育与绝育券项目（Neutering voucher scheme）**、**报告动物虐待与家庭暴力** |
| Level 3: National Level | **兽医协会**、**人力（Manpower）**（灾害响应队成员）、**数据收集与分析**、**国家项目** |
| Level 4: International | **WSAVA 及其他兽医协会**、**政府间组织（INGOs）**（如 OIE）、**跨境志愿服务**（应**社会负责、遵守当地法规、尊重当地文化**） |

8.3 挑战与自查清单

**不要削弱本地兽医的地位，而要尽可能与其合作**；避免缺乏社会责任的「**voluntourism（志愿旅游）**」；慈善或志愿工作支持的动物应获得**与私人所有动物相同的最低兽医照护标准**（**有痛操作始终应提供镇痛**）；**务必在自身知识限度内工作——不应把志愿项目中的动物拿来供你练手**。', 'dog', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表', '9. 工具包（Toolkit）资源表

原文以表格列出主题与资源。**注意：抽取稿中该表版式被打乱（原为「Topic / Resource」两列，PDF 抽取后部分行合并、下划线 `_` 被抽成空格或 `_ _`）**；下表按原文顺序整理，链接文字保留抽取原样。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表 (2)', '| Topic（主题） | Resource（资源，原文文字/链接） |
|---|---|
| Animal Welfare Charter | Charter for Compassion: http://www.charterforanimalcompassion.com/ ；RSPCA Australia: http://kb.rspca.org.au/RSPCA-Australia-animals-charter 316.html |
| Animal Welfare learning | WSAVA Animal Welfare Modules: http://www.wsava.org/Committees/animal-wellness-and-welfare-committee ；World Animal Protection - Concepts in Animal Welfare: http://www.globalanimalnetwork.org/search/training |
| Behaviour Guidelines & Protocols | 2015 AAHA Canine and Feline Behavior Management Guidelines: https://www.aaha.org/professional/resources/behavior management guidelines.aspx ；AAHA''s Model Behavior Management Protocol: https://www.aaha.org/professional/resources/behavior management model protocol.as_px |
| Condition Score Charts (cats) | Body Condition Score: http://www.wsava.org/WSAVA/media/Arpita-and-Emma-editorial/chart cat horiz-June_ 2017.pdf ；Muscle Condition Score: http://www.wsava.org/sites/default/files/Muscle condition score chart-cats.pdf |
| Condition Score Charts (dogs) | Body Condition Score: http://www.wsava.org/WSAVA/media/PDF old/Body-condition-score-chart-dogs.pdf ；Muscle Condition Score: http://www.wsava.org/WSAVA/media/Documents/Committee Resources/Global Nutrition Committee/Muscle-condition-score-chart-2013-1.pdf |
| Environment (clinic & home) | AAFP and ISFM Feline Environmental Needs Guidelines: http://journals.sagepub.com/doi/pdf/10.1177/1098612X13477537 |
| Ethics | Animal Ethics Dilemma: http://www.aedilemma.net/ |
| Euthanasia Guidelines | AVMA Guidelines for the Euthanasia of Animals: https://www.avma.org/KB/Policies/Documents/euthanasia.pdf ；BVA (British Veterinary Association) Euthanasia of animals: http://www.bva.co.uk/Workplace-guidance/Ethical-guidance/BVA-Euthanasia-Guide/ ；IFAW (International Fund for Animal Welfare): http://www.ifaw.org/united-states/resource-centre/welfare-basis-euthanasia-dogs-andcats-and-policy-development |', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表 (3)', '| Euthanasia Policy | DVM360 Sample Euthanasia Protocol: http://veterinaryteam.dvm360.com/euthanasia-protocol ；Oregon State University Veterinary Teaching Hospital: http://128.193.215.68:12469/vth-policies/VTH/SA/AAHA Standards/PC59-Euthanasia-protocol.pdf |
| Forensic Forms | Veterinary Forensics: http://www.veterinaryforensics.com/forms/ |
| Handling & Restraint | AAFP and ISFM Feline-Friendly Handling Guidelines: http://journals.sagepub.com/doi/pdf/10.1016/j.jfms.2011.03.012 ；Dove & Lewis: https://www.atdove.org/ ；Fear Free Pets: https://fearfreepets.com/veterinary-professionals/ ；Low Stress Handling – Dr. Sophia Yin: https://www.lowstresshandling.com/ |
| Mobile apps | Dog Bite Prevention Strategy — Apple: https://dog-bite-prevention-strategy-ios.soft112.com/modal-download.html ；Android: https://dog-bite-prevention-strategy-ios.soft112.com/modal-download.html |
| Nursing care | AAFP and ISFM Feline-Friendly Nursing Care Guidelines: http://www.catvets.com/public/PDFs/PracticeGuidelines/NursingCareGLS.pdf |
| Nutrition Guidelines | WSAVA Global Nutrition Guidelines: http://www.wsava.org/Guidelines/Global-Nutrition-Guidelines |
| Pain Guidelines | WSAVA Global Pain Council Guidelines: http://www.wsava.org/Guidelines/Global-Pain-Council-Guidelines |
| Pain Scales for cats | Colorado State University Feline Acute Pain Scale: http://www.vasg.org/pdfs/CSU Acute Pain Scale Kitten.pdf ；UNESP-Botucatu multidimensional composite pain scale (MCPS): http://www.animalpain.com.br/assets/upload/escala-en-us.pdf |
| Pain Scales for dogs | Colorado State University Canine Acute Pain Scale: http://www.vasg.org/pdfs/CSU Acute Pain Scale Canine.pdf ；Glasgow Composite Measure Pain Scale (CMPS-SF): http://www.wsava.org/WSAVA/media/PDF old/Canine-CMPS-SF 0.pdf ；Helsinki Chronic Pain Index (HCPI): https://www.fourleg.com/media/Helsinki Chronic Pain Index.pdf ；Canine Brief Pain Inventory (Canine BPI): http://www.vet.upenn.edu/research/clinical-trials/vcic/pennchart/cbpi-tool |', '', 'young', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 工具包（Toolkit）资源表 (4)', '| Veterinary Oath | WSAVA Veterinary Oath: http://www.wsava.org/Guidelines/WSAVA-Global-Oath |', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 术语表（Glossary）', '10. 术语表（Glossary）

| 术语 | 原文定义 |
|---|---|
| Disease（疾病） | 「结构或功能的紊乱，尤其指产生特定临床征象或影响特定部位、且不单纯是物理损伤直接结果者」（Oxford English Dictionary, 2018）；识别举例为 **5 项生命评估（5 Vital assessments）：Temperature（体温）、Pulse（脉搏）、Respiration（呼吸）、Pain（疼痛）、Nutrition（营养）**（Freeman et al., 2011） |
| Injury / Pain / Suffering | 损伤＝**身体的、心理的或情感的损害（physical, psychological or emotional damage）**，细微损伤需有经验评估；疼痛＝**涉及感觉与情感成分的多维度体验**（同 4.8），**可被恐惧、记忆与应激修饰**；受苦＝**恐惧、疼痛与挫败等不愉快情绪的主观体验**，识别时须考虑环境、行为、营养与社会需求未获满足 |

11. 附录 1：处理疑似动物 mistreatment 或虐待的标准操作规程（SOP）

**每家兽医诊所都应具备处理疑似案件的政策、程序与预案**，并使全体员工知晓与受训；SOP（standard operating procedure）应含**随时可访问的参考资料库**：适用的**动物保护/虐待法律与兽医法规**（含**强制报告要求与免责（immunity）条款**）、调查机构与官员联系方式（**含非工作时间**）、授权报告的**清晰职权线（clear lines of authority）**、活体与死亡动物的记录、**保管链（chain of custody）**与照片方案；**死亡动物应保留至调查人员或检察机关授权放行**。', '', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'caution', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利指南2018要点 · 图目录与抽取残缺说明', '12. 图目录与抽取残缺说明

原文 Table of Figures 列出 Figure 1–12：1 Three overlapping animal welfare concepts (adapted from Fraser, 2008)（p12）；2 The welfare spectrum（p14）；3 Schematic showing the differences in outcome for animals when they are able to perform normal evolutionary behaviours and skills or if their environment does not allow these to occur（p14）；4 An ecological model of the interactions between companion animals, the veterinary clinic, the owner/guardian and the wider community（p16）；5 Five Domains Model of measuring animal welfare with examples in each Domain of the features being measured (from Mellor, 2017)（p21）；6 Animal welfare can be measured using Input-based measures and Output-based measures（p23）；7 Passive responders withdraw and avoid social interactions（p27）；8 Active responders are often vocal and may attempt to paw at passers-by（p27）；9 Traffic light system for assessing the animal''s emotional state（p28）；10 Cats benefit from perching and hiding places（p37）；11 For cats in wards/hospital cages, minimum recommended distances between litter tray, resting place, and food container. Adapted from Guidelines for Standards of Care in Animal Shelters (Attard et al., 2013)（p40）；12 Levels of outreach opportunities range from local to international（p69）。

> **抽取残缺说明**：Figure 1–12 均为图片，抽取稿只保留题注。**Figure 5 五域下属特征清单**、**Figure 6 输入/输出完整清单**、**Figure 9 交通灯分级条目**、**Figure 11 最小推荐距离数值**在本抽取稿中**原文此处缺失**，未以外部知识补全；**五大自由（Five Freedoms）的逐条内容**同样缺失（见 3.3）。第 1 章各国伴侣动物数量数据、第 3 章建议的完整长句、致谢与作者介绍、各章 References 为控制篇幅只作摘录式整理，未逐条照录。', 'cat', '', '', '动物福利,应激（stress）,文档基本信息,前言（Preamble）', 'informational', 'WSAVA 动物福利指南2018要点', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利宪章 · 文档基本信息', '1. 文档基本信息

- 文档名称：动物福利宪章（Animal Welfare Charter），文内标题为 **WSAVA Animal Welfare Charter**；署名机构（照录原文大写）`WSAVA ANIMAL WELLNESS & WELFARE COMMITTEE`。
- 版本年份：2020 年 2 月，该日期**来自文件名与 URL 路径 `2020/02`**；**宪章正文抽取文本中未出现任何成文日期或版本号——原文此处缺失**。
- 载体形态：3 页 PDF，抽取字符 1853（`needs_ocr: False`，无纯图片页）。从段落重复与项目符号 `»` 被单独抽取的情况看，应为折页／海报式排版，而非连续行文的报告。
- 签署方（signatories）：**原文此处缺失**。抽取稿不含签署人姓名、签字栏、会员协会（member association）批准名单或理事会决议编号。
- 通讯地址（原文照录）：`WSAVA Office 72 Melville Street Dundas, Ontario Canada L9H 2A1`；邮箱 `admin@wsava.org`。', '', '', '', '动物福利,文档基本信息,宪章开宗明义：感受力、福利定义与兽医责任,承诺条款（逐条列出）', 'informational', 'WSAVA 动物福利宪章（2020）', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利宪章 · 宪章开宗明义：感受力、福利定义与兽医责任', '2. 宪章开宗明义：感受力、福利定义与兽医责任

抽取稿首段为宪章的立场声明，原文完整照录（本稿唯一的英文整段引文，因定义与承诺均以此为据）：

> WSAVA recognises companion animals as sentient beings, capable of experiencing both positive and negative affective states and emotions. Companion animal welfare should be protected by decreasing negative experiences and promoting positive ones. WSAVA deﬁ nes animal welfare as the physical and psychological, social and environmental well-being of animals and believes that all veterinarians have a responsibility to lead and advocate for the best possible welfare outcomes.

逐句整理：

1. **动物感受力（sentience）**：WSAVA 承认伴侣动物（companion animals）为**有感觉能力的存在（sentient beings）**，能够体验**积极与消极的情感状态和情绪（positive and negative affective states and emotions）**。
2. **福利保护的方向**：伴侣动物福利（companion animal welfare）应通过**减少消极体验、促进积极体验**来加以保护。
3. **动物福利（animal welfare）定义（照录）**：动物的**身体与心理、社会及环境层面的康乐（the physical and psychological, social and environmental well-being of animals）**；该定义与《WSAVA 动物福利指南 2018》采用的定义一致。
4. **兽医责任**：**所有兽医（all veterinarians）都有责任为尽可能最佳的福利结局（the best possible welfare outcomes）进行引领与倡导（lead and advocate）**。', '', '', '', '动物福利,文档基本信息,宪章开宗明义：感受力、福利定义与兽医责任,承诺条款（逐条列出）', 'informational', 'WSAVA 动物福利宪章（2020）', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利宪章 · 承诺条款（逐条列出）', '3. 承诺条款（逐条列出）

宪章引导句在抽取稿中**出现两次**，原文为：

> WSAVA through our global companion animal veterinary community will strive for the betterment of animal welfare by:

即 **WSAVA 将通过我们的全球伴侣动物兽医共同体（global companion animal veterinary community），以下列方式致力于动物福利的改善（the betterment of animal welfare）**。其后的承诺条款共 **9 条**，项目符号在原文中为 `»`（抽取稿里被分离为 `» » » » »` 与 `» » » »` 两组，分别紧随两次出现的引导句）。**按抽取稿条目顺序逐条列出，措辞照录**：', '', '', '', '动物福利,文档基本信息,宪章开宗明义：感受力、福利定义与兽医责任,承诺条款（逐条列出）', 'informational', 'WSAVA 动物福利宪章（2020）', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利宪章 · 承诺条款（逐条列出） (2)', '| # | 原文（照录） | 中文整理 |
|---|---|---|
| 1 | utilising the Five Animal Welfare Needs as a framework to ensure human caregivers provide for the basic welfare requirements of animals, which includes the needs: …（五项需求见第 4 节） | **以「五大动物福利需求（Five Animal Welfare Needs）」为框架**，确保人类照护者（human caregivers）提供动物的基本福利要求 |
| 2 | considering animals in their wider ecological context and how decisions concerning animals impacts on wider society | 把动物置于其**更广阔的生态学语境（wider ecological context）**中考量，并考虑涉及动物的决策对更广泛社会的影响（原文 `impacts on` 语法如此） |
| 3 | continuously educating our veterinarians and veterinary teams on animal welfare and behaviour | 就动物福利与行为**持续教育我们的兽医与兽医团队（veterinary teams）** |
| 4 | protecting animals in disasters and including animals in disaster-relief programs | **在灾害（disasters）中保护动物**，并把动物纳入**灾害救援项目（disaster-relief programs）** |
| 5 | managing animal populations and disease control in the most humane manner available and acceptable by society | 以**现有最人道且为社会所接受的方式**进行**动物种群管理（managing animal populations）与疾病控制（disease control）** |
| 6 | promoting preventative healthcare and the practice of good veterinary standards including good pain management | 推动**预防性医疗保健（preventative healthcare）**与良好兽医标准的实践，**包括良好的疼痛管理（good pain management）** |
| 7 | providing relief from suffering through humane euthanasia if necessary | 必要时**通过人道安乐死（humane euthanasia）解除受苦（relief from suffering）** |
| 8 | educating the public on responsible pet ownership and their duty of care towards animals | 就**负责任宠物饲养（responsible pet ownership）**及其对动物的**照护义务（duty of care）**教育公众 |
| 9 | advocating both within the veterinary clinic and the community for the welfare of animals | **在兽医诊所（veterinary clinic）内外与社区中同时为动物福利发声倡导（advocating）** |', '', '', '', '动物福利,文档基本信息,宪章开宗明义：感受力、福利定义与兽医责任,承诺条款（逐条列出）', 'informational', 'WSAVA 动物福利宪章（2020）', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利宪章 · 承诺条款（逐条列出） (3)', '**顺序说明**：第 1–5 条与第 6–9 条在抽取稿中分属两个文本块，两块的相对先后无法由抽取顺序确定（疑为折页正反面各自重复引导句所致）；本稿按抽取稿出现先后编号，不重新排序、不合并。

**条款内容缺失说明**：抽取稿仅呈现上述 9 条，**未见任何条款的解释文字、实施指引、评估指标或修订记录——原文此处缺失**。', '', '', '', '动物福利,文档基本信息,宪章开宗明义：感受力、福利定义与兽医责任,承诺条款（逐条列出）', 'informational', 'WSAVA 动物福利宪章（2020）', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利宪章 · 五大动物福利需求（Five Animal Welfare Needs）', '4. 五大动物福利需求（Five Animal Welfare Needs）

第 1 条承诺所引用的框架，五项需求在原文中以 `*` 列出，**顺序与措辞照录**：

1. 对适宜环境的需求（for a suitable environment）
2. 对适宜饮食的需求（for a suitable diet）
3. 能够表达正常行为模式的需求（to be able to exhibit normal behaviour patterns）
4. 与其他动物同住或分开安置的需求（to be housed with, or apart from, other animals）
5. 免受疼痛、受苦、损伤和疾病的需求（to be protected from pain, suffering, injury and disease）

宪章对该框架的定位是：**确保人类照护者提供动物的基本福利要求（the basic welfare requirements of animals）**，未对其作进一步展开或评分方法说明。

- **五大自由（Five Freedoms）：本宪章抽取稿中未出现**——原文此处缺失（其由来见《WSAVA 动物福利指南2018要点》第 3.3 节）。
- **五域模型（Five Domains Model）：本宪章抽取稿中未出现**——原文此处缺失（见同一整理稿第 4.2 节）。

5. WSAVA 愿景（Our WSAVA Vision）

宪章末节标题为 `Our WSAVA Vision`，愿景为直接引语：

> "All companion animals worldwide receive the veterinary care that ensures their optimal health and welfare."

中文整理：**「全世界所有伴侣动物都能获得确保其最佳健康与福利的兽医照护（veterinary care）。」**', '', '', '', '动物福利,文档基本信息,宪章开宗明义：感受力、福利定义与兽医责任,承诺条款（逐条列出）', 'informational', 'WSAVA 动物福利宪章（2020）', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('WSAVA 动物福利宪章 · 宪章与《WSAVA 动物福利指南 2018》的关系', '6. 宪章与《WSAVA 动物福利指南 2018》的关系

- 2018 指南第 1 章建议诊所制定**书面动物福利宪章（animal welfare charter）**，并把「是否有明示政策承诺」「是否有书面宪章」「全员是否理解」「是否已向客户与社区传达」列入自查清单；其工具包（Toolkit）表的 **Animal Welfare Charter** 主题下亦列出外部宪章资源。本宪章是 WSAVA 自身发布的范本，两者构成「范本—落地要求」的对应关系。
- 术语一致点：**动物福利定义（身体与心理、社会及环境的康乐）**、**五大动物福利需求**、兽医作为福利倡导者的责任、以及**在兽医诊所与社区两个层面的倡导**、**负责任宠物饲养（responsible pet ownership）**。
- 分工差异：宪章为**一页式承诺声明**（立场 + 9 条承诺 + 愿景 + 地址）；2018 指南为 80 页操作性文件。宪章**不含测量方法、疼痛量表、伦理理论与标准操作规程（SOP）等技术内容**，其术语表对 Disease / Injury / Pain / Suffering 的定义**在宪章抽取稿中均未出现——原文此处缺失**。

7. 抽取稿质量与残缺清单

- 抽取器 `pymupdf-block-heuristic`；连字残缺：原文 `deﬁ nes`、`Ofﬁce` 含 `ﬁ` 连字，本稿引用时照录或写作 `defines`、`Office`。
- 项目符号错位：`» » » » »` 与 `» » » »` 与条目文字被抽取到不同位置，条目与符号的对应需按数量推断（5 + 4 = 9 条）。
- 标题层级混乱：引导句被抽取为重复的 `##`/`###` 标题，中间夹入 WSAVA 地址行，故**宪章的实际版面顺序无法由抽取稿确定**。
- **原文此处缺失**汇总：成文日期与版本号；签署方／批准主体名单与签字栏；页眉页脚与版权信息；条款的解释、实施与监测说明；五大自由与五域模型；任何图表、参考文献、致谢；除署名委员会外的编写者姓名。', '', '', '', '动物福利,文档基本信息,宪章开宗明义：感受力、福利定义与兽医责任,承诺条款（逐条列出）', 'informational', 'WSAVA 动物福利宪章（2020）', 'official', 'https://wsava.org/global-guidelines/animal-welfare-guidelines/', 'approved'),
('Dental Guidelines · 第 1 段', 'Dental Guidelines（全球牙科指南）

板块页面正文（原文）

Guidelines

Dental

Executive Summary

With oral and dental disease the most common medical conditions affecting companion animals, these Global Guidelines aim to highlight the importance of veterinary dentistry and give advice on best practice to raise standards of dental practice around the world.

Resources

- **NEW: [2026 WSAVA Global Dental Guidelines](https://onlinelibrary.wiley.com/doi/epdf/10.1111/jsap.70057)**
- [Pet Dental Scoring](https://pds.e-vds.vet/)
- [Introducing Toothbrushing](https://wsava.org/wp-content/uploads/2022/06/GDC-Toothbrushing-Toolkit-1.pdf)
- [The 3 questions in Oral Cancer](https://wsava.org/wp-content/uploads/2023/03/GDC-Oral-Cancer.pdf)', '', '', '', '口腔护理,板块页面正文（原文）,Guidelines,Dental', 'informational', 'Dental Guidelines', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('Dental Guidelines · Guidelines Translations', '2019 Guidelines Translations

- [Greek](https://wsava.org/wp-content/uploads/2020/01/WSAVA-dental-guidelines-Greek.pdf)
- [Korean](https://wsava.org/wp-content/uploads/2020/01/WSAVA-dental-guideline-Korean-translation.pdf)
- [Mandarin](https://wsava.org/wp-content/uploads/2021/05/WSAVA-Global-Dental-Guidelines-JSAPMandarin.pdf)
- [Thai](https://wsava.org/wp-content/uploads/2023/11/WSAVA_deatal-guideline-thaiversion.pdf)
- [Portuguese](https://wsava.org/wp-content/uploads/2020/01/Directrizes-Dentarias-Globais-da-World-Small-Animal-Veterinary-Association.pdf)
- [Spanish](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Dental-Guidelines-Spanish.pdf)
- [Russian](https://wsava.org/wp-content/uploads/2023/08/WSAVA-Global-Dental-Guidelines-JSAP-version_Rus.pdf)

Downloads

Global Dental Guidelines

[Read in JSAP](https://onlinelibrary.wiley.com/doi/epdf/10.1111/jsap.70057)', '', '', '', '口腔护理,板块页面正文（原文）,Guidelines,Dental', 'informational', 'Dental Guidelines', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('Dental Guidelines · Endorsements', 'Endorsements

- Academy of Veterinary Dentistry (AVD)
- All-Ukrainian Union of Veterinary Dentists (BCBC)
- Asociacion de Veterinarios Espanoles Especialistas en Pequenos Animales (AVEPA)
- Associação Brasileira de Odontologia Veterinária
- Associacao Portugesa de Medicos Veterinarios Especialistas em Animais de Companhia (APMVEAC)
- Bulgarian Association of Small Animal Veterinarians (BASAV)
- Canadian Veterinary Medical Association (CVMA)
- Companion Animal Veterinaries, New Zealand Veterinary Association (CVA)
- Croatian Small Animal Veterinary Section (CSAVS)
- Czech Small Animal Veterinary Association (CSAVA)
- Hellenic Companion Animal Veterinary Society(HCAVS)
- Hellenic Veterinary Medical Society (HVMS)
- International Society of Feline Medicine (ISFM)
- International Veterinary Academy of Pain Management (IVAPM)
- Japanese Study Group of Veterinary Maxillofacial Oral Surgery
- Kenyan Small and Companion Animal Veterinary Association (KESCAVA)
- Lithuania Small Animal Veterinary Association (LSAVA)
- Macedonian Small Animal Veterinary Association (MSAVA)
- Montenegro Association of Small Animal Practitioners (MASAP)
- Netherlands Association of Companion Animal Medicine (NACAM)
- Norwegian Small Animal Vets Association (NSAVA)
- Philippine Animal Hospital Association (PAHA)
- Polish Small Animal Veterinary Association (PSAVA)
- Slovene Small Animal Veterinary Association (SZVMZ)
- Small Animal Veterinary Association Belgium- Flanders SAVAB -Flanders)
- Spanish Veterinary Dental and Maxillofacial Surgery Society (SEOVE)
- Swedish Veterinary Dental Association (SSDt)
- Veterinary Association of Namibia (VAN)
- Veterinary Ireland (VICAS)', '', '', '', '口腔护理,板块页面正文（原文）,Guidelines,Dental', 'informational', 'Dental Guidelines', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('Dental Guidelines · 本板块文档清单', '本板块文档清单

共 9 份 PDF，按「英文 + 中文」策略收录 3 份，跳过小语种译本 6 份。

已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Introducing Toothbrushing | EN | 2022 版 | 2 | 3978 | [raw_extracts/GDC-Toothbrushing-Toolkit-1.md](raw_extracts/GDC-Toothbrushing-Toolkit-1.md) |
| The 3 questions in Oral Cancer | EN |  | 2 | 1552 | [raw_extracts/GDC-Oral-Cancer.md](raw_extracts/GDC-Oral-Cancer.md) |
| WSAVA Global Dental Guidelines JSAPMandarin | ZH |  | 127 | 213989 | [raw_extracts/WSAVA-Global-Dental-Guidelines-JSAPMandarin.md](raw_extracts/WSAVA-Global-Dental-Guidelines-JSAPMandarin.md) |', '', '', '', '口腔护理,板块页面正文（原文）,Guidelines,Dental', 'informational', 'Dental Guidelines', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('Dental Guidelines · 未收录（同一指南的其他语言译本）', '未收录（同一指南的其他语言译本）

- WSAVA-dental-guidelines-Greek.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-dental-guidelines-Greek.pdf>
- WSAVA-dental-guideline-Korean-translation.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-dental-guideline-Korean-translation.pdf>
- WSAVA_deatal-guideline-thaiversion.pdf — 原链接 <https://wsava.org/wp-content/uploads/2023/11/WSAVA_deatal-guideline-thaiversion.pdf>
- Directrizes-Dentarias-Globais-da-World-Small-Animal-Veterinary-Association.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/Directrizes-Dentarias-Globais-da-World-Small-Animal-Veterinary-Association.pdf>
- WSAVA-Dental-Guidelines-Spanish.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-Dental-Guidelines-Spanish.pdf>
- WSAVA-Global-Dental-Guidelines-JSAP-version_Rus.pdf — 原链接 <https://wsava.org/wp-content/uploads/2023/08/WSAVA-Global-Dental-Guidelines-JSAP-version_Rus.pdf>

外部引用（期刊论文 / 相关机构，未抓取正文）

- 2026 WSAVA Global Dental Guidelines — <https://onlinelibrary.wiley.com/doi/epdf/10.1111/jsap.70057>
- Pet Dental Scoring — <https://pds.e-vds.vet/>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '口腔护理,板块页面正文（原文）,Guidelines,Dental', 'informational', 'Dental Guidelines', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 第 1 段', 'WSAVA全球牙科指南要点

> 说明：本稿依据《WSAVA 全球牙科指南（Global Dental Guidelines）》官方中文译本（Journal of Small Animal Practice 专刊，页码 E36–E161）整理；数值、分级档位、牙齿编号与英文原词照抄原文，抽取残缺处标注「原文此处缺失」，不自行补全。

1. 指南框架与分层

正文 9 节：1 口腔解剖学与常见病变；2 动物福利问题；3 麻醉与疼痛管理；4 口腔检查与记录；5 牙周治疗（含牙科居家照护）；6 牙科放射线学；7 拔牙；8 大学对于牙科教育的重要性；9 必要设备；另附「对于无麻醉牙科操作（Anaesthesia Free Dentistry, AFD）的立场声明」与参考文献。

按资源可及性分第 1／2／3 层继续教育要求，国家/地区对应分为第一类、第二类、第三类国家；设备、麻醉与影像章节全按此分级。影像：第一类与某些第二类国家/地区以传统放射学技术为最低可接受标准，可以的话应拍摄牙科 X 光；第三类国家/地区视为最低标准。

核心信息：牙周疾病（periodontal disease）是小动物最常见健康问题之一；所有牙科操作必须在全身麻醉下完成；牙科 X 光影像是检查不可分割的一部分；口腔检查必须系统性且可重复并记录在牙科记录表上。

2. 第 1 节：口腔解剖学与常见病变

2.1 齿列式（原文照抄）

| 齿列式 | 总数 |
|---|---|
| 成犬：2（I 3/3 : C 1/1 : P 4/4 : M 2/3） | = 42 |
| 幼犬：2（i 3/3 : c 1/1 : p 3/3） | = 28 |
| 成猫：2（I 3/3 : C 1/1 : P 3/2 : M 1/1） | = 30 |
| 幼猫：2（3/3 : c 1/1 : p 3/2） | = 26 |

犬猫为双套齿（diphyodont）、单套齿（anelodont）、低冠齿（brachydont）齿列；犬齿是最大的单牙根牙齿；牙釉质（enamel）厚 0.1–1 mm，仅在萌发前由造釉细胞（ameloblasts）分泌。', '', 'young', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('WSAVA全球牙科指南要点 · 牙周疾病关键数据', '2.2 牙周疾病关键数据

2 岁时 70% 的猫、80% 的犬患牙周疾病，近期研究述及所有病患近 90% 发病率；小型犬与玩具犬特别易发。牙龈炎（gingivitis）仅限牙龈、为初始可逆阶段；牙周炎（periodontitis）累及牙周韧带、牙骨质与齿槽骨。囊袋大于 3 mm（犬）或 0.5 mm（猫）即诊断为牙周囊袋。牙菌斑（plaque）为生物膜（biofilm），24 小时内即附着于清洁牙齿；每公克牙菌斑与牙结石（calculus）可含多达 100,000 亿（10^12）个细菌，生物膜内细菌抗药性为 1,000–1,500 倍、需 50 万倍消毒剂浓度才能杀灭。牙周疾病并非由细菌数量增加诱发，而与口腔微生物群改变有关。牙结石本身相对非致病性；只控制牙龈上牙菌斑（supragingival plaque）无效，必须处理牙龈下牙菌斑（subgingival plaque）。

2.3 AVDC 牙齿折断分类（原表仅剩空表头，「原文此处缺失」；下表按原文 E65 用词重建）

| 缩写 | 病变 |
|---|---|
| T/FX/EI | 牙釉质裂痕（Enamel Infraction）：牙釉质不完全折断，无牙齿物质损失 |
| T/FX/EF | 牙釉质折断（Enamel fracture）：局限于牙釉质、造成牙冠物质损失 |
| T/FX/UCF | 不涉及牙髓的牙釉质/牙本质折断（可含牙骨质，随物种而异） |
| T/FX/CCF | 涉及牙釉质与牙本质并使牙髓裸露 |
| T/FX/UCRF | 涉及牙釉质、牙本质与牙骨质但牙髓未裸露 |
| T/FX/CCRF | 涉及牙釉质、牙本质与牙骨质且牙髓裸露 |
| AB | 牙齿与非牙齿组织接触造成的磨损 |
| AT | 牙齿与其他牙齿接触造成的磨损 |
| EH | 牙釉质发育不良/矿化不全 |

49.6% 伴侣动物有折断的牙齿；10% 的犬牙髓直接裸露（复杂性牙冠折断）；50% 的大型犬有非复杂性牙冠折断伴疼痛性牙本质裸露；92% 染色的牙齿已失去活性。牙髓裸露或影像显示失活/根尖周发炎者需拔牙或根管治疗；仅牙釉质或牙本质缺损者只需平整锐利边缘。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 齿吸收（tooth resorption, TR）', '2.4 齿吸收（tooth resorption, TR）

噬牙细胞作用导致牙齿硬组织损失；分生理性（乳齿牙根吸收）与病理性（本准则只讨论病理性）。猫 28.5–67%；犬经放射学检查 53.6%；228 只临床健康猫的调查中下颌第三前臼齿（307, 407）最常受累且多为对称发展。猫可见 2 种类型（T1、T2），犬可见 7 种类型；最佳治疗方式是拔牙。

| 放射学分型 | 表现 |
|---|---|
| 第 I 型（T1） | 牙周韧带间隙宽度正常，牙齿局部或全面放射线透明度降低 |
| 第 II 型（T2） | 特定区域牙周韧带间隙变窄或消失，一部分牙齿放射线不透明度降低；可见取代性吸收（replacement resorption） |
| 第 III 型（T3） | 同一牙齿同时存在第 I 型与第 II 型征象 |

| 分期（AVDC Nomenclature Committee 2019） | 定义（原文照抄） |
|---|---|
| 第 1 期（TR 1） | 轻度牙齿硬组织损失（牙骨质或牙骨质与牙釉质） |
| 第 2 期（TR 2） | 中度损失（伴牙本质损失但未延伸至牙髓腔） |
| 第 3 期（TR 3） | 深层损失（伴牙本质损失并延伸到牙髓腔）；多数牙齿保有完整性 |
| 第 4 期（TR 4） | 广泛损失（伴牙本质损失并延伸到牙髓腔）；多数牙齿失去完整性 |
| TR4a／TR4b／TR4c | 牙冠与牙根受影响程度相等／牙冠受损比牙根更大／牙根受损比牙冠更大 |
| 第 5 期（TR 5） | 仅可观察到不规则放射线不透明度的牙齿硬组织残留物，并且牙龈完全覆盖 |', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 第 2 节：动物福利', '3. 第 2 节：动物福利

80% 与 70% 的两岁龄犬猫存在牙周炎（periodontitis）证据，有些研究述及 90%；20–75% 成猫表现齿吸收病变症状。未观察到明显行为改变不代表疼痛不存在，也不能反映病灶严重程度；动物即使剧烈牙痛仍可能持续进食。建议治疗后 2 周及 2 个月各追踪一次。

表 1（原文表体被打散为项目符号并混入正文，原栏位「原文此处缺失」，按原文顺序重建）：

| 序号 | 牙痛可能引起之明显可见变化 |
|---|---|
| 1 | 宠物与饲主之间的互动模式改变 |
| 2 | 过度流涎 |
| 3 | 攻击性 |
| 4 | 躲藏 |
| 5 | 睡眠型态受影响 |
| 6 | 理毛次数减少 |
| 7 | 进食行为改变 |
| 8 | 食物偏好改变：从硬食变成软食 |
| 9 | 狼吞虎咽：吞下整块食物而没有咀嚼 |
| 10 | 单侧咀嚼 |
| 11 | 舔嘴唇 |
| 12 | 牙齿打颤 |
| 13 | 磨牙：特别是在猫 |
| 14 | 舌头垂露在嘴巴外 |
| 15 | 玩耍行为改变 |
| 16 | 食物或水盆中有血 |
| 17 | 鼻子流出血液分泌物 |
| 18 | 摩擦脸部或用手掌搔抓脸部 |
| 19 | 口鼻部周围脱毛 |
| 20 | 患猫不再对人磨蹭脸部表达情感 |
| 21 | 食物掉到食盆外：不愿意咀嚼 |

4. 第 3 节：麻醉与疼痛管理（麻醉安全要点）

麻醉计划须依每个病患的需求、风险评估、共存疾病与药物取得性量身定制；血清生化学与血液学检查结果鲜少影响麻醉计划。麻醉相关死亡率 0.05–0.3%；简单周边脉搏触诊加脉搏血氧饱和度监测（pulse oximetry）可使猫的麻醉相关死亡风险降低 80%。

4.1 表 2：ASA 身体状况分类系统（ASA House of delegates, 2014）

| ASA 分类* | 定义 |
|---|---|
| ASA I | 正常健康的病患 |
| ASA II | 轻度全身性疾病病患 |
| ASA III | 重度全身性疾病病患 |
| ASA IV | 重度全身性疾病且持续危及生命的病患 |
| ASA V | 濒死且如果不立即进行手术，预期无法存活的病患 |
| * | 每个分类可进一步细分为「E」，表示紧急手术 |', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'caution', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 表 3：用于犬猫之镇静、麻醉前给药和化学保定的药物', '4.2 表 3：用于犬猫之镇静、麻醉前给药和化学保定的药物

| 药物 | 剂量范围** | 原文括注 |
|---|---|---|
| Acepromazine | 0.01–0.05 mg/kg IM, IV, SC | 猫仅轻度镇静 |
| Diazepam† | 0.2–0.5 mg/kg IV | 肌注吸收不佳 |
| Midazolam† | 0.2–0.5 mg/kg IM 或 IV | 合并 ketamine/propofol 诱导 |
| Xylazine | 0.2–0.5 mg/kg IM, IV | 无 (dex)medetomidine 时的替代 |
| Dexmedetomidine | 1–10 μg/kg IM, IV | 高剂量合并 ketamine 与鸦片类（"doggy"/"kitty magic"） |
| Medetomidine | 10–20 μg/kg（OTM）（猫） | 效力为 dexmedetomidine 一半 |
| Ketamine | 6–20 μg/kg IM, IV | 猫仅合并 midazolam 与鸦片类 |
| Alfaxalone | 3–10 mg/kg IM 或 PO；0.5–1 mg/kg IM | 猫仅合并 midazolam 与鸦片类 |

脚注：*静脉注射时应降低剂量；**用于牙科治疗；†Benzodiazepines 于年轻健康病患常观察到逆理性镇静。

4.3 表 4：用于麻醉诱导和注射型麻醉的药物

| 药物 | 剂量范围 | 原文括注 |
|---|---|---|
| Alfaxalone | 0.5–3 mg/kg IV；最高 3–5 mg/kg IV（无麻醉前给药者） | 渐给予至见效；恢复期可能激动 |
| Propofol | 0.5–4 mg/kg IV | 猫可能需 6–8 mg/kg；心肺疾病与低血容慎用 |
| Ketamine | 2–5 mg/kg IV（诱导）；2–20 μg/kg/min IV（输注） | 切勿单独使用；拮抗 NMDA 受体 |
| Thiopental | 2.5–5 mg/kg IV | 仅无其他药物时；只能静脉注射 |
| Tiletamine-zolazepam | 1–2 mg/kg IV | 仅无挥发性麻醉剂时；须合并止痛药 |

挥发性麻醉剂（isoflurane、sevoflurane）为维持首选；平衡式麻醉（balanced anaesthesia）可降低麻醉剂浓度以避免低血压。麻醉期间泪液生成减少，应至少每小时润滑眼睛一次。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'caution', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 表 5：经常用于动物麻醉和疼痛管理的局部麻醉剂', '4.4 表 5：经常用于动物麻醉和疼痛管理的局部麻醉剂

| 局部麻醉剂* | 起效时间（分钟） | 常用浓度（%） | 阻断时间（小时） | 相对效力（lidocaine = 1） | 建议最高剂量（mg/kg） |
|---|---|---|---|---|---|
| Lidocaine | 5–15 | 1, 2 | 1–2 | 1 | 10（犬）／5（猫） |
| Mepivacaine | 5–15 | 1, 2 | 1.5–2.5 | 1 | 4（犬）／2（猫） |
| Bupivacaine | 10–20 | 0.25, 0.5, 0.75 | 4–6 | 4 | 4（犬）／2（猫） |
| Ropivacaine | 10–20 | 0.5, 0.75 | 3–5 | 3 | 3（犬）／1.5（猫） |
| Levobupivacaine | 10–20 | 0.5, 0.75 | 4–6 | 4 | 2（犬）／1（猫） |
| * | 注射量 0.25–1 mL 依体型、解剖结构与体重而异；可按手术时长与术后止痛需要重复注射 | | | | |', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 第 2 段', '4.5 表 6：犬猫口腔疾病手术治疗的术中疼痛控制组合示例（剂量见表 3、4、5；所有病例都应按目标区域使用眶下、下齿槽、上颌、腭、颏神经阻断）

| 组合类型 | 方案（原文压缩） |
|---|---|
| 不受药物取用性影响 | 前驱 acepromazine + α-2 受体致效剂（dexmedetomidine、xylazine、medetomidine），或 midazolam + 鸦片类；诱导 IV propofol 3–5 mg/kg、ketamine 5 mg/kg + diazepam 或 midazolam 0.25 mg/kg，或 alfaxalone 2–5 mg/kg；维持 isoflurane 或 sevoflurane；术后 NSAID，按疼痛程度可重复鸦片类 |
| 没有管制药物 | 前驱 acepromazine 或 α-2 受体致效剂 + 注射型 tramadol；诱导 IV propofol 3–10 mg/kg、alfaxalone 2–5 mg/kg 或 tiletamine/zolazepam 1–2 mg/kg；维持 halothane、isoflurane、sevoflurane 或 IV propofol/alfaxalone 或 tiletamine/zolazepam；术后 NSAIDs；犬可用 metamizol（dipyrone 25 mg/kg IV q12h）或 acetaminophen（paracetamol 12.5 mg/kg PO q12h），猫不能这么做 |
| 受限止痛药物取用性 | 前驱 xylazine；诱导与维持 IV pentobarbital 2–5 mg/kg、thiopental 2–8 mg/kg、propofol 3–5 mg/kg，或 IV/IM tiletamine/zolazepam；术后同上 |', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 麻醉安全要点', '4.6 麻醉安全要点

局部麻醉：常用量 0.1–0.2 mL（猫）／0.2–1 mL（犬）；lidocaine 高于 10 mg/kg（犬）、5 mg/kg（猫），bupivacaine 高于 2 mg/kg（犬猫）可诱发癫痫、心肺抑制、昏迷和死亡，猫用量须计入气管插管用的 lidocaine 喷雾。局部麻醉剂在发炎组织中以离子形式为主而可能无效，应在非发炎区域阻断；脓疡或肿瘤处避免阻断。原文 5 种阻断：下齿槽神经、腭神经、眶下神经（不一定能麻醉治疗侧上颌第四前臼齿与第一或第二臼齿，拔这些牙应考虑上颌神经阻断；针头只前进约 2 mm 以免眼睛穿刺伤）、中颏神经（猫与小型犬孔很小不应穿刺）、上颌神经（可经眶下入路置导管约 2–4 mm）。

猫的张口器（mouth gag）：猫麻醉期间的危险因子，也是口腔手术后暂时性与永久性麻醉后失明的原因之一；持续应力可压迫供应视网膜与大脑的上颌动脉（maxillary artery）——嘴巴过度张开使下颌骨角突（angular process）与鼓泡（tympanic bulla）间距缩短而该动脉流经其间。弹簧式张口器（spring-loaded mouth gags）不应使用；可用裁切好的注射器针筒等适当尺寸塑胶张口器，仍须尽量减少使用并定期松开/移除。

其他：须配合气囊式气管插管并填塞口咽，避免过度充气（猫可致气管受损/坏死），翻身前先断开呼吸回路；口腔手术术中晶体输液 2–3 mL/kg/hour，低于外科手术 5 mL/kg/hour；平均血压维持 70 mmHg 以上；理想以二氧化碳分析仪（capnograph）监测呼吸；体温维持 37–38 °C（98.6–100.4 °F）；ASA III 级或更高应转介麻醉进阶训练兽医师。疼痛是第四个生命徵象；应制定涵盖术中与出院后数天至一周的多模式止痛（multimodal analgesia）计划。

5. 第 4 节：口腔检查与记录（牙科评估流程）', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'caution', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 清醒检查与表 7 口腔健康指标', '5.1 清醒检查与表 7 口腔健康指标

第一步都是搜集基础最低临床数据。口腔健康指标（Oral Health Index, OHI）（Gawor et al., 2006）由清醒病患基础检查建立，项目含淋巴结、牙结石堆积、发炎状态、饮食与居家照护，逐项评分后计算总分。

表 7（原文抽取中「表 7」标签与咬合段落错乱合并为「為表骨7性咬合不正或單一結構錯位」，该句「原文此处缺失」；下表依抽取内容重建，最右列为原文样例记录）：

| 项目 | 评分选项 | 对应分值 | 样例得分 |
|---|---|---|---|
| 淋巴结 | 正常／可摸到／肿大 | 0 1 2 | 0 |
| 牙结石堆积 | 无／低于 25% 的牙冠／低于 50% 的牙冠／低于 75% 的牙冠 | 0 1 2 3 | 1 |
| 发炎状态 | 无发炎／牙龈炎／牙周炎／口腔炎 | 0 1 3 3 | 0 |
| 饮食 | 干粮／软质干粮／软质食物 | 0 1 2 | 2 |
| 居家照护 | 每日主动口腔照护／被动及（或）偶尔主动／无 | 0 1 2 | 2 |
| 总分 | | | 5 |

| 结果 | 建议 |
|---|---|
| 0–3 分 | 预防保健建议 |
| 4–7 分 | 需要积极的改变，并可能需要进行手术 |
| 8–12 分 | 需要尽快进行手术 |

咬合：依 AVDC 命名委员会（2019），理想咬合为「上颌与下颌牙齿牙尖完美对合」。牙齿咬合检查表（Gorrel 2004）：1 头部对称性；2 门齿关联性；3 犬齿咬合；4 前臼齿对合；5 后前臼齿/臼齿咬合；6 每颗牙齿的位置。', 'dog', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 全身麻醉下的详细检查步骤（原文 14 步）', '5.2 全身麻醉下的详细检查步骤（原文 14 步）

全面检查只有在全身麻醉下才能完成；建议四手操作（一人记录）。原文 14 步如下，其中第 6「初步洁牙」与第 7「术中照片」在本稿中合并为第 6 项：

1. 检查口咽（插管与填塞喉咙前）：咽门、口咽与扁桃腺。
2. 拍摄术前照片：左右两侧及头顶往后视图，用嘴唇牵引器 lip retractor 或牙科镜 dental mirror。
3. 减少细菌数量：0.12% chlorhexidine 漱口液冲洗。
4. 评估并确定齿列（乳牙、恒牙或混合）。
5. 评估软组织：黏膜颜色、湿润度、肿胀，嘴唇与脸颊、腭、舌头与舌下组织、口腔团块。
6. 初步洁牙（刮牙器）与术中照片。
7. 牙科探针检查每颗牙（由每象限第一门齿向后）：a 存在或缺失（缺牙症 hypodontia、阻生齿、牙根滞留、赘生齿 supernumerary teeth；发现「缺失」都建议拍 X 光）；b 表面粗糙（折断、牙釉质缺损/矿化不全、龋齿、磨耗/磨损、齿吸收）；c 颜色（内因性染色紫/黄/粉/灰暗示牙髓已失去活性，需根管治疗 root canal therapy 或拔除）。
8. 牙周检查：a 牙周探测深度 periodontal probing depth, PPD（带刻度探针环绕整颗牙，记录 4–6 个位置；犬正常 0–3 mm、猫正常 0–1 mm）；b 牙龈肿大形成假性囊袋；c 牙龈萎缩；d 根叉病变；e 摇动性；f 全口牙周评分 Total Mouth Periodontal Score, TMPS。
9. 拍摄牙科放射学影像。
10. 牙周疾病分期（合并临床与 X 光，AVDC 2019）。
11. 专业洗牙与抛光。
12. 辅助治疗：依肉眼、触觉与放射学结果定最终治疗计划。
13. 术后 X 光影像及照片。

没有牙科 X 光辅助下的分期非常不准确，但无法取用时仍可能有帮助。

5.3 记录与 Triadan 牙齿编号

检查结果必须记录在牙科记录表上以制定治疗计划，并作为病历的一部分。最广泛应用 Triadan 系统，猫用改良式 Triadan 系统（Floyd 1991）：每颗牙三位数代码，第一位为象限（顺时针从右上颌开始，永久齿列 1–4、乳牙 5–8），后两位为象限内位置，由中线第一门齿开始编号；犬齿始终为 04，第一臼齿为 09（例左上颌第四前臼齿 208）。常见标记：圆圈表示牙齿缺失（O）、井号表示牙齿折断（#）、叉叉表示需拔除的牙齿（X）。记录表可从 http://cpd.vetdent.eu 免费下载；欧洲兽医牙科学会（European Veterinary Dental Society）提供免费线上电子兽医牙科评分系统（www.evds.org）。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 第 5 节：牙周治疗与专业洁牙', '6. 第 5 节：牙周治疗与专业洁牙

牙菌斑清除与控制由四方面组成（Niemiec 2008c）：1 专业的牙科清洁（曾称牙科预防、清洁、口腔 ATP〔assessment、treatment、prevention〕或 COHAT〔全面口腔健康评估与治疗 Comprehensive Oral Health Assessment and Treatment〕）；2 居家照护；3 牙周手术；4 拔牙。所有专业牙周治疗必须在全身麻醉下并使用充分充气的气囊式气管插管；非专业洗牙会导致牙周疾病严重恶化（Stella JL et al. 2018）。

专业牙科清洁 11 个步骤（原文顺序）：1 术前检查与评估（理学与口腔检查、筛查危害麻醉安全的全身性问题、与饲主讨论病程并估算时间）；人员与病患防护（洗牙机产生大量带细菌气雾，操作者佩戴口罩、护目镜、手套，建议细菌滤水器或 chlorhexidine 冲洗系统）；2 Chlorhexidine 冲洗（0.12% 或 0.2% 葡萄糖酸氯己定 chlorhexidine gluconate；完整牙科清洁属轻度侵入性、会造成短暂菌血症 bacteraemia）；3 牙龈上区域清洁（牙结石钳 calculus forceps 移除大量牙结石须小心；机械式与手动式最好合并）；4 清除牙龈下牙菌斑与牙结石（最重要步骤）；5 确认残留（探针查粗糙区、牙菌斑显示液或空气干燥）；6 抛光（橡胶抛光杯 rubber prophy cup 配慢速手机以 90 度角，转速不超过 3,000 RPM，单颗牙一次最长 5 秒）；7 牙龈沟灌洗（22–25 gauge 钝头套管，多数偏好 0.12% Chlorhexidine）；8 牙周探测、口腔评估与绘制牙科记录表（每颗牙 6 个位置；犬正常牙龈沟 0–3 mm，猫 0–0.5 mm）；9 牙科放射学影像（至少针对每个病变区域，许多研究支持全口 X 光）；10 拟定治疗计划；11（非必要）牙科封填剂（疏水性蜡基封填剂 hydrophobic wax-based sealer 需每周在家涂凝胶，或 VOHC 认可的自固化型亲水性聚合物由兽医人员施用）。

| 器械参数（原文照抄） | 数值 |
|---|---|
| 超音波结石刮（磁致伸缩型、压电型）频率 | 大约 25,000–45,000 赫兹 |
| 音波型（压缩空气驱动）频率 | 2,000–6,500 赫兹，可高达 9,000 赫兹 |
| 超音波最大振荡区域 | 距尖端 1–3 mm |
| 单颗牙持续接触时间 | 不超过 6–8 秒 |
| 尖端 1 mm／2 mm 受损 | 效率降低 25%／50% |
| 通用（universal）结石刮刀口与柄杆 | 90 度，只能用于牙龈上区域 |
| Gracey 刮匙 | 切割刀片与柄杆成 70 度，区域性设计；数字越小（例如 1-2）越用于吻端区域 |
| Rotosonic 设备 | 已不再建议使用（表面明显较粗糙、最具破坏力） |

要点：功率设低值再上调至所需最小功率；必须确保充分冷却液通过工作端，否则可致牙齿完全失去活性；标准牙周尖头不能深入牙龈缘下，特殊低功率牙周尖头可用于牙龈下；勿用尖锐尖端而应用平面；轻柔接触、多方向重叠路径、始终保持器械移动。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 分期与指数（原文方框 3、4、5）', '6.1 分期与指数（原文方框 3、4、5）

| 根叉指数（furcation index） | 定义（原文照抄） |
|---|---|
| 1 级（F1） | 牙周探针深入多牙根牙齿任何方向都不超过牙冠下 1/3，伴随附着性丧失 |
| 2 级（F2） | 任何方向深度超过牙冠一半的距离，伴随附着性丧失，但并非完全贯穿 |
| 3 级（F3） | 深入牙冠下时可从根叉一侧完全贯穿到另一侧 |

| 牙齿摇动性指标 | 定义（原文照抄） |
|---|---|
| 0 级（M0） | 生理摇动性最多为 0.2 mm |
| 1 级（M1） | 除轴向以外任何方向摇动度增加 0.2 mm 以上至 0.5 mm |
| 2 级（M2） | 除轴向以外任何方向摇动度增加 0.5 mm 以上至 1.0 mm |
| 3 级（M3） | 增加并超过 1.0 mm，或任何轴向移动 |

| 牙周疾病分期（periodontal disease, PD） | 定义（原文照抄） |
|---|---|
| 正常（PD0） | 临床正常；没有明显牙龈发炎或牙周炎 |
| 1 期（PD1） | 只有牙龈炎，没有附着力丧失；齿槽缘高度与结构正常 |
| 2 期（PD2） | 早期牙周炎；低于 25% 的附着力丧失，或最多一颗多牙根牙齿存在 1 型根叉病变；可见早期放射学征象 |
| 3 期（PD3） | 中期牙周炎；附着力丧失 25–50%（依临床探测或测量 X 光上牙骨质牙釉质交界处与齿槽缘距离相对于牙根长度），或多牙根牙齿存在 2 型根叉病变 |
| 4 期（PD4） | 晚期牙周炎；附着力丧失超过 50%，或多牙根牙齿存在 3 型根叉病变 |

每颗牙齿的严重程度可能不同。原文仅提供「分期（staging）」，没有独立的「分级（grading）」系统，「原文此处缺失」。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 牙科居家照护（家庭口腔护理）', '7. 牙科居家照护（家庭口腔护理）

清洁后 24 小时内牙菌斑即附着牙齿表面；没有居家照护时牙龈炎症迅速复发，专业清洁几乎失去意义。主要是牙龈线（gumline）上及其下方的牙菌斑引起炎症；刷牙是最有效机械式去除牙菌斑的方法（黄金标准），对前排牙齿最有效；被动式（咀嚼为主）对后侧牙齿最有效；两者结合可能最佳。

| 项目 | 原文数据/标准 |
|---|---|
| 频次 | 理想每天一次；已确诊牙周疾病者可能建议每天两次 |
| 中断后果 | 暂停刷牙一个月，牙龈发炎程度恢复到与未治疗病例相同水平 |
| 技术 | 牙刷与牙长轴成 45 度角，置于牙龈缘以圆周运动沿牙弓移动；闭合状态下刷颊侧面；要张嘴先将惯用手拇指放在下犬齿后面（最安全入口） |
| 牙刷 | 双面、3D、圆形猫用牙刷有效；小体型选儿童牙刷，玩具犬/猫与幼年动物用婴儿牙刷；不建议纱布和毛巾（无法清洁牙龈线以下） |
| 牙膏 | 机械式移除才是关键；不建议人类牙膏（清洁剂、氟化物、小苏打可致胃不适或氟中毒） |
| 漱口水/凝胶 | chlorhexidine 除假单胞菌属（Pseudomonas spp.）外无细菌抗药性、作用最长 7 小时，缺点为缺乏适口性；兽医用口服抗坏血酸锌凝胶（zinc ascorbate gel）可减少牙菌斑 |
| 依从性 | 积极度高的饲主六个月后刷牙执行率只剩约 50%；纯就执行率被动式可能优于主动式 |
| 牙科饮食 | 6 个月研究减少 33% 牙菌斑和牙龈发炎；须作主要食物来源，占总热量 75%、50%、25% 时效果逐渐下降 |
| 牙科零食 | 无调味烤饼干零食与绳类玩具未显示益处；压缩小麦咀嚼物、掺纤维素零食与牛皮骨效果良好；含褐藻（Ascophyllum nodosum）添加剂可改善口腔健康；没有咀嚼物获 VOHC 认证能减少猫牙菌斑 |
| 咀嚼风险 | 食道异物阻塞、舌头被玩具夹住、洁牙棒热量高致肥胖；鹿角、蹄或尼龙骨可致牙齿折断（BVDA 2017：尤其上颌第四前臼齿） |
| 添加剂 | 六偏磷酸钠（Sodium hexametaphosphate, HMP）加于干粮让犬牙结石减少近 80%；生物膜使饮水中稀释的杀菌剂失去功效 |
| 水添加剂 | 木糖醇（xylitol）能减少猫的牙菌斑和牙结石；产品浓度极低，建议剂量对健康犬安全 |
| 天然饮食/生骨 | 29 只食「天然饮食」的非洲野犬牙周疾病 41%、牙齿磨损 83%、牙齿折断 48%；马里恩岛野猫 61% 有牙周疾病但仅 9% 有牙结石；无文献支持生骨有益牙周疾病 |
| 营养素与益生菌 | 维生素 A、C、D、E 与 B 族缺乏与牙龈疾病有关；短乳酸菌（Lactobacillus brevis）含精胺酸去亚胺酶（arginine deiminase），抑制一氧化氮（NO）生成 |

法规与认证：AAFCO（Association of American Feed Control Officials）与 FEDIAF（European Pet Food Industry Federation）不允许「可预防需专业牙科治疗的牙科疾病」的声明，但 AAFCO 讨论了预防牙结石的声明。VOHC（美国兽医口腔健康委员会，vohc.org）由 9 名牙科兽医师与牙科科学家加 1 名无表决权主席组成，非监管机构、不测试产品，只建立程序与标准并审查公司提交的研究；颁发两类证书（有助于控制牙菌斑、有助于控制牙结石）；其认证仅提供整体牙齿评分，不一定能改善牙周状况。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'caution', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 第 6 节：牙科放射线学（影像要点）', '8. 第 6 节：牙科放射线学（影像要点）

全口牙科 X 光影像能显现出比临床检查多 40% 的病理学发现；至少应针对临床异常的牙齿拍摄；所有影像都在全身麻醉下拍摄。需 X 射线机（壁挂式、移动式、手持式）与侦测系统（传统口内牙科胶片、直接数字放射摄影 digital radiography, DR、电脑放射摄影 computed radiography, CR）。

三种标准技术：平行法（适用中间至后侧下颌骨，胶片与牙长轴平行，目标牙周围须有清楚 3 mm 边界）、角平分线法（适用其他区域，均分牙长轴与胶片平面夹角，中心束垂直假想平角线；用 4 号或 5 号胶片须拉远以免锥形照射）、口外/口内近平行技术（拍猫上颌前臼齿与臼齿以避免颧骨弓重叠；应标记为「口外技术」）。

标准视图（AVDC 2016）——犬 8 个：1 上颌门齿与犬齿咬合视图、2 上颌犬齿侧视图、3 前上颌牙齿（P1-P3）、4 后上颌牙齿（P4-M2）、5 下颌门齿与犬齿咬合视图、6 下颌犬齿侧视图、7 前下颌牙齿（P1-P3）（1–7 皆角平分线法）、8 后下颌牙齿（P4-M3，平行法）；猫 6 个：1 上颌门齿与犬齿咬合视图、2 上颌犬齿侧视图、3 上颌牙齿（P2-M1）口外（近平行）视图、4 下颌门齿与犬齿咬合视图、5 下颌犬齿侧视图、6 后下颌牙齿（P3-M1，平行法）。Woodward（2009）简化法只用 20、45 和 90 度：90 度打下颌前臼齿与臼齿（平行法）、45 度角平分线法打上颌前臼齿与臼齿、20 度打犬齿和门齿。

置位用唇侧/颊侧置位（labial/buccal mounting）：上颌牙冠指向下方而下颌牙冠指向上方、咬合视图以第一门齿为中线置中、臼齿在影像外围；故病患左侧牙位于影像右侧（口外视图置位相反）。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 第 7 节：拔牙与牙冠切除术（拔牙指征）', '9. 第 7 节：拔牙与牙冠切除术（拔牙指征）

适应症（包括但不限于）：牙髓疾病（endodontic disease，例如折断或一些内在性染色的牙齿）、严重牙周疾病、创伤性咬合不正（traumatic malocclusion）、乳牙迟滞（persistent deciduous teeth）、齿吸收（tooth resorption）、慢性牙龈口炎（chronic gingivo-stomatitis）、牙齿未萌发（unerupted teeth）。WSAVA 牙科准则委员会与美国兽医牙科学院共同建议：所有拔牙只能由合格且经过适当训练的兽医师执行。医源性并发症：出血、骨髓炎（osteomyelitis）、口鼻瘘管（oronasal fistula）、牙根尖挤入下颌管（mandibular canal）或鼻腔、颚骨骨折（jaw fracture）、眼睛损伤；最常见的是牙根残留——92% 的犬猫裂肉齿（carnassial）部位存在牙根残留。

封闭拔牙 10 个步骤（原文顺序；单牙根牙齿适用，多牙根牙齿分段后同样处理）：1 获得同意（最好书面）；2 取得术前牙科 X 光影像（齿槽骨沾黏几乎无法以传统挖除完成，可据影像对严重第 II 型猫齿吸收进行牙冠切除术 crown amputation 与保留牙根）；3 确保视野与活动度；4 疼痛管理（多模式止痛）；5 切断牙龈附着（手术刀片 scalpel blade、骨膜剥离器 periosteal elevator，推进至齿槽骨水平并环绕整颗牙）；6 剥离/挖除（最危险：有眼睛被器械弄伤、至少一例牙根挺刺穿脑部致死的报告，食指应放在距尖端约 1 cm 处；插入时与牙成 10–20 度角，轻柔扭转维持 10–30 秒以撕裂牙周韧带，再深入约 1/8 并环绕 360 度；蝶型（winged）器械可扭转，拔牙刀 luxators 只可插入摇动）；7 拔牙（仅在牙齿非常松动后尝试，横截面圆形者可轻微扭转至少 10 秒）；8 齿槽整形术（刮匙、钻石磨针或咬骨钳 Rongeurs 平整骨）；9 术后牙科 X 光确认完整移除；10 缝合（大颗牙或创建牙龈瓣者必须缝合；反角针 reverse cutting needle 配 0 至 5/0 合成单股可吸收缝线，间隔 2 至 3 毫米，比制造商建议多打一个圈）。

多牙根牙齿拔除前先切割成单牙根片段；工具为高速气动手机配斜切式锥形裂隙磨针（cross-cut taper fissure bur），型 699 用于猫和小型犬、701 用于中型犬、702 用于大型犬，从根叉向牙冠切割（空气与水冷却避免骨过热坏死）。开放式拔牙用于难以处理的牙齿（通常为犬齿与裂肉齿：上颌第四前臼齿与下颌第一臼齿）、牙根畸形或病变及牙根残留者；第一步创建牙龈瓣（袋状瓣 envelope flap 或垂直释放切口），释放至黏膜牙龈交界处（muco-gingival junction, MGJ）或以下；切线上必须没有张力，可穿孔骨膜（periosteum）减压。

牙冠切除术标准（原文）：仅在严重第 II 型齿吸收、X 光上看不到牙周韧带、没有牙髓系统的放射学证据、没有牙周疾病与牙髓病变证据、没有后口腔炎（caudal stomatitis）证据时才建议进行，并应尽可能移除多一点「牙根」；技术为创建袋状牙龈皮瓣、用牙钻研（原文示例用钨钢钻研 701）移除骨水平以下 1–2 mm 的所有牙齿物质、平整骨组织并缝合牙龈；院内没有牙科放射学设备者不应进行；强烈建议不要用钻研（bur）对牙根钻孔或「消磨」（牙根粉碎 root pulverization）。', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'caution', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('WSAVA全球牙科指南要点 · 第 8 节、AFD 立场声明与第 9 节设备', '10. 第 8 节、AFD 立场声明与第 9 节设备

第 8 节讨论兽医学院训练与研究生培训对牙科教育的重要性。

AFD 立场声明核心：需要配合麻醉才能有效并彻底进行牙科操作（专业清洁、完整口腔检查、牙科 X 光、拔牙及其他治疗）；无麻醉牙科操作对动物几乎没有好处而代价可能很大，会带来压力和潜在风险；以牙结石可见量判断是否需要治疗是错误的，在未诊断或治疗牙龈下病变的情况下移除表面病灶会延迟有效治疗；非专业洗牙已被证明使牙周健康恶化。WSAVA 牙科准则委员会因此认为无麻醉洗牙引起重大动物福利关注、未达到照护标准并强烈反对。「国际非牙科学会：」标题下无内容，「原文此处缺失」。

第 9 节设备分层（原文照抄要点）：清醒口腔检查（第一、二、三类）＝好的光源 + 检诊手套，另需放大镜、笔灯（可透照牙齿以确定其活性）。全身麻醉下检查基础设备＝良好光源、放大设备、牙周探针（Williams 14 号刻度 1-2-3-5-7-8-9-10 毫米）、牙科镜、嘴唇牵引器、张口器（注射针筒外壳或塑胶张口器，而非弹簧式）、个人防护装备。保温：第一类热水式，第二与第三类热空气式。麻醉：吸入性麻醉、全静脉麻醉（TIVA）、提供氧气、局部神经阻断工具；监测（第二、三类）体温、脉搏、呼吸频率、血压、呼出二氧化碳量，第三类加静脉输液帮浦。放射学：第一类传统动物用 X 射线机；第二类牙科 X 射线机配非屏幕式口内牙科胶片、光激发磷光板（CR 系统）；第三类数字放射系统（DR 系统）并应广泛应用。洗牙器械：第一类牙结石夹除钳、牙龈上结石刮、牙龈下刮匙；第二、三类加牙科治疗台、音波或超音波洗牙（压电型、磁致伸缩型）与牙龈上/下尖头、抛光膏。缝线：Poliglecaprone 25，猫 4/0 至 5/0、犬 4/0–3/0，带缝线针（swaged-on）配反角针（reverse cutting needle）。

11. 原文抽取缺失与异常一览

| 位置 | 状态 |
|---|---|
| 颅骨解剖标注（E49） | 乱序标签残片，「原文此处缺失」 |
| AVDC 折断分类表（E62） | 仅剩空表头，本稿据 E65 段落重建 |
| 表 1（E94） | 表体被打散为项目符号，本稿按原文顺序重建 |
| 表 7（E105） | 标签与咬合段落错乱合并，该句「原文此处缺失」 |
| 牙周疾病「分级（grading）」 | 原文只有分期，「原文此处缺失」 |
| 插图（图 1–165） | 抽取不含图像，仅图注文字，「原文此处缺失」 |
| 参考文献与编译署名（E156–E161） | 引用信息，本稿不整理 |', '', '', '', '口腔护理,牙周疾病,Triadan 系统,牙科记录表,PD0-PD4 分期,根叉指数 F1-F3,指南框架与分层,第 1 节：口腔解剖学与常见病变,第 2 节：动物福利', 'informational', 'WSAVA全球牙科指南要点', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('口腔肿瘤与病变识别 · 第 1 段', '口腔肿瘤与病变识别

> 说明：本稿主体为 WSAVA 全球牙科委员会（Global Dental Committee, GDC）饲主教育材料《The 3 questions in Oral Cancer》（2 页，英文，抽取字符 1,552）。该材料第 2、第 3 两个问题标题下没有独立正文（内容并入末段），已标注「原文此处缺失」。第 4 节明确标注为《WSAVA 全球牙科指南》官方中文译本第 1 节「口腔肿瘤」小节的补充，数值与切缘标准照抄原文。

1. 需要立即就诊的信号

原文「Visit your vet immediately, if you notice」清单：

| 原文症状 | 中文对应 |
|---|---|
| bad breath | 口臭 |
| difficulties eating | 进食困难 |
| bleeding from the mouth or nose | 口腔或鼻部出血 |
| lump(s) | 肿块 |
| swelling(s) | 肿胀 |
| ulcer(s) | 溃疡 |
| tissue colour change | 组织颜色改变 |
| any other change in the mouth or face of your animal | 口腔或脸部的任何其他变化 |

2. 口腔癌症的三个问题（The 3 Questions In Oral Cancer）

2.1 第一个问题：它是什么（What Is It?）

- 活检（biopsy）指在动物处于全身麻醉（general anaesthesia）下取下一块外观异常的组织。
- 恶性（malignant）癌症会透过身体扩散（即转移 metastasize）；良性（benign）癌症不会扩散，但仍可造成严重的局部破坏。
- 样本送实验室进行组织病理学检查（histopathology examination）——在显微镜下评估组织，确定是否为癌症（同义词 tumor 或 neoplasia）。
- 口腔癌的局部范围（local extent）主要由头部电脑断层扫描（computed tomography, CT）评估；必须了解癌症是否局限于口腔内，或已侵犯任何周围结构。
- CT 理想上应在活检之前立即执行（just before biopsy），因为有助于更好地规划活检。

2.2 第二个问题：它有多大（How Big Is It?）

原文该标题下没有独立正文，仅出现标题，相关内容并入材料末段（见 2.3）。「原文此处缺失」。', '', '', '', '口腔护理,口腔肿瘤,活检 biopsy,电脑断层 CT,PET-CT,恶性黑色素瘤 MM,需要立即就诊的信号,可选治疗方式', 'informational', '口腔肿瘤与病变识别', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('口腔肿瘤与病变识别 · 第三个问题：它是否已经扩散到全身（Has It Spread Through T', '2.3 第三个问题：它是否已经扩散到全身（Has It Spread Through The Body?）与分期

原文该标题下同样没有独立正文。材料末段：只有在获得全部 3 个问题的答案之后，才能为动物制定最佳治疗计划和最有可能的结果（optimal treatment plan and most likely outcome）。如果癌症是恶性的，需要检查头部与颈部淋巴结（lymphnodes）、肺脏和腹部器官是否有转移；这通常通过全身 CT（full-body CT）完成；CT 可以与腹部超音波（abdominal ultrasound, US）、磁共振成像（magnetic resonance imaging, MRI）、（手术或针吸）淋巴结采样结合使用，或由其替代；PET-CT 甚至更敏感，但尚未广泛可及（not yet available widely）。

3. 可选治疗方式

| 原文（English） | 中文对应 |
|---|---|
| surgery | 手术 |
| radiation therapy | 放射治疗 |
| electrochemotherapy | 电化学疗法 |
| immunotherapy | 免疫疗法 |
| (metronomic) chemotherapy | （节拍式）化学治疗 |
| photodynamic therapy | 光动力治疗 |
| or combinations of these treatments (i.e., multimodal approach) | 或上述治疗的组合（即多模式方法） |

原文关键结论：大多数口腔癌，尤其是犬的口腔癌，如果在早期被诊断和治疗，是可以治愈的（Most of the oral cancers, especially in dogs, can be cured, if diagnosed and treated early!）。

4. 病变识别依据（补充自《WSAVA 全球牙科指南》第 1 节）', 'dog', '', '', '口腔护理,口腔肿瘤,活检 biopsy,电脑断层 CT,PET-CT,恶性黑色素瘤 MM,需要立即就诊的信号,可选治疗方式', 'informational', '口腔肿瘤与病变识别', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('口腔肿瘤与病变识别 · 分类框架', '4.1 分类框架

肿瘤（tumour）代表「肿胀（swelling）」或异常生长（abnormal growth）；口腔肿瘤可区分为良性及恶性，以及是否为齿源性（odontogenic）。「龈瘤（epulis）」数十年来被错误用来描述口腔内良性生长的团块，实际上是指源自牙龈的任何异常生长，可能包括恶性肿瘤。口腔肿瘤约占犬肿瘤的 5–7%，占猫肿瘤的 10%。原文重点：良性和恶性肿瘤的临床表现可能非常相似，必须藉由组织病理学检查确认；最常见的犬口腔恶性肿瘤是恶性黑色素瘤，其次是鳞状上皮细胞癌；最常见的猫口腔恶性肿瘤是鳞状上皮细胞癌，其次是纤维肉瘤；手术切除是大多数口腔肿瘤的首选，切缘大小取决于生长类型及涉及组织平面；化学治疗、免疫疗法及放射治疗可作为姑息或辅助疗法；某些情况下加速放射治疗具有治愈效果。', '', '', '', '口腔护理,口腔肿瘤,活检 biopsy,电脑断层 CT,PET-CT,恶性黑色素瘤 MM,需要立即就诊的信号,可选治疗方式', 'informational', '口腔肿瘤与病变识别', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('口腔肿瘤与病变识别 · 恶性肿瘤', '4.2 恶性肿瘤

| 肿瘤（中文（English）） | 占比 | 平均发病年龄 | 原文要点 |
|---|---|---|---|
| 恶性黑色素瘤（malignant melanoma, MM） | 占犬恶性口腔肿瘤 30–40%；鲜少发生在猫 | 犬 12 岁（犬最常见口腔肿瘤） | 色素沉淀或无色素病灶，最初平滑后逐渐溃疡，通常无血管蒂；局部侵犯性高并常诱发骨反应；扩散到局部淋巴结 70%、肺脏 66%，未在转移前诊断并切除则预后保守至不佳；完整切除搭配 1–2 cm 切缘；多模式选择含放射治疗、免疫疗法、黑色素瘤疫苗、基因疗法；通常认为对化学治疗有相当耐受性 |
| 鳞状上皮细胞癌（Squamous Cell Carcinoma, SCC） | 占犬口腔恶性肿瘤 24–30%；猫 64–75% | 犬 8 岁（犬第二常见）；猫 12.5 岁（猫最常见） | 可为溃疡增生性病灶，破坏大范围颚骨、破坏牙齿，有时导致下颌骨骨折；可见于舌下或舌背上，可能与扁桃腺有关；大城市动物患病率较高（空气污染），配戴跳蚤项圈及（或）吸烟家庭的猫风险更高；广泛切除 1–2 cm 切缘为首选，完整切除的患犬预后良好；无法切除者加速放射治疗（Accelerated radiation）有益甚至可治愈；猫一般对放射治疗没有反应，与化学治疗合并使用观察到一些正向效果；瘤内注射放射性钬（166Ho）微球体有望提高切除性手术效果 |
| 纤维肉瘤（Fibrosarcoma, FSA） | 占犬口腔肿瘤 17–25%；猫 12–22% | 犬 8–9 岁；猫 10 岁；黄金猎犬确诊时通常 4–5 岁 | 通常生长于腭上，无血管蒂、光滑、比周围组织略微苍白；即使切缘确认「干净（tumour free）」仍经常复发；组织学可能低恶性程度但临床高侵犯性；首选治疗未确定，手术或合并放射治疗、单独放射治疗、放射治疗合并局部热疗（hyperthermia）均可延长部分患犬存活 |
| 淋巴肉瘤（lymphomas） | 约占口腔肿瘤 5% | 原文此处缺失 | 可分为扁桃腺型及非扁桃腺型 |
| 骨肉瘤（osteosarcomas） | 仅占猫口腔肿瘤 2%；犬 7% 的骨肉瘤影响颅骨 | 原文此处缺失 | 可致骨质破坏或骨骼增生，有些在影像上呈囊肿样病灶；倾向在疾病晚期（转移）；可用放射治疗与化学治疗 |
| 肥大细胞瘤（Mast Cell Tumour, MCT） | 约占口腔肿瘤 6%；雄性为雌性两倍 | 原文此处缺失 | 建议 3 cm 切缘广泛切除，术前须详细拟定重建计划并排除肺脏与淋巴结转移；淋巴结未受影响时存活超过 4 年，转移时中位存活仅 14 个月；并发症为脱颗粒（degranulation）释放组织胺（histamine）引起过敏反应，术前 30 至 60 分钟皮下注射 diphenhydramine 1 至 2 mg/kg 或可减少；无法切除时可选放射治疗、电化学疗法（可合并肿瘤周围介白素 IL-12 基因电转移）、病灶内注射 Triamcinolone |', '', '', '', '口腔护理,口腔肿瘤,活检 biopsy,电脑断层 CT,PET-CT,恶性黑色素瘤 MM,需要立即就诊的信号,可选治疗方式', 'informational', '口腔肿瘤与病变识别', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('口腔肿瘤与病变识别 · 良性肿瘤与类肿瘤病变', '4.3 良性肿瘤与类肿瘤病变

| 病变（中文（English）） | 原文要点 |
|---|---|
| 牙龈增生（gingival hyperplasia, GH） | 须以组织病理学与其他口腔团块区分；可能遗传好发（拳师犬），或由 cyclosporine、phenobarbital、calcium channel blockers 引起，或与牙菌斑诱发之牙龈发炎有关；停药通常可恢复正常；对牙龈整形术（gingivoplasty）及牙龈切除术（gingivectomy）反应良好，可借每天刷牙与有效居家照护控制；遗传性者切除后仍预期复发 |
| 周边齿源性纤维瘤（peripheral odontogenic fibromas） | 旧称牙周韧带来源的纤维性龈瘤（fibromatous epulis of periodontal ligament origin）；易生于犬口腔，可为纤维化或骨化团块，源自牙周韧带形成局部坚硬肿胀灶；边缘性切除可控制，拔除牙齿并彻底清创牙周组织才能治愈，亦可 en-block 完整切除 |
| 齿瘤（odontomas） | 组合性齿瘤（compound odontomas）为含许多完整牙齿样结构的错构瘤（hamartomas）；复合性齿瘤（complex odontomas）含源自个别牙齿成分的结构；边缘性切除通常可治愈；术中常造成大空洞，需骨填充与精巧缝合 |
| 含齿囊肿（dentigerous cysts） | 导因于牙齿釉质器（enamel organ）残留体嵌入或阻生齿；通常与下颌第一前臼齿阻生齿有关，尤其短吻犬；犬阻生齿出现囊肿的发生率 29%，故所有「缺失」牙齿都应拍牙科 X 光；治疗为移除受影响牙齿并完整摘除囊肿上皮内衬；术后约 3 个月新骨完全充填 |
| 棘皮状造釉细胞瘤（acanthomatous ameloblastoma, AA） | 旧称犬棘状细胞龈瘤；良性但局部侵犯性，常造成齿列移动；周边型致骨扩大与牙齿移动，中央型（CAA）可在颚骨内形成囊肿样病变（常见于黄金猎犬、秋田犬、可卡犬、喜乐蒂牧羊犬）；首选至少 5–10 mm 切缘的边缘性切除；对放射线敏感、控制率高达 90%，但可能恶性转化或放射性骨坏死，故保留给无法手术或老年犬；病灶内注射 bleomycin 有效 |
| 浆细胞瘤（plasmacytoma） | 罕见，可能多发病灶；局部侵犯性强但不转移；5–10 mm 切缘外科切除通常可治愈，前提是口腔病灶非全身性疾病的一部分 |
| 犬传染性花柳性肿瘤（Transmissible Venereal Tumours, TVT） | 可生长在口腔内；在第三类国家实际上已消声匿迹，但在热带与亚热带盛行区须列入鉴别诊断；组织病理学对区分淋巴瘤与其他圆形细胞病变（round-cell lesions）很重要；典型治疗为静脉注射 vincristine，通常治愈性；也可能自限性 |
| 乳突状瘤病（papillomas） | 见于幼年动物口腔与嘴唇，多为病毒性；白色、灰色或肉瘤样团块，通常带血管蒂（pedunculated），可单发或成束；通常自限性，但严重者可继发感染影响食欲，已知可能恶性转化为 SCC；严重病例手术切除或减积手术（debulking）并送检 |', 'dog', 'senior', '', '口腔护理,口腔肿瘤,活检 biopsy,电脑断层 CT,PET-CT,恶性黑色素瘤 MM,需要立即就诊的信号,可选治疗方式', 'informational', '口腔肿瘤与病变识别', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('口腔肿瘤与病变识别 · 需与肿瘤鉴别的病变', '4.4 需与肿瘤鉴别的病变

嗜酸球性肉芽肿复合症（Eosinophilic Granuloma Complex, ECG）：一群生长于猫口腔内（也可能发生在犬）的相关团块——上门齿与嘴唇之间及（或）人中的无痛溃疡灶（indolent ulcer，俗称侵蚀性溃疡 rodent ulcers）；线状肉芽肿（linear granulomas）更具侵略性，可能导致下颌骨骨折或口鼻瘘管（oronasal fistulas）；胶原蛋白溶解性肉芽肿（collagenolytic granulomas）位于下颌前端与唇部之间，坚实肿胀但不发炎。原文强调：始终建议用组织病理学检查将其与其他口腔肿瘤区分；任何治疗的第一步是排除潜在过敏性病因（跳蚤治疗、食物试验及过敏测试）；原文案例中患猫病变 5 年未经活检即被「诊断」为 SCC，故无论病灶外观如何，应对所有口腔病变采样并送检组织病理学检查。', '', '', '', '口腔护理,口腔肿瘤,活检 biopsy,电脑断层 CT,PET-CT,恶性黑色素瘤 MM,需要立即就诊的信号,可选治疗方式', 'informational', '口腔肿瘤与病变识别', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('犬猫刷牙工具包 · 第 1 段', '犬猫刷牙工具包

> 原文抽取内容有限说明：本材料为 WSAVA 全球牙科委员会（Global Dental Committee, GDC）面向饲主的 2 页图文工具包（英文原文），抽取字符数 3,978，正文全部为连续段落文字；原文引用的 Figure 1、Figure 2、Figure 3、Figure 4 四张示意图在 PDF 抽取中没有可提取的文字说明，「原文此处缺失」。本稿不含表格，因为原文没有表格；所有数值（90%、6 至 7 月龄、少于 2 分钟、每天一次、每年一次）均照抄原文，未补充原文之外的内容。

1. 为什么需要每天刷牙

原文要点：

- 牙周疾病（Periodontal disease）是猫和犬最常见的医疗问题，当前研究显示高达 90% 的宠物受到影响（up to 90% of pets are affected）。
- 过去十年的科学研究表明，这种疾病会对宠物的生活质量造成有害影响（a detrimental impact on your pet''s quality of life）。
- 预防这种感染是你每天都能做、用以改善宠物口腔健康的事情。
- 就像你本人一样，你的宠物需要免受牙菌斑（plaque）的侵害，而牙菌斑是牙周疾病的原因（the cause periodontal disease）。
- 你可以通过每天刷牙（daily toothbrushing）来保护宠物，就像保护你自己一样简单。
- 向宠物引入刷牙可能存在挑战——包括时间因素、知道如何有效地做，以及你的宠物是否允许。按材料给出的步骤，可以成功地把刷牙引入宠物的日常生活中。

2. 什么时候开始最合适

原文回答「When is the best time to start brushing your pet''s teeth?」：

| 情形 | 原文要求 |
|---|---|
| 起始时点一 | 当宠物 6 至 7 月龄（6 to 7 months of age）、恒牙（adult teeth）萌出之后 |
| 起始时点二 | 或在进行专业牙科清洁（professional dental cleaning）之后，由兽医执行 |
| 训练时点 | 但训练应当从第一天就开始（training should start from day one） |

原文提醒：习惯很难开始，但很容易打破（Habits are hard to start, but easy to break）。', '', '', '', '口腔护理,刷牙,牙周疾病,牙菌斑,plaque,牙龈线,为什么需要每天刷牙,什么时候开始最合适,时间安排与频次', 'informational', '犬猫刷牙工具包', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('犬猫刷牙工具包 · 时间安排与频次', '3. 时间安排与频次

原文要求逐条如下：

- 选择一天中你容易坚持下来的时间。
- 可以尝试在宠物的用餐时间、睡前或清晨第一件事（mealtime, before bed or first thing in the morning）。
- 给宠物刷牙只需要不到 2 分钟（It takes less than 2 minutes to brush your pet''s teeth），因此为自己设定每天做到的目标。
- 你只需要每天为宠物刷牙一次（You only need brush your pet''s teeth once each day），所以找一个适合你和宠物的时间。
- 一旦开始刷牙，就要坚持下去；把它变成习惯/例行仪式，对你和宠物都更容易（Making it a habit/ritual makes it easier on you AND your pet）。

4. 成功刷牙的五个步骤（Successful toothbrushing starts with these easy steps）

4.1 步骤 1：触摸宠物的脸（Touch your pet''s face）

从训练宠物接受你的手在它的脸和嘴巴周围开始。轻柔地抚摸它脸的每一侧，最后以翻起上唇（lifting their top lip）结束（Figure 1，原文图示缺失）。当宠物自在地接受这一点后，就可以进入下一步。给宠物它最喜欢的零食或玩具作为奖励。

4.2 步骤 2：触摸牙齿（Touch the Teeth）

在轻柔抚摸脸部、翻起上唇并触碰一颗上牙的同时，将你的食指引入宠物的嘴巴，试着触碰两侧的犬齿（canine (fang) tooth）。（Figure 2，原文图示缺失）。每天的目标是多碰一颗牙齿，直到你能碰到它大多数或全部牙齿（Each day aim to touch an extra tooth until you can touch most or all their teeth）。同样用宠物最喜欢的零食奖励它。', 'dog', '', '', '口腔护理,刷牙,牙周疾病,牙菌斑,plaque,牙龈线,为什么需要每天刷牙,什么时候开始最合适,时间安排与频次', 'informational', '犬猫刷牙工具包', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('犬猫刷牙工具包 · 步骤 3：轻柔按摩牙龈（Gently Massage the Gums）', '4.3 步骤 3：轻柔按摩牙龈（Gently Massage the Gums）

原文强调：最需要清洁的牙齿区域是沿着牙龈线（The most important area of the tooth to clean is along the gumline）。把对牙齿的触碰改为沿牙龈线的轻柔按摩。在这个阶段你可以使用兽医推荐的指套式牙刷和牙膏（a veterinary recommended finger style toothbrush and toothpaste）（Figure 3，原文图示缺失）。先让宠物闻一闻并尝一尝牙膏，确保它喜欢这个味道！或者，把牙刷蘸一些金枪鱼汁（tuna juice）或鸡肉高汤（chicken stock）来鼓励宠物接受。

4.4 步骤 4：过渡到牙刷（Transition to Toothbrush）

你的兽医可以推荐一种安全有效的、适合你宠物特定需求的牙刷。儿童牙刷（A Child''s toothbrush）是理想的替代选择，因为其刷毛柔软、对宠物牙龈温和。原文提示：当你第一次引入牙刷时，事情可能会倒退一步（Things may take a backward step）。因此，从牙刷的「步骤 2」开始——一次触碰一颗牙齿，直到宠物重新自在地接受；然后当宠物更适应时，你可以开始用刷毛沿牙龈线轻柔按摩（Figure 4，原文图示缺失）。把宠物最喜欢的零食准备好！', '', '', '', '口腔护理,刷牙,牙周疾病,牙菌斑,plaque,牙龈线,为什么需要每天刷牙,什么时候开始最合适,时间安排与频次', 'informational', '犬猫刷牙工具包', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('犬猫刷牙工具包 · 步骤 5：定期检查（Regular Checkups）', '4.5 步骤 5：定期检查（Regular Checkups）

原文要点：

- 虽然人们常说牙齿外侧最重要，但如果可能，牙齿内侧也应该刷。
- 做到这一点的最佳方法是在下犬齿后面放一根手指——那里有很小的牙齿——这通常会让宠物张开嘴巴，从而接触到内侧（place a finger behind the lower canine where there are very small teeth and this will usually cause the pet to open their mouth allowing access to the inside）。
- 如果宠物不允许，不要破坏你已经取得的进展，继续刷外侧即可（If they won''t allow it, don''t ruin your progress and stay with the outside）。
- 你的宠物其实已经习惯嘴里有东西，因为它们用嘴巴的方式就像你用双手的方式。
- 如果你缓慢而轻柔地进行、给宠物适应的时间，宠物通常很容易接受主人的手在脸和嘴巴周围。
- 始终以宠物的节奏进行；如果你觉得宠物太不舒服，就停在那里，第二天再试。
- 刷牙不会在一夜之间成功，可能需要每天尝试几周，直到宠物完全自在；你越慢、越轻柔，就会越成功。
- 与人类不同，宠物牙痛时不能自己去看牙医，所以要与你的兽医安排定期（每年一次）的检查（schedule regular (annual) checkups），以确保宠物获得最好的口腔健康照护。
- 猫和犬可能患有许多其他口腔疾病（Cats and dogs can suffer from many other oral conditions），因此应由专业人员定期进行口腔评估，作为宠物口腔健康常规的一部分；如有任何担忧，请联系你的兽医获取建议。

5. 原文联系信息

原文结尾：如需了解更多关于 WSAVA 全球牙科委员会（WSAVA Global Dental Committee）工作的资讯，请访问 wsava.org/committees/global-dental-committee。', '', '', '', '口腔护理,刷牙,牙周疾病,牙菌斑,plaque,牙龈线,为什么需要每天刷牙,什么时候开始最合适,时间安排与频次', 'informational', '犬猫刷牙工具包', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('犬猫刷牙工具包 · 补充对照（出自《WSAVA 全球牙科指南》第 5 节「牙科居家照护」）', '6. 补充对照（出自《WSAVA 全球牙科指南》第 5 节「牙科居家照护」）

为避免与上述饲主材料混淆，本节内容明确标注来源为《WSAVA 全球牙科指南》官方中文译本，仅摘录与刷牙直接相关、且可与上文互相印证的原文数值：

| 项目 | 指南原文要点 |
|---|---|
| 有效性排序 | 目前为止，刷牙是最有效机械式去除牙菌斑的方法；如果正确执行，刷牙被证实是控制牙菌斑最有效的方法，因此刷牙是黄金标准 |
| 目标区域 | 牙龈上牙菌斑和牙结石对牙周疾病几乎没有影响；主要是牙龈线（gumline）上及其下方的牙菌斑引起炎症反应并诱发牙周疾病 |
| 频次 | 理想上应每天一次；已经确定患有牙周疾病的病例需要每天刷牙，并可能建议每天刷牙两次 |
| 中断后果 | 如果即使只暂停刷牙一个月，牙龈发炎的程度将恢复到与未接受治疗病例相同的水平 |
| 角度技术 | 正确的刷牙技术是将牙刷与牙齿的长轴成 45 度角，然后放在牙龈缘，并以圆周运动的方式沿牙弓移动 |
| 依从性 | 积极度高的宠物饲主在刷牙六个月后的刷牙执行率只剩 50% 左右 |
| 牙刷选择 | 不建议使用纱布和毛巾，因为它们无法清洁牙龈线以下的区域；体型较小的病患通常选用儿童牙刷；婴儿牙刷可能更适合用于玩具犬、猫或幼年动物 |
| 牙膏禁忌 | 不建议使用人类牙膏，因为它们通常含有清洁剂和氟化物，如果被吞入消化道可能导致胃不适或氟中毒，并且也含有小苏打（碳酸氢钠）等成分 |
| 风险告知 | 靠近动物的嘴巴并操弄可能让饲主存有被咬的风险，在讨论刷牙的过程一定需告知饲主这种风险；强迫使饲主完成居家照护将适得其反，并可能损害饲主与动物之间的连结 |
| 张开嘴巴的入口 | 若要张开嘴巴，先将惯用手的拇指放在下犬齿的后面，这是将手指放置于嘴巴内最安全的地方 |

7. 原文缺失项汇总

| 缺失项 | 说明 |
|---|---|
| Figure 1–4 | 原文以「(Figure 1)」等形式引用四张示意图，抽取中只有引用标记，没有图与图注文字，「原文此处缺失」 |
| 表格 | 原文材料本身没有表格；本稿第 2、6 节的表格是把原文条目按栏位整理呈现，未添加原文之外的内容 |
| 推荐产品名单 | 原文只写「兽医推荐的指套式牙刷和牙膏」「你的兽医可以推荐一种安全有效的牙刷」，没有品牌或产品清单，「原文此处缺失」 |
| 刷牙时长上限 | 原文只给出「少于 2 分钟」，未给出每次刷多少颗/多少秒的分项标准，「原文此处缺失」 |
| 猫/犬差异 | 原文未区分猫与犬的具体步骤差异（仅在定期检查处提到猫和犬可能患有许多其他口腔疾病），「原文此处缺失」 |', '', '', '', '口腔护理,刷牙,牙周疾病,牙菌斑,plaque,牙龈线,为什么需要每天刷牙,什么时候开始最合适,时间安排与频次', 'caution', '犬猫刷牙工具包', 'official', 'https://wsava.org/global-guidelines/dental-guidelines/', 'approved'),
('Gastrointestinal Guidelines · 第 1 段', 'Gastrointestinal Guidelines（胃肠病学指南）

板块页面正文（原文）

Guidelines

Gastrointestinal

Executive Summary

The Gastrointestinal Standardization Group worked to create a global standard for the histopathological evaluation of the gastrointestinal tract of dogs and cats. This standard now provides a wide range of benefits, including uniform diagnosis of disease, staging of disease, and the subsequent development of controlled clinical trials for the treatment of gastrointestinal disorders.

Resources

- [Upper GI Endoscopy Report Form](https://wsava.org/wp-content/uploads/2020/01/Final_Upper_Endoscopy_Report_Form.pdf)
- [Lower GI Endoscopy Report Form](https://wsava.org/wp-content/uploads/2020/01/Final_Lower_Endoscopy_Report_Form.pdf)

Endorsements

These forms have been officially endorsed by the Comparative Gastroenterology Society (CGS) and the European Society of Comparative Gastroenterology (ESCG).

Downloads

Endoscopic, Biopsy and Histopathologic Guidelines for the Evaluation of Gastrointestinal Inflammation in Companion Animals

[Download](https://onlinelibrary.wiley.com/doi/pdf/10.1111/j.1939-1676.2009.0443.x)

本板块文档清单

共 2 份 PDF，按「英文 + 中文」策略收录 2 份，跳过小语种译本 0 份。', '', '', '', '消化,板块页面正文（原文）,Guidelines,Gastrointestinal', 'informational', 'Gastrointestinal Guidelines', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('Gastrointestinal Guidelines · 已收录（原文已抽取到 raw_extracts/）', '已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Upper GI Endoscopy Report Form | EN |  | 2 | 2591 | [raw_extracts/Final_Upper_Endoscopy_Report_Form.md](raw_extracts/Final_Upper_Endoscopy_Report_Form.md) |
| Lower GI Endoscopy Report Form | EN |  | 2 | 2804 | [raw_extracts/Final_Lower_Endoscopy_Report_Form.md](raw_extracts/Final_Lower_Endoscopy_Report_Form.md) |

外部引用（期刊论文 / 相关机构，未抓取正文）

- Download — <https://onlinelibrary.wiley.com/doi/pdf/10.1111/j.1939-1676.2009.0443.x>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '消化,板块页面正文（原文）,Guidelines,Gastrointestinal', 'informational', 'Gastrointestinal Guidelines', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 表单背景与适用范围', '1. 表单背景与适用范围

本整理稿合并 WSAVA 发布的两份标准内镜报告表：**上消化道内镜（UPPER GI ENDOSCOPY）** 与 **下消化道内镜（LOWER GI ENDOSCOPY）**，表头统一为 `ENDOSCOPIC EXAMINATION REPORT`。

- 表单由 WSAVA Gastrointestinal Standardization Group 制定，参与专家（原文逐字）：Drs Washabau, Willard, Hall, Jergens, Day, Mansell, Wilcox, Minami, Guilford, and Biltzer；由 **Hill''s Pet Nutrition** 资助（sponsorship）。
- 板块页面说明：胃肠病学标准化工作组致力于为犬猫胃肠道组织病理学评估建立全球标准，其收益包括统一的疾病诊断、疾病分期，以及后续胃肠疾病治疗对照临床试验的开展。
- 这两份表单获得 **Comparative Gastroenterology Society (CGS)** 与 **European Society of Comparative Gastroenterology (ESCG)** 正式背书（endorsed）。
- 每份 PDF 均为 2 页；抽取字符数分别为 2591（上）与 2804（下）。

1.1 统一病变评分码（两份表单通用）

两份表单在每一解剖段均使用同一套严重度评分码，必须逐字照抄：

`Code: Normal = 0  Mild = 1  Moderate = 2  Severe = 3`

每张病变表的列结构固定为三列：**Lesion（病变）／Code（评分码）／Comments（备注，需注明位置）**。原文对备注列的硬性要求是 `Comments (include location)`，即记录病变时必须写明解剖位置。

2. 上消化道内镜检查报告表', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 基本信息与操作记录项', '2.1 基本信息与操作记录项

| 填写项（原文） | 中文对照 | 填写方式 |
|---|---|---|
| Date of procedure | 操作日期 | 虚线填空 |
| Case Number | 病例编号 | 虚线填空 |
| Patient and client information | 患畜与主人信息 | 原文注明 `(card or stamp)`，即贴卡片或盖章 |
| PROCEDURE(S) | 所行操作 | 横线填空 |
| Indication(s) for procedure | 操作适应证 | 横线填空 |
| Endoscope(s) used | 所用内镜 | 横线填空 |
| Forceps/retrieval device(s) used | 所用活检钳／异物取出装置 | 横线填空（上消化道含取出装置） |

2.2 问题／并发症（PROBLEMS/COMPLICATIONS）

勾选项（原文逐项）：`None`（无）、`Perforation`（穿孔）、`Excessive bleeding`（过度出血）、`Anesthetic complications`（麻醉并发症）、`Excessive time`（时间过长）、`Other`（其他）。

其后为 `Comments:` 横线备注。未能完成的情形需逐项说明原因：

| 未完成事项（原文） | 需填写的原因栏 |
|---|---|
| Unable to complete full examination | why?（横线） |
| Unable to obtain adequate biopsies | why?（横线） |
| Unable to retrieve foreign object | why?（横线） |
| Visualization obscured | why?（横线） |

2.3 采样与记录（SAMPLING / DOCUMENTATION）

- SAMPLING：`Biopsy`（活检）、`Brush cytology`（刷片细胞学）、`Washing`（冲洗液）、`Aspiration`（抽吸）、`Foreign body retrieved`（异物已取出）。
- DOCUMENTATION：`Video`（视频）、`Photographs`（照片）。', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 食管（ESOPHAGUS）', '2.4 食管（ESOPHAGUS）

一般所见勾选项：`Normal`、`Foreign body`（异物）、`Mass`（肿物）、`Stricture`（狭窄）、`Hiatal hernia`（食管裂孔疝）。

病变评分表（评分码见 1.1）：

| Lesion | Code | Comments (include location) |
|---|---|---|
| Hyperemia/vascularity 充血／血管相 | | |
| Discoloration 变色 | | |
| Friability 易脆性 | | |
| Hemorrhage 出血 | | |
| Erosion/ulcer 糜烂／溃疡 | | |
| Contents (mucus/bile/food) 内容物（黏液／胆汁／食物） | | |
| Dilation 扩张 | | |
| Gastroesophageal sphincter 食管胃括约肌 | | |
| Other 其他 | | |

2.5 胃（STOMACH）

一般所见勾选项：`Normal`、`Foreign body`、`Mass`、`Polyp(s)`（息肉）、`Parasite(s)`（寄生虫）。

- `Site(s) of lesions:`（病变部位）：Fundus、Body、Incisura、Antrum、Pylorus。
- `Site(s) of biopsies:`（活检部位）：Fundus、Body、Incisura、Antrum、Pylorus。

胃段病变评分表：

| Lesion | Code | Comments (include location) |
|---|---|---|
| Can''t inflate lumen 管腔无法充气扩张 | | |
| Hyperemia/vascularity | | |
| Edema 水肿 | | |
| Discoloration | | |
| Friability | | |
| Hemorrhage | | |
| Erosion/ulcer | | |
| Contents (mucus/bile/food) | | |
| Gastroesophageal sphincter | | |
| Passing scope through pylorus 内镜通过幽门 | | |
| Other | | |', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 十二指肠／空肠（DUODENUM/JEJUNUM）', '2.6 十二指肠／空肠（DUODENUM/JEJUNUM）

一般所见勾选项：`Normal`、`Foreign body`、`Mass`、`Polyp`、`Parasite(s)`。

必须填写的两项操作细节：
- `How far was the tip of the scope advanced?`（内镜先端推进深度）——横线填空。
- `Was/were the papilla(e) seen?`（是否见到乳头）——`Yes (which? ________)` / `No`，即勾选 Yes 时须写明是哪一个乳头。

十二指肠／空肠病变评分表：

| Lesion | Code | Comments (include location) |
|---|---|---|
| Can''t inflate lumen | | |
| Hyperemia/vascularity | | |
| Edema | | |
| Discoloration | | |
| Friability | | |
| Texture 质地 | | |
| Hemorrhage | | |
| Erosion/ulcer | | |
| Lacteal dilatation 乳糜管扩张 | | |
| Contents (mucus/bile/food) | | |
| Other | | |

2.7 意见与签署

- `Comments and Recommendations:`（意见与建议）——表单给出 3 行长横线。
- `Endoscopist signature _____________________`（内镜操作者签名）。

3. 下消化道内镜检查报告表

3.1 基本信息与操作记录项

| 填写项（原文） | 中文对照 | 备注 |
|---|---|---|
| Date of procedure | 操作日期 | 虚线 |
| Case Number | 病例编号 | 虚线 |
| Patient and client information | 患畜与主人信息 | `(card or stamp)` |
| PROCEDURE(S) | 所行操作 | 横线 |
| Indication(s) for procedure | 适应证 | 横线 |
| Endoscope(s) used | 所用内镜 | 横线 |
| Forceps used | 所用活检钳 | 原文此栏不含 retrieval device |
| **Method of preparing colon** | **结肠准备方式** | 下消化道表特有项，横线 |', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 问题／并发症', '3.2 问题／并发症

勾选项：`None`、**`Colonic preparation inadequate`（结肠准备不充分，下消化道特有）**、`Perforation`、`Excessive bleeding`、`Anesthetic complications`、`Excessive time`、`Other`。附 `Comments:` 横线。

未完成事项原因栏（较上消化道表少一项异物取出）：

| 原文 | 中文 |
|---|---|
| Unable to complete full examination: why? | 无法完成完整检查：原因 |
| Unable to obtain adequate biopsies: why? | 无法取得足够活检：原因 |
| Visualization obscured why? | 视野受阻：原因 |

3.3 采样与记录

- SAMPLING：`Biopsy`、`Brush cytology`、`Washing`、`Aspiration`（**原文此表无 `Foreign body retrieved` 项**）。
- DOCUMENTATION：`Video`、`Photographs`。

3.4 结肠（COLON）

一般所见勾选项：`Normal`、`Foreign body`、`Parasite(s)`、`Mass`、`Polyp`。

结构可视性勾选：`Visualized:` 下列 `ileo-colic valve`（回结肠瓣）、`ceco-colic valve (dog)`（回盲瓣，犬）、`cecum (cat)`（盲肠，猫）。

必填推进信息：`If did not see ileo-colic valve area, how far was the scope advanced ?`（若未见回结肠瓣区域，内镜推进深度）。

结肠病变评分表（`Code: Normal = 0 Mild = 1 Moderate = 2 Severe = 3`）：

| Lesion | Code | Comments (include location) |
|---|---|---|
| Hyperemia/vascularity | | |
| Discoloration | | |
| Friability /Hemorrhage 易脆性／出血（原表合并为一行） | | |
| Erosion/ulcer | | |
| Intussusception 肠套叠 | | |
| Stricture 狭窄 | | |
| Artifact 伪影／人为假象 | | |
| Other | | |', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 回肠（ILEUM）', '3.5 回肠（ILEUM）

段首勾选项：`NOT EXAMINED`（未检查）、`Normal`、`Foreign body`、`Parasite(s)`、`Mass`。

| 操作记录项（原文） | 可勾选值 |
|---|---|
| Tried to pass scope through ileocolic valve | Successful / Unsuccessful |
| Tried to biopsy the ileum | Successful / Unsuccessful |
| Biopsies taken by | Direct visualization / Blindly passing forceps through ileocolic valve |

回肠病变评分表：

| Lesion | Code | Comments (include location) |
|---|---|---|
| Can''t inflate lumen | | |
| Hyperemia/vascularity | | |
| Edema | | |
| Discoloration | | |
| Friability/Hemorrhage | | |
| Erosion/ulcer | | |
| Lacteal dilatation | | |
| Texture of mucosa 黏膜质地 | | |
| Mass 肿物 | | |
| Other | | |

3.6 盲肠（CECUM）

段首勾选项：`NOT EXAMINED`、`Normal`、`Foreign body`、`Parasite(s)`、`Mass`。
操作记录项：`Tried to intubate the cecum (dogs):` → `Successful` / `Unsuccessful`（犬盲肠插管尝试）。

盲肠病变评分表：

| Lesion | Code | Comments (include location) |
|---|---|---|
| Can''t inflate lumen | | |
| Hyperemia/vascularity | | |
| Edema | | |
| Discoloration | | |
| Friability/Hemorrhage | | |
| Texture 质地 | | |
| Erosion/ulcer | | |
| Other | | |

3.7 意见与签署

- `Comments and Recommendations:`——下消化道表给出 5 行长横线（上消化道表为 3 行）。
- `Endoscopist signature _____________________`。', 'dog', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 上下消化道两表差异速查', '4. 上下消化道两表差异速查

| 项目 | 上消化道表 | 下消化道表 |
|---|---|---|
| 器械栏 | Forceps/retrieval device(s) used | Forceps used |
| 肠道准备栏 | 无 | Method of preparing colon |
| 并发症特有项 | Unable to retrieve foreign object | Colonic preparation inadequate |
| 采样特有项 | Foreign body retrieved | 无 |
| 检查段落 | 食管、胃、十二指肠/空肠 | 结肠、回肠、盲肠 |
| 特有病变行 | Dilation、Hiatal hernia（食管）、Passing scope through pylorus（胃） | Intussusception、Stricture、Artifact（结肠）、Mass（回肠） |
| 易脆性/出血行 | 分为两行（Hemorrhage、Friability） | 合并为 `Friability/Hemorrhage` 一行 |
| 意见栏行数 | 3 行 | 5 行 |
| 食管/结肠表行差异 | 食管表无 `Can''t inflate lumen`、无 `Edema` 行 | 结肠表无 `Can''t inflate lumen`、无 `Edema` 行 |', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 可填写项总清单（供精确检索）', '5. 可填写项总清单（供精确检索）

**上消化道表，按表单出现顺序：** `Date of procedure`；`Case Number`；`Patient and client information (card or stamp)`；`PROCEDURE(S)`；`Indication(s) for procedure`；`Endoscope(s) used`；`Forceps/retrieval device(s) used`；`PROBLEMS/COMPLICATIONS: None / Perforation / Excessive bleeding / Anesthetic complications / Excessive time / Other`；`Comments`；`Unable to complete full examination: why?`；`Unable to obtain adequate biopsies: why?`；`Unable to retrieve foreign object: why?`；`Visualization obscured why?`；`SAMPLING: Biopsy / Brush cytology / Washing / Aspiration / Foreign body retrieved`；`DOCUMENTATION: Video / Photographs`；`ESOPHAGUS: Normal / Foreign body / Mass / Stricture / Hiatal hernia`；`Code: Normal = 0 Mild = 1 Moderate = 2 Severe = 3`；`STOMACH: Normal / Foreign body / Mass / Polyp(s) / Parasite(s)`；`Site(s) of lesions: Fundus / Body / Incisura / Antrum / Pylorus`；`Site(s) of biopsies: Fundus / Body / Incisura / Antrum / Pylorus`；`DUODENUM/JEJUNUM: Normal / Foreign body / Mass / Polyp / Parasite(s)`；`How far was the tip of the scope advanced?`；`Was/were the papilla(e) seen? Yes (which? ) / No`；`Comments and Recommendations`；`Endoscopist signature`。', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 可填写项总清单（供精确检索） (2)', '**下消化道表，按表单出现顺序：** `Date of procedure`；`Case Number`；`Patient and client information (card or stamp)`；`PROCEDURE(S)`；`Indication(s) for procedure`；`Endoscope(s) used`；`Forceps used`；`Method of preparing colon`；`PROBLEMS/COMPLICATIONS: None / Colonic preparation inadequate / Perforation / Excessive bleeding / Anesthetic complications / Excessive time / Other`；`Comments`；`Unable to complete full examination: why?`；`Unable to obtain adequate biopsies: why?`；`Visualization obscured why?`；`SAMPLING: Biopsy / Brush cytology / Washing / Aspiration`；`DOCUMENTATION: Video / Photographs`；`COLON: Normal / Foreign body / Parasite(s) / Mass / Polyp`；`Visualized: ileo-colic valve / ceco-colic valve (dog) / cecum (cat)`；`If did not see ileo-colic valve area, how far was the scope advanced?`；`Code: Normal = 0 Mild = 1 Moderate = 2 Severe = 3`；`ILEUM: NOT EXAMINED / Normal / Foreign body / Parasite(s) / Mass`；`Tried to pass scope through ileocolic valve: Successful / Unsuccessful`；`Tried to biopsy the ileum: Successful / Unsuccessful`；`Biopsies taken by: Direct visualization / Blindly passing forceps through ileocolic valve`；`CECUM: NOT EXAMINED / Normal / Foreign body / Parasite(s) / Mass`；`Tried to intubate the cecum (dogs): Successful / Unsuccessful`；`Comments and Recommendations`；`Endoscopist signature`。', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('犬猫内镜检查报告表 · 原文缺失与整理说明', '6. 原文缺失与整理说明

- 原始 PDF 为可勾选表单，PDF 文本抽取保留了勾选项文字与表格行，但**未保留勾选框的版式位置与页面分页归属**；上消化道表第 2、3 张病变表与胃、十二指肠段文字在抽取稿中交叉排列，本稿按解剖段对应关系归位（食管表含 Dilation 与 Gastroesophageal sphincter、胃表含 Passing scope through pylorus、十二指肠/空肠表含 Lacteal dilatation，据此判定归属）。
- 抽取稿元数据存在一处沿用痕迹：下消化道表的 `pdf_meta_title` 仍记为 `ENDOSCOPIC EXAMINATION REPORT -- UPPER ENDOSCOPY`，而其正文表头实为 `ENDOSCOPIC EXAMINATION REPORT: LOWER GI ENDOSCOPY`；本稿以正文表头为准。
- 表单未提供任何评分码的解释性文字或阈值定义（Normal/Mild/Moderate/Severe 的判定标准在原文此处缺失），配套的活检与组织病理学评估标准以外链 Wiley 论文形式给出（`Endoscopic, Biopsy and Histopathologic Guidelines for the Evaluation of Gastrointestinal Inflammation in Companion Animals`，<https://onlinelibrary.wiley.com/doi/pdf/10.1111/j.1939-1676.2009.0443.x>），正文未抓取。
- 两份表单均无给药剂量、麻醉方案、正常参考值范围或器械规格条目，原文亦未涉及。', '', '', '', '消化,内镜报告表,上消化道内镜,下消化道内镜,病变评分码,食管,表单背景与适用范围,上消化道内镜检查报告表,下消化道内镜检查报告表', 'informational', '犬猫内镜检查报告表（上消化道／下消化道）', 'official', 'https://wsava.org/global-guidelines/gastrointestinal-guidelines/', 'approved'),
('Hereditary Disease Guideline · 第 1 段', 'Hereditary Disease Guidelines（遗传病委员会立场文件）

板块页面正文（原文）

Guidelines

Hereditary Disease

Executive Summary

Given the importance of hereditary disease as a welfare issue in companion animals, the Hereditary Disease Committee educates and encourages veterinarians, veterinary teams and breeders to adopt ‘health-conscious’ breeding. It also works to ensure the optimum use of genetic testing and counselling to control hereditary diseases and genetic predispositions in dogs and cats.

Resources

[Genetic Database: Genetic Diseases, Tests and Testing Facilities](https://www.vet.upenn.edu/research/academic-departments/clinical-sciences-advanced-medicine/research-labs-centers/penngen/tests-worldwide)

[AKC Breed Club Directory](https://webapps.akc.org/club-search/)

[AKC Canine Health Foundation](http://www.akcchf.org/)

[The Orthopedic Foundation for Animals](http://www.ofa.org/)

[Dog Breed Health](http://www.dogbreedhealth.com/)

[Winn Feline Foundation](http://www.winnfelinefoundation.org/)

[Human Genome Project Talking Glossary](https://www.genome.gov/glossary/index.cfm)

Downloads', '', '', '', '遗传病,板块页面正文（原文）,Guidelines,Hereditary Disease', 'informational', 'Hereditary Disease Guidelines', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('Hereditary Disease Guideline · The Role of Health-Conscious Breeding an', 'The Role of Health-Conscious Breeding and Genetic Testing

[Read](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Hereditary-Disease-Committee-Position-Paper-HDC-Edited.pdf)

Translations

[Portuguese](https://wsava.org/wp-content/uploads/2020/01/HDC-Position-Paper-Portuguese.pdf)

本板块文档清单

共 2 份 PDF，按「英文 + 中文」策略收录 1 份，跳过小语种译本 1 份。

已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Read | EN |  | 2 | 3328 | [raw_extracts/WSAVA-Hereditary-Disease-Committee-Position-Paper-HDC-Edited.md](raw_extracts/WSAVA-Hereditary-Disease-Committee-Position-Paper-HDC-Edited.md) |

未收录（同一指南的其他语言译本）

- HDC-Position-Paper-Portuguese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/HDC-Position-Paper-Portuguese.pdf>', '', '', '', '遗传病,板块页面正文（原文）,Guidelines,Hereditary Disease', 'informational', 'Hereditary Disease Guidelines', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('Hereditary Disease Guideline · 外部引用（期刊论文 / 相关机构，未抓取正文）', '外部引用（期刊论文 / 相关机构，未抓取正文）

- Genetic Database: Genetic Diseases, Tests and Testing Facilities — <https://www.vet.upenn.edu/research/academic-departments/clinical-sciences-advanced-medicine/research-labs-centers/penngen/tests-worldwide>
- AKC Breed Club Directory — <https://webapps.akc.org/club-search/>
- AKC Canine Health Foundation — <http://www.akcchf.org/>
- The Orthopedic Foundation for Animals — <http://www.ofa.org/>
- Dog Breed Health — <http://www.dogbreedhealth.com/>
- Winn Feline Foundation — <http://www.winnfelinefoundation.org/>
- Human Genome Project Talking Glossary — <https://www.genome.gov/glossary/index.cfm>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', 'dog', '', '', '遗传病,板块页面正文（原文）,Guidelines,Hereditary Disease', 'informational', 'Hereditary Disease Guidelines', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('WSAVA 遗传病委员会立场文件 · 文件定位与核心主张', '1. 文件定位与核心主张

原文标题：**The Role of Health-Conscious Breeding and Genetic Testing in Reducing the Impact of Hereditary Disease**（健康意识育种与基因检测在降低遗传病影响中的作用），是一份 **A Position Paper from the WSAVA Hereditary Disease Committee**（立场文件），PDF 共 2 页。

开篇核心主张（原文逐字对应）：遗传病是伴侣动物的一项重要福利问题（Hereditary disease is an important welfare issue in companion animals）。为降低其影响，WSAVA 遗传病委员会敦促**兽医与繁育者**采取「健康意识」（health-conscious）育种，并确保充分利用**配前体格检查（pre-breeding physical examinations）、基因检测（genetic testing）与遗传咨询（counselling）**三项手段。

板块页面的执行摘要补充了委员会职责：鉴于遗传病作为伴侣动物福利问题的重要性，遗传病委员会负责教育并鼓励兽医、兽医团队和繁育者采取「健康意识」育种；同时致力于确保基因检测与遗传咨询得到最佳使用，以控制犬猫的遗传病与遗传易感性。

2. 健康意识育种（Health-conscious breeding）

WSAVA 对兽医与繁育者提出的要求可拆为两条：

2.1 选择种畜的标准必须包含与排除特定特征

- **必须纳入的标准：** 能够**自然交配/自然繁殖**（the ability to reproduce naturally）。
- **必须排除的特征：** 使个体易于发生遗传病的解剖学特征（anatomical characteristics that predispose to hereditary disease）。原文明确列举：
  - 极端体型／极端外貌（extreme conformations），包括：
  - 体型大小（size）
  - 皮肤褶皱（skin folds）
  - 角度／肢势（angulation）
  - 极端短头／扁脸（extremely short faces, brachycephaly）
- **品种层面已存在易感解剖构造时：** 选择方向应转向**温和、不那么极端的解剖构造**（selection should be towards a moderate and less extreme anatomy）。', '', '', '', '遗传病,立场文件,健康意识育种,基因检测,遗传咨询,文件定位与核心主张', 'informational', 'WSAVA 遗传病委员会立场文件：健康意识育种与基因检测的作用', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('WSAVA 遗传病委员会立场文件 · 配前健康筛查（pre-breeding health screening）', '2.2 配前健康筛查（pre-breeding health screening）

WSAVA 呼吁繁育者利用配前健康筛查，挑选**更可能产出健康后代**的个体。原文列出筛查程序（pre-screening procedures）包括：

| 筛查环节（原文） | 中文 |
|---|---|
| an examination of the medical history | 既往病史／医疗记录审查 |
| veterinary physical examination | 兽医体格检查 |
| breed-specific genetic testing | 品种特异性基因检测 |

品种特异性建议的来源（原文）：许多可靠渠道，包括**品种原属俱乐部（parent breed clubs）、犬舍俱乐部与猫舍俱乐部（kennel and cattery clubs）、动物健康组织（animal health organizations）**。

3. 基因检测的作用（The role of genetic testing）

原文对兽医与检测方提出四项要求：

1. **自我教育：** WSAVA 呼吁兽医了解基因检测的**可用性（availability）与正确使用方式（proper use）**，针对其患畜开展。
2. **检测须针对特定疾病与品种验证：** 要求**单项基因检测须针对所检测的具体疾病和具体品种完成验证**（validated for the specific disease and the breed being tested）。
3. **跨品种不可直接套用：** 原文关键逻辑——某突变可在多个品种中分离（segregate in multiple breeds），但**并非在所有品种中都与疾病相关**。因此**为一品种开发的 DNA 检测对其他品种可能并不适用**（a DNA test for one breed may not be appropriate for others）。
4. **实验室资质：** 要求基因检测由**熟练且专业化的实验室**执行，且这些实验室须使用**适当的对照与流程**（proficient and specialized laboratory that utilizes proper controls and procedures）。', '', '', '', '遗传病,立场文件,健康意识育种,基因检测,遗传咨询,文件定位与核心主张', 'informational', 'WSAVA 遗传病委员会立场文件：健康意识育种与基因检测的作用', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('WSAVA 遗传病委员会立场文件 · 多重检测panel 与结果过滤', '3.1 多重检测panel 与结果过滤

原文指出现状变化：**多重基因检测panel（multiplex genetic testing panels）**，一次报告**超过 100 个已鉴定疾病相关突变**的结果，正在取代单个基因的逐一检测，因为对每份 DNA 样本运行所有可用检测在实操上更可行、价格更可承受（practical and more affordable）。

由此带来的必要步骤：对此类检测，**过滤掉对该个体所属品种没有临床意义的结果，是至关重要的**（The need to filter out results with no clinical implications for the individual''s breed is essential with these types of test）。

4. 遗传咨询的重要性（The importance of genetic counselling）

WSAVA 要求遗传咨询**必须针对个体动物与具体情形定制（tailored to the individual animal and circumstance）**，原文列出咨询必须纳入的四类变量：

| 变量（原文） | 中文 |
|---|---|
| the mode of inheritance | 遗传方式 |
| the penetrance of the mutation being tested for | 所检测突变的外显率 |
| the breed being tested | 被检测的品种 |
| the frequency of the mutation within that breed | 该突变在该品种内的频率 |

结论性要求：每一例 DNA 检测结果的解释及随之的遗传咨询建议，必须与**该检测、该个体、该品种**三者相称，**以避免就育种、治疗或安乐死做出不当决定**（to avoid improper decisions regarding breeding, treatment or euthanasia being made）。

5. 进一步信息与工具（Further information）', '', '', '', '遗传病,立场文件,健康意识育种,基因检测,遗传咨询,文件定位与核心主张', 'informational', 'WSAVA 遗传病委员会立场文件：健康意识育种与基因检测的作用', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('WSAVA 遗传病委员会立场文件 · WSAVA 资助的遗传病检测实验室数据库', '5.1 WSAVA 资助的遗传病检测实验室数据库

- **Canine and Feline Hereditary Disease (DNA) Testing Laboratories database**（犬猫遗传病 DNA 检测实验室数据库）。
- 地址（原文）：`http://research.vet.upenn.edu/WSAVA-LabSearch`
- 检索维度：可按**品种（breed）、疾病（disease）、检测实验室（testing laboratory）** 检索。
- 每个疾病突变都附有**其发现经同行评审的发表文献引用链接**（a link to the peer-reviewed published citation of its discovery）。
- 委员会正在为兽医和繁育者**开发教育资源与工具**。

5.2 基因检测协调倡议

- **International Partnership for Dogs**（国际犬类伙伴关系）的 **Harmonization of Genetic Testing**（基因检测协调）倡议正在开发一个网站。
- 地址（原文）：`https://dogwellnet.com/ctp/`
- 网站用途：记录**各实验室的质量保证流程与程序（individual laboratory quality assurance processes and procedures）**，以及**按犬品种列出的检测适用性（test applicability by dog breed）**。

6. 委员会署名成员

原文末尾列出 WSAVA Hereditary Disease Committee 成员（逐字照抄）：

| 成员 | 角色 |
|---|---|
| Dr Jerold Bell | Chair（主席） |
| Dr. Cynthia Cole | 委员 |
| Dr Helle Friis Proschowsky | 委员 |
| Dr Ake Hedhammar | 委员 |
| Dr Susan Little | 委员 |
| Dr Monique Megens | 委员 |
| Dr Cathryn Mellersh | 委员 |
| Dr Claire Wade | 委员 |', '', '', '', '遗传病,立场文件,健康意识育种,基因检测,遗传咨询,文件定位与核心主张', 'informational', 'WSAVA 遗传病委员会立场文件：健康意识育种与基因检测的作用', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('WSAVA 遗传病委员会立场文件 · 立场要点速查表', '7. 立场要点速查表

| 议题 | WSAVA 呼吁（立场） |
|---|---|
| 种畜选择标准 | 必须包含自然繁殖能力；排除 predisposing 遗传病的解剖特征（size、skin folds、angulation、brachycephaly） |
| 已极端化的品种 | 选择转向温和、非极端的解剖构造 |
| 配前筛查 | 病史审查 + 兽医体格检查 + 品种特异性基因检测 |
| 检测验证 | 单项检测须针对该疾病与该品种验证 |
| 跨品种外推 | 一品种的检测未必适用于另一品种 |
| 实验室 | 须由熟练、专业、使用适当对照与流程的实验室执行 |
| 多重 panel | 报告 >100 个突变，须过滤对本品种无临床意义的结果 |
| 遗传咨询 | 按遗传方式、外显率、品种、突变品种内频率定制 |
| 决策风险 | 避免不当的育种、治疗或安乐死决定 |

8. 原文缺失与整理说明

- 本立场文件原文未提供具体疾病清单、具体品种的推荐检测项目、任何数值阈值或剂量；此类内容需查第 5.1 节的数据库，**原文此处缺失**。
- 原始 PDF 为 2 页版式，文本抽取已丢失分页与版式（`pdf_meta_title` 为空，抽取稿标题被记为 "Read"，实为板块页面下载按钮文字）；正文内容完整（抽取 3328 字符）。
- 该指南另有葡语译本 `HDC-Position-Paper-Portuguese.pdf`，按本知识库「英文 + 中文」收录策略未抓取，内容未纳入本稿。', '', '', '', '遗传病,立场文件,健康意识育种,基因检测,遗传咨询,文件定位与核心主张', 'informational', 'WSAVA 遗传病委员会立场文件：健康意识育种与基因检测的作用', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('WSAVA 遗传病委员会立场文件 · 延伸资料', '延伸资料

板块页面列出的外部资源（**正文未抓取，仅登记链接**）：

- Genetic Database: Genetic Diseases, Tests and Testing Facilities — <https://www.vet.upenn.edu/research/academic-departments/clinical-sciences-advanced-medicine/research-labs-centers/penngen/tests-worldwide>
- AKC Breed Club Directory — <https://webapps.akc.org/club-search/>
- AKC Canine Health Foundation — <http://www.akcchf.org/>
- The Orthopedic Foundation for Animals — <http://www.ofa.org/>
- Dog Breed Health — <http://www.dogbreedhealth.com/>
- Winn Feline Foundation — <http://www.winnfelinefoundation.org/>
- Human Genome Project Talking Glossary — <https://www.genome.gov/glossary/index.cfm>', 'dog', '', '', '遗传病,立场文件,健康意识育种,基因检测,遗传咨询,文件定位与核心主张', 'informational', 'WSAVA 遗传病委员会立场文件：健康意识育种与基因检测的作用', 'official', 'https://wsava.org/global-guidelines/hereditary-disease/', 'approved'),
('Liver Disease Guidelines · 第 1 段', 'Liver Disease Guidelines（犬猫肝病组织学诊断标准）

板块页面正文（原文）

Guidelines

Liver Disease

Executive Summary

The Liver Standardization Project created a global standard for the histological evaluation of liver tissues for liver diseases of dogs and cats, including unified nomenclature, well-defined histological diagnostic criteria, and precise definitions of chronicity stages and grades of disease.

Downloads

Standards for Clinical and Histological Diagnosis of Canine and Feline Liver Diseases

[Download the Book](https://www.sciencedirect.com/book/9780702027918/wsava-standards-for-clinical-and-histological-diagnosis-of-canine-and-feline-liver-diseases?via=ihub=)', '', '', '', '肝病,板块页面正文（原文）,Guidelines,Liver Disease', 'informational', 'Liver Disease Guidelines', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('Liver Disease Guidelines · Endorsements', 'Endorsements

- Academy of Veterinary Dentistry (AVD)
- All-Ukrainian Union of Veterinary Dentists (BCBC)
- Asociacion de Veterinarios Espanoles Especialistas en Pequenos Animales (AVEPA)
- Associacao Portugesa de Medicos Veterinarios Especialistas em Animais de Companhia (APMVEAC)
- Bulgarian Association of Small Animal Veterinarians (BASAV)
- Canadian Veterinary Medical Association (CVMA)
- Companion Animal Veterinaries, New Zealand Veterinary Association (CVA)
- Croatian Small Animal Veterinary Section (CSAVS)
- Czech Small Animal Veterinary Association (CSAVA)
- Hellenic Companion Animal Veterinary Society(HCAVS)
- Hellenic Veterinary Medical Society (HVMS)
- International Society of Feline Medicine (ISFM)
- International Veterinary Academy of Pain Management (IVAPM)
- Japanese Study Group of Veterinary Maxillofacial Oral Surgery
- Kenyan Small and Companion Animal Veterinary Association (KESCAVA)
- Lithuania Small Animal Veterinary Association (LSAVA)
- Macedonian Small Animal Veterinary Association (MSAVA)
- Montenegro Association of Small Animal Practitioners (MASAP)
- Netherlands Association of Companion Animal Medicine (NACAM)
- Norwegian Small Animal Vets Association (NSAVA)
- Philippine Animal Hospital Association (PAHA)
- Polish Small Animal Veterinary Association (PSAVA)
- Slovene Small Animal Veterinary Association (SZVMZ)
- Small Animal Veterinary Association Belgium- Flanders SAVAB -Flanders)
- Spanish Veterinary Dental and Maxillofacial Surgery Society (SEOVE)
- Swedish Veterinary Dental Association (SSDt)
- Veterinary Association of Namibia (VAN)
- Veterinary Ireland (VICAS)', '', '', '', '肝病,板块页面正文（原文）,Guidelines,Liver Disease', 'informational', 'Liver Disease Guidelines', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('Liver Disease Guidelines · 本板块文档清单', '本板块文档清单

共 0 份 PDF，按「英文 + 中文」策略收录 0 份，跳过小语种译本 0 份。

已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|

外部引用（期刊论文 / 相关机构，未抓取正文）

- Download the Book — <https://www.sciencedirect.com/book/9780702027918/wsava-standards-for-clinical-and-histological-diagnosis-of-canine-and-feline-liver-diseases?via=ihub=>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '肝病,板块页面正文（原文）,Guidelines,Liver Disease', 'informational', 'Liver Disease Guidelines', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 本板块资料的性质（重要前提）', '1. 本板块资料的性质（重要前提）

- WSAVA 站点 `Liver Disease Guidelines` 板块页面（page_id 511，发布于 2024-03-26，最后更新 2024-05-02，抓取于 2026-10-19）**只提供一段执行摘要、一个指向外部电子书的下载链接和一份背书机构名单**。页面标题层级为 `Guidelines` → `Liver Disease` → `Executive Summary` → `### Downloads` → `### Endorsements`。
- 板块文档清单原文记载：**共 0 份 PDF，按「英文 + 中文」策略收录 0 份，跳过小语种译本 0 份**；`raw_extracts/` 与 `pdf/` 目录均为空。
- 因此：**组织学诊断标准的具体条目、命名表、慢性期分期（stage）与分级（grade）的判定阈值，原文此处缺失**——这些内容存在于页面所链接的 Elsevier/ScienceDirect 电子书正文中，本次爬虫未抓取该书正文，本稿不予转述或推测。', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 执行摘要（原文逐字对应）', '2. 执行摘要（原文逐字对应）

页面 `Executive Summary` 小节的英文原文如下（逐字）：

> The Liver Standardization Project created a global standard for the histological evaluation of liver tissues for liver diseases of dogs and cats, including unified nomenclature, well-defined histological diagnostic criteria, and precise definitions of chronicity stages and grades of disease.

拆成可检索的要点表：

| 要点（原文） | 中文 | 说明 |
|---|---|---|
| The Liver Standardization Project | 肝脏标准化项目 | 该项工作的主导主体，页面未列出委员会成员名单 |
| created a global standard | 创建了**全球标准** | 适用范围为全球 |
| for the histological evaluation of liver tissues | 用于**肝组织的组织学评估** | 对象是组织学（切片）评估，非血清学或影像 |
| for liver diseases of dogs and cats | 针对**犬和猫**的肝病 | 仅犬猫两个物种 |
| including unified nomenclature | 包含**统一的命名法** | 具体术语表：原文此处缺失 |
| well-defined histological diagnostic criteria | **明确定义的组织学诊断标准** | 具体标准条目：原文此处缺失 |
| and precise definitions of chronicity stages and grades of disease | 并对**慢性期分期（stages）与疾病分级（grades）**给出精确定义 | 分期/分级方案（如 0–I–II–III/IV 之类）：原文此处缺失，页面未给出任何级别名称或数值 |', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 标准载体的书目信息', '3. 标准载体的书目信息

页面 Downloads 小节给出该标准的出版物名称与链接：

| 项目 | 内容（逐字照抄） |
|---|---|
| 书名 | Standards for Clinical and Histological Diagnosis of Canine and Feline Liver Diseases |
| 页面标题前缀 | WSAVA Standards for Clinical and Histological Diagnosis of Canine and Feline Liver Diseases（链接 slug 中体现） |
| 链接文字 | Download the Book |
| URL | https://www.sciencedirect.com/book/9780702027918/wsava-standards-for-clinical-and-histological-diagnosis-of-canine-and-feline-liver-diseases?via=ihub= |
| URL 中的编号 | 9780702027918（照抄，页面未标注其为 ISBN 还是其他编号） |
| 页面章节归属 | 同时出现在 `### Downloads` 与 `### Endorsements` 两个小节下 |

**该书正文内容未抓取，本稿不转述、不概括、不推测其章节结构与结论。**', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 板块页面列出的背书机构（Endorsements）', '4. 板块页面列出的背书机构（Endorsements）

页面在 `### Endorsements` 下逐条列出机构全称与缩写。以下按原顺序、原文拼写（含原文自身的空格与标点状况）完整还原：

| # | 机构全称 | 缩写 |
|---|---|---|
| 1 | Academy of Veterinary Dentistry | AVD |
| 2 | All-Ukrainian Union of Veterinary Dentists | BCBC |
| 3 | Asociacion de Veterinarios Espanoles Especialistas en Pequenos Animales | AVEPA |
| 4 | Associacao Portugesa de Medicos Veterinarios Especialistas em Animais de Companhia | APMVEAC |
| 5 | Bulgarian Association of Small Animal Veterinarians | BASAV |
| 6 | Canadian Veterinary Medical Association | CVMA |
| 7 | Companion Animal Veterinaries, New Zealand Veterinary Association | CVA |
| 8 | Croatian Small Animal Veterinary Section | CSAVS |
| 9 | Czech Small Animal Veterinary Association | CSAVA |
| 10 | Hellenic Companion Animal Veterinary Society | HCAVS |
| 11 | Hellenic Veterinary Medical Society | HVMS |
| 12 | International Society of Feline Medicine | ISFM |
| 13 | International Veterinary Academy of Pain Management | IVAPM |
| 14 | Japanese Study Group of Veterinary Maxillofacial Oral Surgery | （原文未给缩写） |
| 15 | Kenyan Small and Companion Animal Veterinary Association | KESCAVA |
| 16 | Lithuania Small Animal Veterinary Association | LSAVA |
| 17 | Macedonian Small Animal Veterinary Association | MSAVA |
| 18 | Montenegro Association of Small Animal Practitioners | MASAP |
| 19 | Netherlands Association of Companion Animal Medicine | NACAM |
| 20 | Norwegian Small Animal Vets Association | NSAVA |
| 21 | Philippine Animal Hospital Association | PAHA |
| 22 | Polish Small Animal Veterinary Association | PSAVA |
| 23 | Slovene Small Animal Veterinary Association | SZVMZ |
| 24 | Small Animal Veterinary Association Belgium- Flanders | SAVAB -Flanders) |
| 25 | Spanish Veterinary Dental and Maxillofacial Surgery Society | SEOVE |
| 26 | Swedish Veterinary Dental Association | SSDt |
| 27 | Veterinary Association of Namibia | VAN |
| 28 | Veterinary Ireland | VICAS |', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 使用该名单时必须注意的疑点', '4.1 使用该名单时必须注意的疑点

该名单中有 5 家机构名称含 Dental / Dentistry / Maxillofacial Oral Surgery（第 1 家 AVD、第 2 家 BCBC、第 14 家日本兽口腔颌面外科研究组、第 25 家 SEOVE、第 26 家 SSDt），与「肝病组织学」主题不相符。经核查，**同一份名单原样出现在 `02-dental-guidelines/00-板块说明.md` 中**，因此这更可能是 WSAVA 板块页面共用模态或抓取归并造成的内容错位。**本稿不对「这些机构为何背书肝病标准」作任何推断**；引用时请以 WSAVA 原页面为准。

5. 页面元数据与逐字语句清单

5.1 板块页面 frontmatter（逐字）

| 字段 | 值 |
|---|---|
| type | section |
| section | liver-disease-guidelines |
| section_zh | 犬猫肝病组织学诊断标准 |
| title | Liver Disease Guidelines |
| source_url | https://wsava.org/global-guidelines/liver-disease-guidelines/ |
| page_id | 511 |
| published | 2024-03-26T16:43:21 |
| updated | 2024-05-02T14:25:32 |
| language | en |
| crawled_at | 2026-10-19T10:24:08Z |', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 页面全部实质性英文语句（可逐字引用）', '5.2 页面全部实质性英文语句（可逐字引用）

页面正文中**除执行摘要那一句之外，不存在其他说明性句子**。可引用的其余文本仅为标题、链接文字与清单条目：

| 原文语句 | 性质 |
|---|---|
| `Guidelines` | 栏目标题 |
| `Liver Disease` | 指南名称 |
| `Executive Summary` | 小节标题 |
| `The Liver Standardization Project created a global standard for the histological evaluation of liver tissues for liver diseases of dogs and cats, including unified nomenclature, well-defined histological diagnostic criteria, and precise definitions of chronicity stages and grades of disease.` | **页面唯一的内容句** |
| `### Downloads` | 小节标题 |
| `Standards for Clinical and Histological Diagnosis of Canine and Feline Liver Diseases` | 标准载体书名 |
| `[Download the Book](https://www.sciencedirect.com/book/9780702027918/...)` | 链接与链接文字 |
| `### Endorsements` | 小节标题 |
| 第 4 节的 28 条机构名 | 名单条目 |

板块文档清单原文三行（逐字）：`共 0 份 PDF，按「英文 + 中文」策略收录 0 份，跳过小语种译本 0 份。`；「已收录（原文已抽取到 raw_extracts/）」表格**只有表头、无任何数据行**；「外部引用（期刊论文 / 相关机构，未抓取正文）」下仅一条 `Download the Book`。', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 背书名单的文本保真记录', '6. 背书名单的文本保真记录

为后续抽取/校验使用，记录以下原文自身状态（**均为原样，未作修正**）：

- 名单共 **28 条**；其中 **27 条带缩写**，仅 `Japanese Study Group of Veterinary Maxillofacial Oral Surgery` 一条无缩写。
- `Companion Animal Veterinaries, New Zealand Veterinary Association (CVA)` —— 原文作 **Veterinaries**（非 Veterinarians），照录。
- `Hellenic Companion Animal Veterinary Society(HCAVS)` —— 原文**括号前无空格**，照录。
- `Small Animal Veterinary Association Belgium- Flanders SAVAB -Flanders)` —— 原文**缩写栏括号不闭合**（缺左括号），照录。
- `Associacao Portugesa de Medicos Veterinarios Especialistas em Animais de Companhia (APMVEAC)` —— 原文**无变音符号**（Portugesa/Portuguesa），照录。
- 部分机构名称与主题明显相关（`International Society of Feline Medicine (ISFM)` 为猫科、多家为小动物/practitioner 组织），部分为牙科口腔颌面相关（见 4.1）。', 'cat', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 机构名称中的地域与专科提示（仅由名称字面译出，不涉原页面未提供的信息）', '6.1 机构名称中的地域与专科提示（仅由名称字面译出，不涉原页面未提供的信息）

| 名称中出现的地域词 | 中文 | 名称中出现的专科词 | 中文 |
|---|---|---|---|
| Bulgarian | 保加利亚 | Dentistry / Dental | 牙科／口腔科 |
| All-Ukrainian | 全乌克兰 | Maxillofacial Oral Surgery | 颌面口腔外科 |
| Espanoles | 西班牙 | Feline Medicine | 猫科医学 |
| Portugesa | 葡萄牙 | Pain Management | 疼痛管理 |
| Canadian | 加拿大 | Small Animal / Practitioners | 小动物／临床医师 |
| New Zealand | 新西兰 | Companion Animal / Animais de Companhia | 伴侣动物 |
| Croatian | 克罗地亚 | Animal Hospital | 动物医院 |
| Czech | 捷克 | Veterinary Ireland | 爱尔兰兽医 |
| Hellenic | 希腊 | Kenyan | 肯尼亚 |
| Japanese | 日本 | Lithuania | 立陶宛 |
| Macedonian | 马其顿 | Montenegro | 黑山 |
| Netherlands | 荷兰 | Norwegian | 挪威 |
| Philippine | 菲律宾 | Polish | 波兰 |
| Slovene | 斯洛文尼亚 | Belgium - Flanders | 比利时弗拉芒 |
| Swedish | 瑞典 | Namibia | 纳米比亚 |

6.2 执行摘要整段中文译文（供检索命中）

「肝脏标准化项目为犬与猫肝病的肝组织组织学评估创建了一项全球标准，内容包括统一的命名法、明确定义的组织学诊断标准，以及对疾病慢性期分期（stages）与分级（grades）的精确定义。」该句中**四项成果**（全球标准、统一命名法、组织学诊断标准、分期与分级精确定义）是页面给出的全部定性信息，**没有任何一项在页面上展开**。', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('犬猫肝病临床与组织学诊断标准 · 犬猫肝病标准的可用与不可用信息边界', '7. 犬猫肝病标准的可用与不可用信息边界

| 可以据此稿回答的问题 | 无法据此稿回答的问题（需原始电子书或其他来源） |
|---|---|
| 该标准由哪个项目制定（Liver Standardization Project） | 具体某疾病的组织学诊断标准条目 |
| 标准覆盖哪些物种（犬、猫） | 统一命名法的具体术语清单 |
| 标准覆盖哪类评估（组织学评估肝组织） | 慢性期 stage 的定义与各期划分 |
| 标准的正式载体书名与获取链接 | 疾病 grade 的定义与分级阈值 |
| 页面所列背书机构清单 | 各机构与该标准的关系说明 |
| 页面更新与抓取时间 | 临床诊断路径、实验室指标、治疗方案（页面完全未涉及） |

8. 延伸资料

页面指向的外部书目（**正文未抓取，仅登记链接**）：

- WSAVA Standards for Clinical and Histological Diagnosis of Canine and Feline Liver Diseases（Download the Book）— <https://www.sciencedirect.com/book/9780702027918/wsava-standards-for-clinical-and-histological-diagnosis-of-canine-and-feline-liver-diseases?via=ihub=>', '', '', '', '肝病,肝脏标准化项目,组织学评估,肝组织,统一命名法,本板块资料的性质（重要前提）,执行摘要（原文逐字对应）,标准载体的书目信息', 'informational', '犬猫肝病临床与组织学诊断标准（肝脏标准化项目）', 'official', 'https://wsava.org/global-guidelines/liver-disease-guidelines/', 'approved'),
('Microchip Identification Gui · 第 1 段', 'Microchip Identification Guidelines（微芯片识别指南）

板块页面正文（原文）

Guidelines

Microchip Identification

Executive Summary

These Global Guidelines set out recommended implantation sites for microchips and give information on geographic and species variations (where they exist). In addition to dogs and cats, they also provide guidance for microchipping agricultural animals, other mammals, amphibians, avians and reptiles. They include a section providing recommendations on ensuring the proper function of the microchip reader, which is an integral, and often overlooked, component of the overall microchip identification system.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Guidelines', 'Guidelines

On this page you will find the Microchip Identification Guidelines including the following points:

Issues pertaining to microchip technology (ie communication protocol) have been the thrust of standardization efforts in recent years; initially by microchip user groups and then through the International Standards Organization (ISO).

Fortunately, these efforts have resulted in the adoption of global standards (ie, ISO 11784 and 11785) that have facilitated wide spread implementation of microchip identification thanks to stronger marketplace confidence. However, despite these standardization efforts, the identification network is ineffective if the reader and microchip cannot come in close enough proximity to communicate with one another, thereby providing the animal’s unique identification number. To optimise this interaction, the international veterinary community has been diligently working on standardized microchip implantation sites for various species of animals.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Guidelines (2)', 'This document details both recommended implantation sites as well as providing information on geographic and species variations (where they exist). Beginning with dogs and cats, it also provides information on agricultural animals, other mammals, amphibians, avians and reptiles. There is also a section providing recommendations on ensuring the proper function of the microchip reader, which is an integral, and often overlooked, component of the overall microchip identification system.

Please disseminate this information to your membership, thereby increasing user awareness and adoption of these standards. Cooperatively, we can ensure the viability of this technology well into the future.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Guidelines (3)', 'Standardization of microchip implantation sites is essential to the overall integrity of a radio frequency identification (RFID) system. This is especially relevant to FDX based communication protocols since their effective interrogation distance, the distance between reader and transponder, is relatively short. However, although standardized implantation sites are critical, one cannot overlook the importance of a functional reader in the identification of an implanted transponder – without this, the system fails. The following points are the recommendations of the World Small Animal Veterinary Association (WSAVA) Microchip Subcommittee for implantation sites in small (companion) animals. Attached to this document are suggestions regarding enhancing reader performance as well as currently recommended implantation sites in species other than small (companion) animals. It is up to the individual veterinarian to assess the need for the use of a local anaesthetic. Aseptic technique, as with any injection, is recommended.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip implantation sites for small (', 'Microchip implantation sites for small (companion) animals

Canine and Feline

In the canine and feline, there are two currently recognized implantation sites in use:

- The transponder (microchip) is implanted subcutaneous on the dorsal midline just cranial to the shoulder blades or scapula. This is the standard implantation site in all countries (including the United Kingdom [Wales, Scotland, England, and Northern Ireland] and the Republic of Ireland) excluding those of Europe.
- The transponder (microchip) is implanted subcutaneously in the midway region of the left neck. This is the standard implantation site in continental Europe (excluding the United Kingdom and the Republic of Ireland – see above).
- Until one common global site can be agreed upon, it is imperative that scanning concentrate on the implantation site commonly used in that geographic locale. Should an animal scan negative, it is strongly recommended that the alternative site in use, as defined above, also be scanned.

Recommended implantation sites in other species of animals', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip implantation sites for small ( (2)', 'In bilaterally symmetrical species, microchips should be implanted on the left side (unless used as an aid in the identification of sex – in this case males are implanted on the left, females on the right where applicable).

Mammals

Equine

In the equine, there are two recognized implantation sites currently in use

- The microchip is implanted within the nuchal ligament in its middle third or at the halfway point between the ears and the withers. This is the recommended implantation site in all countries except Australia.
- The microchip is implanted in the musculature of the left neck or the anterior injection triangle. Clipping of the hair, local anaesthetic and aseptic technique is required. This is the recommended implantation site in Australia. Due to the use of two implantation sites, please review and follow the scanning procedures as discussed previously under canine and feline.

Agricultural Animals', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip implantation sites for small ( (3)', 'The implantation site for the bovine, ovine, porcine and caprine or other species used for meat production is subcutaneously at the base of the left ear on the scutiform cartilage. It is strongly recommended that any implanted food producing animal should carry an external identifier to indicate that a microchip is present so that it can be recognised and recovered at slaughter. Local trade or government guidelines must govern the use of implanted microchips in food producing species as in some situations their use may not be permitted.

Elephants

Subcutaneously on the left side of the tail in the main caudal fold.

Hyrax and Loris

Subcutaneously on the left side of the intralumbar area.

Alpacas (as per Australia)

Subcutaneously midway on the left neck of top of the head behind the left ear.

Other mammals

If the adult length is >17 cm from the backbone (spine) to the shoulder blade – subcutaneously at the base of the left ear. If <17 cm – subcutaneously between the shoulder blades.

Amphibians

The microchip is to be implanted into the lymphatic cavity. The implantation site should be sealed with tissue glue.

Avians', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip implantation sites for small ( (4)', '5.5 kg adult weight and/or long-legged: subcutaneously at the base of the neck. <5.5 kg. adult weight: intramuscularly in the left pectoral muscle. Direct the implanter in a caudal (downward) direction. Use tissue glue and digital pressure or a suture to seal the implantation site.

Exceptions

Ratites

Up to four days old – implanted in the piping muscle behind the head on the left.

Older birds

Subcutaneously in the left thigh.

Emu

Implanted in the dorsal midline in the s/c lump (Australia).

Penguins and vultures

Subcutaneously at the base of the neck.

Fish

>30 cm in length: on the left side at the anterior base of the dorsal fin. <30 cm in length: on the left side into the coelomic cavity.

Reptiles

Chelonians

Left hind limb socket. Use a subcutaneous site in small chelonians, an intramuscular technique in large species as well as small species with thin skin. The implantation site should be sealed with tissue glue. Hibernating species should be implanted several weeks before the end of their active season in order to allow healing before hibernation.

Crocodilians

Subcutaneously anterior to the nuchal cluster.

Lizards', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip implantation sites for small ( (5)', '>12.5 cm snout to vent length – subcutaneously in the left inguinal region. <12.5 cm snout to vent length – intracoelomic.

Snakes

Subcutaneously on the left side of the neck, twice the length of the head from the tip of the nose.

***Note:** special recommendations have been made for implantation sites to be used in particular applications. It is recommended that primates kept in cages should be implanted intramuscularly in the back of the right forearm so that the microchips can be conveniently read while the animal grips the bars of its cage. Similarly, the recommendation is that big cats should be implanted in the shoulder region so that they can be read as they walk backwards and forwards while brushing against the bars of their cage. Such sites are different from implantation sites used by other operators. These sites should only be used in animals which, after implantation, will stay in one facility where the sight of the microchip is known to all operators and there is no risk of the microchip being missed by an operator failing to scan the unusual location.*', 'cat', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Enhancing Reader Performance', 'Enhancing Reader Performance

An often-overlooked factor in reader (scanner) performance is the user. How the user cares for and applies the reader can dramatically impact on reader performance. Fortunately, it is an area over which we, as users, have complete control, regardless of the manufacturer, and therefore can eliminate as a causative factor of poor performance.

Ensure that the reader in use is compatible with the communication protocols in use in your geographic locale (ie, forward and backward compatible).', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Enhancing Reader Performance (2)', 'Familiarize yourself with and follow the manufacturer’s recommendations regarding reader care and scanning technique. When evaluating for the presence of a microchip, scanning should begin at the standardized site of microchip implantation in that species and geographic locale. If a microchip is not immediately identified, scanning should encompass a larger area and be done in slowly expanding concentric circles. Some manufacturers recommend a figure-eight pattern. Scanning should be done with the reader touching, or brushing, the animal’s fur. Read distance can be slightly affected by the orientation of the microchip in relationship to the reader, and its impact will vary based on reader and microchip design. Fortunately, this rarely affects routine reader use. Although one cannot visualize the actual position of the implanted microchip relative to the reader during scanning, we can take advantage of this principle by slightly rocking the reader from side to side during the scanning process if the reader design allows.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Enhancing Reader Performance (3)', 'To ensure that an implanted animal is identified, the scanning procedure should be done for a minimum of 10 seconds (longer if possible) and on two consecutive occasions before an animal is declared negative for the presence of a microchip. If possible, repeat the scanning process using a different reader. Fortunately this is rarely necessary, being the exception rather than the norm. As mentioned earlier, all recognized implantation sites should be scanned.

Battery charge is also important for portable, hand-held reader function. Ensure batteries are always fully charged and that the manufacturer’s directions for battery care are followed closely.

Readers emit and receive electromagnetic energy and therefore can be affected by other electronic equipment or metallic objects. In this regard, shelters and veterinary clinics can be regarded as “hostile environments” due to the presence of computer terminals, fluorescent lights and stainless steel tables to mention a few. Try to maintain a distance of at least one meter (three feet) from electronic equipment. Ideally, one should not scan on stainless steel tables and remember to remove metal collars from the animal prior to scanning.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Enhancing Reader Performance (4)', 'All implanted animals should be scanned annually to ensure proper function and location of the microchip.

Finally, all manufacturers and distributors provide support services for their products. Check the reader’s performance frequently for read rate and range using a microchip that has not been implanted. Don’t risk the use of a reader if its performance is in doubt. Instead, call the manufacturer or distributor for hardware support.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip FAQs', 'Microchip FAQs

How can one tell if the microchip being used is an ISO microchip or not, especially within the USA?

ISO 11784 and 11785 clearly define the bit content and communication protocol of microchips that adhere to these ISO standards. As such, a true ISO microchip has a 64 bit content resulting in a 15 digit numeric ID code of which the first 3 digits is the manufacturer’s code that operates using FDX-B technology at a frequency of 134.2 kHz. In the USA, The current HomeAgain (Digital Angel) microchip is comprised of 48 bits resulting in a 10-alphanumeric ID number that does not contain Digital Angel’s manufacturer’s code and operates using FDX-A technology at a frequency of 125 kHz. This also applies to the AVID Eurochip. The AVID Friendchip also operates at 125 kHz and provides a 10 alphanumeric ID number but this number is encrypted, and hence requires a specially designed reader to be able to read. It is therefore also not a microchip that adheres to the ISO Standards 11784 or 11785. Both Digital Angel and AVID do manufacturer and distribute ISO standard microchips in markets outside of the USA.', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip FAQs (2)', 'What is the difference between the manufacturer and country codes and which is preferred?

The first three digits of the identification number stored in a microchip that meets ISO 11784/5 will be either a manufactures code or a country code.

Country Code

Microchips containing a number which starts with a country code can only be used in countries with a single central database which controls the issue of identification numbers. Each manufacturer selling product in such a country will ask the central database for a series of identification numbers. The manufacturer will then make microchips with these numbers each of which will start with the country code. These transponders will only be sold in the country represented by the three-digit code. It is the responsibility of the central registry to be sure that no duplicate numbers are issued.

Manufacturers Code', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip FAQs (3)', 'In a country where there is no single central authority controlling the uniqueness of the code in each microchip, a manufacturer code is used. Each manufacturer applies to the International Committee on Animal Recording (ICAR) for a three-digit manufacturer code, which will start with 9. It is then the responsibility of each manufacturer to be sure that the number in each of the transponders that he makes is unique.

Technical details can be found in the ISO standards 11784 and 11785.

ICAR rules require that manufacturers abide by a code of conduct which includes the provisions outlined above. Manufacturers who do not abide by the code risk having their allocated manufacturer code withdrawn

What is Annex A and are microchips identified in Annex A truly ISO standard microchips?', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · Microchip FAQs (4)', 'When ISO standards 11784 and 11785 were developed, there was concern regarding protection of the installed base of microchips, often referred to as backward compatibility. ISO 11785 Annex A was developed to address this issue during the transition period between prior and ISO standard technology and defined the need for readers to read three technologies (Destron, Datamars, and Trovan) for a period of 2 years. AVID was not included in Annex A because they elected not to provide the encryption code with which to read their encrypted microchips. However, this 2-year period has long since passed and this was clearly defined in ISO 11785, Section 2 (Conformance), wherein it states “…transponders meeting the requirements of Annex A may be applied for a transition period of 2 years from the date of the first edition of this international standard.” The date of the first edition was 1996, and as this time frame was completed in 1998, Annex A is no longer applicable, hence, Annex A microchips are not true ISO standard microchips.

Translations

[Portuguese](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Microchip-Identification-Guidelines-Portuguese.pdf)', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Microchip Identification Gui · 本板块文档清单', '本板块文档清单

共 1 份 PDF，按「英文 + 中文」策略收录 0 份，跳过小语种译本 1 份。

已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|

未收录（同一指南的其他语言译本）

- WSAVA-Microchip-Identification-Guidelines-Portuguese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-Microchip-Identification-Guidelines-Portuguese.pdf>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '身份识别,板块页面正文（原文）,Guidelines', 'informational', 'Microchip Identification Guidelines', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 指南定位与执行摘要', '1. 指南定位与执行摘要

执行摘要（原文逐字对应）：本全球指南**规定了微芯片的推荐植入部位**，并给出**地域差异与物种差异**信息（凡存在之处）。除犬猫外，还为**农业动物、其他哺乳类、两栖类、鸟类和爬行类**的微芯片植入提供指引。指南另有一章给出**如何确保读数器（reader）正常工作**的建议——读数器是整个微芯片识别系统中不可或缺、却常被忽视的组成部分。

标准化的历史脉络与核心论点（原文要点）：

- 近年标准化的主线是**微芯片技术问题（即通信协议，communication protocol）**；最初由**微芯片用户团体**推动，其后由 **International Standards Organization (ISO)** 承接。
- 这些努力的结果是**全球标准被采纳（即 ISO 11784 与 11785）**，因市场信心增强而促进了微芯片识别的广泛实施。
- 但**若读数器与微芯片不能靠近到足以相互通信、从而给出该动物的唯一识别号，整个识别网络就是无效的**。为优化这一交互，国际兽医界一直在为各物种制定标准化的植入部位。
- **植入部位的标准化对射频识别（radio frequency identification, RFID）系统的整体完整性至关重要**。这对 **FDX 类通信协议**尤为相关，因为其**有效询问距离（effective interrogation distance，即读数器与应答器之间的距离）相对较短**。
- 然而即便部位标准化至关重要，也不能忽视**读数器是否正常工作**——没有它，系统就失效。
- 本文是 **WSAVA Microchip Subcommittee** 关于**小型（伴侣）动物植入部位**的建议，随文附上提升读数器性能的建议，以及小型（伴侣）动物以外物种目前推荐的植入部位。
- 操作前提（原文两条）：**是否需要使用局部麻醉由兽医自行评估**（It is up to the individual veterinarian to assess the need for the use of a local anaesthetic）；**与其他任何注射一样，推荐无菌技术**（Aseptic technique, as with any injection, is recommended）。
- 页面呼吁：请把本信息传播给你的会员群体，以提高用户对标准的知晓与采纳。

2. 芯片规格与频率标准', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 判定一枚芯片是否真正为 ISO 芯片（尤其在美国市场内）', '2.1 判定一枚芯片是否真正为 ISO 芯片（尤其在美国市场内）

原文定义：**ISO 11784 与 11785 明确界定了遵循这些标准的微芯片的比特内容（bit content）与通信协议（communication protocol）。** 具体规格对照（数值逐字照抄，不做换算）：

| 芯片（原文） | 比特数 | ID 号码形态 | 是否含厂商码 | 技术 | 频率 |
|---|---|---|---|---|---|
| 真正的 ISO 微芯片（a true ISO microchip） | **64 bit** | **15 位纯数字 ID 码**，其中**前 3 位是厂商码** | 是 | **FDX-B** | **134.2 kHz** |
| HomeAgain (Digital Angel)（美国现行） | **48 bits** | **10 位字母数字混合 ID 号** | **不含** Digital Angel 的厂商码 | **FDX-A** | **125 kHz** |
| AVID Eurochip | 同上（原文：This also applies to the AVID Eurochip） | 10 位字母数字混合 | — | — | **125 kHz** |
| AVID Friendchip | — | **10 位字母数字 ID 号**，且该号码**经过加密** | — | — | **125 kHz**；因此**需要专门设计的读数器才能读取** |
| Annex A 芯片 | 见 2.4 | — | — | 非 ISO 技术 | — |

原文结论：HomeAgain、AVID Eurochip、AVID Friendchip **均不属于遵循 ISO Standards 11784 或 11785 的微芯片**。**Digital Angel 与 AVID 在美国以外的市场确实制造并分销符合 ISO 标准的微芯片。**', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 国家码与厂商码的区别', '2.2 国家码与厂商码的区别

原文：**符合 ISO 11784/5 的芯片所存识别号的前三位，要么是厂商码（manufactures code），要么是国家码（country code）。**

| 维度 | Country Code（国家码） | Manufacturers Code（厂商码） |
|---|---|---|
| 适用国家条件 | 只能用于**存在单一中央数据库、统一管控识别号发放**的国家 | 用于**没有单一中央权威管控每枚芯片号码唯一性**的国家 |
| 号码来源 | 在该国销售的每个厂商**向中央数据库申请一批识别号**，再制成芯片，每个号码**以该国国家码开头** | 每个厂商**向 International Committee on Animal Recording (ICAR) 申请一个三位厂商码，以 9 开头** |
| 销售范围 | 这些应答器**只在三位码所代表的那个国家销售** | 原文未设地域限制 |
| 唯一性责任 | **由中央登记机构（central registry）负责确保不发出重号** | **由各厂商自行确保其制造的每枚应答器号码唯一** |

原文补充：技术细节见 **ISO standards 11784 和 11785**；**ICAR 规则要求厂商遵守一套行为准则（code of conduct），其中包含上述各项规定；不遵守准则的厂商面临其被分配的厂商码被撤销的风险**。', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('WSAVA 微芯片识别与应用指南 · Annex A 芯片是否算 ISO 标准芯片', '2.3 Annex A 芯片是否算 ISO 标准芯片

原文按时间与条文论证：

- ISO 11784/11785 制定时，存在对**已装基座芯片群（installed base of microchips）的保护**顾虑，即通常所说的**后向兼容（backward compatibility）**。
- **ISO 11785 Annex A** 正是为处理过渡期问题而制定，它**要求读数器在 2 年期间内读取三种技术（Destron、Datamars、Trovan）**。
- **AVID 未被列入 Annex A，因为它选择不提供读取其加密芯片所需的加密码。**
- 引用原文条文（ISO 11785, Section 2 (Conformance)）：*“…transponders meeting the requirements of Annex A may be applied for a transition period of 2 years from the date of the first edition of this international standard.”*
- 时间推算（原文给出）：**第一版日期为 1996 年，该时限于 1998 年结束**，故 **Annex A 不再适用，Annex A 芯片不是真正的 ISO 标准微芯片**。

3. 注射（植入）部位与操作

3.1 总原则

- **左右侧规则：** 在**两侧对称的物种**中，微芯片应植入**左侧**；**除非用芯片作为辨别性别的辅助手段**——在这种情况下（凡适用）**雄性植左侧、雌性植右侧**。', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 犬与猫（Canine and Feline）', '3.2 犬与猫（Canine and Feline）

原文强调：犬猫目前**有两个公认在用的植入部位**：

| 部位 | 解剖定位（原文逐字） | 适用地域（原文） |
|---|---|---|
| 部位一（背中线上位） | The transponder (microchip) is implanted **subcutaneous on the dorsal midline just cranial to the shoulder blades or scapula**（皮下，背中线，肩胛／肩胛骨稍前方） | **除欧洲各国以外所有国家**的标准部位，其中包括**英国 [Wales, Scotland, England, and Northern Ireland] 与爱尔兰共和国** |
| 部位二（颈部中位） | The transponder (microchip) is implanted **subcutaneously in the midway region of the left neck**（皮下，左侧颈部中段） | **欧洲大陆**（**不含英国与爱尔兰共和国**——见上） |

扫描策略要求（原文）：**在尚未就一个全球统一部位达成一致之前，扫描务必集中于该地区地理上常用的植入部位**；若动物**扫描结果为阴性，强烈建议同时对上述另一个在用部位进行扫描**。', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 其他物种推荐部位（原文分类逐条）', '3.3 其他物种推荐部位（原文分类逐条）', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 其他物种推荐部位（原文分类逐条） (2)', '| 类群 | 物种 | 部位（原文逐字） | 操作要求／地域差异 |
|---|---|---|---|
| Mammals | **Equine（马）** 部位一 | implanted **within the nuchal ligament in its middle third** or at the halfway point between the ears and the withers（项韧带中三分之一，或耳与鬐甲连线中点） | **除澳大利亚以外所有国家**的推荐部位 |
| Mammals | **Equine（马）** 部位二 | in the **musculature of the left neck or the anterior injection triangle**（左颈肌或前注射三角） | **澳大利亚**推荐部位；**需要剪毛、局部麻醉与无菌技术**；因存在两个部位，须按犬猫部分讨论过的扫描程序复查并遵循 |
| Mammals | **Agricultural Animals（农业动物）**：bovine, ovine, porcine and caprine 或其他产肉物种 | subcutaneously at the **base of the left ear on the scutiform cartilage**（左耳基部、耳状软骨） | **强烈建议任何已植入的食用动物同时携带外部标识**，以提示体内有微芯片，便于**屠宰时被识别并回收**；**食用物种体内芯片的使用必须由当地贸易或政府指南管辖**，因为在某些情形下其使用可能不被允许 |
| Mammals | **Elephants（象）** | Subcutaneously on the **left side of the tail in the main caudal fold**（尾左侧、尾主褶皱内） | — |
| Mammals | **Hyrax and Loris（蹄兔与懒猴）** | Subcutaneously on the left side of the **intralumbar area**（腰部左侧） | — |
| Mammals | **Alpacas（羊驼，按澳大利亚规定）** | Subcutaneously **midway on the left neck of top of the head behind the left ear**（头顶左侧颈中段、左耳后方） | 原文限定 "as per Australia" |
| Mammals | **Other mammals（其他哺乳类）** | 若成体**从脊柱（backbone/spine）到肩胛长度为 >17 cm**：subcutaneously at the base of the left ear；若 **<17 cm**：subcutaneously **between the shoulder blades**（肩胛之间） | 以 **17 cm** 为分界（数值照抄） |
| **Amphibians（两栖类）** | — | The microchip is to be implanted **into the lymphatic cavity**（淋巴腔） | **植入部位应以组织胶封闭**（sealed with tissue glue） |
| **Avians（鸟类）** | 一般规则 | **5.5 kg adult weight and/or long-legged**：subcutaneously at the base of the neck（颈基部皮下）；**<5.5 kg 成体体重**：intramuscularly in the **left pectoral muscle**（左侧胸肌内注射） | **植入器朝向尾部方向（向下）**推进；用**组织胶加指压，或缝合**封闭植入部位 |
| Avians 例外 | **Ratites（平胸鸟类）** | Up to four days old – implanted in the **piping muscle behind the head on the left**（左侧头后导管肌） | 限**出生后至 4 日龄** |
| Avians 例外 | **Older birds（较大日龄鸟）** | Subcutaneously in the **left thigh**（左大腿皮下） | — |', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 其他物种推荐部位（原文分类逐条） (3)', '| Avians 例外 | **Emu（鸸鹋）** | Implanted in the **dorsal midline in the s/c lump**（背中线的皮下隆起处） | 标注（Australia） |
| Avians 例外 | **Penguins and vultures（企鹅与秃鹫）** | Subcutaneously at the **base of the neck**（颈基部皮下） | — |
| **Fish（鱼类）** | — | **>30 cm 体长**：on the left side at the **anterior base of the dorsal fin**（背鳍前基部左侧）；**<30 cm 体长**：on the left side into the **coelomic cavity**（体腔内） | 以 **30 cm** 为分界 |
| **Reptiles** | **Chelonians（龟鳖类）** | **Left hind limb socket**（左后肢臼／肢根窝） | **小型龟鳖用皮下部位**；**大型物种以及皮薄的小型物种用肌内技术**；植入部位**以组织胶封闭**；**冬眠物种应在其活动季结束前数周植入**，以便冬眠前完成愈合 |
| Reptiles | **Crocodilians（鳄类）** | Subcutaneously **anterior to the nuchal cluster**（项集群前方皮下） | — |
| Reptiles | **Lizards（蜥蜴）** | **>12.5 cm 吻至肛长（snout to vent length）**：subcutaneously in the **left inguinal region**（左腹股沟区皮下）；**<12.5 cm**：**intracoelomic**（体腔内） | 以 **12.5 cm** 为分界 |
| Reptiles | **Snakes（蛇）** | Subcutaneously on the **left side of the neck, twice the length of the head from the tip of the nose**（颈左侧，距鼻尖两个头长处皮下） | 定位以「头长的两倍」表述 |', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 特殊用途的部位例外（原文 Note）', '3.4 特殊用途的部位例外（原文 Note）

原文说明：针对特定应用场景，已就植入部位提出了**特别建议**：

- **笼养灵长类**：建议植入**右前臂背面肌内（intramuscularly in the back of the right forearm）**，这样当动物抓握笼栏时芯片即可方便地被读取。
- **大型猫科动物**：建议植入**肩部区域（shoulder region）**，这样当它们来回走动并蹭擦笼栏时即可被读取。

原文的风险限定（必须一并记录）：**这些部位与其他操作方使用的植入部位不同**；此类部位**只应用于植入后将留在同一设施内、该芯片位置为所有操作者所知、且不存在因操作者未扫描这一非寻常位置而漏读风险的动物**。

4. 扫描流程与读数器性能（Enhancing Reader Performance）

原文指出：读数器性能中**常被忽视的因素是使用者本身**——使用者如何保养和使用读数器会显著影响性能；所幸这是用户（无论制造商是谁）能完全掌控的领域，因此可以把它从性能不佳的原因中排除。

4.1 扫描前准备

| 要求（原文要点） | 中文 |
|---|---|
| Ensure that the reader in use is compatible with the communication protocols in use in your geographic locale (ie, forward and backward compatible) | 确认在用读数器与**本地理域的通信协议兼容**（即前向与后向兼容） |
| Familiarize yourself with and follow the manufacturer''s recommendations regarding reader care and scanning technique | 熟悉并**遵循制造商关于读数器保养与扫描技术的建议** |
| Battery charge is also important for portable, hand-held reader function. Ensure batteries are always fully charged and that the manufacturer''s directions for battery care are followed closely | **电池电量**对手持读数器很重要：始终保持**满电**，并严格遵循制造商的电池保养说明 |
| remove metal collars from the animal prior to scanning | 扫描前**取下动物的金属项圈** |', 'cat', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 扫描动作要领（逐条还原原文顺序）', '4.2 扫描动作要领（逐条还原原文顺序）

1. **从标准部位开始：** 检查有无芯片时，扫描**应从该物种、该地区标准化的微芯片植入部位开始**。
2. **扩大范围：** 若未立即识别到芯片，扫描应**覆盖更大区域，并以缓慢扩张的同心圆方式进行**（slowly expanding concentric circles）；**一些制造商推荐 8 字形（figure-eight pattern）**。
3. **接触被毛：** 扫描时读数器应**接触或擦过动物的被毛**（with the reader touching, or brushing, the animal''s fur）。
4. **朝向影响：** 读取距离会受**芯片相对读数器的朝向**轻微影响，其影响程度随读数器与芯片的设计而变；所幸这**很少影响日常读数器使用**。虽然扫描时无法看到植入芯片相对读数器的实际位置，但可以**利用这一原理**：若读数器设计允许，**在扫描过程中左右轻微晃动（rocking the reader from side to side）**。
5. **所有公认部位都要扫：** 如前所述，**所有公认的植入部位都应扫描**。

4.3 判定「阴性」的硬性流程

原文要求（数值逐字照抄）：为确保已植入的动物能被识别，**扫描程序应至少持续 10 秒（越长越好），并连续进行两次**，之后才能宣布该动物**没有微芯片（negative）**。**如可能，改用另一台读数器重复扫描过程**——所幸这很少必要，属例外而非通例。

4.4 电磁干扰与「 hostile environments 」

原文：读数器**发射并接收电磁能量**，因此会被其他电子设备或金属物体影响。就此而言，**收容所（shelters）与动物医院（veterinary clinics）可被视为「敌意环境」**，因为其中存在**电脑终端、荧光灯、不锈钢台面**等。要求：**尽量与电子设备保持至少 1 米（three feet）的距离**；**理想情况下不要在不锈钢台面上扫描**；扫描前记得**取下金属项圈**。

4.5 年度复查与设备维护

- **所有已植入动物都应每年扫描一次**，以确认微芯片**功能正常且位置未变**。
- 所有制造商与分销商都提供产品支持服务。**使用一枚未植入过的微芯片，频繁检查读数器的读取率与读取范围（read rate and range）**。**若读数器性能存疑，不要冒险使用；应联系制造商或分销商获取硬件支持。**', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 登记数据库相关内容（页面正文所含部分）', '5. 登记数据库相关内容（页面正文所含部分）

本次抓取的英文页面全文**没有独立的「登记数据库」章节**；与登记数据库有关的表述仅散见于 2.2 的国家码问答，即：**国家码芯片只能用于有单一中央数据库管控识别号发放的国家**、**厂商向中央数据库批量申领号码**、**该类应答器只在三位码代表国家销售**、**由中央登记机构负责杜绝重号**；以及**无中央权威时改用 ICAR 分配的以 9 开头的三位厂商码、由厂商自行保证唯一性**。

**其余数据库运营细节（登记流程、跨库互查、失主联络机制、注册费用等）：原文此处缺失。**

6. 流浪动物与法规相关内容

- **法规部分：** 页面正文中与法规有关的原文只有两句——**食用（产肉）物种体内微芯片的使用必须由当地贸易或政府指南管辖，因为某些情形下其使用可能不被允许**（3.3 农业动物）；以及**ISO 标准（11784、11785）本身的技术条款与 ISO 11785 Section 2 (Conformance) 的 2 年过渡期条文**（2.3）。**除以上之外，本页面正文没有强制植入立法、法律责任、跨境承认等法规章节，原文此处缺失。**
- **流浪动物部分：** 页面正文只在讨论电磁干扰时**提及「收容所（shelters）」这一场所**（4.4）。**针对流浪/丢失动物的识别流程、公告与寻回制度等专章：原文此处缺失。**（葡语 PDF 译本未抓取，无法核对其中是否含额外章节。）', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 各章节要点表', '7. 各章节要点表

| 章节（原文标题） | 核心要点 | 必须记住的数值/术语 |
|---|---|---|
| Executive Summary | 规定推荐植入部位 + 地域/物种差异 + 读数器功能保障章 | RFID、effective interrogation distance、FDX |
| Guidelines（引言） | 标准化由用户团体起步、经 ISO 完成；部位标准化与读数器功能缺一不可 | ISO 11784、ISO 11785、FDX-B/FDX-A |
| Microchip implantation sites for small (companion) animals → Canine and Feline | 两个公认部位：背中线上（非欧洲用）与左颈中段（欧洲大陆用）；阴性须补扫另一部位 | subcutaneous、dorsal midline、cranial to shoulder blades、left neck |
| Recommended implantation sites in other species | 两侧对称物种植左侧；性别识别时雄左雌右；马/农业动物/象/蹄兔与懒猴/羊驼/其他哺乳类/两栖/鸟/鱼/爬行各有部位 | 17 cm、5.5 kg、30 cm、12.5 cm、scutiform cartilage、nuchal ligament、tissue glue |
| Exceptions | Ratites、较大日龄鸟、Emu、企鹅与秃鹫；另有笼养灵长类与大型猫科的特殊部位及其使用限制 | piping muscle、left thigh、s/c lump、right forearm、shoulder region |
| Enhancing Reader Performance | 使用者是关键变量；协议兼容；从标准部位起、同心圆/8 字、接触被毛、轻微晃动；阴性判定流程；避开干扰源；年度扫描；硬件支持 | 10 seconds、two consecutive occasions、one meter (three feet)、annually |
| Microchip FAQs | ISO 芯片判定；国家码 vs 厂商码；Annex A 是否算 ISO | 64 bit、15 digit、134.2 kHz、48 bits、10-alphanumeric、125 kHz、9 开头三位厂商码、1996、1998、2 years、Destron/Datamars/Trovan |', 'cat', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('WSAVA 微芯片识别与应用指南 · 原文缺失与整理说明', '8. 原文缺失与整理说明

1. **本板块英文正文仅存在于板块页面**（`00-板块说明.md`），文档清单记为「共 1 份 PDF，收录 0 份，跳过小语种译本 1 份」；`pdf/`、`raw_extracts/` 目录为空，**指南原始手册版式（图示、解剖定位图、章节编号）原文此处缺失**。
2. 页面正文**无芯片尺寸（如 12mm×2mm 之类）、植入器型号、麻醉或镇静剂量、并发症与迁移率数据**；**原文此处缺失**。
3. 页面正文**无独立「登记数据库」与「流浪动物与法规」章节**（详见第 5、6 节）。
4. 葡语译本：<https://wsava.org/wp-content/uploads/2020/01/WSAVA-Microchip-Identification-Guidelines-Portuguese.pdf>（未抓取正文，不作转述）。

延伸资料

- WSAVA Microchip Identification Guidelines 板块页面 — <https://wsava.org/global-guidelines/microchip-identification-guidelines/>
- Translations 小节所列葡语 PDF（未抓取正文） — <https://wsava.org/wp-content/uploads/2020/01/WSAVA-Microchip-Identification-Guidelines-Portuguese.pdf>', '', '', '', '身份识别,微芯片,Microchip,识别指南,应答器,读数器,指南定位与执行摘要,芯片规格与频率标准,注射（植入）部位与操作', 'informational', 'WSAVA 微芯片识别与应用指南（注射部位、扫描流程与芯片标准）', 'official', 'https://wsava.org/global-guidelines/microchip-identification-guidelines/', 'approved'),
('Pain Guidelines · 第 1 段', 'Pain Guidelines（全球疼痛管理指南）

板块页面正文（原文）

Guidelines

Pain

Executive Summary

These recently updated Global Guidelines for the Recognition, Assessment and Treatment of Pain help veterinary teams to understand the importance of pain management for patient health and welfare and offer the latest thinking on the treatment of pain.', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · Pain Management Protocols', 'Pain Management Protocols

- [Cesarean patients](https://wsava.org/wp-content/uploads/2024/08/Caesarean-section.pdf)
- [Cancer related pain](https://wsava.org/wp-content/uploads/2024/08/Cancer-Pain.pdf)
- [Castration and ovariohysterectomy/ovariectomy in Cats](https://wsava.org/wp-content/uploads/2024/08/Castration-and-OVH-cats.pdf)
- [Castration and ovariohysterectomy/ovariectomy in Dogs](https://wsava.org/wp-content/uploads/2024/08/Castration-and-OVH-Dogs.pdf)
- [Degenerative joint disease](https://wsava.org/wp-content/uploads/2020/01/Degenerative-joint-disease.pdf)
- [Emergency and critical care](https://wsava.org/wp-content/uploads/2024/08/Emergency-and-critical-care.pdf)
- [Medical pain](https://wsava.org/wp-content/uploads/2024/08/Medical-Pain.pdf)
- [Pediatric patients](https://wsava.org/wp-content/uploads/2024/08/Pediatric-Pain.pdf)
- [Neuropathic pain](https://wsava.org/wp-content/uploads/2024/08/Neuropathic-pain-protocol.pdf)
- [Orthopedic surgery](https://wsava.org/wp-content/uploads/2024/08/Orthopedic-surgery.pdf)
- [Pregnant or lactating patients](https://wsava.org/wp-content/uploads/2020/01/Pregnant-or-lactating-patients.pdf)
- [Soft tissue surgery](https://wsava.org/wp-content/uploads/2024/08/Soft-tissue-Surgery.pdf)
- [Perceived level of pain associated with various conditions](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Global-Pain-Council-Perceived-levels-of-pain.pdf)', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · Downloads', 'Downloads', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · 第 2 段', 'Guidelines for the recognition, assessment and treatment of pain

[Read in JSAP](https://onlinelibrary.wiley.com/doi/10.1111/jsap.13566)

Translations

[Arabic](https://wsava.org/wp-content/uploads/2023/08/Arabic_WSAVA-%D8%A5%D8%B1%D8%B4%D8%A7%D8%AF%D8%A7%D8%AA-2022-%D9%84%D9%84%D8%AA%D8%B9%D8%B1%D9%81-%D9%88%D8%A7%D9%84%D8%AA%D9%82%D9%8A%D9%8A%D9%85-%D9%88%D8%B9%D9%84%D8%A7%D8%AC-%D8%A7%D9%84%D8%A3%D9%84%D9%85.pdf)

[Mandarin](https://wsava.org/wp-content/uploads/2023/02/Reduced_Chinese_Simplified_2022%E5%B9%B4WSAVA%E7%96%BC%E7%97%9B%E8%AF%86%E5%88%AB%E3%80%81%E8%AF%84%E4%BC%B0%E5%92%8C%E6%B2%BB%E7%96%97%E6%8C%87%E5%8D%97.pdf)

[Thai](https://wsava.org/wp-content/uploads/2023/10/VPAT-2022-WSAVA-pain-guideline-Thai-version.pdf)

[Portuguese](https://wsava.org/wp-content/uploads/2023/08/Portugues_2022-WSAVA-Diretrizes-de-dor.pdf)

[Spanish](https://wsava.org/wp-content/uploads/2023/01/Spanish_2022-WSAVA-Manejo-del-Dolor-Espanol.pdf)

[Russian](https://wsava.org/wp-content/uploads/2024/04/2022-WSAVA-Pain-Management-Guidelines_Russian_final-version.pdf)

[Japanese](https://wsava.org/wp-content/uploads/2024/07/Global-Pain-Guidelines-JPN.pdf)

[French](https://wsava.org/wp-content/uploads/2024/09/2022-WSAVA-guidelines-for-the-recognition_final.pdf)', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · 本板块文档清单', '本板块文档清单

共 21 份 PDF，按「英文 + 中文」策略收录 15 份，跳过小语种译本 6 份。', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · 已收录（原文已抽取到 raw_extracts/）', '已收录（原文已抽取到 raw_extracts/）', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · 已收录（原文已抽取到 raw_extracts/） (2)', '| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Cesarean patients | EN | 2024 版（现行） | 2 | 6467 | [raw_extracts/Caesarean-section.md](raw_extracts/Caesarean-section.md) |
| Cancer related pain | EN | 2024 版（现行） | 1 | 3566 | [raw_extracts/Cancer-Pain.md](raw_extracts/Cancer-Pain.md) |
| Castration and ovariohysterectomy/ovariectomy in Cats | EN | 2024 版（现行） | 2 | 4951 | [raw_extracts/Castration-and-OVH-cats.md](raw_extracts/Castration-and-OVH-cats.md) |
| Castration and ovariohysterectomy/ovariectomy in Dogs | EN | 2024 版（现行） | 2 | 4374 | [raw_extracts/Castration-and-OVH-Dogs.md](raw_extracts/Castration-and-OVH-Dogs.md) |
| Degenerative joint disease | EN |  | 1 | 3139 | [raw_extracts/Degenerative-joint-disease.md](raw_extracts/Degenerative-joint-disease.md) |
| Emergency and critical care | EN | 2024 版（现行） | 1 | 3237 | [raw_extracts/Emergency-and-critical-care.md](raw_extracts/Emergency-and-critical-care.md) |
| Medical pain | EN | 2024 版（现行） | 2 | 3678 | [raw_extracts/Medical-Pain.md](raw_extracts/Medical-Pain.md) |
| Pediatric patients | EN | 2024 版（现行） | 2 | 5854 | [raw_extracts/Pediatric-Pain.md](raw_extracts/Pediatric-Pain.md) |
| Neuropathic pain | EN | 2024 版（现行） | 1 | 3380 | [raw_extracts/Neuropathic-pain-protocol.md](raw_extracts/Neuropathic-pain-protocol.md) |
| Orthopedic surgery | EN | 2024 版（现行） | 2 | 7126 | [raw_extracts/Orthopedic-surgery.md](raw_extracts/Orthopedic-surgery.md) |
| Pregnant or lactating patients | EN |  | 1 | 5180 | [raw_extracts/Pregnant-or-lactating-patients.md](raw_extracts/Pregnant-or-lactating-patients.md) |
| Soft tissue surgery | EN | 2024 版（现行） | 2 | 5548 | [raw_extracts/Soft-tissue-Surgery.md](raw_extracts/Soft-tissue-Surgery.md) |
| Perceived level of pain associated with various conditions | EN |  | 1 | 2714 | [raw_extracts/WSAVA-Global-Pain-Council-Perceived-levels-of-pain.md](raw_extracts/WSAVA-Global-Pain-Council-Perceived-levels-of-pain.md) |', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · 已收录（原文已抽取到 raw_extracts/） (3)', '| Reduced Chinese Simplified 2022年WSAVA疼痛识别、评估和治疗指南 | ZH | 2022 版 | 42 | 446 | [raw_extracts/Reduced_Chinese_Simplified_2022年WSAVA疼痛识别、评估和治疗指南.md](raw_extracts/Reduced_Chinese_Simplified_2022%E5%B9%B4WSAVA%E7%96%BC%E7%97%9B%E8%AF%86%E5%88%AB%E3%80%81%E8%AF%84%E4%BC%B0%E5%92%8C%E6%B2%BB%E7%96%97%E6%8C%87%E5%8D%97.md) |
| 2022 WSAVA guidelines for the recognition final | fr | 2022 版 | 78 | 404452 | [raw_extracts/2022-WSAVA-guidelines-for-the-recognition_final.md](raw_extracts/2022-WSAVA-guidelines-for-the-recognition_final.md) |', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · 未收录（同一指南的其他语言译本）', '未收录（同一指南的其他语言译本）

- Arabic_WSAVA-إرشادات-2022-للتعرف-والتقييم-وعلاج-الألم.pdf — 原链接 <https://wsava.org/wp-content/uploads/2023/08/Arabic_WSAVA-%D8%A5%D8%B1%D8%B4%D8%A7%D8%AF%D8%A7%D8%AA-2022-%D9%84%D9%84%D8%AA%D8%B9%D8%B1%D9%81-%D9%88%D8%A7%D9%84%D8%AA%D9%82%D9%8A%D9%8A%D9%85-%D9%88%D8%B9%D9%84%D8%A7%D8%AC-%D8%A7%D9%84%D8%A3%D9%84%D9%85.pdf>
- VPAT-2022-WSAVA-pain-guideline-Thai-version.pdf — 原链接 <https://wsava.org/wp-content/uploads/2023/10/VPAT-2022-WSAVA-pain-guideline-Thai-version.pdf>
- Portugues_2022-WSAVA-Diretrizes-de-dor.pdf — 原链接 <https://wsava.org/wp-content/uploads/2023/08/Portugues_2022-WSAVA-Diretrizes-de-dor.pdf>
- Spanish_2022-WSAVA-Manejo-del-Dolor-Espanol.pdf — 原链接 <https://wsava.org/wp-content/uploads/2023/01/Spanish_2022-WSAVA-Manejo-del-Dolor-Espanol.pdf>
- 2022-WSAVA-Pain-Management-Guidelines_Russian_final-version.pdf — 原链接 <https://wsava.org/wp-content/uploads/2024/04/2022-WSAVA-Pain-Management-Guidelines_Russian_final-version.pdf>
- Global-Pain-Guidelines-JPN.pdf — 原链接 <https://wsava.org/wp-content/uploads/2024/07/Global-Pain-Guidelines-JPN.pdf>

外部引用（期刊论文 / 相关机构，未抓取正文）

- Read in JSAP — <https://onlinelibrary.wiley.com/doi/10.1111/jsap.13566>', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Pain Guidelines · 版权', '版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '疼痛管理,板块页面正文（原文）,Guidelines,Pain', 'informational', 'Pain Guidelines', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · > 本稿覆盖切片 001-014；治疗与用药部分见 15-、16- 两篇。', '> 本稿覆盖切片 001-014；治疗与用药部分见 15-、16- 两篇。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 文献信息与背景', '1. 文献信息与背景

本篇整理自《WSAVA 2022 犬猫疼痛识别、评估与管理全球指南》（Guide pour la reconnaissance, l''évaluation et le traitement de la douleur de la WSAVA 2022）法语译本，发表于 Journal of Small Animal Practice · Vol 64 · 2023 年 4 月，© 2022 British Small Animal Veterinary Association / WSAVA。主要作者包括 B. P. Monteiro、B. D. X. Lascelles、J. Murrell、S. Robertson、P. V. M. Steagall 等，通讯作者邮箱 beatrizpmonteiro@gmail.com。法语译本由 Vetoquinol 资助翻译。

**摘要要点**：动物感知力（sensibilité animale）指动物感受正性和负性情绪（含疼痛）的能力。兽医作为动物健康专业人员负有减轻痛苦的医学与伦理职责。2014 年 WSAVA 全球疼痛委员会（Global Pain Council，GPC）发布了第一版疼痛指南，2022 版在其基础上纳入过去十年的主要进展，为日常临床提供易实施的基本原则和一份详尽的参考文献清单，可在任何执业环境与地区推行。

**引言**：所有哺乳动物及其他脊椎动物（含鱼类、鸟类、爬行类、两栖类）都具有感受疼痛的能力；观察表明动物不仅感知疼痛的感觉维度，也体验其不愉快、厌恶与负性情绪。动物感知力已在许多国家和地区获得法律承认。GPC 的使命是「唤醒世界并采取行动，申明所有动物都有感知力、能感受疼痛并因此受苦……提升兽医在动物疼痛识别与管理方面的信心与能力」。

**使用本文件**：本文件不是详尽手册，而是提供基础实用信息加一份长参考文献清单。疼痛的发生与识别能力没有地理界限，主要限制因素是意识、教育和把疼痛评估纳入每次临床检查的投入。各地镇痛药可及性与监管框架不同，构成疼痛管理的重要障碍；指南在治疗部分以「阶梯式」方案应对，先给出当前技术水平的完整管理方案，再给出受法规限制时的替代方案。在某些情况下，安乐死可能是唯一在道德/伦理上可辩护（即可行）的处理选择。本文件仅提供建议，临床决策须个案化。当某一主题科学证据不足时，内容反映的是专家组共识。

**本指南基于的六项原则**：
- 疼痛是一种疾病（maladie），在大多数情况下可以被识别并有效管理。
- 疼痛是**第四生命体征**，应纳入每位患者的 TPR（体温、脉搏、呼吸）评估。
- 应始终考虑预防性（préventive）与多模式（multimodale）镇痛。
- 围手术期疼痛可持续数天，须相应管理，包括「家庭环境」中的疼痛管理。
- 疼痛感知受许多内外部因素影响，包括社会与物理环境。
- 疼痛治疗应始终包含药物与非药物治疗。

> 注：切片 002 处出现「la douleur est le quatrième signe vital」表述。任务提示中提及的「第五生命体征」在本法语译本 001-014 块中未见对应文字，原文此处以「第四生命体征」表述。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 疼痛的定义与分类（1.1 理解疼痛）', '2. 疼痛的定义与分类（1.1 理解疼痛）

**疼痛定义**：疼痛是复杂的、多参数的感觉，包含感觉成分与情绪成分。国际疼痛研究协会（IASP，International Association for the Study of Pain）的官方定义为「一种不愉快的感觉和情绪状态，与真实的或潜在的组织损伤相关，或以此类术语描述」；并承认「无法交流并不能排除人类或非人类动物体验疼痛的可能性」。疼痛是独特的个体体验，即便没有明显的伤害性刺激也可被体验，并可被恐惧、焦虑、记忆和应激所改变。对于像动物一样不能用语言交流的患者，临床用行为学体征作为疼痛识别与评估的基础。

**急性与慢性**：疼痛常被分为急性（aiguë）或慢性（chronique）；任意地，持续超过 3 个月视为慢性。但机制上疼痛沿「急性伤害性疼痛 → 病理性疼痛状态」的连续谱演变，改变的幅度取决于疼痛的持续时间、强度与类型。3 个月本身并无突变，故本文件把「急性/适应性」与「慢性/不适应/病理性」疼痛交替使用。疼痛持续时间是整体疼痛状态的主要因素。炎症性疼痛常归入「急性/适应性」类，但显然也可存在于长期（慢性）疼痛中。较长的疼痛会导致伤害性传递在多个层面改变，统称**可塑性（algoplasticité）**，这些改变促进并放大疼痛，可在无外周刺激时引起疼痛（如幻肢痛），表现为外周损伤与所感知疼痛的逐渐脱节，即「不适应」或「病理性」疼痛。

**临床疼痛的亚分类**：适应性疼痛被进一步分为伤害性（nociceptive）或炎症性（inflammatoire）；病理性疼痛被分为功能失调性（dysfonctionnelle / fonctionnelle）或神经病性（neuropathique）。大多数临床疼痛是这些类型的混合，例如-established 骨关节炎同时具有炎症性和病理性疼痛成分。癌症疼痛在部分文献中被单列为独立病理实体；「混合性疼痛（douleur mixte）」一词即用于反映临床疼痛由多种类型成分组合。

**表 1：适应性（急性）疼痛与不适应（慢性）疼痛的差异**

| 项目 | 适应性（急性） | 不适应（慢性） |
|---|---|---|
| 特征 | 与真实/潜在组织损伤相关；目的是迅速改变动物行为以避免或减轻损伤、优化愈合条件；严重程度变化且与组织损伤程度成正比；会自行停止（随愈合减轻、愈合完成即消失） | 持续超过急性疾病的预期病程；与愈合无关；无明确的停止标准；与反复或长期疾病相关；可无病因存在；生物学用途极少或无 |
| 举例 | 手术；创伤（切割、损伤、骨折）；急性疾病（如胰腺炎） | 骨关节炎；癌症；牙周病 |
| 评述 | 常被认为具保护性，但在受控的手术/治疗环境下这种保护性并非必要；急性疼痛机制多反映正常生理性疼痛传递系统，通常比慢性疼痛更易处理；有时称为生理性疼痛，可涉及炎症 | 术后疼痛持续即由急性手术疼痛转为慢性；慢性疼痛患者初期可有急性发作（即「慢性基础上的急性发作」/「阵发性疼痛发作」）；有时称为病理性疼痛 |', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 疼痛的生理与病理生理（1.2）', '3. 疼痛的生理与病理生理（1.2）

疼痛是一种主观感觉，即使在没有外部伤害性刺激时也可被体验，并可被恐惧、记忆等广泛后果放大或消除。适应性（生理性）疼痛预示潜在有害刺激的到来，具关键的保护功能；不适应疼痛则是神经传递的功能障碍，不服务于任何生理目的，导致疼痛本身可能成为原发障碍的慢性综合征。疼痛感知是中枢与外周神经系统促进与抑制机制相互作用的最终产物。持续有害刺激激活 C 纤维，其意义取决于损伤严重程度。大脑皮层是有意识疼痛体验（感知）之所在，并对脊髓施加下行控制，调节疼痛感觉（即伤害性下行抑制控制）。

**疼痛的三个关键成分**：感觉-辨别成分（时间、空间、温度/机械）、情感成分（主观与情绪，描述恐惧、紧张及伴随的自主反应）、评估成分（描述 qualities 的幅度，如穿透性/弥漫性、轻度/重度）。动物的疼痛体验包含这三成分，但临床倾向只关注疼痛强度。

**表 2：初级传入纤维按结构、直径与传导速度分为三型**（改编自 Monteiro & Simon 2022）

| 纤维 | 描述 | 直径（μm） | 传导速度（m/秒） |
|---|---|---|---|
| Aβ | 粗的有髓鞘、快速传导纤维，参与低阈值无害机械刺激（如触觉） | 大于 10 | 30 至 100 |
| Aδ | 弱髓鞘、慢传导纤维，主要参与伤害性信号传递；造成急性疼痛「刀刺样」快速反应，主要作为警告、引起快速撤离刺激（快痛） | 2,0 至 6,0 | 12 至 30 |
| C | 无髓鞘、极慢传导纤维，主要参与伤害性信号传递；被强烈的机械、化学、热刺激激活，造成「缓慢灼烧」感（慢痛）；一群称「静默伤害性感受器」的 C 纤维可在炎症或组织损伤中被激活，是外周敏化的改变之一 | 0,4 至 1,2 | 0,5 至 2,0 |

**临床疼痛与敏化**：组织损伤或炎症时，伤害性感觉系统内在可塑性使受损区域敏感性升高，伤害性甚至无害刺激被感知为疼痛。其临床体征为**痛觉过敏（hyperalgésie）**——对伤害性刺激的过度且延长的反应；与**异常性疼痛/触物痛感（allodynie）**——对正常无害的低强度刺激（轻触皮肤、轻压）产生疼痛反应。二者是外周敏化与中枢敏化的结果。外周敏化源于损伤/炎症后伤害性感受器末梢周围微环境改变，炎症介质和神经递质由受损细胞释放，直接激活或敏化伤害性感受器；已敏化的神经还通过「神经源性炎症」参与局部炎症。中期中枢敏化不仅指脊髓改变，也包括超脊髓层面的改变（如伤害性下行抑制活动下降、内源性镇痛系统减弱）。手术也可引起中枢敏化，但更易发生于长期疼痛状态（如患骨关节炎/退行性关节病的犬、猫，或慢性神经病性疼痛犬）。

**表 3：疼痛类型**

| 类型 | 描述 | 相关机制 |
|---|---|---|
| 炎症性疼痛 | 至伤口愈合的急性术后疼痛；起病迅速，强度和时长一般与组织损伤的严重程度和持续时间直接相关；源于炎症与免疫细胞及组织损伤产物的活动 | 伤害性系统改变通常可逆；但若伤害刺激严重或炎症灶持续，则疼痛持续；更长/更强刺激使传递系统改变加大，累及神经元、支持细胞（如胶质细胞）及免疫/炎症细胞，导致病理性疼痛 |
| 神经病性疼痛 | 由外周或中枢神经系统的原发损伤、创伤或功能障碍引起或启动 | 涉及外周神经、脊髓、脑干、脑的大量改变，受损神经自发性炎症并对炎症性及正常无害刺激产生超反应；正常控制疼痛的内源系统功能下降；人类的幻肢痛、带状疱疹后神经痛为术后持续疼痛主因；兽医文献中描述较少，因人类神经病性疼痛定义多依赖疼痛质量描述（灼烧、刀刺、麻刺感） |
| 功能失调性疼痛 | 神经系统整体正常（无器质性损伤）但中枢神经系统功能异常的状态（功能性或功能失调性疼痛） | 反复刺激中枢引起异常中枢过程，导致神经系统可塑性（神经元及支持细胞如胶质细胞与神经元交流方式的改变），放大并促进伤害性信息处理；与神经病性疼痛一样，下行抑制可有缺陷 |

（SNC=中枢神经系统，SNP=外周神经系统。图 2 示适应性疼痛、图 3 示不适应疼痛、图 4 示外周敏化、图 5 示中枢敏化；图 4 涉及 PG 前列腺素、NGF 神经生长因子。）', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 伦理与动物福利（1.3）', '4. 伦理与动物福利（1.3）

**疼痛管理中的伦理**：兽医有伦理与医学职责管理动物疼痛。伦理职责因疼痛引起痛苦，且「预防与缓解痛苦」常是兽医宣誓的一部分；医学职责因疼痛是医学问题，会引起交感神经系统激活、免疫抑制、代谢改变、愈合不良、发病率升高并影响疾病进展等不良生理后果。兽医应基于对患者的伦理与医学责任作出决定，不受外部影响，并不造成伤害。疼痛管理伦理是文化与社会规范及「动物—兽医—客户」三元关系复杂交互的结果。使用镇痛药有经济成本；WSAVA GPC 坚决反对把「是否使用镇痛药」的选择权交给客户。常见伦理困境包括猫爪去爪术（onychectomie）与犬美容手术（剪耳、断尾），这些手术很少在医学上成立，并可能导致术后持续疼痛。另一冲突是关于无用或徒劳的痛苦操作：随着专科化技术发展，客户支付意愿可能促使实施侵入性痛苦操作或「过度治疗」，仅延长生命而不改善真实生活质量（QoL），导致持续痛苦。兽医伦理工具（EFP）可从照护者、患者、临床医师三方面问题协助决策。基于终止动物疼痛与痛苦的伦理原则，在疼痛无法被有效管理、QoL 低时，应始终考虑安乐死。

**疼痛管理与动物福利**：动物福利可视为「身心 Complete 健康、动物与环境和谐的状态」，从好到坏连续分布；当前福利科学旨在保障动物有好的生活。五域模型提出五个影响动物福利的领域（营养、环境、健康、行为、心理状态），并越来越重视促进积极（情感）心理状态。疼痛始终不愉快，会负面影响这五个领域（如食欲下降、社交互动减少）——图 6 的五域模型显示前四域正/负向影响第五域（心理状态），疼痛负面作用于前四域且本质上是不愉快情绪。疼痛引起负性情绪（应激、恐惧、焦虑、挫败），而情绪（正/负）又反过来影响疼痛感知；给予动物积极体验（愉悦、舒适、满足、好奇、游戏、积极社交）可改善疼痛缓解与福利。人类积极心理学干预已用于不适应疼痛的治疗；室内环境富集、为犬提供新的积极体验可能有助缓解疼痛（尚未经证实）。本文件中：动物福利指动物当前身心状态及其与物理/社会环境的关系；生活质量（QoL）指改善或恶化动物生活的所有方面；健康相关生活质量（HRQoL）指特定健康问题对 QoL 的影响。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5）', '5. 犬猫急性疼痛的识别与评估（1.4、1.5）

**猫的急性疼痛（1.4）**：急性疼痛由创伤、手术、内科或感染事件引起，突然发生、有与严重程度相关的预期病程，通常可通过正确选择镇痛药（多为阿片类 morphiniques、非甾体抗炎药 AINS、局部麻醉技术）缓解。择期手术在术前给药（预防性镇痛）；创伤后应尽快开始治疗；用疼痛量表/评分系统评估；治疗后密切监测、防止疼痛升级，治疗持续到急性炎症反应消退。镇痛方案（药物与非药物选择、疗程）应个体化。血浆 β-内啡肽、儿茶酚胺、皮质醇等神经内分泌测定虽与猫急性疼痛相关，但受焦虑、应激、恐惧和药物影响；血压、心率、呼吸频率等客观指标受应激影响，不应单独用作疼痛指标。目前认为综合行为、身体姿势与面部表情的观察最能反映动物复杂的疼痛体验。

猫可用多维复合疼痛量表评估术后疼痛：UNESP-Botucatu 多维猫疼痛评估简表（UFEPS-SF）与格拉斯哥猫复合疼痛测量量表（CMPS-Feline）。这些工具需与患者互动（对野生或未社会化猫不一定可行）。各物种特异的「鬼脸（grimace）」疼痛量表因面部表情在所有哺乳动物（含猫）中均存在而有用——猫鬼脸量表（Feline Grimace Scale，FGS）与多维复合量表相关性良好，适合快速评估不同类型疼痛、且在与猫无法互动时使用。FGS 含五个动作单元（UA：耳位、眶周收紧、口部紧张、胡须变化、头位），每项 0-2 分，总分最高 10；≥4/10 提示可能疼痛、需给予补救镇痛（补救镇痛阈值分）；有 iOS/Android 应用（英/法/西）。

**表 4：评估猫急性疼痛的工具**', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5） (2)', '| 工具 | 类型 | 适用病理 | 评述 | 参考文献 |
|---|---|---|---|---|
| 猫鬼脸量表（FGS）† | 面部表情 | 任何外科或内科疼痛，含口齿疾病与拔牙猫 | 广泛研究与验证；兽医、兽医学生、技师/护士及照护者使用均可靠；5 项各 0-2 分，最高 10，补救镇痛阈值 ≥4/10；felinegrimacescale.com；App 支持英/法/西 | Evangelista 2019、2020；Watanabe 2020a；Evangelista & Steagall 2021 |
| Unesp-Botucatu 猫疼痛量表（UFEPS-SF）† | 行为与面部表情 | 任何外科或内科疼痛 | 除英语外已在 8 种语言验证（中、英、法、德、意、日、葡、西）；最新简表含 4 项各 0-3 分，最高 12，补救镇痛阈值 ≥4/12；animalpain.org | Belli 2021；Luna 2022；Brondani 2013 |
| 格拉斯哥复合疼痛测量-猫（CMPS-Félin） | 行为与面部表情 | 任何外科或内科疼痛 | 中等验证；英/西双语；含 7 项，各项分值范围不同，最高 20，补救镇痛阈值 ≥5/20；newmetrica.com | Reid 2017；Holden 2014 |

（† 因科学证据更充分而在实践中推荐使用；‡ 达到即应给予补救镇痛的分数。）

**识别与评估要点**：应先考虑手术类型、解剖部位与时长、环境、个体差异、年龄与健康状况（框 1）。了解猫的正常行为有助判断相对基线的改变与新出现行为（原本亲人的猫变攻击、躲藏或试图逃跑）；有些猫尤其在人、其他动物在场或应激情境下不表现疼痛行为。舒适猫在成功镇痛后应表现正常面部表情、姿势与运动（图 8、9）；腹部手术后弓背姿势是疼痛提示，犬猫的「祈祷姿势」可为腹部或食道疼痛缓解体位。

**框 1：猫犬急性疼痛分步识别与评估**：
1. 远距离观察动物（笼内、床上、犬舍）：姿势、面部表情、对伤口的关注、对环境的关注、鸣叫类型或是否鸣叫（表 5）；如安详舒适睡眠，勿打扰。
2. 平静接近并打开笼门，同时观察其反应。
3. 轻声唤名、抚摸或玩耍与之互动，观察反应；若无互动兴趣，勿强迫，给其空间。
4. 在已接触的同时把手靠近疼痛区域，先触该区域再轻压；一旦出现行为反应（舔唇、吞咽、转头向手、惊跳、凝视、低吼、咬牙、试图咬、哀鸣），立即停止接近/触碰/加压。
5. 用疼痛量表根据观察评估疼痛等级。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5） (3)', '**烦躁不安（dysphorie）还是疼痛**：做局、躁动、持续活动可能是猫剧烈疼痛的征象，也可能与烦躁不安有关；烦躁不安通常出现在术后早期（20-30 分钟）、麻醉恢复不良时，常见于吸入麻醉、给予氯胺酮或大剂量阿片类之后。鉴别方法是给予镇痛药：体征减轻提示原本为疼痛；体征加重提示可能为烦躁不安，需逆转所用药物/镇静剂。若用阿片类拮抗剂（如纳洛酮），镇痛效果也可能被逆转，需密切监测疼痛表现。

**疼痛评估时机**：建议在术前用上述验证工具评估以获得基线（图 11）；猫的疼痛分数数值变化不如行为变化关键；镇静剂与某些麻醉药会干扰术后早期评估，待猫呈胸骨卧位并对环境有定向时开始较合适。术后疼痛最早可在卵巢子宫切除后 30 分钟开始，持续约 6-8 小时。不必为评估而唤醒猫——安静休息/睡眠通常是舒适的良好指标，但须确认其为正常放松或蜷曲姿势；有些猫因恐惧或疼痛一动不动，或「假寐（sommeil feint）」（图 10）。

**犬的急性疼痛（1.5）**：犬急性疼痛可继发于创伤、手术、内科问题、感染或炎性疾病；强度可从极低到极高，时长数小时至数天。有效管理依赖医护人员识别、分析并可靠测量疼痛的能力。回家时须告知主人识别疼痛及如何处理，合理处方镇痛药。心率、血压、血浆皮质醇/儿茶酚胺客观指标与犬急性疼痛显著相关但不可靠（受应激、恐惧、麻醉分子影响）。因此犬的疼痛评估以主观行为学体征为主（图 13、表 5）。

疼痛的行为表达具有物种特异性，受年龄、品种、行为、疼痛类型与时长、临床状态及焦虑/恐惧等应激因素影响；消耗性疾病可显著降低动物本应有的疼痛行为指标（犬可能为免加重疼痛而不鸣叫、不活动）。犬的疼痛识别需系统评估、观察互动、结合疾病/手术状态与既往史，用一致的评估流程与量表（框 1）。若犬在给予阿片类后出现喘气、恶心、呕吐或鸣叫，应考虑烦躁不安（见 1.4）。若判断犬疼痛，应立即给药；持续评估疗效，之后每 2-4 小时评估一次（视药物作用时长）；最早可在拔管后 30 分钟评估。

评估工具须具备效度、信度与对变化的敏感性；GPC 推荐使用经验证的疼痛量表（表 6）。格拉斯哥疼痛测量量表及其简版（CMPS-SF）与法国动物麻醉镇痛兽医协会疼痛评估表 4A-Vet 易用、含互动成分与行为类别。CMPS-SF 是配合临床评估使用的临床决策工具；并发镇静是混杂因素——深度镇静的犬无论是否疼痛都倾向得到高分，解读须考虑镇静对 CMPS-SF 分数的影响。

**表 6：评估犬急性疼痛的工具**', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫急性疼痛的识别与评估（1.4、1.5） (4)', '| 工具 | 类型 | 适用病理 | 评述 | 参考文献 |
|---|---|---|---|---|
| 格拉斯哥疼痛评估简表（CMPS-SF）† | 行为 | 任何外科或内科疼痛 | 中等验证；英/法/西/德/意/挪威/瑞典语；6 个问题，各项分值不同，最高 24（无法评估运动时为 20）；补救镇痛阈值 ≥6/24（无法评估运动时 ≥5/20）；newmetrica.com | Holton 2001；Reid 2007；Murrell 2008 |
| 法国动物麻醉镇痛兽医协会疼痛评估表 4A-Vet | 行为 | 骨科手术 | 初步验证；6 项各 0-3 分，最高 18，无阈值分；原文开放获取 10.1371/journal.pone.0049480 | Rialland 2012 |
| 墨尔本大学疼痛量表 | 行为与生理数据 | 卵巢子宫切除 | 初步验证；6 类多描述符，含生理数据与行为反应，最高 27，原文无阈值 | Firth & Haldane 1999 |

（† 证据更充分推荐；‡ 达到即应给予补救镇痛的分数。）

**表 5：犬猫急性疼痛相关的行为改变**（两栏在原 PDF 中并列；此处抽取存在跨栏合并与乱码，见下方说明）

| 猫 | 犬 |
|---|---|
| 面部表情改变（图 7）；身体姿势/体位改变（图 10）；活动与/或游戏活动减少；对环境兴趣下降；互动意愿下降；食欲下降；步态异常或负重改变；不寻常的坐/卧姿（可能提示不适与保护受伤区）；行为改变；哀鸣（呻吟、哭泣）；不愿移动；关注身体某部位（多为手术伤口）；保护性行为；停止理毛（或某处过度理毛）；蜷缩姿势和/或腹部紧张† | 安静、躲藏；身体姿势/体位改变（图 14）；活动与/或游戏活动减少；对环境兴趣下降；互动意愿下降；食欲下降；步态异常或转移体重；不寻常的坐/卧姿；对触碰或轻柔触诊疼痛区反应改变（如采取「祈祷姿势」缓解腹痛、或后肢伸展）；精神萎靡与不动、显得紧张、不与环境互动；犬的吹口哨/低吼或与恐惧相关的攻击；对伤口的关注 |

> 抽取说明：切片 006 表 5 中「犬的尾巴动作/行为」一栏与两条脚注（† 与 ‡「进食时抓不到食物、进食时头部颤抖增加」、§ 剧烈疼痛时观察）为法语两栏文字竖排合并产生的乱码，原文此处缺失/不可靠还原。猫栏「嘶叫、低吼或恐惧性攻击」实为犬栏内容因合并而错位，此处按可读文字归位，不确定处已标注。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7）', '6. 犬猫慢性疼痛的识别与评估（1.6、1.7）

**猫的慢性疼痛（1.6）**：随着猫寿命延长，慢性疼痛性疾病与共病（影响 QoL）患病率增加（参见 2021 AAFP 老年猫护理指南）。慢性疼痛长期存在，常与退行性关节病（DJD）、口炎、椎间盘疾病等相关；也可无基础病、继发于急性疼痛（如肢体、爪或尾截肢后的神经病性疼痛）。慢性疼痛的行为改变可逐渐发展、相当隐匿，因而更易被熟悉动物者（通常是主人）察觉。猫作为捕食者又是猎物，极善于隐藏疼痛、减少相关行为表现，且通常不像其他动物那样活动、也不主动与医护互动，故识别不适应疼痛更难。不适应长期疼痛的识别依赖于（受过适当培训的）照护者评估 + 兽医观察 + 兽医检查的组合；家庭自制视频对识别疼痛相关行为很有帮助（图 15），未来摄像头与可穿戴设备有望助诊断。

照护者评估是慢性不适应疼痛评估的基石，信息由客户报告结局或临床计量工具（CMI）录入。照护者培训很重要——长期疼痛造成的渐进行为改变可能被忽视或归因于衰老。已有评估猫 QoL/HRQoL 的研究与系统综述，但均非专门针对疼痛；多数工作聚焦猫 DJD 相关疼痛的识别（框 2）。近期基于可靠科学方法创建了**猫肌肉骨骼疼痛筛查清单（Feline Musculoskeletal Pain Screening Checklist，MiPSC）**，用于识别有 DJD 相关疼痛的猫，也可作为照护者培训工具。CMI 用于标准化照护者报告的收集、便于测量与识别 DJD 相关慢性疼痛，示例有猫肌肉骨骼疼痛指数（FMPI）、客户特异性结局测量（CSOM）、蒙特利尔猫关节炎筛查工具（IM-CAT/MICAT(C)）、猫身体功能公式（FPFF）。这些工具主要评估 DJD 疼痛对猫的影响并监测疗效，定期使用时可提供一致数据，也可辅助初诊。文献建议：用 MiPSC 筛查风险患者，用 FMPI 或 CSOM 监测疼痛体征与治疗反应。用活动监测仪（图 16）辅助检测与监测肌肉骨骼疼痛是活跃研究方向，但仍需理解疼痛如何影响活动及如何分析数据（图 16 为项圈加速度计活动监测仪）。目前研究也在评估猫其他类型不适应慢性疼痛（如口炎所致疼痛）的工具。

**定量感觉测试（QST）**测量热、机械、化学刺激由外周向躯体感觉皮层的传递：用校准器械对皮肤施加伤害性刺激直至出现行为反应，终点被客观记录（牛顿、克、℃、秒）。QST 使研究者比较病与健康动物、评估治疗效应。猫 DJD 研究显示其痛觉过敏、异常性疼痛与时间性疼痛总和促进较健康猫增强，反映外周与中枢敏化机制（图 17 为用 von Frey 轻压猫掌垫至出现缩腿反应，触发反应的最大力即伤害性感受阈值）。', '', 'senior', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (2)', '**框 2：慢性关节疾病——猫与犬的区别**：
- 退行性关节病（DJD）涵盖所有关节类型的退变，包括滑膜附肢关节、纤维软骨关节与椎间关节；骨关节炎是一种通常为退变性的、低度慢性炎症过程，累及滑膜关节，非感染或免疫介导疾病所致。
- 因肌肉骨骼疼痛就诊的猫常同时具有骨关节炎疼痛与非滑膜关节疼痛；猫滑膜关节退变是否由不同于犬骨关节炎的免疫功能障碍所致尚不清楚，故对因肌肉骨骼关节疼痛就诊的猫更倾向使用「DJD」一词。
- 犬骨关节炎主要源于发育性骨科疾病（髋/肘发育不良、髌骨脱位、剥脱性骨软骨炎、十字韧带断裂易感性），这些导致关节机械负荷增加或异常，引起低度慢性炎症、关节组织退化与疼痛，故骨关节炎（及骨关节炎性疼痛）早年即发生，应视为「青年犬疾病」。

**表 7：猫慢性疼痛筛查/评估（CMI）与 HRQoL 评估工具**', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (3)', '| 工具 | 类型 | 病理 | 评述 | 主参考文献 |
|---|---|---|---|---|
| 猫肌肉骨骼疼痛筛查清单（MiPSC 猫用）‡ | 筛查 | DJD/骨关节炎 | 6 问清单，问某活动能否正常完成，主人逐条答「是/否」；任一「否」即需进一步评估；cvm.ncsu.edu…comparative-pain-research | Enomoto 2020 |
| 猫肌肉骨骼疼痛指数（FMPI）‡ | CMI | DJD/骨关节炎 | 被研究最充分的「标准」CMI（构造效度、内部一致性、信度与判别力已评估）；更新版 FMPI-Short Form 含 9 个活动项，Likert 由「正常」到「完全不能」评 | Benito 2013a,b；Stadig 2019；Enomoto 2022 |
| 客户特异性结局测量（CSOM）‡ | CMI | DJD/骨关节炎 | 广泛使用，非「现成」问卷，而按每例个体与家居环境构建特定活动，由照护者共同决定并随访 | Lascelles 2007；Stadig 2019 |
| 猫主人用蒙特利尔猫关节炎筛查工具（MICAT(C)） | CMI | DJD/骨关节炎 | 初步验证；条目涉及敏捷性、社交、游戏与探索行为、自我理毛与体能 | Klinck 2015、2018 |
| 猫身体功能公式（FPFF） | CMI | DJD/骨关节炎 | 初步验证；评估四域（总体活动、运动、性情、理毛）；不供下载，条目见原文 | Stadig 2019 |
| 猫健康与福利（CHEW） | HRQoL | 任意 | 初步验证；33 条目分 8 域（运动、情绪、精力、投入、眼、被毛、食欲、体能）；作为原文补充材料 | Freeman 2016 |
| 猫 QoL 测量 | HRQoL | 任意 | 初步验证；16 条目分 2 域（健康行为、临床体征）；不供下载，条目见原文 | Freeman 2017 |
| VetMetrica 猫 HRQoL | HRQoL | 任意 | 初步验证；20 条目分 3 域（活力、舒适、情绪福利）；付费在线工具，条目见原文 | Scott 2021 |

（CMI=临床计量工具；DJD=骨关节炎；表内另列有 COP=环磷酰胺+长春新碱+泼尼松龙的缩写，对应行文字在本切片中被截断，原文此处缺失。† 证据更充分推荐；‡ 所有工具均须由照护者填写。）

**表 8：慢性疼痛评估中犬猫的行为改变**', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (4)', '| 猫 | 犬 |
|---|---|
| 总体活动（动作流畅性、动作自如）；活动（游戏、捕猎、跳跃、使用猫砂盆）；饮食与饮水；理毛（梳理）；休息、观察、放松（猫对这些活动的享受程度）；与人和其他宠物的社交互动；性情 | 活力与活动（是否精力充沛、快乐、活跃/迟钝、满足、爱玩，能否卧、坐、跳、运动）；情绪与行为（警觉、焦虑，或悲伤、封闭、阴郁，或顽皮、自信、合群）；痛苦水平（鸣叫——低吼、呻吟，姿态——低落，对与同类或人互动的反应）；疼痛指标（舒适程度、僵硬、跛行、骨科检查）；疼痛对躯体结构的影响（肌筋膜检查、肌纹） |

**犬的慢性疼痛（1.7）**：慢性疼痛长期存在，规律性地与慢性病相关，也可无持续临床病而继发于急性疼痛（如术后持续疼痛）。犬寿命延长使致痛慢性病（骨关节炎、脊髓病变、可治癌症、泌尿/肾/胃肠内科疼痛）发病率明显上升；患发育性骨科病的幼犬尤易在生命早期即发生慢性疼痛。所有年龄的犬都可能慢性疼痛；早识别意味着早干预（含生活方式改变），可减缓这一疼痛性疾病的进展。慢性疼痛治疗选择复杂，疗效存在大量个体差异。慢性疼痛识别是有效管理的前提；已有多种量表用于评估犬慢性疼痛或 HRQoL，但仅少数经过验证（表 9）。基于现有数据，推荐在实践中使用犬简短疼痛量表（CBPI）与 LOAD（利物浦犬骨关节炎问卷）。与猫一样，QST 与活动监测仪等工具也用于评估犬疼痛；QST 可提供关于慢性疼痛评估的宝贵视角，研究显示骨关节炎犬对外部刺激的感觉敏感性较健康犬呈全身性增高，验证后临床 QST 可作为实践补充。

**表 9：犬慢性疼痛筛查/评估（CMI）与 HRQoL 评估工具**', '', 'young', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 犬猫慢性疼痛的识别与评估（1.6、1.7） (5)', '| 工具 | 类型 | 病理 | 评述 | 参考文献 |
|---|---|---|---|---|
| 犬骨关节炎分期工具（COAST） | 筛查 | 骨关节炎 | 初步验证；三步（分级犬、分级关节、分级骨关节炎），助早期识别并随访；galliprantvet.com/us/en/coast-tools | Cachon 2018 |
| CBPI 评估表 | CMI | 骨关节炎与骨癌 | 已验证；11 问评估疼痛严重度与疼痛对 QoL 影响，Likert 评分；vet.upenn.edu…pennchart/cbpi-tool | Brown 2008、2009 |
| 利物浦犬骨关节炎量表（LOAD）‡ | CMI | 骨关节炎 | 已验证；13 问评估总体活动与运动时活动，Likert 评分；galliprantvet.com/us/en/coast-tools | Walton 2013 |
| 赫尔辛基慢性疼痛指数（HCPI） | CMI | 骨关节炎 | 初步验证；11 问 Likert 评分 | Hielm-Bjorkman 2009 |
| 夜间睡眠与躁动评估（SNoRE） | 睡眠与夜间躁动 | 骨关节炎 | 初步验证；原 6 项，现推荐 5 项版（2.0），睡眠评分 Likert；cvm.ncsu.edu…snore-evaluation | Knazovicky 2015；Gruen 2019 |
| 健康相关生活质量（HRQoL） | HRQoL | 慢性病 | 已验证；最新版 22 问分四域（精力充沛与热情、快乐与满足、活跃与舒适、安静与放松）；付费在线 newmetrica | Reid 2013、2018b |
| 健康相关生活质量（HRQoL） | HRQoL | 骨关节炎 | 已构建 HRQoL 评估概念框架，聚焦四域（外表、能力、行为、情绪）；工具尚未可用 | Roberts 2021 |

（CMI=临床计量工具，DJD=骨关节炎/退行性骨关节炎。† 所有工具均须由照护者填写，非穷举清单而仅列出研究较多者；‡ 须由照护者填写。）', 'dog', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 镇痛不足与不合理多重用药（1.8）', '7. 镇痛不足与不合理多重用药（1.8）

**镇痛不足（oligoanalgésie）**：指未能识别并对急性疼痛患者提供镇痛（Wilson & Pendleton 1989）。未处理围手术期急性疼痛可导致外周与中枢敏化及不适应疼痛（如术后持续疼痛）。人类急诊中，镇痛不足见于被视为不痛的常规操作、无法表达疼痛者或因评估不当未及时诊治者；这些因素也可能致兽医镇痛不足。历史研究显示许多犬猫尽管处于疼痛状态仍未获镇痛药，疼痛在急诊中很普遍；但近年围手术期镇痛药使用在增加（如英国逾 90% 兽医对常规手术给予围手术期镇痛，加拿大绝育镇痛使用亦上升）；也有研究提示某些国家绝育后术后镇痛仍不普遍（Lorena 2014、Perret-Gentil 2014）。

**框 3：镇痛不足的原因（据 Simon 等 2017）**：病历中的主观性医嘱（如「必要时（PRN）镇痛」而非用客观疼痛评分系统）；未做疼痛评估导致控制不当；一线人员（助理、学生、急诊兽医）缺乏疼痛评估培训；对抗镇痛药副作用的恐惧与误解；镇痛药可及性不足；技术人员依从性差；物种差异——即使相同手术，猫历来比犬得到更少镇痛；其他因素：过去缺乏经验证工具、镇痛药成本、特定镇痛药在人类的滥用可能、对工具或药物缺乏经验/信心、不熟悉处方规程。教育与疼痛管理培训（含镇痛药不可得时的替代控痛讨论、使用经验证评估工具）对纠正镇痛不足至关重要。

**不合理多重用药（polypharmacie）**：必须区分合理多模式镇痛与不合理多重用药。多重用药指无正当理由过度联合用药，可致复杂药物相互作用与不良副作用风险增加。例如作用于血清素系统的药物联用增加血清素综合征风险；AINS 与糖皮质激素联用增加胃肠道溃疡/穿孔等副作用风险。多模式镇痛虽改善缓解，但过度多重用药在诊所与家庭都成本高、难随访用药与服药时间；一日三次给药常对主人不可行导致依从差；过多药物还可能恶化人兽关系（超半数主人反映给猫喂药改变了与猫的关系）。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'caution', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 神经病性疼痛（1.9）', '8. 神经病性疼痛（1.9）

神经病性疼痛是由躯体感觉系统损伤或疾病直接引起的疼痛（Jensen 2011，见表 3），属不适应现象，涉及异位自发性异常感觉活动、神经可塑性、外周与中枢敏化、内源性抑制调节改变及胶质细胞激活等。兽医领域它常被漏诊、理解不足且相对新；截至撰写时无专门诊断神经病性疼痛的经验证工具，一般经详尽临床与神经学检查及可能的进阶影像（如 MRI）后推定。当患者对常规镇痛治疗抵抗并出现异常性疼痛和/或痛觉过敏时应怀疑神经病性疼痛；但视损伤与疾病不同也可能出现痛觉减退（hypoalgésie）。犬胸腰椎椎间盘突出的 QST 及神经病性疼痛犬的 QST 显示，较健康犬疼痛促进增加和/或疼痛抑制减少，未来纳入体格/神经学检查或可提供有用信息。动物可见多种神经病变：脊髓病变、慢性肌肉骨骼疾病、周围神经病、术后持续疼痛。骨关节炎可致全身中枢敏化并引发神经病性疼痛；猫糖尿病性神经病是继发于糖尿病、引起跖行姿势与神经病性疼痛的综合征；骑士查理王猎犬、吉娃娃等品种的 Chiari 型畸形及脊髓空洞症是重要神经病性疼痛来源，常伴恐惧行为与 QoL 下降，涉及基因因素——颅与颅颈交界畸形压迫脑实质、致疼痛并扰乱脑脊液循环。猫感觉过敏综合征（FHS）与口面部疼痛综合征（FOPS）是具有强烈提示神经病性疼痛的行为体征的疼痛障碍（图 18）。7 例 FHS 病例系列的临床特征包括腰区皮肤滚动、跳跃与奔跑发作、过度鸣叫、追尾或自残尾行为；FOPS 在缅甸猫中患病率高于其他品种，病理生理类似人类三叉神经痛，含单侧急性发作与推定的遗传成分并可能与应激相关，可由口腔动作触发或自发，表现为口部抓挠、过度舔咬动作、舌自残、伴逃跑行为的自发鸣叫与食欲下降。神经病性疼痛治疗仍复杂：兽医文献常一线使用加巴喷丁类（gabapentine、prégabaline）并见 QoL 明显改善；怀疑炎症病时可与 AINS 联用；NMDA 受体拮抗剂（如金刚烷胺 amantadine）亦用于犬与猫的骨关节炎治疗；多种理疗（热/冷疗、针灸、激痛点针刺、牵伸、按摩、运动）可实施但需更多研究验证有效性；还需研究更多神经病性疼痛治疗选项与潜在安慰剂效应（详见第 3.12 章）。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 口面部与牙齿疼痛（1.10）', '9. 口面部与牙齿疼痛（1.10）

据 IASP，口面部疼痛是面部和/或口腔区域常见疼痛，可由区域结构疾病/障碍、神经系统功能障碍或远隔问题引起；可涉及肌韧带、牙槽及/或神经血管机制。牙痛是口面部疼痛的特异类型，源于牙病或向牙的放射痛；牙伤害性感受机制与身体其他组织不同（牙髓高度神经支配，被矿化的牙本质与牙釉质包围；后者无血管、无神经、无孔，起保护层作用，但在炎症时牙髓轻微肿胀即引起剧烈疼痛，尤其当牙釉质受损）。口面部疼痛在兽医中常见，因口腔疾病高患病率（牙周病、断牙、口炎、咬合不正、肿瘤）导致急慢性疼痛、影响 QoL 与人宠纽带。WSAVA 牙科标准化委员会已发表含牙科麻醉与疼痛管理的文件，AAHA 牙科护理建议也可用。牙周病在犬猫常见，治疗常需全身麻醉与拔牙。猫慢性牙龈口炎表现为舌基与腭舌褶周围双侧、多灶或弥漫、易碎、增生性溃疡性病变，导致严重口腔疼痛、厌食、咀嚼困难、流涎、口臭、体重下降，可致口腔出血并常需全口拔牙。其他常见牙痛原因：创伤、牙髓感染（牙髓炎）、牙髓病、肿瘤、咬合创伤、脓肿、裂牙综合征、骨折与侵入性口腔手术（上颌/下颌切除）。口腔牙齿疼痛虽常见却常被低估、误治与忽视，被视为优先福利问题；英国犬电子病历调查显示牙科疾病因高患病率、长病程与严重度位列影响福利的前三疾病。目前多数研究聚焦局部麻醉块及其减少全身麻醉用量的效应，关于口腔疼痛特异镇痛与相关行为的研究很少。这类患者需较长阿片类治疗（某些病例可达 72 小时），并在手术时用阿片类、局部麻醉药与 AINS 的多模式方案。猫拔牙后表现为不那么爱玩、活动减少；犬的类似研究尚未进行。口腔疼痛病可负面影响动物 QoL 与睡眠（如人类）。兽医认为口咽疾病是犬慢性疼痛的主要来源，对猫可能亦然。犬猫可患口面部神经病性疼痛（见 FOPS，1.9）或口腔良恶性肿瘤相关慢性疼痛。IASP 强调口面部疼痛多维性需跨学科方法，并设特别兴趣组。兽医牙科尚无物种特异的疼痛评估问卷发表，但猫鬼脸量表在拔牙后观察者间信度为良好至优；经进一步验证后，现行疼痛评估格可能有助评估犬猫口腔颌面疾病疼痛。牙科疼痛管理依赖多模式方法；多数诊断操作（如 X 光）需全身麻醉，拔牙等侵入性疼痛操作也应在全身麻醉下完成；多颗拔牙后常需较长疗程 AINS，即便围手术期已用阿片类与局部麻醉。慢性疼痛药物治疗可考虑 AINS 及中枢性镇痛药（加巴喷丁、阿米替林、曲马多——曲马多仅限猫）。牙科方案示例见第 2.5 与 3.7 章。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 癌症疼痛（1.11）', '10. 癌症疼痛（1.11）

疼痛可在癌症各阶段影响患者，临床表现因肿瘤部位与性质差异很大。一般而言累及口腔、骨、泌尿生殖、眼、鼻、神经与胃肠道的肿瘤造成明显疼痛，其他癌症（如淋巴瘤）也可致痛；累及骨或伴神经病性成分时疼痛更剧烈。随癌症进展疼痛更频繁更强。人类中癌症疼痛是最令人恐惧与失能的症状之一，各期 43-63% 患者、进展期高达 90% 受影响。宠物癌症疼痛确切患病率未知，但考虑犬猫寿命延长与癌症为主要致病/致死原因，可合理假设其很高。英国兽医调查显示 87% 认为癌症疼痛诊断不足，66% 认为其易于治疗。癌症患者的疼痛可急性、慢性或二者兼有，具多维性质（表 10），可为躯体性或内脏性，一般含炎症与神经病成分。

**骨癌**：可为原发（如犬骨肉瘤，图 21）或其他癌症骨浸润（如猫口腔鳞状细胞癌）。骨肉瘤是侵袭性恶性骨肿瘤，引起溶骨与增生，好发大型与超大型犬；这些癌症疼痛剧烈，患者多在晚期确诊。犬骨肉瘤研究显示其较健康犬全身痛觉敏化增强（全身更痛）、肿瘤部位异常性疼痛、瘤周及其他部位痛觉过敏、伤害性抑制机制功能障碍，QoL 评分低、活动下降、睡眠障碍增多。

**内脏癌**：腹部与胸部癌症疼痛，但来源难定位，可由空腔器官扩张与收缩、器官包膜或黏膜牵拉、肿瘤侵犯或压迫内脏血供致缺血、或压迫/侵犯供养内脏或其他结构（韧带、血管、肠系膜）的神经结构所致。

**表 10：癌症疼痛是多因素的，与疾病本身、诊断与治疗操作及伴随疾病相关**

| 促成因素 | 评述 |
|---|---|
| 肿瘤直接后果 | 多数肿瘤为扩张性病变，引起组织坏死、软组织/骨浸润并影响周围神经；炎症性疼痛源于组织损伤与炎症，神经病性疼痛源于周围神经或其他神经组织受累或压迫 |
| 肿瘤与宿主环境生化交互的后果 | 癌细胞、免疫系统与外周/中枢神经系统间的复杂通讯在促进肿瘤生长与扩散、产生与维持癌症疼痛中起核心作用 |
| 诊断操作 | 活检、穿刺、内镜及影像摆位可致暂时疼痛与不适 |
| 抗癌治疗 | 静脉穿刺、手术、化疗与放疗可致轻至重度疼痛，含急性痛、术后持续痛（如截肢、开胸）、化疗诱导神经病、黏膜炎症与放射诱导疼痛 |
| 转移性疾病 | 癌症可侵犯健康组织，如骨转移 |
| 伴随疼痛病 | 癌症患者常有其他慢性疼痛来源，含骨关节炎与牙周病 |

（图 21 涉及 SP 物质 P、NGF 神经生长因子、CGRP 降钙素基因相关肽、PG 前列腺素、TRPV 香草酸受体激动剂。）', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'caution', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 营养与疼痛的交互（1.12）', '11. 营养与疼痛的交互（1.12）

犬猫的喂食、肥胖与骨关节炎性疼痛密切相关；犬减重可减轻疼痛，体况与肌肉评分信息见 WSAVA 全球营养指南。肥胖与骨关节炎疼痛强相关部分归因于超重带来的机械负荷增加及脂肪组织产生的促炎介质引起的代谢改变；肥胖被视为炎症性疾病，脂肪组织作为活跃「器官」分泌大量细胞因子。肥胖还影响肠道微生物组，进而影响疼痛与疾病状态。肠道微生物通过与神经系统（神经-内分泌-免疫轴）交流影响疼痛调节；慢性疼痛状态以神经炎症为特征，其促进慢性疼痛又反过来加重神经炎症。饮食可通过肠-脑相互作用与微生物组改变影响神经炎症。高热量低纤维饮食与氧化应激、细胞坏死及组织损伤相关（经促炎中枢免疫信号与胶质细胞激活）；另有研究提示生酮、高能量高蛋白饮食可助缓解疼痛与减轻炎症。某些肠道微生物可产生色氨酸、提高血清素介导镇痛，另一些可产生 NMDA 受体激动剂、促中枢敏化。用微生物组控痛的数据尚缺，但益生元在兽医应用正扩展，多研究示其对胃肠与代谢病的益处。肥胖、炎症、血糖与疼痛已建立联系；某些减少肠道（及全身）炎症的膳食补充剂或可发挥作用，但结果仍喜忧参半（见第 2.12 章）。营养管理与神经炎症的药物阻断剂或有前景。目前控制肥胖仍是缓解疼痛最成熟的方法。急性疼痛也可影响摄食与进食行为：多颗拔牙的猫干粮与软粮摄入显著少于仅洁牙或微创拔牙者；多颗拔牙猫在术后长达 6 天频繁出现进食时「难以抓取干粮」与进食后「甩头」。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 各病症疼痛感知水平（1.13）与表 11', '12. 各病症疼痛感知水平（1.13）与表 11

疾病分级（表 11）仅作指导，疼痛因患者与疾病而异，每例须个体评估；既往疼痛史或疼痛记忆会影响当前可观察到的疼痛，先前或持续疼痛可加剧任何新病或手术相关疼痛，即「慢性基础上的急性发作」。**表 11 中的条目按字母序而非严重度排列**（此表在两栏并排抽取时存在跨栏错乱，下方按可读文字归类）：

| 剧烈至难以忍受 | 中度至重度（随疾病/损伤程度而异） |
|---|---|
| 主动脉血栓栓塞；关节或病理性骨折；骨癌；烧伤；中枢神经系统梗死/肿瘤；耳道切除术；伴软组织广泛损伤的骨折修复手术；增生性骨营养障碍；广泛炎症（如腹膜炎、筋膜炎）；肢体截肢；脑膜炎；坏死性胰腺炎或胆囊炎；神经病性疼痛（神经压迫/炎症、椎间盘嵌入等）；脊柱手术；血栓/缺血 | 器官肿大所致关节囊痛；角膜磨损/溃疡；矫形骨科手术（截骨术、十字韧带手术、开放关节切开术）；难产；软组织损伤/炎症/疾病的早期或消退期；广泛切除与重建以大面积摘除；青光眼；冻伤；空腔器官扩张；免疫介导性关节炎；椎间盘疾病；乳腺切除术；乳腺炎；肠系膜、胃、睾丸或其他扭转；黏膜炎（含放疗相关）；口腔癌；全骨炎；腹膜炎/胸膜炎；口炎；创伤（如尿道/输尿管/胆管梗阻、头、软组织范围）；葡萄膜炎 |

| 中度 | 轻度至中度 |
|---|---|
| 膀胱炎；牙齿疾病；关节镜与腹腔镜；骨关节炎（若涉及神经病性疼痛可为重度；生命末期阶段）；卵巢子宫切除；软组织损伤（即较上述为轻）；尿道梗阻 | 脓肿及其处理；胸腔引流；牙齿疾病；膀胱炎；耳炎；浅表撕裂伤 |

> 抽取说明：切片 013 表 11 由法语 PDF 多栏抽取合并，个别条目（如「Par Gelure」冻伤、「Traumatisme」创伤括注）跨栏错位，此处按可读文字归位；条目严重度以原四档划分为准。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'caution', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('2022 WSAVA 疼痛全球指南——概述与评估 · 关于疼痛的常见误解（1.14）', '13. 关于疼痛的常见误解（1.14）', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 关于疼痛的常见误解（1.14） (2)', '- **阿片类会使清醒犬猫呼吸抑制——错误**：此误解源于人类对阿片类呼吸抑制尤为敏感；实际在合适剂量下阿片类在围麻醉期很少造成严重副作用。但病畜应滴定剂量以在最小化并发症风险的同时获得有效镇痛。对无意识动物、颅内病理（颅外伤后）及短头品种（尤其短头阻塞性气道综合征）应密切观察呼吸频率/深度与脉搏血氧。
- **无意识动物有误吸性肺炎风险——正确**：犬猫误吸性肺炎（PA）病因多因素、可发生于围手术期。回顾研究中 18% 诊断 PA 的猫曾接受麻醉；犬镇静/麻醉大样本多中心回顾研究 PA 发生率 0.17%，其中反流事件或使用氢吗啡酮与 PA 显著相关。喉麻痹、食道功能障碍、短头综合征，或接受特定手术（开腹、上气道手术、神经外科、开胸、内镜）者风险更高。尚无研究直接建立意识水平与 PA 风险的关联，但无意识动物喉反射较慢、保护气道较弱看似合理。
- **术中大剂量阿片类会造成问题——可能正确**：术中阿片类因减少麻醉需求并提供镇痛而有益；呼吸抑制可因麻醉药综合作用出现，但可经手动/机械通气处理。苏醒期可能出问题——一研究中近 25% 骨科手术中持续输注芬太尼的犬出现麻醉后烦躁不安。阿片类（尤其大剂量、单独用于术中镇痛时）有时可通过激活胶质细胞加重疼痛（阿片诱导痛觉过敏）；该现象在兽医中尚未证实，但可能致所需剂量增加、镇痛不足、部分病例出现痛觉过敏。
- **AINS 对犬猫有毒——错误**：剧痛总伴随炎症，AINS 是急性与慢性疼痛镇痛的支柱之一，在全球犬猫广泛安全使用；镇痛获益在风险获益权衡中权重更大。肝功能受损与晚期肾病动物使用 AINS 的利弊须仔细考量。犬最常见副作用为呕吐、腹泻、厌食；给药前须检查以发现风险因素并全程监测。许多人类批准的 AINS 在动物安全范围有限，须谨慎；有获批兽药时应优先使用。
- **止痛后动物会活动、导致缝线崩开或愈合不良——错误**：用疼痛来限制术后活动是不合乎伦理的；需控制活动时应采用其他方法（限制笼、牵绳散步）；犬服 trazodone 有助术后限制。负重受控运动对骨科术后修复至关重要，以保证合适骨愈合、维持肌肉量支撑肢体；不使用/不承重导致肌与骨萎缩；无镇痛则运动产生过大疼痛；未治疗的腹/胸切口疼痛也会妨碍正常通气。
- **新生与儿科动物不感到疼痛——错误**：有力证据支持人类新生儿体验疼痛、且未处理者可能更敏感，可致持续痛苦；新生儿功能 MRI 显示疼痛某些特征与成人相似。鉴于哺乳动物神经解剖相似性，应假设新生犬猫能感受疼痛（虽可能不同于成体体验）。
- **镇痛药会掩盖患者恶化体征、妨碍诊断或随访——错误**：若患者疼痛，出于伦理及减少疼痛相关不良生理效应（心动过速、呼吸急促、潮气量低、肠麻痹）应考虑镇痛；应体检后尽快给药，有时须先缓解疼痛才能检查。全身给药（如阿片类）能缓解但未必完全消除急性创伤或急诊手术（如胃扩张扭转的剧烈内脏痛）的疼痛；可用短效阿片类滴定至既能评估患者、适当镇痛又仅轻度镇静（如神经学检查）。
- **麻醉药就是镇痛药、能预防疼痛——错误**：吸入麻醉药（异氟烷、七氟烷）与注射麻醉药（丙泊酚、alfaxalone）阻断疼痛感知，被某些教材称作镇痛药；但它们不是抗伤害性/经典镇痛药，故全麻期间若有有害刺激且未给抗伤害性药物，伤害性感受（转导、传递、调制）仍发生，苏醒时患者将感到疼痛（伴神经内分泌改变的有意识情绪）。
- **疼痛管理只关注用药——错误**：急慢性疼痛管理须整合（药物 + 非药物）。非药物示例含针灸、按摩、饮食、处方粮、功能康复、护理与支持治疗；冰/冷疗（第 2.10 章）有效且低成本。药物联用称为多模式，药物 + 非药物技术联用亦为多模式，可为患者带来额外获益。
- **关节疼痛时运动禁忌——错误**：受控运动可减轻多种急性疼痛与某些慢性疼痛；运动激活内源性神经调节镇痛系统（阿片类、一氧化氮、血清素、儿茶酚胺、内源性大麻素），改善软骨结构与功能、肌肉筋膜肌腱韧带活动度、骨与椎间盘结构功能；不活动增加来自软组织的疼痛。受控运动、等长与平衡训练、关节活动度与肌力训练、游泳、水下跑步机等可能有益。
- **镇静动物不太可能感到疼痛——错误**：镇静仅掩盖疼痛行为体征及我们识别评估疼痛的能力；非镇痛药镇静使患者看似舒适，但若被评估（如触诊手术部位）多半是疼痛的。镇静可取，但应经镇痛药 + 镇静剂/抗焦虑药联用、或有镇静特性的镇痛药（如右美托啶 dexmédétomidine、布托啡诺）实现，且须定期评估疼痛。
- **任何活动障碍都是疼痛所致——错误**：骨关节炎/DJD 相关疼痛是犬猫活动下降的常见原因，但也有其他原因（变性性脊髓病、老龄喉麻痹性多神经病、猫糖尿病性神经病、前庭病继发共济失调、趾甲过长）；视力下降或失明可改变探索行为；', '', 'senior', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'caution', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · 关于疼痛的常见误解（1.14） (3)', '将疼痛与其他虚弱/活动障碍形式区分，对 QoL 评估至关重要。
- **膳食补充剂与植物疗法天然故总是安全——错误**：许多主人与兽医支持用植物疗法与补充剂作疼痛辅助；须充分了解其不良反应及与药物的相互作用。「天然」不等于安全（见有毒植物手册）。血清素综合征（高血清素所致一组体征）可能是与贯叶连翘（millepertuis，Hypericum perforatum）等补充剂相关的最常见不良事件，可因过量或患者已用其他改变血清素水平的药物（氯米帕明、氟西汀、trazodone）。Boswellia、大麻素等植物药可改变肝酶与其他药物代谢。美国麻醉医师学会建议麻醉与手术前停用许多植物与补充剂，包括可增加出血的大蒜、银杏、人参、维生素 E，及可延长某些麻醉效用的卡瓦、缬草。', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'caution', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——概述与评估 · SECTION 2 起始：疼痛治疗的总体方法（2.1）', '14. SECTION 2 起始：疼痛治疗的总体方法（2.1）

疼痛是复杂疾病，具感觉与情绪成分、因人而异；宜早期以稳健方案处理，疼痛一旦确立更难治疗；应尽量以预防为镇痛方案核心，目标是消除或至少将疼痛减至最低。

**「先发制痛」与「预防性镇痛」**：先发制痛（analgésie préemptive）指在组织损伤/侵害前（术前）给镇痛药；预防性镇痛（analgésie préventive）是更恰当的临床概念，指术前、术中、术后均给镇痛，涵盖围手术期各时点可致外周与中枢敏化的因素，并含所有围手术期镇痛技术/药物。预防性镇痛常用药包括 AINS、局部麻醉药、阿片类、α2 肾上腺素受体激动剂、NMDA 拮抗剂（如氯胺酮）与加巴喷丁。冷疗是术后最易得的非药物选项，可减少围手术期疼痛严重度并有助降低术后持续疼痛患病率。**多模式镇痛**指药物与非药物（整合）治疗并用，同时给予作用于伤害性通路不同位点的药物与疗法以达最佳镇痛，因针对不同机制，每种药物可用较低剂量从而减少副作用。选药取决于疼痛原因、严重度与时长；须了解各物种、不同年龄与体格状态者的药理学——药动学在成年、儿科（<12 周龄幼犬幼猫）、老龄（达预期寿命 >75%）及共病个体间不同，尤其犬与猫之间用药方案有别。应尽一切可能加入非药物治疗。积极情绪在减痛中作用重要，应尽力减少应激、恐惧与焦虑同时提供正性身心刺激：围手术期提供温暖清洁舒适的卧处与安静环境、温柔抚摸与积极互动、为猫提供躲藏空间与高台、条件允许时勤遛犬；慢性疼痛管理则应通过激发游戏、促进积极互动强化人宠纽带、丰富环境来提高身体活动。

**急性疼痛**：由创伤、手术或感染事件触发，围手术期疼痛是典型例子，分四阶段（术前、术中、术后即刻在诊所、术后居家/愈合期）；镇痛方案显著影响术后疼痛程度。围手术期疼痛管理应含不同类别药物，运用预防性与多模式概念；非药物镇痛含冷疗、针灸、被动关节活动、按摩、治疗性运动、水疗、超声与电刺激。护理（环境、伤口护理、膀胱排空、人宠互动）也影响住院体验。围手术期疼痛程度可受手术技术与部位影响，应尽量精细组织操作与最小创伤技术（小切口、微创如关节镜与腹腔镜）。术前已有炎症或慢性疼痛（如子宫蓄脓、癌症、骨关节炎）者术中术后疼痛更强，需更频繁/更大剂量、更长时间镇痛（即「慢性基础上的急性发作」）。可用疼痛量表优化镇痛方案。

**慢性疼痛**：慢性或不适应疼痛可伴原发疾病或单独存在；人类慢性疼痛常伴恐惧、焦虑、抑郁与愤怒，加重疼痛及其对 QoL 的负面影响；可累及各年龄但以高龄动物更常见。慢性疼痛相关行为改变起病隐匿、微妙，常漏诊或误认为「只是变老」；处理慢性病（如慢性耳炎、慢性伤口、炎性肠病、骨关节炎）的兽医应始终考虑慢性疼痛可能。治疗路径取决于疼痛根本原因、时长与既往管理质量；慢性疼痛可表现为既往控制良好的疼痛急性加重（「慢性基础上的急性发作」）。多模式方法可能最有效，医护培训（尤其对治疗期望与预后）至关重要。慢性疼痛治疗支柱以 AINS 为首——**（本句在此处接续到切片 015 起始的「2.2 阿片类」，切片 014 止于「Les piliers du traitement de la douleur chronique sont les AINS ;」，后续内容不在本稿覆盖范围。）**', '', '', '', '疼痛管理,疼痛全球指南,WSAVA,全球疼痛委员会GPC,IASP疼痛定义,适应性疼痛,文献信息与背景,疼痛的定义与分类（1.1 理解疼痛）,疼痛的生理与病理生理（1.2）', 'informational', '2022 WSAVA 疼痛全球指南——概述与评估', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 剖腹产疼痛管理', '剖腹产疼痛管理

本指引为分层（tiered）方案，原文明确说明：并非所有镇痛方式（analgesic modalities）在各地区均可获得，实施时应按可获得的药物与该个体病例的需要进行选择。

1. 适用场景

- 猫（queen）与犬（bitch）的剖腹产（Caesarean section）。
- 妊娠相关的生理变化（physiologic changes associated with pregnancy）会影响剖腹产麻醉与镇痛药物的选择。
- 所有麻醉与镇痛药物均穿过胎盘屏障（cross the placental barrier）。
- 原文指出：犬在剖腹产与新生仔活力、存活方面有更充分的循证信息，猫的证据较少（There is more evidence-based information on caesarean section and neonatal vitality and survival for dogs than cats）。', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'informational', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 评估要点', '2. 评估要点

| 项目 | 原文要点（逐字） |
|---|---|
| 术前给药 | Premedication is normally recommended to decrease maternal stress and anxiety and to reduce the doses of induction and maintenance agents; in addition the use of opioids provides pre-emptive analgesia. |
| 呕吐/误吸风险 | Decreased gastrointestinal motility and the enlarged uterus increase the risk of vomiting and aspiration. Aspiration of gastric contents is thought to contribute to maternal mortality. |
| 阿片选择 | 若术前使用阿片类，choose those that are less likely to cause emesis (e.g. buprenorphine, butorphanol, methadone and pethidine). |
| 气道 | intubation is always warranted to protect the airway and also for delivery of oxygen. Rapid control of the airway is essential therefore mask induction with an inhalant agent is not recommended. |
| 对仔畜影响 | The administration of opioids prior to delivery has not been shown to adversely affect the outcome for the offspring. |
| 新生仔心动过缓 | If opioids have been administered to the dam and the offspring are bradycardic, naloxone can be administered via the umbilical vein or sublingually. |
| 低氧血症 | Due to their high oxygen requirements and reduced functional residual capacity of the lungs, pregnant animals are at risk for hypoxaemia and oxygen desaturation can occur rapidly at induction of anaesthesia. Pre-oxygenation (3–5 minutes) using a face mask is recommended. |
| 液体治疗 | Many animals undergoing caesarean section are dehydrated and even in elective situations, fluid losses can be large therefore intravenous fluids are recommended and should be started prior to induction of anaesthesia. |', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'informational', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 镇痛与麻醉方案（按可及性分层）', '3. 镇痛与麻醉方案（按可及性分层）', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'informational', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 择期手术（Elective situation）', '3.1 择期手术（Elective situation）

| 阶段 | 原文方案 |
|---|---|
| Preoperative | IM or IV opioid ± acepromazine (lower doses [0.01–0.03 mg/kg IM or IV] are usually sufficient). An opioid normally provides adequate sedation for venous access however acepromazine can be used if the dam is difficult to manage and requires more sedation than an opioid alone can provide. |
| Induction and maintenance of anaesthesia | IV alfaxalone to effect (3–5 mg/kg) or IV propofol to effect (3–10 mg/kg). Where propofol or alfaxalone are not available, ketamine or thiopentone could potentially be used with the understanding that they may decrease vigour of the offspring and resuscitation efforts should be aggressive. Following intubation, anaesthesia can be maintained with isoflurane. Anaesthesia can be maintained with repeated boluses or a continuous rate infusion of propofol, but intubation and administration of oxygen is still required. |
| 吸入药减量警示 | NOTE: The dam''s requirements for inhalant agents may be reduced by 25–40% at term. |
| Local anaesthetic techniques | Pre-incisional and / or post incisional line block (lidocaine or bupivacaine). |
| Epidural / Spinal analgesic techniques | Morphine can be administered pre- or post-operatively to provide up to 18–20 hours of analgesia. |
| Postoperative analgesia | NSAIDs, one dose. Opioids can be continued. |', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'informational', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 急诊且母体状况不良（Emergency situation with compr', '3.2 急诊且母体状况不良（Emergency situation with compromised dam）

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Fentanyl IV (3–5 µg/kg). |
| Induction | IV etomidate (1–2 mg/kg) ± diazepam or midazolam (0.25 mg/kg), IV ketamine (3–5 mg/kg) plus diazepam or midazolam (0.25 mg/kg); midazolam is shorter acting in both dam and offspring so is preferred when available. |
| Maintenance | Following intubation anaesthesia can be maintained with isflourane（原文拼写） and fentanyl can be repeated. |
| Local anaesthetic techniques | See above. |
| Epidural / Spinal analgesic techniques | See above. |
| Postoperative analgesia | NSAIDs should only be considered if the bitch or queen is normovolaemic and normotensive. Opioids can be continued. |', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'caution', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 无管制药物方案（Protocol without controlled drug', '3.3 无管制药物方案（Protocol without controlled drugs）

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Acepromazine unless the bitch or queen is volume depleted. If the dam is compromised do not administer premedication drugs. |
| Induction and maintenance of anaesthesia | IV alfaxalone to effect (3–5 mg/kg), propofol to effect (3–10 mg/kg) or etomidate (1–2 mg/kg). Following intubation anaesthesia can be maintained with isoflurane. Anaesthesia can be maintained with repeated boluses or a continuous rate infusion of propofol, but intubation and administration of oxygen is still required. |
| Local / Epidural / Spinal | See above. |
| Postoperative analgesia | NSAIDs, one dose. |', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'informational', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 麻醉与镇痛药物可及性受限（Protocol with limited avail', '3.4 麻醉与镇痛药物可及性受限（Protocol with limited availability）

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Acepromazine (see indication for use above). |
| Induction and maintenance | Depending on availability of drugs, choose from the protocols above. |
| Local anaesthetic techniques | Epidural local anaesthetic (lidocaine) can be used as a sole technique but with caution. |
| Postoperative analgesia | NSAIDs one dose. |

硬膜外技术专项警示（原文逐字）：
- NOTE: due to the decreased size of the epidural space in pregnant animals, smaller volumes (25–30% reduction) of epidural local anaesthetic drugs are used.
- Epidural local anaesthetics cause sympathetic blockade with resultant vasodilation and hypotension which can be prevented or treated with intravenous fluids, but could be especially detrimental in compromised dams.
- With this technique the dam is conscious and therefore not intubated so there is an increased risk of aspiration; oxygen should be administered by face mask. The dam will also require to be manually restrained for surgery.', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'informational', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 禁忌与警示', '4. 禁忌与警示

| 药物/类别 | 原文警示 |
|---|---|
| xylazine（alpha2-adrenergic agonist）、methoxyurane（inhalant agent，原文拼写） | Drugs that are known to increase maternal and/or neonatal mortality include the alpha2-adrenergic agonist xylazine and the inhalant agent methoxyurane. |
| medetomidine and dexmedetomidine（较新的 alpha2-adrenoceptor agonists） | There is no data on the effect ... on anaesthetic risk associated with caesarean section. However due to the potential for emesis and cardiovascular depression, these drugs as a class are best avoided. |
| NSAIDs | Some controversy regarding the use of NSAIDs in this setting due to potential uptake and negative effects in the suckling offspring. However, only a small percentage of the dam''s dose of NSAID is secreted in milk and a single post-operative dose is regarded as a suitable compromise. NSAIDS should only be given if hypovolaemia and hypotension have been corrected. |
| 面罩吸入诱导 | mask induction with an inhalant agent is not recommended. |', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'caution', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫/犬剖腹产疼痛与麻醉管理 · 术后与新生仔管理要点', '5. 术后与新生仔管理要点

- 术后镇痛：各分层方案均为 NSAIDs 一剂（one dose），阿片类可继续（Opioids can be continued）。
- 新生仔：若母体已给予阿片且仔畜出现心动过缓，可按「2. 评估要点」表使用 naloxone（脐静脉或舌下给药）。
- 原文未提供出院/居家用药与复诊时间安排，「原文此处缺失」；补充剂量信息原文指向 WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）。', '', '', '', '疼痛管理,剖腹产,超前镇痛,误吸,aspiration,预充氧,适用场景,评估要点,镇痛与麻醉方案（按可及性分层）', 'informational', '猫/犬剖腹产疼痛与麻醉管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('癌性疼痛管理 · 第 1 段', '癌性疼痛管理

本指引为分层（tiered）方案：并非所有镇痛方式（analgesic modalities）在各地区均可获得，实施时按可获得的药物与个体病例需要进行选择。

1. 适用场景

- 肿瘤患畜（cancer patients）的疼痛。原文指出疼痛可与肿瘤本身有关、与诊断性操作有关、与治疗有关，也可以与肿瘤无关（or it can be unrelated to cancer）。
- 肿瘤本身所致疼痛的严重程度因病程（duration）、部位（location）与肿瘤类型（type of cancer）而异。
- 原文强调：Most patients with cancer suffer pain at some point in the course of the disease.（大多数肿瘤患畜在病程的某个阶段都会发生疼痛。）', '', '', '', '疼痛管理,癌性疼痛,骨肿瘤疼痛,神经病理性疼痛,多模式镇痛,NSAIDs,适用场景,评估要点与机制,镇痛方案', 'informational', '癌性疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('癌性疼痛管理 · 评估要点与机制', '2. 评估要点与机制

| 要点 | 原文内容（逐字/直译保留术语） |
|---|---|
| 疼痛机制 | It may be associated with inflammation, tissue infiltration, mechanical factors (e.g. organ distension), nerve infiltration or compression and potentially factors released by the tumour. |
| 流行病学证据缺口 | The prevalence and severity of pain associated with various cancer types in animals is not well documented. |
| 证据最充分的癌痛类型 | One of the best documented types of cancer pain is that associated with primary or metastatic bone tumours. |
| 骨痛的具体机制 | Pain results from direct invasion of the bone, microfractures, increased pressure of endosteum, distortion of the periosteum or perilesional inflammation. |
| 化学介质 | Another important mechanism is the release of chemical mediators such as amines, peptides, fatty acids, potassium, and prostaglandins. |
| 神经病理性特征 | Cancer pain, and bone pain in particular, are often associated with neuropathic-like clinical signs. |
| 骨癌犬的难治性 | Dogs with bone cancer can be affected by widespread somatosensory sensitivity and clinical pain is generally refractory to palliative treatment with orally administered analgesics. |
| 治疗相关疼痛 | Cancer treatments including specific chemotherapy agents (chemotherapy induced peripheral neuropathy [CIPN]) and therapeutic radiation (radiation associated pain [RAP]) can be associated with significant pain at the time of treatment, but also for prolonged periods afterwards. |
| CIPN/RAP 机制 | Mechanisms of CIPN and RAP are poorly understood and undergoing investigation. |
| 疼痛与预后 | The presence of pain itself (unrelated to cancer) may promote the progression of cancer, and emerging evidence indicates that pre-treatment cancer pain levels may be negatively related to survival. |
| 肿瘤与神经互动 | evidence indicates that some cancers may coapt (i.e. to bring together) sensory nerves and pain signalling mechanisms to facilitate its progression. |', 'dog', '', '', '疼痛管理,癌性疼痛,骨肿瘤疼痛,神经病理性疼痛,多模式镇痛,NSAIDs,适用场景,评估要点与机制,镇痛方案', 'informational', '癌性疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('癌性疼痛管理 · 镇痛方案', '3. 镇痛方案

原文说明：对癌痛机制的详尽理解未来才会形成专门推荐；当前推荐多药联合（multimodal drug approach）控制慢性癌痛，并推荐对任何非肿瘤性疼痛（如操作性疼痛、围手术期疼痛或其他慢性疼痛状态如骨关节炎 [osteoarthritis, OA]）进行恰当管理。

| 层级 | 原文用药（逐字） |
|---|---|
| 慢性癌痛基础用药 | In general, for chronic cancer pain, NSAIDs are recommended with the addition of opioids and adjunctive drugs (such as gabapentin) as needed. |
| 其他可能获益的方式 | Other modalities that can prove beneficial are bisphosphonates, chemotherapy, and radiotherapy. |
| 非药物疗法 | Non-drug therapies should be used concurrently. |
| 辅助疗法的定位 | Other forms of adjunctive therapy tend to improve quality of life in cancer patients, although it is not known if they directly induce analgesia. |

**剂量缺失说明**：本份指引原文未提供任何药物的 mg/kg 剂量、给药途径（IV/IM/SC/PO）与频次（TID/BID/SID），原文此处缺失；原文指示补充剂量信息见 WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）。

4. 监测与警示

- 原文未列出本场景的特定禁忌药物清单与监测指标，原文此处缺失。
- 需要识别并处理与肿瘤无关的疼痛来源：原文推荐 appropriate management of any non-cancer pain, such as procedure, perioperative pain or other chronic pain conditions such as osteoarthritis (OA)。
- 对口服镇痛药姑息治疗反应差（refractory）的骨肿瘤病例，原文将其作为典型难点提出（见「2. 评估要点与机制」）。
- 出院/长期居家管理的具体安排在原文中未展开，原文此处缺失。', '', '', '', '疼痛管理,癌性疼痛,骨肿瘤疼痛,神经病理性疼痛,多模式镇痛,NSAIDs,适用场景,评估要点与机制,镇痛方案', 'caution', '癌性疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('癌性疼痛管理 · 文献出处', '5. 文献出处

Monteiro, B.P., Lascelles, B.D.X., Murrell, J., Robertson, S., Steagall, P.V.M. and Wright, B. (2023), 2022 WSAVA guidelines for the recognition, assessment and treatment of pain. J Small Anim Pract, 64: 177-254. https://doi.org/10.1111/jsap.13566', '', '', '', '疼痛管理,癌性疼痛,骨肿瘤疼痛,神经病理性疼痛,多模式镇痛,NSAIDs,适用场景,评估要点与机制,镇痛方案', 'informational', '癌性疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 犬去势与卵巢子宫切除疼痛管理', '犬去势与卵巢子宫切除疼痛管理

本指引为分层（tiered）方案：并非所有镇痛方式（analgesic modalities）在各地区均可获得，实施时按可获得的药物与个体病例需要进行选择。

1. 适用场景

- 犬（Dogs）的去势术（Castration）与卵巢子宫切除/卵巢切除术（ovariohysterectomy/ovariectomy）。
- 原文：手术 associated with pain of varying severity and is influenced by the degree of surgical trauma（疼痛严重程度不一，并受手术创伤程度影响）。
- 因此手术应以细致的组织处理（careful tissue handling）并遵守良好的外科原则（adherence to good surgical principles）进行。
- General anaesthesia and preventive/multimodal analgesia techniques are strongly recommended（强烈推荐全身麻醉与预防性/多模式镇痛技术）。

2. 评估要点与总则

| 要点 | 原文内容（逐字） |
|---|---|
| 术后镇痛时长 | Postoperative treatment with analgesics may be required for up to 3 days after surgery especially after ovariohysterectomy/ovariectomy, or if laparotomy is required in males (e.g. a cryptorchid) to remove a testicle. |
| NSAIDs 使用原则 | The same NSAID should be used pre- and postoperatively. |
| 评分工具 | 本份指引原文未给出疼痛评分量表（如 GPAPS、SF 等），原文此处缺失。 |

3. 镇痛与麻醉方案', 'dog', '', '', '疼痛管理,犬去势,Castration,卵巢子宫切除,卵巢切除,多模式镇痛,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '犬去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration）', '3.1 去势术（Castration）

| 阶段 | 原文方案（逐字，含剂量与途径） |
|---|---|
| Preoperative — Analgesia | opioid |
| Preoperative — Sedation | Acepromazine and/or benzodiazepines (midazolam or diazepam 0.25–0.4 mg/kg IM; diazepam is best given IV – painful IM); alpha2 adrenoceptor agonist |
| Induction — Intravenous | Propofol to effect (3–5 mg/kg), ketamine (3–5 mg/kg) + diazepam or midazolam (0.25 mg/kg), or alfaxalone (1–2 mg/kg) |
| Induction — Intramuscular | Opioid + Alpha2 adrenoceptor agonist + ketamine (3–5 mg/kg) or tiletamine/zolazepam (3–4 mg/kg) |
| Maintenance of anaesthesia | Inhalation anaesthesia or propofol, alfaxalone or ketamine (1/3 or ½ of initial dose) to effect; venous access is recommended. Equipment should also be available for endotracheal intubation. |
| Local anaesthetic techniques | Intra-testicular block, incisional block with lidocaine. |
| Postoperative analgesia | NSAID. |

**无管制药物方案（Protocol without controlled drugs）**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Combination of a NSAID and an alpha2 adrenoceptor agonist)（原文末尾括号为排版残留） |
| Induction — Intravenous | Propofol to effect (3–5 mg/kg), ketamine (3–5 mg/kg) or alfaxalone (1–2 mg/kg) |
| Induction — Intramuscular | Alpha2 adrenoceptor agonist + tiletamine/zolazepam (3–4 mg/kg) |
| 其余 | Otherwise, same as above. |

**镇痛药物可及性受限方案（Protocol with limited availability of analgesic drugs）**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Alpha2 adrenoceptor agonist ± NSAID. |
| Induction and maintenance of anaesthesia | Any available injectable or inhalant agent; venous access is recommended. |
| 其余 | Otherwise, same as above. |', '', '', '', '疼痛管理,犬去势,Castration,卵巢子宫切除,卵巢切除,多模式镇痛,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '犬去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 卵巢子宫切除/卵巢切除术（Ovariohysterectomy/ovariect', '3.2 卵巢子宫切除/卵巢切除术（Ovariohysterectomy/ovariectomy）

| 阶段 | 原文方案（逐字，含剂量与途径） |
|---|---|
| Preoperative — Analgesia | Opioid |
| Preoperative — Sedation | Acepromazine and/or benzodiazepines or alpha2 adrenoceptor agonist |
| Induction — Intravenous | Propofol to effect (3–5 mg/kg), ketamine (3–5 mg/kg) + diazepam/midazolam (0.25 mg/kg) or alfaxalone (1–2 mg/kg) |
| Induction — Intramuscular | Opioid + Alpha2 adrenoceptor agonist + ketamine (5.0–7.5 mg/kg) or tiletamine/zolazepam (3–4 mg/kg) |
| Maintenance of anaesthesia | Inhalation anaesthesia, or propofol, alfaxolone（原文拼写）, ketamine (1/3 or ½ of initial dose) to effect; venous access is recommended. |
| Local anaesthetic techniques | Incisional and intraperitoneal/ovarium ligament block. |
| Postoperative analgesia | NSAID. |

**无管制药物方案**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Combination of a NSAID and an alpha2 adrenoceptor agonist + metamizole/Dypirone (20–50 mg/kg slow IV or deep IM). |
| Induction — Intravenous | Propofol to effect (3–5 mg/kg), ketamine (3–5 mg/kg) or alfaxalone (1–2 mg/kg) |
| Induction — Intramuscular | Alpha2 adrenoceptor agonist + tiletamine/zolazepam (3–4 mg/kg) |
| Postoperative analgesia | NSAID ± metamizole (dipyrone). |
| 其余 | Otherwise, same as above. |

**镇痛药物可及性受限方案**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Combination of a NSAID and an alpha2 adrenoceptor agonist + metamizole/Dypirone (20–50 mg/kg slow IV or deep IM). |
| Induction and maintenance of anaesthesia | Any available induction agent; venous access is recommended. |
| 其余 | Otherwise, same as above. |', '', '', '', '疼痛管理,犬去势,Castration,卵巢子宫切除,卵巢切除,多模式镇痛,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '犬去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('犬去势与卵巢子宫切除/卵巢切除疼痛管理 · 监测与出院辅助', '4. 监测与出院辅助

- 非药物补充（原文逐字）：Analgesia may be supplemented after most surgical techniques by application of non-drug modalities such as cold therapy, photobiomodulation therapy, acupuncture, mild exercise, nursing care and massage.
- 静脉通路（venous access）在维持期方案中被反复推荐；应备好气管插管（endotracheal intubation）设备。
- 术后镇痛需求最长可达 3 天（见「2. 评估要点与总则」），据此安排复诊与居家给药。
- 具体 NSAID 药名与 mg/kg 剂量、以及出院带药清单在原文中未列出，原文此处缺失；原文指示详见 WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）。', '', '', '', '疼痛管理,犬去势,Castration,卵巢子宫切除,卵巢切除,多模式镇痛,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '犬去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 猫去势与卵巢子宫切除疼痛管理', '猫去势与卵巢子宫切除疼痛管理

本指引为分层（tiered）方案：并非所有镇痛方式（analgesic modalities）在各地区均可获得，实施时按可获得的药物与个体病例需要进行选择。

1. 适用场景

- 猫（Cats）的去势术（Castration）与卵巢子宫切除/卵巢切除术（ovariohysterectomy/ovariectomy）。
- 原文：手术 associated with pain of varying severity and is influenced by the degree of surgical trauma（疼痛严重程度不一，受手术创伤程度影响）；因此应以细致的组织处理（careful tissue handling）并遵守良好的外科原则进行。
- General anaesthesia and preventive/multimodal analgesia techniques are strongly recommended（强烈推荐全身麻醉与预防性/多模式镇痛技术）。

2. 评估要点与总则

| 要点 | 原文内容（逐字） |
|---|---|
| 术后镇痛时长 | Postoperative treatment with analgesics may be required for up to 3 days after surgery especially after ovariohysterectomy/ovariectomy, or if laparotomy is required in males (e.g. a cryptorchid) to remove a testicle. |
| NSAIDs 使用原则 | The same NSAID should be used pre- and postoperatively. |
| 保定/应激相关 | 猫的术前用药剂量按耐受度选择：the higher doses are selected for cats that are more dicult to handle（原文拼写，应为 difficult）。 |
| 评分工具 | 本份指引原文未给出疼痛评分量表，原文此处缺失。 |

3. 镇痛与麻醉方案', 'cat', '', '', '疼痛管理,猫去势,Castration,卵巢子宫切除,卵巢切除,神经镇痛复合,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '猫去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration）', '3.1 去势术（Castration）', '', '', '', '疼痛管理,猫去势,Castration,卵巢子宫切除,卵巢切除,神经镇痛复合,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '猫去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration） (2)', '| 阶段 | 原文方案（逐字，含剂量与途径） |
|---|---|
| Preoperative | Neuroleptanalgesia（神经镇痛复合用药）to include opioid + acepromazine (0.01–0.05 mg/kg) OR alpha2 +/– ketamine (5–10 mg/kg IM: the higher doses are selected for cats that are more dicult to handle). |
| 诱导可免全麻的说明 | In some cats an opioid, an alpha2 adrenoceptor agonist and ketamine will provide sufficient analgesia and anaesthesia for a castration. |
| Induction — Intravenous | Propofol to effect (3–10 mg/kg), ketamine (3–5 mg/kg) + diazepam or midazolam (0.25 mg/kg), or alfaxalone (3–5 mg/kg). Note: if an alpha2 adrenoceptor agonist has been used preoperatively these doses may be lower. |
| Induction — Intramuscular | An alpha2 adrenoceptor agonist + ketamine (5–10 mg/kg) or tiletamine/zolazepam (3–4 mg/kg). |
| Maintenance of anaesthesia | Inhalation anaesthesia or ketamine or propofol or alfaxalone IV to effect. Note: in many cases a castration can be completed without the need for maintenance anaesthesia drugs; however, there should be a plan for extending the anaesthesia time in the event the cat becomes responsive or complications arise. Equipment should also be available for endotracheal intubation. |
| Local anaesthetic techniques | Intra-testicular block and pre- and/or post-surgery skin infiltration with lidocaine. |
| Postoperative analgesia | NSAID. |', 'cat', '', '', '疼痛管理,猫去势,Castration,卵巢子宫切除,卵巢切除,神经镇痛复合,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '猫去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 去势术（Castration） (3)', '**无管制药物方案（Protocol without controlled drugs）**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | combination of a NSAID and an alpha2 adrenoceptor agonist. |
| Induction — Intravenous | Propofol to effect (3–10 mg/kg) or alfaxalone (3–5 mg/kg). |
| Induction — Intramuscular | An alpha2 adrenoceptor agonist + ketamine (5–10 mg/kg) or tiletamine/zolazepam (3–4 mg/kg). |
| 其余 | Otherwise, same as above. |

**镇痛药物可及性受限方案（Protocol with limited availability of analgesic drugs）**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Alpha2 adrenoceptor agonist ± NSAID. |
| Induction and maintenance of anaesthesia | Any available induction agents; injectable or inhalant. |
| 其余 | Otherwise, same as above. |', '', '', '', '疼痛管理,猫去势,Castration,卵巢子宫切除,卵巢切除,神经镇痛复合,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '猫去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 卵巢子宫切除/卵巢切除术（Ovariohysterectomy/ovariect', '3.2 卵巢子宫切除/卵巢切除术（Ovariohysterectomy/ovariectomy）

| 阶段 | 原文方案（逐字，含剂量与途径） |
|---|---|
| Preoperative | Neuroleptanalgesia to include opioid + acepromazine (0.01–0.05 mg/kg) OR alpha2 +/– ketamine (5–10 mg/kg IM: the higher doses are selected for cats that are more difficult to handle). |
| Induction — Intravenous | Propofol to effect (3–10 mg/kg), ketamine (3–5 mg/kg) + diazepam or midazolam (0.25 mg/kg), or alfaxalone (3–5 mg/kg). Note: if an alpha2 adrenoceptor agonist has been used preoperatively these doses may be lower. |
| Induction — Intramuscular | An alpha2 adrenoceptor agonist + ketamine (5–10 mg/kg) or tiletamine/zolazepam (3–4 mg/kg). |
| Maintenance of anaesthesia | Inhalation anaesthesia or ketamine or propofol or alfaxalone IV to effect (1/3 or 1/2 of initial dose). Note: in many cases an ovariohysterectomy or ovariectomy can be completed without the need for maintenance anaesthesia drugs; however, there should be a plan for extending the anaesthesia time in the event the cat becomes responsive or complications arise; venous access is recommended. |
| Local anaesthetic techniques | Incisional and intraperitoneal/ovarium ligament block with lidocaine. |
| Postoperative analgesia | NSAID. |

**无管制药物方案**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Combination of a NSAID and an alpha2 adrenoceptor agonist. |
| Induction — Intravenous | Propofol to effect (3–10 mg/kg) or or（原文重复） alfaxalone (3–5 mg/kg). |
| Induction — Intramuscular | An alpha2 adrenoceptor agonist + ketamine (5–10 mg/kg) or tiletamine/zolazepam (3–4 mg/kg). |
| 其余 | Otherwise, same as above. |

**镇痛药物可及性受限方案**

| 阶段 | 原文方案 |
|---|---|
| Preoperative | Alpha2 adrenoceptor agonist ± NSAID. |
| Induction and maintenance of anaesthesia | Any available induction agents; injectable or inhalant. |
| 其余 | Otherwise, same as above. |', 'cat', '', '', '疼痛管理,猫去势,Castration,卵巢子宫切除,卵巢切除,神经镇痛复合,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '猫去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('猫去势与卵巢子宫切除/卵巢切除疼痛管理 · 监测与出院辅助', '4. 监测与出院辅助

- 非药物补充（原文逐字）：Analgesia may be supplemented after most surgical techniques by application of non-drug modalities such as cold therapy, photobiomodulation therapy, acupuncture, nursing care, mild exercise and massage。
- 原文反复强调：即使多数猫绝育可在不使用维持麻醉药的情况下完成，也必须具备延长麻醉时间的预案（plan for extending the anaesthesia time），并备好气管插管设备（endotracheal intubation）。
- 具体 NSAID 药名、mg/kg 剂量与出院带药方案在原文中未列出，原文此处缺失；详见 WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）。', 'cat', '', '', '疼痛管理,猫去势,Castration,卵巢子宫切除,卵巢切除,神经镇痛复合,适用场景,评估要点与总则,镇痛与麻醉方案', 'informational', '猫去势与卵巢子宫切除/卵巢切除疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('退行性关节病 · 第 1 段', '退行性关节病疼痛管理

版权与版本说明（原文逐字）：© World Small Animal Veterinary Association. Adapted from Mathews K, et al. Guidelines for recognition, assessment and treatment of pain. Journal of Small Animal Practice 2014; 55: E10–E68 and produced by The British Small Animal Veterinary Association. See full text for further information. 本份为 GPC Pain Management Protocol 系列的单页海报，属较早版本。

1. 适用场景

- 退行性关节病（Degenerative joint disease, DJD），以及与骨关节炎（osteoarthritis, OA）相关的疼痛与功能障碍。
- 原文：The management（原文抽取为 "Te management"）of DJD has grown in complexity in the past decade, and there are many recommendations for treatment of the pain and dysfunction associated with this disease.
- 分层（tiered）方案声明：并非所有镇痛方式（analgesic modalities）在各地区均可获得。', '', '', '', '疼痛管理,退行性关节病,DJD,骨关节炎,体重管理,NSAIDs,适用场景,评估要点,镇痛方案', 'informational', '退行性关节病（DJD）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('退行性关节病 · 评估要点', '2. 评估要点

| 要点 | 原文内容（逐字/直译保留术语） |
|---|---|
| 不是单一问题 | it should be remembered that DJD in any patient is not a single ''type'' of problem. |
| 生命周期差异 | it is now becoming recognized that DJD presents differently（原文抽取为 "diﬀerently"）in the growing, versus middle-aged, versus older cat or dog. DJD presenting at different ''life-stages'' requires different approaches to optimize care. |
| 生长期犬举例 | in the growing dog surgical intervention may be a first line treatment in an attempt to limit the disease progression and the likelihood of pain in the future. |
| 治疗目标 | Regardless of the stage of disease or the treatments selected, the veterinarian should aim to maximize the benefit（原文抽取为 "beneﬁt"）and minimize the risks associated with managing this disease. |
| 主要治疗支柱 | The mainstays of treatment involve methods to alleviate pain, and at all stages NSAIDs are the most predictable analgesics. |
| 证据权重最高项 | Currently, the greatest weight of evidence for efficacy is for weight management, NSAIDs, dietary optimization (amount and content), and exercise. |

3. 镇痛方案

原文将猫与犬 OA 疼痛的治疗按三大类归纳（Drugs 类下的具体药名逐字照抄；本份指引未给出任何 mg/kg 剂量、给药途径与频次，原文此处缺失）。', '', '', '', '疼痛管理,退行性关节病,DJD,骨关节炎,体重管理,NSAIDs,适用场景,评估要点,镇痛方案', 'informational', '退行性关节病（DJD）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('退行性关节病 · 非手术、非药物治疗（Non-surgery, non-drug treatmen', '3.1 非手术、非药物治疗（Non-surgery, non-drug treatment）

| 项目 |
|---|
| Weight management |
| Diet modulation (type; amount) |
| Exercise |
| Physical rehabilitation and physical modalities |
| Environmental modification |
| Nutritional supplements |
| Acupuncture |

3.2 药物治疗（Drugs）

| 类别 | 原文药物（逐字） |
|---|---|
| ''Base'' analgesics（基础镇痛药） | NSAIDs；Paracetamol (acetaminophen) (not in cats)；Corticosteroids (treating the underlying immune-mediated disease resulting in polyarthritis) |
| Adjunctive analgesics（辅助镇痛药） | e.g. tramadol, amantadine, gabapentin, tricyclic antidepressants |
| Postulated disease modifying drugs（推测的疾病改良药） | e.g. polysulfated glycosaminoglycan |
| Neuroablative procedures（神经毁损性操作） | 原文仅列类别名，未展开具体术式 |

3.3 手术治疗（Surgery）

| 项目 |
|---|
| Joint replacement (hip, elbow, knee) |
| Excision arthroplasty |
| Arthrodesis |
| Joint dennervation（原文拼写） |
| Stem cell therapies |', 'cat', '', '', '疼痛管理,退行性关节病,DJD,骨关节炎,体重管理,NSAIDs,适用场景,评估要点,镇痛方案', 'informational', '退行性关节病（DJD）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('退行性关节病 · 原文前段列举的其他推荐手段（逐字）', '3.4 原文前段列举的其他推荐手段（逐字）

surgical intervention；systemic analgesic therapy (NSAIDs, paracetamol [acetaminophen] [not in cats], corticosteroids)；local pharmacologic therapy (transcutaneous; intra-articular)；home-based exercises；clinic-based therapeutic exercises；weight optimization；nutritional supplementation；massage；acupuncture；laser therapy；heat/cold therapy；neuromuscular electrical stimulation；transcutaneous electrical stimulation；joint mobilization。原文注明这些推荐 include, but are not limited to 上述内容。

4. 警示与监测

- 对乙酰氨基酚警示（原文逐字）：Paracetamol (acetaminophen) (**not in cats**) —— 猫禁用。
- 糖皮质激素的定位（原文逐字）：Corticosteroids (treating the underlying immune-mediated disease resulting in polyarthritis)，即用于导致多关节炎的潜在免疫介导性疾病。
- 各阶段 NSAIDs 均为最可预期的镇痛药（NSAIDs are the most predictable analgesics），故应作为疼痛缓解的主要支柱；但本份原文未提供 NSAID 具体药物、剂量与疗程，原文此处缺失。
- 长期随访与复诊安排在原文中未展开，原文此处缺失；补充剂量信息原文指向 WSAVA GPC Treatise 的 dosing tables（www.wsava.org）。

5. 抽取质量提示

本份原文共 1 页，抽取文本存在连字/首字母丢失（"Te"、"Tese"、"diﬀerently"、"beneﬁt"），且正文结束后出现重复标题 "## Degenerative joint disease"，未包含其他各份均有的 Monteiro et al. (2023) 引用条目，疑似原文版脚部信息缺失。', 'cat', '', '', '疼痛管理,退行性关节病,DJD,骨关节炎,体重管理,NSAIDs,适用场景,评估要点,镇痛方案', 'caution', '退行性关节病（DJD）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('急诊与重症 · 第 1 段', '急诊与重症疼痛管理

本指引为分层（tiered）方案：并非所有镇痛方式（analgesic modalities）在各地区均可获得，实施时按可获得的药物与个体病例需要进行选择。

1. 适用场景

- 受伤或患病动物（Injured or ill animals）需要为疼痛性疾病、以及诊断性与急诊操作（diagnostic and emergency procedures）提供镇痛。
- 重症监护单元（intensive care unit, ICU）中的即时镇痛：原文指出 Due to their safety, opioids are the mainstay of immediate analgesia in the intensive care unit (ICU), and most also provide some degree of sedation, which may facilitate restraint for procedures and diagnostics（因安全性好，阿片类是 ICU 即时镇痛的主力，且多数兼有程度不等的镇静作用，有助于操作与检查时的保定）。原文并提示参见 Guidelines 的 Chapter 2.2。', '', '', '', '疼痛管理,急诊与重症,ICU,阿片类,opioids,滴定至有效剂量,适用场景,评估要点,镇痛方案', 'caution', '急诊与重症（Emergency and critical care）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('急诊与重症 · 评估要点', '2. 评估要点

| 要点 | 原文内容（逐字） |
|---|---|
| 静脉通路 | Intravenous access should be achieved as soon as possible so that volume deficits can be corrected, and additional analgesics and sedatives can be titrated to effect. |
| 药物选择倾向 | In general, short-acting opioids are preferred, and titrated to an effective dose. |
| 滴定方法 | by starting with 10-20% of the recommended dose, and incrementally increasing until establishing a positive response (i.e. pain relief) while avoiding adverse effects. |
| 输注衔接 | A CRI（constant rate infusion，恒速输注）can be started afterwards and adjusted as the patient is stabilised and frequently assessed. |
| 输注速率调整依据 | The CRI rates should be adjusted based upon pain assessment, patient tolerance, and response; for example, rates can be increased for break-through pain, and decreased if the patient becomes heavily sedated and difficult to arouse. |', '', '', '', '疼痛管理,急诊与重症,ICU,阿片类,opioids,滴定至有效剂量,适用场景,评估要点,镇痛方案', 'informational', '急诊与重症（Emergency and critical care）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('急诊与重症 · 镇痛方案', '3. 镇痛方案

本份原文未提供任何药物的 mg/kg 剂量、具体给药途径与频次（TID/BID/SID），原文此处缺失；以下为原文对各类药物的定位与使用方式（逐字照抄）。

| 药物类别 | 原文用法与定位 |
|---|---|
| Opioids（阿片类） | mainstay of immediate analgesia in the ICU; short-acting opioids are preferred, titrated to an effective dose by starting with 10-20% of the recommended dose; a CRI can be started afterwards. |
| NMDA antagonists（NMDA 拮抗剂），如 ketamine | NMDA antagonists such as ketamine may prevent or treat central sensitisation particularly in cases of invasive and severe pain involving a neuropathic component. Ketamine infusions can be started concurrently or after opioid therapy. The drug must be administered as an infusion as boluses are short-acting and more likely to induce behavioural changes. |
| Lidocaine（利多卡因） | In dogs and cats, lidocaine may also be given IV (loading dose and infusion), but lidocaine infusions should be used cautiously in cats due to the risk of haemodynamic compromise. |
| NSAIDs（非甾体抗炎药） | Non-steroidal anti-inflammatory medications can be valuable in emergency and critical care situations, but should be withheld until volume, cardiovascular and renal status are stabilised, and with diseases that do not involve the gastro-intestinal system. When not contra-indicated, the anti-inflammatory effects of NSAIDs can be valuable for decreasing secondary inflammatory cascades. |
| Low-dose alpha2-adrenoceptor agonists | low-dose alpha2-adrenoceptor agonists (dexmedetomidine, medetomidine) can be part of multimodal analgesia and provide sedation and muscle relaxation. |
| 应激/恐惧/焦虑管理药物 | Managing stress, fear and anxiety are also an important consideration in critically ill, hospitalised cases and can be addressed with medications (e.g. trazodone, acepromazine or gabapentin), nursing care, and low-stress handling techniques. |', '', '', '', '疼痛管理,急诊与重症,ICU,阿片类,opioids,滴定至有效剂量,适用场景,评估要点,镇痛方案', 'informational', '急诊与重症（Emergency and critical care）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('急诊与重症 · 监测与警示', '4. 监测与警示

| 警示项 | 原文内容（逐字） |
|---|---|
| 猫利多卡因输注 | lidocaine infusions should be used cautiously in cats due to the risk of haemodynamic compromise. |
| 氯胺酮给药形式 | The drug must be administered as an infusion as boluses are short-acting and more likely to induce behavioural changes. |
| NSAIDs 使用时机 | should be withheld until volume, cardiovascular and renal status are stabilised, and with diseases that do not involve the gastro-intestinal system. |
| 镇静过度 | CRI rates ... decreased if the patient becomes heavily sedated and difficult to arouse. |
| 突破性疼痛 | rates can be increased for break-through pain. |
| 评估频次 | 患者稳定过程中需 frequently assessed（频繁评估）；原文未给出具体评分量表名称，原文此处缺失。 |

5. 出院与随访

原文仅覆盖急诊与 ICU 住院期管理，未包含出院标准、居家镇痛方案与复诊安排，原文此处缺失；补充剂量信息原文指向 WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）。', 'cat', '', '', '疼痛管理,急诊与重症,ICU,阿片类,opioids,滴定至有效剂量,适用场景,评估要点,镇痛方案', 'caution', '急诊与重症（Emergency and critical care）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('内科疾病疼痛 · 内科疾病疼痛管理', '内科疾病疼痛管理

本指引为分层（tiered）方案：并非所有镇痛方式（analgesic modalities）在各地区均可获得，实施时按可获得的药物与个体病例需要进行选择。

1. 适用场景

- 定义（原文逐字）：The term "medical pain" encompasses conditions not primarily associated with surgery or trauma.（"内科疼痛"涵盖并非主要由手术或创伤引起的疾病状态。）
- 内脏痛（visceral pain）：Abdominal, pelvic and thoracic visceral pain occurs in conditions associated with distension and/or inflammation of hollow organs, ischaemia, pulmonary thrombosis, acute enlargement of solid organs resulting in stretching of the capsule and inflammation of any organ (e.g. pancreatitis, acute kidney injury, pneumonia/pleuritis).
- 内脏痛特点：Visceral pain tends to be diffuse in nature and difficult to localise.', '', '', '', '疼痛管理,内科疼痛,内脏痛,多模式镇痛,μ 激动剂,opioids,适用场景,评估要点,镇痛方案', 'informational', '内科疾病疼痛（Medical pain）管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('内科疾病疼痛 · 评估要点', '2. 评估要点

| 要点 | 原文内容（逐字） |
|---|---|
| 治疗目标 | The goal of therapy is to treat the underlying medical problem, but analgesics are often required prior to a definitive diagnosis and during treatment. |
| 疼痛分级 | 原文按 Severe pain / Moderate pain / Mild to moderate pain 三档给出推荐方案（原文 "Moderate pian:" 为拼写误差）。重度疼痛请参见 full Guidelines 的 section 3.9（Refer section 3.9 of the full Guidelines）。 |
| 一线药物 | Opioids are the first-choice drugs in many emergency and critically ill patients. |
| 给药通路 | Frequent IM or SC injections are painful and stressful and should be avoided, when possible, therefore a catheter is recommended for IV injections. |

3. 镇痛方案

3.1 伴随治疗（Adjunctive therapies，可在任何疼痛级别按需使用）

| 项目 | 原文内容（逐字） |
|---|---|
| 止吐/止恶 | Antiemetic and anti-nausea drugs |
| 针灸 | Acupuncture can be useful for pain, gastrointestinal and urinary cases in particular and also vomiting. |
| 物理与护理 | Medical massage, cold therapy and warm compress are recommended where indicated. |
| 环境与信息素 | Environmental enhancement and pheromone therapy to reduce stress and anxiety. |', '', '', '', '疼痛管理,内科疼痛,内脏痛,多模式镇痛,μ 激动剂,opioids,适用场景,评估要点,镇痛方案', 'informational', '内科疾病疼痛（Medical pain）管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('内科疾病疼痛 · 重度疼痛（Severe pain）', '3.2 重度疼痛（Severe pain）

| 方案 | 原文内容（逐字） |
|---|---|
| μ 激动型阿片 | 𝜇 agonist opioids can be titrated to effect. Opioids that cause vomiting (e.g. morphine or hydromorphone) are best avoided. Opioid infusions are recommended. |
| NSAIDs | NSAIDs, when patients are haemodynamically stable with no contraindications; these can be combined with opioid therapy. |
| 局部区域麻醉 | Locoregional anaesthetic techniques. |
| 恒速输注 | Ketamine and/or lidocaine CRI (lidocaine should be used cautiously in cats due to the risk of haemodynamic compromise). |
| 腔内阻滞 | Intrapleural and intraperitoneal blocks for somatic and visceral pain, respectively. |', 'cat', '', '', '疼痛管理,内科疼痛,内脏痛,多模式镇痛,μ 激动剂,opioids,适用场景,评估要点,镇痛方案', 'informational', '内科疾病疼痛（Medical pain）管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('内科疾病疼痛 · 中度疼痛（Moderate pain）', '3.3 中度疼痛（Moderate pain）

| 方案 | 原文内容（逐字） |
|---|---|
| μ 激动型阿片 | 𝜇 agonist opioid as described for severe pain. Frequent IM or SC injections are painful and stressful and should be avoided, when possible, therefore a catheter is recommended for IV injections. |
| NSAIDs | NSAID when patients are haemodynamically stable with no contraindications; these can be combined with opioid therapy. |
| 恒速输注 | Ketamine and/or lidocaine CRI (lidocaine should be used cautiously in cats due to the risk of haemodynamic compromise). |
| 丁丙诺啡 | Buprenorphine as part of multimodal analgesia. |', 'cat', '', '', '疼痛管理,内科疼痛,内脏痛,多模式镇痛,μ 激动剂,opioids,适用场景,评估要点,镇痛方案', 'informational', '内科疾病疼痛（Medical pain）管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('内科疾病疼痛 · 轻度至中度疼痛（Mild to moderate pain）', '3.4 轻度至中度疼痛（Mild to moderate pain）

| 方案 | 原文内容（逐字，含剂量/途径/频次） |
|---|---|
| NSAID ± 丁丙诺啡 | NSAID of choice (if no contraindications) ± buprenorphine (OTM is suitable for home settings). |
| Gabapentin | Gabapentin 10 mg/kg PO every 8 hours for dogs, or every 12 hours for cats may be of benefit, although there is little published evidence to support its use in acute pain. Gabapentinoids are better administered for naturally occurring medical, chronic pain with a neuropathic component. |
| 口腔溃疡痛含漱 | Mouth wash solutions for alleviating oral mucositis pain. Gently rinse or flush oral cavity using a syringe containing one of the following. |
| 含漱配方 1 | Lidocaine 2% viscous solution mixed in a 1:1:1 ratio with magnesium/aluminium hydroxide and diphenhydramine: maximum dose 0.4 mL/kg every 8 hours. |
| 含漱配方 2 | Green Tea flushes can be used in the mouth or on wounds. |

**剂量缺失说明**：除 gabapentin 与含漱用 lidocaine 2% 外，本份原文未提供阿片类、NSAIDs、ketamine、lidocaine CRI 与 buprenorphine 的 mg/kg 剂量、输注速率与给药频次，原文此处缺失；原文指示详见 WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）。', '', '', '', '疼痛管理,内科疼痛,内脏痛,多模式镇痛,μ 激动剂,opioids,适用场景,评估要点,镇痛方案', 'informational', '内科疾病疼痛（Medical pain）管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('内科疾病疼痛 · 监测与警示', '4. 监测与警示

| 警示项 | 原文内容（逐字） |
|---|---|
| 致呕阿片 | Opioids that cause vomiting (e.g. morphine or hydromorphone) are best avoided. |
| NSAIDs 前提 | 必须在 patients are haemodynamically stable with no contraindications 时使用；可与阿片治疗联合。 |
| 猫利多卡因 | lidocaine should be used cautiously in cats due to the risk of haemodynamic compromise. |
| 反复肌注/皮下注射 | Frequent IM or SC injections are painful and stressful and should be avoided, when possible. |
| 加巴喷丁证据 | there is little published evidence to support its use in acute pain；加巴喷丁类更适合用于伴神经病理性成分的天然发生内科性慢性疼痛。 |
| 含漱给药 | 含漱液须用注射器轻柔冲洗口腔（Gently rinse or flush oral cavity），并遵守 maximum dose 0.4 mL/kg every 8 hours 的上限。 |
| 出院/居家 | 原文仅指出 buprenorphine 的 OTM 剂型适合居家场景（OTM is suitable for home settings），其余出院与随访安排未展开，原文此处缺失。 |', 'cat', '', '', '疼痛管理,内科疼痛,内脏痛,多模式镇痛,μ 激动剂,opioids,适用场景,评估要点,镇痛方案', 'informational', '内科疾病疼痛（Medical pain）管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('神经病理性疼痛处理方案 · 第 1 段', '神经病理性疼痛处理方案

1. 文件定位与使用原则

1.1 分层（tiered）全球适用原则

原文开篇声明：以下疼痛管理方案按**分层（tiered）**方式编排，以保证全球适用性，并承认并非所有镇痛手段（analgesic modalities）都可为兽医从业者获得、且在世界各地因地区而异；方案的实施将取决于可获得的镇痛手段以及需要治疗的个体患者的需求。

1.2 出处与原文获取

- 本方案转载（reproduced）自 WSAVA Pain Committee guidelines，该指南是犬猫疼痛评估、各类疼痛形式及多种临床疼痛场景治疗的简明而全面的综述，发表于 *Journal of Small Animal Practice*，可在 www.wsava.org 的 Pain Committee 页面开放获取。
- 原文 PDF：`https://wsava.org/wp-content/uploads/2024/08/Neuropathic-pain-protocol.pdf`（1 页）。
- 原文页脚提示：**更多药物剂量信息见 www.wsava.org 上 WSAVA Pain Committee Treatise 的剂量表（dosing tables）**。本海报正文只给出个别静脉药物的剂量，其余辅助镇痛药剂量见第 5 节缺失说明。', '', '', '', '疼痛管理,神经病理性疼痛,加巴喷丁类,gabapentin,pregabalin,amantadine,文件定位与使用原则,总论：神经病理性疼痛的处理依据', 'informational', '神经病理性疼痛处理方案', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('神经病理性疼痛处理方案 · 总论：神经病理性疼痛的处理依据', '2. 总论：神经病理性疼痛的处理依据

神经病理性疼痛（Neuropathic pain）按原文表述"经典地难以治疗（classically difficult to treat）"，其推荐依据来自人医文献（human literature）以及来自兽医医学的不断增加的证据体系。

| 手段类别 | 原文表述（照抄关键要素） | 本稿说明 |
|---|---|---|
| 加巴喷丁类（Gabapentinoids）：gabapentin 或 pregabalin | 已被用作一线治疗（first line of treatment），在 QoL 上有显著改善 | QoL 缩写原文未展开 |
| 非甾体抗炎药（Non-steroidal anti-inflammatory drugs, NSAIDs） | 当同时怀疑炎症性疾病时，与加巴喷丁类联合使用 | — |
| NMDA 受体拮抗剂（Antagonists of NMDA receptors），即 amantadine | 也用于治疗对单独 NSAID 治疗无效（refractory to NSAID treatment alone）的 OA 犬，提示这些病例存在神经病理性疼痛的潜在成分 | OA 缩写原文未展开 |
| 抗神经生长因子单克隆抗体（anti-NGF mAbs） | 其在神经病理性疼痛中的作用**尚未被研究（has not been investigated）**，但可能存在获益 | 原文不作推荐 |
| 阿片类（Opioids） | **警示原文：阿片类可能通过神经炎症（neuroinflammation）与胶质细胞放大（glial amplification）加重慢性神经病理性疼痛（may exacerbate chronic neuropathic pain）** | 属禁忌/风险表述 |
| 物理手段（physical modalities） | 多种针对肌筋膜源性（myofascial origin）神经病理性疼痛的物理手段：use of heat and cold therapy、acupuncture、trigger point needling、stretching、massage and exercise；**所有这些手段在兽医医学中都需要进一步研究** | 逐字保留项目 |

3. 慢性神经病理性疼痛（Chronic Neuropathic Pain）', 'dog', '', '', '疼痛管理,神经病理性疼痛,加巴喷丁类,gabapentin,pregabalin,amantadine,文件定位与使用原则,总论：神经病理性疼痛的处理依据', 'caution', '神经病理性疼痛处理方案', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('神经病理性疼痛处理方案 · 原文列举的病症', '3.1 原文列举的病症

原文列举的神经病理性疼痛状态包括：椎间盘疾病（intervertebral disc disease）、截肢或开胸术后慢性疼痛（chronic postoperative pain following amputation or thoracotomy）、Chiari 样畸形（Chiari-like malformation）、空洞性脊髓病变（syringomyelia）、糖尿病神经病变（diabetic neuropathy）、口面部疼痛综合征（orofacial pain syndrome）、FHS（原文未展开该缩写）等（among others）。

3.2 治疗策略

| 要点 | 原文表述 |
|---|---|
| 多模式镇痛 | 对这类患者，多模式镇痛（multimodal analgesia）可能提供最大获益 |
| 试错法 | 可能需要基于**试错（trial-and-error）**的方式来确定某患者的最佳治疗 |
| 非药物技术 | **非药物技术应被纳入神经病理性疼痛状态的治疗中（Non-pharmacologic techniques should be included）** |
| 起始组合 | 犬和猫的药物学治疗可以用**一种 NSAID 与下列一种或多种辅助镇痛药（adjuvant analgesics）的组合**起始：gabapentin、pregabalin、amantadine 和 amitriptyline |
| 方案调整与疗程 | 最终治疗组合以及治疗持续的时长，将基于**患者反应与不良反应（patient response and adverse effects）**决定 |
| 减量 | 镇痛药的给药方案有时可以在监测下缓慢减量（slowly tapered down），以确保疼痛征象不再复现（do not re-emerge） |', '', '', '', '疼痛管理,神经病理性疼痛,加巴喷丁类,gabapentin,pregabalin,amantadine,文件定位与使用原则,总论：神经病理性疼痛的处理依据', 'informational', '神经病理性疼痛处理方案', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('神经病理性疼痛处理方案 · 药物剂量表', '3.3 药物剂量表

| 药物（English） | 剂量（mg/kg） | 给药途径 | 频次 | 时长 | 原文警示 |
|---|---|---|---|---|---|
| gabapentin | 原文此处缺失 | 原文此处缺失 | 原文此处缺失 | 基于患者反应与不良反应决定 | 与 NSAID 组合起始 |
| pregabalin | 原文此处缺失 | 原文此处缺失 | 原文此处缺失 | 同上 | 同上 |
| amantadine | 原文此处缺失 | 原文此处缺失 | 原文此处缺失 | 同上 | 用于 NSAID 单药无效的 OA 犬 |
| amitriptyline | 原文此处缺失 | 原文此处缺失 | 原文此处缺失 | 同上 | 同上 |
| NSAID（未指定药物） | 原文此处缺失 | 原文此处缺失 | 原文此处缺失 | 同上 | 怀疑炎症成分时与加巴喷丁类联用 |

4. 急性加重的慢性神经性疼痛（Acute on Chronic Neurological Pain）

4.1 住院指征

原文：犬和猫出现**痛觉过敏（hyperalgesia）与异常性疼痛（allodynia）的重度临床征象**时，可能需要住院（hospitalisation），以实施神经调控技术（neuro-modifying techniques）。

4.2 可实施的神经调控与静脉镇痛（剂量逐字照抄）

| 手段 / 药物 | 原文剂量与途径 | 频次/时长 | 原文警示语 |
|---|---|---|---|
| 局部麻醉药阻滞（local anaesthetic blocks） | 原文此处缺失（仅提及技术名称） | 原文此处缺失 | — |
| lidocaine 静脉给药 | `1 mg/kg bolus with 30 µg/kg/minute CRI` | CRI 持续，直至临床征象改善 | `use with caution in cats` |
| ketamine 静脉给药 | `bolus of 0.5-1 mg/kg followed by a CRI of 2-10 µg/kg/minute` | CRI 持续，直至临床征象改善 | — |
| 全身性阿片类（systemic opioids） | 原文此处缺失 | 原文此处缺失 | 与上述静脉镇痛药**联合**使用，直到临床征象改善（until clinical signs have improved） |', '', '', '', '疼痛管理,神经病理性疼痛,加巴喷丁类,gabapentin,pregabalin,amantadine,文件定位与使用原则,总论：神经病理性疼痛的处理依据', 'informational', '神经病理性疼痛处理方案', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('神经病理性疼痛处理方案 · 原文缺失项登记', '5. 原文缺失项登记

- 本海报对 gabapentin、pregabalin、amantadine、amitriptyline、各 NSAID 与阿片类**均未给出剂量、途径与频次**，原文此处缺失；原文统一指向 WSAVA Pain Committee Treatise 剂量表。
- 原文未列出疼痛评估量表名称，未给出猫/犬的具体病症分层，原文此处缺失。
- QoL、OA、FHS、CRI、IV 等缩写在原文中未展开（CRI、IV 按常规理解为恒速输注与静脉注射，本稿不作内容补充）。
- anti-NGF mAbs 的具体药物名称原文未列出，原文此处缺失。', '', '', '', '疼痛管理,神经病理性疼痛,加巴喷丁类,gabapentin,pregabalin,amantadine,文件定位与使用原则,总论：神经病理性疼痛的处理依据', 'informational', '神经病理性疼痛处理方案', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('骨科手术疼痛管理 · 第 1 段', '骨科手术疼痛管理

1. 总则与全球分层原则

1.1 分层原则与出处

原文声明本方案按**分层（tiered）**方式编排以保证全球适用性，承认并非所有镇痛手段（analgesic modalities）都可为兽医从业者获得且各地区不同；实施取决于可获得的镇痛手段与个体患者需求。方案转载（reproduced）自 WSAVA Pain Committee guidelines，发表于 *Journal of Small Animal Practice*，可在 www.wsava.org 的 Pain Committee 页面开放获取。原文 PDF：`https://wsava.org/wp-content/uploads/2024/08/Orthopedic-surgery.pdf`（2 页）。

1.2 骨科手术的疼痛性质与麻醉要求

| 要点 | 原文表述 |
|---|---|
| 疼痛强度 | 骨科手术（Orthopaedic surgery）有导致**中度至重度术后疼痛**的潜能 |
| 麻醉要求 | 手术应在**全身麻醉（general anaesthesia）联合积极的围手术期镇痛（aggressive perioperative analgesia）**下实施 |
| 技术原则 | **预防性（Preventive）与多模式（multimodal）镇痛技术应用于所有手术** |
| 平衡依据 | 术前、术中、术后镇痛的平衡取决于术前疾病严重程度、手术创伤的位置与大小以及患者状态 |
| 评估要求 | 应频繁进行疼痛评估（Frequent pain assessment）；疼痛未被成功控制时，应采用替代或额外的镇痛药或镇痛技术以改善患者舒适度 |
| 出院后 | 患者从医院出院后提供有效镇痛是**关键（critical）** |

2. 药物类别要点

2.1 NSAIDs

- 非甾体抗炎药（NSAIDs）提供优秀的围手术期镇痛，**应当使用，除非有禁忌（unless contraindicated）（应优先选择已批准的药物 approved drugs should be preferred）**。
- **同一 NSAID 应术前与术后使用；应避免在围手术期即刻在 NSAIDs 之间切换（switching between NSAIDs in the immediate perioperative period should be avoided）**。

2.2 神经损伤与加巴喷丁

神经切断（如截肢期间）或牵拉 manipulation 可导致重度疼痛、神经病理性疼痛（neuropathic pain）及持续性术后疼痛的发展。**Gabapentin 可围手术期使用**，因其在预防持续性术后疼痛方面存在潜在获益。', '', '', '', '疼痛管理,骨科手术疼痛,多模式镇痛,预防性镇痛,NSAIDs,methadone,总则与全球分层原则,药物类别要点', 'caution', '骨科手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('骨科手术疼痛管理 · 选择依据与局部麻醉技术', '2.3 选择依据与局部麻醉技术

- 阿片类（opioid）、α2 肾上腺素受体激动剂（alpha2 adrenoceptor agonist）或 NSAID 的选择将因**可获得性、个人偏好与禁忌症**而异。
- 局部区域麻醉技术（Locoregional anaesthetic techniques）、局部区域神经阻滞（locoregional nerve blocks）、伤口输注导管（wound infusion catheters）或其组合，在手术前和/或术后，**所有病例均推荐使用**；当阿片类及其他受管制镇痛药（controlled analgesic drugs）不可获得时，这些技术应视为**强制性（mandatory）**。
- 推荐使用**长效局部麻醉药，如 bupivacaine 或 ropivacaine**，因其作用时间长。
- 在可获得时，推荐局部麻醉药长效制剂（例如 **bupivacaine liposomal injectable suspension，其可持续镇痛达 72 hours（may provide analgesia for up to 72 hours）**）用于犬 cranial cruciate ligament（前十字韧带）手术的切口麻醉。', 'dog', '', '', '疼痛管理,骨科手术疼痛,多模式镇痛,预防性镇痛,NSAIDs,methadone,总则与全球分层原则,药物类别要点', 'caution', '骨科手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('骨科手术疼痛管理 · 标准方案（Protocol for orthopaedic surgery）', '3. 标准方案（Protocol for orthopaedic surgery）

| 阶段 | 原文用药与技术 |
|---|---|
| Preoperative（术前） | Combination of an opioid and a NSAID, ± alpha2 adrenoceptor agonist, ± ketamine（**cats only，仅限猫**） |
| Intraoperative（术中） | Boluses and/or infusions of opioids, alpha2 adrenoceptor agonists, ketamine and/or lidocaine（**use cautiously in cats，猫慎用**）。若已实施有效局部麻醉阻滞，这些药物可能不需要 |
| Local Anaesthetic techniques | Locoregional blocks（e.g. RUMM、sciatic-femoral nerve、incisional、brachial plexus block）；Neuraxial nerve blocks（e.g. epidural）。RUMM 缩写原文未展开 |
| Immediate postoperative（术后即刻，24 hours） | Combination of a NSAID（if not administered preoperatively）并继续术中输注或推注并**逐步减量（gradual reduction in doses）**；Locoregional anaesthetic blocks 或 wound infusion catheters；辅助镇痛药、非药物治疗（**尤其是 cold therapy**）、谨慎的垫衬与体位摆放（careful padding and positioning）、代偿区域（背部与未手术肢体）的轻柔按摩 |
| Later postoperative days（术后较晚阶段） | Opioid administration（injectable、transdermal、oral、transmucosal）**滴定至效应（titration to effect）并逐步停药**和/或 NSAIDs。**Metamizole (dipyrone)、Paracetamol (acetaminophen) — not in cats（猫禁用）**，及其他辅助镇痛药（e.g. lidocaine patches、gabapentin、amantadine）与非药物治疗；经扩散导管（diffusion catheter）给予局部麻醉药，可直至出院（if needed）。**患区冰敷应持续至少 3 days（minimum of 3 days）**，此后可与热疗交替，在伸展与轻柔负重之前使用热疗（这些治疗之后再冰敷） |', 'cat', '', '', '疼痛管理,骨科手术疼痛,多模式镇痛,预防性镇痛,NSAIDs,methadone,总则与全球分层原则,药物类别要点', 'caution', '骨科手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('骨科手术疼痛管理 · 无受管制药物方案与药物受限方案', '4. 无受管制药物方案与药物受限方案

4.1 无受管制药物方案（Protocol without controlled drugs）

见上文，**去掉阿片类（without the opioid）**。**Injectable tramadol 可在围手术期给药**。当阿片类不可获得时，局部麻醉技术（尤其区域阻滞）、**intravenous lidocaine infusion（术中与术后）**、非药物治疗联合 NSAIDs 变得**关键（critical）**。

4.2 镇痛药物可获得性受限方案（Protocol with limited availability of analgesic drugs）

| 阶段 | 原文内容 |
|---|---|
| 总则 | 见上文，without the opioid |
| Intraoperative | 非药物治疗、ketamine 与 lidocaine 输注、acupuncture（针刺）可用于术中 |
| Immediate postoperative | 低剂量 alpha2 adrenoceptor agonist + tramadol + NSAID（**not if administered preoperatively**）+ 非药物治疗 + 追加区域阻滞或连续伤口阻滞（wound catheters） |
| Later postoperative days | NSAIDs as required、paracetamol (acetaminophen)（**not in cats**）或 **dypirone**（原文拼写）、amantadine 和/或 gabapentin、非药物治疗 |
| 警示语 | **If pain is severe, cannot be controlled with the available resources and is likely to be prolonged, euthanasia should be considered（若疼痛严重、以现有资源无法控制且可能长期持续，应考虑安乐死）** |', 'cat', '', '', '疼痛管理,骨科手术疼痛,多模式镇痛,预防性镇痛,NSAIDs,methadone,总则与全球分层原则,药物类别要点', 'informational', '骨科手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('骨科手术疼痛管理 · 犬股骨骨折修复示例方案', '5. 犬股骨骨折修复示例方案

| 阶段 | 原文剂量（逐字） |
|---|---|
| Preoperative | NSAID (24-hour dose; ideally one approved for dogs), **methadone 0.3 mg/kg IM**, **acepromazine 0.02-0.03 mg/kg IM** |
| Induction of anaesthesia | **propofol to effect IV** |
| Maintenance of anaesthesia | inhalation anaesthesia with **lumbosacral epidural** administration of **bupivacaine 0.5% with morphine (preservative free) 0.1-0.2 mg/kg (1 mL/4 kg up to 6 mL before surgery)** |
| Immediate postoperative (for 24 hours) | **methadone 0.3 mg/kg IM**（every 4-6 hours depending on pain scoring and need for rescue analgesia，即每 4-6 小时，依疼痛评分与解救镇痛需要而定）、icing、range of motion 及其他非药物治疗 |
| Later postoperative days | NSAID（same drug as preoperative, starting 24 hours after preoperative dose）**every 24h** and **gabapentin 5-10 mg/kg PO every 8-12h for up to 14 days after surgery**。继续非药物治疗，并在随访时重新评估镇痛药需求 |', 'dog', '', '', '疼痛管理,骨科手术疼痛,多模式镇痛,预防性镇痛,NSAIDs,methadone,总则与全球分层原则,药物类别要点', 'informational', '骨科手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('骨科手术疼痛管理 · 猫股骨骨折修复示例方案', '6. 猫股骨骨折修复示例方案

| 阶段 | 原文剂量（逐字） |
|---|---|
| Preoperative | NSAID (24-hour dose; ideally one approved for cats), **methadone 0.3 mg/kg IM**, **medetomidine 0.01 mg/kg IM** |
| Induction of anaesthesia | **propofol to effect IV** |
| Maintenance of anaesthesia | inhalation anaesthesia with **lumbosacral epidural** administration of **0.5% bupivacaine with morphine (preservative free) 0.1-0.2 mg/kg (1 mL/4kg up to 6 mL before surgery)** |
| Immediate postoperative (for 24 hours) | **methadone 0.2-0.3 mg/kg IV**（every 4-6 hours depending on pain scoring and need for rescue analgesia）、icing、range of motion 及其他非药物疗法 |
| Later postoperative days | **Buprenorphine 0.02 mg/kg OTM (or IV if catheter available), every 6-8h for up to 3 days after surgery**（原文补充：where available, the high concentration formulation of buprenorphine **(1.8 mg/mL)** or the **buprenorphine transdermal formulation** can be used instead; Table 12）。NSAID（same drug as preoperative, starting 24 hours after preoperative dose）, **every 24h after surgery**。原文：**Please see labels for approved-NSAIDs for use in cats**。继续非药物治疗并在随访时重新评估镇痛药需求 |', 'cat', '', '', '疼痛管理,骨科手术疼痛,多模式镇痛,预防性镇痛,NSAIDs,methadone,总则与全球分层原则,药物类别要点', 'informational', '骨科手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('骨科手术疼痛管理 · 原文缺失项登记', '7. 原文缺失项登记

- 示例方案中"NSAID (24-hour dose)"未指名具体药物与 mg/kg 数值，原文此处缺失；原文另标注 **Table 12**，该表未包含在本海报抽取内容中。
- 标准方案各阶段（第 3 节）的阿片类、alpha2 受体激动剂、ketamine、lidocaine 均未给出剂量，原文此处缺失；原文统一指向 www.wsava.org 上 WSAVA Pain Committee Treatise 的 dosing tables。
- 原文未提供犬猫各自的疼痛评分工具名称。', '', '', '', '疼痛管理,骨科手术疼痛,多模式镇痛,预防性镇痛,NSAIDs,methadone,总则与全球分层原则,药物类别要点', 'informational', '骨科手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('幼龄动物 · 第 1 段', '幼龄动物（儿科）疼痛管理

1. 文件定位与分层原则

原文声明方案按**分层（tiered）**方式编排以保证全球适用性，承认并非所有镇痛手段（analgesic modalities）都可为兽医从业者获得且各地区不同；实施取决于可获得的镇痛手段与个体患者需求。本方案转载（reproduced）自 WSAVA Pain Committee guidelines，发表于 *Journal of Small Animal Practice*，可在 www.wsava.org 的 Pain Committee 页面开放获取。原文 PDF：`https://wsava.org/wp-content/uploads/2024/08/Pediatric-Pain.pdf`（2 页），正文章节标题为 **PAEDIATRIC PAIN（幼龄/儿科疼痛）**。

2. 年龄分期术语与适用对象

2.1 生命阶段（Life Stage）术语

原文：近期 American Association of Feline Practitioner / American Animal Hospital Association Life Stage Guidelines 简化了不同生命阶段的术语，年龄细分现描述为：

| 阶段（原文） | 年龄区间（原文） |
|---|---|
| kitten（幼猫） | birth up to 1 year of age |
| young adult（青年成年） | 1-6 years |
| mature adult（成熟成年） | 6-10 years |
| senior（老年） | 10 years and older |

原文补充：犬的品种寿命可能不同，但可应用类似的生命阶段；**然而仍将 12 weeks（12 周）以内的幼猫或幼犬视为幼龄（paediatric）患者是可接受的**。

2.2 新生儿疼痛"记忆"的证据基础

原文：人新生儿研究表明，当麻醉或镇痛被 withheld（例如在 circumcision 包皮环切术期间），与接受镇痛者相比，**随后疼痛体验（例如 vaccination 接种）时的痛觉敏改改变（altered pain sensitivity）会增加**。这提示婴儿保留了对疼痛体验的"记忆"，并随后对疼痛刺激产生改变的反应。原文指出**这些现象也发生于动物**；关于人新生儿疼痛及其管理所得的知识可应用于动物。', '', '', '', '疼痛管理,幼龄动物疼痛,Paediatric,新生儿,生命阶段,药物清除率,文件定位与分层原则,年龄分期术语与适用对象,幼龄动物给药挑战与药动学依据', 'informational', '幼龄动物（儿科）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('幼龄动物 · 第 2 段', '3. 幼龄动物给药挑战与药动学依据

原文：对幼龄动物施用镇痛药存在顾虑，常被引用的是"代谢药物能力下降与过量风险升高（decreased ability for drug metabolism and elevated risk of overdose）"；这可能是潜在顾虑，但**犬或猫幼龄个体中 published studies 很少，给药剂量仍具挑战**。

3.1 多数药物清除率降低的原因（原文四条，逐字保留）

| 序号 | 原文原因表述 |
|---|---|
| 1 | Their greater body water content leading to a higher volume of distribution |
| 2 | A larger fraction of body mass that consists of highly perfused tissues |
| 3 | Incomplete maturation of the hepatic-enzymes systems |
| 4 | Decreased glomerular filtration rate and renal excretion |

3.2 肝肾系统与血脑屏障

- 肝肾脏（hepatorenal）系统在生命早期持续发育；这可能导致代谢与排泄减少，**可能需要改变给药剂量与给药间隔**。
- 作用于中枢神经系统（CNS）的药物（例如 opioids、sedatives、tranquilisers、anaesthetic agents）因**血脑屏障（blood brain barrier）差异与外排转运系统（efflux transport systems）不成熟**，可能在新生儿脑内达到更高浓度。

4. 各类药物的幼龄使用要点', '', 'young', '', '疼痛管理,幼龄动物疼痛,Paediatric,新生儿,生命阶段,药物清除率,文件定位与分层原则,年龄分期术语与适用对象,幼龄动物给药挑战与药动学依据', 'informational', '幼龄动物（儿科）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('幼龄动物 · 阿片类（Opioids）', '4.1 阿片类（Opioids）

| 药物 | 原文要点（逐字关键表述） | 剂量（mg/kg） |
|---|---|---|
| fentanyl、morphine | Lower doses of fentanyl and morphine are required for analgesia in the neonatal puppy（**0–2 weeks**）when compared to **5-week-old puppies**；幼犬与幼猫对 morphine 的镇静与呼吸抑制作用较成年动物更敏感 | 原文此处缺失 |
| fentanyl | may be a more suitable opioid in paediatrics; however, as it is short-acting **continuous IV access and titration are required** | 原文此处缺失 |
| buprenorphine | may be an alternative and associated with **minimal respiratory depression** | 原文此处缺失 |
| 通用原则 | In each case, the clinical response to treatment should guide dosing | — |
| naloxone（解救） | **Opioids can be reversed with titration of naloxone should there be clinical evidence of overdosing（e.g. respiratory depression and marked somnolence）** | 原文此处缺失 |', '', 'young', '', '疼痛管理,幼龄动物疼痛,Paediatric,新生儿,生命阶段,药物清除率,文件定位与分层原则,年龄分期术语与适用对象,幼龄动物给药挑战与药动学依据', 'informational', '幼龄动物（儿科）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('幼龄动物 · 非甾体抗炎药（NSAIDs）', '4.2 非甾体抗炎药（NSAIDs）

| 要点 | 原文表述 |
|---|---|
| 靶动物年龄批准 | NSAIDs **rarely have market authorisation in small animals less than 12-16 weeks of age**；然而 **meloxicam has approval in some countries for use in dogs and cats ≥ 6 weeks of age** |
| 解释 | 这并不意味着幼龄群体不能使用，而是反映**各年龄段缺乏临床前试验（lack of preclinical trials in all age groups）** |
| 临床使用 | 非甾体抗炎药用于**在幼年年龄接受去势手术的犬和猫** |
| 研究证据（逐字） | Prepubertal kittens（**N = 380, aged 8-12 weeks**） undergoing **ovariohysterectomy or castration** received **carprofen or meloxicam** before surgery with **no reported adverse effects** |
| 警示语 | 临床医生应确保患者是 NSAID 使用的合适候选者，例如 **they are not hypovolemic or hypotensive（不得处于低血容量或低血压状态）** |', '', 'young', '', '疼痛管理,幼龄动物疼痛,Paediatric,新生儿,生命阶段,药物清除率,文件定位与分层原则,年龄分期术语与适用对象,幼龄动物给药挑战与药动学依据', 'informational', '幼龄动物（儿科）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('幼龄动物 · 局部麻醉药（Local anaesthetics）', '4.3 局部麻醉药（Local anaesthetics）

| 项目 | 原文内容（数值逐字） |
|---|---|
|  topical（外用）制剂 | topical anaesthetics include a **eutectic mixture of 2.5% lidocaine and 2.5% prilocaine**，及 **liposome encapsulated formulations of 4% lidocaine**，可用于使皮肤脱敏（desensitise the skin） |
| 适用操作 | **venipuncture（静脉穿刺）、IV catheter placement 及其他轻微表浅操作** |
| 操作步骤 | 剃除区域皮肤毛发、清洁，用麻醉乳膏覆盖区域，然后放置**封闭性敷料（occlusive dressing, e.g. a thin film of plastic）**并用多用途粘弹性绷带（multi-purpose cohesive bandage）固定 |
| 起效时间 | **Onset of action is variable but occurs between 15-20 minutes** |
| 可注射局部麻醉药 | **应尽可能使用局部麻醉技术**；选择合适剂量时应考虑新生儿器官成熟度与身体组成；**重复注射或连续输注（e.g. IV lidocaine）可能导致蓄积，应避免或谨慎使用** |
| 减量警示 | 若重复给药，**连续剂量或 CRI 速率应较成年动物降低**，并密切观察患畜毒性征象 |
| 清醒患者注射痛的减轻 | 使用**细针（27-30 G）**、缓慢注射、**用 sodium bicarbonate 缓冲**、并将溶液**加温至体温** |

4.4 α2 肾上腺素受体激动剂（Alpha2-adrenoceptor agonist drugs）

| 要点 | 原文表述 |
|---|---|
| 不推荐依据 | **Cardiac output is heart rate dependent in neonates**，且因该类药相关的**心动过缓（bradycardia）**，**这些药物不推荐使用（not recommended）** |
| 原文同时记录的做法 | 然而许多幼龄去势麻醉方案包含 alpha2-adrenoceptor agonist（e.g. **medetomidine or dexmedetomidine**）、**ketamine** 与 **an opioid** 作为**全静脉注射技术（total injectable technique）**联合使用，并取得了成功（with success） |
| 剂量 | 原文此处缺失 |', '', 'young', '', '疼痛管理,幼龄动物疼痛,Paediatric,新生儿,生命阶段,药物清除率,文件定位与分层原则,年龄分期术语与适用对象,幼龄动物给药挑战与药动学依据', 'informational', '幼龄动物（儿科）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('幼龄动物 · 非药物技术（Nonpharmacologic techniques）', '5. 非药物技术（Nonpharmacologic techniques）

原文：对所有患者而言，**良好的护理（Good nursing care）与低应激保定（low stress handling）**都很重要。可考虑的技术包括：**suckling（吸吮）、swaddling（包裹）、body contact with the dam (or a human)（与母犬/母猫或人的身体接触）and warmth（保暖）**。

6. 原文缺失项登记

- 本页为机制与注意事项类海报，**通篇未给出任何 mg/kg 剂量、给药途径或频次**（仅给出外用制剂百分比、针规 27-30 G、起效 15-20 minutes、年龄区间等数值），原文此处缺失；原文页脚指示参见 WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）。
- 未列出幼龄犬猫适用的疼痛评估量表，原文此处缺失。
- 原文未提供 "total injectable technique" 的具体药物配比，原文此处缺失。', '', 'young', '', '疼痛管理,幼龄动物疼痛,Paediatric,新生儿,生命阶段,药物清除率,文件定位与分层原则,年龄分期术语与适用对象,幼龄动物给药挑战与药动学依据', 'informational', '幼龄动物（儿科）疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('妊娠与哺乳动物疼痛管理 · 第 1 段', '妊娠与哺乳动物疼痛管理

1. 文件定位、分层原则与版权来源

1.1 分层原则

原文声明本疼痛管理方案按**分层（tiered）**方式编排以保证全球适用性，承认并非所有镇痛手段（analgesic modalities）都可为兽医从业者获得且各地区不同；实施取决于可获得的镇痛手段与个体患者需求。方案转载（reproduced）自 **WSAVA Global Pain Treatise**，发表于 *Journal of Small Animal Practice*，可在 www.wsava.org 的 GPC 页面开放获取。原文 PDF：`https://wsava.org/wp-content/uploads/2020/01/Pregnant-or-lactating-patients.pdf`（1 页）。

1.2 版权与改编来源（原文逐字）

© World Small Animal Veterinary Association. Adapted from Mathews K, et al. Guidelines for recognition, assessment and treatment of pain. Journal of Small Animal Practice 2014; 55: E10–E68 and produced by The British Small Animal Veterinary Association. See full text for further information. WSAVA would like to recognize the GPC sponsors。

1.3 证据基础声明

原文：**Very little information is available about the pharmacology of analgesic drugs in dogs and cats during pregnancy and lactation; some information is presented from studies in humans and laboratory species.（犬猫妊娠与哺乳期镇痛药物的药理学信息极少；部分信息来自人类与实验动物研究。）**

2. 妊娠期（Pregnancy）', '', '', '', '疼痛管理,妊娠疼痛管理,哺乳疼痛管理,Pregnancy,Lactation,胎盘屏障,文件定位、分层原则与版权来源,妊娠期（Pregnancy）,哺乳期（Lactation）', 'informational', '妊娠与哺乳动物疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('妊娠与哺乳动物疼痛管理 · 母体生理变化对药物处置的影响', '2.1 母体生理变化对药物处置的影响

原文：与**母体-胎盘-胎儿单位（maternal-placental-foetal unit）**相关的生理变化会改变药物的**药效学（pharmacodynamics）**、**药动学（pharmacokinetics）**及向胎儿的分布。

| 影响环节 | 原文因素（逐字列表） |
|---|---|
| 改变药物吸收的母体因素 | decreased gastrointestinal motility、oesophageal reflux（原文抽取为 reﬂux，连字字符）and vomiting；以及 an increased cutaneous blood flow，**which may enhance absorption of transdermally administered drugs（可增强透皮给药药物的吸收）** |
| 改变妊娠动物对镇痛药反应的因素 | Increased total body water、increased total body fat、reduced serum albumin、altered hepatic enzymatic activity and increased renal function |

2.2 胎盘屏障与药物理化性质

原文：**The placental barrier is considered to be a lipoprotein, therefore drugs with high lipid solubility are permeable. Drugs that are polar, ionized, protein-bound or water soluble are less likely to cross the placenta into the foetus.（胎盘屏障被视为脂蛋白，因此高脂溶性药物可通透；极性、离子化、蛋白结合或水溶性药物较少跨越胎盘进入胎儿。）**', '', '', '', '疼痛管理,妊娠疼痛管理,哺乳疼痛管理,Pregnancy,Lactation,胎盘屏障,文件定位、分层原则与版权来源,妊娠期（Pregnancy）,哺乳期（Lactation）', 'informational', '妊娠与哺乳动物疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('妊娠与哺乳动物疼痛管理 · 妊娠期各类药物（剂量原文均未给出）', '2.3 妊娠期各类药物（剂量原文均未给出）

| 药物类别 | 原文表述 | 禁忌 / 警示语（逐字） |
|---|---|---|
| Opioids（阿片类） | 目前阿片类常用于妊娠犬猫的镇痛。**Methadone, morphine and hydromorphone** are used during pregnancy in humans。**Fentanyl, pethidine (meperidine), butorphanol and nalbuphine** are more lipid soluble, and therefore **may reach higher concentrations in the foeti**。阿片类常用于剖宫产（caesarian section，原文拼写）术前，**most puppies and kittens are successfully delivered and are vigorous** | 若幼崽分娩后抑郁：除提供 warmth、stimulation、oxygen 及按需 application of suction 外，**a drop of naloxone placed sublingually should reverse these effects; however repeat dosing may be required**。**Buprenorphine resulted in lack of milk production in animal studies, which may be a problem following casesarian（原文拼写）** |
| NSAIDs | — | **Due to possible teratogenicity and development-interfering effects, it is advised that NSAIDs are not administered to pregnant animals（因可能的致畸性与干扰发育的作用，建议妊娠期动物不使用 NSAIDs）** |
| Ketamine | **Ketamine rapidly crosses the placenta**; however, **no foetal effects have been observed during organogenesis and near delivery in rats, mice, rabbits and dogs** | **Ketamine increases uterine tone and should be avoided during pregnancy（Ketamine 增加子宫张力，妊娠期应避免使用）**。原文另注：An in-depth review of caesarean section in dogs is available |
| Alpha2 adrenoceptor agonists | **Reduce uterine blood flow（减少子宫血流）** | **Xylazine should not be used during pregnancy**。**Evidence regarding the use of medetomidine and dexmedetomidine in dogs and cats during pregnancy is not available** |
| Local anaesthetics | Generally considered to be **safe and non-teratogenic** | 原文：**they are highly recommended（强烈推荐）** |
| Herbal analgesic medications | — | **Due to a lack of information, these should be avoided（因信息缺乏应避免）** |', '', 'young', '', '疼痛管理,妊娠疼痛管理,哺乳疼痛管理,Pregnancy,Lactation,胎盘屏障,文件定位、分层原则与版权来源,妊娠期（Pregnancy）,哺乳期（Lactation）', 'caution', '妊娠与哺乳动物疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('妊娠与哺乳动物疼痛管理 · 哺乳期（Lactation）', '3. 哺乳期（Lactation）

3.1 药物进入乳汁的规律与哺乳管理

| 要点 | 原文表述 |
|---|---|
| 利于分泌入乳汁的药物特性 | **high lipid solubility, low molecular weight and the non-ionized (charged) state** |
| 新生儿实际摄入量 | **It is estimated that the neonate receives approximately 1% to 2% of the maternal dose of a drug.（估计新生儿接受约母体给药剂量的 1%–2%）** |
| 必需镇痛且顾虑子代毒性时的处理 | **the milk should be pumped and discarded for 12 h before resuming suckling, and puppies and kittens should be bottle fed（应挤奶并弃去 12 小时后再恢复哺乳，幼犬幼猫应人工瓶喂）** |', '', 'young', '', '疼痛管理,妊娠疼痛管理,哺乳疼痛管理,Pregnancy,Lactation,胎盘屏障,文件定位、分层原则与版权来源,妊娠期（Pregnancy）,哺乳期（Lactation）', 'informational', '妊娠与哺乳动物疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('妊娠与哺乳动物疼痛管理 · 哺乳期各类药物', '3.2 哺乳期各类药物

| 药物类别 | 原文表述 | 禁忌 / 警示语（逐字） |
|---|---|---|
| Opioids | 阿片类的脂溶性影响其出现在乳汁中的量；原文排序：**pethidine (meperidine) > sufentanil > fentanyl > morphine > hydromorphone**，因此更具亲水性的阿片类（如 morphine）在乳汁中的量可能少于高脂溶性的 pethidine | **It is recommended that suckling occurs after peak levels of the opioid have waned.（建议哺乳在阿片类血药峰值消退后进行）**；**Pethidine (meperidine), butorphanol, nalbuphine are not recommended**；选择阿片类时，**mothers and offspring should be carefully observed and monitored for signs of opioid adverse effects** |
| NSAIDs | Most NSAIDs are not lipid soluble, are **highly protein bound** to plasma proteins and may be present to a great degree in an **ionised form** in the plasma。**It has been suggested that a single use of an NSAID is safe in nursing human mothers.** | **Until studies are performed in lactating cats and dogs, NSAIDs should be administered with caution and as single doses only（在哺乳期犬猫研究完成前应谨慎使用且仅单剂给药）**。**Hemorrhage is a potential concern following the administration of non-COX selective, or COX-1 selective NSAIDs immediately after caesarian section, or even natural birth.** In general, **paracetamol is safe for use in dogs, but cannot be administered to cats** |
| Local anaesthetics | **Lidocaine and its metabolites have low lipid solubility; at therapeutic doses the concentrations in milk are small and unlikely to be a risk** | **Incision line infiltration is highly recommended（切口线浸润麻醉强烈推荐）** |
| Ketamine | **No reports on passage into breast milk were found, but it is expected to pass into breast milk** | — |
| Herbal analgesic medications | — | **Due to a a lack of information（原文重复冠词）, these should be avoided** |', '', '', '', '疼痛管理,妊娠疼痛管理,哺乳疼痛管理,Pregnancy,Lactation,胎盘屏障,文件定位、分层原则与版权来源,妊娠期（Pregnancy）,哺乳期（Lactation）', 'caution', '妊娠与哺乳动物疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('妊娠与哺乳动物疼痛管理 · 原文缺失与抽取质量问题登记', '4. 原文缺失与抽取质量问题登记

- 本页为机制/禁忌类海报，**通篇未给出任何 mg/kg 剂量、给药途径或频次**（唯一给药表述为 "a drop of naloxone placed sublingually" 与弃奶 "12 h"），其余原文此处缺失；原文指示参见 **WSAVA GPC Treatise 的 dosing tables（www.wsava.org）**。
- 原文未给出犬/猫具体临床场景（如剖宫产）的完整分层镇痛方案；仅提及"犬剖宫产的深入综述可供查阅"，正文未附，原文此处缺失。
- 抽取文本存在字体连字与识别问题：`reﬂux`、`eﬀects`、`inﬂammation` 等含连字字符；多处 "The" 被抽取为 **"Te"**（如 "Te maternal factors"、"Te placental barrier"、"Te lipid solubility"、"Te designation"）；原文自身拼写变异包括 `caesarian`/`casesarian`、`a a lack of information`。本稿按原样保留并以括注标示。', '', '', '', '疼痛管理,妊娠疼痛管理,哺乳疼痛管理,Pregnancy,Lactation,胎盘屏障,文件定位、分层原则与版权来源,妊娠期（Pregnancy）,哺乳期（Lactation）', 'caution', '妊娠与哺乳动物疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('软组织手术疼痛管理 · 第 1 段', '软组织手术疼痛管理

1. 总则与分层原则

1.1 分层原则与出处

原文声明方案按**分层（tiered）**方式编排以保证全球适用性，承认并非所有镇痛手段（analgesic modalities）都可为兽医从业者获得且各地区不同；实施取决于可获得的镇痛手段与个体患者需求。方案转载（reproduced）自 WSAVA Pain Committee guidelines，发表于 *Journal of Small Animal Practice*，可在 www.wsava.org 的 Pain Committee 页面开放获取。原文 PDF：`https://wsava.org/wp-content/uploads/2024/08/Soft-tissue-Surgery.pdf`（2 页）。

1.2 软组织手术疼痛的基本认识

| 要点 | 原文表述 |
|---|---|
| 疼痛强度 | 软组织手术（Soft tissue surgery）可引起**轻度、中度或重度**术后疼痛 |
| 技术原则 | 应采用**预防性（Preventive）与多模式（multimodal）**镇痛技术，并**尽可能包含局部麻醉技术** |
| 平衡依据 | 术前、术中、术后镇痛的平衡取决于术前疾病严重程度以及手术创伤的位置与大小 |
| 疼痛未控时 | **当 NSAIDs 未能成功控制术后疼痛时，应采用替代或额外的镇痛药或镇痛技术** |
| 慢性疼痛 | **大型（Major）软组织手术可导致慢性疼痛，其可能带有神经病理性成分（neuropathic component）** |
| gabapentin 证据状态 | 迄今**尚无兽医研究**评估在存在显著神经损伤的手术情形下，于围手术期麻醉与镇痛方案中加用 gabapentin 的获益；但基于其在人医中的使用，**在预防神经病理性疼痛方面可能存在潜在价值** |
| 药物选择 Note | **The choice of opioid, alpha2 adrenoceptor agonist or NSAID used will vary based on availability and contraindications** |
| 局部区域麻醉 | 关节内（intra-articular）、切口（incisional）及特定神经阻滞等局部区域麻醉技术（Locoregional anaesthetic techniques）、伤口输注导管（wound infusion catheters）或其组合，在手术前和/或术后**所有病例均强烈推荐**；当阿片类及其他受管制镇痛药不可获得时，这些技术**成为强制性（mandatory）** |', '', '', '', '疼痛管理,软组织手术疼痛,预防性镇痛,多模式镇痛,局部区域阻滞,midazolam,总则与分层原则', 'informational', '软组织手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('软组织手术疼痛管理 · 小型软组织手术（Minor soft tissue surgery）方案', '2. 小型软组织手术（Minor soft tissue surgery）方案

| 阶段 | 原文内容（逐字要素） |
|---|---|
| Pre- and intraoperative | Combination of an opioid, NSAID ± alpha2 adrenoceptor agonist ± **ketamine (cats)**；Local anaesthetic techniques |
| Postoperative analgesia | NSAIDs (unless administered preoperatively) ± opioid and/or non-drug therapies |
| Protocol without controlled drugs（无受管制药物） | Pre- and intraoperative: **NSAID ± alpha2 adrenoreceptor agonist + metamizole (dipyrone) or paracetamol (acetaminophen) – not in cats ± gabapentin**；Same as above but without the opioid |
| Protocol with limited availability（药物受限） | Pre-and intraoperative: Combination of **alpha2 adrenoceptor agonists, tramadol, a NSAID and local anaesthetic technique**。Immediate and later postoperative (**24 h**): **NSAID (unless administered preoperatively), paracetamol (acetaminophen) (not in cats) or dypirone（原文拼写）, and non-drug therapies** |', 'cat', '', '', '疼痛管理,软组织手术疼痛,预防性镇痛,多模式镇痛,局部区域阻滞,midazolam,总则与分层原则', 'informational', '软组织手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('软组织手术疼痛管理 · 大型软组织手术（Major soft tissue surgery）方案', '3. 大型软组织手术（Major soft tissue surgery）方案

| 阶段 | 原文内容（逐字要素） |
|---|---|
| Preoperative | **Same as for minor soft tissue surgery（同小型软组织手术）** |
| Intraoperative | Boluses or infusions of **opioids ± alpha2 adrenoceptor agonists ± ketamine ± lidocaine**。若已实施有效局部麻醉阻滞，这些药物可能不需要 |
| Immediate and later postoperative（24 hours） | **NSAID (unless administered preoperatively)**，按需**连续输注或推注术中使用的药物** ± 其他辅助药物与非药物治疗，如 **cold therapy（冷疗）与 acupuncture（针刺）** |
| Protocol without controlled drugs | Preoperative: Same as for minor soft tissue surgery。See above, **without the opioid**。**Injectable tramadol may be administered in the perioperative period**。当阿片类不可获得时，局部麻醉技术（尤其区域阻滞）、**lidocaine infusion（术中与术后输注）**、非药物治疗联合 NSAIDs 变得**关键（critical）** |
| Protocol with limited availability | See above **without opioids**。组合使用 **low dose alpha2 adrenoreceptor agonist、NSAID (unless administered preoperatively)、gabapentin、paracetamol (acetaminophen) (not in cats) or dipyrone、amantadine、非药物治疗、追加区域阻滞或连续伤口阻滞（wound catheters）**。Later postoperative days：**NSAID as required、非药物治疗、追加区域阻滞或连续伤口阻滞（wound catheters）** |
| 终止性警示 | **If pain cannot be controlled or ameliorated with available techniques and the prognosis is poor, consider euthanasia（若以现有技术无法控制或缓解疼痛且预后不良，考虑安乐死）** |', 'cat', '', '', '疼痛管理,软组织手术疼痛,预防性镇痛,多模式镇痛,局部区域阻滞,midazolam,总则与分层原则', 'informational', '软组织手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('软组织手术疼痛管理 · 猫注射部位肉瘤手术切除示例（Major soft tissue surgery）', '4. 猫注射部位肉瘤手术切除示例（Major soft tissue surgery）

原文示例标题：**Example of a protocol for a cat undergoing a surgical removal of injection site sarcoma (major soft tissue surgery)**。

| 阶段 | 原文剂量与途径（逐字照抄） |
|---|---|
| Preoperative | **NSAID (24h dose; one approved in cats), methadone 0.3 mg/kg IM, ketamine 5 mg/kg and midazolam 0.25 mg/kg IM** |
| Induction of anaesthesia | **Propofol to effect IV** |
| Maintenance of anaesthesia | Inhalation anaesthesia with **constant rate infusions of fentanyl 5-10 µg/kg/h following a loading dose of 5 µg/kg IV**, and **ketamine at 2-10 µg/kg/min following a loading dose of 0.5 mg/kg IV**。**Infiltration anaesthesia with local anaesthetics, consider placement of a wound infusion catheter** |
| Immediate postoperative（24 hours） | **Constant rate infusions of fentanyl 1–3 µg/kg/h and ketamine 2-10 µg/kg/min**。**Cold therapy ± acupuncture**。**Wound therapy catheter with administration of bupivacaine 0.5% (up to 2 mg/kg every 8 hours)** |
| Later postoperative days | **Buprenorphine 0.02 mg/kg OTM (or IV if catheter available), every 6-8h for up to 3 days after surgery**（原文补充：**where available, the high concentration formulation of buprenorphine (1.8 mg/mL) or the buprenorphine transdermal formulation can be used instead**）。**NSAID (same drug as preoperative, starting 24 hours after preoperative dose), every 24h after surgery**。**Please see labels for approved-NSAIDs for use in cats**。继续非药物治疗，并在随访时重新评估镇痛药需求 |', 'cat', '', '', '疼痛管理,软组织手术疼痛,预防性镇痛,多模式镇痛,局部区域阻滞,midazolam,总则与分层原则', 'informational', '软组织手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('软组织手术疼痛管理 · 原文缺失项登记', '5. 原文缺失项登记

- 第 2、3 节的各阶段方案仅列**药物类别与组合方式**，未给出任何 mg/kg 剂量、途径与频次（除示例方案外），原文此处缺失；原文页脚指示参见 **WSAVA Pain Committee Treatise 的 dosing tables（www.wsava.org）**。
- 示例方案（第 4 节）只给出猫注射部位肉瘤一例，**未提供犬的大型/小型软组织手术示例方案**，原文此处缺失。
- 示例方案末尾括注在原文中未闭合（"…can be used instead." 括号不完整），属抽取格式问题，未影响药名与剂量内容。
- 原文对 "metamizole (dipyrone)"、"dypirone"、"dipyrone" 三种拼写并存，本稿按各处原文逐字保留，不作统一。', '', '', '', '疼痛管理,软组织手术疼痛,预防性镇痛,多模式镇痛,局部区域阻滞,midazolam,总则与分层原则', 'informational', '软组织手术疼痛管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('感知疼痛等级视觉自评图 · 第 1 段', '感知疼痛等级视觉自评图（各病症感知疼痛等级）

1. 文件定位与用途

1.1 标题与性质

原文标题：**WSAVA Global Pain Council — Perceived Level of Pain Associated with Various Conditions（与各种病症相关的感知疼痛等级）**。原文 PDF：`https://wsava.org/wp-content/uploads/2020/01/WSAVA-Global-Pain-Council-Perceived-levels-of-pain.pdf`（1 页，含 2 张图示图像）。本页是一张**按疼痛等级归类临床病症的图示海报/速查表**，不是给药方案。', '', '', '', '疼痛管理,感知疼痛等级,临床场景分级,Moderate,病症清单,图示量表,文件定位与用途,等级总览表', 'informational', '感知疼痛等级视觉自评图（各病症感知疼痛等级）', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('感知疼痛等级视觉自评图 · 原文使用说明（逐字要点）', '1.2 原文使用说明（逐字要点）

| 原文表述 | 中文整理 |
|---|---|
| The following are common clinical scenarios encountered in veterinary medicine with their attendant level of pain provided. | 以下为兽医临床常见场景及其相应的疼痛等级 |
| The degree of pain should be taken into account when determining therapeutic approach, as outlined in the various tiered analgesic protocols; their implementation will be guided by the various analgesic modalities available along with the needs of the individual patient requiring treatment. | 决定治疗思路时应考虑疼痛程度，如各**分层（tiered）镇痛方案**所述；其实施取决于可获得的镇痛手段与个体患者需求 |
| This table is reproduced from the WSAVA Global Pain Treatise… | 本表转载（reproduced）自 WSAVA Global Pain Treatise，发表于 *Journal of Small Animal Practice*，可在 www.wsava.org 的 GPC 页面开放获取 |
| Te designation of conditions into categories below is intented to serve only as a guide. Pain may vary according to the patient and the condition. Each patient should be assessed individually. | 将病症归入以下等级**仅作为指南**；疼痛可因患者与病症而异，**每例患者都应个体化评估**（"Te" 为原文抽取将 "The" 误识所致） |', '', '', '', '疼痛管理,感知疼痛等级,临床场景分级,Moderate,病症清单,图示量表,文件定位与用途,等级总览表', 'informational', '感知疼痛等级视觉自评图（各病症感知疼痛等级）', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('感知疼痛等级视觉自评图 · 版权与数据来源', '1.3 版权与数据来源

- 版权：© World Small Animal Veterinary Association. Adapted from Mathews K, et al. Guidelines for recognition, assessment and treatment of pain. Journal of Small Animal Practice 2014; 55: E10–E68 and produced by The British Small Animal Veterinary Association. See full text for further information. WSAVA would like to recognize the GPC sponsors。
- 表内数据来源：Data from Mathews, K. (2000) Vet Clin NA, Sm Anim Pract. 30, 729–752。

2. 等级总览表

| 等级名称（原文） | 中文对应 | 分值区间 | 适用对象（犬/猫、主人用/兽医用） | 原文收录病症条数 |
|---|---|---|---|---|
| Severe-to-excrutiating（原文拼写，见第 7 节说明） | 重度至难以忍受 | 原文此处缺失 | 原文此处缺失 | 15 |
| Moderate-to-severe (varies with degree of illness or injury) | 中度至重度（随疾病或损伤程度而异） | 原文此处缺失 | 原文此处缺失 | 21 |
| Moderate | 中度 | 原文此处缺失 | 原文此处缺失 | 6 |
| Mild-to-moderate | 轻度至中度 | 原文此处缺失 | 原文此处缺失 | 7 |

说明：原海报以四个等级名称**定性分级**，未提供数值量表（如 0–10 或 0–4）的分值区间，也未标注该图供犬主人自评或兽医使用，更未按犬/猫分列；原文此处缺失。', '', '', '', '疼痛管理,感知疼痛等级,临床场景分级,Moderate,病症清单,图示量表,文件定位与用途,等级总览表', 'informational', '感知疼痛等级视觉自评图（各病症感知疼痛等级）', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('感知疼痛等级视觉自评图 · 重度至难以忍受（Severe-to-excrutiating）', '3. 重度至难以忍受（Severe-to-excrutiating）

| # | 原文病症（逐字） | 中文整理 |
|---|---|---|
| 1 | Central nervous system infarction/tumours | 中枢神经系统梗死/肿瘤 |
| 2 | Meningitis | 脑膜炎 |
| 3 | Fracture repair where extensive soft tissue injury exists | 存在广泛软组织损伤的骨折修复 |
| 4 | Spinal surgery | 脊柱手术 |
| 5 | Ear canal ablation | 耳道截除术 |
| 6 | Burn injury | 烧伤 |
| 7 | Articular or pathological fractures | 关节内或病理性骨折 |
| 8 | Limb amputation | 肢体截肢 |
| 9 | Necrotizing pancreatitis or cholecystitis | 坏死性胰腺炎或胆囊炎 |
| 10 | Thrombosis/ischaemia | 血栓/缺血 |
| 11 | Bone cancer | 骨癌 |
| 12 | Hypertrophic osteodystrophy | 肥大性骨营养不良 |
| 13 | Aortic saddle thrombosis | 主动脉鞍状血栓 |
| 14 | Neuropathic pain (nerve entrapment/inflammation, acute intervertebral disc herniation) | 神经病理性疼痛（神经卡压/炎症，急性椎间盘 herniation 突出） |
| 15 | Inflammation (extensive e.g. peritonitis, fascitis – especially streptococcal, cellulitis) | 炎症（广泛性，例如腹膜炎、筋膜炎——尤其链球菌性、蜂窝织炎） |', '', '', '', '疼痛管理,感知疼痛等级,临床场景分级,Moderate,病症清单,图示量表,文件定位与用途,等级总览表', 'informational', '感知疼痛等级视觉自评图（各病症感知疼痛等级）', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('感知疼痛等级视觉自评图 · 第 2 段', '4. 中度至重度（Moderate-to-severe, varies with degree of illness or injury）

| # | 原文病症（逐字） | 中文整理 |
|---|---|---|
| 1 | Immune-mediated arthritis | 免疫介导性关节炎 |
| 2 | Panosteitis | 全骨炎 |
| 3 | Capsular pain due to organomegaly | 器官肿大所致被膜痛 |
| 4 | Hollow organ distension | 空腔器官扩张 |
| 5 | Traumatic diaphragmatic rupture | 创伤性膈破裂 |
| 6 | Pleuritis | 胸膜炎 |
| 7 | Trauma (i.e. orthopaedic, extensive soft tissue, head) | 创伤（骨科、广泛软组织、头部） |
| 8 | Frostbite | 冻伤 |
| 9 | Ureteral/urethral/biliary obstruction | 输尿管/尿道/胆道梗阻 |
| 10 | Glaucoma | 青光眼 |
| 11 | Corneal abrasion/ulceration | 角膜擦伤/溃疡 |
| 12 | Uveitis | 葡萄膜炎 |
| 13 | Early or resolving stages of soft tissue injuries/inflammation/disease | 软组织损伤/炎症/疾病的早期或消退阶段 |
| 14 | Intervertebral disc disease | 椎间盘疾病 |
| 15 | Mesenteric, gastric, testicular or other torsions | 肠系膜、胃、睾丸或其他扭转 |
| 16 | Peritonitis with septic abdomen | 伴脓毒性腹腔的腹膜炎 |
| 17 | Mucositis | 黏膜炎 |
| 18 | Oral cancer | 口腔癌 |
| 19 | Mastitis | 乳腺炎 |
| 20 | Dystocia | 难产 |
| 21 | Extensive resection and reconstruction for mass removal and corrective orthopaedic surgery (osteotomies; cruciate surgery; open arthrotomies) | 肿块切除与矫正性骨科手术的广泛切除与重建（截骨术；十字韧带手术；开放性关节切开术） |', '', '', '', '疼痛管理,感知疼痛等级,临床场景分级,Moderate,病症清单,图示量表,文件定位与用途,等级总览表', 'caution', '感知疼痛等级视觉自评图（各病症感知疼痛等级）', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('感知疼痛等级视觉自评图 · 中度（Moderate）', '5. 中度（Moderate）

| # | 原文病症（逐字） | 中文整理 |
|---|---|---|
| 1 | Soft tissue injuries (i.e. less severe than above) | 软组织损伤（即较上述为轻） |
| 2 | Urethral obstruction | 尿道梗阻 |
| 3 | Ovariohysterectomy | 卵巢子宫切除术 |
| 4 | Cystitis | 膀胱炎 |
| 5 | Diagnostic arthroscopy and laparoscopy | 诊断性关节镜与腹腔镜 |
| 6 | Osteoarthritis | 骨关节炎 |

6. 轻度至中度（Mild-to-moderate）

| # | 原文病症（逐字） | 中文整理 |
|---|---|---|
| 1 | Dental disease | 牙科疾病 |
| 2 | Otitis | 耳炎 |
| 3 | Superficial lacerations（原文抽取为 Superﬁcial） | 浅表撕裂伤 |
| 4 | Mild cystitis | 轻度膀胱炎 |
| 5 | Chest drains | 胸腔引流管 |
| 6 | Abscess lancing | 脓肿切开引流 |
| 7 | Castration | 去势术 |

7. 原文缺失与抽取质量问题登记

- **分值区间**：原文仅使用四个定性等级名称，未给出任何数值范围或评分刻度，原文此处缺失。
- **适用对象**：原文未标注各图/各等级供犬主人或猫主人自评使用抑或兽医使用，亦未按犬、猫分列（表内病症犬猫混列），原文此处缺失。
- **图示文字**：原 PDF 含 2 张图像（色彩分级图示/图例），图像中的文字与色带未进入文本抽取，原文此处缺失。
- **原文拼写问题（逐字保留）**：等级标题 `Severe-to-excrutiating`（应为 excruciating）、`intented`（应为 intended）、`fascitis`；连字字符 `inﬂammation`、`Superﬁcial`、`ischaemia`；冠词误识 `Te designation`。
- 本表不含药物、剂量与给药途径；相关分层镇痛方案见本板块其他场景指引（如骨科手术、软组织手术等）。', '', '', '', '疼痛管理,感知疼痛等级,临床场景分级,Moderate,病症清单,图示量表,文件定位与用途,等级总览表', 'caution', '感知疼痛等级视觉自评图（各病症感知疼痛等级）', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · > 本稿覆盖切片 015-029；评估部分见 01-，特殊情形与附录见 16-。', '> 本稿覆盖切片 015-029；评估部分见 01-，特殊情形与附录见 16-。

1. 慢性疼痛治疗概述与镇痛药物大类

慢性疼痛的主要治疗（Les principaux traitements de la douleur chronique）是 NSAIDs（Anti-inflammatoires non stéroïdiens / Non-steroidal anti-inflammatory drugs，非类固醇抗炎药），但单克隆抗体（Anticorps monoclonaux，AcM）等其他疗法的使用日益增多；还应考虑补充疗法，并更关注能减轻广泛化敏感化（sensibilisation généralisée）的疗法。慢性疼痛中宠物主人深度参与、属于护理团队的一部分：在家观察动物、填写 CMI、录制视频与兽医团队分享，监测疗效、给药，并修改动物环境（参见图 22 的环境改造策略，如利用礼品包装带、购物袋、纸盒、卫生纸卷制作猫用"喂食拼图"增加取食时间以促进饱腹与体重控制；注意不应使用绳线和细线，有误食导致线性异物风险）及生活方式（体重控制与体育活动）。

2. 阿片类（Morphiniques / Opioids）', 'cat', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 概念与分类', '2.1 概念与分类

Opiacé（阿片）指天然来源于罂粟（pavot à opium）的药物；morphinique 是更宽泛的术语，涵盖所有与阿片受体结合的天然或合成物质。阿片类长期以来是兽医急性疼痛管理的基石，按受体效应分四组：

- 完全激动剂（agonistes complets）：morphine（吗啡）、méthadone（美沙酮）、fentanyl（芬太尼）及其衍生物、péthidine（mépéridine，哌替啶/美派啶）等
- 激动-拮抗剂（agonistes -antagonistes）：butorphanol（布托啡诺）、nalbuphine（纳布啡）
- 部分激动剂（agonistes partiels）：buprénorphine（丁丙诺啡）
- 拮抗剂（antagonistes）：naloxone（纳洛酮）、nalméfène（纳美芬）、naltrexone（纳曲酮）——后者无激动活性

阿片类高效且在动物中异常安全，部分归因于其可逆性（Simon & Steagall 2017）。多数为管制/列管物质，某些国家兽医无法获得；按 WSAVA 犬猫基本药物清单属基本药物（Steagall et al. 2020a）。个体差异可源于药效学、性别、年龄、基因型、阿片受体的类型与数量及其中枢分布、脑转运机制。例如曲马多（tramadol）的代谢产物 O-desmethyl-tramadol（M1）具阿片活性，但将其代谢为 M1 的能力存在种属特异性：犬给药后血浆中该代谢物浓度不显著，猫与人则不然（Perez Jimenez et al. 2016）。

2.2 机制

阿片类与中枢及外周神经系统的 μ（mu）、κ（kappa）、δ（delta）、nociceptin（痛觉孤儿素）受体及其亚型结合，抑制脊髓传入纤维兴奋性神经递质释放，抑制伤害性刺激的突触传递；突触后增加 K+ 外流，使脊髓投射神经元超极化，抑制上行痛觉通路。阿片类不干扰运动功能或本体感觉（Simon et Steagall, 2017）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 适应证', '2.3 适应证

阿片类产生镇痛、欣快、瞳孔散大（猫）或瞳孔缩小（犬）、镇静或兴奋（dysphorie，烦躁不安）等效应用，用于中度至重度疼痛；效应取决于药物、剂量、给药途径、给药系统与物种（Hofmeister et Egger, 2004）。广泛用于围手术期多模式与预防性镇痛，及麻醉节约效应（即减少吸入麻醉药需求）；也广泛用于急诊与重症监护（胰腺炎、烧伤、创伤、脑膜炎）。硬膜外给予吗啡用于术后镇痛。剂量与间隔适当时，猫"吗啡狂躁"（morphine-manie）样兴奋罕见；犬通常出现镇静，最常见于高龄、幼年和危重患者。首选 IV（intraveineuse，静脉）与 IM（intramusculaire，肌内）给药（Steagall et al. 2006）；buprénorphine 与 méthadone 可经猫口腔跨黏膜（OTM, transmuqueuse orale）途径产生抗伤害感受。犬猫口服阿片类生物利用度极低，不应经口用于镇痛。研究显示 12 月龄猫比 6 月龄猫抗伤害感受更强；同批猫 6 月龄时 hydromorphone（氢吗啡酮）作用时间更短、幅度更小，提示 6 月龄幼猫可能需要更频繁的阿片类给药（Simon et al., 2019）。

2.4 不良反应

恶心呕吐、dysphorie、喘息（犬）、心动过缓、组胺释放（尤其吗啡与哌替啶快速静脉给药时）、（吗啡硬膜外给药后）尿失禁/尿潴留、呼吸抑制；不良反应通常与大剂量相关。较少见：厌食、躁动、便秘、低温或高温（猫使用氢吗啡酮后最常见）。上述不良反应均可通过 naloxone 或 butorphanol 谨慎滴定迅速消除——但镇痛作用也会同时被逆转。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 12：犬猫阿片类镇痛药及拮抗剂 naloxone 推荐（逐字还原）', '2.5 表 12：犬猫阿片类镇痛药及拮抗剂 naloxone 推荐（逐字还原）

缩写：IM Intramusculaire（肌内），iv Intraveineuse（静脉），OTM Transmuqueuse orale（口腔跨黏膜）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 12：犬猫阿片类镇痛药及拮抗剂 naloxone 推荐（逐字还原） (2)', '| Analgésique morphinique（阿片镇痛药） | 犬剂量与频次 | 猫剂量与频次 | Voie d''administration（途径） | Commentaires（注释） |
|---|---|---|---|---|
| Morphine（吗啡） | 0,3 à 0,5 mg/kg toutes les 2 à 4 heures | 0,2 à 0,3 mg/kg toutes les 4 à 6 heures | im | 静脉缓慢给药可行（法语抽取文本此处行尾截断："Voi ./ le r"，疑指避免快速静注）。但可能发生组胺释放 |
| Péthidine (mépéridine)（哌替啶） | 3 à 5 mg/kg toutes les 1 à 2 heures | 3 à 5 mg/kg toutes les 1 à 2 heures | im | 不得静脉给药，因组胺释放（行尾截断："s Ne pas administrer iv en raison de la libération d''histamine co"） |
| Méthadone（美沙酮） | 0,3 à 0,5 mg/kg toutes les 3 à 4 heures | 0,2 à 0,3 mg/kg toutes les 4 heures | im, iv, OTM‡ | 具 NMDA 受体拮抗特性。OTM 给药在猫产生抗伤害感受（行尾截断"OTM tion/g s/énér"） |
| Hydromorphone（氢吗啡酮） | 0,05 à 0,1 mg/kg toutes les 4 à 6 heures | 0,025 à 0,05 mg/kg toutes les 4 à 6 heures | im, iv | 可引起高热（行尾截断："hyperthermie ale/s (ht"） |
| Fentanyl（芬太尼） | Bolus 2 à 5 μg/kg + CRI 3 à 6 μg/kg/h | Bolus 1 à 3 μg/kg + CRI 2 à 3 μg/kg/h | iv | 为追求吸入麻醉药节约效应或最大镇痛可加大剂量（行尾混入页眉噪声："//o nline lib"） |
| Rémifentanil（瑞芬太尼） | 6 à 12 μg/kg/h | 4 à 6 μg/kg/h | iv | 为追求吸入麻醉药节约效应或最大镇痛可加大剂量。不需 bolus。瑞芬太尼活性约为芬太尼的一半 |
| Butorphanol（布托啡诺） | 0,2 à 0,4 mg/kg toutes les 1 à 2 heures | 0,2 à 0,4 mg/kg toutes les 1 à 2 heures | im, iv | 镇痛效力有限，仅适用于轻度疼痛管理 |
| Nalbuphine（纳布啡） | 0,3 à 0,5 mg/kg toutes les 2 à 4 heures | 0,2 à 0,4 mg/kg toutes les 2 à 4 heures | im, iv | 镇痛效力有限，仅适用于轻度疼痛管理。兽医研究很少 |
| Buprénorphine（丁丙诺啡） | 0,01 à 0,02 mg/kg toutes les 4 à 8 heures | 0,02 à 0,04 mg/kg toutes les 4 à 8 heures | im, iv, OTM‡ | 已有高浓度剂型（1,8 mg/ml）（目前仅美国）——该剂型按 0,24 mg/kg toutes les 24 heures、最长 3 天给药，用于猫术后疼痛控制。近期美国已批准丁丙诺啡透皮溶液：单剂涂抹于颈基部皮肤，可控制猫术后疼痛 4 天；给药体积为 1,2 à 3 kg 体重 0,4 ml (8 mg)，>3 à 7,5 kg 体重 1 ml (20 mg) |
| Naloxone (antagoniste)（纳洛酮，拮抗剂） | 0,04 mg/kg toutes les 0,5 à 1 heure | 0,04 mg/kg toutes les 0,5 à 1 heure | im, iv | 稀释后缓慢滴定至起效，以逆转阿片类诱导的不良反应。将 0,25 ml naloxone (0,4 mg/ml) 与 5 à 10 ml 生理盐水混合，以 1 ml/minute 缓慢输注该稀释液直至不良反应消失，以避免拮抗掉阿片镇痛 |', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 12：犬猫阿片类镇痛药及拮抗剂 naloxone 推荐（逐字还原） (3)', '†表注原文："Les doses peuvent être augmentées ou diminuées au cas par cas en fonction de la réponse individuelle et des autres médicaments administrés de façon concomitante. L''évaluation systématique de la douleur et les modifications des scores de douleur guident les décisions concernant le traitement antalgique."（剂量可根据个体反应与合用药物逐例增减；系统性疼痛评估与疼痛评分变化指导镇痛决策。）‡OTM 途径仅用于猫。', 'cat', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 禁忌、相互作用与注意事项', '2.6 禁忌、相互作用与注意事项

- 禁忌：兽医应权衡阿片类利弊——某些不良反应在疼痛管理为优先事项时可能不具临床意义。原文"Contre-indications"一节仅此一句，未列出具体禁忌清单。
- 相互作用：阿片类常与苯二氮䓬类、α2 肾上腺素能受体激动剂或乙酰丙嗪（acépromazine）联用作神经安定镇痛（neuroleptanalgésie） premédication；与 NSAIDs（Steagall et al. 2009）及局麻药在多模式镇痛中有协同作用。联合使用不同阿片类（如 butorphanol + buprénorphine、butorphanol + hydromorphone）效应不可预测，不推荐。
- 注意事项：人与实验动物有耐受报道，但兽医短期使用很少成为问题。阿片诱导的痛觉过敏（hyperalgésie）见于人与大鼠报道，宠物临床实践中尚未见文献记录。

2.7 无阿片/阿片节约麻醉（anesthésie sans morphiniques / avec épargne morphiniques）

国际兽医界并非总能获得阿片类，导致动物不必要痛苦和兽医人员同情疲劳。替代方案包括多模式镇痛（局麻药、NSAIDs 与其他辅助镇痛药），即所谓阿片节约麻醉或无阿片麻醉。文献要点：

- 一项无阿片注射方案（im）研究：kétamine 5 mg/kg + midazolam 0,25 mg/kg + dexmédétomidine 40 μg/kg 用于行卵巢子宫切除术的猫，术后另予 bupivacaïne（布比卡因）腹腔内 2 mg/kg 与 méloxicam（美洛昔康）0,2 mg/kg。麻醉可满足手术，但大多数猫术后镇痛不理想，补救性镇痛比例成年猫高于幼猫（Diep et al., 2020）。
- 后续研究比较无阿片方案与阿片节约方案（术前给予单次 buprénorphine）：单剂丁丙诺啡消除了术后补救镇痛需求（节约组 0/14 对比无阿片组 5/14 需要补救镇痛）（Rufiange et al. 2022）。
- 幼猫研究：多模式组术前予 méloxicam、术中腹腔内予 bupivacaïne；对照组补救镇痛发生率 15/15，多模式组 1/14（Malo et al., 2022）。
- 延伸阅读（原文列出）：Steagall et al. 2014、Bortolami & Love 2015、Simon & Steagall 2017、Kongara 2018。

3. NSAIDs 与其他抗炎药', 'cat', 'young', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 机制与适应证', '3.1 机制与适应证

NSAIDs 具解热、抗炎与镇痛作用（表 13），多经口给药，部分有注射剂型；主要经肝代谢，经胆汁（粪便）和尿液排泄。作用于花生四烯酸级联：抑制环加氧酶（cyclooxygénases, COX）活性及 ensuing 前列腺素生成，或像 piprant 类那样阻断前列腺素与其受体的相互作用（图 23）。COX-1 产生的前列腺素参与血管稳态、胃保护、肾血流与凝血等生理过程；COX-2 虽与某些生理功能有关，主要在组织损伤后释放产生炎症性前列腺素（Monteiro et Steagall 2019a）。抑制 COX 带来镇痛（抑制炎症与疼痛）的同时也可带来不良反应（抑制生理功能）；不同 NSAIDs 对 COX-1/COX-2 抑制程度不同。COX 抑制型 NSAIDs 是围手术期以及骨关节炎（arthrose）、癌症和其他炎症性疾病等急慢性疼痛状态的有效镇痛药，可单独或与辅助治疗联用（视疼痛严重程度）。用于慢性疼痛（如骨关节炎）时常滴定至最低有效剂量，并应结合细致的重新评估（Wernham et al. 2011）；个体疗效不一，应答不满意时可换用另一种 NSAIDs 并设适当的治疗空窗期（période de vide thérapeutique，见 1.14 章）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原）', '3.2 表 13：犬猫 NSAIDs 剂量推荐（逐字还原）

缩写：iv Intraveineuse，SC Sous-cutanée（皮下），IM Intramusculaire，OTM Transmuqueuse orale，PO Orale（口服）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (2)', '| Substance（药物） | Indication（适应证） | Espèce, Dose‡, Voie d''administration（种属、剂量、途径） | Fréquence（频次） |
|---|---|---|---|
| Carprofène（卡洛芬） | Douleur chirurgicale（手术疼痛） | Chiens : 4 à 4,4 mg/kg SC, iv, PO | Toutes les 24 heures pendant 4 jours maximum |
| Carprofène | Douleur chirurgicale | Chiens : 2 à 2,2 mg/kg SC, iv, PO | Toutes les 12 heures pendant 4 jours maximum |
| Carprofène | Douleur chirurgicale | Chats : 2 à 4 mg/kg SC, iv | Une seule dose ; ne pas poursuivre avec dosage supplémentaire |
| Carprofène | Douleur chronique（慢性疼痛） | Chiens : 4 à 4,4 mg/kg PO | Toutes les 24 heures ; utiliser la dose efficace la plus faible |
| Carprofène | Douleur chronique | Chiens : 2 à 2,2 mg/kg PO | Toutes les 12 heures ; utiliser la dose efficace la plus faible |
| Cimicoxib（司马考昔） | Douleur chirurgicale | Chiens : 2 mg/kg PO | Toutes les 24 heures pendant 4 à 8 jours |
| Cimicoxib | Douleur chronique | Chiens : 2 mg/kg PO | Toutes les 24 heures ; utiliser la dose efficace la plus faible |
| Déracoxib（代拉考昔） | Douleur chirurgicale | Chiens : 3 à 4 mg/kg PO | Toutes les 24 heures pendant 7 jours maximum |
| Déracoxib | Douleur chronique | Chiens : 1 à 2 mg/kg PO | Toutes les 24 heures ; utiliser la dose efficace la plus faible |
| Enflicoxib（恩利考昔） | Douleur arthrosique（骨关节炎性疼痛） | Chiens : dose de charge de 8 mg/kg suivie de 4 mg/kg PO | Une fois par semaine |
| Firocoxib（非罗考昔） | Douleur chirurgicale | Chiens : 5 mg/kg PO | Toutes les 24 heures pendant 3 jours maximum |
| Firocoxib | Douleur chronique | Chiens : 5 mg/kg PO | Toutes les 24 heures ; utiliser la dose efficace la plus faible |
| Flunixine méglumine（氟尼辛葡甲胺） | Pyrexie（发热） | Chiens et chats : 0,25 mg/kg SC | Une fois |
| Flunixine méglumine | Interventions chirurgicales et ophtalmiques（手术与眼科操作） | Chiens et chats : 0,25 à 1,0 mg/kg SC | Toutes les 12 à 24 heures pour 1 ou 2 traitements |
| Grapiprant（格拉匹兰特） | Douleur arthrosique | Chiens : 2 mg/kg PO | Toutes les 24 heures |', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (3)', '| Kétoprofène（酮洛芬） | Douleur chirurgicale et chronique | Chiens : 2,0 mg/kg, iv, SC, im | Une fois postopératoire |
| Kétoprofène | Douleur chirurgicale et chronique | Chiens : 1,0 mg/kg PO | Toutes les 24 heures pendant 4 jours maximum |
| Kétoprofène | Douleur chirurgicale et chronique | Chats : comme pour les chiens | （同犬） |
| Mavacoxib（玛伐考昔） | Douleur chronique | Chiens : 2 mg/kg PO | Une dose au jour 0 et une autre au jour 14. Puis une fois par mois jusqu''à 5 fois |
| Méloxicam（美洛昔康） | Douleur chirurgicale/aiguë | Chiens : 0,2 mg/kg intraveineuse SC | Une fois |
| Méloxicam | douleur musculo-squelettique（肌肉骨骼疼痛） | Chiens : 0,1 mg/kg PO | Toutes les 24 heures |
| Méloxicam | douleur musculo-squelettique | Chats : 0,2 à 0,3 mg/kg SC | Une seule dose |
| Méloxicam | douleur musculo-squelettique | Chats : 0,05 mg/kg PO | Toutes les 24 heures pendant 5 jours maximum |
| Méloxicam | Douleur chronique | Chiens : 0,2 mg/kg PO | Une fois le jour 1 |
| Méloxicam | Douleur chronique | Chiens : 0,1 mg/kg PO | Toutes les 24 heures après le jour 1 ; utiliser la plus faible dose efficace |
| Méloxicam | Douleur chronique | Chats : 0,1 mg/kg PO | Une fois le jour 1 |
| Méloxicam | Douleur chronique | Chats : 0,05 mg/kg PO | Toutes les 24 heures après le jour 1 ; utiliser la plus faible dose efficace |
| Métamizole (dipyrone)（甲氧苯丙酸钠/安乃近） | Douleur aiguë | Chiens et chats : 25 mg/kg iv | Toutes les 8 à 12 heures |
| Paracétamol (acétaminophène)（对乙酰氨基酚/扑热息痛） | Douleurs chirurgicales/aiguës ou chroniques | Chiens SEULEMENT : 10 à 15 mg/kg PO | Toutes les 8 à 12 heures. Ne pas utiliser chez le chat |
| Paracétamol (acétaminophène) | Douleurs chirurgicales/aiguës ou chroniques | Chiens SEULEMENT : 10 mg/kg iv au-delà de 15 mn | Toutes les 8 à 12 heures. Ne pas utiliser chez le chat |
| Piroxicam（吡罗昔康） | Inflammation des voies urinaires inférieures（下尿路炎症） | Chiens : 0,3 mg/kg PO | Toutes les 24 heures pour deux traitements, puis toutes les 48 heures |', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (4)', '| Robénacoxib（罗贝考昔） | Douleur chirurgicale/aiguë douleur musculo-squelettique | Chiens : 2 mg/kg SC | Toutes les 24 heures pendant 3 jours maximum |
| Robénacoxib | Douleur chirurgicale/aiguë douleur musculo-squelettique | Chiens : 1 à 2 mg/kg PO | Toutes 24 heures |
| Robénacoxib | Douleur chirurgicale/aiguë douleur musculo-squelettique | Chats : 2 mg/kg SC | Toutes les 24 heures pendant 3 jours maximum |
| Robénacoxib | Douleur chirurgicale/aiguë douleur musculo-squelettique | Chats : 1 à 2 mg/kg PO | Toutes 24 heures |
| Robénacoxib | Douleur chronique | Chiens : 1 mg/kg PO | Toutes les 24 heures ; utiliser la dose efficace la plus faible |
| Robénacoxib | Douleur chronique | Chats : 1 mg/kg PO | Toutes les 24 heures ; utiliser la dose efficace la plus faible |
| Acide tolfénamique（托芬那酸） | Douleur aiguë et chronique | Chiens : 4 mg/kg SC, im, PO | Toutes les 24 heures pendant 3 à 5 jours. Répéter une fois par semaine |
| Acide tolfénamique | Douleur aiguë et chronique | Chats : comme pour les chiens | （同犬） |', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 13：犬猫 NSAIDs 剂量推荐（逐字还原） (5)', '表 13 脚注：†脚注原文为交叉错乱文本，可辨认部分为"…post-opératoire ou douleurs chroniques… dans plusieurs pays la disponibilité des produits vétérinaires homologués, l''étiquette fournira les meilleurs renseignements sur l''utilisation du produit en fonction du pays où il est homologué. Les vétérinaires devraient privilégier l''utilisation…"（各国获批兽药的可得性不同，标签提供按获批国使用的最佳信息；兽医应优先使用获批兽药产品。其余部分法语抽取文本断裂，需核对原 PDF）。‡Dose en fonction du poids maigre（按瘦体重计剂量）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · NSAIDs 不良反应与禁忌', '3.3 NSAIDs 不良反应与禁忌

不良反应最常见为胃肠道（厌食、呕吐、腹泻、食欲下降）；较少见的其他不良反应包括血小板聚集减少及肾、肝毒性。胃肠道效应通常自行缓解，但给药不当时可发生溃疡和穿孔（Lascelles et al., 2005）。NSAIDs 后可出现无临床意义的血小板聚集下降（Lemke et al. 2002），健康动物不应成为顾虑；但使用 COX-1 选择性（原文如此：médicaments sélectifs de la COX-1）药物或阿司匹林时需谨慎——阿司匹林在整个血小板寿命期内抑制 COX，应避免术前使用，仅在手术结束、确认止血后给药。肝毒性很少报道，多数认为属特质性反应（MacPhail et al., 1998）；长期使用建议通过远程医疗或体检并逐例血液学检查定期监测。

禁忌：未控制的胃肠道疾病、肝病、凝血障碍、低血容量、脱水或低血压。患有慢性疼痛且慢性肾病稳定［国际肾病_interest 协会（IRIS）1–3 期］的猫，在密切监测下可用 méloxicam 或 robénacoxib 治疗（Monteiro et al. 2019）。总体上 NSAIDs 不良反应发生率似较低，多数临床研究未显示与安慰剂在不良反应方面有显著差异（Monteiro-Steagall et al. 2013），但多数此类研究并非为此差异设计；一旦发生不良反应可对患者造成毁灭性后果，应考虑其他镇痛方式。轻例应立即停用 NSAIDs 并给予对症治疗（液体治疗与胃黏膜保护剂）；重例可能需要手术与重症监护（Lascelles et al. 2005）。不良反应应报告给药企或区域监管机构（如美国 FDA 兽药中心或英国兽药管理局 VMD）。

药物相互作用：不应与糖皮质激素或其他 NSAIDs（包括阿司匹林）同时或前后接近给药。与血管紧张素转换酶抑制剂、利尿剂、华法林、苯巴比妥或化疗药物联用应谨慎。

3.4 更换另一种 NSAIDs（Passage à un autre AINS）

不同动物对不良反应的耐受性和临床应答存在差异；出于镇痛无效或出现不良反应两种原因，均可能适合换用另一种（COX 抑制或非抑制）NSAIDs。因无效换药时应考虑治疗空窗期（不给予 NSAIDs）：最谨慎做法是空窗几天，但无科学证据证明其必要，也无证据确定合适时长。若因胃肠道不良反应换用 COX-2 抑制药，快速换药可能延迟愈合并加重损伤，此情形可能需要空窗 7 天。犬（但猫不可）可在空窗期使用 paracétamol（acétaminophène）。不推荐围手术期更换 NSAIDs（患者已在用某种 NSAIDs 则继续使用同一药物）。据作者经验，从 grapiprant 换用 NSAIDs 时无需空窗期，但尚无安全性评估研究。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 其他抗炎药物', '3.5 其他抗炎药物

- Grapiprant 被视为 NSAIDs——一种不抑制 COX 的 NSAIDs，属 piprant 类（PGE2 受体拮抗剂），在花生四烯酸级联更靠后的阶段阻止 PGE2 与其受体结合（图 23）；精确地说为 EP4 受体拮抗剂，已在部分国家获批用于犬骨关节炎疼痛与炎症；其安全性与有效性经骨关节炎犬的随机安慰剂对照临床试验证实（Rausch-Derra et al., 2016）。
- Paracétamol（acétaminophène）：据信作用于中枢神经系统内 COX-1 的一个亚型；具镇痛与解热特性，但抗炎活性很小（Pacheco et al. 2020）。围手术期口服与静脉对乙酰氨基酚在骨科或软组织手术犬中被证明不劣于获批 NSAIDs（Hernández-Avalos et al. 2020）；有争议的是卵巢子宫切除术后犬使用对乙酰氨基酚与生理盐水静脉输注的术后疼痛评分无显著差异（Leung et al. 2021）。对乙酰氨基酚单用或与 codéine（可待因）联用在多模式方案中 anecdote 性地用于犬慢性疼痛，但支持其用于犬急慢性疼痛的证据很少（Budsberg et al. 2020）。猫严格禁用对乙酰氨基酚，因发生高铁血红蛋白血症（méthémoglobinémie）风险增加。
- Métamizole (dipyrone)：亦为弱抗炎药，具镇痛、解热与解痉特性，主要通过抑制中枢神经系统内 COX-1 亚型实现；在多个国家获批用于犬围手术期，可与 NSAIDs 联用（Zanuzzo et al. 2015）。犬猫均有疗效证据（Imagawa et al. 2011, Teixeira et al. 2020, Pereira et al. 2021）：行卵巢子宫切除术的猫，métamizole 25 mg/kg q24 或 12,5 mg/kg q12h 与 méloxicam 0,1 mg kg q24h 产生相似镇痛效应（Pereira et al. 2021）。
- Glucocorticoïdes（糖皮质激素）：因强效抗炎作用在炎症性疾病中有镇痛作用，但常与不良反应相关，不应被视为镇痛药；疼痛非炎症所致时糖皮质激素不是有效的镇痛选择。

4. α2 肾上腺素能受体激动剂（Agonistes des récepteurs alpha2-adrénergiques）', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 机制与适应证 (2)', '4.1 机制与适应证

α2 激动剂产生镇静、催眠、镇痛与肌松（表 14）；该类药物的特异性与效力不同；给予拮抗剂（atipamézole 或 yohimbine，育亨宾）可逆转，但镇痛作用也随之被逆转。镇静效应依分子、途径与剂量持续 30 à 90 minutes；经肝代谢、肾排泄（Murrell et Hellebrekers, 2005）。药物与脊髓背角（脊髓镇痛）、大脑皮质与蓝斑（supraspinale，上位性镇静镇痛）的 α2 肾上腺素受体亚型结合；去甲肾上腺素（norépinéphrine）为内源性配体。通过复杂机制抑制兴奋性神经递质释放、引起膜超极化，与阿片类类似。α2 激动剂也与血管内皮受体结合，引起外周血管收缩、体循环与肺循环血管阻力升高，并剂量依赖性地降低心输出量。

广泛用于非侵入性操作的镇静、神经安定镇痛与平衡麻醉方案；可在许多临床情形中作为辅助镇痛药，补完镇痛并减轻应激反应。小剂量（dexmédétomidine 1 à 2 μg/kg iv）可在麻醉苏醒期给予，尤其出现意识混乱综合征与烦躁时。其使用通常限于能耐受显著血流动力学变化的健康动物和/或野生及未社会化动物（Pypendop et Verstegen 1998）。α2 激动剂与阿片类同用可因协同效应改善镇痛、减少阿片需求（Pascoe et al. 2006）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 14：α2 肾上腺素能受体激动剂/拮抗剂药理学特性（逐字还原）', '4.2 表 14：α2 肾上腺素能受体激动剂/拮抗剂药理学特性（逐字还原）

| Substance | Composants（成分） | Agoniste ou antagoniste | Alpha 1 : Alpha 2 Sélectivité（选择性） | Durée d''action (analgésie)†（镇痛时程） | Durée d''action (sédation)†（镇静时程） |
|---|---|---|---|---|---|
| Médétomidine | Dexmedetomidine et Levomedetomidine | Agoniste | 1 : 1620 | 1 heure | 2 à 4 heures |
| Dexmédétomidine | Dexmédétomidine | Agoniste | 1 : 1620 | 1 heure | 2 à 4 heures |
| Xylazine（赛拉嗪） | Xylazine | Agoniste | 1. 160 | 15 à 30 minutes | 1 à 2 heures |
| Romifidine（罗米替定） | Romifidine | Agoniste | 1 : 340 | Non déterminé | 1 à 2 heures |
| Atipamézole（阿替美唑） | Atipamézole | Antagoniste | 1. 8500 | S/O | S/O |
| Yohimbine（育亨宾） | Yohimbine | Antagoniste | Moins sélectif pour le récepteur alpha2 que l''atipamézole（对 α2 受体的选择性低于阿替美唑） | S/O | S/O |

†镇痛与镇静效应时程均为剂量依赖。S/O = 原文如此。选择性两行"1. 160"与"1. 8500"原文用句点，未改为冒号，照抄。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 输注、口服凝胶、不良反应与禁忌', '4.3 输注、口服凝胶、不良反应与禁忌

- 恒速输注（CRI, Constant Rate Infusion）：dexmédétomidine 或 médétomidine CRI 在犬猫围手术期提供延长镇静/镇痛日益常用，可弥补单次给药作用时间短的局限；CRI 下显著降低吸入麻醉药最低肺泡有效浓度（CAM/MAC）同时保持麻醉深度稳定。术后保持镇静但动物仍能对外界刺激作出反应，有利于频繁评估及患者行走与排泄需求；但意外觉醒（如巨响或疼痛刺激）可能导致定向障碍与防御性咬伤。研究剂量通常为 dexmédétomidine 1 μg/kg/heure， preceded 负荷剂量 1 à 2 μg/kg（Lin et al. 2008, Valtolina et al. 2009）。
- 口服 dexmedetomidine 凝胶（0,1 mg/ml）：商品化用于犬噪音厌恶管理，涂于颊黏膜与牙龈之间；推荐剂量不足以诱导完全镇静，但被证明可减轻焦虑，可能通过降低蓝斑活动实现（Korpivaara et al. 2017）；其在兽医就诊等其他情境的抗焦虑作用尚未探索。
- Détomidine（detomidine，去甲托米定）凝胶（7,6 mg/ml）：马的镇静与化学保定用，舌下给药。犬经口 0,35 à 2,0 mg/m² 已评估用于便利保定与短时低侵入操作（Hopfensperger et al. 2013, Messenger et al. 2016, Kasten et al. 2018）：达峰镇静约 45 minutes、持续约 30 minutes，心脏效应与静脉给药类似（原文此处抽取断裂："ces deux derniers"疑指与静脉给药相比），镇静可用 atipamézole 逆转。健康猫 4 mg/m² 出现镇静不一且所有病例均呕吐，提示该技术在猫不太理想（Smith et al., 2020）。
- 不良反应：最常见为高血压或低血压、心动过缓、低温、副交感张力与肠道活动下降、尿量增加、一过性低血糖与低胰岛素血症；较少见呕吐、流涎、缓慢性心律失常（Granholm et al. 2006, 2007）。
- 禁忌/预防：禁用于伴或不伴心律失常与传导障碍的心肺疾病、严重全身性疾病、既存低/高血压、糖尿病、肝功能衰竭或肾病动物；曾受创伤的患者需特别注意（Lamont et al. 2002）。存在外周血管收缩与高血压时，禁与抗胆碱能药联用。
- 外周作用 α2 拮抗剂 Vatinoxan/MK-467：与 α2 激动剂联用，防止外周介导的血管收缩，从而减轻 α2 激动剂后的反射性心动过缓（Kallio-Kujala et al. 2018），并证明较单用 α2 激动剂改善犬心输出量（Honkavaara et al. 2011）。犬猫研究表明镇静与镇痛效应基本不变，而心血管与神经内分泌效应减弱。2022 年 3 月，美国（原文此处药物监管机构名前缺失，应为药品管理局，抽取断裂）批准 médétomidine 与 vatinoxan 盐酸盐注射剂复方用于犬小手术的镇静与镇痛。
- 特殊注意：某些动物似不受 α2 激动剂影响、镇静不佳，常与既存强烈兴奋状态有关。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 局部麻醉药（Anesthésiques locaux, AL）', '5. 局部麻醉药（Anesthésiques locaux, AL）

5.1 机制与理化特性

局麻药主要通过阻断电压门控 Na+ 通道的钠内流，抑制膜去极化、兴奋与神经传导。价廉、不受管制、全球易得，为 WSAVA 犬猫基本药物清单基本药物（Steagall et al., 2020a），在犬猫疼痛管理中有广泛应用潜力。伴侣动物最常用 lidocaïne（利多卡因）、mépivacaïne（甲哌卡因）、bupivacaïne（布比卡因）、ropivacaïne（罗哌卡因），均属酰胺类（aminoamides）。局麻药为弱碱，按 pKa 在体内达到平衡；pKa 是药物 50% 离子化/50% 非离子化时的 pH——只有非离子型可穿过神经膜到达电压门控 Na+ 通道，而离子型结合通道受体位点阻断 Na+ 内流。因此 pKa 接近生理 pH 的药物（如利多卡因）起效更快（生理 pH 下非离子比例更高）。其他影响特性的理化因素为分子量、脂溶性与蛋白结合力（encadré 4）：分子量与组织扩散能力成反比；脂溶性决定效价与作用时程（低脂溶性者效价低、时程短；高脂溶性者因被髓鞘捕获而起效潜时更长）；蛋白结合决定作用时程（蛋白结合高者与 Na+ 通道受体位点结合更牢，时程更长）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 15：局麻药理化性质与最大推荐剂量（逐字还原）', '5.2 表 15：局麻药理化性质与最大推荐剂量（逐字还原）

| Anesthésique local | pKa / délai d''apparition (minutes)（pKa/起效时间） | Liaison aux protéines / durée d''action (heures)（蛋白结合/作用时程） | Puissance（效价） | Dose maximale recommandée (mg/kg)† |
|---|---|---|---|---|
| Lidocaïne | 7,8 / 5 à 10 | Modérée / 1 à 1,5 | Modérée | Canin : 5；Félin : 5 |
| Bupivacaïne | 8,1 / 20 à 30 | Longue / 3 à 10 | Forte | Canin : 2；Félin : 2 |
| Ropivacaïne | 8,1 / 20 à 30 | Longue / 3 à 6 | Forte | Canin : 2；Félin : 2 |
| Mépivacaïne | 7,7 / 5 à 10 | Modérée / 1,5 à 2 | Modérée | Canin : 5；Félin : 3 |

†原文表注："Les anesthésiques locaux peuvent induire une hypotension, une bradycardie et un arrêt cardiaque lorsque leurs concentrations systémiques atteignent des niveaux toxiques. L''administration doit être arrêtée immédiatement si des signes de toxicose apparaissent"（血药浓度达中毒水平时可致低血压、心动过缓与心脏停搏；出现中毒征象须立即停止给药）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 全身毒性及其处理', '5.3 全身毒性及其处理

意外过量时更易发生全身毒性，猫与小型犬尤甚。影响因素：注射部位（静脉内注射吸收最快，血药浓度高、毒性风险大；意外静脉或动脉内注射是重要风险因素，bupivacaïne 尤甚）；药物本身（bupivacaïne 因与心脏电压门控 Na+ 通道解离缓慢而特别具心脏毒性）。心血管效应：心肌传导减慢、心肌抑制与外周血管扩张综合作用，血药浓度达中毒水平时可发生低血压、心动过缓乃至心脏停搏。中枢神经效应：局麻药脂溶性高、分子量小，易过血脑屏障；高浓度可致惊厥，随后广泛中枢抑制。

处理（Prise en charge de la toxicité）：以支持与对症治疗为主（如控制惊厥）。苯二氮䓬类处理惊厥，配合氧疗、必要时气管插管与通气；心脏毒性可能需要补液与正性肌力药。脂肪乳剂（solutions lipidiques）可在血浆中 creating 脂质区室，吸引脂溶性化合物（如局麻药），将其从血浆水相中分离，直接对抗局麻药毒性（Weinberg et al. 2003, O''Brien et al. 2010, Muller et al. 2015）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 静脉输注利多卡因', '5.4 静脉输注利多卡因

利多卡因可经 CRI 全身给药以提供镇痛并减少维持麻醉所需吸入麻醉药浓度（MAC 节约效应），机制通常认为是多重的：全身给药后的血药浓度过低，不足以直接阻滞钠通道，因此抑制细胞因子生成与 NMDA 受体抑制的机制被认为更重要。腹部手术患者的数据令人信服地表明围手术期利多卡因具镇痛节约效应，减少术后阿片类消耗；其他手术类型的证据较弱（Sun et al., 2012）。犬的研究有的显示该输注可减少术中伤害性刺激（血压心率变化）与术后疼痛，有的未显示获益（Tsai et al. 2013, Gutierrez-Blanco et al. 2015）。研究剂量包括负荷 2 mg/kg 后 50 μg/kg/minute 恒速输注，各研究的负荷量与输注速率不一。犬利多卡因 CRI 的 MAC 节约效应证据更强，对需高浓度吸入麻醉维持的低压动物有益（Wilson et al. 2008, Moran-Muñoz et al. 2014）；输注期间应精细调节吸入麻醉药浓度。猫方面，由于潜在心血管不良反应，使用存在争议（原文"Les utilisation des inhibiteurs de la recapture de la lidocaïne"为抽取断裂的病句，需核对原 PDF）：实验研究显示猫利多卡因 CRI 对异氟烷亦有显著 MAC 节约效应，但出现负面血流动力学效应（Pypendop et Ilkiw 2005）。因此猫的利多卡因输注应谨慎使用，存在血流动力学抑制风险；但在严重伤害性刺激与高动力状态（高血压与心动过速）的猫，利多卡因可作为猫多模式镇痛的组成。脂质体布比卡因长效注射悬液见下节。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 给药技术与装置（2.6 Techniques d''administration）', '6. 给药技术与装置（2.6 Techniques d''administration）

给药技术影响疗效；药物递送系统对 minimizing 毒性、maximizing 疗效很重要。缓释剂型设计为在数小时或数天内缓慢释放药物：可提供"非干预式"镇痛、减少全身不良反应与药物蓄积、减小血药浓度波动、免用输注装置（Krugner-Higby et al., 2011）。

- 透皮贴片（Dispositifs transdermiques, TD）：fentanyl、lidocaïne、buprénorphine 贴片为人用获批贴剂，经储库型或基质型贴剂经皮按时递送药物（Hofmeister et Egger 2004, Murrell et al. 2007, Weil et al. 2007）。储库型贴片用于伴侣动物结果喜忧参半：吸收取决于皮肤厚度、温度、血管分布等，且黏胶常无法维持与皮肤的持续接触；透皮贴片不排除仍需局麻药与其他镇痛技术。猫芬太尼贴片的镇痛效应因个体吸收与药代动力学差异而多变（Egger et al., 2003）；骨科手术犬芬太尼贴片与 NSAIDs 合用可提供足够的术后镇痛（Hofmeister et Egger, 2004）。芬太尼贴片作用时间长，须在需要镇痛前 12 heures（猫）至 24 heures（犬）贴好。基质型芬太尼贴片因药物整合入贴体而不易被转移滥用。猫用丁丙诺啡透皮贴片虽有可检测血药浓度但未提高热痛阈（Murrell et al., 2007）；犬用丁丙诺啡贴片提高了热痛阈（Pieper et al., 2011）。需进一步试验确定临床适用性。
- 缓释剂型（Formulations à libération prolongée）：长效脂质体布比卡因（suspension injectable de liposome de bupivacaïne）注射悬液已在美国获批用于外周神经阻滞：单次神经周围给药后猫远端肢体手术、犬前十字韧带手术渗透给药后可控制术后疼痛至多 72 heures（Lascelles et al. 2016, Gordon-Evans et al. 2020, Reader et al. 2020）。该商品化脂质体布比卡因未在 5 月龄以下猫或其他区域技术中研究过。优点：由术者放置、可保证至多 3 天镇痛，不依赖主人及其护理。
- 静脉输注：恒速输注经电子输注装置连续给予既定方案以维持恒定血药浓度；变流量输注更合适（可按镇痛需求与不良反应出现与否调节剂量以达到效应）；目标控制输注（perfusion à débit contrôlé）用复杂算法调节输注装置给药以达到指定部位的目标血药浓度。输注装置通常是容积式输液泵（蠕动式、活塞式、梭式），可输注大容量但精度较低（原文"faible précision ( 10%)"，百分号前符号抽取缺失，疑为 ±10%）；注射泵适合输注更高浓度镇痛制剂，精度更高（±5 %）。计算功能允许输入体重、药物浓度与输注速率（Amoore et Adamson, 2003），但输错浓度或方案时仍可能出错。
- 伤口输注导管（Cathéters de perfusion de plaie）：柔性导管置入手术创口内或旁侧，重复给予局麻药（Abelson et al. 2009）。持续输注导致组织分布不均（Hansen et al., 2013），最好作为多模式镇痛方案的组成部分使用。
- 硬膜外导管（Cathéters périduraux）：可用商业套件（规格 19、20 与 24）置入，重复硬膜外给药；最常置于腰荐椎间隙，可在术后较长时间内持续或间歇给予镇痛药。置管操作、诱发的低温与败血症污染是最常见并发症（Valverde 2008）。
- 神经刺激器与神经定位：用于辅助臂丛神经、股神经或胫神经阻滞、硬膜外镇痛及其他局部阻滞；便利进针、可缩短起效时间、延长作用时程并降低神经损伤风险；为恒流发生器（低频低周期）连接绝缘针与皮肤电极，针尖向神经推进至出现运动反应，注入药物时神经被机械推移、运动反应停止（Campoy et al. 2012）。局麻药注射体积为 0,05 à 3 ml/kg。坐骨神经与股神经阻滞等示例见 WSAVA GPC 网站视频。
- 超声引导技术：可用于若干外周神经阻滞；与神经刺激器一样旨在降低有效阻滞所需局麻药剂量、减少局麻药毒性风险并提高成功率；可显示神经、血管与周围结构，应能尽量减少神经损伤、血肿与出血等并发症，但需要培训与昂贵/专用设备；相关综述见 Portela et al. 2018a b。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 辅助（adjuvant）治疗（2.7 Traitements adjuvants', '7. 辅助（adjuvant）治疗（2.7 Traitements adjuvants）

辅助治疗不被视为"自主"镇痛药，可与阿片类、NSAIDs 与局麻药联合纳入疼痛管理方案，或在上述某类镇痛药有禁忌时替代之（Ruel et Steagall 2019）（表 16）。

7.1 Kétamine（氯胺酮）

机制：NMDA 受体激活是中枢敏感化启动与维持的主要因素之一；kétamine 可逆性拮抗 NMDA 受体，调制中枢敏感化并发挥抗痛觉过敏效应。亦可能有免疫调节作用并直接抑制促炎细胞因子生成（Beilin et al. 2003）。适应证：在重大侵袭手术及创伤患者的多模式围手术期疼痛管理中预防与治疗中枢敏感化；亦可给予有明显痛觉过敏与异常性疼痛（allodynie）征象的慢性疼痛患者。手术犬可见术后镇痛改善与食欲改善（Wagner et al. 2002, Sarrau et al. 2007）；但猫的镇痛数据缺乏。创伤患者应尽早开始治疗。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 16：犬猫辅助镇痛药剂量推荐（逐字还原）', '7.2 表 16：犬猫辅助镇痛药剂量推荐（逐字还原）

缩写：iv Intraveineuse，SC Sous-cutanée，IM Intramusculaire，PO Orale；详见正文的适应证与禁忌。CRI = 恒速输注。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 16：犬猫辅助镇痛药剂量推荐（逐字还原） (2)', '| Substance | Indications | Espèce, dose, voie d''administration | Fréquence | Commentaires |
|---|---|---|---|---|
| Amantadine（金刚烷胺） | Douleur chronique | Chiens et chats : 2 à 5 mg/kg PO | Toutes les 12 à 24 heures | 对 AINS 单药治疗无效的骨关节炎犬有效；与 NSAIDs 或其他镇痛药同用。有报道金刚烷胺与 méloxicam 联用于神经病理性疼痛犬的剂量高达 14 mg/kg（Madden et al. 2014） |
| Amitriptyline（阿米替林） | Douleur chronique | Chiens : 1 à 4 mg/kg | Toutes les 12 à 24 heures | 不与其他 5-羟色胺（sérotoninergique）能药物同时给予 |
| Amitriptyline | Douleur chronique | Chats : 2,5 à 12,5 mg au total | Toutes les 12 à 24 heures | 适口性差；经口给药可能不可行。不与其他 5-羟色胺能药物联用 |
| Gabapentine（加巴喷丁） | Douleur périopératoire | Chiens : 10 mg/kg PO | 2 heures avant l''intervention | 与阿片类联用 |
| Gabapentine | Douleur périopératoire | Chats : 50 mg PO total | À 12 heures et 1 à 2 heures avant l''intervention chirurgicale | 与阿片类联用 |
| Gabapentine | Douleur chronique | Chiens et chats : 5 à 10 mg/kg PO | Toutes les 8 à 12 heures | 从 3 à 5 mg/kg 起始，逐步递增至目标剂量；按治疗反应增减剂量；有更高剂量的轶事报道；慢性肾病猫推荐减量。可致镇静与共济失调 |
| Gabapentine | Transport et visite vétérinaire contrainte connexe（强制性转运与就诊相关） | Chats : études ayant rapporté des intervalles de doses de 50 à 200 mg PO total | 90 minutes avant le transport du chat jusqu''au vétérinaire | 该情形下加巴喷丁用于减少转运与体检相关应激与焦虑；若已安排手术，也可能有助术后镇痛 |
| Prégabaline（普瑞巴林） | Douleur chronique | Chiens : 2 à 5 mg/kg PO | Toutes les 8 à 12 heures | 自更低剂量和/或更长给药间隔起始，逐步递增至目标剂量。有空泡肌病相关神经病理性疼痛犬 13 à 19 mg/kg toutes les 12 heures 的报道（Thoefner et al. 2020）。可在椎间盘手术前 1 heure 给予单次，术后每 8 heures 给药持续 5 天（原文"syringomyélie"按上下文照抄为脊空洞症相关；"chirurgie discale intervertébrale"即椎间盘手术）。 |
| Prégabaline | Douleur chronique | Chats : 1 à 4 mg/kg PO | Toutes les 12 heures | 可致镇静与共济失调 |
| Prégabaline | Stress lié au transport（转运相关应激） | Chats : 5 à 10 mg/kg PO | 90 minutes avant le transport du chat | 该情形下普瑞巴林用于减少转运相关应激与焦虑 |', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 16：犬猫辅助镇痛药剂量推荐（逐字还原） (3)', '| Kétamine | Douleur périopératoire | Chiens : 0,2 à 0,5 mg/kg iv (bolus) puis 2 à 10 μg/kg/minute (CRI) | Bolus (dose de charge avant la chirurgie) puis CRI pendant 72 heures maximum | 术中采用更高输注速率，术后调低 |
| Kétamine | Douleur périopératoire | Chats : 0,2 à 0,5 mg/kg iv (bolus) puis 2 à 10 μg/kg/minute (CRI) | CRI pendant 72 heures maximum | 术中采用更高输注速率，术后调低；某些猫在较高剂量时可能出现麻醉征象 |
| Tramadol（曲马多） | Douleur périopératoire | Chats : 2 à 4 mg/kg PO, iv ou im | Utilisé pour la prémédication en combinaison avec des sédatifs | 不与其他 5-羟色胺能药物同时给予 |
| Tramadol | Douleur chronique | Chats : 2 à 4 mg/kg PO | Toutes les 8 à 12 heures | 适口性差；经口给药可能不可行。不与其他 5-羟色胺能药物同时给予 |

注：表 16 中 amitriptyline 犬行的"voie d''administration"列在抽取文本中未单独标出（PO 仅见于猫相关上下文），照抄原表；prégabaline 的"13 à 19 mg/kg"评注在抽取表中与犬普瑞巴林/加巴喷丁区块错位，此处按原文可读片段归位，法语抽取文本存在错位断裂，需核对原 PDF。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 各辅助药物正文要点', '7.3 各辅助药物正文要点', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 各辅助药物正文要点 (2)', '- Amantadine：与 kétamine 类似的 NMDA 受体抑制，但无幻觉效应。适应证：含神经病性成分的慢性疼痛综合征，如 AINS 单药治疗无效的骨关节炎犬（Lascelles et al. 2008）。骨关节炎猫单用 amantadine 时主人报告的疼痛评分改善但活动量下降（Shipley et al., 2021）。经肾排泄，肾功能受损动物使用时需考虑。
- Gabapentinoïdes（加巴喷丁类：gabapentine 与 prégabaline）：机制两药类似且未完全明确；可能通过改变钙通道 α2( ) 亚基通透性（原文符号缺失）、抑制谷氨酸与 P 物质、调制脊髓背角 GABA 受体来调制疼痛。prégabaline 与钙通道结合强于 gabapentine。适应证：已知或可能有神经病性成分的慢性疼痛（骨关节炎、癌症、糖尿病神经病、骨盆创伤、截肢、椎间盘疾病），犬猫（见 3.12 章）；也用于减少转运与就诊焦虑，及作为急性疼痛的辅助方案。犬神经病理性疼痛：gabapentine 单用与 gabapentine-méloxicam 组 CBPI 评分较基线显著改善，安慰剂则否（Ruel et Steagall 2019, Ruel et al. 2020）。两药均可致共济失调与镇静，可能复杂化管理并影响生活质量（QoL）（Platt et al. 2006, Bleuer-Elsner et al. 2021）。猫慢性肾衰应减量（药物排泄可能受损）（Quimby et al. 2022）。人术前给予 gabapentine 以提供术后镇痛并减轻焦虑；部分研究在手术犬猫及转运中的猫显示类似效应（Crociolli et al. 2015, van Haaften et al. 2017, Steagall et al. 2018）；亦有研究显示 prégabaline 减少转运应激与焦虑（Lamminen et al. 2021）。犬前肢截肢：在已包含术中与术后 fentanyl 输注及其他镇痛药的强方案上加用术前 gabapentine，术后前 3 天无显著获益（Wagner et al., 2010）。
- Amitriptyline：三环类抗抑郁药（TCA）阻断儿茶酚胺再摄取，增强疼痛抑制系统；另具 NMDA 受体拮抗特性。适应证：已知或可能有神经病性成分的慢性疼痛。TCA 也可与环境丰富化联合用于治疗炎症性肠病及猫下泌尿道疾病（FLUTD）猫（Chew et al. 1998）；但个体反应差异大，许多特发性 FLUTD 猫治疗 7 天（10 mg/chat toutes les 24 heures）无改善（Kraijer et al., 2003）；另一面，难治性 FLUTD 猫持续治疗 12 个月消除了主人观察到的下尿路症状，血尿与蛋白尿减少，但观察到镇静、体重增加与被毛质量下降（Chew et al., 1998）。加用 amitriptyline 可能对某些难治性慢性疼痛有效，但可用证据有限。
- 其他抗抑郁药：TCA 是人的神经病理性疼痛最常用抗抑郁药；其他如 5-羟色胺与去甲肾上腺素再摄取抑制剂（duloxétine，度洛西汀）与选择性 5-羟色胺再摄取抑制剂（fluoxétine，氟西汀）在人分别有充分有效证据与无效证据。兽医领域此类药物主要在行为障碍背景下评估，用于疼痛管理的资料少。需注意：同时给予作用于 5-羟色胺的镇痛药（tramadol、amitriptyline、imipramine、duloxétine）可引起"5-羟色胺综合征"（syndrome sérotoninergique）；治疗接受 SSRI、TCA 或单胺氧化酶抑制剂（sélégiline，司立吉林）的疼痛合并焦虑患者时应谨慎。5-羟色胺综合征表现为神经肌肉兴奋性增高、发热、心动过速、呼吸急促与躁动征象（Mohammad-Zadeh et al. 2008, Indrawirawan & McAlees 2014）。
- Tramadol：中枢性镇痛药，双重机制（弱 μ 阿片激动与 5-羟色胺和去甲肾上腺素再摄取抑制）及其他机制。适应证：与其他镇痛药联合，注射剂型用于猫急性疼痛、口服剂型用于猫慢性疼痛（Evangelista et al. 2014, Monteiro et al. 2017, Guedes et al. 2018）。犬猫差异：主要代谢物 O-desmethyltramadol（M1）与 μ 阿片激动效应相关；猫的 M1 生成更快、半衰期更长、清除更慢（Perez Jimenez et al., 2016）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 各辅助药物正文要点 (3)', '犬无法产生显著浓度的 M1，骨关节炎犬（Budsberg et al. 2018）与术后犬（Donati et al. 2021）均未观察到镇痛效应。猫使用 tramadol 证据充分（尽管苦味可能妨碍经口给药）；犬疗效证据薄弱。因此 tramadol 作为犬辅助镇痛药仅应在药物选择有限时使用（阿片效应不可期，但 5-羟色胺与去甲肾上腺素再摄取抑制可能带来潜在镇痛效应）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 疼痛患者管理中的非镇痛药物（2.8）', '8. 疼痛患者管理中的非镇痛药物（2.8）

- Glucocorticoïdes（GC，糖皮质激素）：支持其在临床环境用于镇痛的证据很少；但其抗炎特性可带来疼痛缓解。最佳适应证为过敏性障碍与自身免疫病（免疫介导性贫血）及特定炎症病（炎症性肠病、脑膜炎）。镇痛缓解来自 GC 减少前列腺素生成的效应与在这些疾病康复中的作用之结合。GC 与 NSAIDs 联用禁忌，因不良反应发生率升高（Boston et al. 2003）。
- 吸入麻醉药（Anesthésiques volatils）：用于动物全身麻醉；麻醉深度可预测且可快速调节，心肺抑制呈剂量依赖。该类包括 halothane（氟烷）、isoflurane（异氟烷）、sevoflurane（七氟烷），均无抗伤害感受特性；吸入麻醉仅阻断麻醉期间的痛觉感知，未给镇痛药的患者苏醒时即是痛的。
- Maropitant（马罗匹坦）：神经激肽-1（NK-1）受体拮抗剂，阻断中枢催吐化学感受区的 NK-1 受体以治疗和预防呕吐。NK-1 受体及其配基 P 物质存在于参与伤害性感受的脊髓感觉传入纤维。小鼠与兔研究显示 NK-1 拮抗剂对内脏伤害性刺激有真正镇痛，但该信息不应外推至伴侣动物，临床镇痛似不成立。静脉给药后 maropitant 可降低犬猫吸入麻醉药需求（Boscan et al. 2011, Niyom et al. 2013）。目前没有明确证据支持将其作为临床镇痛药（Kinobe et Miyake 2020）。maropitant 减少呕吐但不能消除恶心，且可能降低胃肠动力（Koh et al. 2014, Mikawa et al. 2015）。总体而言可在麻醉方案中使用以改善患者在医院的体验、减少晕动症。
- Ondansétron（昂丹司琼）：5-HT3 型 5-羟色胺受体拮抗剂，有效的止吐与抗恶心药（Santos et al. 2011, Foth et al. 2021）。maropitant 与 ondansétron 虽无证实的镇痛效应，但在整体患者管理、预防不良反应与呕吐、促进舒适度方面作用关键。
- Acépromazine（ACP，乙酰丙嗪）：兽医最常用的安定剂之一；无镇痛特性。给予 ACP 可减少注射与吸入麻醉药需求。大剂量或用于低血容量动物时可致临床显著的低血压。广泛用于围手术期（神经安定镇痛），可因外周血管扩张及下丘脑中枢效应导致低温。

9. 非药物治疗', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 功能性康复（2.9 Rééducation fonctionnelle）', '9.1 功能性康复（2.9 Rééducation fonctionnelle）

康复医学包括对关节内、囊、韧带、肌肉、肌筋膜及周围与中枢神经系统神经组织的肌肉骨骼与神经疾病的临床评估与治疗。评估姿势、步态、功能、肌力、肌肉柔韧性、被动活动范围与关节活动度以制定治疗计划（Millis et Levine 2014）。物理因子、手法治疗与治疗性运动可用于治疗疼痛（图 27）；治疗的频次、强度与时长按靶组织愈合能力与病变慢性程度确定。

- 治疗性运动：改善淋巴与血流、增加软组织对骨骼与脊柱的支撑、促进肌腱韧带柔韧性；可培训主人在家实施。损伤急性期可给予简单运动（如静态负重），随愈合推进与力量改善逐级增加强度。人的肌力训练与有氧运动缓解疼痛可与 NSAIDs 同样有效甚至更有效（Polaski et al., 2019）。
- 热疗（Thermothérapie）：加热增加组织可延展性与血流以促进愈合；疾病早期热可能是促痛（pro-nociceptive）的。慢性期炎症消退后以肌肉筋膜张力区为主，热可具镇痛效应（McCarberg et O''Connor 2004）。
- 冷疗：见 9.2。
- 光生物调节（Photobiomodulation, laser）：以红光/近红外光应用光子，减少炎症并（原文如此）"l''analgésie"——该句"réduit l''inflammation et l''analgésie"疑为抽取或翻译缺陷，需核对原 PDF（应为减少炎症并产生镇痛）。不同激光类别；剂量基于波长、辐射功率、辐照度、fluence（能量密度）与治疗面积。光生物调节对肘或髋关节疼痛犬有镇痛疗效（剂量 10 à 20 J/²——原文单位上标残缺，疑为 J/cm²，照抄残缺），（Looney et al. 2018, Alves et al. 2022）。
- 电刺激（TENS）：约半数中度疼痛的人患者可被电刺激镇痛（Rushton 2002）；治疗按患者滴定频率（脉冲/秒）、强度（脉冲幅值）与脉宽（电流输注时段）。
- 脉冲电磁疗法：非热、非侵入性电磁疗法可降低人膝骨关节炎疼痛，并改善犬半椎板切除术后功能结果（Nelson et al. 2013, Alvarez et al. 2019）。
- 冲击波疗法：高强度声波使组织变形，导向新生血管形成、慢性炎症逆转、胶原生成刺激、肌腱韧带损伤治疗及长短程镇痛（Chamberlain et Colborne 2016）。研究显示犬髋发育不良手术后肢体使用改善、人腰痛长期获益（Barnes et al., 2019, Waleinicz et al. 2019——原文作 Walewicz）。
- 触发点治疗（trigger points）：位于肌纤维内的坚硬触痛结节；可用治疗激光、电疗或物理/手法治疗（如注射局麻药或 acupuncture 干针）刺激（Wall 2014）。兽医数据有限，首选 acupuncture。
- Massage（按摩）：见 9.5。', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 冷疗（2.10 Thérapie par le froid）', '9.2 冷疗（2.10 Thérapie par le froid）

冷疗是非药物镇痛工具，医学上有效、科学上可靠、全球可得且不受管制法规限制（Wright et al. 2020）。为局部应用冰或冷冻基质（经杯、容器、纸袋）或使用冷敷包与压迫套（图 28），须正确施加于靶组织并维持足够时长。皮肤冷却可使皮下组织温度下降至 2 à 4 cm 深，从而减少组织伤害性感受器激活、减慢外周轴突传导速度（冷诱导的神经失用，neuropraxie）（Malanga et al. 2015）；冷敏感的外周离子通道参与减少伤害性信号并激活抑制性中间神经元（Liu et al. 2013）。冷疗还经交感介导的血管收缩减轻水肿、减少肌肉痉挛（Lee et al., 2002）——急慢性疼痛患者可存在肌痉挛，是重要不适来源。

适应证与考虑：推荐用于任何手术切口、作为镇痛方案的组成部分。术后即刻起可冷疗 15 à 20 minutes toutes les 6 à 8 heures，持续数天；技术可教给主人出院后继续（Wright et al. 2020）。有炎症成分或肌痉挛的慢性疼痛也可能有益。与任何药物/医疗操作一样，其效应取决于剂量、时长与疾病，且因患而异，须评估个体获益后使用。预防：避免长时间使用造成神经损伤，避免用于无感觉或血流少的区域（如远端肢体）；必须在冷敷包与皮肤之间加衬垫（纸巾或布——冰袋绝不可直接接触皮肤）；避免非无菌表面接触手术切口。冰在 1 à 2 heures 时段内应用不得超过 20 minutes。多数患者经短暂（不应超过 2 minutes）不适后即接受冷感觉；患者初期可有负面反应，但组织敏感性降低后通常很快接受。然而慢性疼痛综合征可表现冷异常性疼痛（allodynie au froid）——此时若患者对冷刺激反应过度或持续试图回避治疗，应中断治疗。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 大麻素类（2.11 Cannabinoïdes）', '9.3 大麻素类（2.11 Cannabinoïdes）

内源性大麻素系统（système endocannabinoïde）在所有脊椎动物与 5-羟色胺能、多巴胺能、去甲肾上腺素能及阿片系统共存并互动以维持稳态（McPartland et al., 2014）；运动、针刺与膳食等物理治疗形式也可影响该系统（Howlett & Abood 2017, Toczek & Malinowska 2018）。大麻素受体（CB）是 G 蛋白偶联受体，为细胞膜与神经突触前末梢上的神经调制者；公认两种：CB1（主要位于神经系统）与 CB2（广泛分布、与免疫细胞相关）。大麻素分三类：内源性（体内产生）、植物源（phytocannabinoïdes，来自植物）与合成；这些分子在外周与中枢改变伤害性信号；经神经胶质效应具有抗痛觉过敏作用，或可减少神经退行性疾病（如退行性脊髓病）（Fine & Rosenfeld 2013, Fernandez-Trapero et al. 2017）。

外源大麻素：植物大麻素主要源自 Cannabis sativa，比合成分子更多样；研究最多的两个分子为 CBD（cannabinol，按原文译名照抄；通常作大麻二酚）与 delta-9-tétrahydrocannabinol（THC，Δ9-四氢大麻酚），已存在 180 余种化合物。监管机构批准的制药产品源自生物来源且仅为一个或两个分子；植物源大麻素含也有生物学效应的萜烯（terpènes）与类黄酮（flavonoïdes）。化合物多样性造成不同植物大麻素效应复杂多变，以及监管与市场上产品缺乏标准化（原文"ay niveau réglementaire et recheche"为抽取错乱）。CBD 因经 CB2 的镇痛与免疫调节效应在兽医中常用，精神与镇静效应极小、药理效应相对可预期（Gamble et al. 2018）。THC 是强 CB1 激动剂（也结合 CB2），与精神活性、焦虑、心动过速与外周血管扩张相关，难以在动物中确定医用剂量；但少量 THC 与 CBD 联用可显著增强疗效（Vaughn et al. 2020）。

marijuana（大麻）与 chanvre（工业 Hemp）皆为 Cannabis sativa 属植物，区别在 THC 含量（ hemp 干重不足 0,3 %）（Deabold et al. 2019）；杂交造成植物多样性，单个亚种对医学考量并不重要（Solymosi et Kofalvi 2017）；常见品种效应差异取决于活性大麻素、萜烯与类黄酮比例（Piomelli et Russo, 2016）；分析证书（certificat d''analyse）可提供某一产品的该信息（Wakshlag et al. 2020）。

临床思路：目前无法就大麻素向兽医给出普适建议；各地法律差异极大（从法律风险低到处方或销售构成刑事犯罪）。此类化合物被广泛使用、常未经兽医监督获取；但兽医专业人员应发挥保护与咨询作用，至少在降低风险方面；已有继续教育课程。犬中毒报道广泛，尤其 THC：临床表现严重程度不一，包括中枢抑制、焦虑、感觉过敏、尿失禁、心动过速与死亡。大麻素是细胞色素 P450 酶的强抑制剂（尤其 CBD）；与其他药物联用需谨慎并监测肝酶与肝功能变化。与经钙通道作用的药物（如 gabapentine）合用时双方均应减量以免过度镇静。THC 的血管扩张效应可能改变既存病理状态如肾病与心病（Ho et al., 2019）。内源性大麻素系统属稳态系统，个体间"基础"活动可能差异极大，令治疗不可预测；建议植物大麻素低剂量起始，在数周时间尺度上滴定。骨关节炎犬通常用 CBD 油 2 mg/kg deux fois par jour（每日两次）经口，有一定程度的疗效报道；部分犬出现肝酶升高（Gamble et al. 2018, Brioschi et al. 2020, Vaughn et al. 2020）。猫缺乏疗效数据，其药代动力学似与犬差异很大（Deabold et al. 2019）。新生动物内源性大麻素系统可能未成熟，加之肝功能未成熟，因此妊娠、哺乳与 8 周龄以下动物应避免使用大麻素。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 处方粮与补充饲料（2.12 Régimes et aliments complé', '9.4 处方粮与补充饲料（2.12 Régimes et aliments complémentaires）

治疗日粮应考虑纳入疼痛管理（Vandeweerd et al. 2012）。例：给骨关节炎猫喂食富含 EPA（eicosapentaénoïque，二十碳五烯酸）与 DHA（docosahexaénoïque，二十二碳六烯酸）的日粮并补充绿唇贻贝提取物与硫酸氨基葡萄糖/软骨素 9 周后，观察到活动水平增加（Lascelles et al. 2010a）；骨关节炎犬喂食添加鱼油 ω-3 的日粮 90 天后，负重客观评估（步态分析）改善（Roush et al. 2010）。营养与疼痛管理的相互作用及商品日粮如何以多学科方式为多模式镇痛助力仍待探索。补充饲料（aliments complémentaires）为源自食品、宣称提供超出营养之额外健康益处的产品；注意其上市不需安全性、有效性或质量控制证明；但其使用历史悠久、有效性信息增多，在药品可及性受限时可作替代。encadré 5 给出非详尽的基本成分清单（下列），若干商品日粮已含其中一种或数种；需要前瞻性随机临床试验研究补充饲料在疼痛管理尤其是慢性病中的作用。

Encadré 5（补充剂示例，照抄）：Acides gras poly-insaturés（AGPI，多不饱和脂肪酸）；Glucosamine/chondroïtine（氨基葡萄糖/软骨素）；Acide hyaluronique（HA，透明质酸）；Insaponifiables d''Avocat et de Soja（鳄梨大豆不皂化物）；Extraits de moules vertes（GLM）（Perna canaliculus，绿唇贻贝提取物）；Collagène de type II non dénaturé（UC-II，非变性 II 型胶原）；Boswellia serrata（齿叶乳香）；Ashwaganda（Withania somnifera，南非醉茄）；Curcumine（Curcuma，姜黄素）；Arnica montana ou Solidago chilensis（Arnica brésilien，山金车/巴西山金车）；Griffe du diable（Harpagophytum procumbens，魔鬼爪/非洲钩毛草）；Écorce blanche de saule（Salix alba，白柳皮）；Quercétine, resvératrol et autres polyphénols（槲皮素、白藜芦醇及其他多酚）；Acétyl-l-carnitine（乙酰左卡尼汀）；Produits dérivés du lait（乳源性产品）；Myristoléate de cétyle（鲸蜡肉豆蔻酸酯）；N-acétylcystéine（N-乙酰半胱氨酸）；N-palmitoyl-éthanolamine（PEA，N-棕榈酰乙醇胺）；Membrane de coquille d''œuf（fortétropine，蛋壳膜）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15', '9.5 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 软组织松动与按摩、2.16 手术干预

护理与随访：应给予伴侣动物优质基础护理（soins de nursing，"tender loving care"）以配合其他疗法，改善疼痛与应激管理（图 29）。营造生理与情感舒适的环境：环境改造（声音、光线、气味的管理）与操作改造以及疼痛与舒适针对性治疗。声音：犬猫分开安置、将安静患者与吵闹动物隔离、远离繁忙处置室（原文此处行尾断裂），舒缓音乐或白噪音（Hampton et al. 2020, Lindig et al. 2020），平静交谈。视觉：休息时特别是夜间的低照度照明、犬舍/笼内躲藏与攀高位置；有数据证实某些波长光线可带来放松或镇痛（Tamarova et al. 2009）。嗅觉：上述居所调整，以及信息素或有放松特性植物的暴露（猫与犬信息素、某些物种如兔的薰衣草）（Pageat et Gaultier 2003, Amaya et al. 2020, Van Vertloo et al. 2021）。笼内环境应提供舒适、空间、活动与退避/躲藏机会；猫使用三维空间，纸箱既是"安全地点"又提供垂直空间（图 29）。操作改造：识别焦虑患者并在转运前和/或住院期间用抗焦虑药物处理（如 gabapentine 或 trazodone，曲唑酮）（Gilbert-Gregory et al., 2016）（表 16）；必须评估疼痛，对寻求接触者给予抚慰性触摸与积极互动，对寻求隔离者给予空间。应激、焦虑与睡眠剥夺可跨物种加剧疼痛（Lefman et Prittie, 2019）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (2)', '其他安抚与镇痛护理技术：massage（轻压、按压与摇晃可安抚习惯与人密切接触的患者，见 2.15）；冷热应用（急性损伤冷疗减少水肿并提供镇痛；无炎症性疼痛时热疗可带来舒适）；搬动患者时避开疼痛区域（手术/创伤部位、骨关节炎关节等），即使动物已麻醉或镇静也应避免施加伤害性刺激；长骨损伤在搬运前必须用石膏或夹板固定；保定不使用暴力（用毛巾包裹患者），用平静的声音与轻柔动作；猫绝不可抓握后颈 scrumming（原文："Le frottement doit être évité à tout prix chez le chat"——字面为"摩擦"，疑为抓取颈皮的翻译偏差，需核对原 PDF）；猫友好操作指南见别处（Rodan et al., 2011）。卧床与摆位：营造柔软垫衬的卧息面；长时间卧于坚硬冰冷表面极其不适并易致焦虑，增加痛感与压疮风险；卷起的毯子或垫子可让患者自选最舒适姿势；可摆位抬高患肢以减轻水肿或促进创面空气流通。翻身：每 4 heures 变换体位可预防肌僵硬、压疮与肺不张风险、促进循环，并可进行疼痛评估与必要时镇痛调整。温和运动：谨慎实施的活动与温和运动可减少疼痛与组织僵硬、改善舒适度（Polaski et al., 2019）；助行具如人体工学挽具、助行车与运动设备可便利活动；辅助行走可改善姿态、减轻应激并让有控尿能力者得以排尿。激光治疗与 TENS 可作为护理的一部分（2.13）。', 'cat', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (3)', 'Acupuncture（针刺）：在富含神经血管或肌筋膜结构的特定部位（神经解剖点）放置并操纵细针，以激发内源性镇痛反应、愈合与免疫反应；针刺的生化效应机制为机械转导（mécano-transduction）与组织神经调制（Wright 2019）。"针刺"一词以针的使用定义，但神经解剖点并非针刺专属——同类点亦可以 acupression（按压）、laser、电疗与 aquapuncture（水针，如生理盐水或维生素 B12 注射至穴位）刺激（图 30）；这些相关方式或有疗效，但其机械转导机制尚未确立（Langevin et Wayne 2018）。神经解剖学进路：穴位解剖富集有髓与无髓神经、低阈值机械感受器、成纤维细胞与胶原基质、肥大细胞与微循环复合体（Zhang et al. 2012）。进针时神经受直接刺激，也继发于针尖周围筋膜与细胞外基质所受机械力——如成纤维细胞经针牵拉胶原网络被拉伸；成纤维细胞功能经机械转导被改变并持续 36 heures，增加经淋巴通道的液体流动。针直接作用于神经与成纤维细胞，改变外周伤害性输入、脊髓神经递质调制、交感/副交感平衡与免疫功能（Wright 2019）。与已记录的生理过程相对，传统中国兽医针刺学基于"chi"（气）运行的描述；两种进路都是将针放置并操纵于特定部位以产生有益临床效应（Kaptchuk et al., 2010）。适应证：人的急性与多种慢性疼痛治疗中针刺地位日隆，美国 NIH 国家补充与整合健康中心维护针刺科学数据网站并资助研究；兽医证据虽有限，研究总体上显示针刺对犬猫急慢性疼痛（卵巢子宫切除、骨关节炎、半椎板切除及其他神经肌肉骨骼疾病）具有镇痛效应（Teixeira et al. 2016, Ribeiro et al. 2017, Silva et al. 2017, Nascimento et al. 2019, Baker-Meuten et al. 2020, Machin et al. 2020）。不良反应：由受过充分训练的临床医师操作时风险极低；已报道的不良事件罕见，包括重要结构（尤其肺）的意外穿刺、感染（与未使用一次性无菌针有关）与异物引入；必须使用一次性无菌针。不建议犬有意植入异物（如金珠或金属针）——金珠导致长期炎性改变；人中有迁移针致死后果报道（Lie et al., 2011）。针刺设备价廉易得，但需要培训。针刺被证明可减少阿片类需求，在慢性疼痛中越来越多的被建议作为阿片类疗法的替代（Tick et al. 2018）；正确使用下针刺是药物方法的宝贵补充，应作多模式方案一部分而非独立疗法。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (4)', '2.15 软组织松动与按摩：概念要求理解连接体驱与内脏结构的筋膜与结缔组织的存在。筋膜系统以胶原、疏松与致密纤维结缔组织构成三维连续体并渗透全身，使各系统整合运作（Zügel et al. 2018）。传统筋膜松动方法包括 massage、拉伸与整脊技术。筋膜组织被操纵时释放生长因子、多种蛋白与神经递质，导致疼痛处理、代谢过程、血流与愈合能力改变，并减少外周与中枢敏感化及炎症（Weerapong et al. 2005, Langevin 2014, Berrueta et al. 2016）。运动作为组织松动形式可改善慢性疼痛的镇痛与功能，并对免疫系统有正面影响、减少衰老相关的免疫老化（Naugle et al. 2012, Sluka et al. 2018）。过去 30 年针刺研究表明筋膜松动对针刺的生化效应贡献重要（Langevin, 2014）。基于机器的新技术含聚焦式与放射式冲击波治疗，用于肌腱损伤、疼痛缓解与骨愈合（Dedes et al., 2018）。筋膜松动从护理人员可提供的简单技术（软组织按摩与抚触）到需大量训练的复杂方式（冲击波、针刺）不等。许多技术可作为疼痛控制组成部分；组织松动建议可像推荐规律温和运动作为疼痛管理方案的一部分那样简单，尤其针对慢性持续疼痛。

2.16 手术干预：某些病例推荐手术入路缓解疼痛。此类手术常称救援（secours）手术，但也可作一线治疗：如肢体骨肉瘤的疼痛难以用镇痛疗法控制，截肢可快速缓解疼痛。手术可以很复杂，须由有经验的外科医师实施；许多接受此类手术的患者患有慢性疼痛，须使用完整镇痛技术，防止手术急性痛叠加已敏感化状态导致人中所见的手术后持续性疼痛。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 护理与随访（2.13 Soins et suivis）、2.14 针刺、2.15 (5)', '- 截肢（Amputation d''un membre）适应证：肢体创伤/撕脱严重或修复手术失败（如骨折修复失败）、肢体骨肉瘤、其他疼痛性肢体肿瘤、其他慢性疼痛性肢体疾病。给予合适围手术期镇痛时，多数病例恢复迅速，动物良好适应三肢行走；其他肢体无肌肉骨骼疾病且不超重/肥胖者功能最佳。
- 全关节置换（Prothèse articulaire totale）适应证：缓解病变关节疼痛（退行性关节病/骨关节炎、半脱位、脱位与关节内骨折）。此类手术（全髋、全肘、全膝置换、定制关节假体）技术先进、需专用设备；正确实施可消除关节疼痛（Lascelles et al. 2010b）。
- 切除成形术（Arthroplastie avec excision）适应证：缓解病变关节疼痛（骨关节炎、半脱位、脱位与关节内骨折）。最常见于髋关节（股骨头颈切除术），技术复杂程度低于全髋置换；但数据提示功能结果并不理想（Off & Matis, 2010；Montasell et al. 2018）。切除成形术不应被当作"简单解决办法"：需要有效的围手术期镇痛技术与积极的物理康复以优化结果。
- 关节融合术（Arthrodèse）适应证：缓解病变关节疼痛；通过永久消除关节运动及其相关疼痛，但通常遗留机械性（功能性）跛行。
- 去神经术（Dénervation）适应证：药物治疗失败时缓解疼痛，作为关节融合术的替代；通过阻断将关节伤害性信息传至脑的神经通路实现镇痛。犬髋（股骨头髋臼）与肘的去神经技术已有描述，用于药物、手术与辅助等其他治疗失败后（Zamprogno et al. 2011）。正确实施时运动功能一般可保持良好；无长期随访数据；去神经是否导致关节变性加速的证据相互矛盾。
- 以上均为大型手术，若围手术期不提供足时程镇痛，极易造成显著（急性与持续性）疼痛；推荐多模式方案并特别强调局部镇痛——因大多数患者术前已患慢性疼痛性疾病；只应由熟悉手术及术后患者护理的外科医师实施（Lister et al. 2009）。', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 抗痛单克隆抗体（2.17 Anticorps monoclonaux contr', '9.6 抗痛单克隆抗体（2.17 Anticorps monoclonaux contre la douleur）

单克隆抗体（AcM/mAb）在人医多种疾病中极为有效，现已引入兽医。mAb 为单价抗体，特异性结合靶分子——细胞因子、受体或细胞（Liu 2014），结合后阻断靶标活性。作用机制多样：阻断配体-受体相互作用或信号通路、改变细胞群体（通过募集效应功能，含补体依赖性细胞毒、抗体依赖性细胞毒及抗体依赖性吞噬或凋亡）（Khan et Sadroddiny, 2015）。治疗性抗体须种属特异，以减少抗药抗体（免疫抗药反应）的发生率。靶向神经生长因子（NGF）已成为骨关节炎疼痛控制及可能其他疾病的潜在有益治疗途径。NGF 最初被认为是发育中神经系统感觉与交感神经元发育和维持的重要因素，现已明确其在促痛觉（pro-nociception）中的重要作用（Enomoto et al. 2019）：NGF 通过改变神经元功能敏化神经、激活免疫/炎症细胞、由这些细胞释放的产物进一步敏化神经元；还参与慢性疼痛中的神经新生长（néo-innervation/sprouting）。人的临床试验中若干抗 NGF mAb 显示减少骨关节炎患者疼痛、改善行动能力（Wise et al. 2021）；但至今无一抗 NGF mAb 在人获批，部分由于对不良反应的担忧，尤其快速破坏性骨关节炎病例。近年兽医用单剂抗 NGF mAb 控制犬猫骨关节炎疼痛显示显著镇痛效应：犬重组抗 NGF mAb ranevetmab、犬源抗 NGF mAb bedinvetmab 与猫重组抗 NGF mAb frunevetmab 的有效已有描述（Webster et al. 2014, Lascelles et al. 2015, Gruen et al. 2016, 2021a,b, Corral et al. 2021）。最近，首批抗 NGF mAb（frunevetmab 与 bedinvetmab）已在多国获批用于犬猫骨关节炎疼痛缓解（原文"frunevetmab"在另一处拼作"ranevetmab"，两拼写并存，需核对原 PDF）。已发表数据表明两物种各类严重程度的骨关节炎疼痛均有效、适合一线治疗；两物种单剂皮下注射即可缓解骨关节炎疼痛至少 1 mois。尚无其他类型疼痛的研究。抗 NGF mAb 似与器官不良反应无关，但猫有轻度皮肤反应（如脱发，alopécie）报道；完全安全性要待广泛临床使用后方知。尽管仍需安全性信息更大样本疗效研究，种属特异、单剂注射可在犬猫控制疼痛数周的抗 NGF mAb 开发满足了重要的临床需求。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 肌肉骨骼辅助治疗（2.18）', '9.7 肌肉骨骼辅助治疗（2.18）

- 再生医学（Médecine régénérative）：聚焦培养、修复或替换受损/患病的细胞、器官或组织（Voga et al., 2020）。使用间充质干细胞（CSM/MSC）：成体未特化细胞，具免疫调节与抗炎效应，可迁移至组织损伤部位（"归巢"domiciliation 能力）。可取自多种组织如骨髓或脂肪组织；来源可为患者自体（autologue）、同种异体（allogénique）或异种（xénogénique）；可经静脉、关节内或其他方法给予（详见 Voga et al. 2020, Brondeel et al. 2021）。骨关节炎犬的 MSC 治疗前景良好，现有研究总体显示跛行减少、关节疼痛减轻与活动度改善（Harman et al. 2016, Brondeel et al. 2021）。原文表述为"患骨关节炎的猫"中，MSC 治疗使某些患严重难治性牙龈口炎的猫完全缓解或显著临床改善（Arzi et al. 2016）（照抄原文行文）。进一步证据将阐明 MSC 在动物慢性疼痛管理中的真实作用及最佳治疗进路（如关节内对比静脉给药；自体对比同种异体对比异种移植等）。
- 关节内治疗：透明质酸（AH/HA）为关节液与软骨天然成分，可注入骨关节炎关节或经口给予（2.12），促进润滑。富血小板血浆（PRP）含具抗炎特性的生长因子与蛋白；采集并处理患者血液后注入患病关节。AH 与 PRP 在人改善关节疼痛与活动度；兽医证据仍有限，但提示 AH 或 PRP 单用或与 MSC 联用于骨关节炎犬对疼痛与活动度有正面效应（Nganvongpanit et al. 2013, Carapeba et al. 2016, Venator et al. 2020, Brondeel et al. 2021, Okamoto-Okubo et al. 2021）。Tin (117mSn) colloid（胶体放射性锡 117m）是用于放射滑膜切除术的核医学兽医器械：关节内注射放射性核素以减少滑膜炎症；该产品最近在美国获批治疗犬肘关节骨关节炎，可提供长达 1 an 的镇痛；需使用放射性医疗的许可证。初步研究显示该产品似安全并在犬肘骨关节炎提供长期镇痛（Lattimer et al. 2019, Aulakh et al. 2021, Donecker et al. 2021a b）。TRPV1（transient receptor potential vanilloid type 1，瞬时受体电位香草素亚型 1）激动剂：TRPV1 主要表达于伤害性感觉神经元，是慢性疼痛管理的有前景靶点。résinifératoxine（树脂毒素）与 capsaïcine（辣椒素）为强 TRPV1 激动剂，尚在研究中、尚未上市，在骨关节炎犬显示有前景的结果（Iadarola et al. 2018, Campbell et al. 2021）。
- 肌注或皮下治疗：聚糖硫酸氨基聚糖（Glycosaminoglycane polysulfaté, PSGAG）抑制骨关节炎关节中过度表达、促软骨丢失的分解代谢酶；犬指示肌内注射，亦有犬皮下（Varcoe et al. 2021）及猫给药（Adrian et al. 2018）的研究；现有有限研究提示骨关节炎犬有效（de Haan et al. 1994, Fujiki et al. 2007）。多聚硫酸戊聚糖（polysulfate de pentosan）为半合成糖氨基聚糖，抑制并调制炎症介质；犬指示皮下注射，猫也轶事性使用；犬临床疗效证据有限（Budsberg et al., 2007）。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 第 3 节：疼痛管理方案示例（3.1-3.5）', '10. 第 3 节：疼痛管理方案示例（3.1-3.5）

第 3 节给出疼痛管理方案示例；药物剂量方案见表 12、13、15、16 与 17（切片 027 原文如此，正文后文实际另用至表 22）；犬猫麻醉管理建议见综述（Warne et al. 2018, Grubb et al. 2020）及 FECAVA 麻醉与镇痛基本实践链接。

10.1 猫去势与卵巢/卵巢子宫切除（3.1）

猫的绝育手术疼痛强度依手术创伤程度而异；须轻柔组织操作并遵守良好外科实践。强烈推荐全身麻醉与多模式预防性镇痛；围手术期选择多样（表 18 与表 19）。术后镇痛应持续至术后 3 jours，尤其卵巢子宫切除/卵巢切除后，或雄性需剖腹（如隐睾）切除睾丸时。术前术后应使用同一种 NSAID。某些猫经肌注"阿片类 + α2 激动剂 + kétamine"组合可提供手术所需的镇痛与麻醉（即兼作 premédication、诱导与维持），此类混合液常被称为"Kitty magic"，有许多不同版本；应准备好延长麻醉时间的预案，以防猫有反应或出现并发症。因手术时间短，许多猫不插管，但气管内插管器材必须备好。所有病例均推荐建立静脉通路。多数术式后可辅以冷疗、激光、针刺与护理等非药物治疗补完镇痛。

10.2 犬去势与卵巢/卵巢子宫切除（3.2）

与猫同构：疼痛依创伤程度而异；轻柔操作、良好外科实践；全麻与多模式预防性镇痛强烈推荐（表 20 与表 21）；术后镇痛持续 3 天（尤其卵巢子宫切除/卵巢切除或雄犬隐睾剖腹）；术前术后同一 NSAID。犬可经肌注"阿片 + α2 + kétamine"组合满足手术需要（"doggy magic"及其诸多版本）；备好延长麻醉预案；插管器材备妥；静脉通路推荐；术后可辅冷疗、激光、针刺与护理。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 骨科手术（3.3）', '10.3 骨科手术（3.3）

骨科手术可致中度至重度术后疼痛。须在全身麻醉联合积极的围手术期镇痛下手术（表 22，encadré 6 与 7）；所有手术均应使用预防性多模式镇痛。术前/术中/术后镇痛的配比取决于术前疾病严重度、损伤部位、创伤大小与患者状态。必须反复进行疼痛评估；疼痛未被适当控制时，可用不同或额外的镇痛药或替代镇痛技术改善舒适度。NSAIDs 带来极佳的围手术期镇痛，除禁忌外均应使用；建议给予获批 NSAID；术前术后使用同一种 NSAID，应避免更换 NSAID。（神经等结构的）切断（如截肢时）或神经操作可引发严重的慢性神经病理性疼痛；可围手术期使用 gabapentine，因其在预防术后持续性疼痛方面可能有益。阿片类、α2 激动剂或 NSAIDs 的选择取决于分子可得性、医师偏好与禁忌。区域麻醉技术（如关节内神经阻滞、手术切口阻滞、伤口导管等，图 31）或其组合，在手术前和/或术后，所有病例均推荐使用；当阿片类及其他管制镇痛药不可得时，此类技术应视为强制。推荐 bupivacaïne 或 ropivacaïne 等局麻药，因其作用时间长。可获得时，推荐长效局麻制剂（如脂质体布比卡因注射悬液，可提供长达 72 heures 镇痛）用于犬前十字韧带手术麻醉。患者出院后的有效镇痛补给至关重要。

10.4 软组织手术（3.4）

软组织手术可致轻度、中度或重度术后疼痛。应使用预防性多模式镇痛技术，并尽可能纳入局部麻醉技术。术前/术中/术后配比取决于术前疾病严重度、损伤部位与创伤大小（表 23 与 24，encadré 8——该两表与附框内容位于切片 030-032，本稿切片范围内未见其正文，原文此处缺失）。术后疼痛未被 NSAIDs 有效控制时，应使用替代或额外的镇痛药与镇痛技术，如规律给予阿片类。大型软组织手术可能引发慢性疼痛，可含神经病性成分。阿片类、α2 或 NSAIDs 的选择随可得性与禁忌而变。区域麻醉技术如切口神经阻滞与选择性神经阻滞、伤口输注导管（图 31）或其组合，术前和/或术后强烈推荐；当阿片类与管制镇痛药不可得时此类技术不可或缺。', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 17：犬猫常用镇静药与麻醉药推荐剂量（逐字还原）', '10.5 表 17：犬猫常用镇静药与麻醉药推荐剂量（逐字还原）

| Substance | Chiens（犬） | Chats（猫） | Commentaires |
|---|---|---|---|
| Acépromazine† | 0,01 à 0,03 mg/kg iv | 0,01 à 0,03 mg/kg im | （无） |
| Kétamine‡ | 3 à 5 mg/kg iv | 5 à 10 mg/kg im；3 à 5 mg/kg iv | 对难以保定的猫建议更高剂量 |
| Propofol‡ | 3 à 5 mg/kg iv | 3 à 10 mg/kg iv | Donné à effet（按需给至起效） |
| Alfaxalone‡ | 1 à 2 mg/kg iv | 3 à 5 mg/kg iv | Donné à effet |
| Diazépam（地西泮） | 0,25 mg/kg iv | 0,25 mg/kg iv | 最好静脉给药，因肌注疼痛 |
| Midazolam（咪达唑仑） | 0,25 mg/kg iv | 0,25 mg/kg iv | （无） |
| Pentobarbital§（戊巴比妥） | 2 à 5 mg/kg iv | 2 à 5 mg/kg iv | （无） |
| Thiopental‡§（硫喷妥） | 2 à 8 mg/kg iv | 2 à 8 mg/kg iv | （无） |
| Tilétamine/zolazépam（替来他明/唑拉西泮） | 3 à 10 mg/kg iv ou im | 3 à 4 mg/kg iv ou im | （无） |

†更高剂量的乙酰丙嗪可使用，但通常延长作用时间而不增加作用强度。‡剂量一般按患者需求、共患病、健康状态及合用镇静与麻醉药物情况给予至起效。§预期在延长且躁动的苏醒期出现药物蓄积。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 18：猫去势建议方案（三列并排还原）', '10.6 表 18：猫去势建议方案（三列并排还原）

| 项目 | 含管制药物方案 | 无管制药物方案 | 镇痛药可及性低方案 |
|---|---|---|---|
| Préopératoire（术前） | Morphinique ± acépromazine ou alpha2 agoniste ± kétamine | AINS + alpha2 agoniste | 同"无管制药物"方案 |
| Induction de l''anesthésie（诱导）iv† | 选择其一：• Propofol‡ • Kétamine + diazépam ou midazolam • Alfaxalone‡ | 选择其一：• Propofol‡ • Alfaxalone‡ | 任何可用的注射制剂 |
| Induction im | alpha2-agoniste + kétamine 或 tilétamine/zolazépam | alpha2-agoniste + tilétamine/zolazépam | — |
| Maintien de l''anesthésie‡（维持） | 选择其一：• Anesthésie par inhalation • Kétamine • Propofol‡ • Alfaxalone‡ | 选择其一：• Anesthésie par inhalation • Propofol‡ • Alfaxalone‡ | 任何可用的注射或吸入制剂 |
| Techniques anesthésiques locales（局部麻醉技术） | Bloc intratesticulaire（睾丸内阻滞） | 同"含管制药物"方案 | 同"含管制药物"方案 |
| Analgésie postopératoire（术后镇痛） | AINS | 同"含管制药物"方案 | 同"含管制药物"方案 |

iv Intraveineuse，im Intramusculaire，AINS 非类固醇抗炎药。†注意 premédication 减少静脉麻醉药需求；故诱导剂量须滴定至效应。‡注射药物经 iv 给至效应（初始剂量的 1/3 或 1/2）。', 'cat', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 19：猫卵巢子宫切除/卵巢切除建议方案', '10.7 表 19：猫卵巢子宫切除/卵巢切除建议方案

| 项目 | 含管制药物方案 | 无管制药物方案 | 镇痛药可及性低方案 |
|---|---|---|---|
| Préopératoire | Morphinique ± acépromazine ou agoniste du récepteur alpha2-adrénergique ± kétamine | AINS + alpha2 agoniste | 同"无管制药物"方案 |
| Induction iv† | 选择其一：• Propofol‡ • Kétamine + diazépam ou midazolam • Alfaxalone‡ | 选择其一：• Propofol‡ • Alfaxalone‡ | 任何可用的注射制剂 |
| Induction im | Morphinique + alpha2-agoniste + kétamine 或 tilétamine/zolazépam | Alpha2-agoniste + tilétamine/zolazépam | — |
| Maintien‡ | 选择其一：• Anesthésie par inhalation • Kétamine • Propofol‡ • Alfaxalone‡ | 选择其一：• Anesthésie par inhalation • Propofol‡ • Alfaxalone‡ | 任何可用的注射或吸入制剂 |
| Techniques d''anesthésie locale | Bloc incisionnel ± intrapéritonéal（切口阻滞 ± 腹腔内） | 同"含管制药物"方案 | 同"含管制药物"方案 |
| Analgésie postopératoire | AINS | 同"含管制药物"方案 | 同"含管制药物"方案 |

脚注同表 18（iv/im/AINS；†premédication 减少静脉麻醉药需求、诱导剂量滴定至效应；‡注射药物经 iv 给至效应，初始剂量的 1/3 或 1/2）。', 'cat', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 20：犬去势建议方案', '10.8 表 20：犬去势建议方案

| 项目 | 含管制药物方案 | 无管制药物方案 | 镇痛药可及性低方案 |
|---|---|---|---|
| Préopératoire | Morphinique ± acépromazine ou benzodiazépines (midazolam ou diazépam) ± alpha2 agoniste | AINS + alpha2 agoniste | 同"无管制药物"方案 |
| Induction iv† | 选择其一：• Propofol‡ • Kétamine + diazépam ou midazolam • Alfaxalone‡ | 选择其一：• Propofol‡ • Alfaxalone‡ | 任何可用的注射制剂 |
| Induction im | Morphinique + alpha2-agoniste + kétamine 或 tilétamine/zolazépam | Alpha2-agoniste + tilétamine/zolazépam | — |
| Maintien‡ | 选择其一：• Anesthésie par inhalation • Kétamine • Propofol‡ • Alfaxalone‡ | 选择其一：• Anesthésie par inhalation ou • Propofol‡ • Alfaxalone‡ | 任何可用的注射或吸入制剂 |
| Techniques anesthésiques locales | Bloc intra-testiculaire ± incisionnel | 同"含管制药物"方案 | 同"含管制药物"方案 |
| Analgésie postopératoire | AINS | 同"含管制药物"方案 | 同"含管制药物"方案 |

脚注同表 18。', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 21：犬卵巢子宫切除/卵巢切除建议方案', '10.9 表 21：犬卵巢子宫切除/卵巢切除建议方案

| 项目 | 含管制药物方案 | 无管制药物方案 | 镇痛药可及性低方案 |
|---|---|---|---|
| Préopératoire | Morphinique ± acépromazine ± alpha2 agoniste ou benzodiazépines (midazolam ou diazépam) | AINS + métamizole (dipyrone) + alpha2-agoniste | 同"无管制药物"方案 |
| Induction iv† | 选择其一：• Propofol‡ • Kétamine + diazépam ou midazolam • Alfaxalone‡ | 选择其一：• Propofol‡ • Alfaxalone‡ | 任何可用的注射制剂 |
| Induction im | Morphinique + alpha2-agoniste + kétamine 或 tilétamine/zolazépam | Alpha2-agoniste + tilétamine/zolazépam | — |
| Maintien‡ | 选择其一：• Anesthésie par inhalation ou • Kétamine • Propofol‡ • Alfaxalone‡ | 选择其一：• Anesthésie par inhalation ou • Propofol‡ • Alfaxalone‡ | 任何可用的注射或吸入制剂 |
| Anesthésiques locaux | Bloc incisionnel ± intrapéritonéal | 同"含管制药物"方案 | 同"含管制药物"方案 |
| Analgésie postopératoire | AINS | AINS ± métamizole (dipyrone) | 同"无管制药物"方案 |

脚注同表 18。', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 22：骨科手术建议方案（三列；抽取文本严重错乱，逐段照抄）', '10.10 表 22：骨科手术建议方案（三列；抽取文本严重错乱，逐段照抄）

该表在法语抽取中三列文本交织成行，无法完全复原表格栏位归属。可读片段按原文顺序照录（"含管制药物 / 无管制药物§ / 镇痛药可及性低§"三列）：', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 22：骨科手术建议方案（三列；抽取文本严重错乱，逐段照抄） (2)', '- Préopératoire（片段照抄）："Morphinique + AINS ± agoniste du récepteur alpha2-adrénergique ± kétamine（chats uniquement）/ un agoniste ± alpha2-adrénocepteur ± métamizole (dipyrone) ou paracetamol (acétaminophène) – pas chez le chat ± gabapentine¶ / Identique au protocole sans médicaments réglementés"——栏位归属与"(chats uniquement)"的确切修饰对象无法从抽取文本确定，需核对原 PDF。
- Induction de l''anesthésie 与 Maintien de l''anesthésie：三列均"Voir tableaux 18 à 21"（见表 18 至 21）。
- Techniques d''anesthésie locale†：Choisissez l''une des options suivantes : • Blocs locorégionaux (par exemple MRUM, nerf sciatique-fémoral, incisionnel) • Blocs nerveux axiaux (p. ex. épiduraux)。注：正文脚注给出 RUMM = Bloc des nerfs radial, ulnaire, musculocutané et médian（桡、尺、肌皮与正中神经阻滞）；正文栏内拼作"MRUM"，两处不一致，照抄。
- Analgésiques peropératoires（术中镇痛）：含管制药物列——Bolus et/ou perfusions des produits suivants, seuls ou en association :‡ Morphiniques；Alpha2-agonistes；Kétamine；Lidocaïne (utiliser avec prudence chez le chat ; voir chapitre 2.5)。无管制药物列：（抽取顺序上先出现）"Identique au protocole avec médicaments réglementés"，随后为"• Alpha2-agonistes；• Lidocaïne (utiliser avec prudence chez le chat ; voir chapitre 2.5)；L''acupuncture peut également être utilisée"，再一列"Identique au protocole avec médicaments réglementés"、"Identique au protocole sans médicaments réglementés"——三列各自归属无法确定，需核对原 PDF。
- Immédiatement postopératoire (24 heures)：Options médicamenteuses：AINS (sauf s''ils ont déjà été administrés en pré-opératoire)；Perfusions peropératoires continues ou bolus avec réduction progressive des doses；Analgésiques d''appoint；Blocs anesthésiques locorégionaux ou cathéters de perfusion de plaie。Options non médicamenteuses：Traitement par le froid；Un bandage approprié；Positionnement soigné, literie confortable, support d''élimination；Massage doux des régions compensatoires (dos, membres non opérés)；Acupuncture；"Tendre, Aimant, Attentionné"（此三词为法语抽取对英文"tender, loving, care"的逐词直译，照抄）。另两列："Identique au protocole avec médicaments réglementés"。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 表 22：骨科手术建议方案（三列；抽取文本严重错乱，逐段照抄） (3)', '- Jours postopératoires ultérieurs（术后后续天数，含管制药物列）：Options médicamenteuses：Morphiniques avec augmentation progressive de la dose jusqu''à obtention de l''effet et arrêt progressif；Des anesthésiques locaux par cathéter de la plaie peuvent être utilisés jusqu''à la sortie de l''hôpital；Continuer les AINS pendant des jours ou des semaines sauf contre-indication；Métamizole (dipyrone)；Paracétamol (acétaminophène) – pas chez le chat；Analgésiques d''appoint (par exemple patchs de lidocaïne, gabapentine, amantadine)。Options non médicamenteuses：3  premiers jours : traitement par le froid pendant au moins 3 jours；Après 3 jours : alternance de traitement par le froid et la chaleur avant étirement et mise en charge douce (avec traitement par le froid après ces traitements)；Rééducation physique；Acupuncture。无管制药物列（¶）：不含 morphiniques 条目，其余与上述药物选项（伤口导管局麻药至出院；AINS 数日至数周除非禁忌；métamizole；paracétamol——猫禁用；辅助镇痛药）及非药物选项同前；可及性低列："Identique au protocole sans médicaments réglementés"。
- 表 22 脚注照抄：iv Intraveineuse，AINS Anti-inflammatoire non stéroïdien，RUMM Bloc des nerfs radial, ulnaire, musculocutané et médian。†Les injections intra-articulaires continues d''anesthésiques locaux sont contre-indiquées car elles peuvent endommager le cartilage ; le risque de contamination ascendante conduisant à une infection est élevé（局麻药持续关节内注射禁忌——可损伤软骨；上行污染导致感染的风险高）。‡Ces médicaments peuvent ne pas être nécessaires si un bloc d''anesthésie locale efficace a été réalisé, mais ils peuvent fournir une analgésie supplémentaire et réduire davantage les besoins en anesthésiques inhalés。§当阿片类不可得时，局部麻醉技术、NSAIDs、bolus 或静脉输注与非药物治疗成为关键。¶Le tramadol injectable (chats uniquement) peut être administré à la place du morphinique（注射用曲马多仅猫，可替代阿片类）。', 'cat', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'caution', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 区域（loco-régionales）技术（3.5）总则', '10.11 区域（loco-régionales）技术（3.5）总则

本章描述若干简单技术（详细操作见 Grubb & Lobprise 2020a,b 及 WSAVA 全球牙科指南的牙科神经阻滞描述 Niemiec et al. 2020；WSAVA GPC 网站有教学视频；不同阻滞技术需不同层级的培训）。除牙科神经阻滞外的所有区域麻醉技术务必保持无菌注射技术（术部剃毛与注射点无菌准备，见 encadré 9——其正文位于本稿切片范围之外）。须在麻醉或深度镇静的患者上实施，后者需复合镇痛药，因为这些操作本身是疼痛性的。进针完成后、注射局麻药前，轻轻回抽注射器；若抽出血液，则不注射并重新调整针位。虽然许多解剖标志和神经可经皮触诊，使用神经刺激器或超声引导技术可降低阻滞不全与神经、血管及其他结构损伤的风险。本切片止于"Anesthésie locale"小节标题；局部/睾丸内/腹腔内阻滞等具体技术正文在切片 030 之后，本稿未覆盖。

10.12 Encadré 6：犬股骨骨折修复方案示例（逐字）

- Préopératoire：AINS（24 heures 剂量；理想为犬获批产品）、méthadone 0,3 mg/kg im、acépromazine 0,02 à 0,03 mg/kg im。
- Induction de l''anesthésie：propofol 静脉按效应给予（à effet iv）。
- Maintien de l''anesthésie：吸入麻醉，并在手术前给予腰荐硬膜外 bupivacaïne 0,5 % + morphine（无防腐剂）0,1 à 0,2 mg/kg（1 ml/4 kg，至多 6 ml）。
- Immédiatement post-opératoire (pendant 24 heures)：méthadone 0,3 mg/kg im（toutes les 4 à 6 heures，依疼痛评分与补救镇痛需要），icing（原文 givrage，冰敷），关节活动度及其他非药物技术。
- Jours postopératoires ultérieurs：AINS（同术前药物，自术前剂量 24 heures 后开始）toutes les 24 heures，及 gabapentine（原文作 gabapen-étain，断词）5 à 10 mg/kg PO toutes les 8 à 12 heures，至术后 14 jours。继续非药物技术，随访时重新评估镇痛需求。', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · Encadré 7：猫股骨骨折修复方案示例（逐字）', '10.13 Encadré 7：猫股骨骨折修复方案示例（逐字）

- Préopératoire：AINS（24 heures 剂量；理想为猫获批产品）、méthadone 0,3 mg/kg im、médétomidine 0,01 mg/kg im。
- Induction de l''anesthésie：propofol 静脉按效应给予。
- Maintien de l''anesthésie：吸入麻醉，并在手术前给予腰荐硬膜外 bupivacaïne 0,5 % + morphine（无防腐剂）0,1 à 0,2 mg/kg（1 ml/4 kg，至多 6 ml）。
- Immédiatement post-opératoire (pendant 24 heures)：méthadone 0,2 à 0,3 mg/kg iv（toutes les 4 à 6 heures，依疼痛评分与补救镇痛需要），icing，关节活动度及其他非药物治疗。
- Jours postopératoires ultérieurs：buprénorphine 0,02 mg/kg OTM（如留置导管则 iv）toutes les 6 à 8 heures，至术后 3 jours（如可获得，可改用高浓度丁丙诺啡剂型 1,8 mg/ml 或丁丙诺啡透皮剂型；见表 12）。AINS（同术前药，自术前剂量 24 heures 后开始）toutes les 24 heures；参见猫获批 NSAIDs 标签。继续非药物技术，随访时重新评估镇痛需求。', 'cat', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 图 24-26 与图 31 的技术要点（切片内可读部分）', '11. 图 24-26 与图 31 的技术要点（切片内可读部分）

- 图 24，区域静脉麻醉（IVRA/Bier-block）：① 拟阻滞肢剃毛、导管穿刺点无菌准备，远端放置静脉导管（导管方向可为近端或远端双向）；② 固定导管，由远及近施加压迫绷带减少远端肢体血液；③ 在肘关节（或跗关节，原文"montant"疑为跗之误译）稍近端置止血带；④ 止血带保留时解除绷带；⑤ 经先前放置的导管静脉内注射局麻药。止血带可保留 60 minutes；须缓慢解除，因高浓度局麻药将一并释放入循环，可诱发局麻药毒性。
- 图 25，腰荐硬膜外麻醉：患者胸骨卧位、后肢前伸；也有人偏好侧卧。以示指触诊腰荐交界，拇指与中指置于髂翼；右手者左手定位、右手进针，左手者相反。"悬滴法"（pendaison-goutte）为正控机制：9 号生理盐水（NaCl 0,9 %）滴在针座上被硬膜外间隙负压吸入针内与间隙。
- 图 26：腰荐硬膜外（L7-S1，红圈）与尾荐（sacrococcygienne，蓝圈）给药位置。
- 局部麻醉应用的总类（切片 020 正文）：局部（跨黏膜）麻醉——某些局麻药涂布黏膜可在 5 minutes 内快速镇痛，应用部位包括角膜（眼科检查）、鼻腔（如置鼻氧管前）与插管时的喉；组织内镇痛深度通常限于 1 à 2 mm；局麻药经皮（角质层）吸收通常很低；lidocaïne 与 prilocaïne（丙胺卡因）共熔混合物涂皮并以封闭敷料覆盖 30 à 40 minutes 可产生皮肤麻醉——尤其便利犬猫置静脉导管或静脉穿刺前的局部镇痛。浸润麻醉——注射浸润在兽医常规进行，安全、可靠、不需丰富经验；须用无菌针；可沿腹壁切口与半椎板切除切口浸润（切口麻醉），术前和/或术后实施；半椎板切除中术前切口周围浸润较缝合时浸润获益更多（McFadzean et al., 2021）。区域麻醉——神经刺激器或超声定位外周神经可显著提高注药精度与阻滞效率，还可减少局麻药总量，从而减少运动副作用与吸收性全身毒性风险；如臂丛神经阻滞导致肘以下感觉与运动功能丧失。硬膜外麻醉——腰荐硬膜可用于膈以下所有手术的镇痛，尤适用于后肢骨科；尾荐硬膜可用于后段泌尿生殖手术。牙科神经阻滞——上颌与下颌神经阻滞对牙科操作或下颌/上颌手术极为有用，可分别阻滞眶下孔与颏孔出孔处，或行更近端阻滞以获得更大镇痛范围。腹腔内给予局麻药——WSAVA GPC 推荐腹腔内麻醉与浸润用于疼痛管理，尤其作为犬猫腹部手术的辅助技术（Steagall et al. 2020b）。
- 图 31，伤口输注导管：示例为犬前肢截肢（B、C）与后肢截肢（D）后可放置的无菌导管，用于输注局麻药。', '', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南——治疗与药物管理 · 原文缺失与抽取断裂位置汇总', '12. 原文缺失与抽取断裂位置汇总

1. 表 12 右侧"Commentaires"列存在逐行尾部字母脱落（如 morphine、péthidine、méthadone、hydromorphone、fentanyl、rémifentanil 各行），系双栏 PDF 抽取错位，剂量与频次列完整。
2. 表 13 脚注 † 为交叉错乱字符（疑为"不同国家获批产品可得性…优先使用获批兽药"），无法完整复原；‡"Dose en fonction du poids maigre"完整。
3. 表 14 中 xylazine 与 atipamézole 的选择性写作"1. 160""1. 8500"（句点疑似冒号误抽），照抄未改。
4. 切片 018 关于 détomidine 凝胶犬给药的"les effets cardiopulmonaires sont similaires à ceux induits par d''autres alpha2-agonistes et est ces deux derniers"句法断裂。
5. 切片 019 "Drug Administration des États-Unis"前机构名首词（Food and）缺失。
6. 切片 020 末—021 间，"Les techniques d''anesthésie régionale"与"Anesthésie intraveineuse régionale"细节部分依赖图注复原。
7. 切片 022 输注装置精度"faible précision ( 10%)"正负号丢失；"inhibiteurs de la recapture de la lidocaïne"一句语义不通（疑为对"利多卡因再摄取/清除"相关表述的误译或抽取错乱）。
8. 表 16 中 amitriptyline 犬给药途径列、prégabaline 的 13 à 19 mg/kg 评注栏位归属错位。
9. 切片 023 激光句"réduit l''inflammation et l''analgésie"语义矛盾、单位"10 à 20 J/ 2"上标残缺。
10. 切片 027 末表 18"Maintien de l''anesthésie"行被截断，其内容在切片 028 表 18 续列中复原。
11. 表 21 术前"±kétamine (chats uniquement)"栏位归属不确定；表 22 三列文本严重交织，多处栏位归属无法复原（Preop、术中镇痛与围术期部分）。
12. 图 25 说明"(B) et D)"标点残缺；切片 020 图 28（B）中"champs opératoires"（手术巾）为可疑误译。
13. 表 23、24 与 encadré 8、9 在切片 028/029 中被引用但正文位于切片 030 之后，本稿覆盖范围之外，原文此处缺失（对本稿而言）。
14. ranevetmab/frunevetmab 拼写两处不一致；"gabapen-étain"断词；"syndrome confusionnel"等个别词组疑为法语翻译瑕疵。', 'dog', '', '', '疼痛管理,AINS,表 12 阿片剂量,表 16 辅助镇痛,表 17 镇静麻醉药,Méthadone,慢性疼痛治疗概述与镇痛药物大类,NSAIDs 与其他抗炎药', 'informational', '2022 WSAVA 疼痛全球指南——治疗与药物管理', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 局部区域阻滞技术的续（3.5 章节后半，块 030–031）', '> 来源机构：WSAVA Pain Management Guidelines Task Force / WSAVA Global Pain Council (GPC)（世界小动物兽医协会全球疼痛委员会）。
> 原始文档：《Guide mondial de gestion de la douleur de la WSAVA (2022)》（2022 WSAVA 犬猫疼痛识别、评估与治疗全球指南），发表于 Journal of Small Animal Practice · Vol 64 · Avril（四月）2023 · © 2022 World Small Animal Veterinary Association (WSAVA) / British Small Animal Veterinary Association；DOI 10.1111/jsap.13566。
> 本稿基于**法语译本**（英文完整版在 Wiley 付费墙内、HTTP 403；官网仅提供法语完整译本），据法语原文撰写中文整理稿。
> 数值、剂量、百分比、药名与结论一律以原文（法语译本）为准；抽取稿中的连字（ﬀ/ﬂ）、断词、OCR 噪声造成的乱码或明显拼写错误照录并标注〔原文如此〕，不作猜测修正。
> 本稿覆盖分块 **030–043**（约 14 万字符）。001–029 的内容见 `01-疼痛全球指南2022-概述与评估.md` 与 `15-`（治疗与用药上半部分）。

1. 局部区域阻滞技术的续（3.5 章节后半，块 030–031）

本章承接上半部分，讲切口的浸润麻醉与若干特定部位阻滞。

1.1 切口浸润 / 局部浸润（anesthésie incisionnelle）

- 任何伤口（创伤性或手术性）或任何组织都可浸润局部麻醉药。举例：卵巢子宫切除（ovar io hystérectomie，原文断词）前的开腹术（célitomie），可沿伤口两侧全长浸润各层（肌肉、皮下、皮下〔原文如此，"sous-cutané, sous-cutanée"重复〕）。
- 犬猫可用药物与剂量：**bupivacaïne（布比卡因）2 mg/kg** 或 **lidocaïne（利多卡因）5 mg/kg**。可用无菌溶液增加注射体积（在不增加剂量的前提下稀释）。
- WSAVA 全球疼痛委员会（GPC）已就此发表简短综述（Steagall et al. 2020b）。
- 技术：移动针头技术（technique d''aiguille mobile）——将针插入组织，回抽确认不在血管内，然后在边退针边注射局部麻醉药。原文附视频链接：https://www.youtube.com/watch?v=43Km46WJ2zI', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 睾丸内阻滞（Bloc intratesticulaire）', '1.2 睾丸内阻滞（Bloc intratesticulaire）

- 在犬猫全身麻醉下进行，可提供术后镇痛、减少吸入麻醉药需求、减轻手术交感反应。
- 药物与剂量：**Lidocaïne 或 bupivacaïne**——猫 **0,2 至 0,3 ml/面（face）**；犬 **0,5 至 1 ml/面**〔原文跨页断行，"chez le chat ; 0,5 à 1 ml/face … chez le chien"〕。
- 注射入睾丸实质（parenchyme testiculaire），由淋巴管吸收，使**精索（cordon spermatique）**去敏（Fig 32）。可另做切口阻滞以让皮肤去敏。视频链接：https://www.youtube.com/watch?v=VHfqoUPse-c
- Fig 32 图注：针头插入睾丸中央，注射 lidocaïne；每只睾丸注射约 **0,1 至 0,25 ml**，视猫体型（幼猫 vs 成年猫）而定；注射后睾丸会变硬（deviendra ferme）。插图作者 Alice MacGregor Harvey。

1.3 环形阻滞（Bloc en anneau）

- 可在肢体远端或尾部实施，使用 lidocaïne 或 bupivacaïne 等。
- **含肾上腺素（adrénaline / épinéphrine）的局麻溶液绝不用于此类阻滞。**
- 技术：围绕肢体做皮下浸润，使阻滞部位以远的浅感觉神经和远端分支去敏（Figures 33 与 34）。
- Fig 33 图注：犬前肢（membre thoracique）环形阻滞示意；针平行于皮肤刺入皮下，回抽阴性后边缓慢退针边注射，环绕肢体一圈重复，与切口线阻滞类似。
- Fig 34 图注：犬断尾术（amputation de queue）环形阻滞示例。图片经 Sheilah Robertson 授权使用。

1.4 腹膜内阻滞 / 腹膜内镇痛（Bloc intrapéritonéal）

- 腹膜内镇痛是腹部手术后其他镇痛药的有用补充，**尤其是在吗啡类（morphiniques）不可得时**（Steagall et al. 2020b）。
- 须在全身麻醉下操作，以避免腹腔脏器撕裂/穿刺及 bupivacaïne 引起的腹膜炎。药物与剂量：**bupivacaïne 2 mg/kg（犬或猫）**。
- 提供早期术后镇痛，但**不抑制交感反应、也不在术中对内脏麻醉**。
- 可与生理盐水等量稀释以增加腹膜内注射体积；可在卵巢子宫切除前或腹部探查术关腹前直接注入腹膜腔；需无菌技术。视频链接：https://www.youtube.com/watch?v=eLa1UxWboh0', '', 'young', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 围手术期方案表（Tableau 23 / 24，块 030–031）', '1.5 围手术期方案表（Tableau 23 / 24，块 030–031）

两表均为「小型软组织手术（chirurgie mineure des tissus mous）」的三列方案：**含管制药物方案 / 不含管制药物方案 / 镇痛药匮乏方案**。抽取稿表格 OCR 较乱，以下按可读要点整理，标注〔原文如此〕。

| 阶段 | 含管制药物方案 | 不含管制药物方案 | 镇痛药匮乏方案 |
|---|---|---|---|
| 术前（Préopératoire） | 吗啡类 + AINS ± α2 肾上腺素能药 ± kétamine | AINS ± α2 受体激动剂 + métamizole（dipyrone，安乃近）或 paracétamol（acétaminophène，对乙酰氨基酚）—**猫不用** ± gabapentine‡ | 同「不含管制药物方案」 |
| 麻醉诱导 / 维持 | 见 Tableau 18 至 21 | 见 Tableau 18 至 21 | 见 Tableau 18 至 21 |
| 局麻技术 | 选其一：局部区域阻滞（如切口阻滞 / Tableau 24 中为肋间阻滞 intercostaux）；轴性神经阻滞（如硬膜外） | 同「含管制药物方案」 | 同「含管制药物方案」 |
| 术中（Peropératoire，仅 Tableau 24） | 下列药物单用或联用的 bolus 和/或输注§：吗啡类、α2 激动剂、kétamine、lidocaïne（猫慎用，见 2.5 章） | 同左但列 α2 激动剂、lidocaïne（猫慎用） | 同「不含管制药物方案」 |
|  immediate 术后（24 h） | 药物：AINS（若术前已给药则除外）、吗啡类；输注/减量、辅助镇痛（lidocaïne 贴片、gabapentine、amantadine）、局部区域阻滞或伤口输注导管。非药物：冷敷、合适绷带、精心体位与舒适垫料、排泄支持、针灸、"Tendre, Aimant, Attentionné"〔温柔、关爱、体贴，原文如此〕 | 药物：AINS + métamizole（dipyrone）或 paracétamol—猫不用；余类同左 | 同「不含管制药物方案」 |
| 后续术后日 | 继续 AINS 数日至数周（除禁忌）；métamizole（dipyrone）；paracétamol—猫不用；前 3 天冷敷至少 3 天；3 天后冷/热交替；针灸；（Tableau 24 另含）物理康复、局麻伤口导管至出院、吗啡类加量至起效后递减 | 类同 | 同「不含管制药物方案」 |

表脚注（逐字要点）：iv Intraveineuse（静脉），AINS 非甾体抗炎药，RUMM = 桡、尺、肌皮、正中神经阻滞（Bloc des nerfs radial, ulnaire, musculocutané et médian）〔该缩写在 Tableau 23 脚注中出现，正文未见展开，原文此处缺失〕。† 当无吗啡类可用时，局麻技术、AINS、静脉 bolus/输注与非药物治疗变得至关重要。‡ 注射用 tramadol（曲马多，仅猫）可替代吗啡类。§ 若已完成有效局麻阻滞，这些药物可能并非必需，可提供额外镇痛并进一步减少吸入麻醉药需求。', 'cat', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · Encadré 8：猫注射部位肉瘤（sarcome au site d''inje', '1.6 Encadré 8：猫注射部位肉瘤（sarcome au site d''injection）手术方案（大型软组织手术）

逐字照录药物剂量：

- **术前**：AINS（24 小时剂量；猫已批准），méthadone 0,3 mg/kg im，kétamine 5 mg/kg 与 midazolam 0,25 mg/kg im。
- **麻醉诱导**：Propofol 至效应（iv，原文 "à effet iv"）。
- **麻醉维持**：吸入麻醉 + 恒定速率输注（CRI）fentanyl 5 至 10 μg/kg/h（先负荷量 5 μg/kg iv），及 kétamine 2 至 10 μg/kg/min（先负荷量 0,5 mg/kg iv）；用局麻药做浸润麻醉，考虑置入伤口输注导管。
- **immediate 术后（24 h）**：CRI fentanyl 1 至 3 μg/kg/h 与 kétamine 2 至 10 μg/kg/min；冷敷 ± 针灸；伤口治疗导管给予 bupivacaïne 0,5%（每 8 小时至多 2 mg/kg）。
- **后续术后日**：buprénorphine（丁丙诺啡）0,02 mg/kg OTM（经口腔黏膜，若有导管可 iv），每 6 至 8 小时，至术后 3 天（若有高浓度剂型 1,8 mg/ml 或经皮贴剂可替代；见 Tableau 12）；AINS（用术前同一药物，自术前剂量起 24 小时后开始），每 24 小时；见猫用 AINS 批准标签；继续非药物技术，复诊时重新评估镇痛需求。

1.7 Encadré 9：局麻阻滞安全有效应用的关键步骤

- 务必使用无菌技术；除牙科阻滞外，注射区域应剃毛并准备。
- 计算安全最大剂量且不超过；若需更大体积以扩大药物分布，用氯化钠稀释局麻药。
- 选用合适规格的针头与注射器，以减少组织损伤并保证精确给药。
- 通过回抽注射器、确认无血液回抽后再注射，避免误入血管。', 'cat', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 眼科方案（3.6，块 031）', '2. 眼科方案（3.6，块 031）

- 眼、眼睑及周围组织手术可致轻度至重度疼痛；对宠物眼痛知之甚少，需研究疼痛诱发的行为与镇痛需求。
- 结膜与角膜可用**局麻滴眼液局部去敏**：proxymétacaïne（丙对卡因）、tétracaïne（丁卡因）、proparacaïne（奥布卡因）。**须限制使用次数**，尤其 tétracaïne 反复应用可致上皮性或基质性角膜炎（Giuliano 2008）。表面局麻药作用约 **15 分钟**，适于眼科检查或快速取出异物。**必须滴人工泪液**。
- **球后 / 眼球周围阻滞（anesthésie rétro-/péri-bulbaire）**可麻醉眼部（视神经、动眼、滑车、眼、上颌及外展神经），与吗啡类和 AINS 联用（Shilo-Benjamini 2019，Grubb & Lobprise 2020b）。多技术见文献。
- 下-外侧（inféro-temporal）球后阻滞用 **bupivacaïne 0,5%（≤15 kg 犬 2 ml；>15 kg 犬 3 ml；约 1 ml/10 kg）**可给犬摘除术（énucléation）后提供早期术后镇痛（Myrna et al. 2010）。回顾性研究显示未做阻滞者术后苏醒并发症风险更高；术中出血风险不因是否做球后阻滞而改变（Bartholomew et al. 2020）——即该技术在犬摘除术中不增加并发症风险。
- **Lidocaïne（bolus 2 mg/kg 继以 CRI 25 至 50 μg/kg/min）**可提供与 morphine 类似的犬眼科手术术中镇痛；但与局麻阻滞联用持续输注 lidocaïne 须防毒性。**猫的 lidocaïne 输注因血流动力学紊乱风险须慎用**（见 2.5 章）。
- **全身 AINS**（术前 24 小时起）在眼科手术中适用，可镇痛并降低葡萄膜炎及前列腺素生成性房水导致后房涌出的风险。术中与术后给予吗啡类和/或 α2 激动剂可增强局麻药与 AINS 的镇痛效果。
- 眼压（PIO）相关：**morphine 致犬缩瞳（myosis）、猫散瞳（mydriase）**。优选吗啡类（méthadone、buprénorphine），因其不引起呕吐、不升高眼压 PIO。**kétamine（0,5 至 1 mg/kg）**因增强眼外肌张力可升高眼压；对升高 PIO 可能致眼内容物脱出（如角膜外伤）者须慎用，若用 kétamine 可同时给苯二氮䓬类、α2 激动剂以减轻。**亚麻醉剂量 kétamine（2 至 10 μg/kg/min）用于镇痛时不太可能改变 PIO**。
- 术后：冷敷消肿；可给 AINS（全身和/或局部）；gabapentine（犬猫）与 paracétamol（acétaminophène，仅犬）可考虑用于居家术后镇痛，但证据很少。**tramadol 在犬摘除术后无镇痛效果，不应使用**（Delgado et al. 2014）。全麻与吗啡类减少泪液分泌，**术后应滴人工泪液 1 至 3 天**。', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 牙科方案（3.7，块 031–032）', '3. 牙科方案（3.7，块 031–032）

- 口腔疾病常伴疼痛与炎症。围手术期及出院后数天须有镇痛计划（Tableau 25）。各物种具体剂量见 2.2、2.3、2.4、2.5 章表格。
- 围手术期吗啡类（hydromorphone、méthadone、morphine、butorphanol、buprénorphine）的选择基于疼痛严重度。
- 需拔牙时应按受累区域使用局部麻醉技术（见 2.5 章及 WSAVA 全球牙科指南），包括**眶下（infraorbitaire）、下牙槽（alvéolaire inférieur）、下颌（mandibulaire）、上颌（maxillaire）、腭（palatin）与颏（mental）神经阻滞**。

3.1 Tableau 25：牙科手术（如拔牙）方案

三列同前（含管制药物 / 不含管制药物 / 镇痛药匮乏）。

| 阶段 | 含管制药物方案 | 不含管制药物方案 | 镇痛药匮乏方案 |
|---|---|---|---|
| 术前 | 吗啡类 ± acépromazine（乙酰丙嗪）或 α2 激动剂或苯二氮䓬类（midazolam 或 diazépam）± AINS | acépromazine 或 α2 激动剂或苯二氮䓬类（midazolam 或 diazépam）± AINS‡ | 同「不含管制药物方案」，或 xylazine（木甲苯胺） |
| 麻醉诱导 | 见 Tableau 18 至 21 | 同「含管制药物方案」 | 同「含管制药物方案」 |
| 麻醉维持 | isoflurane 或 sévoflurane（异氟烷/七氟烷）吸入麻醉 | 同「含管制药物方案」 | iv 至效应：pentobarbital、thiopental、propofol 或 alfaxalone；iv 或 im：tilétamine/zolazépam（替来他明/唑拉西泮） |
| 局麻技术 | 视情况做牙科阻滞（2.5 章） | 同「含管制药物方案」 | 同「含管制药物方案」 |
| immediate 术后（24 h）及后续日 | 药物：AINS（除禁忌，若术前给药则间隔 24 小时）并持续数日；吗啡类。非药物：软食；"Tendre, Aimant, Attentionné" | 药物：AINS（除禁忌、术前给药者间隔 24 小时）并持续数日；métamizole（dipyrone）；paracétamol（acétaminophène）—猫不用。非药物：软食；温柔关爱 | （抽取稿此列未填，原文此处缺失） |', 'cat', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 急诊与重症（3.8，块 031–032）', '4. 急诊与重症（3.8，块 031–032）

- 受伤或患病动物需对疼痛疾病及诊断/急诊操作进行镇痛。因安全性，**吗啡类是重症监护病房（USI）即刻镇痛的支柱**，多数还提供一定镇静，便于操作与诊断（2.2 章）。
- 尽早建立静脉通路以纠正容量缺失、滴定额外镇痛与镇静药至起效（Dyson 2008，Hansen 2008，Tainter 2012）。
- 一般优选短效吗啡类，从推荐剂量的 **10% 至 20%** 开始逐步加量至阳性反应（疼痛缓解），同时避免不良反应；随患者稳定与频繁评估启动并调整 CRI。
- **NMDA 拮抗剂（如 kétamine）**可预防或治疗中枢敏化，尤其伴神经病理性成分的重度侵入性疼痛。Kétamine 输注 **5 至 10 μg/kg/min（先 bolus 0,2 至 0,3 mg/kg iv）**可与吗啡类同时或之后开始；应输注给药（bolus 作用短、更易诱发行为改变）。
- 犬猫可用 lidocaïne iv（负荷量与输注），但**猫输注须慎用**（血流动力学紊乱风险，见 2.5 章）。CRI 速率据疼痛评估、耐受与反应调整（阵发性疼痛发作时上调，过度镇静难唤醒时下调）。
- **AINS** 在急诊/重症可能有用，但须暂停至容量、心血管与肾状态稳定，且不用于非胃肠道疾病；无禁忌时可减轻继发炎症级联（Monteiro-Steagall et al. 2013）。低剂量 **α2 激动剂（dexmédétomidine、médétomidine）**可作多模式镇痛一部分，提供镇静与肌松（2.4 章）。
- 应激、恐惧与焦虑管理在重症与住院病例中很重要，可用药物（trazodone、acépromazine 或 gabapentine）、护理与低应激操作处理（Lefman & Prittie 2019）。

4.1 资源（Ressources）

- CRI 计算器见国际兽医疼痛管理学院网站：https://ivapm.org/professionals/cri-calculator/', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 内科疼痛（Douleur médicale，3.9，块 032）', '5. 内科疼痛（Douleur médicale，3.9，块 032）

- 「内科疼痛」指并非主要由手术或创伤引起的疼痛状态。腹痛、胸痛与内脏痛见于腹腔膨胀、空腔器官炎症、缺血、肺血栓、含脏器急性膨胀伴被膜牵张、或任何器官炎症（急性肾损伤、肺炎或胸膜炎）。内脏痛往往弥散、难以定位。
- 目标是治疗潜在内科问题，但确诊前与治疗期间常需镇痛（Tableau 26）。辅助疗法在各疼痛级别可用：止吐与抗恶心药（有呕吐/恶心时）；针灸（尤其胃肠与泌尿疼痛，亦可用于呕吐，Wright 2019）；医疗按摩、冷敷与热敷；改善环境以减轻猫的压力与焦虑，信息素疗法（phéromonothérapie）可能有用（Kronen et al. 2006）。

5.1 Tableau 26：内科来源重度、中度、轻度疼痛的治疗选项

| 疼痛严重度 | 治疗选项 |
|---|---|
| 重度疼痛 | 激动型吗啡类滴定至起效（2.2 章）；避免引起呕吐的吗啡类（如 morphine 或 hydromorphone）；推荐吗啡类输注。血流动力学稳定且无禁忌时用 AINS（2.3 章），可与吗啡类联用。局部区域麻醉技术（3.5 章）。Kétamine（2.7 章）和/或 lidocaïne CRI（2.5 章），猫输注须慎用。胸膜内与腹膜内阻滞（Steagall et al. 2020b）分别用于躯体痛与内脏痛 |
| 中度疼痛 | μ 激动型吗啡类（同重度）。频繁 IM 或 SC 注射疼痛且应激，应尽量避免，推荐留置静脉导管给 iv。血流动力学稳定无禁忌时用 AINS，可与吗啡类联用。Kétamine（2.7 章）和/或 lidocaïne CRI（2.5 章），猫慎用。buprénorphine 可用于多模式镇痛、疼痛已控制时（2.2 章） |
| 轻至中度（非住院或住院） | 首选 AINS（无禁忌）± buprénorphine（适合居家管理）。**Gabapentine 10 mg/kg PO 犬每 8 小时，猫每 12 小时**可能有益，但急性痛证据少；加巴喷丁类更适合自然慢性内科痛伴神经病理性成分；可见镇静；肾病者须调整剂量。口腔冲洗液缓解口炎疼痛（3.14 章〔原文此处章节号存疑〕）：用注射器含下列之一轻柔冲洗口腔——**lidocaïne 黏稠液 2% 与氢氧化镁/铝、diphénhydramine（苯海拉明）按 1:1:1 混合：最大剂量 0,4 ml/kg 每 8 小时**（De Lorimier & Fan 2005，Shanan et al. 2017）；**绿茶漱口液**可用于口腔或伤口（Liao et al. 2021） |', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 儿科疼痛（Douleurs pédiatriques，3.10，块 032–03', '6. 儿科疼痛（Douleurs pédiatriques，3.10，块 032–033）

- 人新生儿研究示：麻醉/镇痛中断时（如 circumcision 包皮环切），后续疼痛体验（如接种）的痛敏增高，接受镇痛者则否（Taddio et al. 1997），成年后应激与焦虑易感性亦增高——提示婴儿对疼痛经历保留「记忆」，日后对伤害性刺激反应改变。此类现象亦见于动物（Anand et al. 1999），人新生儿镇痛知识可外推至动物（Lee 2002）。
- AAFP/AAHA 生命周期指南简化了分期：**幼猫/幼崽（chaton）出生至 1 岁、年轻成年（jeune adulte）1 至 6 岁、成熟成年（adulte mature）6 至 10 岁、老年（aîné）10 岁及以上**（Quimby et al. 2021）。犬品种寿命不一，但可用相似分期；仍可将 **12 周龄以内的幼猫或幼犬**视为儿科患者。
- 年轻动物镇痛给药常被顾虑「药物代谢能力下降、过量风险高」。此顾虑可能存在，但关于幼犬幼猫发表研究很少，给药仍是挑战（Ku & Smith 2015）。年轻动物多种药物清除率降低，主要因：体水分含量高致分布容积大；高灌注组织占体重比例大；肝酶未成熟；肾小球滤过率与肾排泄降低。肝肾系统在生命早期持续发育，代谢与排泄下降，可能需调整剂量与给药间隔。作用于 CNS 的药物（吗啡类、镇静剂、安定类、麻醉药）可在新-born 脑达到更高浓度，因血脑屏障差异与外排转运系统不成熟（Ku & Smith 2015）。

6.1 吗啡类（儿科）

- 过量出现临床征象（呼吸抑制、过度嗜睡）时可用 **naloxone（纳洛酮）滴定**拮抗。
- 新生幼犬（0 至 2 周）镇痛所需 fentanyl 与 morphine 剂量低于 5 周幼犬（Luks et al. 1998）；幼犬幼猫对 morphine 的镇静与呼吸抑制亦更敏感。
- **fentanyl** 或因作用短而更适于儿科，需连续 iv 并滴定（Luks et al. 1998）。**buprénorphine** 可为替代，呼吸抑制极小。猫 6 月龄给予 hydromorphone 后的热抗伤害感受持续时间与幅度均短/低于 9 与 12 月龄猫（Simon et al. 2019）。任何情况下以临床反应指导剂量。', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 非甾体抗炎药（儿科）', '6.2 非甾体抗炎药（儿科）

- AINS 在 <12 至 16 周龄宠物鲜有上市许可；但 **méloxicam（美洛昔康）**在部分国家批准用于 **6 周龄及以上**的犬猫。这不代表年轻人不可用，只是缺乏各年龄段临床前试验。AINS 用于幼龄绝育犬猫。
- 8 至 12 周龄性成熟前幼猫（n = 380）行卵巢子宫切除或去势，术前给 carprofène（卡洛芬）或 méloxicam，未报告不良反应（Porters et al. 2015）。须确认患者适合用 AINS（非低血容量或低血压，见 2.3 章）。

6.3 局部麻醉药（儿科）

- **表面局麻**：包括 lidocaïne 2,5% 与 prilocaïne（丙胺卡因）2,5% 的共熔混合物（EMLA），及脂质体包封 lidocaïne 4% 制剂，可让皮肤去敏，适于静脉穿刺、置 iv 导管等浅表小操作。捏起并清洁皮肤，涂麻醉膏，覆以封闭敷料（如薄塑料膜），用多功能自粘绷带固定。起效时间不一，约 15 至 20 分钟。**猫**未报告不良作用，无论产品本身或经皮吸收 4% 脂质体 lidocaïne 膏（按 15 mg/kg），血浆浓度远低于该物种中毒水平（Fransson et al. 2002，Gibbon et al. 2003）。
- **注射局麻**：尽量使用局麻技术；选剂量须考虑新生器官成熟度与体成分。重复注射或连续输注（如 iv lidocaïne）可致蓄积，应避免或慎用；重复给药时后续剂量或 CRI 速率应低于成年，并密切监测毒性（2.5、3.5 章）。清醒患者可减小注射痛：用细针（**27 至 30 G**）、缓慢注射、用碳酸氢钠缓冲〔原文 "tamponnant avec du bicarbonate de sodium"〕、将溶液加温至体温。

6.4 α2 受体激动剂（儿科）

- 新生儿心输出量依赖心率，α2 激动剂伴心动过缓，故**不推荐**。但许多儿科麻醉方案成功采用 α2 激动剂（médétomidine 或 dexmédétomidine）+ kétamine + 吗啡类的全静脉技术；已有 <12 周龄幼猫多例报道（Joyce & Yates 2011，Porters et al. 2015）。

6.5 非药物技术（儿科）

- 良好护理与低应激操作对所有患者重要；新生儿应避免母子与同窝分离。人新生儿用非药物技术配合镇痛（Riddell et al. 2015），鼓励对幼犬幼猫采用整合方法。可考虑：哺乳、襁褓包裹（emmaillotement）、与母犬母猫（或人）的身体接触、保暖（Gray et al. 2012，Riddell et al. 2015）。', '', 'young', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 皮肤病（3.11，块 033–034）', '7. 皮肤病（3.11，块 033–034）

- 皮肤病炎症可致中度至难以忍受的疼痛（如坏死性筋膜炎 fasciculite nécrosante）。**瘙痒（prurit）**是犬猫常见感觉，与疼痛多相似。瘙痒定义为引起强烈抓挠欲望的不愉快感觉，负面损害生活质量（QoL）（Grundmann & Stander 2011）。
- 疼痛与瘙痒均由无髓鞘、慢传导的 **C 纤维**传导，但生理机制多有差异。瘙痒由真皮伤害性化学感受器与位于真皮-表皮交界的多模式伤害性感受器游离神经末梢介导；瘙痒 C 纤维通路含对组胺反应的机械不敏感 C 纤维。触发这些纤维释放乙酰胆碱、儿茶酚胺、P 物质（substance P）、生长抑素、神经降压素等递质与神经肽，共同促成瘙痒（Burkhart & Burkhart 2003）。慢性瘙痒难题：抓挠立即带来心理与生理缓解，但持续抓挠致进一步炎症、外周与中枢敏化加重瘙痒，感染为另一并发症。主人填写的 QoL 问卷已用于患瘙痒性皮肤病的犬猫，证实瘙痒降低动物与主人的 QoL（Noli et al. 2011a b, 2019）——故须有效管理瘙痒，并确定病因。

7.1 治瘙痒的四类药物

- **corticostéroïdes（皮质类固醇）**；**Janus 激酶（JAK）抑制剂（如 oclacitinib）**；**环孢素类（cyclosporines，如 cyclosporine）**；**抗 NGF 单克隆抗体（如 lokivetmab）**。选择取决于瘙痒病因、物种（注册考量）与不良反应（Olivry et al. 2015，Saridomichelakis & Olivry 2016）。

7.2 瘙痒的特异镇痛（块 034）

- 镇痛药可联合特异药物预防痒感。吗啡类**不是**瘙痒相关疼痛的一线药，因全身性阿片虽罕见但可因组胺释放引起瘙痒。
- AINS 对炎症相关疼痛常高效，但**不能与皮质类固醇同用**。已见瘙痒相关的神经病理性疼痛综合征（如空腔畸形/脊髓空洞症 syringomyélie 相关瘙痒、肢端 mutilation/自残综合征 acral mutilation；见 1.9 与 3.12 章），可对该类用 gabapentine 或 prégabaline（普瑞巴林）起效，但缺乏稳健研究。', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 耳部疾病（Maladie de l''oreille / otite extern', '7.3 耳部疾病（Maladie de l''oreille / otite externe）

- 外耳炎常见（尤其犬），可依病因与对内科治疗反应行内科或外科处理；患犬可感难以忍受疼痛，故需镇痛并特异治疗。
- **AINS 是犬猫耳部疾病疼痛的一线**，但仅在未开皮质类固醇时。若已用皮质类固醇，镇痛更难，而 **paracétamol（acétaminophène）可与皮质类固醇安全联用于犬，猫则不可**。
- 围手术期（全耳道切除术 ablation totale du conduit auditif 或鼓泡切开术 ostéotomie bulleuse centrale）后疼痛可用**完全 μ 激动剂（bolus 或输注，2.2 章）**，联合 kétamine 输注等。居家时若 AINS 禁忌，无充分证据指导口服镇痛选择；若疑有神经病理性成分（如慢性外耳炎）则用 gabapentine。**犬（非猫）**可将 paracétamol（acétaminophène，± codéine 可待因）与 AINS 或皮质类固醇联用于居家镇痛。

8. 神经病理性疼痛方案（3.12，块 034）

- 神经病理性疼痛通常难治，建议基于人医文献与渐增兽医数据（Rusbridge et al. 2010）。
- **加巴喷丁类（gabapentine 或 prégabaline）**为一线，显著改善 QoL（Plessas et al. 2015，Batle et al. 2019），用于神经病理性疼痛的内外治疗（Sanchis-Mora et al. 2019，Schmierer et al. 2020，Thoefner et al. 2020）。疑合并炎症病时可联用 AINS。
- **NMDA 拮抗剂（amantadine，金刚烷胺）**用于 AINS 单药治疗无效的犬骨关节炎，提示此类病例潜在神经病理性成分（Lascelles et al. 2008）。抗 NGF 单抗在神经病理性疼痛中的作用未研究，但或有获益。
- **吗啡类可经神经炎症与胶质放大加重慢性神经病理性疼痛。**
- 物理疗法针对肌筋膜来源神经病理性疼痛：热/冷疗、针灸与触发点播散（aiguilletage des points de déclenchement）、牵伸、按摩、运动；均需更多兽医研究（Shah et al. 2015）。需更多研究涵盖不同神经病理性疼痛的治疗选择及安慰剂效应。', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 慢性神经病理性疼痛患者', '8.1 慢性神经病理性疼痛患者

- 见于椎间盘病（discopathie intervertébrale）、截肢或开胸术后慢性疼痛、Chiari 样畸形、脊髓空洞症、糖尿病神经病变、口面部疼痛综合征、马尾综合征等——多模式镇痛获益最大；有时需以「试错」确定最佳方案。须纳入非药物技术。
- 犬猫药物可**以 AINS 联合一种或多种辅助镇痛起始（剂量见 Tableau 13 与 16）**：gabapentine、prégabaline、amantadine、amitriptyline（阿米替林）。最终联合与疗程依患者反应与不良反应而定；镇痛方案可缓慢减量并密切监测以防疼痛征象复发。

8.2 急性/慢性神经病理性疼痛患者

- 犬猫若呈现重度痛觉过敏（hyperalgésie）与异常性疼痛（allodynie）征象，可能需住院行神经调节技术（局麻阻滞）和/或 iv 镇痛：**lidocaïne（bolus 1 mg/kg，CRI 30 μg/kg/min）**（猫输注须慎用，血流动力学风险，见 2.5 章），或 **kétamine（bolus 0,5 至 1 mg/kg，继 CRI 2 至 10 μg/kg/min）**联合全身吗啡类，直至临床征象改善。可能继发神经病理性疼痛的侵入性手术患者见 3.3 章。', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'caution', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 肌肉骨骼疼痛 / 骨关节炎（3.13，块 034）', '9. 肌肉骨骼疼痛 / 骨关节炎（3.13，块 034）

- 骨关节炎（arthrose，OA）与退行性关节病（DJD）疼痛管理近二十年日趋复杂，推荐繁多但效力不一（Aragon et al. 2007，Sanderson et al. 2009，Vandeweerd et al. 2012，Monteiro 2020）。包括但不限于：手术、全身镇痛（AINS、paracétamol〔猫不用〕、皮质类固醇）、局部给药（经皮或关节内）、居家锻炼、诊所治疗性运动、体重控制、营养支持、按摩、针灸、激光治疗、冷/热疗、肌肉电刺激、经皮电刺激、关节活动。
- 每个患者的 OA/DJD **不是单一问题**；生长期、成年、老年犬猫表现不同，需不同方法以优化管理。无论病期或所选治疗，兽医目标是最大化获益、最小化风险。治疗支柱为缓解疼痛；目前**经证明的镇痛选项**为 COX 抑制性与非 COX 抑制性 AINS〔原文括注 "(graphiturant)"，疑 OCR 噪声，〔原文如此〕〕及抗 NGF 单抗。
- 犬猫 OA 疼痛治疗大类：
  - **非手术、非药物**：运动；体重优化；饮食调节（类型、量）；治疗性运动与物理方式；环境改造；营养补充；针灸。
  - **全身与局部给药**：批准治 OA 药物（COX 抑制/非抑制 AINS、抗 NGF 单抗）；其他镇痛含 paracétamol（acétaminophène，猫不用）、皮质类固醇（治致多关节炎的潜在免疫介导病，或关节内局部治疗）；辅助镇痛（如猫 tramadol、amantadine、gabapentine、三环类抗抑郁药）；推测的疾病改善药（如 **glycosaminoglycane fumé**〔原文如此，疑指 polysulfated glycosaminoglycan 聚硫酸糖胺聚糖〕）。
  - **手术**：关节置换、切除成形术（arthroplastie par excision）、关节固定术（arthrodèse）、关节去神经术（dénervation articulaire）。各法效力差异巨大，兽医比较疗效信息少；人医研究提供相对效力信息（Zhang et al. 2010，Katz et al. 2021）。
- 循证（Medecine fondée sur des données probantes）：效力证据权重最高者为 COX 抑制/非抑制 AINS〔原文括注 "(piprant)"，疑 OCR 噪声，〔原文如此〕〕、抗 NGF 单抗、体重管理、饮食优化（ω-3 脂肪酸含量）与运动（Aragon et al. 2007，Sanderson et al. 2009，Enomoto et al. 2019，Monteiro 2020）；医生应优先效力最大者。', '', 'senior', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 癌性疼痛（3.14，块 034–035）', '10. 癌性疼痛（3.14，块 034–035）

- 肿瘤患者疼痛可与癌症本身、诊断操作或治疗相关，也可无关。癌症本身疼痛严重度依病程、部位与类型而异，可伴炎症、组织浸润、机械因素（如器官膨胀）、神经浸润或压迫及肿瘤释放因子。多数肿瘤患者病程中某时点会疼痛。人医中淋巴瘤与白血病疼痛患病率较低；动物各肿瘤类型疼痛患病率与严重度记录不清。记录最充分的癌痛之一为原发或转移骨肿瘤相关疼痛——机制为直接骨侵犯、微骨折、骨内膜压力增高、骨膜扭曲或炎症〔跨页断词 "péri-lésionnelle"〕；另一关键机制为释放化学物质（胺、肽、脂肪酸、钾、前列腺素，Mantyh 2014）。
- 癌痛尤其骨痛常伴神经学征象。骨肿瘤犬可出现广泛躯体感觉敏感，临床疼痛通常对口服镇痛药的姑息治疗抵抗（Monteiro et al. 2018）。抗癌治疗——化疗药〔化疗诱发周围神经病变 CIPN（原文缩写 NCIP），Argyriou et al. 2014〕与放疗〔放疗相关疼痛 RAP/原文缩写 PAR，Trotti et al. 2003〕——可在治疗时及此后长期伴显著疼痛；CIPN 与 PAR 机制不清、正被研究（Nolan et al. 2017, 2020b，Ma et al. 2018）。疼痛本身（非癌症相关）可促进癌症进展（Page et al. 2001），新证据显示治疗前癌痛水平与生存负相关（Nolan et al. 2020a）；某些癌症可「劫持（coapter）」感觉神经与疼痛信号机制以利其进展（Gasparini et al. 2019，Venkatesh et al. 2019）。
- 当前建议对慢性癌痛采用**多模式药物方法**并妥善管理非癌痛（手术、围手术期痛、OA 等其他慢性痛）。一般控制癌痛时 **AINS 用于吗啡类与附加药（gabapentine）的补充**；其他有据方案包括**双膦酸盐（bisphosphonates）、化疗与放疗**；应同时用非药物治疗；其他辅助治疗改善肿瘤患者 QoL（难以确证是否经镇痛）。', 'dog', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 结语、致谢与利益冲突（块 035）', '11. 结语、致谢与利益冲突（块 035）

- **REMARQUES FINALES（最终说明）**：动物感受正负情绪含疼痛。急性（适应性）痛与慢性（失适应性）痛是不同现象，可对动物健康与福利产生危害性影响，导致应激、恐惧、焦虑与挫折；社会与物理环境可影响疼痛感知。作为兽医健康专业人员，我们负医学与伦理责任尽可能减少痛苦，涉及基于行为观察、使用疼痛量表对**所有**动物充分识别与评估疼痛，并应用药物与非药物策略。镇痛方面推荐以预防性、多模式方法为良好实践。非药物治疗方面，多种策略可易于实施以减轻疼痛、改善住院急性痛患者体验、并增强慢性痛者的 QoL 与人-动物纽带。亦须认识到某些情况下**安乐死可能是终止痛苦唯一可行方案**。鉴于疼痛被视为**第四生命体征**且负面影响动物福利各方面，兽医团队须协作优化所有患者疼痛管理。
- **REMERCIEMENTS（致谢）**：WSAVA GPC 现获 **Zoetis（硕腾）** 通过 WSAVA 赞助提供财政支持；发起方未参与本指南撰写、内容与出版，亦未提供意见。作者感谢 **Stephen Niño Cital** 对 2.11 章（Cannabinoïdes 大麻素类）修订的贡献。〔2023 年 4 月 3 日在线首发后添加更正：前一句在本版中加入。〕
- **Conflit d''intérêts（利益冲突）**：所有作者均已/正在为多家制药公司提供咨询服务。', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 缩略语表（Abréviations，块 035，逐字照录）', '12. 缩略语表（Abréviations，块 035，逐字照录）', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 缩略语表（Abréviations，块 035，逐字照录） (2)', '| 缩写 | 含义（法语/英语原文） |
|---|---|
| PA | Pneumonie d''aspiration（吸入性肺炎） |
| CB | Récepteurs cannabinoïdes（大麻素受体） |
| CBD | Cannabidiol（大麻二酚） |
| CBPI | 犬简式疼痛量表（canine brief pain inventory，Canine BPI） |
| CIPN | 化疗诱发周围神经病变（Neuropathie périphérique induite par la chimiothérapie） |
| CMI | 临床计量工具（Outils de métrologie clinique / Clinical Metrology Instruments） |
| CMPSSF | Glasgow 复合疼痛量表及其短表〔原文 "CMPSSF … et sa forme courte au niveau du SNC Système Nerveux Central"，抽取稿串行，〔原文如此〕〕 |
| COX | Cyclooxygénase（环加氧酶） |
| CRI | Perfusion À Vitesse Continue（恒定速率输注） |
| CSOM | 客户特异结局测量（Mesure des résultats propres au client） |
| DJD | 退行性关节病（Maladie Articulaire Dégénérative / Degenerative Joint Disease） |
| FHS | 猫感觉过敏综合征（Syndrome d''hyperesthésie féline） |
| FLUTD | 下泌尿道疾病（Maladie des voies urinaires inférieures） |
| FMPI | 猫肌肉骨骼疼痛指数（Indice De Douleur Musculo-Squelettique Féline） |
| FOPS | 猫口面部疼痛综合征（Syndrome douloureux orofacial félin） |
| FPFF | 猫身体功能公式（La formule de la fonction physique féline） |
| GCs | Glucocorticoïdes（糖皮质激素） |
| AH | Acide hyaluronique（透明质酸） |
| HRQoL | 健康相关生活质量（Qualité de vie liée à la santé） |
| IASP | 国际疼痛研究协会 |
| PIO | Pression intraoculaire（眼内压） |
| IRIS | 国际肾病关注协会（Société Internationale D''Intérêt Rénal） |
| （iv） | Intraveineuse（静脉） |
| LOAD | 利物浦犬骨关节炎量表（Échelle d''ostéoarthrite chez le chien de l''université de Liverpool） |
| mAbs | Anticorps monoclonaux（单克隆抗体） |
| MAC | Concentration alvéolaire minimale（最低肺泡浓度） |
| MI-CAT | 蒙特利尔猫关节炎检测工具（Outil d''évaluation des chats de Montréal） |
| MiPSC | 猫肌肉骨骼疼痛筛查清单（Liste de contrôle pour le dépistage de la douleur musculo-squelettique chez le félin） |
| MSC | 间充质干细胞（Cellules Souches Mésenchymateuses） |
| NGF | 神经生长因子（Nerve growth factor） |
| NK-1 | 神经激肽-1 受体（Récepteur de neurokinine-1） |
| NMDA | N-méthyl-D-aspartate（N-甲基-D-天冬氨酸） |
| AINS | 非甾体抗炎药（Anti-inflammatoires non stéroïdiens） |
| OA | 骨关节炎（Arthrose / Osteoarthritis） |
| PRP | 富血小板血浆（Plasma riche en plaquettes） |
| QoL | 生活质量（Qualité de vie / Quality of Life） |', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 缩略语表（Abréviations，块 035，逐字照录） (3)', '| QST | 定量感觉测试（Tests Sensoriels Quantitatifs / Quantitative Sensory Testing） |
| RAP | 放疗相关疼痛（Radiation associated pain） |
| TCA | 三环类抗抑郁药（Antidépresseurs tricycliques） |
| TD | 经皮装置（Dispositifs transdermiques） |
| TENS | 经皮电刺激（Stimulation Électrique Transcutanée） |
| THC | Delta-9-tétrahydrocannabinol（Δ9-四氢大麻酚） |
| TRPV1 | 瞬时受体电位香草碱亚型 1 受体 |
| WSAVA GPC | 世界小动物兽医协会——全球疼痛委员会（Conseil mondial de la douleur） |', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('2022 WSAVA 疼痛全球指南 · 抽取质量提示（块 030–043）', '14. 抽取质量提示（块 030–043）

- 每页页脚反复出现 Wiley 下载水印与版权串（"17485827, 2023, 4, Téléchargé de https://onlinelibrary.wiley.com/doi/10.1111/jsap.13566 par Cochrane France, Wiley Online Library le [16/07/2024]…"），常夹入正文行中并切断句子，需跨页拼接。部分页脚出现英法混杂串（块 036 起 "Voir les conditions générales … sur Wiley Online Librar for rules of use; OA articles are governed…"，"Librar" 缺 y，〔原文如此〕）。
- 连字与断词普遍：如 "diﬀérentes/diﬀérem" 等 ﬀ/ﬁ 连字符；跨行断词（"ovar io hystérectomie"、"péri-lésionnelle"、"r éversal"、"multidisciplinar y"、"chim iothérapie"、"augmentati on"、"chapitres 2 .5" 等）；块 035 "Retrobulbar"、"médian" 断入表格脚注。
- Tableau 23、24、25 的三列表格在抽取中严重错行、串行（如 "†L''utilisation … de | é"、"RUMM" 出现在软组织手术方案表脚注但正文无该阻滞、"peu disponibles" 断行），个别栏（Tableau 25 第三列后半）无内容——已按可读要点归位，缺失处标注「原文此处缺失」。
- 疑似噪声词：正文 "(graphiturant)"、"(piprant)" 出现在 OA 镇痛选项处，疑为 OCR 误拾的脚注/图注残片，〔原文如此〕，未作猜测修正。
- Tableau 26 口腔冲洗条目引用「3.14 章」，而 3.14 在本稿实为癌性疼痛；该处章节号或为法语译本/抽取错位，照录并提示读者核对原文。
- 缩略语块串行（CMPSSF 行与 "au niveau du SNC / Système Nerveux Central" 混排）；照录并标注〔原文如此〕。', '', '', '', '疼痛管理,切口浸润,睾丸内阻滞,精索,环形阻滞,肾上腺素禁忌,眼科方案（3.6，块 031）,牙科方案（3.7，块 031–032）', 'informational', '2022 WSAVA 疼痛全球指南（法语译本）下半部分：局部区域阻滞、专科方案（眼科/牙科/急诊重症/内科/儿科/皮肤病/神经病理性/肌肉骨骼骨关节炎/癌性疼痛）、结语、缩略语与参考文献', 'official', 'https://wsava.org/global-guidelines/pain-guidelines/', 'approved'),
('Professional Wellness Guidel · 第 1 段', 'Professional Wellness Guidelines（兽医职业健康指南）

板块页面正文（原文）

Guidelines

Professional Wellness

Executive Summary

These Global Guidelines offer an evidence-based overview of the elements that contribute to the current challenges around health and wellbeing in the companion animal veterinary sector globally. They also highlight wellbeing resources already available for veterinary leaders, team members and students.

Guideline Tools & Resources

- **NEW**: [Professional Wellness Guidelines Infographics](https://wsava.org/wp-content/uploads/2025/05/Professional_Wellness_Guidelines-FINAL.pdf)
- Professional Wellness Guidelines:
  - [Spanish](https://wsava.org/wp-content/uploads/2025/03/WSAVA-professional-wellness-guidelines__Spanish.pdf)
  - [French](https://wsava.org/wp-content/uploads/2025/03/WSAVA-professional-wellness-guidelines_French.pdf)
  - [Chinese](https://wsava.org/wp-content/uploads/2024/12/WSAVA-professional-wellness-guidelines（Chinese）.pdf)', '', '', '', '兽医职业健康,板块页面正文（原文）,Guidelines', 'informational', 'Professional Wellness Guidelines', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Professional Wellness Guidel · Other Resources', 'Other Resources

- [Creating a Culture of Wellbeing in Your Practice in 6 Key Steps](https://wsava.org/wp-content/uploads/2024/02/PWG_Wellbeing_Tips.pdf)
- [Stress Management for Clinician’s during the COVID-19 Pandemic](https://wsava.org/wp-content/uploads/2020/04/Stress-Management-for-Clinicians-during-the-COVID-19-Pandemic_WSAVA-PWG.pdf)
- [Resources from the AVA’s THRIVE Team](https://www.ava.com.au/Thrive/)
- [Resources from the AVMA](https://www.avma.org/resources-tools/wellbeing)
- [AVA Graduate Mentoring Program](https://wsava.org/wp-content/uploads/2020/12/AVA-Graduate-Mentoring-Program.pdf)

Scientific Papers

- [The Prevalence of Compassion Fatigue among Veterinary Students in Australia, JVME](https://wsava.org/wp-content/uploads/2020/12/JVME_The-Prevalence-of-Compassion-Fatigue-among-Veterinary-Students-in-Australia.pdf)
- [Cross-sectional analysis of veterinary student coping strategies and stigma in seeking psychological help, Veterinary Record](https://wsava.org/wp-content/uploads/2020/12/Veterinary-Record_Cross-sectional-analysis-of-veterinary-student-coping-strategies-and-stigma-in-seeking-psychological-help.pdf)
- [Veterinary Surgeons and Suicide, Veterinary Record](https://wsava.org/wp-content/uploads/2020/12/Veterinary-Record_Veterinary-surgeons-and-suicide.pdf)
- [Finding the Balance – Uncovering Resilience in Veterinary Literature, JVME](https://wsava.org/wp-content/uploads/2020/12/JVME_Finding-the-Balance-uncovering-resilience-in-veterinary-literature.pdf)
- [Resilience in Veterinary Students and the Predictive Role of Mindfulness and Self-Compassion, JVME](https://wsava.org/wp-content/uploads/2020/12/JVME_Resilience-in-Veterinary-Students-and-the-Predictive-Role-of-Mindfulness-and-Self-Compassion.pdf)

We welcome feedback on the Professional Wellness or any other aspect of WSAVA’s work.

Please feel free to share your thoughts by emailing [feedback@wsava.org](mailto:feedback@wsava.org).', '', '', '', '兽医职业健康,板块页面正文（原文）,Guidelines', 'informational', 'Professional Wellness Guidelines', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Professional Wellness Guidel · Downloads', 'Downloads

Professional Wellness Guidelines

[Read in JSAP](https://doi.org/10.1111/jsap.13689)

本板块文档清单

共 12 份 PDF，按「英文 + 中文」策略收录 10 份，跳过小语种译本 2 份。', '', '', '', '兽医职业健康,板块页面正文（原文）,Guidelines', 'informational', 'Professional Wellness Guidelines', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Professional Wellness Guidel · 已收录（原文已抽取到 raw_extracts/）', '已收录（原文已抽取到 raw_extracts/）', '', '', '', '兽医职业健康,板块页面正文（原文）,Guidelines', 'informational', 'Professional Wellness Guidelines', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Professional Wellness Guidel · 已收录（原文已抽取到 raw_extracts/） (2)', '| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Professional Wellness Guidelines Infographics | EN | 2025 版（现行） | 38 | 11142 | [raw_extracts/Professional_Wellness_Guidelines-FINAL.md](raw_extracts/Professional_Wellness_Guidelines-FINAL.md) |
| WSAVA professional wellness guidelines（Chinese） | ZH | 2024 版（现行） | 42 | 73174 | [raw_extracts/WSAVA-professional-wellness-guidelines（Chinese）.md](raw_extracts/WSAVA-professional-wellness-guidelines%EF%BC%88Chinese%EF%BC%89.md) |
| Creating a Culture of Wellbeing in Your Practice in 6 Key Steps | EN | 2024 版（现行） | 1 | 2033 | [raw_extracts/PWG_Wellbeing_Tips.md](raw_extracts/PWG_Wellbeing_Tips.md) |
| Stress Management for Clinician’s during the COVID-19 Pandemic | EN |  | 2 | 3557 | [raw_extracts/Stress-Management-for-Clinicians-during-the-COVID-19-Pandemic_WSAVA-PWG.md](raw_extracts/Stress-Management-for-Clinicians-during-the-COVID-19-Pandemic_WSAVA-PWG.md) |
| AVA Graduate Mentoring Program | EN |  | 5 | 8219 | [raw_extracts/AVA-Graduate-Mentoring-Program.md](raw_extracts/AVA-Graduate-Mentoring-Program.md) |
| The Prevalence of Compassion Fatigue among Veterinary Students in Australia, JVME | EN |  | 13 | 59752 | [raw_extracts/JVME_The-Prevalence-of-Compassion-Fatigue-among-Veterinary-Students-in-Australia.md](raw_extracts/JVME_The-Prevalence-of-Compassion-Fatigue-among-Veterinary-Students-in-Australia.md) |
| Cross-sectional analysis of veterinary student coping strategies and stigma in seeking psychological help, Veterinary Record | EN |  | 7 | 36383 | [raw_extracts/Veterinary-Record_Cross-sectional-analysis-of-veterinary-student-coping-strategies-and-stigma-in-seeking-psychological-help.md](raw_extracts/Veterinary-Record_Cross-sectional-analysis-of-veterinary-student-coping-strategies-and-stigma-in-seeking-psychological-help.md) |', '', '', '', '兽医职业健康,板块页面正文（原文）,Guidelines', 'informational', 'Professional Wellness Guidelines', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Professional Wellness Guidel · 已收录（原文已抽取到 raw_extracts/） (3)', '| Veterinary Surgeons and Suicide, Veterinary Record | EN |  | 10 | 73463 | [raw_extracts/Veterinary-Record_Veterinary-surgeons-and-suicide.md](raw_extracts/Veterinary-Record_Veterinary-surgeons-and-suicide.md) |
| Finding the Balance – Uncovering Resilience in Veterinary Literature, JVME | EN |  | 11 | 49293 | [raw_extracts/JVME_Finding-the-Balance-uncovering-resilience-in-veterinary-literature.md](raw_extracts/JVME_Finding-the-Balance-uncovering-resilience-in-veterinary-literature.md) |
| Resilience in Veterinary Students and the Predictive Role of Mindfulness and Self-Compassion, JVME | EN |  | 10 | 47261 | [raw_extracts/JVME_Resilience-in-Veterinary-Students-and-the-Predictive-Role-of-Mindfulness-and-Self-Compassion.md](raw_extracts/JVME_Resilience-in-Veterinary-Students-and-the-Predictive-Role-of-Mindfulness-and-Self-Compassion.md) |', '', '', '', '兽医职业健康,板块页面正文（原文）,Guidelines', 'informational', 'Professional Wellness Guidelines', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Professional Wellness Guidel · 未收录（同一指南的其他语言译本）', '未收录（同一指南的其他语言译本）

- WSAVA-professional-wellness-guidelines__Spanish.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/03/WSAVA-professional-wellness-guidelines__Spanish.pdf>
- WSAVA-professional-wellness-guidelines_French.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/03/WSAVA-professional-wellness-guidelines_French.pdf>

外部引用（期刊论文 / 相关机构，未抓取正文）

- Resources from the AVA’s THRIVE Team — <https://www.ava.com.au/Thrive/>
- Resources from the AVMA — <https://www.avma.org/resources-tools/wellbeing>
- Read in JSAP — <https://doi.org/10.1111/jsap.13689>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '兽医职业健康,板块页面正文（原文）,Guidelines', 'informational', 'Professional Wellness Guidelines', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 范围、目标与预警信号（章节 1）', '指南由 WSAVA 职业健康小组（Professional Wellness Group, PWG）制定，中文版原刊于 *Journal of Small Animal Practice* 2024，DOI 10.1111/jsap.13689，共 6 章。正文以中文版为准，中英差异汇总于 §8。

1. 范围、目标与预警信号（章节 1）

1.1 性质与适用对象

指南**无意成为诊断工具**，用于指导改善职业健康幸福、帮助读者识别个人与团队中的问题；**识别出问题后，重要的是寻求适当的帮助**。「兽医从业人员」涵盖从事兽医实践活动、兽医研究以及/或动物健康护理的所有人员。原文「目的」段：小组成立的目的是**确定全球兽医行业面临的心理健康挑战的程度，并找出并评估最适合预防或缓解这些挑战的资源**；因各国表现与程度不同，指南侧重概述行业面临的挑战并提供建议与支持——概述可能影响兽医心理健康的因素、这些因素如何对兽医及其团队产生负面影响，以及可通过哪些方式（**包括预防与治疗**）解决这些问题；这些方法以健康为导向，旨在提升健康幸福。中文版已提交 JSAP 发表但未经全面同行评审；作者无财务或个人利益冲突。

1.2 PWG 目标

| # | 目标 |
|---|---|
| 1 | 支持全球兽医社区中个人、团队和协会成员的幸福和健康。 |
| 2 | 提高全球兽医社区对心理健康及其重要性的认知。 |
| 3 | 找到并协助实施适当的补救措施和项目，以改善全球兽医社区的心理健康。 |

1.3 章节框架

| 章 | 中文版 | 英文版 |
|---|---|---|
| 1 | 介绍 | Introduction |
| 2 | 可能影响心理健康的个人方面要素 | Aspects of a person that can influence mental health |
| 3 | 环境 – 兽医生态系统 | The environment |
| 4 | 个人和环境因素对员工健康幸福的影响 | The impact of stressors on worker wellbeing |
| 5 | 解决方案与资源 | Solutions and resources |
| 6 | 章节 6——总结 | Top tips |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('WSAVA 兽医职业健康指南 · 风险背景与预警数据', '1.4 风险背景与预警数据

| 项目 | 原文内容与数值 | 出处 |
|---|---|---|
| 拟一年内离开行业 | **20%** 的兽医；原因：高额毕业债务、低毕业起薪、过度工作压力、未满足的职业期望 | AVA 2018 Australian Veterinary Workforce Survey |
| 离职时点 | 许多兽医在**从业前三到四年**内离开 | AVA 2018；Montoya et al., 2021 |
| 人格风险 | 从业者常具理想主义与完美主义，难以应对客户对能力与费用的预期落差 | Crane et al., 2015 |
| 高自杀率的 4 项可能原因 | ①高成就导向和完美主义人格；②社交隔离与地理隔离；③执行安乐死以减轻动物痛苦的心理负担；④容易获取致命药物并了解其使用方法 | Nett et al., 2015（澳/英/挪/美） |
| 主要压力源（全球调查） | 客户互动、兽医同事关系、组织管理问题、财务问题、时间管理与工作量 | WSAVA 2018 调查 |
| 各国支持项目 | 英国 Vetlife、澳大利亚 Graduate Mentoring Program、美国兽医协会（AVMA）健康幸福项目 | 中文版「介绍」 |

2. 健康幸福与幸福健康的定义（章节 1）

2.1 定义缺失

「幸福（wellbeing）」与「健康（wellness）」无统一定义，科学和非科学文献中常无明确定义或被交替使用。Brady 等（2018）**对医师健康的系统性综述**发现缺乏对医生幸福与健康的清晰、一致定义，纳入综述的文章中 **86% 未对幸福或健康作出定义**；并指出「缺乏共同确认的定义……可能在人们根据医生健康衡量标准来判断其健康状况的时候做出错误的推断（Standish et al., 2002）」——原文强调**对兽医团队的健康幸福而言情况也是如此**。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'caution', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 健康幸福（Wellbeing）＝状态', '2.2 健康幸福（Wellbeing）＝状态

> **健康幸福是指一个人在任何特定时刻的身体和心理健康状态。**

《牛津英语词典》（OED, 2022）将「wellbeing（健康幸福）」定义为幸福、健康或繁荣的状态，**与身体、心理或道德福祉相关**；该状态涵盖身体、心理、情感与社交健康，需积极生活态度、生活意义感与目标感，并受与自我、他人、自然界、文化及精神层面关系的影响（「精神性」指通过与自我、他人、艺术、音乐、文学、自然或超越自我的力量的连接，体验和融合生命的意义和目的，HRZone, n.d.）。Seligman 的 **PERMA 模型**（2022）与其他定义不同之处在于不含身体健康：

| 要素 | 英文 | 原文释义 |
|---|---|---|
| P | Positive emotion | 积极的情绪：对自己所处世界的态度和看法 |
| E | Engagement | 参与感：与他人一起参与让自己感到快乐的活动 |
| R | Relationships | 关系：充满爱、富有成效的人际关系 |
| M | Meaning | 意义：一种目的感和/或精神信仰 |
| A | Accomplishments / Achievements | 成就：为自己对世界的贡献感到自豪 |

2.3 幸福健康（Wellness）＝过程

> **幸福健康是采取行动来维持和改善身心健康的过程。**

National Wellness Institute 认为健康幸福是「一个积极的过程，人们意识到它并做出选择，朝着更成功的生活迈进」（Holm & Severinsson, 2015），该定义基于三原则：①被视为有意识、自我引导并不断发展的过程，目的是实现个人最大潜能；②具有多个维度且全面，涵盖生活方式、心理与精神健康及环境因素；③是积极的，并具有认可影响。（注：中文版在这一 wellness 段落中亦以「健康幸福」表述，属术语混用。）它也指维持身体、心理与精神健康的活动整合——为身体提供能量、激发思维、滋养灵魂（University of Maryland, UMD, 2022），例如吃健康的食物、获得足够的睡眠、定期锻炼身体、进行瑜伽/冥想或其他沉思活动、维持健康的工作-生活平衡状态。八个维度（UMD, 2022）：**身体、智力、情感、社交、精神、职业、财务、环境**，相互依赖、无需完全平衡但每维需关注，长期忽视任一维度会降低整体健康幸福与生活质量；此外健康幸福还与充实的生活息息相关，要求个性化生活方式、充分发挥个人潜力并善用可利用的环境与命运（Ardell, 1986），并可在各维度中找到通过最真实感受获得的平衡——「个人和谐」（UMD, 2022）。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 章节 1 自评清单', '2.4 章节 1 自评清单

| # | 原文问题 |
|---|---|
| 1 | 您熟悉 WSAVA 职业健康小组（PWG）及其工作吗？ |
| 2 | 健康与幸福感之间的主要区别是什么？它们如何影响你的心理健康？ |
| 3 | 您如何看待改善工作团队和职业群体的健康的挑战？ |
| 4 | 您能更有效地确认、利用资源来保护和改善您自己以及你们兽医团队的健康幸福吗？ |

3. 影响心理健康的个人因素（章节 2）

3.1 人在环境中与心理健康连续带

依「环境中的个人」（person-in-environment）视角（Kondrat, 2008），理解个体须重点考虑其生活和行动的环境；健康受固有因素（基因或家族遗传）与从受孕起的全部生活经历影响。心理健康是可双向移动的持续变化光谱（Bailey, 2015；MHCC, 2018）。颜色与中文描述出自中文版，英文标签出自英文版（中文版图 2 为图片，图内文字**原文此处缺失**）：

| 档 | 颜色 | 英文（英文版） | 中文描述 |
|---|---|---|---|
| 1 | 绿色 | HEALTHY – Normal Functioning | 健康的、适应性应对 |
| 2 | 黄色 | REACTING – Common & Reversible Distress | 轻微且可逆的困扰或功能障碍 |
| 3 | 橙色 | INJURED – Significant Functional Impairment | 更严重、持久的伤害或障碍 |
| 4 | 红色 | ILL – Clinical disorder; severe and persistent functional impairment | 临床疾病和障碍，需要更多集中医疗护理 |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 全球事实与障碍分类（中文版表 1）', '3.2 全球事实与障碍分类（中文版表 1）

约 **10 亿**人受心理健康问题影响，处于「受伤」或「疾病」阶段（The Lancet, 2020）；**每 5 年就有 1 人因此致残**，**每年约 80 万人因自杀而死亡**（WHO, 2019）；所有年龄、教育、收入与文化背景的人都受影响，无人完全免疫（CMHA, 2021）；**约一半**患者存在共病（Kessler et al., 2005）。

| 类别 | 精神障碍示例（APA, 2013；Kessler et al., 2005） |
|---|---|
| 焦虑障碍 | 广泛性焦虑障碍（GAD）、特定恐惧症、创伤后应激障碍（PTSD）、惊恐障碍、广场恐惧症、社交恐惧症、强迫症和分离焦虑障碍 |
| 抑郁障碍 | 重度抑郁障碍（MDD）、双相 I–II 型障碍和心境恶劣障碍 |
| 物质滥用障碍 | 酒精滥用、酒精依赖、药物滥用和药物依赖 |

障碍由四类因素结合并相互作用引起（图 3 为图片，**原文此处缺失**），源自 George Engel **1977 年**提出的**生物-心理-社会模型（biopsychosocial model）**，已成为精神病学主流理念与近 40 年全球实践标准（Papadimitriou, 2017）。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'caution', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 四类因素与数值', '3.3 四类因素与数值

| 因素 | 原文要点与数值 |
|---|---|
| 遗传 | 无单一遗传成因；特定基因/变异已与重度抑郁症、双相情感障碍、注意缺陷多动障碍（ADHD）、精神分裂症关联。抑郁症遗传性 **40%–50%**，一级亲属患病者风险为平均 **2–3 倍**（Levinson & Nichols, 2022）；ADHD 者患抑郁风险为常人 **3–6 倍**，也更易患焦虑症与物质滥用障碍（Riglin et al., 2021） |
| 生物 | 患糖尿病、心脏病、癌症、关节炎、哮喘者焦虑与抑郁频率为普通人群**两倍**（CMHA, 2022b）。种族、性取向、能力等差异可使人被归为少数群体，在住房、就业、医疗和教育中遭遇直接或结构性歧视，构成独特慢性压力源；性少数群体焦虑症、抑郁症、饮食失调、物质滥用、自残与自杀发生率较高（Herek & Garnets, 2007） |
| 心理 | 部分遗传率：大五人格（责任心、合作性、神经质、开放性、外向性）**40%–55%**；感官敏感特质（sensory processing sensitivity）**47%**；完美主义 **25%–40%**；乐观主义 **25%**；自尊约 **50%**。其中**神经质**（愤怒、焦虑、自卑、易怒、情绪不稳定、抑郁）与精神障碍相关性最强（Kotov et al., 2010）。约 **20%** 人口高敏感，与更高压力、焦虑、抑郁、身心疾病及较高工作不满与康复需求相关。完美主义＝过高个人标准＋苛刻自我评价，引发失败感、内疚、优柔寡断、拖延、羞耻感与低自尊，并与焦虑障碍、抑郁症、双相障碍、强迫症、人格障碍、饮食障碍、身体变形障碍、物质滥用、自残甚至自杀关联；悲观主义与低自尊亦关联焦虑障碍、抑郁症、物质滥用、饮食障碍、高风险行为和自杀 |
| 环境 | 不良童年经历（Adverse Childhood Experiences, ACEs）影响持久：受虐待、忽视与家庭功能障碍者的焦虑障碍、抑郁症、物质滥用和自杀倾向终生风险与发生率较高。压力源含具体事件（关系破裂、车祸）、长期困境（长期疾病、持续婚姻问题、政治纷争、战争）与日常烦恼（做家务、按时完成任务）；社交媒体、气候变化与疫情亦各带来压力。**任何无法管理的压力都可能负面影响心理健康** |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 章节 2 自评清单', '3.4 章节 2 自评清单

| # | 原文问题 |
|---|---|
| 1 | 您会将自己放置在心理健康持续变化带的哪个位置？ |
| 2 | 您认为身上的哪些个人因素（天生或遗传）和环境因素（生活经历或外界接触）会影响您的心理健康？ |
| 3 | 您是否意识到自己个性中的优点（比如乐观），或者脆弱点（比如神经质或完美主义）？ |
| 4 | 您认为您的哪些人生经历（无论是过去还是现在）可能对您的心理健康产生负面影响？您能做些什么来应对这些问题呢？ |

4. 环境与兽医生态系统：风险因素与压力源（章节 3）

4.1 环境界定与压力定义

「环境」广义解释为所有兽医工作场所及其物理环境（地理位置、地点）与其提供的社会环境（Baum et al., 2015），共同构成「生态系统」。**压力（stress）**由 Hans Selye 于 **1936 年**提出，指人体对任何变化要求的非特异性反应；影响肌肉骨骼、呼吸、心血管、内分泌、消化、神经与生殖系统，转为慢性时产生严重影响（APA, 2022a, 2022b）。**几乎或完全没有控制感时最易引发痛苦**（Bewley, 2023）；反应组合称「战斗或逃跑（fight or flight）」，源自生存机制，却常对非致命压力源（交通堵塞、工作压力、家庭困难）过度反应（Harvard Health, 2020）。Selye 另提出**良性压力／积极压力（eustress）**促使我们做得更多；急性压力提高能量、改善记忆、激励应对挑战，慢性压力由反复遭遇引发压力激素释放造成（White, 2022）。因人们普遍视压力为威胁，Selye 后来创造「**压力源（stressor）**」以区分刺激与反应。

压力源类型（Keely, 2021）——短期：**急性压力源**（在诊所处理紧急病例）、**触发压力源**（提醒过去压力并重新引发反应）、**未知压力源**（因缺乏信息而压力）；长期：**日常烦恼**（每天出现，单一不严重，积少成多则不良后果）、**慢性压力源**（高风险工作、受虐待的关系，个体须时刻警觉）、**涟漪效应压力源**（作息变化或人生事件引发，如毕业、找新工作、被解雇）。急性反应在健康个体可能具适应性；威胁持续（尤其年长或健康状况不佳者）可损害健康（Schneiderman et al., 2005）。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'caution', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 工作场所因素（据 BVA, 2020 等）', '4.2 工作场所因素（据 BVA, 2020 等）

| 因素 | 原文要点 |
|---|---|
| 工作自主权 | 一定程度的自主权积极影响健康幸福（Wheatley, 2017） |
| 角色与责任明确 | 不明确会拖慢团队合作、破坏工作满意度（VetFutures, 2018） |
| 做重要之事 | 感到正在完成有重大影响力的任务（Wallace, 2019） |
| 反馈与绩效评估 | 积极反馈、明确的条款和条件、定期绩效评估（Juncu, 2017） |
| 情感与身体安全 | 保障个人安全并支持心理安全；2019 年 RCVS 调查中处理紧急情况时有安全担忧者平均健康幸福分更低（Robinson et al., 2019） |
| 公平、平等和包容 | 对一切形式歧视零容忍并明确传达给员工与客户 |
| 积极关系（管理者、同事、客户） | 导师-学员关系使双方获益（Niehoff et al., 2005）；2021 AVA 调查：兽医因客户互动困难与同理心疲劳而挣扎，若认为上级或雇主支持不足会加剧 |
| 职业发展机会 | 2015 年 Vet Futures 调查中 **59%** 达到或超出预期、**41%** 失望，主因是发展机会不足 |
| 工作量与灵活性 | 公平工时，认可并奖励超出合同时间的工作，可能时支持灵活请求 |
| 公平薪酬与平等机会 | 与职位匹配的公平薪酬与福利；离开临床者满意度更高、对未来更乐观 |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'caution', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 社会因素与职业积极面', '4.3 社会因素与职业积极面

| 社会因素 | 原文要点 |
|---|---|
| 公共安全与政治稳定 | 感到身体安全影响幸福、健康与生产力；政治稳定同样积极影响健康幸福 |
| 身体、社交和职业支持 | 社交关系可能比任何其他因素更能影响幸福感（Larkin, 2013） |
| 对兽医角色的认知 | 兽医促进人兽关系、支持农民、保护环境、保障公共卫生与食品安全、开展研究与公众教育，符合「一体化健康（One Health）」——「一个全球性战略，旨在促进在人类、动物和环境健康领域的跨学科合作与沟通」（One Health Initiative, 2023） |

职业积极面：中文版作实现潜力、帮助他人、归属感、从事有意义的工作（Wallace, 2019）及专业技能、积极的工作成果与工作特征、良好的人际关系、获得的认可（Clise et al., 2021）；**英文版列 6 项**：Working with animals、Helping animals & people、Realizing one''s potential、Meaningful work、A sense of belonging、Mentally stimulating work。2019 年英国调查中，受访者称最大好处为与动物一起工作、工作满意度、面临挑战/刺激，并希望更好的工作-生活平衡、更高经济回报、更少工作压力。

4.4 原文出现的量表与测评分值

| 量表/调查 | 原文数值 | 出处 |
|---|---|---|
| WEMWBS（Warwick-Edinburgh Mental Well-Being Scale） | 2019 年 RCVS 调查平均 **47.7**，低于 2014 与 2010 年（当时 **49**） | Robinson et al., 2019 |
| 2014 年 RCVS 调查 | 近 **90%** 认为工作有压力；类似比例认为工作富有多样性；超 **80%** 对工作满意 | RCVS, 2014；VetFuture Press Office, 2017 |
| Kessler 6（Kessler et al., 2003） | WSAVA 2018 调查（稿件正在准备中）中男、女兽医得分差异显著，男性兽医的健康幸福分高于女性；年轻、经验较少者健康幸福低于年长成员 | WSAVA, n.d. |
| ProQOL（职业人士生活质量评估） | 表 2「评估您的健康幸福」自评工具；英文版注明自我施测 | AVMA（美国） |
| 「Vets in Mind」压力评估工具 | PWG 组织层面建议的入门工具 | 中文版章节 6 |

原文仅给量表名与总分，**条目数、计分方式与分档区间原文此处缺失**。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 兽医常见工作场所压力源（原文注明排名不分先后）', '4.5 兽医常见工作场所压力源（原文注明排名不分先后）

| 压力源 | 原文要点与数值 |
|---|---|
| 工作量与加班 | 工作时间安排影响「正常的家庭和社交生活」；2020 年 Merck 研究指工作/生活平衡是工作满意度关键驱动因素，**持续每周工作超过 46 小时可能导致高水平的职业倦怠**（Salois, 2021） |
| 资金担忧 | 既是工作场所压力源（AVA, 2018），也是考虑离开行业的主因之一（Olson, 2022） |
| 照护；伦理挑战/安乐死 | 安乐死、临终关怀、经济限制与护理不足造成实际与道德困境；2018 年美国研究：**77%** 的兽医因伦理困境遭受中度到严重压力，**70%** 几乎没有或根本没有接受过解决这些问题的培训（Moses, 2018） |
| 工作场所冲突——有害文化 | 有害文化负面影响健康幸福；不文明行为亦影响患者护理 |
| 客户困难与期望管理 | 原文 6 项：没有能力或不愿付费；盛气凌人与带攻击性；不现实期望；护理缺乏配合；通过社交媒体施压和勒索、要求免费服务；偏见与不平等 |
| 不平等——性别偏见 | 女性从业人数渐超男性但仍受歧视、高层比例较少（Knights, 2019）；2018 年 BVA 歧视报告：其他条件相同时性别仍显著影响认知、待遇与薪酬，年轻与女性兽医更可能亲历歧视 |
| 安全与接触 | 可能暴露于**生物、化学、物理和心理危害**（CDC, 2022）；能力与职业安全健康关注差异形成安全或有害文化 |
| 社交媒体影响 | 网络霸凌（cyberbullying）与公开羞辱常见；AVMA 2014 调查：最常见影响为工作场所紧张与心理健康问题，**几乎一半**受害者曾考虑转行；AVMA 与 Banfield Pet Hospital 2022 年调查：**90%** 受访者过去一年曾与客户有负面互动、**65%** 每周遭遇（Teller, 2023） |

4.6 章节 3 自评清单

| # | 原文问题 |
|---|---|
| 1 | 您是否拥有公平透明的招聘和绩效评估流程？ |
| 2 | 您是否有能够识别、报告歧视事件的系统？ |
| 3 | 您如何确保工作量是可完成的？确保工作/生活平衡？ |
| 4 | 您有汇报程序来收集与同事或客户发生产生的负面交互吗？ |
| 5 | 您的员工是否接受过培训，培训他们提供积极和/或建设性反馈？ |
| 6 | 您是否有同事支持/辅导项目？ |
| 7 | 您是否可以加入一些活动来促进职业发展？ |
| 8 | 您如何激励您的员工？ |
| 9 | 您如何确保在诊所中营造包容性文化？ |
| 10 | 您的员工是否接受过客户沟通培训？ |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 压力源的影响：心理健康、倦怠与自杀风险（章节 4）', '5. 压力源的影响：心理健康、倦怠与自杀风险（章节 4）

工作特征（实现潜力、帮助他人、有意义的工作）有积极影响；工作负担、经济问题、长时间工作、具有挑战性的互动、意外的结果、安乐死、与丧失宠物的客户打交道、对投诉或错误的恐惧则带来压力。已发表文章中关注负面要素者约为关注益处者的**两倍**；词频上问题导向术语与韧性/健康幸福术语之比约 **2:1**（Cake et al., 2017）。「战斗或逃跑」同样在心理层面显现：短期可提升警觉性与专注力，也可能引发焦虑、无助、愤怒与恐惧，导致日常事务处理困难、过度反应、感到失控或不堪重负。

5.1 生理影响

| 系统 | 原文描述 |
|---|---|
| 肌肉骨骼系统 | 接收压力信号后肌肉紧张 |
| 心血管系统 | 心率加快，经大血管泵送更多血液从而提高血压 |
| 神经系统 | 杏仁体提醒下丘脑（压力反应的「指挥中心」），触发对威胁的反应 |
| 内分泌系统 | 下丘脑触发分泌压力激素，提供能量并促使消化系统在肝脏产生葡萄糖 |
| 胃肠系统 | 摄入更多或不同种类的食物，可能引起腹泻或便秘；**英文版此下增列「Gastritis, gastric ulcers」（胃炎、胃溃疡），中文版无** |

慢性压力可致高血压、促进动脉堵塞性沉积物形成并引起大脑变化，可能导致焦虑、抑郁和成瘾；亦可通过直接机制（进食更多）与间接机制（减少睡眠和锻炼）促成肥胖（Harvard Health, 2020）。

5.2 心理影响的数据

| 结论 | 原文数值/群体 | 出处 |
|---|---|---|
| 过去一年感受到抑郁、共情疲劳、倦怠和焦虑情绪 | **三分之二**参与者 | Volk et al., 2018 |
| 心理困扰最严重、幸福感指数评分较低 | **45 岁以下**兽医 | Volk et al., 2018 |
| 更可能遭受严重心理困扰 | 女性 | Merck, 2020 |
| 严重心理困扰的预测因素 | 神经质人格、高负债 | Merck, 2020 |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 常见心理健康问题', '5.3 常见心理健康问题

| 问题 | 原文定义要点 | 原文数值 |
|---|---|---|
| 抑郁症（Depression） | 不同于日常情绪波动与短暂反应；反复发生且中等或严重时成严重健康问题，致极大痛苦、工作与个人生活表现不佳，最严重可致自杀 | 全球约 **5%** 成年人患抑郁症（WHO, 2023）；阿拉巴马州持牌兽医 **66%** 曾经历「临床抑郁」，其中 **32%** 未寻求帮助（Skipper & Williams, 2012） |
| 焦虑症（Anxiety） | 紧张感、担忧思维与身体变化（如血压升高）；反复侵入性思维或担忧、回避情境，可出汗、颤抖、头晕、心跳加速 | 2021 年美国研究：倦怠程度高（情绪高度疲惫、缺乏个人成就感），生活质量心理部分低于美国普通人群、身体部分与常人一致（Chigerwe et al., 2021） |
| 物质滥用（Substance abuse） | 有害或危险地使用精神活性物质（含酒精与非法毒品）；风险因素含工作压力、接触受控物质、长时间工作、持续接触危重病患 | 2015 年科罗拉多州立大学 Jon Geller 在线调查：**72%** 曾与疑似有毒品问题的同事共事，超 **40%** 知道两人及以上，**68%** 认为行业问题与普通人群相当或更严重（Geller, 2016） |
| 职业倦怠（Burnout） | WHO：长期工作相关压力引起的综合症，表现为「精力枯竭或疲劳的感觉；与工作产生的心理距离增加，或有对工作的消极或愤世嫉俗的情绪；且职业工作效率降低」；Mayo Clinic：「身体、情感和心理的耗竭状态，伴对个人能力和工作价值的怀疑」；驱动因素为负担过重、要求与技能不平衡、缺乏自主权、长期压力 | **86.7%** 美国兽医倦怠分处于中等或较高水平（Ouedraogo et al., 2021）；倦怠与整体压力水平随时间上升（Merck, 2020）；较高者为近年毕业生、高教育债务者、小动物诊所兽医、女性兽医；私人诊所执业兽医比诊所老板、临时兽医与公共部门兽医更易倦怠 |
| 共情疲劳／同情疲劳（Compassion fatigue） | 长期照顾生病或受创伤者经历的身体与心理疲惫及情感退缩；与倦怠不同，源于承担患者痛苦的情感负担，在高风险职业中视为职业危害；被认为是继发性创伤压力和职业倦怠的表现；有学者认为更准确的描述是「共情痛苦（empathic distress）」（Klimecki & Singer, 2012） | 2015 年南澳大利亚研究：女性与年轻兽医更易轻度至重度心理困扰，**近一半**参与者共情疲劳达高到非常高水平；相当一部分认为与丧宠悲伤客户打交道影响自身心理健康（Dow et al., 2019） |
| 冒名顶替综合症（Impostor syndrome） | 怀疑自身技能、才能或成就，持续害怕被揭露为骗子；有外部证据仍不相信自己配得上成功 | **68%** 参与者达到或超过临床临界值；居住新西兰或英国、女性、从业不到 **5 年**者得分更可能较高（Kogan et al., 2020） |
| 道德伦理困扰（Moral distress） | 参与或未能阻止与自身价值观和信仰冲突的决策与行为所致的困扰；做出道德决定却无法付诸实践（受内外限制）时出现；在兽医实践中常见 | 英国研究 **57%** 每周面临一到两次道德困境、**34%** 通常每周三到五次（Batchelor & McKeegan, 2012）；美国研究指出多数兽医没有或几乎没有接受过减少其影响的培训（Moses et al., 2018） |
| 工作与生活融合（Work/life integration） | 将工作到个人生活各方面交织与同步；相较「平衡」更现实，促进工作、家庭/亲情、社区、个人幸福与健康各领域协同 | 原文未给数值（原文此处缺失） |
| 交叉性／交叠性（Intersectionality） | 种族、性别及其他社会身份交汇造成独特压迫（「压迫矩阵」、「多重边缘化」）；中文版另述其为多种复杂、累积性问题堆积，种族主义、性别歧视、阶级歧视相互结合、重叠或互相影响，特别影响边缘化的个人或群体（Merriam-Webster, 2023a）；四种做法：参与社区、质疑社会结构、建立联盟、教授社会正义（Rosenthal, 2016） | 原文未给数值（原文此处缺失） |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'caution', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 自杀风险与求助路径', '5.4 自杀风险与求助路径

| 指标 | 兽医/医生 | 对照人群 | 出处 |
|---|---|---|---|
| 当前正经历严重心理困扰（2014 年美国 **11,627** 名兽医） | **9%** | — | Tomasi et al., 2019 |
| 曾经历抑郁发作 | **31%** | — | Tomasi et al., 2019 |
| 自兽医学校毕业后曾有过自杀意念 | **17%** | 美国成年人年发生率 **4%** | Tomasi et al., 2019；Piscopo et al., 2016 |
| 过去一年曾有自杀念头（疫情前） | 每 **15** 名美国医生中 **1** 人 | 高于其他行业美国劳动者 | Shanafelt et al., 2021 |
| 存在自杀意念（2020 年德国） | **19.2%** | **5.7%** | Schwerdtfeger et al., 2020 |
| 自杀风险增加 | **32.11%** | **6.62%** | Schwerdtfeger et al., 2020 |
| 抑郁筛查阳性 | **27.78%** | **3.99%** | Schwerdtfeger et al., 2020 |

自杀意念（suicidal ideation）为描述对死亡和自杀的一系列思考、愿望与执念的广义术语（Harmer et al., 2023）。**关键预测因素是严重心理困扰**，与神经质、高债务、工作时间长相关（Merck, 2020）；**中毒是最常见的兽医死亡机制**（Witte et al., 2019），与「易获取致命药物可能与自杀高发关联」的假设一致。求助路径三层：①识别问题后寻求适当帮助；②「如果您感觉自己未得到提升，则寻求专业帮助」；③表 2 的匿名热线与自助资源。原文**未提供热线电话号码、服务时段或危机处置流程（原文此处缺失）**，仅给链接。

5.5 章节 4 自评清单

| # | 原文问题 |
|---|---|
| 1 | 您的员工是否接受过培训，以辨别出压力源（例如，职业倦怠、焦虑障碍）的影响？ |
| 2 | 您是否可以加入一些活动，以提升辨别、监测工作场所压力源的能力？ |
| 3 | 您是否正式或非正式地寻求其他外部组织的建议，帮助辨别、监测和管理压力源？ |

6. 解决方案、团队与管理层措施、资源（章节 5）', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'caution', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 院校层面', '6.1 院校层面

| 机构/项目 | 原文内容 |
|---|---|
| Murdoch University（澳大利亚） | 《兽医职业生活》（Veterinary Professional Life, VPL）入本科课程，培养自我意识、心理学知识与沟通技能（Mills et al., 2006） |
| Veterinary Leadership Experience | VPL 部分源自并与之合作；自 **2002 年**起列入 Washington State University 课程计划 |
| North Carolina State University | 全面的健康幸福课程计划（Royal et al., 2017） |
| University of Florida | 健康和幸福页面，提供正念与压力管理资源链接 |
| James Cook University（澳大利亚） | 视倦怠与离职率为重大问题，开发课程传授知识与实用策略、鼓励培养韧性个性（Taylor, 2022） |

6.2 职业人士的支援与培训（导师与转介）

新毕业生风险高于资深同事，并面临缺乏经验、职业与社交孤立、报酬低廉等负担（AVA, 2021）。AVA **毕业生辅导计划（Graduate Mentoring Program）**为毕业生指派受过训练的资深兽医导师，提供健康幸福、职业与个人发展支持并在困境时作为「倾诉对象」；导师的一项关键技能是**识别学员遇到导师无法处理的问题并转介**给具相关技能的个人或组织。美国另有半商业化 MentorVet。原文列已有项目的五类协助：支持团队过上满意富足健康的生活；自我评估健康幸福；为寻求帮助者提供自我照护与资源；健康幸福策略与韧性培训；应对共情疲劳与冲突解决。

6.3 管理层与工作场所改善

重视健康幸福的工作场所可为企业带来生产力效益（Fahrenkopf et al., 2008；Oxtoby et al., 2015）。AVA **Employer of Choice** 为诊所提供认证，证明符合人员管理标准（有效招聘、良好员工参与与留存策略），既表达对团队成员健康幸福的重视，也让遵循标准的企业获得公众认可；同类项目含英国兽医协会（BVA）2022、加拿大工作场所心理健康与安全国家标准。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 支持与干预项目', '6.4 支持与干预项目

AVMA 以播客推广健康幸福策略；AVA 推出 **「Thrive」** 为会员提供资源；CVMA 与私人服务商（Vetport International Programs、Improve Vet Practice、Critical Care Vet、Essential Wellness Yoga、The Wellness Journal for Veterinary Team Members）主要在线提供资源。原文指出这些项目**绝大多数基于或面向更富裕、以英语为主要用语的地区（北美、英国、澳大利亚）**；WSAVA 旨在全球分享项目、工具与经验（表 2）。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组）', '6.5 表 2 资源总表（中文版，共 37 行，三档分组）

脚注符号照抄原文：`*` 免费提供；`†` 信息免费但仅成员可参与；`‡` 信息与部分支持开放、完全参与付费；`§` Thrive 开发中，未来模块可能仅对成员开放；`¶` 课程信息免费，仅成员或付费参与者可参与；`∥` 仅成员可得；`**` 信息免费但仅限制成员参与；`††` VETPORT 提供免费试用、完全参与付费；`‡‡` 基于订阅的服务；`§§` 基于订阅的期刊；`¶¶` 提供免费课程但属付费服务。原文另有「资源」列（多为「线上」），此处并入链接列。

**（一）兽医学生**

| 主题 | 标题 | 资源类型 | 链接/出处 | 国家 |
|---|---|---|---|---|
| 学生沟通技巧 | 澳大利亚兽医学院（含 Murdoch University）的兽医沟通技能发展 | 科学论文 | https://jvme.utpjournals.press/doi/pdf/10.3138/jvme.33.1.93 `*`（Journal of Veterinary Medical Education） | 加拿大 |
| 学生健康幸福 | 兽医学教育的综合健康幸福项目（North Carolina State University） | 科学论文 | 第 6 卷第 1 号 `*`（International Journal of Higher Education） | 美国 |
| 学生健康与幸福 | University of Florida College of Veterinary Medicine Health and Wellness | 项目说明 | https://education.vetmed.ufl.edu/dvm-curriculum/student-wellness/ `*` | 美国 |
| 毕业指导 | 毕业指导项目 Australian Veterinary Association | 项目 | https://www.ava.com.au/about-us/programs-awards/graduate-mentoring-program/ `†` | 澳大利亚 |

**（二）兽医职业人士**', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (2)', '| 主题 | 标题 | 资源类型 | 链接/出处 | 国家 |
|---|---|---|---|---|
| 韧性，就业能力 | VetSet2Go：提升就业能力、韧性与毕业生成功的评估框架 | 项目报告 | https://ltr.edu.au/resources/ID15-4930_Cake_FinalReport_2019.pdf `*` | 澳大利亚 |
| 自我意识，领导力 | 兽医领导力体验 | 项目说明 | https://veterinaryleadershipinstitute.org/programs/vle/ `*` | 美国 |
| 指导 | MentorVet | 项目 | https://www.mentorvet.net/ `‡` | 美国 |
| 健康幸福成长 | Thrive | 项目 | https://www.ava.com.au/thrive/ `§` | 澳大利亚 |
| 健康幸福评估 | 评估您的健康幸福：职业人士生活质量（ProQOL）评估 | — | https://www.avma.org/resources-tools/wellbeing/assess-your-wellbeing `*` | 美国 |
| 健康幸福研究 | Merck 动物健康兽医健康幸福研究执行摘要 | 特殊报告 | 特殊报告 252 (10) `*`（Journal of the American Veterinary Medical Association） | 美国 |
| 健康幸福调查 | 还未有标题 | 科学论文 | 在新闻中（Journal of Small Animal Practice） | 美国 |
| 心理健康 | 能帮助您及周围人的资源（信息表、文章、组织、调查） | 其他资源 | https://www.ava.com.au/member-services/vethealth/mental-health-information-sheets/ `*` | 澳大利亚 |
| 心理健康急救 | 心理健康急救课程 | 课程 | https://www.ava.com.au/member-services/vethealth/mental-health-first-aid/ `¶` | 澳大利亚 |
| 健康幸福资源 | 健康幸福：文章、评估工具、活动、培训及 CE 机遇、提示与工具 | — | https://www.avma.org/resources-tools/wellbeing `*` | 美国 |
| 帮助热线 | Vetlife | 匿名电话及电子邮件支持 | https://helpline.vetlife.org.uk `*` | 英国 |
| 自我照养 | 兽医心理健康：兽医自我照养指南 | 网站信息 | https://www.vetxinternational.com/veterinary-mental-health-a-self-care-guide-for-vets/ `*` | 英国 |
| 帮助热线 | Vétos-Entraide（法语） | 匿名电话以及电子邮件支持 | https://vetos-entraide.com/ `*` | 法国 |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (3)', '**（三）兽医诊所**', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (4)', '| 主题 | 标题 | 资源类型 | 链接/出处 | 国家 |
|---|---|---|---|---|
| 团队健康幸福 | 增强您的兽医团队的工具 | 文章 | https://www.avma.org/resources-tools/wellbeing/tools-strengthen-your-veterinary-team `*` | 美国 |
| 心理健康培训 | 心智健康计划：培训项目和研讨会 | — | https://www.vetmindmatters.org/training/ `*` | 英国 |
| 共情倦怠 | 心理健康与幸福平台：工作与共情倦怠 | 文章 | https://www.avma.org/resources-tools/wellbeing/work-and-compassion-fatigue `*` | 美国 |
| 共情倦怠 | MMI Kite App | 应用程序 | https://www.vetmindmatters.org/new-wellbing-programme-for-the-veterinary-profession-takes-flight-as-mmi-kite-app-officially-launches/ `*` | 美国／英国 |
| 冲突解决方案 | 引导兽医团队解决冲突 | 博客帖子 | https://imatrix.com/blog/guiding-the-veterinary-team-through-conflict-resolution/ `*` | 美国 |
| 生产力影响 | 我们需要谈论错误：兽医实践中的错误原因和类型 | 科学论文 | 177, 438 至 444 `*`（Veterinary Record） | 英国 |
| 生产力影响 | 抑郁和倦怠住院医生中的用药错误发生率：前瞻性人群研究 | 科学论文 | 336, 488 `*`（British Medical Journal） | 英国 |
| 健康的工作场所 | 打造健康的工作场所 | 提示单 | https://www.ava.com.au/siteassets/resources/vethealth/fact-sheets/creating-healthy-workplaces-cvi1300.pdf | 澳大利亚 |
| 健康的工作场所资源 | 创建情绪健康工作场所与员工健康幸福项目的实用理念（Overfield R.） | 会议论文集 | https://www.ava.com.au/library-resources/library/conference-proceedings/2015/…（原 PDF 链接即被截断）`∥` | 澳大利亚 |
| 健康的工作场所 | Employer of choice programme — AVA Accreditation programme | 认证项目 | https://www.ava.com.au/education-events/employer-of-choice/ `**` | 澳大利亚 |
| 健康的工作场所 | 良好的兽医工作环境 | 网站与网络研讨会 | https://www.bva.co.uk/take-action/our-policies/good-veterinary-workplaces/ `*` | 英国 |
| 健康的工作场所 | 营造工作场所健康幸福项目 | 文章 | https://www.avma.org/resources-tools/wellbeing/setting-workplace-wellbeing-program `*` | 美国 |
| 健康的工作场所 | 加拿大工作场所心理健康与安全国家标准 | 项目 | https://mentalhealthcommission.ca/national-standard/ `*` | 加拿大 |
| 健康的工作场所 | 兽医实践中的健康幸福计划 | 文章 | https://www.vetport.com/veterinary-wellness-plans `††` | 美国 |
| 健康的工作场所 | 兽医诊所中的心理健康与福幸福——涵盖兽医接待员！ | 文章 | https://www.veterinary-practice.com/article/mental-health-and-well-being-in-veterinary-practice-including-veterinary-receptionists `*` | 英国 |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 表 2 资源总表（中文版，共 37 行，三档分组） (5)', '| 健康幸福 | Marie Holowaychuk 博士，危重病护理兽医 | 博客研讨会 | https://marieholowaychuk.com/ `‡‡` | 加拿大 |
| 心理健康支持 | 兽医团队成员健康幸福日志：52 周日常日志工作簿 | — | https://www.vetsupportstore.com/product/the-wellness-journal-for-veterinary-team-members/ `§§` | 美国 |
| 健康幸福 | 为兽医职业人士提供瑜伽支持 | 瑜伽 | https://www.essentialwellnessyoga.com.au/veterinary-professionals `¶¶` | 澳大利亚 |
| 兽医行业的流失 | 澳大利亚兽医协会兽医劳动力调查 2021 分析报告 | 报告 | https://www.ava.com.au/siteassets/news/ava-workforce-survey-analysis-2021-final.pdf `*` | 澳大利亚 |
| 兽医诊所的流失与风险因素 | 与兽医从临床实践中流失相关的风险因素：一项描述性研究 | 科学论文 | 99 (11), 495 至 501 `*`（Australian Veterinary Journal） | 澳大利亚 |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 求助路径与热线速查', '6.6 求助路径与热线速查

危机/求助直接相关项：**Vetlife**（英国，匿名电话及电子邮件支持）；**Vétos-Entraide**（法国，法语匿名电话与电子邮件支持）；AVA 心理健康急救课程与资源信息表；AVMA 健康幸福资源与 ProQOL 自评；VetX 自我照养指南；Mind Matters 培训与 MMI Kite App。英文版 Resources 页仅列 4 项，其中新增 **Not One More Vet（NOMV，https://nomv.org/）**——兽医心理健康的主要倡导者，含自杀预防热线、本地支持网络与社区、NOMV Ambassador Program、Student Support & Mentorship Committee 及匿名同伴支持系统 Lifeboat；**中文版表 2 无此条目**。

6.7 章节 5 自评清单

| # | 原文问题 |
|---|---|
| 1 | 兽医学课程是否包括个人健康幸福策略意识的培养？ |
| 2 | 学生是否意识到自己的核心个人优势及其对未来健康幸福以及就业能力的影响？ |
| 3 | 兽医企业、专业机构或监管机构是否提供或鼓励有关健康幸福策略的培训或支持？ |
| 4 | 早期的兽医毕业生是否知道导师的价值？是否知道导师可以帮助他们在职业初期发展？ |
| 5 | 是否提供培训，以确保导师理解这一角色及其对初毕业学生的价值？ |
| 6 | 兽医团队是否意识到有大量的项目可以改善兽医团队的健康幸福以及工作成果？ |
| 7 | 兽医和团队是否能够在个人遇到健康幸福挑战或危机时，获取支持资源？ |
| 8 | 兽医企业和监管机构是否鼓励在团队成员遇到挑战或危机时，使用资源提供支持？ |

7. 行动建议：PWG 顶级建议（章节 6）

7.1 幸福健康

| # | 原文建议（英文版标签） |
|---|---|
| 1 | 调查研究自我意识资源，熟悉您自己的核心优势。（Self-awareness） |
| 2 | 培养与信任的朋友和家人的关系，和他们谈论那些具有挑战性的问题。（Relationships） |
| 3 | 享受您的工作——发展您的角色，使其能够激励您，且变得得心应手。（Work） |
| 4 | 培养兴趣爱好——那些能完全吸引您注意力的活动。（Hobbies） |
| 5 | 做一些能让你感到振奋和充实的志愿工作。（Volunteer） |
| 6 | 尽可能多地表达感激之情。向您的团队表达您有多感激他们，或者感谢他们为您做某件事。（Gratitude） |', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 改善健康幸福的个人方法', '7.2 改善健康幸福的个人方法

| # | 原文建议 |
|---|---|
| 1 | 与您信任的人交谈，讨论您的恐惧和期望，以及您希望事情会如何发展。 |
| 2 | 把您的感受和进展写下来，记录在一个日记中，以便来日反思。 |
| 3 | 让自己定期腾出时间，将锻炼融入到日常生活中。 |
| 4 | 通过采用上面提到的积极策略来取代消极的自我对话，克服负面思维。 |
| 5 | 减少工作量——理想的工作量应该能让您保持兴趣、面临挑战、感到充实且忙碌，但不会让您感到不堪重负。 |
| 6 | 思考更大的格局——问问您自己「这有多重要？在长期经历中会造成问题吗？」 |
| 7 | 如果您感觉自己未得到提升，则寻求专业帮助。 |

7.3 提高员工健康幸福的组织方法

| # | 原文建议（英文版标签） |
|---|---|
| 1 | 教导员工辨别出压力的迹象并采取有效的减压方法（开始时，可以采用「Vets in Mind」压力评估工具）。（Stress） |
| 2 | 推广自我照养的文化，并提供资源让员工了解什么是正念和自我共情，理想情况下，还应设立一个「避风港」——一个让团队能够放松和进行自我照养的工作区域。（Culture） |
| 3 | 为团队提供支持/指导，并提供机会让他们讨论案例以及困难的客户互动状况。安排定期的确认会议，将会议当作安全的空间，供团队进行开放讨论。（Mentorship） |
| 4 | 鼓励职业发展——定期与团队讨论职业发展的机会，承担工作场所中的不同角色，并成为团队的导师。（Professional growth） |
| 5 | 推动良好的工作与生活平衡——鼓励与团队就时间安排、工作流程、灵活性和社区参与进行开放讨论。（Work-life balance） |
| 6 | 考虑采用匿名调查或收集反馈，以了解您所在工作场所的文化。（Surveys） |

7.4 章节 6 汇总清单与章节末清单差异

章节 1（4 条）、章节 3（10 条）、章节 4（3 条）、章节 5（8 条）汇总内容与章节末一致（如「诊所」在汇总中作「您的企业」）。章节 2 例外：汇总仅保留 1 条并新增 3 条——①您对「你在自己故事中的角色」的理解是否有改变？如果有，是什么改变？②您还想要了解更多关于什么的内容？怎么做能够帮助您？③您想要采取哪些步骤？您可以做些什么来提升「你在自己故事中的角色」，以改善您的心理健康？', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA 兽医职业健康指南 · 中英文版本差异与原文缺失标注', '8. 中英文版本差异与原文缺失标注

1. **文档性质**：中文版为 42 页 JSAP 文章译本（正文＋表 1＋表 2＋参考文献）；英文版为 38 页信息图（2025-05），无参考文献与完整表 1/表 2；内容冲突一律以中文版为准。
2. **章节标题**：6 章正式英文标题仅见英文版；第 6 章中文版作「总结」、英文版作 Top tips。
3. **连续带**：中文版仅用颜色（绿/黄/橙/红）且图 2 为图片；英文版给出 HEALTHY／REACTING／INJURED／ILL 四档命名与释义（§3.1）。
4. **生理影响**：英文版增列胃炎、胃溃疡并将肥胖归入内分泌；中文版肥胖仅在段落中作为慢性压力的直接/间接机制。
5. **资源条目**：中文版表 2 共 37 行（兽医学生 4 行＋兽医职业人士 13 行＋兽医诊所 20 行）；英文版 Resources 页仅 4 项并新增 NOMV（§6.6），且将 AVMA 条目标作 Wellbeing Assessment for Veterinarians – AVMA My Veterinary Life、注明 ProQOL 为自我施测。
6. **自评清单**：英文版仅章节 1、2 有 Checklist，章节 3–6 的清单在英文版**原文此处缺失**；中文版五章均有并在章节 6 汇总（差异见 §7.4）。
7. **抽取与版式**：①图 1、图 2、图 3 在原 PDF 为图片，图内文字**原文此处缺失**；②表 2 在抽取文本中跨页错行，本稿按 PDF 坐标重排还原（MMI Kite App 行国家栏跨页显示「美国／英国」；Overfield R. 行长链接在原文 PDF 即被截断，保留省略形式）；③raw_extracts 元数据将中文版第 39 页标记为 image-only，核对 PDF 后该页仅含期刊页脚，**无正文缺失**。
8. **原文缺失数值**：热线电话号码与服务时段；WEMWBS／Kessler 6／ProQOL 的条目数与计分分档（§4.4）；工作与生活融合、交叉性两节未见数值（§5.3）——均标注**原文此处缺失**。
9. **中文版术语不统一**：共情疲劳／同情疲劳、冒名顶替综合症／冒充者综合症、职业倦怠／倦怠；表 2「心理健康与福幸福」疑为「幸福」之排版错误，本稿照抄并标注。', '', '', '', '兽医职业健康,职业健康幸福指南,PERMA 模型,生物-心理-社会模型,WEMWBS,ProQOL,范围、目标与预警信号（章节 1）,健康幸福与幸福健康的定义（章节 1）,影响心理健康的个人因素（章节 2）', 'informational', 'WSAVA 兽医职业健康指南（Professional Wellness Guidelines）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA PWG 福祉提示与疫情期压力管理 · 材料性质与适用范围', '1. 材料性质与适用范围

1. **《在您的诊所营造健康幸福文化的 6 个关键步骤》（Creating a Culture of Wellbeing in Your Practice in 6 Key Steps）**：1 页英文提示单（PDF 上传于 2024-02）。原文说明：「兽医工作的性质意味着许多团队在充满挑战的条件下工作，压力水平可能高得不可接受（stress levels can be unacceptably high）；然而，营造一种让团队每位成员都投入（engaged）、有动力（motivated）并具备施展最佳能力条件的文化，当然是可以做到的。」该资源源自 **WSAVA 2023** 期间的圆桌讨论「**在兽医诊所落实健康（wellness）的实用提示**」（''Practical tips on how to implement wellness in the veterinary practice''），原文感谢所有参与者。
2. **《COVID-19 疫情期间面向临床人员的压力管理》（Stress Management for Clinicians during the COVID-19 Pandemic）**：2 页英文提示单（PDF 上传于 2020-04）。原文开篇：「WSAVA 职业健康小组（Professional Wellness Group, PWG）致力于改善全体兽医专业人员（veterinary professionals）的健康与福祉（health and well-being）。对于一个本就面临心理健康（mental health）挑战的职业，COVID-19 疫情又增添了不确定（uncertainty）与压力的一层。希望这些实用提示能帮助兽医团队成员保护自身心理健康并支持同事。」
3. **两份材料均为英文、无中文对照版**（原文此处缺失）；**未提供任何量化指标、评分档位、阈值或实施效果数据**（原文此处缺失）；**未提供电话号码、热线、邮箱或危机处置流程**（原文此处缺失）。
4. 提取文本存在 PDF 连字（ligature）乱码（如 `de-sƟgmaƟse`、`oﬀ-duty`、`Ɵme`），本稿已对照原 PDF 还原为 de-stigmatise、off-duty、time；其余英文小标题按原 PDF 版式复原（提取文本中标题与正文顺序错乱，正文按内容归回各标题下）。

2. 营造诊所健康幸福文化的 6 个步骤（逐条）', '', '', '', '兽医职业健康,日记（diary）,材料性质与适用范围', 'informational', 'WSAVA PWG 福祉提示与疫情期压力管理（Wellbeing Tips & COVID Stress Management）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA PWG 福祉提示与疫情期压力管理 · 步骤 1：开放讨论，为心理健康去污名化', '2.1 步骤 1：开放讨论，为心理健康去污名化

原文要旨：**在与团队的讨论中保持开放，以消除心理健康问题的污名（de-stigmatise）**。

- 营造支持性、开放的环境，在其中确保成员的心理安全（psychological safety）。
- 设定清晰的界限（clear boundaries）。
- 帮助成员管理时间，并进行指定的休息（designated breaks）。
- 「当他们不值班时，务必让他们真正不值班（When they''re off-duty, make sure they ARE off-duty!）」

2.2 步骤 2：协作的团队才是快乐的团队

原文要旨：**A collaborative team is a happy team（协作的团队才是快乐的团队）**。

- 力求确保团队综合技能与经验（combined skills and experience）得到最佳运用。
- 以身作则，认可成绩（recognizing successes）。
- 鼓励围绕挑战开展建设性讨论，并对困难病例进行事后回顾（debriefs on difficult cases）。

2.3 步骤 3：体育锻炼是极佳的减压方式

原文要旨：**Physical exercise is a fantastic stress-buster（体育锻炼是极佳的减压方式）**。

- 提供设施，使团队成员能够在休息时间内锻炼。
- 提供一间独立于员工休息室（staff room）的「安静室（quiet room）」。
- 它让团队成员在繁忙班次（busy shift）期间或之后有一个放松的空间。

2.4 步骤 4：保持人事流程（HR processes）更新

原文要旨：**Keep your HR processes up to date（保持人事流程更新）**。

- 确保所有团队成员熟悉这些流程。
- 确保为每位团队成员在日程中固定安排定期的一对一会议（one-to-one meetings）。
- 利用这些会议讨论绩效（performance）、设定目标（goals）、给予鼓励（encouragement）或提出顾虑（concerns）。', '', '', '', '兽医职业健康,日记（diary）,材料性质与适用范围', 'informational', 'WSAVA PWG 福祉提示与疫情期压力管理（Wellbeing Tips & COVID Stress Management）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA PWG 福祉提示与疫情期压力管理 · 步骤 5：伙伴制度（buddy schemes）帮助新成员', '2.5 步骤 5：伙伴制度（buddy schemes）帮助新成员

原文要旨：**Buddy schemes help new team members feel they have someone to turn to（伙伴制度让新团队成员感到有人可以求助）**。

- 它们非常适合新毕业者（new graduates），可让其跟随伙伴（shadow their buddy）一段时间。
- 导师计划（mentor program）也能对团队的体验（experience）与信心（confidence）产生积极影响。
- 导师会为处于任何层级（any level）的成员提供宝贵的支持与指导。

2.6 步骤 6：帮助他人让我们更快乐

原文要旨：**Research shows that helping others makes us happier（研究表明，帮助他人让我们更快乐）**。

- 为团队提供每年一天带薪假期（one paid day off a year），用于支持其自选的慈善机构（charity of their choice）。
- 或邀请团队选出「年度慈善机构（charity of the year）」。
- 全年举办筹款活动（fundraising events），支持所选定的慈善机构。

3. COVID-19 疫情期间临床人员的压力管理提示（逐条）

3.1 提供社会支持（Offer social support）

- 如果您是管理者，与同事交谈并询问他们的应对情况（how they are coping）。
- 他们可能觉得新的工作安排有压力；也可能在家庭方面遇到困难，例如不得不让孩子在家接受教育（home-schooling），或因工作时间减少而产生经济担忧（financial worries）。
- 安抚他们并表达支持。
- 克制给予建议的诱惑——「这往往不在于提供解决方案，而在于倾听并展现共情（listening and showing empathy）」。
- 在困难时期我们都需要社会支持（social support），而这当然不只来自同事：与家人、朋友、更广的社交网络以及伴侣动物（companion animals）保持联系，因为它们都帮助我们应对压力；并鼓励同事同样这样做。', '', '', '', '兽医职业健康,日记（diary）,材料性质与适用范围', 'informational', 'WSAVA PWG 福祉提示与疫情期压力管理（Wellbeing Tips & COVID Stress Management）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA PWG 福祉提示与疫情期压力管理 · 保持掌控感（Stay in control）', '3.2 保持掌控感（Stay in control）

- 「这不是照常营业（this is not ''business as usual''），您无法控制一切。」
- 您能控制的是自己的努力（effort）与态度（attitude）。
- 试着忽略外部因素，把精力集中在能够改变的地方——保障您的业务（safeguarding your business）、保护团队与患者（patients）的身体与心理健康，当然也保护您自己的身心健康。
- 若能做到，问题会显得更可控，您也会更有效。

3.3 把团队凝聚在一起（Keep your team together）

- 在人手精简（skeleton staff）或远程工作（working remotely）的情况下维持团队感是困难的；请尽力确保每个人仍然感到自己是团队的一员。
- 小小的姿态——赞美、表扬或其他善意的举动（compliments, praise or other acts of kindness）——意义重大，有助于维系甚至加强团队的纽带（team bonds）。
- 设法创造接触的机会：如果不能面对面，或许可以举办线上问答（online quiz）或其他社交活动，把同事聚在一起。

3.4 坚持您的日常作息（Stick to your routine）

- 所有人都从熟悉的作息与一天的结构中受益；当我们以新方式工作（例如远程或居家）时，这一点更加重要。
- 尽量在同一时间起床、同一时间进食。
- 为当天设定目标，或按您的偏好写一份「待办清单（''to do'' list）」。
- 这会给您目的感与成就感，并帮助您保持专注。

3.5 记日记（Keep a diary）

- 有些人觉得记日记有帮助：可以写下困扰您的事情。
- 同时记下每天发生的**三件最好的事（the three best things that happened each day）**。
- 这有助于维持积极（positive）的心态。
- 原文补充：「这听起来是老生常谈（sounds a cliché），但在任何情境中聚焦积极的一面确实让我们感觉更好、更有能力应对。」

3.6 预留放松时间（Build in time to relax）

- 无论帮助您放松的是运动（sport）、散步（walk）、烹饪（cooking）还是简单的泡澡（a simple bath），确保每天花一些时间做这件事。
- **即使只有 15 分钟（just 15 minutes）**，之后您也会更高效、更有成效。
- 把它安排进您一天的计划中。', '', '', '', '兽医职业健康,日记（diary）,材料性质与适用范围', 'informational', 'WSAVA PWG 福祉提示与疫情期压力管理（Wellbeing Tips & COVID Stress Management）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA PWG 福祉提示与疫情期压力管理 · 保证足够睡眠（Get enough sleep）', '3.7 保证足够睡眠（Get enough sleep）

- 认真对待睡眠卫生（sleep hygiene）。
- 每天在同一时间上床，并先试着放松。
- 不要在睡前大量进食与饮酒：虽然您可能很快入睡，但整体睡眠质量可能没那么好。

3.8 警惕「专家」（Beware of experts!）

- 我们都知道社交媒体的危险，事实是网上存在大量错误信息（misinformation）；它会加剧我们正在经历的一切恐惧与不确定。
- 不要一直看新闻，也不要相信您读到或听到的一切。
- 如果您在寻求建议，请务必只信任专业来源——您所在地区的兽医协会（regional veterinary associations）、WSAVA 或政府机构（governmental bodies）。

4. 原文提供的延伸资源

| 资源 | 原文内容 |
|---|---|
| PWG 资源汇总 | 原文称「点击此链接获取更多来自 WSAVA 职业健康小组的帮助资源，包括 WSAVA 的**职业发展与个人健康幸福证书（Professional Development and Personal Wellbeing Certificate）**」 |
| 官网 | WWW.WSAVA.ORG |
| 网络研讨会 1 | ''Stress management during Difficult Times''——Dr Nienke Endenburg（WSAVA PWG 联合主席 Co-Chair）主讲；https://hillsvet.webex.com/recordingservice/sites/hillsvet/recording/2aade5d52e8d4ae3b2e348e022e7b59c |
| 网络研讨会 2 | ''Coping with the Chaos of COVID-19''——PWG 成员 Dr Marie Holowaychuk 主讲；https://www.youtube.com/watch?v=mAwJVHcvsO0&feature=youtu.be |
| PWG 委员会页面 | https://wsava.org/committees/professional-wellness-group/ |

上述三条 URL 取自原 PDF 的内嵌链接注释；提取正文仅含「Check this link / we recommend these webinars / visit the website」等文字而未含链接地址。', '', '', '', '兽医职业健康,日记（diary）,材料性质与适用范围', 'caution', 'WSAVA PWG 福祉提示与疫情期压力管理（Wellbeing Tips & COVID Stress Management）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('WSAVA PWG 福祉提示与疫情期压力管理 · 与主指南的衔接', '5. 与主指南的衔接

两份提示单均不定义健康幸福（wellbeing）与幸福健康（wellness），也**未给出量表或自评清单**（原文此处缺失）；其可执行建议与《WSAVA 兽医职业健康指南》章节 6「顶级建议（Top tips）」的组织方法条目相呼应（见 `01-WSAVA兽医职业健康指南.md` §7.3：自我照养文化、「避风港」放松区域、支持/指导与定期会议、匿名调查与反馈收集）。', '', '', '', '兽医职业健康,日记（diary）,材料性质与适用范围', 'informational', 'WSAVA PWG 福祉提示与疫情期压力管理（Wellbeing Tips & COVID Stress Management）整理稿', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 第 1 段', 'Finding the Balance：在兽医文献中寻找平衡——发掘复原力（中文整理稿）

1. 研究问题

复原力（Resilience，又称心理韧性）是兽医教育与研究中日益重要的议题。本文旨在评估当代（1995 年至今）兽医心理健康研究与教育文献如何呈现复原力，并尝试做出初步综合，形成兽医情境下复原力的概念框架。作者采用的临时性定义来自 Mansfield 等对教师复原力的概念化：复原力同时是一种能力（capacity）、一个过程（process）与一种结果（outcome）——个体利用个人与情境资源穿越挑战的动态过程，通过特定策略与资源的交互产生专业投入、满意感与幸福感等结果。

2. 方法（样本、工具、统计）

本研究为文献的定性分析（qualitative analysis），非传统系统综述。

- 检索数据库：Web of Science（含 CAB Abstracts、Medline、Current Contents）、ERIC、PsycINFO；检索词为 veterinar*（兽医保有/兽医）搭配 resilience、thriving、coping strategies、work/job/personal/life satisfaction、wellbeing/well-being、positive psychology、optimism、engagement、self-care、stress management、mindfulness、mental health、stress、burnout、anxiety、suicide、suicidal、depression、compassion fatigue 等问题取向或幸福取向的心理健康术语；限定 1995 年至今发表。
- 筛选流程：检索命中 n = 1,545 篇，导入 EndNote X7.4，按标题/摘要剔除不相关文献 n = 1,300；剔除非英文及非同行评审来源（信件、新闻、会议摘要）n = 177；剔除无法获取或非可检索 PDF 者 n = 9；最终纳入 59 篇。
- 分析分三阶段，使用质性分析软件 NVivo 10.2.2：① 对全部文本做心理健康术语的原始词频统计（含参考文献与关键词）；② 人工编码其中报告实证研究的子集（n = 38），提取结局/测量变量、风险因素与保护因素、提出的解决方案；③ 对全部 59 篇做术语检索，统计提及各复原力因素的文献数，并按个人资源、情境资源、策略、结果四个分组归类（沿用教师复原力概念化框架）。
- 另检索 10 项能力框架（competency frameworks，来自一项近期系统综述）中与复原力相关的条目，纳入标准为 2000 年后发布、由可识别的专家共识或评审过程制定、正式发表于同行评审刊物或被国际认证机构采纳。', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 主要结果', '3. 主要结果

**(1) 问题取向术语约 2:1 压倒幸福取向术语。** 原文表 1 给出原始词频，抽取时版式压平，仅前三个词保留了计数：

| 术语 | 词频 |
|---|---|
| Stress, stressful | 2,273 |
| Suicide, suicidal | 1,522 |
| Depression, depressive | 1,027 |
| Support / Stressor, stressors / Burnout / Resources / Anxiety / Satisfaction / Coping / Positive / Help / Distress / Engagement / Wellbeing, well-being / Death, deaths / Exhaustion / Fatigue / Success, successful / Resilience / Optimism / Cynicism / Proactive / Motivation / Wellness / Healthy / Happiness | 原文此处缺失（词名保留、计数在抽取中丢失；原文以粗体标示幸福/复原取向词汇，粗体信息亦丢失） |

stress、suicide、depression 三个词约占全部心理健康词频的近一半。来源标题中最常见的是 stress/stressor（21 篇），其次 wellbeing/wellness（17 篇）、suicide（10 篇）。

**(2) 38 项实证研究概览（原文表 2，研究数括注）。** 前 11 行按原文逐行还原：', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 主要结果 (2)', '| 测量的结局（30 项研究报告） | 识别的风险因素（25） | 识别的保护因素（17） | 提出的解决方案（26） |
|---|---|---|---|
| Depression (14) | Workload (21) | Peer support (9) | Training (22) |
| Specific stressors (12) | Recent/younger graduate (10) | Job satisfaction (4) | Counseling (13) |
| Anxiety (10) | Female gender (8) | Workshop intervention (4) | Support networks (11) |
| Stress (8) | Lack of work–life balance (8) | Optimism (2) | Mentoring (8) |
| Job satisfaction (5) | Performance concerns (6) | Self-esteem (2) | Help-seeking culture (7) |
| Job stress/demands (5) | Financial concerns (5) | Self-efficacy (2) | Autonomy (6) |
| Social support (5) | Isolation, homesickness (5) | Relationships (1) | Problem solving (5) |
| Burnout (4) | Uncertainty, lack of control (5) | Motivation (1) | Reduced workload (5) |
| Mental health (4) | Lack of support (5) | Autonomy (1) | Exercise (4) |
| Suicide attempt (4) | Moral challenges (3) | Exercise (1) | Admissions selection (3) |
| Suicide ideation (3) | Team conflict (3) | Hobbies (1) | Empathy, recognition (2) |', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 主要结果 (3)', '表格末段抽取后行列对应关系丢失（原文此处缺失），残余条目为：Work characteristics (3)、Attitudes to mental health (3)、Personal resources (3)、Work engagement (3)、Work–home interaction (3)、Well-being (2)、Positive/negative affect (2)、Life satisfaction (2)、Resilience (1)、Team effectiveness (1)、Perfectionism (3)、Perfectionism (1)、Mental health stigma (2)、Relationship issues (1)、Workload (2)、Optimism (2)、Work–life balance (2)、Job resources (3)、Physical health (2)、Mindfulness (2)。

要点：最常测的结局是抑郁、焦虑、压力等心理健康问题；仅少数研究使用幸福感效度量表（如已在兽医群体验证的 Warwick–Edinburgh Mental Well-Being Scale, WEMWBS）；最一致的风险因素是工作量（学业压力/工作要求、工作-生活平衡受阻、尤其长时间工时）；不足半数研究报告了任何保护因素，社会支持是最常见的保护因素；训练、心理咨询、支持网络与导师制是最常被提议的方案；研究设计以横断面或回顾性为主，仅少数在本科阶段或毕业初期开展了干预。

**(3) 复原力概念本身发育不良。** resilience/resilient 一词出现在 20 篇纳入文献中，仅少数给出定义；只有 1 项研究使用了效度化的复原力量表——Brief Resilience Scale (BRS)（Crane 等）。

**(4) 复原力因素提及频次（原文表 3，文献数括注，前 11 行逐行还原）：**', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 主要结果 (4)', '| 个人资源（53 篇） | 情境资源（55） | 策略（50） | 结果（51） |
|---|---|---|---|
| Emotional competence (27) | Relationships (43) | Life balance (30) | Well-being (45) |
| Motivation (19) | Colleagues (32) | Professional development (18) | Job satisfaction (23) |
| Sense of meaning, purpose (13) | Family support (28) | Counseling, therapy (16) | Enjoyment (17) |
| Autonomy (11) | Social support (26) | Time management (15) | Self-esteem (14) |
| Optimism (11) | Mentors (19) | Problem solving (12) | Engagement (12) |
| Confidence (10) | Feedback (15) | Exercise (12) | Fulfillment (10) |
| Flexibility, adaptability (9) | Support networks (14) | Meditation (12) | Life satisfaction (7) |
| Assertiveness (8) | Peer support (12) | Reflective practice (12) | Happiness (3) |
| Proactivity (8) | Decision latitude (12) | Coaching (8) | Thriving (3) |
| Self-awareness (6) | Culture (11) | Sleep (8) | Flourishing (2) |
| Self-efficacy (6) | Skills discretion (10) | Diet, nutrition (7) | "Compassion satisfaction" (2) |', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 主要结果 (5)', '末段同样行列对应丢失（原文此处缺失），残余条目：Perspective (6)、Mindfulness (7)、Eudaimonia (1)、Initiative (5)、Hobbies, volunteering (7)、Persistence (4)、Spirituality, religion (6)、Hope (3)、Help-seeking (6)、Positive attitude (2)、Gratitude (4)、Self-compassion (1)、Prioritization, organization (4)、Humor (4)、Positive psychology (3)、Setting boundaries (2)、Goal-setting (2)。最常见提及的因素是各类关系性支持/导师制；个人资源中 emotional competence（情绪胜任力）与 motivation/purpose（动机与意义感）最高；最常见的策略是 life balance（通常表述为 work–life balance）。

**(5) 能力框架覆盖不足（原文表 4）。** 仅 2 项兽医能力框架明确使用 resilient/resilience 一词：RCVS Day One Competences 2014（"veterinary surgeons need to be resilient and confident in their own professional judgments to withstand the stresses and conflicting demands..."）与 Lewis & Klausner 2003 非技术胜任力（"Demonstrates adaptability and resilience"）。其余框架（Walsh 等 2001 加州大学毕业生特质、Lloyd & Walsh 2002 课程模板、Collins & Taylor 2002 澳洲毕业生特质、Miller 等 2004 食品动物执业者定义能力、NAVMEC 2011 核心胜任力、Vandeweerd 等 2014 比利时/法国框架）部分内含复原力要素。三个最一致的主题：承受/管理压力、工作-生活平衡、适应变化或不确定性。两项近期框架（含 OIE 2012 Day 1 胜任力建议）未包含复原力相关胜任力。', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 主要结果 (6)', '**(6) 文献内部的反差证据。** 一项大型美国调查在报告"veterinarians frequently experience health-threatening stress related to the demands of practicing veterinary medicine"的同时，同一 80% 受访者同意/非常同意"快乐地在做兽医"；一项高质量系统综述（Platt 等）结论为"little evidence that veterinary surgeons have particularly poor mental health or suffer from exceptionally high levels of stress"。', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Finding the Balance · 结论与临床启示', '4. 结论与临床启示

作者提出兽医复原力的初步综合：七个关键主题——情绪胜任力（emotional competence）、动机（motivation）、个人资源、社会支持、组织文化、生活平衡（life balance）、幸福策略（well-being strategies）；并背书复原力为"涉及个人与情境资源、策略与结果的动态多维过程（能力—过程—结果）"。启示：① 兽医心理健康教育与研究应在问题取向与幸福取向之间取得更大平衡，正性心理学（positive psychology）视角在兽医文献中极少出现；② 现有能力框架未能覆盖复原力所需的全部能力、态度与资源，投入支持/求助（情境资源）胜任力欠表达，动机与影响组织文化相关胜任力缺失；③ 女性、年轻/新近毕业这两个"棘手"风险因素叠加兽医行业女性化趋势，凸显验证干预方案的重要性；④ 此概念为临时性，应随未来研究重新评估。

5. 局限

作者自陈：① 本文无意对纳入文献的证据强弱做系统评价，故不能支持确定结论；② 复原力在兽医文献中概念欠发达、研究稀少，综合仅为 scoping 性质的初步尝试；③ 领域内以横断面/回顾性设计为主，无法确立因果，缺乏干预研究报告与疗效验证；④ 检索限定英文与 1995 年后、排除临床专科期刊以防动物性研究噪声，可能遗漏相关文献。另需说明：本整理依据 PDF 抽取文本，表 1 计数与表 2、表 3 末段、表 4 完整引文在抽取中压平丢失，均已在对应处标注"原文此处缺失"。', '', '', '', '兽医职业健康,复原力,Resilience,兽医心理健康,幸福感,词频分析,研究问题,方法（样本、工具、统计）,主要结果', 'informational', 'Finding the Balance：兽医文献中的复原力综述（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生的复原力与正念、自悯的预测作用 · 兽医学生的复原力与正念（Mindfulness）、自悯（Self-Compass', '兽医学生的复原力与正念（Mindfulness）、自悯（Self-Compassion）的预测作用（中文整理稿）

1. 研究问题

复原力是兽医专业生活质量（professional quality of life）的重要成分，但兽医领域实证研究极少。本研究采用复原力框架开展探索性研究，回答两个问题：① 兽医学生报告的复原力水平如何？② 兽医学生的复原力是否可由正念与自悯预测？作者采用的工作定义：复原力是个体利用个人与情境资源、运用特定策略应对挑战并达成适应性结果的动态多维过程。', '', '', '', '兽医职业健康,复原力,Resilience,BRS,正念,不评判,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '兽医学生的复原力与正念、自悯的预测作用（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生的复原力与正念、自悯的预测作用 · 方法（样本、工具、统计）', '2. 方法（样本、工具、统计）

- 设计：横断面研究（cross-sectional study）。2015 年 7 月下旬通过行政人员以社交媒体与邮件联系学生，约 2 周后再次联系；匿名自愿问卷经 SurveyMonkey 在线完成；参与人数最多的院校可获得 200 澳元学生联合会捐赠。伦理批准：阿德莱德大学人类研究伦理委员会（Approval number: H-2015–135）。
- 样本：目标人群为约 828 名处于临床学习阶段的澳大利亚兽医学生（覆盖六所兽医学院；未开始校外实践或未在兽医诊所工作者排除）。255 名学生开始作答（回收率 31%），193 份数据完整可用（23%）；任一量表缺失超过两个条目者剔除。
- 测量工具：
  - Brief Resilience Scale (BRS)：6 个条目，Likert 1（强烈不同意）至 5（强烈同意），部分反向计分，条目均分 1–5；原作者报告 Cronbach''s α = .80–.91，本测试 α = .88。基于 844 人合并样本，原作者给出一般人群均分 3.70，低于 3.00（m − s）为"低复原力"，高于 4.30（m + s）为"高复原力"。
  - Five Facet Mindfulness Questionnaire（五因素正念问卷）：39 个条目，Likert 1（从不或极少）至 5（经常或总是），总分 39–195，含观察、描述、有觉知地行动、不评判、不反应五个向度；原文效度研究 α = .72–.92；本测试各向度 α：观察 = .80、描述 = .91、有觉知地行动 = .91、不评判 = .91、不反应 = .82。
  - Neff Self-Compassion Scale（自悯量表）：26 个条目，Likert 1（几乎从不）至 5（几乎总是），含自我友善、自我批评、共通人性、孤立感、正念、过度认同六个分量表，取总分均值；原作者报告 α = .92，本测试 α = .92。
- 统计：检查线性、同方差、多重共线性（VIF 与容忍度可接受）、正态性（偏度/峰度与正态概率图）；删除 1 个标准化残差大于 −3.3 的离群个案；缺失数据按列表剔除（listwise）。先做双变量相关，再把与因变量相关 p < .2 的变量纳入 Enter 法多元线性回归；性别设为虚拟变量（男 = 0，女 = 1）。软件 SPSS 22.0 for Windows。', '', '', '', '兽医职业健康,复原力,Resilience,BRS,正念,不评判,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '兽医学生的复原力与正念、自悯的预测作用（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生的复原力与正念、自悯的预测作用 · 主要结果', '3. 主要结果

样本特征：女性占 83%；平均年龄 24 岁（M = 24.3，SD = 4.09）。

原文表 1（描述统计；抽取中 n 列数值丢失，原文此处缺失）：

| 变量 | Mean | SD | Range |
|---|---|---|---|
| Age | 24.36 | 4.09 | 18–48 |
| Brief Resilience Scale | 3.16 | .82 | 1–5 |
| Neff Self-Compassion Scale | 2.71 | .58 | 1.52–4.25 |
| Acting aware mindfulness | 23.31 | 6.32 | 9–40 |
| Describing mindfulness | 24.74 | 6.91 | 9–40 |
| Observing mindfulness | 25.65 | 5.73 | 10–40 |
| Nonjudgmental mindfulness | 22.39 | 6.94 | 8–40 |
| Nonreactive mindfulness | 20.34 | 4.61 | 7–33 |

复原力分级：60% 报告平均水平，34% 为低复原力，仅 6% 达到高复原力（讨论部分表述为"33% of veterinary students in this study demonstrated low capacity for resilience"，两处百分比照录）。

原文表 2（全变量双变量相关矩阵，下三角；照录原表注：* 相关在 .01 水平显著（双尾），† 相关在 .05 水平显著（双尾）——注意与原表 3 的星号约定不同）：', '', '', '', '兽医职业健康,复原力,Resilience,BRS,正念,不评判,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '兽医学生的复原力与正念、自悯的预测作用（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生的复原力与正念、自悯的预测作用 · 主要结果 (2)', '| 变量 | Neff Self-Comp. | Observing | Describing | Acting aware | Nonjudgmental | Nonreactive | Brief Resilience | Gender |
|---|---|---|---|---|---|---|---|---|
| Observing mindfulness | .209* | | | | | | | |
| Describing mindfulness | .077 | .307† | | | | | | |
| Acting aware mindfulness | .424* | .060 | .223† | | | | | |
| Nonjudgmental mindfulness | .517* | −.117 | .026 | .366* | | | | |
| Nonreactive mindfulness | .566* | .314* | .136 | .179† | .094 | | | |
| Brief Resilience | .535* | .157† | .045 | .264* | .339* | .412* | | |
| Gender | −1.390（疑抽取形变，原文此处缺失） | .079 | .069 | .020 | −.013 | −.162† | −.159† | |
| Age | −.036 | .039 | .140 | .010 | −.021 | −.047 | −.015 | −.061 |

原文表 3（解释变量与 BRS 的相关；注：* p < .05，† p < .01，‡ p < .001，带下划线者 .05 < p < .2，下划线在抽取中丢失）：Acting with awareness .264†；Nonjudgmental .339‡；Nonreactive .412‡；Observing .157*；Describing .045；Neff Self-Compassion .535‡；Age −.015；Gender −.159*。年龄与描述正念因 p 超过 .2 未纳入回归。

原文表 4（多元回归，Enter 法）：', '', '', '', '兽医职业健康,复原力,Resilience,BRS,正念,不评判,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '兽医学生的复原力与正念、自悯的预测作用（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('兽医学生的复原力与正念、自悯的预测作用 · 主要结果 (3)', '| 解释变量 | B（非标准化） | B（标准化） |
|---|---|---|
| Acting with awareness mindfulness | .006 | .048 |
| Nonjudgmental mindfulness | .019 | .169* |
| Nonreactive mindfulness | .035 | .205* |
| Observing mindfulness | .008 | .061 |
| Neff Self-Compassion Scale | .364 | .266* |
| Gender | −.155 | −.074 |
| R²（调整 R²） | .312（.286） | |

注：* p < .05；原表说明句为 "B is the standardized coefficient and B is the unstandardized coefficient."（β/B 符号在抽取中合并）。

总模型解释复原力 31% 的变异（F[6, 161] = 12.147, p < .001）。自悯（b = .266, p < .05）、不评判正念（b = .169, p < .05）、不反应正念（b = .205, p < .05）显著预测复原力：三者得分越高的学生复原力越高。', '', '', '', '兽医职业健康,复原力,Resilience,BRS,正念,不评判,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '兽医学生的复原力与正念、自悯的预测作用（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生的复原力与正念、自悯的预测作用 · 结论与临床启示', '4. 结论与临床启示

这是首篇报告兽医学生一般复原力水平的研究：按 BRS 常模标准，仅 6% 达高复原力，约三分之一属低复原力，提示需要系统性增强兽医学生的复原力容量。自悯可视为个人资源、正念（尤其不反应与不评判两个向度）可视为策略，二者合计解释约 31% 变异，是可行的干预靶点。作者联系兽医群体中已报告的特质完美主义（trait perfectionism）与临床错误、道德压力（moral stress，如不情愿的安乐死）讨论：不评判/不反应有助管理完美主义伴随的无效自我批评，自悯有助在道德压力下保持适度分离与自我关怀。对教育者的启示：可参考已将正念课程嵌入本科教学的先例（该先例中不反应与不评判向度在课程结束时显著提升并维持至 6 周随访），设计经情境化改造、体验式（experiential）而非纯讲授的干预——正念训练"从根本上重训大脑"，依赖神经可塑性、需要时间与循环强化；医教文献亦提示进入临床阶段最需要正念训练的学生参与 MBSR（正念减压）意愿最高，故宜在入学临床环节前提升学生对自悯与正念策略的认识。

5. 局限

① BRS 测量的是非情境性的一般"反弹"能力，且测不出个体从逆境中的成长，可能高估或低估兽医教育情境中的实际复原力；② 样本量相对小、回收率低（23%），但性别分布大致代表兽医学生群体；③ 横断面设计与分析不能推断因果，作者建议纵向研究考察：干预实施期间复原力如何变化、毕业后复原力容量如何表现、随个人与职业情境变化复原力如何随时间改变；④ 领域内缺乏情境特异（context-specific）的复原力测量工具，需开发与验证。', '', '', '', '兽医职业健康,复原力,Resilience,BRS,正念,不评判,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '兽医学生的复原力与正念、自悯的预测作用（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('澳洲兽医学生同情疲劳流行率及相关心理因素 · 澳大利亚兽医学生同情疲劳（Compassion Fatigue）的流行率及相关心', '澳大利亚兽医学生同情疲劳（Compassion Fatigue）的流行率及相关心理因素（中文整理稿）

1. 研究问题

同情疲劳由职业倦怠（burnout）与二次创伤应激（secondary traumatic stress）两部分构成，另有独立的同情满足（compassion satisfaction）维度（按 Stamm 的 ProQOL 框架，三者合称职业生活质量，professional quality of life）。此前兽医学界尚无关于兽医学生（乃至兽医领域）二次创伤应激与同情满足的已发表文献。研究目的有二：① 确定澳大利亚兽医学生同情满足、职业倦怠、二次创伤应激的流行率；② 考察上述结果变量与自我污名（self-stigma）、应对（coping）、共情（empathy）、正念（mindfulness）等心理因素及人口学控制变量的关联。', '', '', '', '兽医职业健康,同情疲劳,职业倦怠,Burnout,二次创伤应激,同情满足,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('澳洲兽医学生同情疲劳流行率及相关心理因素 · 方法（样本、工具、统计）', '2. 方法（样本、工具、统计）

- 设计与流程：横断面在线问卷。向澳大利亚全部七所兽医学院发出邀请，筛选条件为已完成至少 2 周校外实践（extramural study, EMS）或曾在兽医诊所工作；七所中六所同意经邮件转发，另经 Facebook 扩散，约两周后发跟进邮件。回收窗口 2015 年 7 月底至 9 月初约 6 周。伦理批准：阿德莱德大学人类研究伦理委员会。抽样/邀请 828 名学生，255 名完成（回收率 31%），其中 193 名（193/828，23%）满足纳入条件且答卷完整，来自七所中的六所。
- 人口学：女性 n = 160（83%），平均年龄 24.4 岁（SD = 4.09，范围 18–48）；临床实践经历 0–46 周（mean = 13.79，SD = 10.58）；43%（n = 82）曾在兽医诊所工作。
- 工具：
  - 结果变量：Professional Quality of Life Scale (version 5)（ProQOL），30 个条目，按过去 30 天发生频率 Likert 1（从不）至 5（总是），分同情满足、职业倦怠、二次创伤应激三个分量表；原始分转 t 分后按第 25/50/75 百分位切分为低/中/高。原文表 1 切分分数：

    | ProQOL 变量 | 低分组（下四分位） | 平均分（中） | 高分组（上四分位） |
    |---|---|---|---|
    | Compassion satisfaction | <44 | 44–57 | >57 |
    | Burnout | <43 | 43–56 | >56 |
    | Secondary traumatic stress | <42 | 42–56 | >56 |

    原文引述该量表既往信度：同情满足 α = .88、二次创伤应激 α = .81、职业倦怠 α = .75。
  - 预测变量：Self-Stigma of Seeking Help Scale（求助自我污名，10 条目，1–5 计分求和；原研究 α = .91）；Brief COPE（简要应对，28 条目，1「完全没做」至 4「经常做」，分情绪聚焦 10–40、问题聚焦 6–24、功能失调 12–48 三个分量表；原文献报告情绪聚焦与功能失调 α = .72 与 .75、问题聚焦 α = .84）；Davis Interpersonal Reactivity Index (IRI)（人际反应指针，28 条目，分幻想、观点采择、共情关怀、个人困扰四个向度，各 7 条目求和；原量表各向度 α = .71–.77）；Five Facet Mindfulness Questionnaire（五因素正念问卷，38 条目，分观察、描述、有觉知地行动、不反应、不评判五个向度；原文献 α = .75–.9）。
- 本样本信度（Cronbach''s α）：同情满足 .88、二次创伤应激 .84、职业倦怠 .70；正念五向度：观察 .80、描述 .91、有觉知地行动 .91、不评判 .91、不反应 .82；应对：问题聚焦 .81（好）、情绪聚焦 .69、功能失调 .66（可疑）；求助自我污名 .88；IRI：幻想 .82、观点采择 .85、共情关怀 .75、个人困扰 .77。
- 统计：同方差/线性/多重共线性/正态性检验合格；删除 1 个标准化残差大于 −3.3 的离群个案；缺失数据列表剔除；双变量相关后，将与结果变量相关 p < .2 的变量以 Enter 法纳入多元回归；模型另含年龄、性别、诊所工作史、EMS 周数作控制变量；性别与工作史设虚拟变量（男 = 0 女 = 1；曾在诊所工作 = 0，未曾 = 1）。软件 SPSS 22.0。', '', '', '', '兽医职业健康,同情疲劳,职业倦怠,Burnout,二次创伤应激,同情满足,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果', '3. 主要结果

**流行率（原文表 2）：**

| ProQOL 变量 | 低 | 平均 | 高 |
|---|---|---|---|
| Compassion satisfaction | 41 (21%) | 111 (58%) | 41 (21%) |
| Burnout | 53 (28%) | 82 (43%) | 57 (30%) |
| Secondary traumatic stress | 45 (23%) | 101 (52%) | 47 (24%) |

即约 30% 学生处于高倦怠风险、24% 处于高二次创伤应激风险、21% 报告低同情满足。

**结果变量间相关：** 二次创伤应激与职业倦怠正相关（r = .642, n = 192, p < .001）；同情满足与职业倦怠负相关（r = −.427, n = 192, p < .001）；二次创伤应激与同情满足无显著相关。Stamm 报告两倦怠/创伤分量表共有方差的关联为 r = .58。

**双变量相关（原文表 3；注：* p < .05，† p < .01，‡ p < .001，带下划线者 .05 < p < .2，下划线在抽取中丢失）：**', '', '', '', '兽医职业健康,同情疲劳,职业倦怠,Burnout,二次创伤应激,同情满足,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果 (2)', '| 变量 | 同情满足 | 职业倦怠 | 二次创伤应激 |
|---|---|---|---|
| Dysfunctional coping | −.098 | .531‡ | .527‡ |
| Problem-focused coping | .435‡ | −.178* | .137 |
| Emotion-focused coping | .326‡ | −.042 | .130 |
| Self-stigma | −.089 | .159* | −.157*（据回归方向疑抽取形变） |
| Observing mindfulness | .340‡ | −.172* | −.010 |
| Describing mindfulness | .248† | −.061 | −.036 |
| Acting-with-awareness mindfulness | .165* | −.457‡ | −.368‡ |
| Nonjudgmental mindfulness | .084 | −.407‡ | −.441‡ |
| Nonreactive mindfulness | .250† | −.286‡ | −.161* |
| Fantasy IRI | .202† | .078 | .190† |
| Perspective taking IRI | .294‡ | −.059 | −.112 |
| Empathic concern IRI | .314‡ | −.043 | −.250† |
| Personal distress IRI | −.233† | .339‡ | .339‡ |
| Age | −.056 | −.043 | −.078 |
| Gender | .169* | .047 | .162* |
| Work | −.238† | .184* | .098 |

功能失调应对（与同情满足，.05 < p < .2）及问题聚焦、情绪聚焦应对、观点采择、工作史（与二次创伤应激，均 .05 < p < .2）虽未达显著亦保留入回归。年龄与任何结果变量均无显著相关。

**回归（原文表 4，Enter 法；B 非标准化、b 标准化；注：* p < .05，† p < .01，‡ p < .001）：**', '', '', '', '兽医职业健康,同情疲劳,职业倦怠,Burnout,二次创伤应激,同情满足,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果 (3)', '| 变量 | 二次创伤应激 B | b | 职业倦怠 B | b | 同情满足 B | b |
|---|---|---|---|---|---|---|
| Nonjudgmental mindfulness | −1.135 | −.113 | −1.470 | −.148* | – | – |
| Nonreactive mindfulness | −.261 | −.025 | −1.252 | −.124 | 1.409 | .142 |
| Observing mindfulness | – | – | −.961 | −.096 | .858 | .089 |
| Describing mindfulness | – | – | – | – | −.584 | −.060 |
| Acting-with-awareness mindfulness | −1.536 | −.154* | −2.156 | −.218† | .408 | .706（疑抽取形变） |
| Dysfunctional coping | 2.938 | .296‡ | 3.920 | .397‡ | −1.333 | −.141 |
| Problem-focused coping | 1.126 | .109 | −1.261 | −.123 | 1.637 | .167 |
| Emotion-focused coping | −.205 | −.020 | – | – | 1.314 | .135 |
| Personal distress IRI | 2.674 | .254‡ | .071 | .007 | −1.953 | −.196* |
| Fantasy IRI | −.606 | −.061 | – | – | 1.172 | .124 |
| Perspective taking IRI | 1.195 | .119 | – | – | .114 | .012 |
| Empathic concern IRI | .970 | .757（疑抽取形变） | – | – | 1.711 | .183* |
| Self-stigma | 1.378 | .140* | .022 | .002 | – | – |
| Gender | 1.710 | .064 | – | – | 3.930 | .156* |
| Work in vet. clinic | 2.034 | .100 | 2.506 | .124* | −3.395 | −.175* |
| R²（调整 R²） | .497（.454）‡ | | .471（.441）‡ | | .38（.327）‡ | |', '', '', '', '兽医职业健康,同情疲劳,职业倦怠,Burnout,二次创伤应激,同情满足,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('澳洲兽医学生同情疲劳流行率及相关心理因素 · 主要结果 (4)', '- 同情满足模型解释 38% 方差（F[13, 153] = 7.208, p < .001）：共情关怀（b = .183, p < .05）与个人困扰（b = −.196, p < .05）显著，另有性别（b = .156, p < .05）与诊所工作史（b = −.175, p < .05）——高共情关怀、低个人困扰、女性、曾在诊所工作的学生同情满足更高。
- 职业倦怠模型解释 47% 方差（F[9, 157] = 15.557, p < .001）：功能失调应对（b = .397, p < .001）、有觉知地行动正念（b = −.218, p < .01）、不评判正念（b = −.148, p < .05）显著；工作史（b = .124, p < .05）显示无诊所工作经历者倦怠更高。
- 二次创伤应激模型解释 50% 方差（F[13, 153] = 11.624, p < .001）：求助自我污名（b = .140, p < .05）、功能失调应对（b = .296, p < .001）、有觉知地行动正念（b = −.154, p < .05）、个人困扰（b = .254, p < .001）显著。

**与参照人群比较（原文讨论引述）：** 美国护理实践博士（DNP）学生同情满足高/平均/低为 27%/44%/29%，高倦怠风险 22%；英国助产士学生 0% 报告低同情满足、45% 平均、56.4% 高，100 余名学生中无一人达到高倦怠风险线；学生医护群体高二次创伤应激风险报道范围 0%–60%，难以直接比较。', '', '', '', '兽医职业健康,同情疲劳,职业倦怠,Burnout,二次创伤应激,同情满足,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('澳洲兽医学生同情疲劳流行率及相关心理因素 · 结论与临床启示', '4. 结论与临床启示

这是首个考察兽医学生同情疲劳与同情满足及其心理因素关联的研究，并首次实证提示兽医学生会经历二次创伤应激。作者结论：某些情绪特征与应对方式可作为干预靶点以降低同情疲劳与倦怠的发生与负面影响，具体课程启示包括——① 预防与管理倦怠与二次创伤应激需分轨进行（后者"高度可治"，Figley 提出教育、脱敏、平衡创伤暴露、改善社会支持四类干预；亦有面向非人类动物照护者的"训练即治疗"研讨班，经 ProQOL 验证可提升同情满足、降低二次创伤应激但不改变倦怠）；② 增强共情（如虚拟患者训练、叙事医学训练可提升共情关怀）；③ 推广适应性应对、减少求助自我污名（在非评判环境中公开讨论创伤体验对自身幸福感的影响）；④ 引入正念训练（文献未见兽医界已实施的正念项目），正念亦可能经由自我调节提升自悯，对高完美主义特质者尤有价值。同情满足与倦怠的负相关提示同情满足可能有保护性，或在未倦怠时更能享受助人角色的积极面；有诊所工作经历的学生同情满足更高、倦怠更低，可能与角色清晰、同事关系与社会支持有关。

5. 局限

① 横断面设计无法确定因果，且仅单时点测量（Chigerwe 等显示美国兽医学生倦怠水平随学期波动，但其使用 Maslach Burnout Inventory 而非 ProQOL）；非定性设计，无法确知倦怠的具体成因（如巨大课业量）。② 回收率 31%，经纳入标准筛后降至 23%；缺失数据列表剔除可能引入估计偏倚。③ 各构念术语在研究者间缺乏统一（如共情的多向度体验），削弱与其他研究的可比性。④ 本样本情绪聚焦（α = .69）与功能失调应对（α = .66）信度可疑，相关结果需谨慎解读；控制变量与心理因素间的交互未显式检验。⑤ ProQOL 为面向人类患者/客户的助人职业设计，未涵盖"专业人员—客户—非人类患者"三元关系与常规安乐死可能的道德困扰；部分条目（如"我从帮助''人''中获得满足"）无法表达面对动物患者时的满足感，可能影响得分效度，未来或需为动物照护情境改良该工具。', '', '', '', '兽医职业健康,同情疲劳,职业倦怠,Burnout,二次创伤应激,同情满足,研究问题,方法（样本、工具、统计）,主要结果', 'informational', '澳洲兽医学生同情疲劳流行率及相关心理因素（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 研究问题', '1. 研究问题

兽医（veterinary surgeon）群体的自杀风险已知高于一般人群，但关于风险机制多为推测，实证研究很少。本结构化综述（structured review）旨在：汇总已发表的兽医自杀风险及影响数据，并与其他职业群体（医生、药剂师、牙医、护士、农场主等）及一般人群对比，梳理可能推高兽医职业自杀风险的机制。英国执业兽医约 16,000 人（RCVS 2007），群体小，自杀绝对数低，但相对风险高。

2. 方法

- 文献检索：检索 PubMed（含 MEDLINE）与 Google Scholar 中 1970 年以后发表的文献；检索词包括 veterinary 联合 depression、suicide、stress、burnout、distress、abuse、alcohol drinking、substance-related disorders、psychosocial working conditions、coping、psychiatry 等；辅以参考文献追溯、会议论文手工检索、Ovid Autoalert 邮件提醒及专家咨询；排除非英文文献。
- 综述性质：为提供全面结构化证据综述，纳入文献做了选择，非系统综述与 meta 分析。
- 指标解释：主要使用比例死亡比（Proportional Mortality Ratio, PMR）。PMR 比较某职业因特定死因死亡占该职业总死亡的比例与一般人群同死因比例；自杀 PMR=200 表示该职业自杀死亡期望比例为一般人群的 2 倍。
- 概念模型背景：应激-易感模型（stress-diathesis model, Mann and others 1999）；''Cry of Pain''模型（Williams and Pollock 2000），将自杀行为概念化为对失败感、被困感（entrapment）且无获救前景情境的回应；职业-自杀四成分模型（Stack 2001）：人口学构成、职业内在应激、既存精神疾病、机会因素（可及致死手段）。

3. 主要结果', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 风险量化数据', '3.1 风险量化数据

兽医自杀 PMR 约为一般人群的 4 倍、其他医疗职业的约 2 倍，PMR 在所有职业中持续名列前茅。英国 Kinlen 1983（1949-1953 年入组随访至 1975）报道男性兽医自杀死亡为同社会阶层全体男性的 2 倍。Charlton 1995 病例对照分析：相对死于自然原因，16-44 岁男兽医、45-64 岁男兽医、16-64 岁女兽医自杀风险分别升高 4.6、5.6 和 7.6 倍。

**表 1：英国男女兽医自杀 PMR 报道值**', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 风险量化数据 (2)', '| Reference | Study period | Region | Age range | PMR | 95% CI |
|---|---|---|---|---|---|
| **Males** | | | | | |
| Charlton and others (1993) | 1979-1990 | England and Wales | 16-64 | 364 | NR |
| Kelly and Bunting (1998) | 1982-1987 | England and Wales | 20-64 | 349 | 203-559 |
| Kelly and Bunting (1998) | 1991-1996 | England and Wales | 20-64 | 324 | 148-615 |
| Mellanby (2005) | 1979-1990 | England and Wales | 20-74 | 361 | 252-503 |
| Mellanby (2005) | 1991-2000 | England and Wales | 20-74 | 374 | 244-548 |
| Stark and others (2006) | 1981-1999 | Scotland | 16-45 | 293 | 80-749* |
| Stark and others (2006) | 1981-1999 | Scotland | 46-64 | 301 | 36-1088* |
| **Females** | | | | | |
| Kelly and Bunting (1998) | 1991-1996 | England and Wales | 20-59 | 500 | 136-1279 |
| Mellanby (2005) | 1979-1990 | England and Wales | 20-74 | 414 | 166-853 |
| Mellanby (2005) | 1991-2000 | England and Wales | 20-74 | 1240 | 446-2710 |
| Meltzer and others (2008) | 2001-2005 | England and Wales | 20-64 | 609 | 198-1422 |

*95% CI 包含 100 时该职业与一般人群差异无统计学意义（P<0.05）；NR=Not reported。

**表 2：1990-1992 年英格兰与威尔士高风险职业自杀相对危险度（RR，Charlton 1995）**', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 风险量化数据 (3)', '| 职业 | Men 16-44 RR (95% CI) | Men 45-64 RR (95% CI) | Women 16-64 RR (95% CI) |
|---|---|---|---|
| Veterinarians | 4.61 (1.49-14.25*) | 5.62 (1.60-19.74*) | 7.62 (1.04-55.94*) |
| Pharmacists | 1.15 (0.37-3.52) | 4.15 (2.00-8.58**) | 1.21 (0.27-5.35) |
| Dentists | 2.26 (0.93-5.47) | 5.19 (2.29-11.76**) | – |
| Farmers | 0.88 (0.60-1.30) | 1.93 (1.48-2.51**) | – |
| Medical practitioners | 1.50 (0.90-2.50) | 2.22 (1.35-3.65*) | 4.54 (2.54-8.13**) |

*P<0.01 **P<0.001。

其他国家：美国 1947-1977 死亡率研究（Blair and Hayes 1980, 1982），男性兽医自杀死亡升高 1.7 倍，小动物临床从业者升高 3.6 倍，最常见手段为巴比妥类药物自服；加州研究（Miller and Beaumont 1995）男女兽医自杀死亡率分别为一般人群的 2.5 倍与 5.9 倍，执业不满 30 年者更高；挪威 40 年职业自杀研究（Hem and others 2005）显示男兽医自杀率最高，为 44/10 万人年（95% CI 25 至——上限原文此处缺失），接近一般人群 2 倍；澳大利亚两个州合并自杀率 45/10 万人年（95% CI 25-82），约为相应州一般人群 4 倍（Fairnie 2005, Jones-Fairnie and others 2008），主要方式为药物自服（多为注射用巴比妥类），年龄分布不限。', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 自杀方式（表 3，英格兰与威尔士 1982-1996，Kelly and Bun', '3.2 自杀方式（表 3，英格兰与威尔士 1982-1996，Kelly and Bunting 1998）

| 群体 | 固体/液体物质中毒 | 气体中毒 | 缢死与窒息 | 溺水 | 枪支与爆炸物 | 其他 |
|---|---|---|---|---|---|---|
| Male veterinarians | 76 | 3 | 5 | 0 | 16 | 0 |
| All men | 20 | 27 | 27 | 6 | 5 | 16 |
| Female veterinarians | 89 | 11 | 0 | 0 | – | 0 |
| All women | 46 | 10 | 17 | 9 | – | 18 |

单位：百分比（四舍五入可能不足 100）。男兽医自杀中 1982-1996 年间以中毒方式自杀者至少半数使用巴比妥类（Kelly and others 1995）；枪支是男兽医第二常见方式（16%，一般人群男性 5%）。', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 可能的风险影响因素', '3.3 可能的风险影响因素

综述提出的可能机制跨越整个职业生涯：', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'informational', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 可能的风险影响因素 (2)', '- **入行个体特征与人格**：入学高学术要求聚集"优等生"，产生自我怀疑与"学术冒充"恐惧（impostor phenomenon, Zenner and others 2005）； socially prescribed perfectionism（社会规定完美主义）、自我批评、对错误的担忧与对行动的怀疑与自杀倾向相关（O''Connor 2007）；无望感、神经质、外向性可能影响自杀（Brezo and others 2006）；挪威六年纵向研究显示神经质与高尽责性是应激危险因素（Tyssen and others 2007）。
- **本科教育负性影响**：兽医课程学习量与进度是应激源；有推测认为入学仅凭学术成绩可能筛入低情绪智力（emotional intelligence, EI）者，但 EI 与学业成绩呈正相关，此推测证据不足。
- **工作应激源**：长时间工作、值班待命、专业失误、客户投诉与诉讼威胁；1/3 英国兽医毕业生两年内离开首份工作（Routly and others 2002）；超过 80% 英国兽医认为工作有压力（Robinson and Hooker 2006）；澳大利亚职业健康横断面研究中高度心理困扰者比例为一般人群 2 倍，预测因素包括年龄小于 35 岁与过去 12 个月使用非处方药（Fairnie 2005）。债务：2008 年英国兽医本科毕业年学生平均负债超过 £20,000，35% 报告经济问题为困难或严重（BVA & AVS 2008）。依赖客户收入的职业自杀率高出 1.5 倍以上（Labovitz and Hagedorn 1971）。
- **手段可及与知识**：兽医易于获得并熟悉致命药物，且受监管少于医生（Fishbain 1986）。
- **对死亡与安乐死的态度**：小规模研究中 93% 兽医从业人员对安乐死人持 favourable inclination（Kirwan 2005）；认知失调理论（cognitive dissonance）被用来解释安乐死态度可能降低对自杀的心理抑制。
- **自杀"传染"（contagion）**：小同业圈内自杀消息易通过社交网络传播，可能形成示范效应。
- **病耻感（stigma）**：阻碍求助；Agerbo and others 2001 发现曾因精神疾病住院者中，医生自杀风险较其他职业高近 4 倍；兽医中未见该队列病例，但可能存在双重效应。
- **精神疾病与物质滥用**：死于自杀的医生 86% 以上、护士 90% 以上有既存精神障碍（Hawton and others 2004, 2002）；英国兽医福利基金（VBF 2007）转介个案中物质滥用顺序为酒精、氯胺酮、苯二氮䓬类、阿片类、街头毒品（大麻、海洛因、可卡因、摇头丸）、氧化亚氮，约半数接受治疗者承认曾有自杀意念；Bartram and others 2009a,b,c 估计英国兽医焦虑与抑郁症状、12 个月自杀意念患病率均高于一般人群；Harling and others 2009 报告德国兽医饮酒量高于一般人群，女兽医危险饮酒流行率明显升高。
- **疫病事件**：2001 年英国口蹄疫（foot-and-mouth disease）期间，40% 受访农民向兽医寻求情感支持（仅次于家人朋友与其他农民）；Vet Helpline 同业帮助热线来电在疫情期间增加，至 2002 年中回落（Peck 2005, Peck and others 2002）。
- **投诉**：1991 年 1 月至 1993 年 12 月英格兰与威尔士死于自杀的开业医生中 71% 死前一年有重大工作问题，其中超过三分之一面临投诉（Hawton and others 2004）；RCVS 公众投诉逐年稳定增加，主类别为被指护理不当（RCVS 2007）。', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 可能的风险影响因素 (3)', '表 4 汇总了纳入综述的 30 项与兽医心理健康相关研究（横断面为主，另有病例系列、队列），此处节录关键条目，完整表见原文：', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'informational', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 可能的风险影响因素 (4)', '| Study | Design | 群体 | 地点 | 样本量 | 应答率(%) | 主要发现 |
|---|---|---|---|---|---|---|
| Bartram and others 2009a,b,c | Cross-sectional | 兽医 | UK | 1796 | 56 | 心理健康症状劣于一般人群；高心理需求、低支持 |
| Fairnie 2005 | Cross-sectional | 兽医 | Australia | 419 | 43 | 高度困扰比例为一般人群 2 倍；<35 岁最高 |
| Fogle and Abrahamson 1990 | Cross-sectional | 兽医 | UK | 167 | 56 | 动物死亡引发短期（76%）与长期（20%）情绪反应 |
| Fritschi and others 2009 | Cross-sectional | 兽医 | Australia | 2125 | 37 | 三分之一报告心理状态差，但困扰/焦虑/抑郁与其他职业相似 |
| Gardner and Hini 2006 | Cross-sectional | 兽医 | NZ | 927 | 49 | 小动物临床、女性、年轻兽医压力最高 |
| Hafen and others 2006, 2008 | Cohort | 学生 | USA | T1:93 T2:78 | T1:90 T2:84 | 三分之一一年级学生抑郁症状达临床水平 |
| Harling and others 2009 | Cross-sectional | 兽医 | Germany | 1136 | 53 | 压力主要来自工作量、下班待命与难缠客户；饮酒高 |
| Mellanby and Herrtage 2004 | Cross-sectional | 应届毕业者 | UK | 108 | 27 | 监督不足、支持少、失误多致 distress |
| Robinson and Hooker 2006 | Cross-sectional | 兽医 | UK | 9671 | 47 | 80% 认为工作有压力；仅 53% 会重选兽医职业 |
| Routly and others 2002 | Cross-sectional | 新毕业者/年长合伙人 | UK | 58/34 | 54/59 | 新人主要困难：待命、经济因素、手术能力不足 |
| Zenner and others 2005 | Cross-sectional | 学生 | USA | 61 | 80 | 心理特征与其他高成就人群相似 |', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 可能的风险影响因素 (5)', '其余条目（Anon 2002、Brown 1994、Connolly 2003、Fishbain 1986、Hansez and others 2008、Heath 2007、Herzog and others 1989、Hesketh and Shouksmith 1986、Johnson and others 2005、Kinsella 2006、Kirwan 2005、Kogan and others 2005、Martin and others 2003、Martin and Taunton 2005、Paul and Podberscek 2000、Phillips-Miller and others 2000/2001、Ptacek and others 2004、Reijula and others 2003、Serpell 2005、Trimpop and others 2000a,b、Williams and others 2005）的样本量、应答率与主要发现请照原文表 4 核对；其中 Williams and others 2005 一行地点原文记为 USA（正文表述为澳大利亚学生），两处不一致，照抄不改。', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'informational', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医外科医生自杀 · 结论与启示', '4. 结论与启示

作者提出一个解释兽医自杀风险的假设模型（Fig 1, Bartram and Baldwin 2008），与应激-易感、Cry of Pain 与职业差异模型相容，主要假设：风险受（1）入行者自身易感特征；（2）本科教育与工作应激导致的心理疾病；（3）安乐死实践与同业自杀知悉造成的自杀态度改变；（4）致死手段可及与知识，四方面交互作用影响。研究启示：尽管兽医自杀绝对数低，其 PMR 为所有职业中最高之一，值得专项研究；建议采用"生命历程"（life course, Gunnell and Lewis 2005）取向，在职业道路各阶段（入学特征—本科训练—就业—退休）识别早期危险因素与后续触发点，访谈有自杀意念者、检查死因裁判档案（coroners'' records）等；安乐死实践可能使死亡"常态化"、将死亡视为对棘手问题的理性解决，此假说至今未经严格检验。

5. 局限

原文指出的方法学局限：PMR 受其他死因频率影响，高 PMR 可能部分反映总体死亡率低；职业间自杀风险比较受社会人口学因素混杂；国际比较因各国自杀分类与记录差异及测量指标不一而受限（Andriessen 2006）；本文为结构化综述而非系统综述/meta 分析；兽医自杀绝对数小，统计估计不稳；本综述将各类自杀相关行为的危险因素统摄考虑；Fishbain 1986 仅 4 例病例系列，结论须极其谨慎解读；Hafen 等结果能否外推不明；关于安乐死态度与自杀关系的比较受研究方法不同混杂。原文 Fig 1 模型示意图在 PDF 抽取中文字顺序错乱，此处不作还原（原文此处缺失）。', '', '', '', '兽医职业健康,自杀,兽医职业,比例死亡比（PMR）,相对危险度（RR）,手段可及性,研究问题,方法,主要结果', 'caution', '兽医外科医生自杀：风险升高的可能影响因素结构化综述', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生应对策略与寻求心理帮助污名的横断面分析 · 研究问题', '1. 研究问题

兽医教育带来高强度学业应激源（学习量与进度、考核要求、临床/学习/时间管理技能欠缺、与同学比较的担忧、伦理困境），也有非学业应激源（关系与家庭问题、个人健康、经济压力），可导致压力、焦虑、抑郁等心理健康问题。背景数据：2016 年英国兽医学生调查中 27% 受访者（n=1480）报告在读期间患抑郁，为全国平均水平的 10 倍以上；兽医学生中亦记录到自杀意念。求助可能受精神疾病污名（stigma）阻碍——包括感知污名（perceived stigma）与内化后的自我污名（self-stigma）。研究目的与问题：

- 兽医学生报告哪些应对策略（coping strategies）？男女兽医学生在应对策略上有何差异？
- 不同应对方式与自我报告的自我污名（self-stigma）之间存在何种关系？

应对策略按 Carver 的分类为三类：情绪聚焦（emotion-focused，如寻求情感支持、接受、积极重新评价、宗教、幽默）、问题聚焦（problem-focused，如计划、寻求工具性支持、主动应对）与功能不良（dysfunctional，如否认、自我分散、发泄、自我责备、物质使用、行为退出）。', '', '', '', '兽医职业健康,兽医学生,应对策略,Brief COPE,情绪聚焦,问题聚焦,研究问题,方法,主要结果', 'informational', '兽医学生应对策略与寻求心理帮助污名的横断面分析', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生应对策略与寻求心理帮助污名的横断面分析 · 方法', '2. 方法

- **设计**：横断面（cross-sectional）匿名在线问卷，使用 SurveyMonkey。
- **参与者与招募**：澳大利亚 7 所兽医学院中的 6 所；纳入标准为已完成至少两周临床院外实习（extramural placement）或曾在/正在兽医诊所工作；通过 Facebook 发布问卷链接，并由各校行政人员向符合条件学生转发邮件。数据收集约六周，从 2015 年 7 月底至 9 月初（原句末尾年份在抽取中缺失）。共 828 名兽医学生受邀。
- **结局变量量表**：寻求心理帮助自我污名量表（Self-Stigma of Seeking Help Scale）10 条目，5 点 Likert 计分（1=strongly disagree 至 5=strongly agree），总分 10-50；第 2、4、5、7、9 条为正向表述，分析前反向计分；原文献内部一致性 α=0.91。示例条目："It would make me feel inferior to ask a therapist for help" 与 "I would feel worse about myself if I could not solve my own problems."
- **预测变量量表**：简化应对方式量表（Brief Coping Orientation to Problems Experienced, Brief COPE）28 条目、14 个应对亚量表，每条 4 点计分（1=I haven''t been doing this at all 至 4=I''ve been doing this a lot），亚量表总分为所含条目之和，范围 2-8。原文献各亚量表内部一致性：self-distraction α=0.71、active coping α=0.68、denial α=0.54、substance use α=0.90、use of emotional support α=0.71、use of instrumental support α=0.64、behavioural disengagement α=0.65、venting α=0.50、positive reframing α=0.64、planning α=0.73、humour α=0.73、acceptance α=0.57、religion α=0.82、self-blame α=0.69。
- **分析**：SPSS Statistics V.24；检查正态性、离群值与假设；religion 与 substance use 正偏态，对数变换后与原始分数比较无显著差异，保留原始分数；Shapiro-Wilk 检验不显著；对 10 个亚量表做男女独立样本 t 检验；再采用自定义向后逐步（backward）单变量广义线性模型，主效应含年龄、性别及 self-blame、planning、active coping、positive reframing、emotional support、instrumental support、humour、religion、substance use 和全部与性别的二阶交互，仅保留 P<0.05 的交互项，CI 设为 95%。', '', '', '', '兽医职业健康,兽医学生,应对策略,Brief COPE,情绪聚焦,问题聚焦,研究问题,方法,主要结果', 'informational', '兽医学生应对策略与寻求心理帮助污名的横断面分析', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生应对策略与寻求心理帮助污名的横断面分析 · 主要结果', '3. 主要结果

**样本**：255/828 名学生完成问卷（31%），其中 188/828（23%）符合纳入标准并进入统计分析；女性占 82%（F=155, M=33），年龄 18-48 岁（M=24.4, sd=4.1）。

**表 1：九个进入分析亚量表的描述统计与 Cronbach''s α**

| Scale | n | Mean | sd | Range (Min-Max) | Cronbach''s α | Interpretation |
|---|---|---|---|---|---|---|
| Emotional support | 192 | 5.58 | 1.65 | 2.00-8.00 | 0.80 | Good |
| Positive reframing | 193 | 5.19 | 1.59 | 2.00-8.00 | 0.80 | Good |
| Humour | 192 | 4.92 | 1.89 | 2.00-8.00 | 0.88 | Good |
| Religion | 193 | 2.93 | 1.65 | 2.00-8.00 | 0.90 | Excellent |
| Planning | 192 | 5.76 | 1.41 | 2.00-8.00 | 0.72 | Acceptable |
| Active coping | 191 | 5.70 | 1.41 | 2.00-8.00 | 0.76 | Acceptable |
| Instrumental support | 192 | 5.35 | 1.76 | 2.00-8.00 | 0.81 | Good |
| Self-blame | 193 | 5.61 | 1.62 | 2.00-8.00 | 0.72 | Acceptable |
| Substance use | 193 | 3.04 | 1.55 | 2.00-8.00 | 0.91 | Excellent |

本样本中 denial（0.42）与 self-distraction（0.45）信度不可接受，acceptance（0.57）与 behavioural disengagement（0.60）为差，venting（0.63）为可疑；这些亚量表未纳入广义线性模型与 t 检验。总体上问题聚焦策略使用最多（planning 与 active coping 值高），情绪聚焦中最常用为 emotional support、最少为 religion；功能不良策略中最常用为 self-blame。', '', '', '', '兽医职业健康,兽医学生,应对策略,Brief COPE,情绪聚焦,问题聚焦,研究问题,方法,主要结果', 'informational', '兽医学生应对策略与寻求心理帮助污名的横断面分析', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生应对策略与寻求心理帮助污名的横断面分析 · 主要结果 (2)', '**男女差异（t 检验）**：emotional support（男 M=4.96 sd=1.33 对女 M=5.71 sd=1.69；t(190)=−2.37, P=0.019）、instrumental support（男 4.52 sd=1.54 对女 5.53 sd=1.76；t(190)=−3.07, P=0.002）、humour（男 5.79 sd=1.75 对女 4.74 sd=1.88；t(190)=2.96, P=0.003）。即女性更多使用工具性与情感支持，男性更多使用幽默。

**表 2：自我污名最终回归模型**

| Variable | B | df | F | P value | 95% CI LL | 95% CI UL |
|---|---|---|---|---|---|---|
| Instrumental support | −1.310 | 1 | 21.302 | 0.001 | −1.870 | −0.750 |
| Humour | −0.287 | 1 | 2.731 | 0.100 | −0.850 | 0.276 |
| Self-blame | 0.941 | 1 | 9.721 | 0.002 | 0.345 | 1.536 |
| Gender | −8.771 | 1 | 4.252 | 0.041 | −17.163 | −0.378 |
| Gender and humour | 1.779 | 1 | 6.091 | 0.015 | 0.357 | 3.202 |

模型整体：三个主预测因子与一个二阶交互解释 16% 方差（R²=0.161, F(5, 1)=8.197, P=0.001；原文 F 值自由度排版如此）。自我污名由 self-blame（B=0.941, P=0.002）、instrumental support（B=−1.310, P=0.001）与性别（B=−8.771, P=0.041）预测：自我责备越多、工具性支持越少、男性，自我污名越高。性别×幽默交互（B=1.779, P=0.015）显示男性中幽默使用越多自我污名越高（男性斜率 1.492，即幽默每增 1 单位自我污名分增 1.492），女性中幽默与自我污名无关。', '', '', '', '兽医职业健康,兽医学生,应对策略,Brief COPE,情绪聚焦,问题聚焦,研究问题,方法,主要结果', 'informational', '兽医学生应对策略与寻求心理帮助污名的横断面分析', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('兽医学生应对策略与寻求心理帮助污名的横断面分析 · 结论与启示', '4. 结论与启示

- 男性更多自我污名可能与性别角色冲突（gender role conflict）有关：男性气质社会化为坚忍独立，求助与自我形象冲突。
- 幽默本是积极情绪聚焦策略，但在男性中过度依赖幽默与更高自我污名相关，可能成为未满足心理求助需求的标志；应告知教师、导师与同伴。
- 自我责备是第四常用策略且预测自我污名；而失误在兽医执业中常见（近 80% 新毕业兽医承认发生过导致不良事件的失误，Mellanby and Herrtage 2004），自我责备与自我批评可能放大失误的负性体验，并与完美主义相关（美国大学生近 30 年元分析显示完美主义上升）。
- 建议方向：教授正念自我关怀（mindful self-compassion）策略以建立复原力并减少污名；干预可按教育、挑战关于精神疾病后果的信念、社会接触（social contact，如第一人称叙事）与提供服务路径设计；学生层面可用同伴导师/''buddy'' 项目、学生社团心理健康活动、资深兽医公开谈求助的讲座、与心理师/咨询师的工作坊；执业层面有导师制、同伴支持/督导、会议主题活动与主题继续教育。将自我关怀纳入职业义务有助去污名：澳大利亚兽医协会（AVA）Draft Code of Professional Conduct 已含自我关怀与关怀同事条款；世界医师协会（WMA）日内瓦宣言要求医生承诺"I will attend to my own health, wellbeing and abilities in order to provide care of the highest standard."。保险机构可通过修改惩罚求助行为的政策减少污名。
- 原文相关背景数据：英国 2013 年研究（n=507）超过三分之二受访者报告担心他人知晓其精神健康问题的自我污名，不到四分之一认同"People are generally caring and sympathetic to people with mental health problems."；英国某兽医学院心理咨询服务试用中，学生因缺乏匿名性与感知污名而不愿在校区内求助。

5. 局限

原文明确列出：横断面设计与统计分析不能判定因果；尽管样本性别分布与澳大利亚兽医学生总体大致相当，但应答率低（31% 完成、23% 符合纳入），结果外推受限；存在无应答偏倚（未应答者的应对技能无从得知，参与动机也可能两极）；Brief COPE 部分亚量表内部一致性低，故未能完整分析澳大利亚兽医学生应对技能的全部范围（但 venting、acceptance、denial 的低信度与量表原始开发报告一致）。', '', '', '', '兽医职业健康,兽医学生,应对策略,Brief COPE,情绪聚焦,问题聚焦,研究问题,方法,主要结果', 'caution', '兽医学生应对策略与寻求心理帮助污名的横断面分析', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('AVA 毕业生导师计划 · 项目背景', '1. 项目背景

澳大利亚对毕业兽医心理健康的支持故事始于（原文"began in"后的年份此处缺失）。直接触发事件是一位新毕业兽医的悲剧性自杀，AVA（西澳分部，WA）由此创立毕业生支持计划（AVA (WA) Graduate Support Scheme），由 AVA (WA) 委员会成员作出重要贡献。设立的动机是：家人朋友虽然是新毕业者的良好支持来源，但通常不了解执业的复杂性；同事可能不愿介入会影响自身职位的问题；新毕业生可能感到孤立，或不愿与身边最亲近的人讨论问题——导师（mentor）恰可在此发挥作用。

最初的运作方式：将默多克大学兽医学院（Murdoch University Veterinary School）每一位毕业生指派给一位经验丰富的志愿从业者，在其入行第一年担任导师。早期发展中，Dr Paul Davey 负责协调并完善该计划，是它的推动者。其后改进包括：更早指派导师（9 月在 AVA Trade Fair 上完成）、高效的邮件沟通系统、毕业前增加毕业生与导师的社交机会、向导师提供基础支持资源。2011-13 年成功获得西澳政府 Suicide Awareness Strategy 通过 OneLife 项目提供的资金，显著增强了对导师的进一步培训与支持能力；该项目由另一位西澳兽医 Dr Brian McErlean 管理。兽医委员会（Veterinary Surgeons Board, WA）、默多克大学与 AVA 密切协作，确保 AVA (WA) 毕业生导师计划与其他提升职业韧性与新毕业生职业满意度的策略和资源纵向衔接。Taverner 报告（AVA 委托研究新毕业生问题）强调这种纵向衔接的重要性，原文引文："Transitioning to the workforce from university is a very challenging time for, most, if not all new graduates. The nurturing of the veterinarians of tomorrow needs to start earlier in their career – while they are still being educated. Most new graduates, once they find a job, feel thrown in at the deep end and while they recognise that support is available, sometimes it is too late."

导师制（mentoring）定义：将两人——导师与学员（mentee）——配对，促进职业与个人技能和经验的分享，并助力职业发展；通过把经验较少的兽医与同业中经验较多、通常工作领域相近的成员结成一个结构化且相互信任的关系，提供指引、支持与鼓励。原文称其后 22 年（自 Dr Gavin Baraugh 自杀的创伤与悲伤起算，原文表述如此），行业对影响兽医心理健康的因素了解更多，重心已从自杀预防（suicide prevention）转向更有针对性的心理健康与个人发展支持。', '', '', '', '兽医职业健康,导师制,mentoring,毕业生支持计划,AVA,新毕业兽医,项目背景,项目结构与要求,申请与参与方式', 'informational', 'AVA 毕业生导师计划（AVA Graduate Mentoring Program）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('AVA 毕业生导师计划 · 项目结构与要求', '2. 项目结构与要求

- **性质与周期**：AVA 导师计划是既定职业人士与兽医行业新人之间为期 12 个月的承诺（12 month commitment）。
- **目标**：以有经验的兽医专业人士支持新毕业生平稳过渡进入行业（transition into the profession），助其发挥全部潜能、乐于从业，发展和维持让兽医满意的职业生涯。
- **匹配**：导师与学员根据申请资料配对；学员也可申请由其认识的导师担任。
- **三个必到活动**：导师与学员须参加 Program Launch（项目启动）、Mid-Program Review（期中回顾）、Program Close（项目收尾）三次活动，部分为面对面会议，部分以网络研讨会（webinar）进行。
- **联络频率**：项目期间导师与学员须至少每月联络一次。
- **培训**：学员及首次担任导师者须完成 Art of Mentoring 在线培训，为其导师关系做准备；培训约一小时完成；参加培训项目以承诺完成该培训为条件。
- **保密（confidentiality）**：讨论涉及临床材料时难以避免客户保密问题，双方都须意识到互动可能具有保密性质；仅在对方存在身体或精神伤害风险、或涉及不道德/违法事项时，泄密才被允许（原文表述：Breaches in confidentiality are only supported if the other party is at risk of harm; physical or mental wellbeing, and in the case of something unethical or illegal）。
- **关系不顺时**：任何原因导致导师关系不畅时，须尽快处理问题并尽快达成双方可接受的解决方案。
- **转介**：导师可能遇到无法为学员彻底解决的问题，关键技能之一是识别自身能力边界，不做超出资质之事；导师须能识别学员何时需要专业帮助（心理健康或其他个人/职业问题）并推荐合适的专业帮助。
- **导师角色**（原文列点）：支持过渡与融入兽医生活（support transition and help assimilation into veterinary life）；作为信息与洞见来源；就职业发展或实现职业目标的策略提出相关选项；识别学员是否需要专业帮助处理心理健康或其他个人/职业问题；推荐合适的专业帮助；推荐改进特定技能的资源；帮助学员解决其工作中的职业挑战；讨论职业伦理问题；讨论工作场所相关问题及处理选项（如薪酬与条件、人际关系）；就应对困难客户关系提供建议。
- **导师所需技能**（原文列点）：理解不同导师风格；真诚帮助学员顺利过渡进入职业生活；能协商时间投入与可及性；能识别学员的需求与目标并促进、支持、鼓励其达成；积极倾听；以诚实开放态度提供不评判的反馈与建议；掌握多种问题解决方法；知道何时将学员转介给健康专业人士。
- **有效性**：全国计划分析的一个有趣结果是导师的高留存率与高满意度，原文认为这可能说明导师计划在领导力发展层面有效。', '', '', '', '兽医职业健康,导师制,mentoring,毕业生支持计划,AVA,新毕业兽医,项目背景,项目结构与要求,申请与参与方式', 'informational', 'AVA 毕业生导师计划（AVA Graduate Mentoring Program）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('AVA 毕业生导师计划 · 申请与参与方式', '3. 申请与参与方式

- **学员资格**：在兽医专业最后一年（尚未开始工作）即可加入；项目现亦欢迎入行第 2、3、4 年的任何 AVA 毕业会员申请成为学员。
- **导师资格**：须在行业内至少有三年经验，并具备 AVA 会员身份；任何非会员希望参加者按个案审查（reviewed on an individual basis）。
- **管理机构**：AVA 全国毕业生导师计划是 AVA Graduate and Student Program 的组成部分，当时由 Monika Cole 管理（原文称其为项目的优秀代言人）。
- **全国项目规模**（原文表格，逐年队列，Oct 起止；偶数编号队列行在原文抽取中缺失，原文此处缺失）：

| Year | Uni | Graduates | Mentors |
|---|---|---|---|
| Cohort 1: Oct2015-Oct2016 | ALL | 249 | 247 |
| Cohort 3: Oct2016-Oct2017 | ALL | 196 | 247 |
| Cohort 5: Oct2017-Oct2018 | ALL | 216 | 261 |
| Cohort 7: Oct2018-Oct2019 | ALL | 190 | 287 |
| Total graduates through the program Oct 2015 – Oct 2019 | | 851 | |

原文另注明该 PDF 第 4 页为图片页，可能存在文字抽取缺失。', '', '', '', '兽医职业健康,导师制,mentoring,毕业生支持计划,AVA,新毕业兽医,项目背景,项目结构与要求,申请与参与方式', 'informational', 'AVA 毕业生导师计划（AVA Graduate Mentoring Program）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('AVA 毕业生导师计划 · 可迁移的做法', '4. 可迁移的做法

（以下均基于原文事实归纳，不引入外部内容。）

- **以真实悲剧事件驱动制度建设**：由一起新毕业生自杀事件催生同业学会分会层面的支持计划，随后制度化、全国化。
- **前置介入点**：学员在毕业前（最后一年）即配对导师，并在离校前的展会（AVA Trade Fair）上完成指派、增加毕业前社交，回应"支持常在需要时已太晚"的过渡期痛点。
- **最低结构保证**：12 个月承诺 + 至少每月一次联络 + 三次强制节点活动（启动/期中/收尾），兼用面对面与 webinar，兼顾约束与可及性。
- **低成本上岗培训**：约 1 小时的 Art of Mentoring 在线课程，作为入学/担任导师的先决条件。
- **清晰的伦理边界**：明示保密原则及例外（伤害风险、不道德或违法），并把"识别自身局限、及时转介"列为导师核心技能，导师定位为非临床支持者而非治疗者。
- **退出与纠错机制**：关系不匹配时 prompt 处理、寻找双方可接受方案。
- **纵向衔接（vertical integration）**：与院校（Murdoch University）、监管机构（Veterinary Surgeons Board）及行业组织协作，嵌入更大的职业韧性体系。
- **资金与赞助模式**：政府 Suicide Awareness Strategy 专项基金（OneLife, 2011-13）支持导师培训；全国期由 Guild、Hills、Petsure、Royal Canin、Provet、Virbac 赞助，原文称赞助使效果评估机会更好（此前 WA 期规模与资源不足以评估效果）。
- **关注导师侧收益**：以导师高留存与高满意作为项目在领导力发展层面有效的信号。', '', '', '', '兽医职业健康,导师制,mentoring,毕业生支持计划,AVA,新毕业兽医,项目背景,项目结构与要求,申请与参与方式', 'informational', 'AVA 毕业生导师计划（AVA Graduate Mentoring Program）', 'official', 'https://wsava.org/global-guidelines/professional-wellness-guidelines/', 'approved'),
('Renal Standardization Guidel · 第 1 段', 'Renal Standardization Guidelines（肾病数据标准化指南）

板块页面正文（原文）

Guidelines

Renal Standardization

Executive Summary

The Renal Standardization Project aimed to improve the diagnosis and, as a result, the clinical outcomes of canine patients with glomerular diseases.

Resources

- [World Small Animal Veterinary Association Renal Pathology Initiative: Classification of Glomerular Diseases in Dogs](https://journals.sagepub.com/doi/full/10.1177/0300985815579996)

Downloads

WSAVA Renal Standardization Brochure

[Download](https://wsava.org/wp-content/uploads/2020/01/Renal-Standardization-Brochure.pdf)

本板块文档清单

共 1 份 PDF，按「英文 + 中文」策略收录 1 份，跳过小语种译本 0 份。

已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Renal Standardization Brochure | EN |  | 2 | 0 | [raw_extracts/Renal-Standardization-Brochure.md](raw_extracts/Renal-Standardization-Brochure.md) |

外部引用（期刊论文 / 相关机构，未抓取正文）

- World Small Animal Veterinary Association Renal Pathology Initiative: Classification of Glomerular Diseases in Dogs — <https://journals.sagepub.com/doi/full/10.1177/0300985815579996>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', 'dog', '', '', '肾病,板块页面正文（原文）,Guidelines', 'informational', 'Renal Standardization Guidelines', 'official', 'https://wsava.org/global-guidelines/renal-standardization-guidelines/', 'approved'),
('WSAVA 肾病数据标准化项目 · > **⚠ 内容完整性警示（必读）**', '> **⚠ 内容完整性警示（必读）**
> 本板块原始手册 `Renal Standardization Brochure`（PDF 2 页）为**扫描/图片版，未能抽取正文，需 OCR 补全**。
> **以下所有内容仅基于 WSAVA 板块页面的执行摘要（Executive Summary）与外部论文标题**，不包含手册正文中的任何标准细节。
> 引用本稿时，凡涉及肾病理分类、分期、分级、命名阈值等实质标准，一律视为**原文此处缺失**，禁止以本稿作答。

1. 板块页面执行摘要（唯一实质正文）

页面正文层级为 `Guidelines` → `Renal Standardization` → `Executive Summary`。英文原文逐字如下：

> The Renal Standardization Project aimed to improve the diagnosis and, as a result, the clinical outcomes of canine patients with glomerular diseases.

对应拆解：

| 原文要素 | 中文 | 可确认的信息 | 不可确认的信息 |
|---|---|---|---|
| The Renal Standardization Project | 肾病标准化项目 | 项目主体名称 | 项目牵头委员会与成员名单（页面未列） |
| aimed to improve the diagnosis | 旨在改善**诊断** | 目标是诊断环节的标准化 | 诊断指标、方法学（页面未列） |
| and, as a result, the clinical outcomes | 并由此改善**临床结局** | 标准化与结局改善的因果表述 | 结局指标与证据（页面未列） |
| of canine patients | 针对**犬**患者 | 物种范围只提犬 | 猫是否纳入（页面正文未提猫） |
| with glomerular diseases | 患**肾小球疾病**者 | 疾病范围为 glomerular diseases | 具体分类清单（页面正文未给） |

页面在 `## Resources` 下**仅列出 1 条外链**，在 `### Downloads` 下**仅给出 1 份手册**（标题 `WSAVA Renal Standardization Brochure`，链接文字 `Download`）。**页面没有分期表、分级标准、术语表或任何数值内容。**', '', '', '', '肾病,肾病标准化,肾病数据标准化,肾病理学倡议,肾小球疾病,canine,板块页面执行摘要（唯一实质正文）,外部论文（仅标题与链接，正文未抓取）,手册抽取状态与技术记录', 'informational', 'WSAVA 肾病数据标准化项目（执行摘要与资料状态）', 'official', 'https://wsava.org/global-guidelines/renal-standardization-guidelines/', 'approved'),
('WSAVA 肾病数据标准化项目 · 外部论文（仅标题与链接，正文未抓取）', '2. 外部论文（仅标题与链接，正文未抓取）

板块页面 `Resources` 列出的唯一学术资源，标题逐字照抄：

| 项目 | 内容 |
|---|---|
| 标题（原文） | World Small Animal Veterinary Association Renal Pathology Initiative: Classification of Glomerular Diseases in Dogs |
| 标题中文对照 | WSAVA 肾病理学倡议：犬肾小球疾病的分类 |
| 链接 | https://journals.sagepub.com/doi/full/10.1177/0300985815579996 |
| DOI（照抄） | 10.1177/0300985815579996 |
| 抓取状态 | 知识库文档清单明确标注为「外部引用（期刊论文 / 相关机构，未抓取正文）」 |
| 页面未提供的信息 | 作者名单、期刊名称、发表年份与卷期页码（**原文此处缺失**） |

从标题本身可确认的两点（**仅此两点，不作进一步展开**）：该论文是 **WSAVA Renal Pathology Initiative（肾病理学倡议）** 的成果；主题是 **Classification of Glomerular Diseases in Dogs（犬肾小球疾病的分类）**。**分类的具体类别、层级与诊断标准条文均未抓取，原文此处缺失。**', 'dog', '', '', '肾病,肾病标准化,肾病数据标准化,肾病理学倡议,肾小球疾病,canine,板块页面执行摘要（唯一实质正文）,外部论文（仅标题与链接，正文未抓取）,手册抽取状态与技术记录', 'informational', 'WSAVA 肾病数据标准化项目（执行摘要与资料状态）', 'official', 'https://wsava.org/global-guidelines/renal-standardization-guidelines/', 'approved'),
('WSAVA 肾病数据标准化项目 · 手册抽取状态与技术记录', '3. 手册抽取状态与技术记录

`raw_extracts/Renal-Standardization-Brochure.md` 的 frontmatter 记录了失败原因，逐字照抄：

| 字段 | 值 |
|---|---|
| title | Renal Standardization Brochure |
| source_url | https://wsava.org/wp-content/uploads/2020/01/Renal-Standardization-Brochure.pdf |
| local_pdf | pdf/Renal-Standardization-Brochure.pdf |
| language | en |
| pdf_pages | 2 |
| pdf_meta_title | 投影片 1 |
| **extraction_chars** | **0** |
| **needs_ocr** | **True** |
| **image_only_pages** | **[1, 2]** |
| extractor | pymupdf-block-heuristic |

解读（只依据上表字段）：

- **两页全部为纯图片页**（`image_only_pages: [1, 2]`），文本层为空，故抽取字符数为 0；`needs_ocr: True` 已被爬虫标记。
- `pdf_meta_title` 为「投影片 1」，说明该 PDF 由幻灯片导出，正文以图像形式嵌入。
- 交接说明中提到的「抽取只有 135 字符」与文件实际记录不符：**该抽取稿的正文区为空，frontmatter 记 `extraction_chars: 0`**；本稿以文件实际内容为准。
- 板块文档清单表格中该文档行的「抽取字符」亦记为 **0**，页数 **2**，语言 EN，链接指向 `raw_extracts/Renal-Standardization-Brochure.md`。

4. 本稿能回答与不能回答的边界

| 可以据此稿回答 | 不能据此稿回答（需 OCR 手册正文或论文全文） |
|---|---|
| 该标准化项目的目标陈述原文 | 手册内任何具体内容（全部缺失） |
| 项目涉及物种（犬）与疾病大类（肾小球疾病） | 肾小球疾病的分类清单与各型定义 |
| 权威论文的确切标题与 DOI 链接 | 作者、期刊、年份、卷期 |
| 资料的抓取/抽取失败状态 | 分期（stage）与分级（grade）标准 |
| 板块页面的更新时间（2024-05-02）与抓取时间（2026-10-19） | 活检、染色、判读流程与术语规范 |
| 手册的下载链接 | 猫肾病是否纳入（页面正文只写 canine） |', '', '', '', '肾病,肾病标准化,肾病数据标准化,肾病理学倡议,肾小球疾病,canine,板块页面执行摘要（唯一实质正文）,外部论文（仅标题与链接，正文未抓取）,手册抽取状态与技术记录', 'informational', 'WSAVA 肾病数据标准化项目（执行摘要与资料状态）', 'official', 'https://wsava.org/global-guidelines/renal-standardization-guidelines/', 'approved'),
('WSAVA 肾病数据标准化项目 · 板块页面元数据与收录状态（逐字）', '5. 板块页面元数据与收录状态（逐字）

| 字段 | 值 |
|---|---|
| section | renal-standardization-guidelines |
| section_zh | 肾病数据标准化指南 |
| title | Renal Standardization Guidelines |
| source_url | https://wsava.org/global-guidelines/renal-standardization-guidelines/ |
| page_id | 554 |
| published | 2024-03-26T18:27:41 |
| updated | 2024-05-02T14:26:57 |
| language | en |
| crawled_at | 2026-10-19T10:21:50Z |

板块文档清单原文（逐字）：`共 1 份 PDF，按「英文 + 中文」策略收录 1 份，跳过小语种译本 0 份。`——即**本板块是唯一真正尝试收录了 PDF 的板块，但收录失败于图片版抽取**。「已收录」表格数据行为：`Renal Standardization Brochure | EN | （版本说明为空） | 2 | 0 | raw_extracts/Renal-Standardization-Brochure.md`。「外部引用（期刊论文 / 相关机构，未抓取正文）」下仅第 2 节那一条论文链接。页面 Downloads 小节的标题为 `WSAVA Renal Standardization Brochure`，链接文字为 `Download`。

页面版权声明（逐字）：`内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。`', '', '', '', '肾病,肾病标准化,肾病数据标准化,肾病理学倡议,肾小球疾病,canine,板块页面执行摘要（唯一实质正文）,外部论文（仅标题与链接，正文未抓取）,手册抽取状态与技术记录', 'informational', 'WSAVA 肾病数据标准化项目（执行摘要与资料状态）', 'official', 'https://wsava.org/global-guidelines/renal-standardization-guidelines/', 'approved'),
('WSAVA 肾病数据标准化项目 · 常见提问与当前可答复状态', '6. 常见提问与当前可答复状态

| 使用者可能提问 | 当前答复 | 依据 |
|---|---|---|
| WSAVA 做肾标准化是为了什么？ | 可答：改善犬肾小球疾病患者的诊断，并由此改善临床结局 | 第 1 节执行摘要原句 |
| 这个标准适用于哪些动物？ | 可答：页面正文只写 canine（犬）；是否涵盖猫，页面未提 | 第 1 节 |
| 针对哪类肾病？ | 可答：glomerular diseases（肾小球疾病） | 第 1 节 |
| 犬肾小球疾病被分成哪几类？ | **不可答：原文此处缺失**（仅在论文标题中出现 Classification 一词） | 第 2 节 |
| 分期的级别名称与判定阈值是什么？ | **不可答：原文此处缺失**（页面与抽取稿均无任何级别或数值） | 第 1、3 节 |
| 活检取材与判读流程怎么规定？ | **不可答：原文此处缺失** | 第 4 节 |
| 手册里还有什么内容？ | **不可答：手册 2 页全为图片，需 OCR 补全** | 第 3 节 |
| 论文发表在哪个期刊、哪一年？ | **不可答：页面只给标题与 DOI，未标期刊/年份/作者** | 第 2 节 |

7. 后续补全工作清单（面向知识库维护，不涉及医学结论）

1. 对 `pdf/Renal-Standardization-Brochure.pdf`（2 页，均为图片页）执行 OCR，产出物写回 `raw_extracts/Renal-Standardization-Brochure.md`，并将 frontmatter 的 `needs_ocr` 状态复核。
2. 如需要分类标准正文，另行获取第 2 节论文的全文（页面给出的是 `.../doi/full/...` 链接）。
3. OCR 或全文到手后，本稿第 1、2 节的「原文此处缺失」条目应逐条替换为照抄的正文内容；在此之前**不得由整理者自行补写**。

延伸资料

板块页面列出的外部资源（**正文未抓取，仅登记链接**）：

- World Small Animal Veterinary Association Renal Pathology Initiative: Classification of Glomerular Diseases in Dogs — <https://journals.sagepub.com/doi/full/10.1177/0300985815579996>
- WSAVA Renal Standardization Brochure（Download）— <https://wsava.org/wp-content/uploads/2020/01/Renal-Standardization-Brochure.pdf>', '', '', '', '肾病,肾病标准化,肾病数据标准化,肾病理学倡议,肾小球疾病,canine,板块页面执行摘要（唯一实质正文）,外部论文（仅标题与链接，正文未抓取）,手册抽取状态与技术记录', 'informational', 'WSAVA 肾病数据标准化项目（执行摘要与资料状态）', 'official', 'https://wsava.org/global-guidelines/renal-standardization-guidelines/', 'approved'),
('Reproduction Control Guideli · 第 1 段', 'Reproduction Control Guidelines（犬猫生殖控制指南）

板块页面正文（原文）

Guidelines

Reproduction Control

Executive Summary

The WSAVA guidelines for the control of reproduction in dogs and cats aim to help WSAVA members make science-based choices for the management of reproduction in their patients, while safeguarding animal welfare and supporting the human-companion animal bond. Included are discussions of current practice, together with explanations of newer approaches, both surgical and non-surgical.  They also explore the health benefits and drawbacks of each method and explore ethical questions.

Download the complete [Executive Summary.](https://wsava.org/wp-content/uploads/2024/06/Executive-Summary.pdf)', '', '', '', '生殖,板块页面正文（原文）,Guidelines,Reproduction Control', 'informational', 'Reproduction Control Guidelines', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('Reproduction Control Guideli · Resources', 'Resources

- [2024 Guidelines for the Control of Reproduction in Dogs and Cats.](https://wsava.org/wp-content/uploads/2024/05/J-of-Small-Animal-Practice-2024-Romagnoli-WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-and-cats.pdf)
- [Executive Summary](https://wsava.org/wp-content/uploads/2024/06/Executive-Summary.pdf)

- **NEW:** [2024 Guidelines for the Control of Reproduction in Dogs and Cats **in Japanese**](https://wsava.org/wp-content/uploads/2025/09/WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-in-Japanese.pdf)
- **NEW:** [Executive Summary **in Japanese**](https://wsava.org/wp-content/uploads/2025/09/Executive-Summary-in-Japnanese-1.pdf)
- [2024 Guidelines for the Control of Reproduction in Dogs and Cats **in Chinese**](https://wsava.org/wp-content/uploads/2025/04/（已压缩）附件：《WSAVA犬猫生殖管理指南》（中文版）250422-2-175.pdf)

*WSAVA understands that the recently launched guidelines for the control of reproduction in dogs and cats has prompted discussions within many communities, and we would like to assure members of these communities that WSAVA is committed to providing open channels for feedback. Anyone wishing to provide feedback on the reproduction guidelines, or any other aspect of WSAVA’s work, is encouraged to send their thoughts to [feedback@wsava.org](mailto:feedback@wsava.org "Reproduction Guidelines"). All feedback will be reviewed with a view to identifying common themes, and it is WSAVA’s wholehearted intention to respond to such themes in due course.*', '', '', '', '生殖,板块页面正文（原文）,Guidelines,Reproduction Control', 'informational', 'Reproduction Control Guidelines', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('Reproduction Control Guideli · Downloads', 'Downloads

Guidelines for the control of reproduction in dogs and cats

[Download](https://wsava.org/wp-content/uploads/2024/05/J-of-Small-Animal-Practice-2024-Romagnoli-WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-and-cats.pdf%20)

本板块文档清单

共 5 份 PDF，按「英文 + 中文」策略收录 3 份，跳过小语种译本 2 份。', '', '', '', '生殖,板块页面正文（原文）,Guidelines,Reproduction Control', 'informational', 'Reproduction Control Guidelines', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('Reproduction Control Guideli · 已收录（原文已抽取到 raw_extracts/）', '已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Executive Summary. | EN | 2024 版（现行） | 9 | 23923 | [raw_extracts/Executive-Summary.md](raw_extracts/Executive-Summary.md) |
| 2024 Guidelines for the Control of Reproduction in Dogs and Cats. | EN | 2024 版（现行） | 136 | 585449 | [raw_extracts/J-of-Small-Animal-Practice-2024-Romagnoli-WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-and-cats.md](raw_extracts/J-of-Small-Animal-Practice-2024-Romagnoli-WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-and-cats.md) |
| 2024 Guidelines for the Control of Reproduction in Dogs and Cats in Chinese | ZH | 2025 版（现行） | 174 | 327100 | [raw_extracts/（已压缩）附件：《WSAVA犬猫生殖管理指南》（中文版）250422-2-175.md](raw_extracts/%EF%BC%88%E5%B7%B2%E5%8E%8B%E7%BC%A9%EF%BC%89%E9%99%84%E4%BB%B6%EF%BC%9A%E3%80%8AWSAVA%E7%8A%AC%E7%8C%AB%E7%94%9F%E6%AE%96%E7%AE%A1%E7%90%86%E6%8C%87%E5%8D%97%E3%80%8B%EF%BC%88%E4%B8%AD%E6%96%87%E7%89%88%EF%BC%89250422-2-175.md) |', '', '', '', '生殖,板块页面正文（原文）,Guidelines,Reproduction Control', 'informational', 'Reproduction Control Guidelines', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('Reproduction Control Guideli · 未收录（同一指南的其他语言译本）', '未收录（同一指南的其他语言译本）

- WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-in-Japanese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/09/WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-in-Japanese.pdf>
- Executive-Summary-in-Japnanese-1.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/09/Executive-Summary-in-Japnanese-1.pdf>

外部引用（期刊论文 / 相关机构，未抓取正文）

- Download — <https://wsava.org/wp-content/uploads/2024/05/J-of-Small-Animal-Practice-2024-Romagnoli-WSAVA-guidelines-for-the-control-of-reproduction-in-dogs-and-cats.pdf%20>

版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '生殖,板块页面正文（原文）,Guidelines,Reproduction Control', 'informational', 'Reproduction Control Guidelines', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('犬猫生殖控制指南2024-第一部分 · > 本稿覆盖切片 001-011；012-033 见 02-、03- 两篇。', '> 本稿覆盖切片 001-011；012-033 见 02-、03- 两篇。

1. 简介

**卵巢子宫次全切（SOHE）在解剖生理上不正确、不可避免残留部分子宫，应当避免实施**；单纯卵巢切除术（OE）快速、切口小、并发症更低，**无子宫病变且旨在清除性腺激素时建议 OE 为母犬猫绝育首选**；腹腔镜痛感更少、暴露更好。兽用长效 GnRH 激动剂犬单次注射持效 **6~12 个月**（依剂量）、猫更久。**最佳繁控策略是对长期健康危害最小者**（大型与巨型犬尤为重要）；收容所策略对家养宠物未必最佳。

1.1 本文使用说明

① 常规性腺切除术的长期健康风险可能不再被人们接受；② **猫和小型犬可以继续在传统年龄段接受传统性腺切除术**；③ **有风险的大型与巨型犬，经与潜在主人协商后应提供输精管切除术和卵巢保留手术作为替代选择**；④ 无一种术式适用所有情况，也无绝对禁用术式；⑤ **不能继续支持对所有类型动物都例行绝育**；⑥ 有负责任宠主时最佳做法可能是不干预；⑦ 永久绝育不可接受时可建议子宫切除术；⑧ **常规卵巢切除术与卵巢子宫切除术应保留给风险较低者**。

> 切片 001-011 **未出现 Grade A/B/C、strong/conditional 等分级标签**，原文以"建议/不建议/推荐/应避免"表达，本稿不作补全。

2. 犬猫手术绝育', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'caution', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 去除性腺激素的手术绝育', '2.1 去除性腺激素的手术绝育

**母犬（2.1.1，含 2.1.1.1.1~2.1.1.1.7）**

- OE／SOHE／OHE 均可开腹或腹腔镜（除 OHE 外可腹中线或侧切）；**三种开腹术式的难易、并发症率与疼痛程度无明显差异**；**围手术期并发症发病率 7.5%~20.6%，随体重而增加**。
- **幼年动物 6 至 16 周龄也可接受各种开腹手术**（健康、适龄疫苗、水合正常、麻前体检、术前术后保暖）。
- **传统建议避免禁食超过四小时以防低血糖**；**体重超过 0.9 kg 的幼犬长时间禁食也不会低血糖**。
- **所有绝育动物都应通过纹身等外部方式标识**：母犬与公犬腹中线正中或外侧纹**绿色线状纹身**。
- **不建议在发情期（oestrus）行 OHE**；**止血钳与结扎线必须置于子宫颈或阴道前缘水平**；SOHE **诱导麻醉后不久人工排空膀胱尤为重要**。
- **应避免发情期绝育，若因发情推迟则应在两个月内都不要绝育，或至少在血清孕酮降至小于 2.0 ng/mL 之后再考虑手术**；手术宜在**发情期或间情期（diestrus）**。
- **输尿管完全梗阻四天内解除肾功能可恢复正常，14 天内解除可恢复 46% 的肾小球滤过率与肾小管功能，超过 40 天无法恢复**。
- 围产期（2.1.1.1.6）：闭合性 SOHE **从钳夹到助理取出胎儿平均 40 秒（30~60 秒），建议不超过 60 秒**；**胎儿已出现心动过缓且非常担心缺氧时不建议使用**。

**母猫（2.1.2）**：**猫子宫颈与子宫体分界不清，术中有时无法区分 SOHE 与 OHE**；**腹腔镜绝育很少适用或推荐在猫上使用**；**流浪猫绝育状态应始终通过耳尖确认**（多数项目建议**左耳剪耳**）；**最常见并发症为过度或长时间出血，约 5% 病例存在**；**与母犬不同，母猫发情期依旧可手术绝育**。

**公犬（2.1.3）**：**双侧睾丸摘除术是百分之百有效的去势手术**；**开放式更易出现淤青与阴囊血肿，可能时建议尽可能用闭合式**；大型犬建议阴囊全切术；**不建议以美容为目的植入阴囊内假体**；**无缝线阴囊切开对小型犬（0.9~11.4 kg）与幼年犬可减少术后自损、缩短手术时间**；**建议等 6 月龄之后再确定是否存在隐睾**；**单侧隐睾患犬仍具繁殖能力，不建议其后代繁殖**；**保留阴囊内睾丸者需定期触诊**。

**公猫（2.1.4）**：**单切口术中出血概率低于两侧双切口**；**不能只是简单地将睾丸撕扯下来——任何没有足够镇静和镇痛的手术都是不人道的**；隐睾发病率 **0.4% 到 3.8%**、**波斯猫更高**；**最终确诊需等患猫 7~8 月龄之后**。', '', 'young', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'caution', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 保留性腺激素的犬猫手术绝育方法', '2.2 保留性腺激素的犬猫手术绝育方法

**母犬（2.2.1）**：**子宫切除术（2.2.1.1，"卵巢保留绝育术"）术前准备与术后管理同 OHE；术后母犬仍会有发情行为并在发情期吸引公犬**；仅 **14.3%** 兽医会为子宫切除术犬施加外部辨识标志、输精管切除术犬 **31.8%**（建议**绿色"X"代表子宫切除术、绿色"V"代表输精管切除术**）；须**切除所有子宫组织以防子宫内膜囊性增生**，**离断位置应在阴道前缘水平而非子宫颈水平**；**腹侧壁切开、双侧输卵管切除术与卵巢组织移植均不建议**（2.2.1.1.2／2.2.1.2／2.2.1.3）。

**母猫（2.2.2）／公猫（2.2.4）**：**很少建议给有家庭的母猫或公猫做保留性腺激素的绝育**；**附睾切除术（2.2.4.2）更简单快速、无需缝合**。

**输精管切除术（2.2.3 犬／2.2.4.1 猫）**：**犬术后最多 21 天射精液体无精子，此期间应避免与发情母犬接触以免怀孕；术中冲洗输精管可缩短至 6 天**；**猫术后最多 49 天达射精液体无精状态，此期间应避免与发情母猫接触；冲洗可缩短至 7 天**。腹腔镜**须避免破坏睾丸动静脉，否则引起睾丸萎缩、性腺激素水平似传统睾丸摘除术**。

2.3 手术绝育的抗菌药使用

**表 1　美国国家科学研究委员会发布的伤口分类系统**

| 类别 | 定义（原文要点） |
|---|---|
| 清洁创 | 非创伤非炎性伤口且未通入尿生殖道、胃肠道或呼吸道；无菌操作未被破坏 |
| 清洁污染创 | 通入胃肠道、尿生殖道或呼吸道但情况受控且无非常规污染；轻度破坏无菌操作或放引流装置 |
| 污染创 | 新鲜创伤性伤口（小于四小时）；胃肠道或尿生殖道内容物溢出；无菌操作严重破坏 |
| 感染创 | 创伤性伤口超过四小时或有失活组织/异物；内脏穿孔；急性细菌性炎症或脓 |

**建议污染创和特定清洁污染创预防性使用抗菌药，不建议用于清洁手术创**；**唯一与感染率有关的因素是手术和麻醉时间**；并发因素：内分泌疾病、**高龄（超过 8 岁）**、体况评分异常、免疫抑制。**预防性使用须严格遵守三条规则**：① 对预计病原体（主要为皮肤葡萄球菌）有效，常选**头孢唑啉（20 mg/kg IV）**等第一代头孢菌素；② **必须在手术前 2 小时内静脉注射**；③ **使用时间不应超过术后 24 小时**。

2.4 手术绝育和疼痛管理

**所有手术操作都会引起疼痛，任何情况下都必须提供足够镇痛**；建议**多模式疼痛管理**与**局部麻醉技术（腹腔内、切口、睾丸内和卵巢麻醉）**；**体型非常大和非常小的病患建议按体表面积或代谢移速生长率计算药物剂量**。

3. 犬猫非手术绝育', '', 'senior', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 下调激素', '3.1 下调激素

3.1.1 GnRH 激动剂和拮抗剂

**市面上只有一种标明用于犬猫的长效 GnRH 激动剂（乙酸地洛瑞林），用于产生可逆性不孕不育**；短效激动剂：戈那瑞林、布什瑞林、西施瑞林。

3.1.1.1 乙酸地洛瑞林（deslorelin）

植入物两种规格 **4.7 mg 与 9.4 mg**，公犬有效期**分别至少 6 个月和 12 个月**。', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 下调激素 (2)', '| 对象 | 剂量／时间窗 | 抑制、持效与恢复 |
|---|---|---|
| 公犬 | 皮下 **6 mg** | **4 周内** LH 与睾酮测不出，睾丸体积缩小约 50%；**>0.25 mg/kg** 生精抑制 **>1 年**；**4.7/9.4 mg** 使睾酮 **<0.1 ng/mL 至少分别持续 180 天和 400 天**；**每 6 个月**重复植入效果不消失；**<10 kg** 用 **4.7 mg** 抑制 **>2 年** |
| 公犬·可逆 | 移除植入物 | 睾酮 **2 周内**、前列腺体积 **7 周之内**、精液质量 **2~4 个月内**恢复正常 |
| 公犬·爆发效应 | — | 睾酮急性升高致暂时行为改变：**可连用 14 天醋酸环丙孕酮（2 mg/kg BID）预防** |
| 公犬·初情期前 | **4 月龄**植入 **4.7 或 9.4 mg** | 初情期延迟到 **2.5~3.2 岁**；**一日龄**植入**两枚 9.4 mg** 亦延迟，副作用为**睾丸下降延迟和/或双侧隐睾**；**超过 4 月龄治疗未见副作用** |
| 母犬·初情期前 | **9.4 mg** | 初情期**至少推迟到 20 月龄**，之后恢复怀孕能力 |
| 母犬·初情期后 | — | 发情推迟**长达 27 个月**；植入后 **1~4 周内**诱发可育发情；**为避免这种影响，应在母犬 4 月龄之前、排卵发情后 60 天内、产后 7 天内或口服醋酸甲地孕酮 2 mg/kg/天 7 天后再使用乙酸地洛瑞林**；**血清孕酮超过 60 ng/mL 仍有爆发效应** |
| 母犬·成年 | — | 体重增加、假孕、尿失禁（可逆）；初始刺激加剧原有子宫疾病、持续发情、卵泡囊肿与卵巢肿瘤，**不建议超说明书用于老年母犬抑制发情** |
| 公猫 | **4.7 mg** | 初始睾酮升高，**3~11 周内**降至 **<0.1 ng/mL**；**植入后 70 天内**严重少精与弱精；不育维持 **6 个月到 28 个月**；**移除后 60~90 天完全恢复繁殖能力**；**肩甲间或脐周植入不影响持效** |
| 母猫·初情期前 | **4.7 mg** | 初情期**平均推迟 4 个月** |
| 母猫·初情期后 | **4.7 和 9.4 mg** | 有些**最长可维持 3 年**；失效或移除后依季节 **3~6 个月内**恢复；植入后**常进入可受孕的排卵发情状态**，可见持续发情、子宫内膜囊性增生、泌乳与乳腺纤维腺瘤样增生 |

3.1.1.2 GnRH 拮抗剂（acyline 与安替肽 antide）', '', 'senior', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 下调激素 (3)', '**不会出现爆发效应**；**尚无兽医专用 GnRH 拮抗剂**。**母犬发情前期（proestrus）头 1~3 天皮下注射 acyline（0.11~0.33 mg/kg）可将发情期推迟 3 周，未观察到副作用**；**植入乙酸地洛瑞林后 2 天内给予 acyline 不预防爆发效应、也不阻断排卵**。**母猫注射两次安替肽（6 mg/kg）、间隔 15 天，在 17~56 天内抑制卵巢活动**；**母猫单次皮下注射 acyline（330 μg/kg）可推迟发情和排卵约 18 天**；公猫同样处理**不影响睾酮浓度**，但影响生精过程。

3.1.2 孕激素

**3.1.2.1 醋酸甲地孕酮（megestrol acetate, MA）**：口服片剂或糖浆；**短效，半衰期只有几个小时**；**对孕酮受体的亲和性是内源性孕酮的 15~25 倍**。', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 下调激素 (4)', '| 对象 | 方案（剂量／天数与频次／效果） |
|---|---|
| 母犬 | **0.01 mg/kg 每天口服 ×154 天 → 50% 推迟发情** |
| 母犬 | **0.05 mg/kg 每天口服 ×365 天 → 推迟 80%**；停药后 **70.5 天（28~111 天）**恢复 |
| 母犬 | **0.55 mg/kg 每天口服 ×32 天 → 98% 乏情期（anestrus）后期母犬不进入发情，持续 120~180 天（30~210 天）** |
| 母犬 | **低剂量每天使用可长达一年无副作用**；**连续 3 轮及以上或在初情期治疗可能负面影响繁殖能力** |
| 母犬 | **发情前期头 3 天连续 8 次 2.2 mg/kg/天 → 3~8 天内推迟 92%~97%**；**恢复发情间隔 1~9 个月（平均 4~6 个月）** |
| 母犬副作用 | **0.25~2.2 mg/kg/天**：食欲与体重增加、乳腺增大与结节、子宫内膜增厚、血糖升高；**连用 8 天者子宫蓄脓 0.8%**；**>2.2 mg/kg/天或用药 >8 天**：诱发胰岛素抵抗、可能抑制肾上腺皮质功能 |
| 母猫 | **每周一一片含 2.5 mg（4 kg 母猫＝0.625 mg/周 或 0.009 mg/kg/天）可推迟发情，连用 30 周安全**；副作用食欲增加（33%）、体重增加（13%）；某些国家制剂**口服 0.011 mg/kg/天，最长用药 12 个月** |
| 母猫警示 | **0.625 mg/kg/天连用 1 周，或隔天一次连用 2 周**：短期抑制肾上腺皮质、影响葡萄糖代谢；**连续数周每天或数月隔天**：乳腺病变、皮肤黄瘤病、失明、子宫病变、糖尿病与肾上腺皮质功能抑制 |
| 公犬 | **2 mg/kg/天口服 ×7 天精液质量无变化；增至 4 mg/kg 仅轻微继发性精子异常** |

**3.1.2.2 醋酸甲羟孕酮（medroxyprogesterone acetate, MPA）**：**口服半衰期 12~17 小时，注射半衰期 40~50 天**；**对孕酮受体亲和性比内源性孕酮高五倍；对雄激素与糖皮质激素受体的亲和性分别比醋酸甲地孕酮低 100 倍和 1000 倍。**', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 下调激素 (5)', '| 对象 | 方案 |
|---|---|
| 母犬 | **0.01 或 0.05 mg/kg/天持续一年，无病例进入发情**；恢复发情间隔 **0.01 mg/kg/天 93.8 天（22~243 天）；0.05 mg/kg/天 211.7 天（116~311 天）** |
| 母犬注射 | **1.5 mg/kg 每 13 周一次、2 mg/kg 每 3 个月一次、3 mg/kg 每 4 个月一次、2.5 mg/kg 每 5 个月一次** |
| 母犬安全 | **2 岁以下、肝肾功能正常、治疗前无子宫或乳腺病变迹象者，每 5~6 个月一次低于 2 mg/kg 的肠外 MPA，最多连续用药 3 次是安全的**（非官方报道）；**>2.5 mg/kg 肠外给药或超过每 5 个月一次的任何剂量**：增加良恶性乳腺肿瘤、子宫内膜囊性增生、胰岛素抵抗、糖尿病、高胰岛素血症与肢端肥大症风险 |
| 母猫 | **0.05 mg/kg/天口服可安全推迟发情长达 12 个月**；**没有进行过重复治疗和/或长期观察**；**肠外给药 1.6~6.25 mg/kg** 引发子宫与乳腺病变 |
| 公犬 | **皮下 10 mg/kg 不影响生育能力；20 mg/kg 在 3 天内显著降低精子活力、形态与浓度** |

3.1.3 雄激素

**3.1.3.1 米勃龙（mibolerone）**：合成雄激素，北美曾有商品化产品（因人类滥用风险退市）。

| 对象 | 方案 |
|---|---|
| 母犬 | **12 kg 以下、12~23 kg、23~45 kg、45 kg 以上分别为每天 30、60、120、180 mg；任何德国牧羊犬（阿尔萨斯犬）血统的纯种或混血犬都用每日最大剂量 180 mg/天**（原因不明）；**发情前期开始前至少 30 天起治疗，可推迟发情长达两年** |
| 母犬限制 | **停药后 70 天（1~7 个月）内恢复发情；有连续治疗长达 5 年的报道，但不建议超过 24 个月**；副作用：阴蒂肥大、阴道炎、体味加重、爬跨、泪溢；**禁忌：怀孕母犬、肝或肾功能不全母犬、贝灵顿梗犬** |
| 母猫 | **50 mg/猫/天，低于此剂量不推迟发情；该剂量接近中毒剂量——60 mg/天致肝功能障碍，120 mg/天致死亡**；**停药后症状仍未缓解**，故**孕激素比米勃龙更为可取** |', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'caution', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 下调激素 (6)', '**3.1.3.2 其他雄激素**：使用前须确保母犬健康、乏情期、未怀孕且肝功能正常。**每周口服两次甲基睾酮（methyltestosterone）1 mg/kg 可推迟母犬发情期**；**连续 90 天给未去势成年灵缇口服 50 mg/犬/天甲基睾酮**降低平均日产精量与睾丸长度，**治疗结束 90 天后恢复正常**。子宫蓄脓内科治疗后禁用孕激素、可用雄激素推迟发情。

3.1.4 褪黑素（melatonin）

**3.1.4.1 母猫**：**光照周期从 14 小时减至 8 小时时终止发情周期；从 8 小时增至 14 小时后 12~26 天（15.6±0.5 天）恢复**。

| 原文方案 | 效果 |
|---|---|
| **口服 30 mg 后 3 小时进入黑暗环境维持 12 小时，持续 35 天** | 可推迟发情周期；**结束后 21~40 天恢复正常** |
| **较低剂量（<30 mg）** | **不会推迟发情周期** |
| **植入 18 mg** | 推迟发情期**约 2~4 个月** |
| **植入 12 mg** | 抑制 4 只母猫中 2 只发情，**平均持续 75 天（53~94 天）**；对 4 只中 3 只施用 5 次有效但**不能延长持效** |
| **给药时机** | **应在发情间期（interoestrus）给药**；**若在发情期植入，推迟可能耽误 5~30 天且持续时间缩短约一半** |
| 18 mg 其他 | 初情期前植入**不会影响生长**；发情间期植入后**发情持续 1~10 天并伴排卵和假孕**，治疗后**可以生育并产生健康后代** |

**3.1.4.2 公猫**：**公猫全年保持生育能力并产生精液，季节性变化极小**；植入 **18 mg** **不会诱发不育**。', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'caution', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 免疫避孕药', '3.2 免疫避孕药

**3.2.1 抗 GnRH 免疫疗法**：**几十种疫苗用于研究但从未商品化；目前商品化生产的 GnRH 疫苗有两种。**

**3.2.1.1 GnRH 结合钥孔帽贝血蓝蛋白（KLH）**：美国已批准用于野生白尾鹿、草原犬鼠和野马。

| 对象 | 结果 |
|---|---|
| 公犬 | **0.6 mL IM 单次注射**：66%（2/3）免疫后 **3~4 周内**不育，持效约 **14 周**；3 只均有**严重注射部位反应** |
| 母犬 | **0.5 mL IM 单次注射**（n=7 单独、n=7 联合狂犬病疫苗）：**孕酮 60 天内一直 <1 ng/mL**；**70%** 注射肌部肉芽肿性肌炎或凝固性坏死；**接种 60 天后被安乐死，无法评估长期影响** |
| 公猫 | **IM 单次注射**：66%（6/9）**3 个月内**因无精症或严重弱精症不育；**接种 6 个月后接受去势**，无法确定可逆性；**未见副作用** |
| 母猫 | **0.5 mL IM 单次注射**（n=15）**接种 4 个月后**接触可育公猫：受孕时间 **39.7 个月 vs 4.4 个月**；**第一年 93% 不孕，持续 2、3、4、5 年不孕分别 73%、53%、40%、27%**；另一设计 **60%（12/20）4 个月内怀孕、45%（9/20）出现注射部位反应**；**67%（4/6）出现注射部位肿物，平均 110 天（18~249 天）**；联合接种者（n=5）**AMH 血清浓度显著降低** |

**3.2.1.2 GnRH 缀合白喉毒素**：标明适用于**准备屠宰的公猪**；**每 1 mL 疫苗含 0.2 mg 与白喉类毒素结合的 GnRH 及佐剂（150 mg 盐酸二乙氨基乙基右旋糖酐、1 mg 氯甲酚）**；公猫 **0.5 mL SQ、相隔 4 周注射 2 次**（n=9）后**接种 6 周**血清睾酮降至基础水平，**接种后 8~24 周**睾丸体积、阴茎棘与精液质量进行性下降；未报道可逆性。

**3.2.2 抗卵子透明带（ZP）免疫疗法**：**猪 ZP3（pZP3）疫苗不适合用于母犬猫**；母犬（n=4）**75% 接种后接触可育公犬不怀孕**，**不孕原因为排卵失败而非精子结合位点受损**；母猫抗 pZP3 滴度高但**对猫 ZP3 蛋白亲和性较低**，**不能终止发情周期或妊娠**。

**3.2.3 抗 GnRH 和透明带免疫疗法**（GnRH＋犬 ZP3，2 只母犬）：**连续接种 3 次、每次间隔 4 周，抗体滴度显著提高；第 383 天加强免疫使滴度进一步提高并维持到第 528 天**。', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 化学去势', '3.3 化学去势

**睾丸内注射**不需全身麻醉、成本低；**附睾内注射**可能需全身麻醉与超声引导；**尚无睾丸内或附睾内注射作为公犬猫非手术去势选择的长期安全性与有效性研究。**

3.3.1 睾丸内注射

**3.3.1.1 氯化钙**：**配方、浓度和体积尚未标准化**；无菌针头自每个睾丸腹侧**距附睾尾部约 0.5 cm** 处向头端注射，溶液以**线性浸润**方式注入。

| 对象 | 方案 | 结果 |
|---|---|---|
| 公犬 | **0%／10%／20%／30%／60% 氯化钙**生理盐水（5 组各 10 只） | 精子总数、精液量与睾酮**剂量依赖性下降**；**10%、20% 组分别 60%、80% 在 12 个月研究结束前无精子；30%、60% 组 100% 无精子症，但副作用更多**；睾酮 6 个月降 **35%~70%**，除 60% 组外 12 个月反弹 |
| 公犬 | **20% 氯化钙的 95% 乙醇溶液**（37 只） | **9 个月研究期内全部无精症、无法繁殖**；无不良反应 |
| 公犬 | **7.5% 氯化钙的 0.5% 二甲亚砜溶液**（6 只） | **24 小时内睾丸体积明显增大、3 周逐渐缩小**；**5 只在 15 天后、1 只在 30 天后无精子症；60 天内睾酮无明显差异** |
| 公犬 | **20% 氯化钙的利多卡因溶液／酒精溶液（各 n=21）** | **利多卡因组 75% 在 12 个月内不育；酒精组全部 12 个月内无精子**；**利多卡因组睾酮 12 个月回复至治疗前水平；酒精组降 63.6% 并持续处于生理范围下限** |
| 公猫 | 每睾丸 **0.20 mL** 的 0%／5%／10%／20% 氯化钙（各 n=1） | **5%、10% 组少精症（每毫升精子不到两千万）；20% 组未射出任何精子**；**60 天**生精小管与间质细胞钙化 |
| 公猫 | 每睾丸 **0.25 mL** 含 **1% 利多卡因**的 0%／5%／10%／20% 氯化钙（各 n=6） | **1~5 分钟轻微不适；24 小时睾丸肿大，2~4 天达峰值，3~4 周消退**；**20% 致生精上皮完全坏死**；**60 天 20% 组睾酮 2.15 ng/mL、0% 组 7.82 ng/mL** |

**安全提示**：**应注意防止氯化钙溶液从注射部位渗漏，因为如果溶液残留在阴囊皮肤表面或下面，可能会导致组织坏死**；**注射量过大或渗漏到白膜外也会导致阴囊皮肤坏死**。', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 化学去势 (2)', '**3.3.1.2 葡萄糖酸锌**：**13.1 mg 锌/mL 的葡萄糖酸锌与 0.2 M 左旋精氨酸中和至 pH 7.0**；**已获美国 FDA 批准用于 3~10 月龄幼犬，也可超说明书用于年龄大一点的公犬猫**。操作：**连接 0.5 mL U100 胰岛素注射器的 27 G 针头**自睾丸一端推向另一极，退针时匀速注射，针**平行于睾丸长轴**；**与氯化钙不同，进针点位于睾丸前背侧、附睾头外侧**。**剂量：犬每 12~14 mm 睾丸宽度注射 0.3 mL；猫每 27 mm 睾丸宽度注射 1 mL。** 结果：成年犬（n=5）**睾丸直径与血清睾酮无明显变化**；流浪犬（n=36）**66% 睾酮与未去势对照持平**；合用二甲基亚砜者**性欲与睾酮显著降低**、**首注 15 天后**精子数量与活力下降；**2012 年智利巴塔哥尼亚按生产商说明化学去势，6%（2/36）注射 1 周后出现严重坏死性睾丸炎和溃疡性皮炎**；公猫（n=11）**91%（10/11）第 60 天无精子症；第 120 天睾丸缩小、36% 阴茎棘消失、54% 缩小**；（n=115）**12 个月内未报告注射部位反应**。

**3.3.1.3 甘油/丙三醇**：**犬**睾丸内注射 70% 甘油**不会导致无精子症或不育**；**猫**（70% 甘油 **0.5 mL／1.0 mL，各 n=7**）：**0.5 mL 致 3 周血清睾酮与睾丸长度显著下降；1.0 mL 致 1 周睾丸长度、2 周血清睾酮显著下降，附睾样本无精子**。

3.3.2 附睾内注射

| 对象 | 方案 | 结果 |
|---|---|---|
| 公犬 | **20% 氯化钙溶于 95% 乙醇、超声引导下注入附睾头**（n=37） | 9 个月全部无精子症、失去繁殖能力，**血清睾酮无变化** |
| 公犬 | **1.5% 葡萄糖氯己定溶于 50% 二甲亚砜**，每个附睾尾**注射一次／两次** | **一次**在**注射后 91 天**、**两次**在**注射后 35 天内**导致不可逆无精子症 |
| 公猫 | **需使用 30 G 针头**；两侧附睾尾注射 **4.5% 葡萄糖氯己定 0.05 mL／0.10 mL** | **0.05 mL 组 75%（3/4）、0.10 mL 组 25%（1/4）** 出现不可逆无精子症；**头两周短暂阴囊肿胀**、**双侧附睾内精子肉芽肿** |
| 公猫 | **附睾内注射 50 mg 精氨酸锌（每个附睾 0.5 mL）** | **90 天内出现无精子症** |

**附睾内注射生理盐水不会诱发无精子症。**', '', 'young', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 物理方法', '3.4 物理方法

**3.4.1 子宫内装置**：经母犬子宫颈插入铜涂层宫内节育器（IUD，n=8）后交配**无一妊娠**；**T 形铜涂层 IUD（n=9）导致 2 只母犬子宫穿孔**，另一只铜涂层双环 IUD 母犬因严重子宫内膜炎**放置 5 个月后不得不切除子宫**。**根据这些研究结果，不建议使用宫内节育器。**

**3.4.2 治疗性超声扫查**：**会产热**，**约 20% 病例出现皮肤灼伤**；犬（n=20）**三次五分钟**超声（**1.5 W/cm²**、**频率 1 MHz**、**每次间隔 48 小时**）覆盖整个睾丸，**40 天内**永久性无精子症、**血清睾酮无变化**；**用于常规临床前还需更多研究**。

3.5 基因治疗

**3.5.1**：以腺相关病毒（AAV）将干扰 siRNA 递送至猫下丘脑**沉默 Kiss1 基因**；问题是**带 AAV 抗体的猫比例很高**。**3.5.2**：母猫**单次肌内注射经 AAV 递送低浓度（n=3，5e12 病毒基因组/kg）或高浓度（n=3，1e13 病毒基因组/kg）抗缪勒氏管激素（AMH）制剂**；**高浓度 AMH 能使原始卵泡失活并阻止排卵；单次注射后两年多不影响雌二醇分泌或发情周期，但阻止排卵和妊娠。**', '', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 去除性腺激素绝育的健康益处', '4. 去除性腺激素绝育的健康益处

需强调**幼年（6~16 周龄）和初情期前**性腺切除的影响（表 2）。**方法论声明**：关于性腺切除术的益处尚不能盖棺定论，而应该在相同条件下同时探讨其潜在害处，最后综合评判。

**表 2　母犬绝育丧失性腺类固醇激素后的健康益处**（按中文译本表格逐字转录）

| 疾病 | 发病率 | 严重后果\\* | 风险品种† | 影响因素 |
|---|---|---|---|---|
| 卵巢肿瘤 | 0.5%~6.3%（颗粒细胞瘤占卵巢肿瘤的一半） | 有 | 无 | 年龄 |
| 子宫蓄脓、子宫内膜囊性增生 | 10 岁前＞20% 到＞50% | 有 | 有‡ | 年龄、品种/基因、地理分布 |
| 阴道肿瘤 | 1%~3%（所有肿瘤） | 无 | 无 | 年龄、类固醇激素 |
| 输卵管肿瘤 | 0.03%~0.4%（所有肿瘤） | 有 | 无 | 年龄 |
| 乳腺肿瘤 | 8.4%~52% | 有 | 有§ | 年龄、性腺切除术年龄、肥胖、表观遗传学等 |
| 传染性性病肿瘤 | ＜1%（报道的发病率） | 无 | 无 | 交配 |
| 阴道脱垂 | - | 无 | 无 | 大型犬、家族倾向 |
| 孕酮依赖性糖尿病 | 推测较低 | 无 | 有¶ | 年龄、体况评分增加、外源性激素（促孕激素） |
| 行为：明显的假孕 | ＞50%~75% | 无 | 有‖ | 营养、其他泌乳中母犬 |

> \\* 可能危及生命　† 根据文献资料　‡ 金毛寻回猎犬、莱昂伯格犬、爱尔兰狼犬、伯恩山犬、大丹犬、斯塔福德郡斗牛梗、罗威纳犬、斗牛梗、杜宾犬、布维耶德弗兰德斯犬、傲达猎犬　§ 英国斯普林格猎犬、英国可卡猎犬、布列塔尼猎犬、杜宾犬、拳师犬、英国赛特犬、指示猎犬、德国牧羊犬、贵宾犬、腊肠犬；斯塔福斗牛梗、拉萨犬、约克夏梗、马尔济斯犬　¶ 猎犬、北欧猎犬　‖ 阿富汗猎犬、比格犬、拳师犬、腊肠犬、斑点犬、矮脚长耳猎犬、指示猎犬
>
> **与英文版核对**：英文该行行名 **Uterine tumours**，中文作「输卵管肿瘤」；英文阴道肿瘤 "1.9 to 3"，中文 "1%~3%"；英文乳腺肿瘤行影响因素另有 "gestagens"；其余数值一致。', 'dog', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'caution', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 母犬', '4.1 母犬

4.1.1 生殖道疾病

表 2 之外的数值：**卵巢囊肿占所有卵巢疾病 80%**；**颗粒细胞瘤可高达 50%、约一半分泌雌激素**；**腺癌／颗粒细胞瘤／生殖细胞瘤转移率 48%／20%~50%／20%~30%**，多见于 **10 岁以上**；**子宫内膜囊性增生主要发生于从未妊娠或无孕周期超过 3~4 年的母犬**；**阴道肿瘤 73%~94% 良性**；子宫肌瘤**最多见于 5~16 岁未绝育初产犬**；**子宫肿瘤占所有犬肿瘤 0.03%~0.4%（子宫肌瘤 >90%），恶性子宫肿瘤仅 0.003%**，**2 岁前摘除卵巢者无子宫肿瘤报道**；乳腺肿瘤：**性腺切除母犬 1.8%（42/2281）**、**大于两岁切除者 4.9%~5.3%**、**约 50% 恶性**、**患者大多大于 8 岁**、**未绝育风险增加 3~4 倍或更高，性腺切除使患病比率与死亡率降低约 3 倍**、**切除时小于 6 个月的雌性德国牧羊犬 0/46 均未罹患**、**1969 年研究：初情期前切除者相对风险 0.5%，第一与第二、第二与第三发情周期之间切除者分别 8% 与 26%，第三发情周期后绝育无预防作用**（**小于 6 月龄不一定意味着初情期前**）；**阴道增生与脱垂多在第一次至第三次发情的卵泡期（73% 至 86%）**、**复发率大于 66%**，妊娠期间的间情期**很少发生所谓的真性阴道脱垂（8%~12%）**，一例由 **0.3 mg/kg 苯甲酸雌二醇肌注**诱发。

**表 3　特定犬卵巢肿瘤组织病理学检查结果**（改自 Arlt and Heimerl, 2016；已与英文版逐格核对一致）', 'dog', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'caution', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 母犬 (2)', '| 作者，年份 | 样本数量 | 腺瘤 | 腺癌 | 其他 | 颗粒细胞瘤 | 支持细胞-间质细胞瘤 | 其他 | 无性细胞瘤 | 畸胎瘤 |
|---|---|---|---|---|---|---|---|---|---|
| Dow, 1960 | 25 | 10 | 1 | 1 | 13 | – | – | – | – |
| Norris et al., 1970 | 78 | 20\\* | 3\\* | 6 | 15 | 6 | 5 | 11 | 2 |
| Hayes & Young, 1978 | 94 | 23 | 29 | 3 | 22 | – | 1 | 2 | 5 |
| Patnaik & Greenlee, 1987 | 71 | 12 | 21 | （原文此处空白） | 12 | 12 | – | 7 | 7 |
| Diez-Bru et al., 1998 | 10 | 1 | 3 | – | 3 | – | 1 | 1 | 1 |
| Sforna et al., 2003 | 49 | 21 | 7 | – | 14 | – | – | 2 | 1 |
| Bertazzolo et al., 2004 | 19 | – | 7 | – | 8 | – | 1 | 1 | 2 |

> \\* 另有 10 例肿瘤介于腺瘤和腺癌之间。

**结论**：**不建议对幼年或初情期前的犬进行预防性性腺切除术；决定是否性腺切除时不应仅以预防生殖道肿瘤为目的**；**只有微弱的证据表明性腺切除术能降低乳腺肿瘤的风险**；**幼年性腺切除术（6~16 周龄）可降低乳腺癌发病率，但这种程度的降低可能比以前认为的要小，因此大多数情况下不再常规推荐**；**性腺切除术可使阴道增生/脱垂在 7~10 天内缓解并防止复发**。

4.1.2 孕酮依赖性糖尿病

**间情期、妊娠或使用促孕激素治疗期间**孕酮升高致胰岛素敏感性暂时降低；**体况评分增加与年龄增长属易感因素**；**胰岛素治疗在性腺切除术后 11 天再次生效，血糖在 2 个月内得以控制**。**结论**：**无论确诊时间长短，性腺切除术都能治愈孕激素依赖型糖尿病。**

4.1.3 行为问题

**必须将问题行为（攻击、焦虑或恐惧行为）与不受欢迎的行为（撒尿标记、爬跨行为）区分开来**。**结论**：**有咬人前科的犬最好在进行不可逆性腺切除术之前先由行为学专家检查并寻找潜在原因；使用 GnRH 激动剂化学绝育等可逆方法似乎更可取**；**存在明显假孕和围产期攻击行为的母犬行性腺切除术有好处，其他行为问题必须先由专业兽医行为学专科医生分析评估**。', 'dog', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 母犬 (3)', '> **表 4（母犬性腺切除术后行为改变文献汇总，Balogh 2018 等 16 项研究）**：中文译本切片与英文版 Table 4（跨两页）列序在 PDF 抽取时均严重串列，故不重构；**表中逐格数值「原文此处缺失」**。

4.1.4 预期寿命

**220 万例犬电子病历**：**切除性腺母犬平均寿命比未绝育母犬长 23%**；**345 只罗威纳犬**：**未绝育状态至少维持 4.3 年的母犬比少于 4.3 年者寿命长 17 个月**，**一岁前绝育的雌性罗威纳犬预期寿命比未绝育同类短 1.5 年**；**金毛寻回猎犬与维兹拉犬显示相反数据或无差异**。**结论**：**文献之间存在争议；缺乏除去罗威纳犬以外其他品种的对照实验。**', 'dog', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 公犬', '4.2 公犬

4.2.1 生殖道疾病

**睾丸肿瘤占雄性生殖器肿瘤 94.1%、占公犬所有肿瘤 16%~27%**；**间质细胞瘤最常见，发病率不低于 50%**；**支持细胞瘤 7.4%~8%，但超过一半会产生雌激素，约 70% 腹腔内支持细胞瘤具内分泌活性**；**所有睾丸肿瘤中 50% 以上来自腹腔内隐睾**。**结论**：**腹腔内隐睾和分泌激素的肿瘤必须进行性腺切除术以防止高雌激素血症和转移；如需延续生育能力且对侧睾丸外观正常可行单侧睾丸摘除，但非官方资料显示同类肿瘤可能随后在对侧睾丸生长，应提醒客户。**

**BPH（良性前列腺增生）为未去势老年公犬最常见的前列腺疾病：80% 超过 5 岁的未去势公犬与 95% 超过 9 岁的公犬发病**；**有临床症状者占小于 4 岁 6.2%、4~7 岁 17.5%、10 岁 32.8%、不低于 10 岁 43.5%**；**最早可发生于 2 岁，5 岁以后发病率超过 60%，老年犬接近 100%**。**干预效果**：**任何能消除性腺类固醇激素分泌或减少双氢睾酮影响的去势方法（如性腺切除术、激素下调）都能预防或解决良性前列腺增生**；**性腺切除术后第一周睾酮迅速减少，前列腺体积数天内开始缩小，2~3 周内缩小程度高达 50%；1~2 周后直检触诊已可感觉体积缩小；大部分病例术后四周内血性包皮分泌物消失**；**超说明书长期使用诸如乙酸地洛瑞林的 GnRH 激动剂后，前列腺在 4~12 周内缩小；植入 4.7 mg 乙酸地洛瑞林后，前列腺在 6 周内缩小 50% 以上**；**长期使用 GnRH 激动剂有时需先用短效抗雄激素治疗 1~2 周以抑制爆发现象**。

**表 5　公犬接受清除性腺类固醇激素的去势后的健康益处**（按中文译本表格逐字转录；已与英文版核对一致）

| 疾病 | 发病率 | 严重后果\\* | 风险品种† | 影响因子 |
|---|---|---|---|---|
| 睾丸肿瘤 | 占几乎所有肿瘤的 16% 到 27% | 有 | 无 | 年龄、隐睾、环境因素 |
| 良性前列腺增生 | 占 7~10 岁年龄段犬的 32.8%，占所有犬类疾病的 50% | 有 | 有‡ | 年龄 |
| 前列腺炎 | 取决于群体 | 有 | 无 | 其他前列腺疾病 |
| 肛周腺瘤 | - | 无 | 有§ | 雄激素、雌激素 |
| 传染性性病肿瘤 | <1% | 有 | 无 | 群体、交配 |
| 会阴疝 | - | 有 | 无 | 年龄、前列腺增大和移位 |

> \\* 可能会危及生命　† 根据文献报道　‡ 大型犬；杜宾犬、罗威纳犬、德国牧羊犬、罗得西亚脊背犬和拉布拉多寻回猎犬　§ 可卡犬', 'dog', 'senior', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'caution', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-第一部分 · 本稿边界说明', '本稿边界说明

- 覆盖切片 **001-011**：1、1.1、2（2.1~2.4）、3（3.1~3.5）、4 绪论与表 2、4.1（4.1.1~4.1.4）、4.2 至 **4.2.1.2.1**（含表 5）；切片中**不含**生殖生理、发情周期等独立章节，本稿按原文实际编号编排。
- 受字数限制，本稿为**密集摘录式**整理稿（"字数"按中文字符计，拉丁药名与数值未计入）：术式操作细节（切口长度、缝线型号、器械、气腹压力）、机制说明、文献引用、§4 中与表 2／表 5 重复的流行病学叙述、§3.4.2／§3.5 的实验性参数已压缩；**药名、剂量（mg、mg/kg、μg/kg）、给药天数与频次、时间窗、手术月龄与体重阈值、表 1~表 3 与表 5 数值均逐字保留**。
- **4.2.1.2.2 前列腺炎、4.2.1.2.3 前列腺肿瘤、4.2.2 肛周肿瘤、4.3 猫、第 5 章、第 6 章、参考文献与中英文对照表在本稿范围之外**，见 02-、03- 两篇；表 6 及之后表格未收录，原文图 1~图 68 在切片中只有图题文字。', 'cat', '', '', '生殖,卵巢子宫次全切,卵巢切除术,子宫切除术,输精管切除术,乙酸地洛瑞林,简介,犬猫手术绝育,犬猫非手术绝育', 'informational', '犬猫生殖控制指南2024-第一部分（中文译本切片001-011）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · > 本稿覆盖切片 012-022；001-011 见 01-，023-033 见', '> 本稿覆盖切片 012-022；001-011 见 01-，023-033 见 03-。
> 说明：药名、剂量、月龄、时间窗与百分比逐字照抄；引用括注与机制铺述从略。

1. 第 4 章 益处——公犬（4.2，接续切片 011）

1.1 4.2.1.2.2~4.2.1.2.3 前列腺疾病
前列腺炎与年龄无关，未去势犬前列腺炎最常继发于良性前列腺增生。急慢性病例服抗雄激素药（醋酸环丙孕酮、醋酸地马孕酮或醋酸奥沙特龙）可减少前列腺体积；地洛瑞林对慢性前列腺炎未研究。**结论框：建议使用抗雄激素药物迅速缩小腺体；性腺切除术是解决和预防前列腺炎的有效辅助措施。**前列腺肿瘤在性腺切除犬比未去势犬更常见（见 5.2.1.1）。

1.2 4.2.2~4.2.5 肛周肿瘤、传染性性病肿瘤、尿道脱垂、会阴疝
- 肛周腺肿瘤：未去势中年至超过九岁公犬第三大最常见肿瘤；约 12%~17% 恶性（腺癌）；腺瘤去睾酮后一般 95% 消退；他莫昔芬（抗雌激素）联合醋酸环丙孕酮（抗雄激素）对雄/雌激素受体高表达腺瘤有效；腺癌建议手术切除结合化疗或放疗；可卡猎犬易感。**结论框：性腺切除术可有效治疗腺瘤和上皮瘤；抗激素疗法对腺瘤有益；非官方证据表明 GnRH 激动剂可能也是治疗肛周腺瘤和上皮瘤的有效方法。**
- 传染性性病肿瘤：性腺切除可降低风险（或因性欲、交配频率下降）。
- 尿道脱垂：最常见于年轻未去势短头犬（英国斗牛犬、约克夏梗），有遗传倾向；结论框：个别个体中修复术联合性腺切除可能有益。
- 会阴疝：CT 病例对照（n=46 vs n=23）示患犬前列腺明显增大、囊肿增多；合并前列腺疾病时去势或激素治疗缩小前列腺有好处，但须权衡成年至老年犬不利影响（尤其前列腺癌风险）。

1.3 4.2.6 行为（表 6）与 4.2.7 预期寿命
去势/激素下调改善睾酮依赖行为：发情母犬诱起的公犬对人性欲亢进和游走分别减少 57% 和 64%；爬跨与年龄有关——初情期前或非常年幼犬切除后消失，有经验犬术后持续。睾丸切除术降雄性间攻击性 57%，但 4% 的犬攻击增强。可先试 GnRH 激动剂植入物化学去势：完全可逆；6 个临床病例认为常年反复使用乙酸地洛瑞林安全；不可逆切除前应由兽医行为专家分析。**表 6（公犬去势后行为改变文献汇总）在译本切片中列头缺失、单元格严重错位，无法还原（原文此处缺失）**。预期寿命：6018 份问卷示未去势公犬寿命较短、性腺持留越长预期寿命越长；345 只罗威纳分析无差异；无法得出明确结论。

2. 第 4 章——猫（4.3）', '', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'informational', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · 生殖道疾病', '2.1 4.3.1 生殖道疾病
母猫：卵巢囊肿【卵巢实质中持续存在的含液结构】致持续发情与激素失调（高雌激素血症、持续发情和/或不发情），可因雌激素骨髓毒性出现非再生性贫血；卵巢囊肿、卵巢癌、子宫内膜囊性增生、子宫蓄脓和肿瘤可经性腺切除或激素下调避免。猫最常见的卵巢肿瘤为颗粒细胞瘤，约 50% 恶性。子宫蓄脓机理同犬，发病率低于犬：13 岁前 2.2%，通常 4 岁以上、7 岁以上更高；总体病死率 5.9%（335 只中 19 只死亡）。9.6 年间子宫肿瘤占所有猫科动物肿瘤的 0.29%。术后子宫卵巢残留可致反复/持续发情、高雌激素血症、可致命的子宫残端蓄脓。
公猫：睾丸肿瘤极罕见、多与隐睾有关，腹腔内隐睾应手术切除（很可能出现间质细胞瘤和支持细胞瘤等恶性肿瘤）；须完全切除肿瘤性睾丸避免癌组织移植。前列腺癌在性腺切除公猫仅三例报告，前列腺腺癌最常见。结论框：母猫性腺切除或卵巢子宫切除可治愈或预防卵巢和子宫疾病；公猫性腺切除可治愈并预防睾丸疾病（译本作"搞完疾病"，笔误），但对前列腺腺癌并非如此。

**表 7 猫清除性腺类固醇激素绝育的健康益处**

| 疾病 | 发病率 | 严重后果* | 易感品种† | 影响因素 |
|---|---|---|---|---|
| 包括颗粒细胞瘤在内的卵巢疾病 | 多变 | 有 | 无 | 年龄 |
| 子宫蓄脓 | 13 岁为2.2% | 有 | 有‡ | 年龄 |
| 子宫肿瘤 | 占所有肿瘤的29% | 有 | 无 | 年龄 |
| 睾丸肿瘤 | 极为罕见 | 少 | 无 | 隐睾 |
| 乳腺肿瘤 | 占所有肿瘤的17%，占所有恶性肿瘤的12% | 有 | 有§ | 年龄、促孕激素 |

注原样：* 可能危及生命；‡ 斯芬克斯、西伯利亚、"猫鼬"（译本用词，正文作"奥西猫"）、柯拉特、暹罗、布偶、缅因、孟加拉猫；§ 暹罗猫和东方品种。正文 0.29% 与表内 29% 不一致，照录。', '', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'caution', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · ~4.3.1.2 乳腺疾病', '2.2 4.3.1.1~4.3.1.2 乳腺疾病
- 炎性乳腺疾病：乳腺炎主要见于哺乳期、分娩后、外伤后、偶尔假孕期；坏疽性乳腺炎可因败血症危及生命。结论框：性腺切除或激素下调防止妊娠或假孕，可预防乳汁淤积和乳腺炎。
- 乳腺纤维腺瘤病（纤维上皮增生）：常见于未绝育年轻猫，多发于孕激素升高期（发情后期、假孕期、妊娠期）；老年猫（含公猫）与外源/内源性孕激素及乳腺孕激素受体浓度异常有关；可能并发缺血坏死和血栓。抗孕激素或性腺切除可治愈；超高剂量长效孕激素致病者缓解可能需数周。结论框：公猫母猫用抗孕激素、母猫用性腺切除术可治愈。
- 乳腺肿瘤：回顾研究发病率 0.104%；占母猫所有肿瘤 17%、所有恶性肿瘤 12%；>80% 恶性（以腺癌为主）。性腺切除猫乳腺癌发病率 19.1%、良性 4.3%；未绝育猫 28.5% 和 6.4%。醋酸甲地孕酮和醋酸甲羟孕酮长年定期大剂量服用可诱发公母猫乳腺增生或癌变；暹罗猫和东方猫风险为其他品种两倍。**初情期前性腺切除或激素下调是预防措施；6 月龄以下性腺切除可将发病率降低 91%；8 月龄或 2 岁后切除没有预防作用**。结论框：猫初情期前性腺切除术可大大降低乳腺癌形成。

2.3 4.3.2~4.3.4 感染/行为/寿命
据称性腺切除可降低 FIV、FeLV 和冠状病毒（FIP）感染风险；<5.5 月龄绝育母猫哮喘和牙龈炎发病率降低、公猫脓肿减少；结论框：无证据表明性腺切除术本身降低感染或免疫系统疾病风险。去势或激素下调（与切除年龄无关）提高对主人忠诚度、降低对其他猫攻击性、消除母猫持续发情；初情期前切除后 10% 公猫和 5% 母猫仍出现尿标记。绝育猫平均寿命比未绝育长 1~4 年。', 'cat', 'senior', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'caution', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · 第 5 章 危害——总论与汇总表（章标题页残缺，仅存"05 去除性腺激素绝育对健', '3. 第 5 章 危害——总论与汇总表（章标题页残缺，仅存"05 去除性腺激素绝育对健康的危害"残块，原文此处缺失）

性腺切除后下丘脑垂体轴负反馈消失，血促黄体素（LH）和促卵泡素（FSH）永久性升高。较早研究与美国动物医院协会等曾支持对收容幼犬（6~16 周龄）性腺切除，论点是 16 周龄前或直到 7 月龄手术的长期影响无显著差异；但被领养的大型和巨型犬种可考虑其他替代方法。

**表 8 母犬接受清除性腺类固醇激素绝育的健康危害**

| 疾病 | 发病率 | 其他影响因素 | 易感品种 |
|---|---|---|---|
| 肥大细胞瘤 | 0.24%~0.29% 占皮肤肿瘤的20% | 体重、年龄、绝育年龄 | 有† |
| 移行细胞癌 | 1% | 年龄 | 无 |
| 骨肉瘤 | 0.2%~8.9% | 体重、年龄、体型、性别、绝育年龄 | 有‡ |
| 淋巴瘤 | 0.02%~0.1% | 绝育年龄 | 有§ |
| 血管肉瘤 | 占非皮肤原发性肿瘤的5% | 绝育年龄 | 有¶ |
| 尿道括约肌机能障碍 | 5%~20% | 体重、年龄、体型、性别、绝育年龄、短尿道 | 有‖ |
| 骨科疾病 | 0%~22%；取决于疾病和其他影响因素 | 体重、年龄、绝育年龄 | 有†† |
| 甲状腺机能减退 | 2.05% | 环境、年龄 | 有‡‡ |
| 肾上腺皮质机能减退 | 0.4% | 年龄 | 有§§ |
| 肥胖 | 随年龄增加 | 饲喂方式、运动、性别状态、年龄、品种体型 | 有¶¶ |
| 行为：根据绝育年龄不同，某些品种的反应性、恐惧或害羞会增加 | 取决于其他影响因素 | 绝育年龄、生活环境、训练、经历 | 未证实 |
| 预期寿命：存疑，在雌性罗威纳犬中有些提示 | 取决于其他影响因素 | 疾病，尤其是癌症 | 未证实 |

**表 9 公犬接受清除性腺类固醇激素绝育的健康危害**（切片 013/014 分断已合并；译本注脚符号有错位，照录）

| 疾病 | 发病率 | 其他影响因素 | 易感品种 |
|---|---|---|---|
| 前列腺肿瘤 | <1% | 年龄、慢性炎症 | 有† |
| 肥大细胞瘤 | 0.24%~0.29% 占皮肤肿瘤的10%~21% | 年龄、体重（>20kg） | 有‡ |
| 移行细胞癌 | <1%（雄性少于雌性） | 年龄、性别状态 | 无 |
| 骨肉瘤 | 0.2%~8.9%（雄性多于雌性） | 年龄、体重、性别状态、去势年龄 | 有§ |
| 淋巴瘤 | 0.02%~0.1%（雄性少于雌性） | 去势年龄、性别状态 | 有¶ |
| 血管肉瘤 | 占所有非皮肤原发恶性肿瘤的5%，占所有脾脏肿瘤的50% | 年龄、去势年龄、浅色皮肤且短毛 | 有‖ |
| 尿道括约肌机能障碍 | 0.94% | 年龄、短尿道、后位膀胱 | 未证实 |
| 骨科疾病 | 0%~22%；取决于疾病和其他影响因素 | 体重、年龄、去势年龄 | 有†† |
| 肥胖 | 随年龄增加 | 饲喂方式、运动、性别状态、年龄、品种体型 | 有‡‡ |
| 甲状腺机能减退 | 2.05%（雄性少于雌性） | 环境、年龄 | 有§§ |
| 肾上腺皮质机能减退 | 0.4%（雄性少于雌性） | 年龄、性别状态 | 有¶¶ |
| 免疫疾病 | 雄性少于雌性 | 年龄、性别状态 | 无 |
| 行为：在某些情况下会增加攻击性，也取决于去势时的年龄 | 取决于其他影响因素 | 去势年龄、生活环境、训练、经历 | 未证实 |

表 8/9 注脚（†~¶¶）为各疾病易感品种名单，母犬／公犬并列、译本符号错位；名单为纯品种名，本稿因篇幅从略，完整照录见原文表 8/9 注脚（切片 013~014）。

**表 10 猫接受清除性腺类固醇激素绝育的健康危害**

| 疾病 | 发病率 | 严重后果* | 易感品种† | 影响因素 |
|---|---|---|---|---|
| 肥胖和糖尿病 | 频发 | 有 | 无 | 性别状态（雄性多于雌性）、饲喂方式 |
| 骨骺骨折 | 频发 | 无 | 无 | 性别状态（雄性多于雌性）、初情期前性腺摘除 |
| 肿瘤 | 与未绝育猫相比几率增加4.43~6.47倍 | 有 | 无 | 绝育年龄 |
| 下尿路疾病 | - | 有 | 有‡ | 超重 |

* 可能危及生命；‡ 波斯猫、曼克斯猫、喜马拉雅猫。', '', 'young', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'caution', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · 第 5 章——母犬（5.1）', '4. 第 5 章——母犬（5.1）

4.1 5.1.1 肿瘤
- 肥大细胞瘤：168,636 只犬估计发病率 0.24%~0.29%；体重 20~30kg 对 <10kg 犬比值比 2.6 倍；>7 岁显著增加；性腺切除母犬比切除公犬风险更高；**切除年龄超过 12 月龄比小于 12 月龄发病率更高**。
- 移行细胞癌：占所有犬癌症 1.5%~2%；确诊中位年龄 11 岁；10%~20% 确诊时已转移、49% 尸检时已转移；切除母犬风险更高（雌:雄 1.7:1）。
- 骨肉瘤：拉布拉多 0.2% 至爱尔兰猎狼犬 8.9%；切除性腺犬相对风险为未绝育 2 倍；**罗威纳犬一岁前切除的公母犬风险明显更高**。
- 淋巴瘤：0.02%~0.1%；切除后风险进一步增加、尤其母犬；维兹拉犬切除母犬相对风险为未绝育 4.3 倍。
- 血管肉瘤：占非皮肤原发恶性肿瘤 5%、脾脏肿瘤 50%；>7 岁、浅色皮肤短毛者增加；切除母犬相对风险高五倍／雌性维兹拉犬高 9.2 倍；切除时超过 12 月龄者发病率高于未绝育犬和 <12 月龄切除犬。

4.2 5.1.2~5.1.3 USMI 与骨科
**性腺切除术后任何时间 3%~20% 的母犬出现尿道括约肌机能障碍（USMI）**（表 8 作 5%~20%）；>20kg、老年、尿道短者易感；术式类型不影响发病率；**年龄越小风险越高，<3~6 月龄是一个临界值**（支持证据强度较弱）。骨科：髋关节发育不良（HD）、肘关节发育不良、前十字韧带（CCL）功能不全及椎间盘疾病等比率随切除增加；**与 12 月龄后或未绝育犬相比，12 月龄前切除犬 HD 和 CCL 损伤发病率更高**；<6 月龄切除的金毛、拉布拉多、德国牧羊犬关节疾病高 2~5 倍；腊肠犬 12 月龄以下切除椎间盘疾病风险增加。结论框：应按品种、年龄和成年体重个性化建议。

4.3 5.1.4~5.1.5 代谢/内分泌/免疫
切除母犬代谢率下降、饱腹感降低；肥胖风险比值 1.53；<10kg 小型犬高于大型犬；犬肥胖不导致糖尿病。甲状腺机能减退（2.05%）：90090 例数据集示切除犬比例更高、平均术后 20 个月确诊。肾上腺皮质机能减退：青中年母犬易感，切除犬风险更大。免疫：90090 例回顾示切除犬罹患特应性皮炎、自体免疫性溶血性贫血、肾上腺皮质机能减退、甲状腺机能减退、免疫介导性血小板减少症和炎性肠病的相对风险明显更高；红斑狼疮仅母犬显著；雌性切除平均 28.6±0.5 月龄、确诊在术后 20 个月之后。', 'dog', 'senior', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'informational', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · ~5.1.7 行为与幼年切除', '4.4 5.1.6~5.1.7 行为与幼年切除
行为：<5.5 至 12 月龄切除对攻击、噪音恐惧和分离焦虑无明显影响；切除母犬攻击性是未绝育的 2 倍（68% 对比 32%），11 月龄前切除且术前已有攻击性者对宠主攻击性增加；候选服务犬 <7 vs 7~11 vs >11 月龄因行为问题被剔除比例 47.2% vs 34.5% vs 49.4%（译本数字排列如此）。成年母犬用长效 GnRH 激动剂可在爆发效应期出现寻求雄性行为及假孕相关行为变化。幼年切除（6~16 周龄）：体质差且免疫不足时易感染；延迟桡尺骨生长板闭合；可致外阴内陷→外阴周围皮炎和尿生殖道反复感染（部分需外阴成形术）；<3 月龄切除可能增加 USMI 风险（证据较弱）。结论框：幼年切除有助防收容所/流浪犬意外怀孕并提高领养率，但某些个体（尤其大型犬）应考虑其他方法。

5. 第 5 章——公犬（5.2）

5.1 5.2.1.1 前列腺肿瘤
发病率 <1%；确诊多 >8 岁；转移率按年龄 16%~80%（腰椎椎体、盆骨、膀胱、肺等）；性腺切除犬更常见。比格犬 24~30 月龄睾丸切除后导管细胞丧失分化能力、基质转为波形蛋白阳性、神经内分泌细胞增加且被雄激素治疗抑制，提示雄激素可能对犬前列腺实质有保护作用。GnRH 激动剂组织学：**植入 6mg 地洛瑞林后前列腺管腺结构完全萎缩；植入后第 41 天前列腺管内仍衬有非分泌性上皮；植入后第 100 天腺上皮完全萎缩伴基质结缔组织增加**。长期 GnRH 激动剂对犬前列腺的影响无资料。**结论框：应将患前列腺肿瘤的极低风险（<1%）与巨大前列腺囊肿/脓肿风险以及未去势犬固有的高手术风险权衡；对保持未去势的公犬，年龄达到预期寿命的 40% 后，每年至少重复一次全面检查（应包括直检、前列腺超声扫查和血清CPSE 检测）。**', 'dog', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'informational', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · ~5.2.7 其余危害要点', '5.2 5.2.1.2~5.2.7 其余危害要点
- 肥大细胞瘤：切除雄性比切除雌性风险低；>12 月龄与 <12 月龄手术发病率无差异（与母犬不同）。淋巴瘤：<12 月龄切除的雄性金毛 10% 诊断淋巴肉瘤，为未去势雄性 3 倍。血管肉瘤：切除雄性维兹拉犬风险未增加。
- USMI：109428 只公犬尿失禁发病率仅 0.94%，与切除或体重无关、随年龄增加。结论框：无证据表明切除会增加公犬尿失禁风险，但仍应告知客户。
- 骨科：615999 例数据示切除公犬 HD 与 CCL 断裂相对风险明显更高；<6 月龄切除雄性金毛 HD+CCL 比率高出五倍；<6 月龄拉布拉多 CCL 断裂和肘关节发育不良显著升高；雄性德国牧羊犬 <6 或 >12 月龄切除风险明显更高。结论框：骨科问题可能是副作用，尤其 <6 月龄切除与中大体重犬。
- 代谢/内分泌：切除公犬肥胖风险比值 2.62；肥胖诱发胰岛素抵抗但不引起糖尿病；一岁时切除者超重/肥胖相对风险低于较晚去势者，风险比值术后 3~4 岁前一直上升后下降。甲状腺机能减退、库欣、阿迪森同母犬。
- 免疫：仅肾上腺皮质机能减退中切除雄性发病率高于切除雌性，公犬切除平均 32.3±0.7 月龄、确诊在术后 20 个月之后；151 例免疫介导性溶血性贫血（IMHA）中 IMHA 组切除犬 129/151（85%）高于对照组 10038/13266（76%）。结论框：只有有限证据表明切除可能是公犬肾上腺皮质机能减退和 IMHA 的风险因素。
- 行为：C-BARQ 研究（切除年龄 ≤6、7~12、11~18、>18 月龄分组）：对陌生人攻击概率更高仅限 7~12 月龄组。长效 GnRH 激动剂后无雄性攻击性增加报告；3/53 只犬焦虑增加（未被后续研究证实）。结论框：不可逆切除前应由兽医行为专家评估。
- 幼年切除（6~16 周龄）：初情期前切除使桡尺骨生长板闭合推迟 4 个月；致阴茎和包皮发育不良，但无不良后果报道。', 'dog', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'informational', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · 第 5 章——猫（5.3）', '6. 第 5 章——猫（5.3）

- 代谢：切除使猫食欲增加、代谢率降低、能量消耗减少，肥胖风险增加（尤其公猫）；肥胖猫患胰岛素依赖型 II 型糖尿病风险增加（胰岛素和瘦素抵抗），绝育公猫尤其高；增加运动、减少摄入及低脂肪饮食可预防。
- 骨科：切除猫最终桡骨长度增加，7 周龄对比 7 月龄切除对 24 月龄桡骨长度无影响、无健康负面影响；切除公猫和肥胖猫常见股骨头骨骺骨折（病因未证实）；母猫初情期前切除问题少于母犬。
- 肿瘤：16592 只猫（2000~2023）：早期切除者患癌几率更高，晚期切除者患肉瘤、肥大细胞瘤和淋巴瘤几率更高；切除猫患癌、淋巴瘤、肥大细胞瘤、肉瘤比值比分别为 4.43、6.24、5.75 和 6.47。
- 下尿路疾病（LUTD）：7 周龄或 7 月龄切除不减小尿道直径；但 22908 病例/263168 对照研究示切除猫患 LUTD（尤其尿道结石和肿瘤）风险明显增加；超重（≥6.8kg）为额外风险。结论框：个体病例中切除可能对猫 LUTD 有一定促进作用。
- 幼年切除：可致阴茎系带持续存在、抑制阴茎突出（临床影响未证实）。**结论框：考虑到猫的高繁殖力、初情期大多较早出现以及问题发生率较低，可以建议在猫 3~4 月龄时进行性腺切除术。不过前提是猫的健康状况应良好，并接种过疫苗。**', '', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'informational', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · 第 6 章 繁殖管理伦理（6.1~6.8）', '7. 第 6 章 繁殖管理伦理（6.1~6.8）

- 收容数据（6.2）：2019 年美国约 310 万只犬进收容所（每千居民约 9.4 只收容、约 1.2 只安乐死），每年犬猫安乐死估计 92 万~约 300 万；科罗拉多州每千居民犬 20.1 只入收容所、1.4 只安乐死，猫分别 11.6 和 1.2；澳大利亚 2012~2013 每千居民 9.3 只犬收容，找回/领养/安乐死每千居民 4.4/29/1.9 只（译本数字排列如此）；英国每千居民 1.9 只收容、约 10% 安乐死。
- TNR（捕获-绝育-放归，6.3）：受"环境容纳量"与外来迁入限制、见效有明显延迟；适用于小而封闭、地理隔离的区域；狂犬病模型显示只需对 30% 的犬注射抗 GnRH 和狂犬病二联疫苗就能根除该地区狂犬病；绝育后的自由漫游动物仍可能威胁野生动物。结论：TNR 应与责任养宠、教育和社区外联结合。
- 责任养宠与绝育率（6.4~6.5）：美国犬绝育率约 64%~78%、猫约 82%~85%；爱尔兰犬 47%、猫 76%；德国犬 43%；瑞典犬接近 2%（瑞典最近才允许对自由漫游猫无医学指征绝育）。
- 早期绝育（6.6）：BVA(2021) 认可犬初情期前绝育、家养猫 16 周龄后绝育、流浪/救助猫 8 周龄绝育；RSPCA(2012) 建议收容所幼年犬猫 6~16 周龄绝育；**应先权衡风险和益处，有家庭的犬应尽量避免早期绝育**。
- 伦理与强制绝育法（6.7~6.8）："福利主义者"赞同绝育以减少总体伤害；"废奴主义者"以绝育防止家养动物出生。强制绝育法已见于欧洲一些区域、美国和澳大利亚，无可靠证据证明有效性；执行成本高、可能增加弃养与不登记、对低收入群体不公平。结论：兽医界开始质疑"所有不打算繁殖的犬猫都应尽早绝育"，需高质量循证信息与按个体/群体权衡利弊。', '', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'informational', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · 不同情况下对犬猫繁殖控制的建议（表 11、12）', '8. 6.9 不同情况下对犬猫繁殖控制的建议（表 11、12）

符号：RPO=有责任的宠主；++=大部分病例都建议；+=有特定适应症时可接受；-=一般不建议；*=在不允许手术绝育作为常规操作的国家可选。

**表 11 母犬猫（有家庭/收容所/流浪）繁殖控制方法建议**

| 方法 | 母犬RPO | 母犬非RPO | 收容所犬 | 流浪犬 | 母猫RPO | 母猫非RPO | 收容所猫 | 流浪猫 |
|---|---|---|---|---|---|---|---|---|
| 不干预 | ++ | - | - | - | - | - | - | - |
| 卵巢子宫切除术 | + | + | + | + | + | + | + | + |
| 卵巢切除术 | + | ++ | + | ++ | ++ | ++ | ++ | ++ |
| 子宫切除术 | + | + | + | + | - | - | - | + |
| GnRH 植入物 | + | * | * | - | + | - | - | + |

要点：犬子宫切除术可免去发情流血甚至意外怀孕，但长期副作用未很好研究，担心增加阴道脱垂风险（短头品种尤甚）；卵巢切除术适用于疾病风险较低的品种且宠主希望、或客户不太可能定期乳腺触诊者（保留卵巢须告知宠主发情与意外怀孕风险，建议每月一次乳腺触诊）；不建议为流浪犬做子宫切除术——术后短期内意外交配可致结扎阴道穹隆开裂、致命腹膜炎。GnRH 植入物可使母犬暂时不孕，但成年母犬植入后可见发情时间延长、卵巢囊肿、子宫脓肿、泌乳和行为改变，尚未列入官方适应症；母猫使用副作用小得多；除成本和宠主配合外无终生植入禁忌症。**由于幼年性腺切除术对健康存在危害，不建议用于任何性别的动物，仅限于没有其他更好替代办法的情况（如收容所）**。母猫卵巢切除术健康损害少于犬，大多数情况仍建议母猫性腺切除；子宫切除术仅建议远离人类生活的流浪猫；不育公猫可与未绝育母猫无效交配并驱避可育公猫。

**表 12 公犬猫（有家庭/收容所/流浪）繁殖控制方法建议**

| 方法 | 公犬RPO | 公犬非RPO | 收容所犬 | 流浪犬 | 公猫RPO | 公猫非RPO | 收容所猫 | 流浪猫 |
|---|---|---|---|---|---|---|---|---|
| 不干预 | ++ | - | - | - | - | - | - | - |
| 睾丸摘除术 | + | ++ | ++ | ++ | ++ | ++ | ++ | ++ |
| 输精管切除术 | ++ | + | ++ | + | - | - | - | ++ |
| 附睾切除术 | 缺乏数据 | | | | - | - | - | ++ |
| 睾丸内注射 | ++ | ++ | ++ | - | - | - | - | - |
| GnRH 植入物 | ++ | - | - | - | + | - | - | + |

注：睾丸内注射=睾丸内局部注射刺激性物质引起睾丸坏死和不育。要点：输精管切除术需宠主定期监测睾丸和前列腺疾病，不愿监测则建议睾丸摘除术；GnRH 植入物适用于仅需暂时不育者；睾丸内注射氯化钙或葡萄糖酸锌对所有公犬有效，但注射后需连续监测七天是否出现并发症——对需尽快放归的流浪群体不现实，在收容所则比手术去势更具吸引力；流浪犬多选睾丸摘除术，封闭稳定群体中输精管切除术更合适；公猫大多数情况睾丸摘除术是不二选择；睾丸内注射中断睾酮的程度可能不足以消除激素相关不良行为；常规外科手术绝育违法的国家 GnRH 植入是可行替代，需及时再次植入。', '', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'caution', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('2024 WSAVA 犬猫生殖控制指南 · 睾丸假体与切片覆盖说明', '9. 6.10 睾丸假体与切片覆盖说明

睾丸假体可减轻宠主因"主观选择去势"的情感压力、满足外貌需求；但可能误导他人判断动物生殖状态，可引起感染、排异和手术并发症，需麻醉手术；伦理上应更关注动物福祉而非人类外观喜好。文末为致谢、作者贡献（Romagnoli、Krekeler、de Cramer、Kutzler、McCarthy、Schaefer-Somi）与利益冲突声明（无）。切片 018~022 全部为参考文献条目（字母序约 A~G，自 Appleton 2001 至 Gunther 等），非正文知识，本稿不逐条收录。第 5 章章标题页与表 6 表头在译本切片中残缺（已标注"原文此处缺失"）。', '', '', '', '生殖,前列腺炎,前列腺肿瘤,肛周腺肿瘤,会阴疝,子宫蓄脓,第 4 章——猫（4.3）', 'informational', '2024 WSAVA 犬猫生殖控制指南（第二部分）：性腺切除术健康益处/危害与繁殖管理伦理（4.2末-6.10章）', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 剂量·规格·样本量·时间窗速查表（从文献题名照录）', '> 原始文档：《2024 Guidelines for the Control of Reproduction in Dogs and Cats》（2024 犬猫生殖控制指南）官方中文译本，抽取稿文件名为「（已压缩）附件：《WSAVA犬猫生殖管理指南》（中文版）250422-2」
> 本稿基于官方中文版整理。数值、剂量、百分比、药名、时间参数与文献信息一律照录原文；抽取稿的断句错乱、表格串行与 OCR 噪声照录并标注〔原文如此〕；原文缺失处标注「原文此处缺失」。一切结论以原文为准。

3. 剂量·规格·样本量·时间窗速查表（从文献题名照录）

以下数值均**原样摘自 023–033 内文献题名本身**，不是正文推荐剂量；仅作检索线索。正文剂量见 01-/02- 整理稿。', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格', '3.1 药物剂量与规格', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (2)', '| 项目 | 照录数值/表述 | 来源文献（作者, 年份） |
|---|---|---|
| deslorelin 植入物规格（公犬精液质量与不育起效） | 4.7-mg deslorelin implant | Romagnoli et al. (2012) |
| deslorelin 植入物规格（公猫精液质量与不育间隔） | 9.4 mg deslorelin implant | Romagnoli et al. (2017) |
| deslorelin 皮下植入物（公猫有效长度与植入部位） | 9.4 mg deslorelin subcutaneous implant | Romagnoli et al. (2019) |
| deslorelin 4.7 mg 植入物后续（flare up / 恢复） | a 4.7 mg deslorelin implant | Stempel et al. (2022a)、Stempel et al. (2022b) |
| 早期青春期前植入的 GnRH 激动剂剂量 | 4.7 and 9.4 mg GnRH-agonist deslorelin | Sirivaidyapong et al. (2012) |
| 醋酸甲地孕酮与 GnRH 激动剂抑制犬精子发生 | medroxyprogesterone acetate or gonadotrophin-releasing hormone agonist | Paramo et al. (1993) |
| cyproterone acetate 预防 deslorelin flare-up（双盲安慰剂对照） | cyproterone acetate | Masson et al. (2021) |
| 犬良性前列腺增生药物对比 | deslorelin acetate and osaterone acetate | Niżański et al. (2020) |
| finasteride 对犬 BPH 前列腺大小与精液质量 | finasteride | Sirinarumitr et al. (2001) |
| 长效 GnRH 激动剂延迟猫青春期 | Long-term-release GnRHagonists | Risso et al. (2012) |
| GnRH 拮抗剂 acyline 终止妊娠（两剂量对比） | two doses of the GnRHantagonist, acyline | Valiente et al. (2009a) |
| GnRH 拮抗剂对 deslorelin 植入母犬的作用 | a GnRHantagonist on GnRHagonist–implanted anestrous bitches | Valiente et al. (2009b) |
| 左炔诺孕酮 vs GnRH 拮抗剂抑制猫排卵（短期） | levonorgestrel versus a GnRHantagonist | Pelican et al. (2005) |
| melatonin 对猫精子发生 | melatonin implants | Nuñez-Favre et al. (2014) |
| 褪黑素与光照操纵（猫卵巢活动、泌乳素） | melatonin and prolactin / effect of melatonin | Leyva et al. (1989a, 1989b) |
| 睾丸内注射甘油（犬非手术绝育） | intratesticular injection of glycerol | Immegart & Threlfall (2000) |
| 睾丸内甘油注射（公猫，对比两种手术） | intratesticular glycerol injection | Madbouly et al. (2021) |
| 氯化钙单侧睾丸内注射（公猫非手术绝育） | single intra-testicular injection of calcium chloride | Jana & Samanta (2011) |
| 氯化钙剂量梯度研究（黑孟加拉山羊） | single intratesticular injection of calcium chloride … a dose-dependent study | Jana, Samanta & Ghosh (2005) |
| 氯化钙醇溶剂配方（犬） | Alcohol diluent … calcium chloride | Leoci et al. (2014a) |', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (3)', '| 氯化钙生理盐水剂量探索长期研究 | calcium chloride in saline solution … most effective concentration with the lowest risk | Leoci et al. (2014b) |
| 氯化钙睾丸内 vs 附睾内注射 | intratesticular vs intraepididymal calcium chloride sterilant | Leoci et al. (2019) |
| 氯化钙+二甲基亚砜（犬化学绝育） | Calcium chloride combined with dimethyl sulphoxide | Silva et al. (2018) |
| 锌基溶液（猫，随机临床试验） | Intratesticular injection of a zinc-based solution | Oliveira et al. (2013) |
| 葡萄糖酸锌睾丸内注射（成年犬初报） | intratesticular administration of zinc gluconate | Rafatmah et al. (2019) |
| 葡萄糖酸锌+DMSO（犬临床、内分泌与生殖参数） | zinc gluconate and dimethyl sulfoxide | Vannucchi et al. (2015) |
| Neutersol（犬睾丸内注射绝育） | Neutersol: intratesticular injection induces sterility in dogs | Wang (2002) |
| 附睾尾部硬化剂注射致无精 | injection of sclerosing agents into the caudae of the epididymides | Pineda et al. (1977) |
| GnRH 免疫避孕（公猫） | GnRHimmunocontraception of male cats | Levy et al. (2004) |
| GonaCon™ 长期控制母猫生育 | GonaConTM, a GnRHimmunocontraceptive | Levy et al. (2011) |
| GonaCon™ 猫单次与重复肌注 | single and repeat intramuscular injection of a GnRHvaccine (GonaConTM) | Vansandt et al. (2017) |
| GonaCon™ 与狂犬病疫苗犬同期接种 | Concomitant administration of GonaConTM and rabies vaccine | Vargas-Pino et al. (2013) |
| GonaCon™ 与狂犬疫苗联合免疫（流浪母猫短期安全性） | combined vaccination with anti-GnRH (Gonacon) and rabies vaccines | Novak et al. (2021) |
| Improvac 用于家猫免疫避孕 | Immunocontraception of male domestic cats using GnRHvaccine Improvac | Ochoa et al. (2023) |
| 猪带卵膜免疫避孕母犬 | active immunization with porcine zonae pellucidae | Mahi-Brown, Huang & Yanagimachi (1982)；组织病理见 Mahi-Brown et al. (1988) |
| 重组犬 ZP2/ZP3 免疫避孕 | recombinant dog ZP2 and ZP3 in a homologous animal model | Srivastava et al. (2002) |
| 重组猪带卵蛋白+犬 ZP3 片段与 GnRH 融合蛋白避孕 | recombinant porcine zona proteins and fusion protein encompassing canine ZP3 fragment and GnRH | Gupta et al. (2022) |
| GnRH-犬瘟热病毒 T -helper p35 免疫去势 | GnRH-canine distemper virus (CDV) T helper cell epitope p35 | Jung et al. (2005) |', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (4)', '| 抗 LHRH 活性疫苗 | active immunization against luteinizing hormone-releasing hormone | Ladd et al. (1994) |
| 猫 zona pellucida 抗原谱 | Survey of zona pellucida antigens for immunocontraception of cats | Levy et al. (2005) |
| 猫附睾精子质量与血清睾酮（自然光照周期） | natural photoperiod on epididymal sperm quality and testosterone | Nuñez-Favre et al. (2012) |
| 猫非繁殖季/繁殖季血浆激素与精液质量 | Plasma hormone levels and semen quality … non-breeding and breeding seasons | Tsutsui et al. (2009) |
| 醋酸甲地孕酮长期给药母猫病理异常 | long-term administration of medroxyprogesterone acetate in a queen | Keskin et al. (2009) |
| 醋酸甲地孕酮长期治疗犬 CEE/子宫内膜炎 | prolonged treatment of medroxyprogesterone acetate | Kim & Kim (2005) |
|  depot MPA 单针后猫乳腺纤维上皮性增生 | following a single injection of depot medroxyprogesterone acetate | Loretti et al. (2005) |
| 甲地孕酮处理猫乳腺形态学变化（3 只公猫 MPA 暴露 1990–2006） | megestrol acetate-treated … retrospective study；Mammary adenocarcinomas in three male cats exposed to medroxyprogesterone acetate (1990–2006) | Hayden et al. (1989)；Jacobs et al. (2010) |
| 合成孕激素长期抑制犬猫发情 | long-term administration of synthetic progestational steroids | Harris & Wolchuk (1963) |
| 甲地孕酮控制猫发情 | Megestrol acetate for control of estrus in the cat | Houdeshell & Hennessey (1977) |
| 甲地孕酮口服推迟猫发情 | oral administration of megestrol acetate to postpone oestrus | Oen (1977) |
| 醋酸甲地孕酮对猫糖耐量与生长激素 | Effects of megestrol acetate on glucose tolerance and growth hormone secretion in the cat | Peterson (1987) |
| MPA 或 GnRH 激动剂抑制犬精子发生 | medroxyprogesterone acetate or gonadotrophin-releasing hormone agonist | Paramo et al. (1993) |
| 犬 BPH：deslorelin vs osaterone 临床效果对比 | deslorelin acetate and osaterone acetate | Niżański et al. (2020) |
| 环磷酰胺相关膀胱移行细胞癌（犬） | Transitional cell carcinoma of the bladder associated with cyclophosphamide administration | Macy, Withrow & Hoopes (1983)；Weller, Wold & Dyjido (1979) |
| 十一酸睾酮治疗公犬尿失禁（临床反应与副作用） | testosterone cypionate for urinary incontinence in male dogs | Palerme et al. (2017) |', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 药物剂量与规格 (5)', '| 雌激素治疗犬阴道脱垂（首例报告） | First report of vaginal prolapse in a bitch treated with oestrogen | Sarrafzadeh-Rezaei et al. (2008) |
| deslorelin 与内镜宫颈人工授精诱导猫首次分娩 | First deliveries after estrus induction using deslorelin and endoscopic transcervical insemination in the queen | Zambelli et al. (2015) |
| aglepristone 治疗猫纤维腺瘤病（14 例） | Treatment of fibroadenomatosis in 14 cats with aglepristone | Jurka & Max (2009) |
| 孕激素拮抗剂治疗猫乳腺纤维腺瘤性增生 | Treatment of feline mammary fibroadenomatous hyperplasia with a progesterone-antagonist | Wehrend, Hospes & Gruber (2001) |
| aglepristone（Alizine）治疗猫乳腺纤维上皮性增生（德文） | Der Progesteronantagonist Aglépristone (Alizine) | Meisl, Hubler & Arnold (2003) |', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数', '3.2 样本量·病例数·时间参数·器械参数', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (2)', '| 项目 | 照录数值 | 来源文献（作者, 年份） |
|---|---|---|
| 犬卵巢子宫切除术并发症（1880 头） | Complications of ovariohysterectomy procedures performed in 1880 dogs | Muraro & White (2014) |
| 猫卵巢蒂结扎并发症（15,927 猫） | few complications of ovarian pedicle tie in 15,927 cats undergoing ovariohysterectomy at a large HQHVSN clinic and training facility in the United States: 2017–2018 | Rigdon-Brestle et al. (2022) |
| 犬会阴疝修补围手术期数据（100 犬） | Perineal herniorrhaphy: perioperative data from 100 dogs | Hosgood et al. (1995) |
| 犬前列腺疾病研究（177 例，1981-1986） | Study of prostatic disease in dogs: 177 cases (1981-1986) | Krawiec & Heflin (1992) |
| 犬前列腺炎与前列腺脓肿（82 例） | Prostatitis and prostatic abscessation in dogs: retrospective study of 82 cases | Lea et al. (2022) |
| 犬睾丸肿瘤回顾（12 年） | A 12-year retrospective study of canine testicular tumors | Liao et al. (2009) |
| 犬猫术后伤口感染率（教学医院数据） | Surgical wound infection rates in dogs and cats. Data from a teaching hospital | Vasseur et al. (1988) |
| 犬猫肿瘤发生频率（一定义群体） | Frequency of canine and feline tumors in a defined population | MacVean et al. (1978) |
| 犬膀胱尿道肿瘤回顾（115 例，1980–1985） | Canine bladder and urethral tumors: a retrospective study of 115 cases (1980–1985) | Norris et al. (1992) |
| 犬肛门袋腺癌（113 例，1985-1995） | Carcinoma of the apocrine glands of the anal sac in dogs: 113 cases (1985-1995) | Williams et al. (2003) |
| 猫卵巢子宫切除侧腹 approach（72 例） | Bilateral flank ovariectomy in the dogsurgical technique and sequelae in 72 animals〔"dog" 后缺空格，原文如此〕 | Janssens & Janssens (1991) |
| 猫隐睾与单睾（25 例） | Cryptorchidism and monorchidism in cats: 25 cases | Millis, Hauptman & Johnson (1992) |
| 猫自发性股骨近端骨骺骨折（26 例，1996-2001） | Spontaneous femoral capital physeal fractures in adult cats: 26 cases (1996-2001) | McNicholas et al. (2002) |
| 猫传腹特定品种流行率 | Prevalence of feline infectious peritonitis in specific cat breeds. Journal of Feline Medicine and Surgery, 8, 1–5 | Pesteanu-Somogyi, Radzai & Pressler (2006) |', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (3)', '| 迷你腹腔镜犬 OHE（体重 <5 kg） | Laparoscopic ovariohysterectomy for dogs under 5 kg body weight | Matsunami (2022) |
| 犬腹腔镜充气压对门静脉压影响（前瞻性随机） | effects of laparoscopic insufflation pressures on portal pressures in dogs | Parlier et al. (2024) |
| 犬右侧腹壁小切口 OHE | a right flank, mini-laparotomy approach to canine ovariohysterectomy | Reece et al. (2012) |
| 超声刀腹腔镜 OHE vs 正中开腹疼痛对比 | harmonic scalpelâ€assisted laparoscopy compared with median celiotomy and ligation〔编码噪声，原文如此〕 | Hancock et al. (2005) |
| 电刀 vs 冷刀开腹失血（RCT） | Electrosurgery reduces blood loss and immediate postoperative inflammation compared to cold instruments for midline celiotomy in dogs: a randomized controlled trial | Meakin et al. (2017) |
| 腹腔镜 OHE 卵巢蒂止血三技术比较 | Comparison of three techniques for ovarian pedicle hemostasis during laparoscopic-assisted ovariohysterectomy | Mayhew & Brown (2007) |
| 6 种摩擦结首结保持力（体外） | In vitro holding security of six friction knots used as a first throw in the creation of a vascular ligation | Hazenfield & Smeak (2014) |
| OHE 蒂部结扎技术体外研究 | Pedicle ligation in ovariohysterectomy: an in vitro study of ligation techniques | Leitch et al. (2012) |
| square vs Aberdeen 结（4-0 polyglyconate，犬尸体） | Comparison of volume, security, and biomechanical strength of square and Aberdeen termination knots tied with 4-0 polyglyconate | Regier et al. (2015) |
| 缝线线结组织反应（尺寸/构型/体积） | Tissue reaction and surgical knots: the effect of suture size, knot configuration, and knot volume | van Rijssel et al. (1989) |
| 尼龙索带（cable band）卵巢切除后反应 | Nylon cable band reactions in ovariohysterectomized bitches | Werner, Straughan & Vezin (1992) |
| 悬韧带锐性切断 vs 手指颤拽 | Sharp transection of the suspensory ligament as an alternative to digital strumming during canine ovariohysterectomy | Shivley et al. (2019) |
| 缝合减血清肿与术后 24 h 疼痛（RCT） | A quilting subcutaneous suture pattern to reduce seroma formation and pain 24 hours after midline celiotomy in dogs: a randomized controlled trial | Travis et al. (2018) |', 'dog', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (4)', '| 猫 flank vs 正中开腹卵巢切除围术期前瞻对比 | Prospective comparison of perioperative wound and pain score parameters in cats undergoing flank vs midline ovariectomy | Swaffield, Molloy & Lipscomb (2019) |
| 单极 vs 双极电凝腹腔镜犬卵巢切除 | Monopolar versus bipolar electrocoagulation in canine laparoscopic ovariectomy: a nonrandomized, prospective, clinical trial | Van Goethem, Rosenveldt & Kirpensteijn (2003) |
| 双极血管封闭装置犬去势 | Use of a bipolar vessel sealing device in canine orchiectomy | Kanca & Yaman (2022) |
| 腹腔镜去势双极钳 vs 开放去势犬 | Laparoscopic castration using bipolar forceps vs. orchiectomy in dogs: a comparison of two techniques | Tavares et al. (2021) |
| 双极电凝止血开放手术应用 | The uses of bipolar electrosurgical forceps for haemostasis in open surgical ovariectomy of bitches and queens and castration of dogs | Watts (2018) |
| 吻合器与血管封闭器械 | Facilitation of soft tissue surgery: surgical staplers and vessel sealing devices | Peycke (2015) |
| 腹腔镜辅助结肠固定+绝育公犬 | Laparoscopic-assisted colopexy and sterilization in male dogs: short-term results and physiologic consequences | Mathon et al. (2011) |
| 犬猫子宫内避孕装置致穿孔机制（实验） | Investigation of the mechanism of perforation of an intrauterine device in pigs and dogs | Larsson et al. (1981a, 1981b)；犬宫腔 IUD 避孕：Volpe et al. (2001) |
| 犬腹腔镜单/三孔脾切除对比 | Comparison between single and three portal laparoscopic splenectomy in dogs〔非生殖对照技术条目〕 | Khalaj et al. (2012) |
| 犬腹腔穿刺入路与镜下基础技能 | Access, port placement, and basic endosurgical skills | Kolata & Freeman (1999) |
| 犬猫生殖道手术（教科书章节） | Surgery of the reproductive tract. In: Small animal surgery, 2nd edition, pp. 610–673 | Hedlund (2002) |
| 猫手术与化学输精管结扎 | Surgical and chemical vasectomy in the cat. American Journal of Veterinary Research, 45, 291–300 | Pineda & Dooley (1984) |
| 犬输精管结扎后精液精子消失 | Disappearance of spermatoza〔原文如此，拼写〕 from the ejaculates of vasectomized dogs | Pineda et al. (1976) |
| 犬结扎后精子快速消失 | Rapid disappearance of spermatozoa after vasal occlusion in the dog | Schiff et al. (2003) |', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (5)', '| 犬猫输精管结扎（传统术式与腹腔镜） | Traditional surgical and laparoscopic vasectomy in dogs and cats | McCarthy (2019) |
| 犬血管内凝固闭塞（便携式装置） | Use of a portable battery-operated apparatus for occlusive intraluminal vas fulguration in dogs | Rao et al. (1980) |
| 犬附睾高强度聚焦超声消融（潜在绝育替代） | High-intensity focused ultrasound ablation of the vas deferens / epididymis in a canine model: a potential alternative to vasectomy | Roberts et al. (2002a, 2002b)；治疗超声犬避孕方案：Leoci et al. (2015) |
| 犬睾丸血供与性激素合成 | Role of the spermatic artery in spermatogenesis and sex hormone synthesis | Hsu et al. (1993) |
| 犬阴囊去势 vs 阴囊前去势（对照） | Scrotal castration versus prescrotal castration in dogs | Woodruff et al. (2015) |
| 幼龄/少年犬无切口阴囊去势 | Evaluation of sutureless scrotal castration for pediatric and juvenile dogs | Miller et al. (2018) |
| 隐睾摘除误切前列腺（4 犬） | Inadvertent prostatectomy as a complication of cryptorchidectomy in four dogs | Schultz et al. (1996) |
| 隐睾犬猫去势技术 | A technique for castrating the cryptorchid dog or cat | Kirby (1980) |
| 输尿管损伤处理（OHE 并发症） | Treatment and outcomes of ureter injuries due to ovariohysterectomy complications in cats and dogs | Plater & Lipscomb (2020) |
| 输尿管梗阻管理 | Management of ureteral obstruction | Hardie & Kyles (2004) |
| 单侧输尿管梗阻后功能恢复 | Recovery following complete chronic unilateral ureteral occlusion / Unilateral ureteral occlusion: pattern of nephron repair and compensatory response | Vaughan & Gillenwater (1971)；Vaughan et al. (1973) |
| 犬猫腹膜内与切口镇痛 | Intraperitoneal and incisional analgesia in small animals: simple, cost-effective techniques | Steagall et al. (2020) |
| 健康非肥胖母犬腹腔镜卵巢切除自发通气 | Healthy nonobese bitches maintain acceptable spontaneous ventilation during laparoscopic ovariectomies | Merlin, Cinti & Charlesworth (2022) |', '', 'young', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'caution', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 样本量·病例数·时间参数·器械参数 (6)', '| 腹腔镜 vs 开腹绝育母犬尿失禁流行率与严重度配对队列 | Do prevalence rates and severity of acquired urinary incontinence differ between dogs spayed by laparoscopy or laparotomy? Comparing apples with apples with a matched-pair cohort study | Lutz, Hartnack & Reichler (2020) |
| 睾丸假体（现代） | The modern testicular prosthesis: patient selection and counseling, surgical technique, and outcomes | Hayon, Michael & Coward (2020) |
| 犬硅胶睾丸假体（Neuticles） | Silicon prosthesis Neuticles as a testicle substitution in a dog | Itze (2010) |
| 卵巢切除犬胃壁卵巢自体移植 | Ovarian autograft as an alternative to ovariectomy in bitches / thyroid status in bitches bearing ovarian autotransplants in the stomach wall | Le Roux & Van Der Walt (1977)；Le Roux (1983) |', 'dog', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 时间与年龄段参数（内嵌于题名）', '3.3 时间与年龄段参数（内嵌于题名）

| 项目 | 照录表述 | 来源文献 |
|---|---|---|
| 猫去势与骨骺闭合时间 | Castration and physeal closure in the cat | Houlton & McGlennon (1992) |
| 隐睾犬 1–2 岁睾丸特征 | Characteristics of cryptic/ectopic and contralateral scrotal testes in dogs between 1 and 2years of age〔"1 and 2years" 原文如此〕 | Veronesi et al. (2009) |
| GnRH 激动剂处理 23 个月后性腺功能恢复 | Normal gonadal functions and fertility after 23 months of treatment of prepubertal male and female dogs with the GnRHagonist | Lacoste et al. (1989) |
| deslorelin 植入 7 月后公猫无精与组织学 | Azoospermia with variable testicular histology after 7 months of treatment with a deslorelin implant in toms | Novotny et al. (2015) |
| deslorelin 长期应用 6 例（2005-2022） | Chronic use of deslorelin in dogs: six cases (2005-2022) | Romagnoli et al. (2023) |
| 妊娠足月母犬麻醉体位影响 | Postural influence on systemic blood pressure, gas exchange, and acid/base status in the term-pregnant bitch during general anesthesia | Probst & Webb (1983)；Probst et al. (1987) |
| 决定到分娩时间对剖宫产胎儿死亡率影响 | Impact of decision to delivery time of fetal mortality in canine caesarean section in a referral population | Proctor-Brown et al. (2019) |
| 母犬绝育时机（相对青春期）对行为的影响：范围综述 | Effect of neutering timing in relation to puberty on female dog behaviour-a scoping review. The Veterinary Record, 193, e2882 | Moxon et al. (2023)（题录照 027 抽取） |
| 母犬青春期前 vs 青春期后绝育行为发育（前瞻队列，导盲犬基地） | A prospective cohort study investigating the behavioural development of bitches in a guide dog training programme neutered prepubertally or post-pubertally. Frontiers in Veterinary Science, 9, 902775 | Moxon et al. (2022) |
| 犬 CEH 超声流行率与年龄关系（含月龄参数） | Prevalence of ultrasound-determined cystic endometrial hyperplasia and the relationship with age in dogs. Theriogenology, 86, 976–980 | Moxon et al. (2016) |
| 犬猫年龄绝育决策 35 品种 | Assisting decision-making on age of neutering for 35 breeds of dogs: associated joint disorders, cancers, and urinary incontinence | Hart et al. (2020) |', '', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'caution', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 抽取噪声与缺失说明', '6. 抽取噪声与缺失说明

6.1 嵌入正文的页码标记

抽取稿在参考文献段内嵌入了原 PDF 的页眉/页脚残留文本，共出现 `管理指南153`、`155`、`157`、`159`、`161`、`163`、`165`、`167`、`169`、`171`、`173`（依次为原书第 153–173 页，奇数页），它们被直接接排进条目中间，转录时保留在原位置并单独成条说明。其中 `管理指南171` 落在 Urfer et al. (2019) 的题名内部，`管理指南173` 落在 Wiebe 与 Wildt 两条之间。

6.3 项目符号「·」缺失

抽取稿中多数条目以「·」起头，但下列条目在原文行内即缺少首「·」（照录，不改；逐条标注见第 4 节对应分块小节）：

- 023：Herron, M. (1983)
- 025：Krzyżewska-Młodawska et al. (2014)、Levy et al. (2005)、Lincoln et al. (2005)
- 026：MacDougall (2003)、Mantziaras et al. (2017)
- 027：Misdorp (2004)、Novak et al. (2021)
- 028：Palerme et al. (2017)、Palm & Reichler (2012)、Palmieri et al. (2022)、Panciera (1994)、PETA (2023)、Peterson, M.E. et al. (1996)
- 029：Power et al. (1998)、Richards et al. (2001)
- 030：Salt et al. (2019)、Schäfer-Somi (2017)、Skerritt (1975)
- 031：Teale (1972)

相反，另有若干条目在抽取稿中已带「·」，整理稿不额外标注（如 Hoad 2018、Millis、Misdorp 1988/2004 之外的 Misdorp 条目、Norris、Vet Record 2023、Watts、Spain 2004a/2004b）。

「·」被错插到条目文本内部的位置（照录）：Root et al. (1996)「in the ·domestic cat」、Veiga et al. (2008)「C-reactive ·protein」、Yam et al. (2016)「. ·Preventive Veterinary Medicine」、Sackman (2012)「·St. Loius, MO」、Hancock (2005)「harmonic ·scalpelâ€assisted」，以及 023–029 各小节中标注的同类插断。', 'cat', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 拼写与编码噪声（照录清单）', '6.4 拼写与编码噪声（照录清单）

- 连写类：`GnRHagonist`、`GnRHantagonist`、`GnRHanalogue`、`GnRHvaccine`、`GnRHimmunocontraception`、`G n RH-agonist`（Sirivaidyapong et al. 2012）、`coliexpressed`（Srivastava et al. 2002）、`immunemediated`（Weinkle et al. 2005）、`148,346`（Wehrend et al. 2001）、`1 and 2years`（Veronesi et al. 2009）、`dog` 与 `surgical` 粘连的 `dogsurgical`（Janssens & Janssens 1991）。
- 拼写/字符类：`memmary`、`spermatoza`（Pineda et al. 1976）、`St. Loius`（Sackman 2012）、`Hyperlasie`、`Vorund`、`Acrosssectional`、`estrogensecreting`、`Labradorand`（Lauber et al. 2012）、`Vetrinary`/`Open Vetrinary Journal`（Munif et al. 2022）、`pseudo-placentational`（Schlafer & Gifford 2008）、`Sundburg`（Sundburg et al. 2016）、`Neãas`（Zatloukal et al. 2005）、`tomcat`（Lapshin & Kondratova 2015）、`McV Messam`（Torres de la Riva et al. 2013）、`Stornelli, M.` 作者重复（Stornelli et al. 2009）、`Werhahn Beining` 复合姓氏。
- 串行/错位类：`V ·eronesi`（032，应为 Veronesi，姓氏首字母被拆到上一行行首）；`·` 后紧跟空格再换行的断行（Herron 1983、Hoad 2018、Houlton、Kustritz & Rudolph、Levy 2005、Lincoln、Misdorp 2004、Leoci 系列、Millis、Norris、Richards、Palm & Reichler、Palmieri、Panciera 等，多数条目首「·」尚在但条目被换行切成两段）。
- 卷/页照录异常：Sinibaldi & Greene (1973) 卷号「9」、Weller et al. (1979) 卷号「5」、Waters et al. (1989) 卷号「3」、Zink et al. (2023) 卷号「1」、Woodruff et al. (2015) 卷号「110」、Swaffield et al. (2019) 年 2019/卷 22 等，均按抽取稿原样照录，未订正。', 'dog', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('WSAVA犬猫生殖控制指南2024-第三部分 · 链接与网址断裂', '6.5 链接与网址断裂

抽取稿中 URL 多处被空格断开：`https:// kb.rspca.org.au/…Aug-2012. pdf`（029→030）、`https://doi.org/10.3390/ ani12192545`（Stempel 2022b）、`https://www.g2z.org.au/pdf/ Whatproportionofvetclinic sofferearlyagedesexing-Researchinonelargecity.pdf`（Verrinder 2011）、`https://www.peta.org/ issues/…/eutha nasia/`（PETA 2023）、`https://towardsdatascience.com/saving-animallives-with-data-d815c6e854eb`（Yadhunath 2021，连写）、RSPCA (2024) 条目中的 `#: ~:text=` 高亮片段。

6.6 本稿范围内的缺失与不可检索项

- 023 起始处第一条只保留了年份之后的题名与出处（「(2022) Reduction of free-roaming cat population requires high-intensity neutering in spatial contiguity to mitigate compensatory effects. Proceedings of the National Academy of Sciences, 119, e2119000119.」），其作者段位于上游分块 022 末尾（「·Gunther, I., Hawlena, H., Azriel, L. & Klement, E.」）；该拼接关系已在第 2 节登记，但 022 本身不在本稿范围，故不在第 4 节重复转录。
- 抽取稿未包含任何原文正文段落，因此 023–033 内**不含**药物剂量用法、手术操作步骤、并发症百分比等正文数据；第 3 节所有数值均来自文献题名与出处本身。正文数据请查 `01-`/`02-` 整理稿（分块 001–022）。
- 个别条目仅有编者或期刊名而无题名（如 Slatter 2003 以「In:」起、Vet Record 2023 以期刊名署名、Wang 2002 为会议论文集、Smeak 2019 为大会报告、Lapshin & Kondratova 2015 出处为行业杂志且无卷页），此类条目按原样照录，无法补齐的信息为「原文此处缺失」。', 'cat', '', '', '生殖,参考文献,GnRH 激动剂,deslorelin,4.7 mg 植入物,9.4 mg 植入物,抽取噪声与缺失说明', 'informational', 'WSAVA犬猫生殖控制指南2024-第三部分：参考文献（G–Z）与中英文对照表', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 引言（第 1 章）与使用说明', '> 来源机构：World Small Animal Veterinary Association（WSAVA，世界小动物兽医协会）生殖控制委员会（Reproduction Control Committee），与其他 WSAVA 委员会及国际利益相关方协作制定。
> 原始文档：《WSAVA Guidelines for the Control of Reproduction in Dogs and Cats — Executive Summary》（2024，9 页，纯文本抽取 23,923 字符，无需 OCR；原文 PDF：<https://wsava.org/wp-content/uploads/2024/06/Executive-Summary.pdf>；本地文件 `pdf/Executive-Summary.pdf`；原文抽取稿 `raw_extracts/Executive-Summary.md`）。
> 本稿为中文整理稿（digest），逐条覆盖执行摘要的全部推荐要点；数值、药名、术语与推荐措辞一律照录原文，不作改动、不补入摘要之外的内容。执行摘要按章节顺序组织（第 1～6 章及「不同情境下的推荐」），本稿沿用该结构并保留原始章节号。

1. 引言（第 1 章）与使用说明

1.1 指南目标与范围

WSAVA 生殖控制委员会（Reproduction Control Committee）与其他 WSAVA 委员会及国际利益相关方协作，就下列主题编写本指南：手术与非手术绝育（surgical and nonsurgical approaches to sterilisation）途径、去势术（gonadectomy）的健康获益与风险，以及猫犬生殖控制的伦理（ethics of reproductive control）。

板块页对指南的定位（原文措辞）：帮助 WSAVA 成员在患者的生殖管理上作出循证选择，同时保障动物福利、支持人—伴侣动物纽带；涵盖现行实践的讨论，并解释较新的手术与非手术方法，同时探讨每种方法的健康利弊与伦理问题。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 关于「推荐等级」的说明', '1.2 关于「推荐等级」的说明

原文执行摘要未采用形式化的证据分级体系（如 A/B/C 级或 GRADE 分层），而是以定性措辞表达推荐强度。本稿在逐条整理时保留原文措辞，常见措辞包括（原文照录）：`preferred`（首选）、`recommended`／`strongly recommended`（推荐／强烈推荐）、`is the treatment of choice`（为首选治疗）、`obligatory`（必须）、`should`／`should be avoided`（应当／应当避免）、`may be considered`／`may be an option`（可考虑／可为选项）、`discouraged`（不鼓励）等。原文此处缺失可对应的量化等级标记。

2. 犬猫手术绝育（第 2 章）

2.1 总原则与术者经验

原文列举了多种犬猫绝育的手术入路与术式；作者强调这并非对兽医可利用的全部选择的描述，而是对「可行做法」的综述。当术者对某方法既有经验又有成功案例时，采用其细微差别与变体是合适的。经验不足的术者应认识到：在任何手术绝育操作中，暴露不充分（inadequate exposure）是并发症的主要原因。

原文特别点出的较新手术绝育方法：犬的阴囊入路（scrotal approach for male dogs）、幼年（pediatric）公犬的精索自体结扎（autoligation of the cord）、母猫的卵巢血管柄自体结扎（autoligation of the ovarian pedicle in female cats）。

2.2 母犬术式的解剖学命名（OE / SOHE / OHE）

编者们刻意将母犬绝育的手术选择划分为三种，并使用解剖学上正确的术语以避免混淆：

| 缩写 | 全称（English） | 中文 |
|---|---|---|
| OE | ovariectomy | 卵巢切除术 |
| SOHE | subtotal ovariohysterectomy | 次全卵巢子宫切除术 |
| OHE | ovariohysterectomy | 卵巢子宫切除术 |

原文关键论点：许多教科书描述、且被绝大多数兽医实际采用的做法是把结扎线放置在子宫颈的子宫侧（uterine side of the cervix），这种做法不可避免地会把子宫远端部分（distal portion of the uterus）留在患体内；因此该术式属于 SOHE，而非 OHE。虽然看似琐碎，但当讨论保留性腺手术（gonad sparing surgery）时，两种术式的区别就变得至关重要。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 委员会立场：OE 为首选', '2.3 委员会立场：OE 为首选

原文表述（推荐措辞照录）：作为委员会，我们认为——当选择「丧失性腺激素的手术绝育」且不存在子宫病变（in the absence of uterine pathology）时，卵巢切除术（OE）是首选术式（preferred procedure）。OE 提供其他术式的全部获益，速度更快、切口更小、潜在并发症更少。

2.4 设备与结扎技术

现代外科技术极大地促进了无创伤、成功的绝育手术。原文最低设备要求：兽医术者至少应配备一台现代电外科设备（modern electrosurgery unit）、血管夹（vascular clips）以及一种提供局部止血（topical haemostasis）的方法。

结扎方式的再评估：以「外科结（surgeon''s knot）」起始血管结扎线的常见做法正在被重新评估。外科结倾向于过早地绑定或「锁死」（bind or "lock up" prematurely），使术者误以为结已足够收紧而实际未收紧。双股摩擦结（two pass friction knots）——如 miller''s 结、constrictor 结、strangle 结——可能更可取，尤其对经验不足的术者。血管熔合（vessel fusion）及类似设备极大促进了手术绝育，但仍然昂贵（remain expensive）。

2.5 围产期母犬（periparturient bitch）

原文设专门章节讨论围产期母犬的手术绝育。据作者所知，没有证据表明——在使用现代麻醉方法的前提下——于分娩新生仔后同期施行 SOHE，或立即施行整块（en-bloc）子宫切除术，会增加母体风险。

2.6 微创腹腔镜入路

原文所述多数手术绝育术式，既可开腹（open laparotomy）完成，也可用微创腹腔镜（minimally invasive laparoscopic）入路完成。微创手术疼痛更轻、创口并发症更少，并提供更好的视野（improved visualization），在较大体型患犬中尤为明显。饲主对腹腔镜手术的熟悉催生了以该方法进行绝育的大量需求；在其可获得且费用不至于高不可攀时，腹腔镜为首选（preferred when available and not cost prohibitive）。', 'dog', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 手术部位感染与抗菌药预防', '2.7 手术部位感染与抗菌药预防

手术部位感染（surgical site infections, SSI''s）是接受绝育手术的兽医患者的重要关切，但关于抗菌药预防（antimicrobial prophylaxis）的数据有限且相互矛盾。抗菌药耐药性（antimicrobial resistance）是人医与兽医共同的重大问题，抱着「用它又不会有害（it can''t hurt）」的前提使用抗菌药是完全错误的（patently wrong）。

原文推荐（措辞照录）：在常规绝育手术中——只要手术持续时间短、在清洁环境中进行、且不存在其他促感染因素——应当避免（should be avoided）抗菌药预防。若确实使用预防用药，应选用可获得的最安全、静脉给药、低毒性、低成本的抗菌药。药物必须在手术前 2 小时内给予（given in the two hours before surgery），且手术后给药不得超过 24 小时（not administered beyond 24 hours after the procedure）。

2.8 疼痛管理

原文表述：所有手术操作都有疼痛，在任何情形下都必须（mandatory）提供充分的镇痛。用于手术绝育的可接受镇痛方案很多，镇痛方案的选择因手术实施的物理地点（医院 vs. 现场，hospital vs. field）、手术创伤程度、患者年龄与健康状况、特定药物的可获得性以及术者对所用药物的熟悉程度而异。手术疼痛管理始于手术之前、维持贯穿整个手术过程并延续至术后。优先采用多模式疼痛管理（multimodality management of pain）。局部麻醉技术（local anaesthetic techniques）尤为合适，因为它们可在不引起全身性副作用的情况下提供出色的镇痛。

3. 犬猫非手术绝育（第 3 章）

3.1 需求来源

原文说明：手术绝育常用于犬猫生殖控制，但并非所有饲主都希望宠物接受手术绝育；此外手术绝育成本高、需要专业技术与设备，且在世界各地并非随处可得。基于这些原因，人们期望有非手术（non-surgical）的犬猫生殖控制替代方案。非手术绝育可通过激素下调（hormonal downregulation）、免疫避孕（immunocontraceptives）、化学去势（chemical castration）和基因治疗（gene therapy）实现。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 激素下调', '3.2 激素下调

使用促性腺激素释放激素（gonadotropin-releasing hormone, GnRH）激动剂（deslorelin，地洛瑞林）或生殖类固醇激素（孕激素 progestogens 或雄激素 androgens）的激素下调治疗，通过负反馈（negative feedback）可逆地关闭下丘脑—垂体—性腺轴（hypothalamic-pituitary-gonadal axis）。

地洛瑞林植入剂：皮下（subcutaneous）deslorelin 植入剂有两种剂量规格（原文数值）——4.7 mg 与 9.4 mg，其有效期长度分别为至少 6 个月（six months）和 12 个月（twelve months）。deslorelin 植入剂的标示适应症因国家而异，包括在公犬与公猫以及青春期前母犬中诱导可逆性不育。

孕激素与雄激素：数十年来已被用于推迟母犬与母猫的发情（oestrus postponement）。其疗效与不良反应取决于所给类固醇种类、剂量、治疗相对于发情周期阶段（stage of the oestrous cycle）的时机、治疗方案，以及动物的年龄、生殖健康与全身健康状况。

3.3 免疫避孕（GnRH 疫苗）

通过 GnRH 疫苗接种产生的免疫避孕，可生成结合内源性 GnRH 的抗体滴度（antibody titres），从而抑制促性腺激素——促黄体素（luteinizing hormone, LH）与促卵泡素（follicle stimulating hormone, FSH）——的合成与分泌。由于 GnRH 天然不具备免疫原性，GnRH 疫苗通过钥孔血蓝蛋白（keyhole limpet hemocyanin）或白喉毒素（diphtheria toxin）偶联来增强抗原性。商品化 GnRH 疫苗对公母犬猫均有效，但这种有效性持续时间短、需要多次注射，从而限制了该方法在流浪动物与大规模种群控制中的用途。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 化学去势', '3.4 化学去势

使用睾丸内注射（intratesticular injection）或附睾内注射（intraepididymal injection）对公犬公猫进行化学去势，可诱导无精症（azoospermia），并因所注入的化学制剂不同而使睾酮浓度出现不同程度的下降。睾丸内注射技术上不具挑战性、无需全身麻醉、成本低廉，适合大规模绝育项目。附睾内注射可注入附睾尾部或头部（tail or head of the epididymis），可能需要全身麻醉与超声引导，在公猫中尤甚。睾丸内与附睾内注射仅产生最少的痛感体征，因为与痛觉相关的传入神经末梢位于阴囊皮肤，而非睾丸或附睾实质内。但若操作不当，可能出现局部与全身性不良反应。此外，尚无关于睾丸内或附睾内注射作为犬或公猫非手术绝育选项的长期安全性与有效性研究。

3.5 基因治疗

基因治疗可用于沉默一个基因或诱导其过表达。基因沉默的机制可用 RNA 干扰（RNA interference）、小干扰 RNA（small interfering RNAs, siRNAs）或使用 CRISPR/cas9 的基因编辑实现。该领域大多数研究仍限于体外细胞或啮齿类模型；但有一项在猫中开展的研究，使用腺相关病毒（adeno-associated virus, AAV）成功沉默了下丘脑神经元中的 Kiss1 基因。与基因沉默类似，基因过表达方面的大多数研究也限于体外细胞或啮齿类模型；不过，使用 AAV 递送系统、经单次肌内注射（single intramuscular injection）在母猫中持续过表达抗缪勒管激素（anti-Müllerian hormone），可在两年以上时间内阻止排卵与妊娠，但并未损害雌二醇分泌（oestradiol secretion）或发情周期（oestrous cyclicity）。

4. 绝育并丧失性类固醇激素的健康获益与损害（第 4、5 章）

4.1 总体立场与个体化评估

丧失性类固醇激素的绝育既带来健康获益也带来健康损害。本章节既不鼓吹也不反对去势术，而是讨论在特殊情形下、以及在何种年龄段是否可推荐去势术或激素下调。健康获益或损害受许多因素影响，如特定疾病的固有品种风险、生活方式、犬所用于的活动类型、饲主对某些特定疾病的倾向、态度与恐惧；且应始终考虑去势术可能在治疗或预防某些问题的同时引发另一些问题。

原文推荐（措辞照录）：任何考虑对公母动物施以去势术的情形，都需要详尽的病例史、饲养该动物的目的、饲主与宠物的生活方式，并考虑品种、年龄、体况评分（body condition score）以及风险与获益的估计。关于每种情形下去势获益与损害的下列结论性表述不应被视为最终结论——该领域的新证据不断涌现，可能随时间改变风险/获益评估。丧失性类固醇激素在特殊情形下可能产生有益效果。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 母犬：获益', '4.2 母犬：获益

原文逐条要点（保留措辞）：

- 母犬中，切除性腺与子宫组织可预防生殖器官疾病，并可预防意外妊娠；这包括雌雄同体（hermaphrodites）与假雌雄同体（pseudohermaphrodites）。然而，由于类固醇激素的丧失会引发其他问题，预防这些疾病不应是母犬去势的唯一理由——尤其是在青春期前（before puberty）不应如此。任何健康的母犬都可保持完整（remain intact），但应监测其生殖健康，并在出现异常的最初迹象时进行检查。
- 阴道肿瘤（vaginal tumours）可能对性类固醇激素有反应（steroid hormone responsive）。因此，去势术在肿瘤切除后是有益的，并能在良性肿瘤情形下预防复发；还可能预防阴道肿瘤的形成。
- 去势术降低乳腺肿瘤（mammary tumours）风险，在青春期前、直至第二次发情之后施术时尤为明显。然而乳腺肿瘤的发病机制是多因素的，因此不应仅为预防乳腺肿瘤而行去势术。
- 去势术降低可传染性静脉瘤（transmissible venereal tumours）的风险，可能是通过降低交配频率实现的。
- 去势术通常使阴道脱垂（vaginal prolapse）在 7–10 天内缓解，并预防该问题的可能复发。
- 与内源性孕激素相关、使糖尿病（diabetes mellitus）治疗复杂化的胰岛素抵抗，将因去势术而得到解决，且与确诊后的时间无关。
- 对于患假孕（pseudocyesis）并有行为与健康问题的母犬，以及母性攻击（maternal aggression）情形，此外还推荐去势术。所有其他行为方面的顾虑都必须先由兽医行为学专家分析，才能推荐不可逆的去势术。以长效 GnRH 激动剂进行试验是一种选择（an option）。

原文关于母犬手术年龄（措辞照录）：绝育推荐年龄取决于考虑施术的原因，但在有主母犬中理想上应在第一次或第二次发情之后施行。', 'dog', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 公犬：获益', '4.3 公犬：获益

原文逐条要点：

- 公犬中，切除性腺可预防生殖器官疾病，这也包括两性畸形（intersexes）与性发育障碍（disorders of sexual development, DSD）。隐睾（retained testes）与激素分泌性肿瘤情形下，去势术是必须的（obligatory），以预防高雌激素血症（hyperoestrogenism）与转移。
- 前列腺疾病如良性前列腺增生（benign prostate gland hyperplasia, BPH）与前列腺炎是雄激素依赖性的（androgen dependant）。因此，对有 BPH 反复体征的犬，强烈推荐（strongly recommended）包括抗雄激素与长效 GnRH 激动剂在内的、减小前列腺体积的药物治疗，或去势术。
- 肛周腺腺瘤（adenomas of the perianal glands）情形下，抗激素治疗、激素下调或去势术为首选治疗（treatment of choice）。
- 尿道脱垂（urethral prolapse）必须手术矫正；可考虑去势术或激素下调，以防止性活动期间缝线断裂。
- 由于许多会阴疝（perineal hernia）犬患有严重的前列腺疾病，这些病例推荐去势术或用以减小腺体体积的激素治疗。
- 与睾酮相关的、不期望的行为可能因去势术或激素治疗而改善；公犬间的攻击（inter-male aggression）可能改善，但并非所有攻击行为都与睾酮相关。

原文关于公犬手术年龄与「去势试验」（措辞照录）：绝育推荐年龄取决于考虑施术的原因，但青春期前（prepubertal）去势副作用的风险应谨慎权衡于该措施的获益之前。在进行不可逆的睾丸切除术（orchiectomy）之前，推荐使用长效 GnRH 激动剂进行所谓「去势试验（castration trial）」。', 'dog', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 公母犬共有：健康损害', '4.4 公母犬共有：健康损害

原文逐条要点：

- 去势术可能促成公母犬某些肿瘤的发生；已有报道提示肥大细胞瘤（mast cell tumours）、移行细胞癌（transitional cell carcinomas）、骨肉瘤（osteosarcomas）、淋巴瘤（lymphomas）与血管肉瘤（haemangiosarcomas）的发病风险升高。这部分可能与去势术后促黄体素（luteinising hormone, LH）的长期升高有关，目前正被深入研究；绝育年龄的影响亦在被研究。
- 在已去势公犬中，前列腺肿瘤的发生率高于完整公犬，这可能是由于缺乏雄激素的保护作用；在这方面，晚龄去势的影响受到质疑。长效 GnRH 激动剂的类固醇激素抑制作用是否不同于去势术诱导的类固醇激素抑制，是未来的研究领域。
- 尿失禁（urinary incontinence）在任何时间发生于去势后母犬的 5–20%（原文数值）。这是多因素的，但被去势术强烈触发；在青春期前绝育的情形下尤其如此——特别是成年体重 >25 kg（原文数值）的母犬幼崽。公犬的尿失禁主要由年龄触发。
- 已有大样本犬群与某些品种报道称，在 <6 月龄或 <12 月龄（原文数值）去势对关节健康有负面影响。当向饲主告知幼龄去势的后果时，应考虑这一点。
- 肥胖、甲状腺功能减退（hypothyroidism）、肾上腺皮质功能亢进（hyperadrenocorticism）与某些免疫性疾病的患病率在去势后升高；这部分可能与性腺类固醇的丧失和/或超生理水平 LH 的持续有关。
- 在某些母犬与公犬，去势后对陌生人和家庭成员的攻击性增加；有报道提示青春期前去势与焦虑/缺乏信心以及行为问题的普遍增加之间存在关联。然而，去势后的行为改变难以预见，只能基于个别犬及其病史进行估计。
- 青春期前去势可能引发健康损害，如外阴周皮炎（perivulvar dermatitis）与泌尿生殖道反复感染，并可能触发骨科问题与肿瘤。这些损害应在去势术前告知犬主，并对每一例个案就犬与饲主双方提供风险 vs. 获益评估。
- 公犬中，发生前列腺肿瘤（prostatic neoplasia）的极低风险（<1%，原文数值）应与高龄时前列腺疾病的风险及其固有的手术风险相权衡。在去势术可能与其他因素（如年龄、体型、肥胖或品种易感性）共同触发上述疾病的病例中，可考虑激素下调等替代方案；这也可防止与去势相关健康顾虑 implicated 的、持续存在的超生理水平 LH 浓度。', 'dog', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 母猫：获益与损害', '4.5 母猫：获益与损害

原文要点：母猫中，去势术可预防卵巢与子宫疾病。去势术或激素下调可预防假孕（pseudopregnancy）与妊娠，因此是预防乳腺纤维腺瘤病（fibroadenomatosis）、乳汁郁积（galactostasis）与乳腺炎（mastitis）的一项措施。考虑到对减少乳腺肿瘤形成与意外妊娠的有益效果，推荐在母猫中进行青春期前去势或激素下调（原文措辞 `is recommended`）。然而，近期研究显示，已去势猫其他肿瘤的发生率更高；这在多大程度上与年龄等其他因素相关，目前仍在研究中。

4.6 公猫：获益

原文要点：公猫中，去势术可预防睾丸疾病，但不能预防前列腺腺癌（adenocarcinomas of the prostate gland）。可推荐去势术以降低对其他猫的攻击性；排尿标记（urine marking）并非在所有病例中都能得到改善。去势术不能预防免疫系统的感染与疾病。

4.7 猫的施术年龄与代谢风险

原文要点：雄性和雌性欧洲短毛猫（European shorthair cats）以及相似体型的品种，可在青春期前后（peripubertally）以及早在 3–4 月龄（原文数值）进行去势，且不损害健康、预期寿命与行为。然而，公母猫都应处于良好的体况并已接种疫苗。猫的健康损害主要涉及代谢：两性在去势后肥胖与胰岛素依赖型 2 型糖尿病（insulin dependent type-2 diabetes mellitus）风险均升高，公猫尤为明显。不过，这可以通过增加运动和限制热量摄入来缓解。此外，去势术可能增加下泌尿道疾病（lower urinary tract diseases）的风险，肥胖与品种为促成因素。青春期前去势与骨骺闭合延迟可能触发公母猫的骨骺骨折（epiphyseal fractures）。较近期，有报道提示某些癌症发生风险升高，目前仍在研究中。', 'cat', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 生殖控制的伦理（第 6 章）', '5. 生殖控制的伦理（第 6 章）

围绕犬猫健康获益与损害的新兴数据，促使兽医在推荐绝育时与宠物主展开最佳实践讨论。除个体动物的健康顾虑外，还须考虑伦理考量、收容所做法与宠物过度繁殖（pet overpopulation）等其他因素。

- 宠物过度繁殖：仍是全球性的重大问题，导致动物收容所过度拥挤，并使大量动物被安乐死。改变绝育做法与改善宠物圈养，被认为有助于减少流浪犬猫数量。
- 低成本绝育项目（low-cost spay and neuter programs）：在提高绝育率方面显示出希望，但尚不清楚此类项目是否直接导致收容所接收率下降。
- 诱捕—绝育—放归（Trap, Neuter, Return, TNR）项目：旨在为管理流浪动物种群提供一种人道的做法；通过绝育并将动物放归其栖息地，TNR 项目意在降低特定区域的动物数量。然而，TNR 的有效性不易评估；特定环境、食物可获得性以及是否有具生育力动物迁入，都会影响其成效，且各项目之间差异很大。TNR 项目有潜力改善动物健康并控制狂犬病（rabies）等疾病，与疫苗接种项目相结合时尤为明显；这是对该地区人群的直接益处。虽然这些项目也促进社区参与，但需要大量资源与长期承诺，其长期结果存疑。该领域需要更多研究。
- 负责任宠物饲养（responsible pet ownership, RPO）：可促进动物福祉并强化人—动物纽带。历史上，对宠物饲养的态度历经数个世纪从实用考量逐渐转向陪伴。人们对妥善照料宠物重要性的认识同步提高。定期兽医就诊、预防性保健与生殖控制项目，是 RPO 的基本要素。教育举措在提升对宠物需求与 RPO 的意识方面发挥关键作用；向儿童传授共情与对动物的尊重，可培养终身的负责任行为。
- 绝育观念与比率的地域差异：西方如美国常实行常规、高量的绝育，而斯堪的纳维亚等地区更为审慎。许多国家缺乏关于绝育流行率的可靠数据，使比较与项目成效评估变得困难。
- 早期绝育（early age desexing, EAD）/儿童绝育：在世界各地以不同程度上施行。许多组织与兽医协会在特定年龄段与情形下认可 EAD。然而，只有在谨慎权衡风险与获益之后才应进行该做法。
- 强制绝育法（Mandatory Spay and Neuter laws）：已在全球不同地区出台以控制社区动物数量。其目标通常是减少与动物相关的问题，如滋扰行为、犬只攻击以及动物数量。然而，此类法律的有效性存在不确定性，其影响正受到质疑。
- 结论性表述：当兽医重新审视「常规性地对宠物去势」这一做法时，显然个体情况与社会因素都必须考虑；兽医在为饲主与决策者提供循证信息与指导方面发挥重要作用。显然，需要高质量研究及专家之间的协作，才能充分理解绝育做法对收容所与更广泛社区内动物种群的影响；此外，也有必要对数据收集方法进行标准化以促进分析。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 不同情境下的生殖控制推荐（Recommendations in differen', '6. 不同情境下的生殖控制推荐（Recommendations in different settings）

关于犬猫绝育／去势／生殖控制的决定需要审慎考虑。除每只个体的性格与健康发挥重要作用外，作出决定的情境以及动物未来的生活环境，都需一并考虑。以下按情境摘要原文推荐（措辞照录）。

6.1 母犬

- 对于负责任的宠物饲主（responsible pet owners, RPOs）：让犬保持完整可能是可取的（may be advisable），尤其在与去势相关健康损害易感的品种。但在此类情形下，饲主必须警惕错配（mismating）风险，并确保定期进行乳腺检查以监测乳腺肿瘤风险升高。
- 子宫切除术（hysterectomy）：可为希望消除带血阴道分泌物不便与意外妊娠风险者提供有效解决方案。必须认识到，犬子宫切除术——尤其是短头颅品种（brachycephalic breeds）——的长期影响尚未完全了解，但可能增加阴道脱垂风险。
- 保留性腺手术（gonad-sparing surgery）：正变得更流行，但尚无充分证据将其获益与「让动物完全保持完整」相等同。不过，对 RPO 以及在去势后易患某些疾病的某些犬种，子宫切除术可能是一个合理的选项（reasonable option）。
- GnRH 植入剂：若希望暂时性不育，可考虑（might be considered），尽管已有不良事件报道，但其发生率尚未被充分调查；尤其在中年至老年母犬需谨慎，但在精选病例中 GnRH 植入剂可为一个选项。GnRH 植入剂对母猫通常是安全的，使其成为手术的潜在替代方案。
- 卵巢切除术（ovariectomy）：在特定情形下可能是合适的，包括无子宫病变或依饲主意愿的母犬。在流浪犬中，不推荐（not recommended）子宫切除术，因为放归后当母犬被交配时可能发生阴道穹窿（vaginal vault）破裂。多数情形下卵巢切除术已足够；存在子宫病变时应行卵巢子宫切除术（ovariohysterectomy）。

6.2 收容所与幼龄绝育

- 收容所情境：以永久绝育为首要目标时，应在子宫切除术与卵巢切除术之间的选择中考虑品种特异性因素；决定可推迟至为动物确定一位（负责任的）饲主之后。
- 青春期前/儿童绝育：对公母动物的青春期前去势（paediatric gonadectomy）因健康损害而不被鼓励（discouraged）；但将「再安置前对所有动物进行永久绝育」列为优先的收容所环境是例外。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'caution', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('犬猫生殖控制指南2024-执行摘要 · 母猫', '6.3 母猫

- 母猫的情形有所不同：由于在家中饲养完整未绝育母猫存在困难，通常推荐卵巢切除术（generally recommended）。对某些流浪猫，在特定情境下（如无外来迁入的封闭社区）可考虑子宫切除术。在多数其他情形下，卵巢切除术或卵巢子宫切除术是永久绝育的首选方法（preferred method）。

6.4 公犬

- 与负责任饲主同住的公犬：推荐（recommendation）或让其保持完整，或在希望绝育时考虑输精管结扎术（vasectomy）。这些病例必须定期监测睾丸与前列腺疾病。然而，如果饲主不太可能进行此类检查，则睾丸切除术（orchiectomy）是更安全的选择。对于多犬家庭的客户所有犬，睾丸切除术也可能适用，以预防不期望的生殖行为。
- 某些情形可考虑 GnRH 植入剂，特别是仅需暂时性不育时。睾丸内注射（intratesticular injections）对所有公犬（包括收容所情境）都是一个可行选项，但必须在施药后 7 天（原文数值）内监测并发症。
- 输精管结扎术可能是合适的选择，尤其在需要维持社会结构的封闭种群中；不过，该领域仍需更多研究。
- 在将犬的常规手术列为非法的国家，GnRH 植入剂可提供一个可行的替代方案，前提是饲主遵守再植入（re-implantation）时间表。

6.5 公猫

- 公猫：通常推荐睾丸切除术，因为它可消除不期望的行为特征；在流浪猫种群中，睾丸切除术仍是首选，尽管在精选情形下可考虑输精管结扎术或附睾切除术（epididymectomy）。
- 在将常规手术列为非法的国家，可为犬提供 GnRH 植入剂作为替代；但需确保饲主依从性，并讨论可能的副作用。

6.6 总决定原则

最终，是否以及以何种方式对动物进行绝育／去势／生殖控制的决定，应基于对个体动物健康与饲主意愿的详尽评估。兽医在指导这些决定方面发挥关键作用，权衡风险与获益，以确保对动物、饲主以及更广泛社区的最佳结果。', '', '', '', '生殖,Kiss1 基因,引言（第 1 章）与使用说明,犬猫手术绝育（第 2 章）,犬猫非手术绝育（第 3 章）', 'informational', '犬猫生殖控制指南2024-执行摘要', 'official', 'https://wsava.org/global-guidelines/reproduction-guidelines/', 'approved'),
('Vaccination Guidelines · 第 1 段', 'Vaccination Guidelines（犬猫疫苗接种指南）

板块页面正文（原文）

Guidelines

Vaccination

Executive Summary

These Global Guidelines set out the latest scientific thinking on the vaccination of dogs and cats globally and give practical advice to veterinarians on optimum vaccination practice.

The Vaccination Guidelines Group has also produced sets of Regional Guidelines for veterinarians in Asia and Latin America.

**NEW:** Access the complete [Executive Summary of the 2024 Guidelines for the Vaccination of Dogs and Cats](https://wsava.org/wp-content/uploads/2024/05/2024-Guidelines-for-the-Vaccination-of-Dogs-and-Cats.pdf)', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · Resources', 'Resources

- [NEW: 2024 Vaccination Guidelines for Dogs and Cats](https://wsava.org/wp-content/uploads/2024/04/WSAVA-Vaccination-guidelines-2024.pdf)
- [English](https://wsava.org/wp-content/uploads/2024/04/WSAVA-Vaccination-guidelines-2024.pdf)
- [Spanish](https://wsava.org/wp-content/uploads/2024/05/ESP.-J-of-Small-Animal-Practice-2024-Squires-2024-guidelines-for-the-vaccination-of-dogs-and-cats-compiled-by-the.pdf)
- [Chinese](https://wsava.org/wp-content/uploads/2024/05/Chinese-Ver-2024-Vaccination-Guideline-for-Dogs-Cats.pdf)
- [Portuguese](https://wsava.org/wp-content/uploads/2024/07/WSAVA-VC-Guidelines-2024-Portuguese.pdf)
- [Russian](https://wsava.org/wp-content/uploads/2024/12/WSAVA-Vaccination-guidelines-2024_rus-compressed.pdf)
- [Italian](https://wsava.org/wp-content/uploads/2025/02/WSAVA_25_WEB_final-version.pdf)
- [French](https://wsava.org/wp-content/uploads/2025/03/2024-Squires-et-al-WSAVA-Vaccination-guidelines_FR_CLEAN.pdf)

**Download Our Vaccination Tables for Dogs and Cats**

Our easy-to-follow vaccination tables provide essential guidance for core and non-core vaccines in dogs and cats, helping you make informed decisions for your patients.', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · Resources (2)', '- Vaccination Table for Dogs: [English Version](https://wsava.org/wp-content/uploads/2025/06/Dogs-Vaccination-Table.pdf) | [Portuguese Version](https://wsava.org/wp-content/uploads/2025/11/WSAVA_VaccinesTable1_A3_POR-Dogs.pdf)
- Vaccination Table for Cats: [English Version](https://wsava.org/wp-content/uploads/2025/06/Cats-Vaccination-Table.pdf) | [Portuguese Version](https://wsava.org/wp-content/uploads/2025/11/WSAVA_VaccinesTable2_A3_POR-Cats.pdf)
- Vaccination Table for Shelter Dogs and Cats: [English Version](https://wsava.org/wp-content/uploads/2025/06/Shelter-Dogs-and-Cats-Vaccination-Table.pdf) | [Portuguese Version](https://wsava.org/wp-content/uploads/2025/11/WSAVA_VaccinesTable3_A4_POR-shelter.pdf)

Regional Recommendations', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · Resources (3)', '**Latin America**[Regional recommendations on vaccination for small animal practitioners in Latin America](https://wsava.org/wp-content/uploads/2020/07/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners.pdf)  
[Portuguese](https://wsava.org/wp-content/uploads/2020/08/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners-Portuguese.pdf)  
[Spanish](https://wsava.org/wp-content/uploads/2020/10/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners-Spanish.pdf)

2016 Guidelines

[English](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Vaccination-Guidelines-2015.pdf)

[Chinese (simplified)](https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Chinese.pdf)

[French](https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2016-French.pdf)

[Italian](https://wsava.org/wp-content/uploads/2020/01/WSAVA-Vaccination-Guidelines-2015-Italian.pdf)

[Japanese](https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Japanese.pdf)

[Polish](https://wsava.org/wp-content/uploads/2020/02/WSAVA-Vaccination-Guidelines-Polish.pdf)', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · Resources (4)', '[Portuguese](https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Portuguese.pdf)

[Russian](https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Russian.pdf)

[Spanish](https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Spanish.pdf)

Other Articles and Publications

- [Vacinação contra o sarampo e  vacinação de cães e gatos](https://wsava.org/wp-content/uploads/2020/01/Clinica-Veterinaria-Brazil-May-2019-Vaccination.pdf)', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · Downloads', 'Downloads

Vaccination Guidelines for Dogs & Cats

[Download](https://wsava.org/wp-content/uploads/2024/04/WSAVA-Vaccination-guidelines-2024.pdf)

Translations

[Spanish](https://wsava.org/wp-content/uploads/2024/05/ESP.-J-of-Small-Animal-Practice-2024-Squires-2024-guidelines-for-the-vaccination-of-dogs-and-cats-compiled-by-the.pdf)

[Chinese](https://wsava.org/wp-content/uploads/2024/05/Chinese-Ver-2024-Vaccination-Guideline-for-Dogs-Cats.pdf)

[Portuguese](https://wsava.org/wp-content/uploads/2024/07/WSAVA-VC-Guidelines-2024-Portuguese.pdf)

[Russian](https://wsava.org/wp-content/uploads/2024/12/WSAVA-Vaccination-guidelines-2024_rus-compressed.pdf)

[Italian](https://wsava.org/wp-content/uploads/2025/02/WSAVA_25_WEB_final-version.pdf)

[French](https://wsava.org/wp-content/uploads/2025/03/2024-Squires-et-al-WSAVA-Vaccination-guidelines_FR_CLEAN.pdf)

本板块文档清单

共 27 份 PDF，按「英文 + 中文」策略收录 9 份，跳过小语种译本 18 份。', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · 已收录（原文已抽取到 raw_extracts/）', '已收录（原文已抽取到 raw_extracts/）

| 文档 | 语言 | 版本说明 | 页数 | 抽取字符 | 原文 |
|---|---|---|---|---|---|
| Executive Summary of the 2024 Guidelines for the Vaccination of Dogs and Cats | EN | 2024 版（现行） | 4 | 6744 | [raw_extracts/2024-Guidelines-for-the-Vaccination-of-Dogs-and-Cats.md](raw_extracts/2024-Guidelines-for-the-Vaccination-of-Dogs-and-Cats.md) |
| NEW: 2024 Vaccination Guidelines for Dogs and Cats | EN | 2024 版（现行） | 40 | 208222 | [raw_extracts/WSAVA-Vaccination-guidelines-2024.md](raw_extracts/WSAVA-Vaccination-guidelines-2024.md) |
| Chinese Ver 2024 Vaccination Guideline for Dogs Cats | ZH | 2024 版（现行） | 59 | 97460 | [raw_extracts/Chinese-Ver-2024-Vaccination-Guideline-for-Dogs-Cats.md](raw_extracts/Chinese-Ver-2024-Vaccination-Guideline-for-Dogs-Cats.md) |
| Dogs Vaccination Table | EN | 2025 版（现行） | 1 | 7056 | [raw_extracts/Dogs-Vaccination-Table.md](raw_extracts/Dogs-Vaccination-Table.md) |
| Cats Vaccination Table | EN | 2025 版（现行） | 1 | 7167 | [raw_extracts/Cats-Vaccination-Table.md](raw_extracts/Cats-Vaccination-Table.md) |
| Shelter Dogs and Cats Vaccination Table | EN | 2025 版（现行） | 1 | 2577 | [raw_extracts/Shelter-Dogs-and-Cats-Vaccination-Table.md](raw_extracts/Shelter-Dogs-and-Cats-Vaccination-Table.md) |
| Regional recommendations on vaccination for small animal practitioners in Latin America | EN |  | 35 | 178219 | [raw_extracts/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners.md](raw_extracts/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners.md) |
| WSAVA Vaccination Guidelines 2015 | EN | 2015 版（已被 2024 版取代，保留历史版本） | 45 | 194104 | [raw_extracts/WSAVA-Vaccination-Guidelines-2015.md](raw_extracts/WSAVA-Vaccination-Guidelines-2015.md) |
| WSAVA vaccination guidelines 2015 Chinese | ZH | 2015 版（已被 2024 版取代，保留历史版本） | 45 | 49455 | [raw_extracts/WSAVA-vaccination-guidelines-2015-Chinese.md](raw_extracts/WSAVA-vaccination-guidelines-2015-Chinese.md) |', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · 未收录（同一指南的其他语言译本）', '未收录（同一指南的其他语言译本）', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · 未收录（同一指南的其他语言译本） (2)', '- ESP.-J-of-Small-Animal-Practice-2024-Squires-2024-guidelines-for-the-vaccination-of-dogs-and-cats-compiled-by-the.pdf — 原链接 <https://wsava.org/wp-content/uploads/2024/05/ESP.-J-of-Small-Animal-Practice-2024-Squires-2024-guidelines-for-the-vaccination-of-dogs-and-cats-compiled-by-the.pdf>
- WSAVA-VC-Guidelines-2024-Portuguese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2024/07/WSAVA-VC-Guidelines-2024-Portuguese.pdf>
- WSAVA-Vaccination-guidelines-2024_rus-compressed.pdf — 原链接 <https://wsava.org/wp-content/uploads/2024/12/WSAVA-Vaccination-guidelines-2024_rus-compressed.pdf>
- WSAVA_25_WEB_final-version.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/02/WSAVA_25_WEB_final-version.pdf>
- 2024-Squires-et-al-WSAVA-Vaccination-guidelines_FR_CLEAN.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/03/2024-Squires-et-al-WSAVA-Vaccination-guidelines_FR_CLEAN.pdf>
- WSAVA_VaccinesTable1_A3_POR-Dogs.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/11/WSAVA_VaccinesTable1_A3_POR-Dogs.pdf>
- WSAVA_VaccinesTable2_A3_POR-Cats.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/11/WSAVA_VaccinesTable2_A3_POR-Cats.pdf>
- WSAVA_VaccinesTable3_A4_POR-shelter.pdf — 原链接 <https://wsava.org/wp-content/uploads/2025/11/WSAVA_VaccinesTable3_A4_POR-shelter.pdf>
- Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners-Portuguese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/08/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners-Portuguese.pdf>
- Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners-Spanish.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/10/Recommendations-on-vaccination-for-Latin-American-small-animal-practitioners-Spanish.pdf>
- WSAVA-vaccination-guidelines-2016-French.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2016-French.pdf>', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · 未收录（同一指南的其他语言译本） (3)', '- WSAVA-Vaccination-Guidelines-2015-Italian.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-Vaccination-Guidelines-2015-Italian.pdf>
- WSAVA-vaccination-guidelines-2015-Japanese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Japanese.pdf>
- WSAVA-Vaccination-Guidelines-Polish.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/02/WSAVA-Vaccination-Guidelines-Polish.pdf>
- WSAVA-vaccination-guidelines-2015-Portuguese.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Portuguese.pdf>
- WSAVA-vaccination-guidelines-2015-Russian.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Russian.pdf>
- WSAVA-vaccination-guidelines-2015-Spanish.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/WSAVA-vaccination-guidelines-2015-Spanish.pdf>
- Clinica-Veterinaria-Brazil-May-2019-Vaccination.pdf — 原链接 <https://wsava.org/wp-content/uploads/2020/01/Clinica-Veterinaria-Brazil-May-2019-Vaccination.pdf>', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('Vaccination Guidelines · 版权', '版权

内容版权归 World Small Animal Veterinary Association (WSAVA) 所有，本目录仅为项目内部 RAG 知识库整理，禁止二次分发。', '', '', '', '疫苗,板块页面正文（原文）,Guidelines,Vaccination', 'informational', 'Vaccination Guidelines', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 指南目的与证据分级方法', '1. 指南目的与证据分级方法

1.1 目的与定位

- 世界小动物兽医协会（World Small Animal Veterinary Association, WSAVA）疫苗接种指南小组（Vaccination Guidelines Group, VGG）于 2006 年召开，制定犬猫疫苗接种指南以协助全球兽医；前版发布于 2007、2010、2016 年，本文为更新版。
- 建议必须广泛并基于基本免疫学原理；**不描述强制性或最低护理标准**；国家和地区兽医协会、个体兽医或诊所可据此制定适合当地条件的接种计划。既有国家/地区指南（以色列犬与猫、斯里兰卡犬、北美犬猫 AAHA 与 AAFP、欧洲猫 ABCD）可能更具针对性。
- 最重要声明：目标是为每只犬和猫接种核心疫苗；在仔细考虑每只宠物的生活方式和疫苗可控制疾病的当地流行情况后，可能建议选择特定的非核心疫苗；核心和非核心疫苗应正确储存和管理，并仅在必要时使用，以提供终身保护。

1.2 证据分级方法的变更

- 本版**停止使用证据基础（Evidence Base, EB）符号 EB1 至 EB4**（先前迭代很少引用 EB2 与 EB3）。采用**叙述性评论**格式（所有其他国际伴侣动物疫苗接种指南团队亦同）；曾考虑系统审查或德尔菲共识流程，因材料广度与团队规模认为不适用。
- 本版变化：修订"核心"定义；新增专门处理母源抗体的章节；更新犬猫临床疫苗学当前和新兴主题与"疫苗类型"部分；重写"收容所和庇护所中的疫苗"；删除"被动免疫"部分；进一步讨论在 26 周龄以上接种选定核心疫苗而不是等到 12 至 16 月龄；纳入新版疫苗信息；进一步考虑猫疫苗接种的解剖部位；新增常见问题（Frequently Asked Questions, FAQs）列表。

1.3 与说明书、法规的关系

产品说明书/数据表/产品特性摘要（Summary of Product Characteristics, SPC）说明正确接种后可预期的**最低**免疫持续时间（duration of immunity, DOI）。指南基于所有可用 DOI 证据，因此可能建议每三年或不太频繁地复种某些在部分国家仍具 1 年期 DOI 声明的核心产品。偏离说明书属"标签外使用"，应取得主人知情同意并建议记录在病历中。兽医采纳指南（成年动物复种频率低于说明书，或给 12 至 20 周龄动物注射额外剂量）通常不会受到严重指责（Thiry & Horzinek, 2007），但应了解可能妨碍遵循指南的地方或国家法规；罕见例外是被政府法规强制遵守标签建议。', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 综合预防医疗保健与医疗记录', '1.4 综合预防医疗保健与医疗记录

- 疫苗接种需求评估只是全面终生医疗保健计划的一个组成部分；需定期（通常每年一次）健康检查，并涵盖体内外寄生虫、虫媒与人畜共患疾病、牙科、营养、行为。
- 病历必记：疫苗接种日期；接种者身份；疫苗名称、批号或序列号、有效期和制造商；接种的解剖部位和途径。任何不良事件与知情同意均应记录。
- VGG 建议接种证书除日期外还说明预计未来多久动物将受到保护。

2. 疫苗分类

| 分类 | 定义 |
|------|------|
| **核心疫苗** | 考虑动物生活方式及其居住或旅行的地理区域后，**所有**犬和猫都应接种的疫苗；部分针对全球分布的潜在致命疾病，部分针对仅在特定国家或地区流行的致命疾病 |
| **非核心疫苗** | 应强烈推荐给那些地理位置和/或生活方式（例如室内外通行、多宠物家庭）使其面临感染未指定为核心的特定感染风险的动物；需兽医与主人仔细对话决定每位患者推荐哪种 |
| **不推荐的疫苗** | 没有足够科学证据证明在任何地方推荐使用其合理性的疫苗 |

- **犬全球核心**：针对犬瘟热病毒（canine distemper virus, CDV）、犬腺病毒 1 型（canine adenovirus type 1, CAV）、犬细小病毒 2 型（canine parvovirus type 2, CPV）的疫苗。
- **猫全球核心**：针对猫细小病毒/猫泛白细胞减少症病毒（feline panleucopenia virus, FPV）、猫杯状病毒（feline calicivirus, FCV）、猫疱疹病毒 1 型（feline herpesvirus-1, FHV）的疫苗。
- **按地区升格为核心**：狂犬病（流行地区对犬猫都是核心，即使无法律要求）；犬钩端螺旋体病（流行、相关血清群已知且有合适疫苗者）；猫白血病病毒（feline leukaemia virus, FeLV）疫苗（流行地区对幼猫 < 1 岁、可户外活动或与可户外活动猫同室的成年猫）。
- VGG 尚未考虑一些地域可获得性或适用性非常有限的"小"疫苗产品。

3. 免疫学基础与母源抗体干扰', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 疫苗类型', '3.1 疫苗类型

| 类型 | 原文要点 |
|------|----------|
| **改良活疫苗（modified live virus, MLV）/减毒活疫苗** | 含活但减毒（减弱）的完整病毒或细菌，可附着在细胞上、感染细胞并在细胞内复制，建立低水平和短暂感染，产生强烈免疫应答而不引起明显疾病；通常比大多数其他种类疫苗更具免疫原性、通常需要较少剂量；一些在没有 MDA 干扰时单剂后即产生一致且持久的应答（多年）；肠外（通常皮下）使用时可更有效诱导相关解剖部位的免疫，比大多数其他疫苗更可能诱导强大的细胞和体液（抗体介导）免疫；一些直接用于黏膜部位（鼻内或口服）诱导局部保护性黏膜免疫 |
| **灭活（或死）疫苗** | 含完整的、灭活的、抗原性完整的微生物，不能感染或复制但能刺激应答；因不模仿自然感染，通常产生较弱应答、可能无法产生足够的黏膜或细胞免疫，通常需要多次剂量和佐剂；无论动物年龄通常需**至少两次初始剂量**，第一剂启动免疫应答，第二剂（有时第三剂）通常间隔 **2 至 4 周**给药；完整保护性应答可能要到第二剂或最后一剂后**两周**才产生；与 MLV 相比通常产生较短 DOI、需更频繁复种。例外：灭活狂犬病病毒疫苗异常有效，其中一些高度免疫原性、单剂量后即产生持久保护；幼猫接种 FHV 和 FPV 疫苗后也显示单剂灭活后的血清转化，接种第 7 天攻毒后提供与 MLV 类似保护 |
| **亚单位疫苗** | 由病原微生物的抗原亚成分组成（从培养物中提取纯化，或用重组 DNA 技术合成）；免疫原性往往低于 MLV，因此通常含佐剂并产生较短 DOI；有针对莱姆病的亚单位疫苗，最近还上市用于犬针对支气管败血鲍特菌（含纤毛抗原）的亚单位疫苗 |
| **重组新型 CPV 疫苗** | 含重组嵌合细小病毒基因组、部分 CPV-2c 和部分 CPV-2，与更传统的 MLV CDV 组件相结合；旨在比上一代疫苗更有效地突破 MDA 干扰，保护幼犬在很小的时候（**4 周龄**）免受 CPV 感染；生产过程中重组基因组用于生产活的细小病毒，可感染细胞并在接种的幼犬中繁殖 |
| **载体疫苗** | 另一种重组疫苗，编码一种或多种病原体免疫原性蛋白的一个或多个基因被直接克隆到载体病毒或生物体的基因组中（例如狂犬病病毒表面糖蛋白基因剪接的减毒金丝雀痘病毒载体）；这种禽类重组嵌合病毒只能在哺乳动物宿主中进行非常有限的复制，但在宿主细胞表面表达引入的基因、模拟自然感染；不能恢复毒力，载体选择为非致病性、有时具免疫刺激性；可诱导体液和细胞免疫应答，通常不需要佐剂；减毒金丝雀痘病毒已用于狂犬病、犬瘟热和 FeLV 感染的载体疫苗 |
| **核酸疫苗（DNA 和 RNA 疫苗）** | 通过在免疫时控制核酸产生病毒抗原靶蛋白的拷贝而产生；mRNA 疫苗通常需要非常低温的运输和储存，采用脂质纳米颗粒等递送系统保护核酸免遭降解；裸 DNA 比 mRNA 更稳定；目前**还没有** mRNA 疫苗或裸 DNA 疫苗可用于犬和猫 |', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 母源抗体（maternally derived antibody, MDA）与"', '3.2 母源抗体（maternally derived antibody, MDA）与"易感窗口"

- MDA 主要是新生幼犬和幼猫在出生后最初几小时内摄入初乳获得的被动免疫；出生后 24 小时内（尤其最初 4 小时）通过肠道吸收进入体循环；正常哺乳新生儿的血液中大约 **95%** 或更多的母源抗体来自初乳。
- 血清 MDA 抑制幼年动物免疫球蛋白 G（immunoglobulin G, IgG）的产生，并防止疫苗抗原刺激主动免疫应答。
- 大多数幼犬幼猫的 MDA 在大约 **8 至 12 周龄**降至能对疫苗接种产生积极应答的水平；MDA 低者可能较早即易感并能应答，MDA 高的幼犬可能在 **≥12 周龄**之前无法应答。
- **易感窗口（或时期）**＝MDA 不足以提供完整免疫保护、但仍足以干扰主动免疫应答的时期；由于转移的 MDA 量在窝间与窝内不同，没有血清学测试就不可能预测此窗口何时打开或关闭。
- **重复剂量不是加强剂量**，应用它们的目的是在 MDA 充分下降后尽快触发主动免疫应答。
- MDA 会干扰对 MLV 和灭活疫苗的应答：若接种第一剂灭活疫苗时有足够 MDA 阻止主动免疫应答，则不会发生免疫启动，**第二剂灭活疫苗将无法使动物免疫**；相反，MDA 充分减弱后接种**一剂 MLV 疫苗通常就足以产生免疫**。
- 图 1（犬细小病毒示例）：MDA 呈指数下降，半衰期约 **9 至 10 天**；6 周龄首次接种因 MDA 干扰、疫苗被中和而未使幼犬免疫；**8 周龄**时 MDA 低于抵御中度攻击所需水平而变得易感染细小病毒性肠炎，但仍足以干扰疫苗、不能免疫；约 **13.5 周龄**降至足以免疫的水平；**16 周龄**复种并迅速做出主动免疫应答。因此每 2 至 4 周复种一次以尽可能缩小易感窗口；不建议对年幼幼犬进行常规 MDA 检测。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 血清学检测协助接种决策', '3.3 血清学检测协助接种决策

- 诊所内诊断试剂盒可检测犬的 CDV、CPV 和 CAV 抗体以及猫的 FPV 抗体，部分已验证可用于诊所和庇护所环境，**20 至 30 分钟**内快速提供结果；病毒中和和血凝抑制测试仍是血清学检测的"黄金标准"。
- 成年犬 CDV、CPV、CAV 与成年猫 FPV 血清抗体的存在提供了积极体液免疫应答的证据，很可能表明可预防疾病；某些宠物中这些抗体会持续存在超过 3 年。**FHV 或 FCV 抗体的存在目前不被认为是针对这两种病毒免疫保护的可靠预测因子**；抗 FPV 抗体检测被认为是比抗 FHV 和抗 FCV 更可靠的保护力指标。
- 与抗体的存在相反，可检测抗体的缺乏并不能可靠预测易感性（未评估细胞免疫和先天免疫、免疫记忆），但基于预防原则通常仍被视为复种疫苗的临床指征。
- 确认主动免疫：可对 **20 周龄或 20 周龄后**、以及**最后一次疫苗接种至少 4 周后**采集的血清样本进行检测。血清反应阴性者应复种并在几周后重测；再次阴性则应暂时视为无应答者。理想情况下血清学检测（尤其抗 CDV）应在参考实验室而非使用即时检测。
- **如果要依赖诊所内血清学检测试剂盒，其特异性必须很高**（假阳性会掩盖需要复种的事实）。德国系列比较研究显示：检测犬血清 CPV-2 抗体的试剂盒表现非常好，但检测 CDV 和 CAV 抗体的试剂盒表现较差；四种检测 CDV 抗体的实际试剂盒并不可靠；检测抗 CAV 抗体的单一试剂盒特异性较差。

4. 犬用疫苗清单与疫苗表（表 1 宠物犬［非收容所］疫苗）

与全世界相关的犬用核心疫苗可预防由 CDV、CAV 和 CPV 引起的疾病；在某些地方工作的兽医指定其他疫苗为核心疫苗，例如预防狂犬病和钩端螺旋体病的疫苗。最广泛使用的犬非核心疫苗针对支气管败血鲍特菌和犬副流感病毒（canine parainfluenza virus, CPiV）；地域可用性更受限制的非核心疫苗包括针对伯氏疏螺旋体、犬流感病毒（canine influenza virus, CIV）和婴儿利什曼原虫的疫苗；还有一种针对犬疱疹病毒 1 型（CHV-1）的亚单位疫苗专门用于怀孕期间的母犬。', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 核心疫苗（肠外）', '4.1 核心疫苗（肠外）

| 疫苗 | ≤16 周龄的幼犬 | >16 周龄的犬 | 复种 | 意见和建议 |
|------|----------------|--------------|------|------------|
| 犬细小病毒 2 型（改良活病毒，MLV）+ 犬瘟热病毒（MLV 或重组）+ 犬腺病毒 2（CAV2，MLV） | 不早于 6 周龄开始。每 3 至 4 周复种一次疫苗，直至 16 周龄。在特别高风险的情况下，持续到 20 周龄，并考虑每 2 至 3 周接种一次疫苗 | 一些制造商建议间隔 2 至 4 周注射两剂。然而，单剂量的 MLV 或重组疫苗可能会保护大多数犬 | 考虑在犬 6 个月大时再次接种疫苗，而不是等到犬 12 至 16 个月大时。这会缩小未能较早产生主动免疫应答的幼犬的易感窗口。此后，在 3 岁时复种疫苗，此后不超过每 3 年接种一次 | 核心。幼犬和犬类最重要的疫苗之一；目的应该是为尽可能多的数量接种疫苗；在完成本系列疫苗接种之前，可以开始对幼犬进行小心的社会化（在其社会化敏感期） |
| 犬细小病毒 2 型（重组）+ 犬瘟热病毒（MLV） | 从 4 周龄开始接种单剂，然后开始常规初种 | 原文此处缺失 | 原文此处缺失 | 核心。最近推出的这款产品专门针对年轻的幼犬（可能有 MDA 干扰性），而不是为年老的犬复种疫苗 |
| 狂犬病（灭活） | 优先遵守任何当地法律或法规。遵循本地生产的疫苗的产品说明书。在一些国家，第一剂疫苗通常不会在 12 周龄之前接种 | 优先遵守任何当地法律或法规。遵循本地生产的疫苗的产品说明书 | 优先遵守任何当地法律或法规，遵循本地生产的疫苗的产品说明书。需要在 1 岁时（或在某些国家，初种后 1 年）复种疫苗。可以购买具有 1 年或 3 年 DOI 的犬狂犬病疫苗；加强的时间由获得许可的 DOI 决定，但在某些地区可能由法律规定 | 核心。无论疾病流行或当地法律或法规要求，均应认为核心疫苗 |
| 钩端螺旋体属（灭活菌苗）。疫苗中包含的血清型取决于地理区域；大多数疫苗至少包含两个血清型，但有些是单价的，有些是三价的，有些是四价的 | 初始剂量通常从 8 周龄开始。请遵循产品说明书中有关何时开始的建议。2 至 4 周后给予第二剂 | 两剂，间隔 2 至 4 周 | 每年 | 核心（按地区）。犬钩端螺旋体病流行地区的犬的核心血清群已知，包含相关血清型的合适疫苗可在市场上买到 |', 'dog', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗', '4.2 非核心疫苗

> 译本此处表头仍作"宠物犬核心疫苗，肠外"，但以下各行"意见和建议"栏均标注**非核心**；本稿按各行自身标注归类。', 'dog', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗 (2)', '| 疫苗 | ≤16 周龄的幼犬 | >16 周龄的犬 | 复种 | 意见和建议 |
|------|----------------|--------------|------|------------|
| 犬副流感病毒（CPiV、MLV，肠外） | 从 6 周龄开始给药，然后每 2 至 4 周给药一次，直至 16 周龄或以上 | 制造商通常建议间隔 2 至 4 周注射两剂 | 每年 | 非核心。宠物犬的免疫力持续时间尚不确定；CPiV（MLV 黏膜）与支气管败血鲍特菌联合使用可能更可取，因为 CPiV 尚未作为单一抗原产品被广泛使用 |
| 支气管败血鲍特菌（无毒活细菌，鼻内）；支气管败血鲍特菌 + CPiV（MLV）鼻内；支气管败血鲍特菌 + CPiV（MLV）+ CAV-2（MLV）鼻内；支气管败血鲍特菌（无毒活细菌，口服）；支气管败血鲍特菌 + CPiV（MLV）口服 | 这些黏膜应用的疫苗均可在单次剂量后提供保护。有些可以在 3 周龄时使用，有些则可以在 7 或 8 周龄时使用。遵循产品说明书的建议 | 单剂 | 每年 | 非核心。这些用于鼻内或口服给药的活疫苗不得无意中通过肠外注射，因为这可能会导致严重的不良反应 |
| 支气管败血鲍特菌（灭活菌苗，肠外）；支气管败血鲍特菌（细胞壁抗原提取物，肠外）；支气管败血鲍特菌（菌毛抗原，肠外） | 这些肠外疫苗或亚单位疫苗需要注射两剂才能免疫，通常间隔 2 至 4 周。查看并遵循产品说明书 | 两剂。由于产品之间存在差异，请查看并遵循特定产品说明书 | 大多数每年一次。查看并遵循特定产品说明书；菌毛抗原疫苗有特殊的复种说明 | 非核心。这些用于肠外使用的疫苗不应无意中通过鼻内或口服给药，这不会有效，并可能引起不必要的不适 |
| 伯氏疏螺旋体（莱姆疏螺旋体病；灭活全菌苗，肠外）；伯氏疏螺旋体［亚基-外表面蛋白 A（OspA），肠外］；伯氏疏螺旋体（OspA 亚基和嵌合 OspC 蛋白） | 这些肠外疫苗或亚单位疫苗需要注射两剂才能免疫，通常在 8 周龄左右开始。查看并遵循特定产品说明书 | 两剂，间隔 2 至 4 周。查看并遵循特定产品说明书 | 每年。根据地区规定，在蜱虫季节开始前复种疫苗 | 非核心。通常建议仅用于已知有高暴露风险、居住或访问媒介蜱暴露风险高、或已知疾病流行区域的犬。预防的主要措施是积极控制体外寄生虫；不会发生犬与犬之间的直接传播 |
| 犬流感病毒（H3N8；灭活佐剂，肠外）；犬流感病毒（H3N2；灭活佐剂，肠外）；犬流感病毒（二价 H3N8 + H3N2；灭活、佐剂、肠外） | 这些肠外灭活病毒疫苗需要两剂才能免疫。初始剂量可以从 6 周龄开始给予。查看并遵循特定产品说明书 | 两剂，查看并遵循特定产品说明书的间隔时间，通常间隔 2 至 4 周 | 每年 | 非核心。仅在美国获得许可；考虑用于共同饲养的高危犬群，例如犬舍、犬展或寄养中心的犬 |
| 犬利什曼病（canine leishmaniosis, CanL；重组蛋白 A2，肠外） | 三剂，间隔 3 周，初始剂量为 > 4 月龄 | 分三剂，间隔 3 周 | 每年 | 非核心。预防关键取决于有效的体外寄生虫控制，以尽量减少与媒介的接触；疫苗接种可以被视为补充控制措施，不能替代积极的体外寄生虫控制 |
| CanL［婴儿利什曼原虫的排泄-分泌蛋白（LiESP），肠外］ | 三剂，间隔 3 周，初始剂量为 > 6 月龄 | 分三剂，间隔 3 周 | 每年 | 非核心 |
| CanL（重组蛋白 Q，肠外） | > 6 月龄时单次给药 | 单剂量 | 每年 | 非核心 |
| 犬疱疹病毒-1（CHV-1；亚单位，肠外） | 不适用。该疫苗适用于怀孕母犬 | 原文此处缺失 | 怀孕期间两次接种：第一剂 – 发情期间或预计交配日期后 7 至 10 天；第二剂 – 预计分娩日期前 1 至 2 周，遵循产品说明书。制造商建议在随后的每次怀孕期间重复两次注射方案 | 非核心。旨在保护新生幼犬；感染（通常来自母犬）对于 3 周龄以下且未保暖的幼犬来说可能是致命的 |', 'dog', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗 (3)', '正文补充：针对呼吸道病原体的犬非核心疫苗不能预防感染，但可以减轻疾病的严重程度。预防 CPiV、支气管败血鲍特菌和犬腺病毒 2 型（CAV-2）的疫苗有不同抗原组合，可为肠外、鼻内（减毒支气管败血鲍特菌，含或不含 CPiV 和 CAV-2）或口服制剂；有证据表明与口服途径相比鼻内途径可提供更好的临床结果；一小部分接种鼻内或口服疫苗的犬可能出现短暂咳嗽、打喷嚏以及眼部或鼻部分泌物。CHV-1 亚单位疫苗可诱导血清阴性母犬母体血清中和抗体的增加，这种抗体在初乳中被动转移，可在幼犬生命早期（< 3 周龄）保护幼犬；出生后不久哺乳不良的幼犬将无法得到很好的保护。', 'dog', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 不推荐给宠物犬接种的疫苗', '4.3 不推荐给宠物犬接种的疫苗

| 疫苗 | 原文理由 |
|------|----------|
| 犬细小病毒 2 型（CPV；灭活的，肠外的） | 在可获得 MLV 疫苗的区域不建议在宠物犬中普遍使用；针对犬细小病毒 2 型的 MLV 疫苗效力更强、可诱导更长的免疫持续时间；一些 MLV 疫苗已被证明可安全用于怀孕母犬（检查产品说明书确认）；如果特定地区无法获得安全的 MLV 疫苗，则可以使用灭活疫苗 |
| 犬冠状病毒（CCoV；灭活的和 MLV，肠外的） | 不建议。CCoV 是成年犬重要原发病原体的证据很薄弱；幼犬与冠状病毒感染相关的腹泻通常轻微，感染通常发生在幼犬身上、有时在首次接种前（故在 6 至 12 周龄接种对预防许多感染为时已晚）；与犬细小病毒 2 型的合并感染可通过有力预防细小病毒感染控制；对 CCoV 的保护取决于肠道中分泌型 IgA 的存在，肠外接种的犬不会产生保护性肠道 IgA 抗体应答；无证据表明现有 CCoV 疫苗可预防病毒突变致病形式（泛嗜性或更高致病性毒株），这些突变病毒很少发生及被识别出来 |
| 贾第鞭毛虫属疫苗 | 不建议。没有足够科学证据证明其使用合理性；十二指肠贾第鞭毛虫感染不会危及生命、对治疗有反应、很少由幼犬或成犬传播给人类；没有足够证据表明贾第虫疫苗可以防止贾第虫卵囊脱落；疫苗不能预防感染，接种的犬可能会出现感染的临床症状 |
| 犬小孢子菌疫苗 | 不建议。没有足够的科学证据证明其使用疫苗的合理性 |

5. 猫用疫苗清单与疫苗表（表 2 宠物猫［非收容所］疫苗）

世界各地与猫相关的核心疫苗是针对 FPV、FHV 和 FCV 的疫苗。猫的非核心疫苗包括针对猫衣原体、支气管败血鲍特菌和猫免疫缺陷病毒（FIV）的疫苗。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('2024年WSAVA犬猫疫苗接种指南 · 核心疫苗', '5.1 核心疫苗

| 疫苗 | ≤16 周龄的幼猫 | >16 周龄的猫 | 复种 | 意见和建议 |
|------|----------------|--------------|------|------------|
| FPV+FCV+FHV：肠外、减毒的（猫泛白细胞减少症病毒 FPV + 猫疱疹病毒-1 FHV + 猫杯状病毒 FCV） | 不早于 6 周龄开始，并且每 3 至 4 周复种一次疫苗，直至 16 周龄。在特别高风险的情况下，持续到 20 周龄，并考虑每 2 至 3 周接种一次疫苗 | 通常建议间隔 2 至 4 周注射两剂。尽管单剂量即可保护大多数猫 | 考虑在大约 6 月龄时再次接种疫苗，而不是等到猫 12 至 16 月龄。这将缩小任何未能较早产生主动免疫应答的幼猫的易感窗口。此后，在 3 岁时为"低风险"猫复种疫苗，然后频率不高于每 3 年一次 | **全球核心**。减毒活 FPV 疫苗提供快速、有效、持久的保护；风险较高的猫应考虑更频繁复种（最多每年一次），进入寄宿猫舍或拜访其他高压力、高风险环境应在暴露前 1 至 2 周复种；怀孕的母猫和 < 4 周龄的幼猫不宜接种减毒活疫苗；不慎雾化或注射部位泄漏过多可能出现上呼吸道疾病症状 |
| FPV+FCV+FHV：肠外，灭活的 | 不早于 6 周龄开始，并且每 3 至 4 周复种一次疫苗，直至 16 周龄。在特别高风险的情况下，持续到 20 周龄，并考虑每 2 至 3 周接种一次疫苗 | 两剂，间隔 2 至 4 周 | 考虑在大约 6 月龄时再次接种疫苗，而不是等到猫 12 至 16 月龄。这将缩小任何未能较早产生主动免疫应答的幼猫的易感窗口。此后，"低风险"猫在 3 岁时复种疫苗，然后每 3 年接种一次；建议风险较高的猫每年复种疫苗 | **全球核心**。灭活肠外 FPV 疫苗通常无法像 MLV FPV 疫苗那样提供快速、有效且持久的保护；有无佐剂疫苗可供选择；对怀孕母猫被认为比 MLV 疫苗更安全；感染逆转录病毒的猫不应避免接种疫苗，其中一些用灭活疫苗可能比 MLV 疫苗更好；双毒株（二价）灭活 FCV 疫苗旨在提供更广泛的保护；高风险猫应考虑更频繁复种（最多每年一次），可在接触前 1 至 2 周复种 |
| FHV+FCV ± FPV：鼻内，减毒的（FPV+FHV+FCV 或 FHV+FCV 系列） | 关注产品说明书 | 单剂量 | 每年 | 鼻内 FPV 疫苗接种不如肠外疫苗接种有效；即使使用三价鼻内疫苗，也要与肠外（皮下）FPV 疫苗同时接种；使用后可能出现上呼吸道疾病的迹象；可快速发挥针对 FHV 和 FCV 的保护作用；同时使用鼻内和肠外 FHV/FCV 疫苗可增强保护作用；进入寄宿猫舍或拜访其他高压力、高风险环境的猫可在暴露前 1 至 2 周复种 |
| 狂犬病（金丝雀痘病毒载体重组，无佐剂，肠外） | 优先遵守当地法规。如果没有规定，请遵循产品说明书 | 优先遵守当地法规。如果没有规定，请遵循产品说明书 | 根据当地法规的要求或根据许可的免疫期限（DOI）/产品说明书复种疫苗 | 疾病流行地区的核心疫苗 |
| 狂犬病（1 年和 3 年 DOI 灭活、佐剂产品、注射用） | 优先遵守当地法规。如果没有规定，请遵循产品说明书 | 优先遵守当地法规。如果没有规定，请遵循产品说明书 | 根据当地法规的要求或根据许可的免疫期限（DOI）/产品说明书复种疫苗 | 疾病流行地区的核心疫苗 |
| FeLV（重组、佐剂、肠外） | 最早从 8 周龄开始，3 至 4 周后注射第二剂 | 两剂，间隔 3 至 4 周 | 初种最后一剂疫苗后一年复种。此后，每年为持续暴露于 FeLV 的高风险猫（室内或室外）复种疫苗 | FeLV 疫苗是生活在 FeLV 感染流行地区 1 岁以下幼猫以及持续存在感染风险的老年猫的核心疫苗，例如在 FeLV 流行地区定期、无人监管进行户外活动的成年猫。避免接触是预防 FeLV 感染的最佳方法；只有 FeLV 阴性的猫才应该接种疫苗；FeLV 测试应在疫苗接种前进行。需进一步研究确定被潜在感染 FeLV 的猫咬伤的持续高风险成年猫应多久复种一次 FeLV 疫苗 |
| FeLV（灭活、佐剂、肠外） | 最早从 8 周龄开始，3 至 4 周后注射第二剂 | 两剂，间隔 3 至 4 周 | 初种最后一剂疫苗后一年复种。此后，每年为持续暴露于 FeLV 的高风险猫（室内或室外）复种疫苗；对接触可能感染 FeLV 的猫风险较低的猫根据产品说明书（例如每 2 或 3 年）复种疫苗 | 同上 |', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 非核心疫苗 (4)', '5.2 非核心疫苗

| 疫苗 | ≤16 周龄的幼猫 | >16 周龄的猫 | 复种 | 意见和建议 |
|------|----------------|--------------|------|------------|
| 猫免疫缺陷病毒（feline immunodeficiency virus, FIV；灭活、佐剂、肠外） | 免疫需要注射三剂，初次剂量最早在 8 周龄时注射；后续应间隔 2 至 3 周给药两次 | 需要三剂，每剂间隔 2 至 3 周给药 | 初种最后一次剂疫苗后一年复种，然后每年对确定有持续暴露风险的猫复种 | 避免接触是预防 FIV 感染的最佳方法。目前仅在日本、澳大利亚和新西兰上市，关于其功效的报道差异很大。接种会诱导产生用于感染诊断的抗体；然而一些诊所内诊断试剂盒可以可靠地区分已接种疫苗、未感染的猫和已感染的猫；经过验证的可靠 PCR 诊断测试也变得越来越广泛 |
| 猫衣原体（无毒活菌、无佐剂、肠外）／猫衣原体（灭活、含佐剂、肠外） | 最早在 9 周龄开始初剂 | 第 2 剂在 2 至 4 周后接种，分两剂接种，间隔 2 至 4 周 | 每年加强剂适用于有持续暴露风险的猫 | 对于已确认存在与临床疾病相关感染的多猫环境，疫苗接种最适合作为动物控制管理制度的一部分。据报道，无意中结膜接种活疫苗会导致临床疾病 |
| 支气管败血鲍特菌（无毒活菌，无佐剂，鼻内） | 最早在 4 周龄时鼻内接种一次 | 鼻内接种一次 | 每年加强剂适用于持续暴露风险的猫 | 通常不用于宠物猫；在宠物猫数量非常大时考虑使用 |

正文补充：猫支原体疫苗无法提供针对感染和疾病的完全保护，可建议用于生活在已知这种病原体曾引起过疾病的多猫家庭中的猫；有减毒活疫苗和灭活佐剂肠外疫苗，可用于 **8 至 9 周龄**的幼猫、并在 **2 至 4 周**后注射第二剂，对持续暴露风险的成年猫每年注射一次加强剂。（译本表 2 该行标签为"猫衣原体"，正文表述为"猫支原体"，两处均照录。）一些国家的猫支气管败血鲍特菌疫苗是减毒鼻内产品，可单剂用于 4 周龄以上的幼猫，每年加强接种一次。FIV 疫苗从未在欧洲获得许可，并于 2017 年在美国和加拿大市场被下架；澳大利亚一项回顾性田间试验报告接种猫中保护率为 **56%**，但该研究缺乏统计效力、置信区间非常大（**20% 至 84%**）、差异没有统计学意义；最近一项新西兰田间研究缺乏疫苗诱导的保护；VGG 决定继续将唯一市售的 FIV 疫苗归类为"非核心"。', 'cat', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 不推荐给宠物猫接种的疫苗', '5.3 不推荐给宠物猫接种的疫苗

| 疫苗 | 原文理由 |
|------|----------|
| 猫传染性腹膜炎疫苗（feline infectious peritonitis, FIP；减毒活疫苗、无佐剂、鼻内给药） | 没有足够科学证据证明广泛推荐使用这种疫苗是合理的。标明用于 **16 周龄**的幼猫；含一种对温度敏感的活病毒，可以在鼻内复制但不能在较高的核心体温下复制（这对疫苗安全性很重要）。根据现有有限研究，只有在接种时已知猫冠状病毒抗体阴性的猫才可能产生某种程度的保护，而猫在 16 周龄或更大时冠状病毒抗体呈阴性并不常见；许多幼猫在这个年龄之前就已感染冠状病毒。此外该疫苗含一种病毒株（FIP 病毒血清型 II 毒株），与世界上一些经过充分研究的地区发现的具有临床重要性的病毒株不同，不会诱导针对在美国和欧洲主要流行的血清型 I 毒株的交叉保护反应 |
| 贾第鞭毛虫属疫苗 | 没有足够的科学证据证明使用疫苗的合理性 |
| 犬小孢子菌疫苗 | 没有足够的科学证据证明使用疫苗的合理性 |

6. 接种方案与加强免疫间隔', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 幼犬幼猫基础免疫与 26 周龄复种', '6.1 幼犬幼猫基础免疫与 26 周龄复种

- 幼犬 **6 至 8 周龄**首次接种 CDV、CAV 和 CPV 疫苗，然后每 **2 至 4 周**接种一次，直至 **16 周龄或以上**；接种频率越高易感窗口越窄；**不建议接种疫苗的频率超过每两周一次**；其中最重要的是 16 周龄或以上接种的那一剂。
- 幼猫三价核心疫苗首注在 **6 至 8 周龄**，然后每 **2 至 4 周**注射一次，直至 **16 周龄或以上**，随后在 **26 周龄或以上**注射一剂。
- VGG 建议在最后一次幼犬疫苗接种后至少 4 周（即 **20 周龄或 20 周龄后**）进行血清学检测，**或者在 26 周龄或 26 周龄后不久再进行一次疫苗接种**。该建议**取代**了之前关于在 12 至 16 月龄进行"首次年度加强免疫"的建议；VGG 先前（Day 等, 2016）建议 **26 至 52 周龄**接种，本版修订为 26 周龄或之后不久。**20 周龄以上血清学检测显示对 CPV、CDV 和 CAV 有保护作用的幼犬不需要 26 周龄以上的疫苗接种。** 这一提早复种的建议并不排除在大约 1 岁时进行第一次年度健康检查并注射狂犬病疫苗及必要的非核心疫苗。
- 幼猫/幼犬最后一次 MLV 核心疫苗接种：**不早于 16 周龄**；暴露风险特别高的地区 **18 至 20 周**可能更合适。若只能接种一次（例如成本限制），应在 16 周龄以上接种核心疫苗。
- 一些获得许可的疫苗说明书建议幼犬接种程序在 **10 周龄或 12 周龄**内完成；然而一些支持性实验证据因"围栏效应"（实验幼犬集体分组饲养、共享黏膜排出的疫苗病毒）而人为增加了接种机会、可能高估收益。因此 VGG 继续建议**不早于 16 周龄完成接种**。
- VGG 强烈支持早期社会化；尚未完成完整幼犬基础接种的幼犬应在受控条件下社交，只允许与健康幼犬和疫苗接种完全的成年犬接触。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 成年动物复种间隔与 DOI', '6.2 成年动物复种间隔与 DOI

- **一旦幼犬产生了积极的免疫应答，随后复种疫苗的频率不得超过每三年一次**。如果在 26 周龄以上接种了核心疫苗，为使核心接种与年度健康检查同步，下一剂可能会在 3 岁时接种（而不是等到 3.5 岁）。
- 接种史未知或不完整的成年犬：单剂 MLV 核心疫苗很可能足以诱导 26 周龄以上宠物犬产生免疫力；高风险情况（例如疫情爆发）应考虑在 **2 至 4 周**后给予第二剂。接种史未知或不完整的成年猫：单剂 MLV FPV 疫苗足以诱导大多数 26 周龄以上宠物猫持久免疫；但鉴于 MLV FHV 和 FCV 疫苗效力不如 MLV FPV 疫苗，VGG 支持制造商间隔 2 至 4 周注射两剂的建议。**重要的是，如果使用灭活核心疫苗（FPV、FHV、FCV、FeLV），建议提供两剂疫苗进行免疫。**
- 成年"低风险"猫（不去寄宿猫舍的独居室内动物）每隔 3 年或更长时间复种 MLV 核心疫苗；"高风险"猫可能需要最多每年一次，寄养的猫可在每年去寄宿猫舍之前 1 至 2 周注射 FCV/FHV 疫苗。一些国家还可在经典三价疫苗之外获得二价 FCV/FHV 疫苗，使兽医能每年为高风险猫接种 FCV/FHV、并每三年或更低频率接种 FPV。
- **未接种疫苗的成年犬方案**：单针狂犬病和 MLV 核心疫苗就足够了，但**必须接种两剂钩端螺旋体疫苗**；此后 CDV、CAV-1 和 CPV 复种频率不得超过每 3 年一次，钩端螺旋体病疫苗需每年复种，狂犬病疫苗按当地法规或产品说明书复种；灭活非核心疫苗需接种两剂、间隔 2 至 4 周，此后每年一次。**未接种疫苗的成年猫方案**：间隔 **2 至 4 周**接种两剂核心 MLV 疫苗（FPV、FCV、FHV），流行地区再加一剂狂犬病疫苗；< 1 岁的幼猫、可户外活动的年长猫或与其他可户外活动猫同室的猫也应接种 FeLV 疫苗（两剂，之后按产品说明书每 2 至 3 年复种）；低风险猫复种核心三价 MLV 疫苗不超过每 3 年一次；高风险猫**每 3 年复种一次 FPV 疫苗，每年复种一次 FHV 和 FCV 疫苗**。
- 非核心疫苗通常需要每年接种一次。若允许保护"失效"，作为预防措施建议"重新开始"并提供两剂、间隔 2 至 4 周。
- **DOI 数值**：正确运输储存且有质量保证的犬核心 MLV 疫苗可提供至少 **3 至 4 年**的保护，据报道攻毒试验表明免疫力可持续至少 **7 年**。猫核心 MLV 疫苗可在至少 **3 至 4 年**内有效预防 FPV；灭活疫苗可为 FCV 和 FHV 提供长达 **7.5 年**的部分但具有临床意义的保护（被攻毒的猫处于无压力环境）。钩端螺旋体疫苗提供相对短期免疫、被认为**少于 18 个月**，多项攻毒试验证明保护至少持续 **12 至 14 个月**；**没有证据表明每 6 个月接种一次**比每年一次提供更好的保护。大多数非核心疫苗 DOI 约 **1 年**。犬猫鼻内/口服（支气管败血鲍特菌 ±CPiV）疫苗只需在收容时接种一次，可提供 **13 个月**的 DOI。
- 针对呼吸道病原体的犬非核心疫苗与 CIV 疫苗均不能预防感染，但可减轻疾病的严重程度。**没有可以预防 FHV 感染的疫苗**——感染通常导致病毒潜伏在神经组织中并可能在应激期间重新激活。FCV 疫苗可对多种毒株产生一定交叉保护，但完全接种疫苗的成年动物仍有可能发生感染和疾病；一个国家内 FCV 也存在巨大遗传变异性。若免疫完全的猫出现 FCV 相关疾病，建议改用包含不同毒株的不同疫苗品牌。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 疫苗剂量', '6.3 疫苗剂量

成年家养犬体重存在几乎 **100 倍**的差异，但疫苗制造商仍建议各种体型的成年犬接种**相同剂量**。**VGG 不鼓励兽医在这方面偏离制造商的建议，也不建议给小型犬注射一半或 1/4 剂量（即不少于全剂量）**。部分疫苗降低了被认为与许多不良反应相关的佐剂成分（例如牛血清白蛋白）的浓度；部分疫苗重新配制后，更小容量（例如 **0.5 mL**）中可含有相同数量的抗原。

7. 收容所和庇护所犬猫的疫苗接种', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 原则', '7.1 原则

- 两种基本类型：传统收容所（为流浪动物提供临时住房，周转率较高、居住时间较短）与庇护所（基于长期居住和低流动性的更稳定动物群）；均接纳来自社区随机来源、多数事先没有接受过兽医护理的动物，大大增加传染病引入传播与地方病形成风险。适合低暴露风险家庭环境的方法对高风险收容所环境并不理想。
- 收容所兽医协会《动物收容所护理标准指南》第二版：收容所疫苗方案与私人诊所不同，主要区别包括**青少年猫的年龄范围更早且更长，疫苗之间的时间间隔更短，以及不同的核心和非核心产品**；接种风险评估针对整个群体进行。
- 最佳收容所方案三个组成部分：① 在接收时为所有动物接种核心疫苗；② 使用可快速诱导保护力的疫苗；③ 在幼年动物 **1 月龄**时开始基础疫苗接种，并在收容所中**每 2 至 3 周**重复一次，直至 **5 月龄**。（执行摘要表述为"从 4 周龄开始，每 2 至 3 周接种一次疫苗，一直持续到 5 月龄"；两处均照录。）
- 大多数 6 月龄以内的幼犬和幼猫，以及 **30% 至 50%** 的成年犬和成年猫在进入收容所时几乎没有或检测不到 CDV、CPV、FPV、FHV 和 FCV 抗体。**所有犬和猫入院后立即接种疫苗是基石；即使延迟 1 天也会显著增加群体中感染和传播疾病的风险**。
- MLV 被认为是收容所的首选疫苗，因为通常能提供更快的免疫力并更早突破 MDA 干扰。收容所中犬的核心疫苗包括改良活 CDV、CPV、CAV-2、CPiV 和支气管败血鲍特菌；收容所中猫的核心疫苗是改良活 FPV、FHV 和 FCV。
- **所有摄入 MLV 核心疫苗的犬和猫都应进行全面接种**，包括流浪动物、被弃养的宠物、狂犬病检疫扣留的动物、被虐待的动物、怀孕或哺乳期的动物、患有轻微疾病或受伤的动物，以及诱捕-绝育-释放（trap-neuter-return, TNR）或重返家园（RTF）计划的社区犬猫。简而言之：如果犬或猫在接收时无法安全地接种 MLV 核心疫苗，那么该动物会因感染风险太大而无法留在收容所。**将疫苗接种局限在可领养的动物会造生大量易感动物，随后会发展成地方性疾病和比免疫成本更高的疾病暴发。**
- 高达 **37%** 的幼猫和不太确定比例的幼犬已被证明在 4 月龄后对一种或多种核心疫苗的应答受到持续 MDA 的干扰；因此收容所幼犬和幼猫的核心疫苗接种应持续至 **5 月龄**，并为 5 月龄以上收容所的犬间隔 2 至 3 周注射两剂 MLV 核心疫苗。
- 收容所和 TNR/RTF 计划中同时接种疫苗与绝育的做法很普遍；多项研究表明麻醉和手术不会显著削弱对疫苗接种的抗体应答。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 表 3 收容所中犬的核心疫苗', '7.2 表 3 收容所中犬的核心疫苗

| 疫苗 | ≤5 月龄 | >5 月龄 | 注释 |
|------|---------|---------|------|
| CDV+CAV+CPV+CPiV（MLV，肠外）；重组 CDV 与 MLV CAV+CPV+CPiV（肠外） | 接收后立即接种，最早从 1 月龄开始接种，每 2 至 3 周重复一次，直至 5 月龄 | 入院后立即接种，2 至 3 周重复一次 | 使用含有改良活病毒或重组 CDV 的联合疫苗可更快产生免疫力 |
| 支气管败血鲍特菌 + CPiV（改良活，鼻内）；支气管败血鲍特菌 + CPiV + CAV（改良活，鼻内） | 从 3 周龄开始，接收时立即接种 | 入院后立即接种 | 为了快速产生最佳免疫力，优选含有改良活支气管败血鲍特菌和至少 CPiV 的鼻内疫苗。最早可在 3 周龄时给予 |
| 支气管败血鲍特菌（改良活，口服）；支气管败血鲍特菌 + CPiV（改良活，口服） | 根据所选择的疫苗，从 7 或 8 周龄开始，接收时立即接种 | 入院后立即接种 | 口服疫苗可用于 7 或 8 周龄及以上的犬，但鼻内疫苗必须用于更幼龄的犬 |
| 狂犬病病毒（灭活，肠外） | 遵守当地法律规定的疫苗最低接种年龄。在短期寄养收容所出院时或进入长期庇护所入院时进行接种 | 原文此处缺失 | 仅限狂犬病流行国家。根据当地法律进行管理 |

（缩写注：CDV 犬瘟热病毒、CAV 犬腺病毒 2 型、CPV 犬细小病毒 2 型、CPiV 犬副流感病毒、MLV 改良活病毒。）

7.3 表 4 收容所中猫的核心疫苗

| 疫苗 | ≤5 月龄 | >5 月龄 | 注释 |
|------|---------|---------|------|
| FPV+FHV+FCV（MLV，肠外） | 接收后立即接种，最早从 1 月龄开始接种 | 接收后立即接种，2 至 3 周重复一次 | 使用含有改良活病毒的联合疫苗可快速产生免疫力 |
| FPV（MLV，鼻内） | 每 2-3 周重复一次，直到 5 月龄 | 原文此处缺失 | 不建议在收容所使用鼻内 FPV 疫苗，因为它们不能提供针对 FPV 的可靠保护 |
| FHV+FCV（MLV，鼻内） | 原文此处缺失 | 原文此处缺失 | 含有改良活病毒的鼻内疫苗。FHV+FCV 可更快起效 |
| 狂犬病病毒（灭活，肠外） | 请遵守当地法律规定的疫苗最低接种年龄。在短期住宿收容所出院时或入住长期庇护所时进行接种 | 原文此处缺失 | 仅限狂犬病流行国家。根据当地法律或法规进行管理 |

（缩写注：FPV 猫泛白细胞减少症病毒、FHV 猫疱疹病毒-1、FCV 猫杯状病毒、MLV 改良活病毒。）', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 收容所操作要点与非核心疫苗', '7.4 收容所操作要点与非核心疫苗

- 支气管败血鲍特菌 ±CPiV 疫苗针对家养犬是非核心疫苗，但因疾病暴露和传播的高风险导致广泛发病率，对收容所中的犬是核心疫苗。**所有成年犬和至少 3 周龄大的幼犬均应在入院时接种鼻内改良活支气管败血鲍特菌疫苗**，这些疫苗可在 **3 至 7 天内**诱导针对两种病原体的快速黏膜免疫应答，并显著减少临床疾病和病原体脱落。当鼻内接种不可行时，可给成年犬和至少 **7 或 8 周龄**的幼犬口服支气管败血鲍特菌疫苗；口服几乎与鼻内一样有效，两者均优于含细胞抗原提取物的肠外灭活疫苗。
- 收容所猫必须使用含改良活 FPV 的肠外疫苗；一些国家提供含 FHV 和 FCV 的鼻内 MLV 疫苗，可在 **4 至 6 天内**产生快速保护。
- 狂犬病病毒是狂犬病流行地区收容所犬猫的核心疫苗。动物短期停留的收容所建议在被收养时接种；根据当地法律，预计停留数月的犬猫都应在接收时接种；长期收容所和庇护所中的犬猫应遵守当地法律复种。
- **犬非核心**：伯氏疏螺旋体、钩端螺旋体病和 H3N8/H3N2 犬流感疫苗限制在收容所内使用。若记录的病例显示暴露风险较高，应根据制造商说明为收容所中每只犬和每只新入院犬启动基础接种；短期收容所中许多犬在完成基础接种前就已离开，应鼓励收养者后续接种。存在重大暴露风险时，应将这些疫苗纳入终生庇护所或预计停留超过数月犬的接种计划。
- **猫非核心**：FeLV 疫苗对收容所内猫是非核心疫苗。根据 2020 年 AAFP 猫逆转录病毒检测和管理指南，**所有猫在接种 FeLV 疫苗之前都应进行 FeLV 感染检测**。资源较差的收容所中单独饲养的猫没有必要进行 FeLV 检测和接种。在猫群体饲养的收容所中，FeLV 检测对识别未受感染的猫至关重要；群养猫的 FeLV 接种取决于停留时间——建议长期居住收容所或庇护所中群养的猫接种，不建议短期居住收容所中群养的猫接种。
- 支气管败血鲍特菌和猫支原体疫苗是收容所内猫的非核心疫苗。当收容所中有因确诊支气管败血鲍特菌感染而患肺炎的咳嗽猫时，应在入院时对所有至少 **1 月龄**大的猫进行数月的鼻内改良活疫苗接种。支气管败血鲍特菌可在犬和猫之间发生种间传播。

8. 疫苗接种后的不良事件（AEFVs）与报告', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 定义与报告要求', '8.1 定义与报告要求

- 不良事件（adverse events following vaccination, AEFV）是疫苗接种后产生的有害的、意外的后果（**包括缺乏保护**）。通常会观察到注射部位疼痛和肿胀等局部反应，以及嗜睡、厌食、发烧和呕吐等全身反应；荨麻疹和过敏反应不太常见；罕见更严重后果例如猫注射部位肉瘤。
- **即使仅仅是怀疑它们与疫苗接种相关，也应报告 AEFVs**。每份报告应注明所涉及的疫苗产品（**包括批号**）、涉及动物的详细信息、不良事件的详细信息以及提交报告的兽医的联系方式，发送给**制造商和当地监管机构**；一些国家政府监管计划尚不存在，因此只能报告给制造商。
- VGG 承认存在 **AEFVs 的严重漏报**；注册前的安全性研究只会监测相对常见的不良事件，罕见的不良事件通过上市后监测和对报告的不良事件的分析来发现。

8.2 发生率

- 日本对 2006 至 2007 年注射的犬类非狂犬病联合疫苗的研究：**573** 家兽医医院注射了 **57,300** 次疫苗，共有 **359** 只犬发生 AEFVs，即每 10,000 只接种疫苗的犬中有 **62.7 只**；死亡 1 只，过敏反应 41 只，胃肠道症状 160 只，皮肤病症状 244 只，其他临床症状 106 只；总共 **83.3%** 的 AEFVs 在接种后 12 小时内被发现；出现过敏反应的犬全部在接种后 60 分钟内出现，其中近一半（**46.3%**）在 5 分钟内出现。
- 美国早期研究：每 10,000 只接种疫苗的犬中有 **38 只**在接种后前 3 天内记录了各种类型的不良事件；每 10,000 只接种疫苗的猫中有 **52 只**在前 30 天内记录。
- 美国近期对近 500 万只犬的研究表明，**品种似乎是发生可能性的决定因素且与体重无关**：法国斗牛犬、腊肠犬和波士顿梗犬风险最高（FAQ 处另列为腊肠犬、波士顿梗犬、小型杜宾犬、法国斗牛犬和哈瓦那犬）；每次就诊时接种多种疫苗的小型犬（体重 **< 5 公斤**）风险特别高；不良事件率也随着同一次就诊中接种的不同疫苗数量的增加而增加。
- 与小型犬相比，大型犬和巨型犬更有可能对狂犬病疫苗不能产生足够的免疫应答；体重与抗 CPV 和抗 CDV 抗体应答的强度呈负相关。', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 疫苗缺乏效力与管理不善', '8.3 疫苗缺乏效力与管理不善

- **疫苗缺乏预期效力是一种不良事件**；幼年动物一个很常见的原因是母体转移的初乳抗体引起的干扰。**疫苗管理不善**可能是原因之一，这是一个令人惊讶的普遍问题；门诊应考虑指定特定工作人员负责监督、监测和报告疫苗管理情况。
- 批量重组的疫苗在抽取和注射之前静置数小时就可能失去效力，尤其影响更脆弱的疫苗成分（例如 CDV）。放在冰箱中距离冷冻室太近的疫苗可能冻结失效；应定期检查冰箱能否可靠地控制内部温度（**通常为 2 至 8°C**），某些地区必须测量每日温度并记录在案。
- 使用多剂量小瓶（例如单瓶 **10 剂**狂犬病疫苗）时，如果抽取前没有充分混合疫苗悬浊液，可能导致缺乏效力，也可能导致某些受种者接种过量。
- 在每天就诊开始之前预先配置好多份疫苗是**不对的**：室温下一些较敏感的疫苗成分（例如 CDV、FHV）可能会在几小时后失去免疫能力。VGG 建议**在使用前重新配制 MLV 疫苗**。', 'dog', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 猫注射部位肉瘤（FISS）与注射解剖部位', '8.4 猫注射部位肉瘤（FISS）与注射解剖部位

- 疫苗和其他注射产品与猫注射部位肉瘤（feline injection-site sarcoma, FISS）的发病机制有关；发病机制仍不确定，但有一些证据表明含佐剂的疫苗可能比不含佐剂的疫苗影响更大。传统上大多数皮下注射都注射到猫的**肩胛间沟**，这对 FISS 发展仍是一个具有挑战性的解剖位置。**建议不要在猫的这个解剖位置进行皮下注射。**
- 北美提出**"左腿白血病"（FeLV 疫苗）和"右腿狂犬病"（狂犬病疫苗）**的建议：尽可能远端注射，**最好在膝关节处或以下**；这仍是当前 AAHA/AAFP 指南推荐的位置。**VGG 强烈支持；皮下注射疫苗优于肌内注射途径，因为肌内 FISS 通常比皮下 FISS 更难发现。**
- 在一些被认为 FISS 远不如北美流行的国家，当地指南小组提出在**肩关节背中线外侧 4 厘米**处接种疫苗，逻辑是确保任何接种后增长的肿块更早被发现。**远端肢体注射疫苗仍然是黄金标准方法，应大力鼓励采用。**
- **"3-2-1"规则或方法**（2020 年 AAHA/AAFP 猫疫苗接种指南，VGG 强烈认可并推荐）：任何疫苗接种后肿块 (1) 在疫苗接种 **3 个月**后仍然存在；(2) 在任何时间点直径大于 **2 厘米**；(3) 接种后 **1 个月**体积仍增大者应行**切开活检**（建议切开活检而不是切除活检）。
- 尾部注射：2014 年一项研究中来自社区 TNR 计划的成年猫在**尾背远端三分之一处**注射三价 MLV 核心疫苗（FPV、FHV、FCV），并在三价疫苗接种部位**远端 2 厘米**处注射灭活狂犬病疫苗；所有猫均发生 FPV 血清转化，除一只猫外其他所有猫均发生狂犬病病毒血清转化；尾部注射仍需进一步研究。
- VGG 关于 FISS 的意见：不应在猫的肩胛间沟内进行皮下注射；如果皮下注射是合法的替代方法，则不应肌肉注射疫苗；每次使用时应将疫苗注射到不同的解剖部位；**建议在已知发生 FISS 且有替代疫苗选择的国家优先使用无佐剂猫疫苗，而不是含佐剂疫苗；如果没有可接受的替代品，那么接种含佐剂的产品比完全不接种要好得多**；注射的解剖部位应记录在病历或疫苗接种卡上，每次都应"轮换"注射部位；鼓励所有疑似 FISS 病例通过国家报告途径上报或向制造商通报。
- 人健康影响：有人认为经黏膜使用的改良活细菌疫苗（例如一些支气管败血鲍特菌疫苗）对某些人类（包括囊性纤维化患者）构成健康危害；尽管风险似乎很小，有人建议在注射改良的支气管败血鲍特菌黏膜活疫苗时要求免疫功能低下的宠主离开诊室。假设亚单位或灭活疫苗能提供同等保护，使用这些疫苗对免疫功能低下的宠主可能更安全。', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 事件处理与相关 FAQ', '8.5 事件处理与相关 FAQ

- 接种后曾有过严重不良事件（严重荨麻疹或面部水肿、过敏反应或免疫介导性疾病）的中年犬：如果引起不良事件的疫苗是 MLV 核心疫苗且此犬之前已根据指南接种过，那么犬很可能仍然受到保护，**并不需要复种疫苗**；如主人特别担心可进行金标准血清学检测。狂犬病疫苗必须咨询地方当局。如果引起不良事件的是支气管败血鲍特菌注射疫苗，推荐使用替代疫苗（例如鼻内或口服）。如果是钩端螺旋体病疫苗且犬为高风险，则应复种，可使用含非常低浓度佐剂（例如牛血清白蛋白）的新型疫苗。
- **复种疫苗前使用抗组胺药或抗炎剂量的糖皮质激素是可以接受的，不会干扰疫苗的免疫应答。**复种疫苗的敏感动物应在接种后 24 小时内密切监测；I 型超敏反应通常在接触后数分钟至 1 小时内发生，其他类型（II、III 或 IV 型）可能晚得多（数小时至数月）。
- 有免疫介导性疾病史的成年犬（免疫介导性溶血性贫血［immune-mediated haemolytic anaemia, IMHA］、免疫介导性血小板减少［immune-mediated thrombocytopenia, ITP］或多发性关节炎）：**无论是否注射加强疫苗，所有免疫介导性疾病都有可能复发**；上述 3 种疾病在诊断后最初几个月内复发率较高，这通常是犬接受较高剂量免疫抑制剂的时期，**在此期间不应接种疫苗**；**12 个月后复发率大大降低（通常为 10% 至 15% 的患病动物）**。IMHA 回顾报告中，从 IMHA 康复的 44 只犬中有 22 只接受了加强免疫，22 只中的一只在注射加强疫苗后出现 IMHA 复发。ITP：22 只缓解犬中 9 只没有接受加强免疫，另外 12 只在几年间多次接受加强疫苗，**两组中都没有犬复发**。如果在加强疫苗接种后 4 周内出现复发，应向有关当局报告此不良反应。
- 犬舍不断出现犬只死于 CDV 和 CPV-2 感染：最可能的原因是繁育母犬没有充分接种疫苗；相反，如果未按指南进行幼犬接种（16 周龄或以上进行最后一次接种），则可能造成超过 12 周至 14 周失去 MDA 保护的幼犬处于风险中。
- 幼犬 9 周龄接种 CPV 疫苗、10 周龄出现细小病毒性肠炎：常见原因是该动物在接种之前已处于潜伏期；也可能在"易感窗口"期间被感染。
- 猫"过度接种疫苗"与慢性肾病（chronic kidney disease, CKD）：2016 年基于问卷的研究显示宠主报告的猫（> 9 岁）频繁接种疫苗与 CKD 氮质血症之间存在关系（148 只猫中的 27 只），但**并没有证明因果关系**；年龄和牙周病是其他独立危险因素。据报道将 CRFK 细胞裂解物或在 CRFK 细胞上生长的疫苗注射到实验猫体内会诱导产生可与猫肾组织结合的抗体；对猫超量接种 CRFK 细胞裂解物后 6 只猫中的 3 只出现淋巴浆细胞性间质性肾炎。然而最近一项研究中使用 FPV/FCV/FHV 疫苗（而不是细胞裂解物）过度接种（在 14 周内接种八次疫苗）**不会诱发 CKD，也不会诱发间质性肾炎**。**成年猫每年/频繁接种疫苗尚未被证明会导致慢性肾病**。
- 顺势疗法"nosodes"**不能**成功使宠物免疫；关于其安全性和有效性的证据非常少，在少数出版物中已被证明缺乏疗效。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 特殊情形', '9. 特殊情形

9.1 妊娠与繁育

- 虽然没有足够的证据表明怀孕期间接种疫苗会造成伤害，但通常建议**尽可能避免在怀孕期间为母犬接种疫苗**；理想情况下应在怀孕前接种所需的疫苗。如果怀孕期间需要核心疫苗，从历史观点上说建议使用灭活疫苗而不是 MLV 疫苗，尽管现在越来越多的犬 MLV 疫苗被批准在怀孕期间使用。**怀孕的母猫和 < 4 周龄的幼猫不宜接种减毒活疫苗**；灭活核心疫苗（FPV、FHV、FCV、FeLV）对怀孕母猫被认为比 MLV 疫苗更安全。
- 一些专家建议每年而不是每三年对繁育母猫复种一次 MLV 疫苗，以最大限度提高初乳中的抗体浓度；然而在怀孕期间给已经免疫的动物注射额外的 MLV 剂量只会提高少数繁育母猫的血清抗体水平。**没有 MLV 疫苗被批准用于繁育母犬**；需要咨询疫苗制造商。

9.2 幼龄动物

- **不可以给 4 周龄以下的幼犬接种疫苗**：这个年龄段大多数犬含有母源抗体，可阻止疫苗免疫应答；产品说明书也不支持这种做法。**一个例外**是使用针对犬传染性呼吸道疾病综合征（canine infectious respiratory disease complex, CIRDC）的鼻内疫苗，从 **3 周龄**起就可以安全地使用。
- 如果幼犬或幼猫没有接受任何初乳：根据抗体滴度，它们将很少被保护，或者更可能没有保护。
- 如果幼犬鼻内接种后打喷嚏，**不需要再次接种**：这些疫苗的设计允许产品部分损失。
- 如果动物接受了第一剂需要两剂才能完成免疫的疫苗（例如钩端螺旋体菌苗或 FeLV 疫苗）而在 6 周内没有注射第二剂：**应假定双剂疫苗中单剂不能提供任何免疫力**，需要重新开始该方案，确保根据产品说明书在 2 至 4 周内注射两剂。

9.3 老年动物

- 几乎没有证据表明根据这些指南终生接种疫苗的老年犬和猫需要在生命后期进行专门或强化的核心疫苗复种计划。大多数老年犬和猫对核心 MLV 疫苗具有持久的免疫记忆，接种单剂后防御能力迅速恢复；但老年动物可能无法有效地对以前未遇到过的新制剂或抗原产生初级免疫应答。
- 在最近的一项研究中，与 1 至 3 年前接种过疫苗的老年犬相比，**接种疫苗 3 年以上的老年犬不太可能产生针对 CDV 和 CAV 的保护性抗体滴度**；基于这些发现，**建议老年宠物每三年或更频繁地复种疫苗**。
- 对英国因为宠物旅行首次接种狂犬病疫苗的犬和猫的研究清楚表明，许多老年动物未能达到法律要求的抗体滴度；年龄较小的动物更有可能成功免疫。
- **停止给老龄犬接种疫苗是不合适的。** 对于核心 MLV 疫苗，目前建议终身接种疫苗的频率不超过每 3 年；如果选择使用钩端螺旋体病疫苗或非核心疫苗，通常需要每年接种一次。', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 免疫抑制、患病与感染逆转录病毒的动物', '9.4 免疫抑制、患病与感染逆转录病毒的动物

- **糖皮质激素**：在接种疫苗之前或同时进行抗炎甚至免疫抑制糖皮质激素治疗，对疫苗产生抗体没有显著的抑制作用。但仍建议在治疗结束后复种疫苗：**对于短疗程的糖皮质激素，应在停药后至少 2 周复种疫苗；对于较长的疗程，此间隔应延长至 3 个月**。如果使用糖皮质激素治疗严重疾病，应推迟疫苗接种直到动物恢复健康。对糖皮质激素接受者使用金标准技术进行血清学监测（针对 CPV、CDV、CAV 和 FPV）可确保动物不会失去对核心疾病的保护。
- **强效免疫抑制或抗肿瘤治疗（糖皮质激素除外）**：如果潜在疾病已得到良好控制且动物看起来很健康，应寻求临床专科医生的建议。关于核心 MLV 疫苗，假设动物在幼犬/幼猫时已完成接种疫苗，**那么最好是等待**。一项研究中，肿瘤患犬接受化疗后未检测到 CDV、CPV 和狂犬病病毒滴度发生显著变化。鼓励使用金标准技术进行血清学检测；**如果需要，可以在强效免疫抑制或抗肿瘤治疗结束后 3 个月内复种核心 MLV 疫苗**。
- **高剂量环孢素治疗的猫**：一项研究表明，对治疗期间加强注射的 FPV 和 FCV 疫苗有正常的血清学反应，但对 FHV、FeLV 和狂犬病的反应延迟；接受治疗的猫在初次接种 FIV 疫苗后未能产生抗体。
- **钩端螺旋体病与免疫抑制**：免疫抑制治疗可能会降低钩端螺旋体病疫苗的功效，但并不一定，特别是如果犬一年前接种过——犬可能保留免疫记忆；菌苗疫苗比 MLV 疫苗造成伤害的可能性更小。
- **持续感染 FeLV 或 FIV 且临床表现良好的猫**：感染 FeLV 的猫不应接种 FeLV 疫苗，感染 FIV 的猫不应接种 FIV 疫苗，因为接种对已感染的猫没有益处。对于外表健康的感染逆转录病毒的猫，所有其他接种决定应基于个体化的风险效益评估；**感染逆转录病毒的猫不应避免接种疫苗**。选择使用灭活或重组疫苗而不是 MLV 疫苗可能是谨慎的做法。有人建议即使感染 FeLV 的猫 100% 在室内，也需要每年复种 FHV、FCV 和 FPV；允许户外活动的 FIV 感染猫也需要每年针对这些核心病原体复种；100% 生活在室内的 FIV 感染猫可以减少接种（例如每三年一次）。在狂犬病流行地区，狂犬病接种应照常遵循当地规定。
- **莱姆病**：ACVIM 共识更新的作者并未就是否建议伯氏疏螺旋体流行区的犬使用疫苗达成共识，但他们**一致认同患病或蛋白尿的犬不应该接种疫苗**。
- **野生或外来物种**：不可以。切勿随意接种 MLV 疫苗，除非已证明 MLV 疫苗对您要保护的物种是安全的——许多 MLV 疫苗用于最初获得许可的物种以外的动物时会导致疾病和死亡；毒株可能会从野生动物身上脱落、传播并通过多次传代重新获得毒力。一种安全有效的重组金丝雀痘病毒载体 CDV 疫苗已在一些国家获得许可用于雪貂，也被建议作为许多野生和外来物种的标签外犬瘟热疫苗选择，因为它不含活的犬瘟热病毒。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 同时接种与操作注意', '9.5 同时接种与操作注意

- 没有疫苗接种史的成年犬或猫**可以立即注射所有必需的疫苗**。**重要的是，除非产品说明书支持，否则切勿在同一注射器中混合不同的疫苗；建议在不同的解剖部位注射不同的疫苗。**
- 多价疫苗中不同抗原的数量**不会**对疫苗的效力产生不利影响：健康犬或猫的免疫系统每天会受到大量不同抗原的攻击；多价疫苗若要获得许可，制造商必须证明每种成分都可以诱导保护性免疫应答。
- 即使动物患病的风险非常高（例如在收容所中），**不建议每周接种疫苗**：过于频繁复种可能无法让免疫应答有足够的时间正常进行，而且疫苗抗原可能会与 MDA 结合。
- 若犬或猫在 **3 年前**接受了最后一次核心 MLV 疫苗，**不需要**重新开始基础接种（即间隔 2 至 4 周接种两剂）——仅幼犬或幼猫需要多次注射；对于 MLV 疫苗，单剂就足够了。
- 在猫身上使用注射 MLV FHV/FCV 疫苗时，**需避免使任何用于皮下或肌肉注射的改良活 FHV/FCV 疫苗雾化**（例如不要轻弹注射器并试图喷出微小的气泡）。诊室中的雾化疫苗可能会接触到猫的黏膜，这可能会导致疾病。如果一些疫苗从注射部位渗漏到猫的皮毛中，应尽可能清除，然后在最后的清洁步骤之前在受影响区域应用消毒剂。
- 对于攻击性犬，**不可以**皮下注射支气管败血鲍特菌鼻内活疫苗：可能会引起严重的局部反应，甚至严重的全身性疾病（例如肝病）并导致动物死亡。同样**不可以**鼻内给予用于皮下注射的灭活支气管败血鲍特菌疫苗：这样不会刺激有效的免疫应答。
- 关于毒株的地域匹配：使用含有当地重要毒株的疫苗对**钩端螺旋体**疫苗确实如此，但对预防 CDV、CAV、CPV、FPV、FHV、FeLV 和狂犬病病毒的疫苗则没必要。

10. "同一个健康"、群体免疫力与法规要求', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 当代与新兴主题', '10.1 当代与新兴主题

- 一些国家受益于疫苗接种的宠物比例较低，会对"群体免疫力"产生不利影响。原文论断：**对群体中小部分宠物进行频繁的复种疫苗对于提高群体免疫力几乎没有作用；相反，增加接种疫苗的宠物的比例，即使每只宠物只接种一种合适的核心疫苗，也会取得更大的效果。**
- **疫苗犹豫（vaccine hesitancy）**：被描述为"……尽管有疫苗接种服务，但仍延迟接受或拒绝疫苗接种"（MacDonald, 2015）。**2019 年对疫苗犹豫不决的态度被列为全球人类健康面临的十大威胁之一**；仅 2020 年就发表了 350 多篇相关论文。原文指出该描述对小型伴侣动物从业者还不够全面——许多选择不给宠物接种疫苗的人在没有咨询兽医的情况下就这样做了，他们不会延迟接受，也不会拒绝，只是避免任何讨论。
- **接种率数据**：PDSA 2019 年 PAW 报告中只有 **72%** 的主人表示他们的幼犬已接受基础疫苗接种（低于 2016 年的约 88%）；幼猫为 **61%**（低于 2016 年的约 82%）。"太贵"是不接种的首要原因（占所有宠物主人的 **17%**）；对成年猫的主人来说，不想因带猫去诊所而给猫带来压力是比成本因素稍强的阻碍（**22%** 对比 **21%**）。Taylor 等（2022）对近 100 万只英国犬的研究表明，12 个月研究期间只有 **49%** 接种了至少一种钩端螺旋体病疫苗；8 岁以上的犬接受钩端螺旋体病接种的可能性比 1 岁以下的犬低 **12.5 倍**。Malter 等（2022）美国研究中，犬钩端螺旋体病临床接种率中位数为 **70.5%**、支气管败血鲍特菌为 **68.7%**；猫 FeLV 成年猫中位数较低（**34.6%**），幼猫和 1 岁猫略高（**36.8%**）。
- **过度、无根据的"疫苗负荷"**仍然令人担忧；含有核心和非核心成分混合物的多成分疫苗仍然很常见；至少在一个国家，单价疫苗的选择已经减少而不是扩大（例如澳大利亚已不再可能购买单价 FeLV 疫苗，唯一选择是含 FeLV 的五价灭活疫苗）。**VGG 鼓励制造商尽可能生产全系列疫苗，或者至少提供仅包含核心疫苗的组合**，以用于无法合理使用非核心疫苗的情况。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · "同一个健康"（One Health）与人畜共患病', '10.2 "同一个健康"（One Health）与人畜共患病

"同一个健康"的概念从未像今天这样与伴侣动物诊所更加相关；COVID-19 大流行曾阻止宠物主人获得及时的兽医护理、尤其是疫苗接种。用于人类病原体的新疫苗平台技术可能会促进创新兽用疫苗的开发。

- **狂犬病**：在狂犬病流行的地方，即使立法没有要求，所有犬和猫都应该接种疫苗以保护宠物和人类；**大规模犬类疫苗接种已被证明可以大大减少或消除狂犬病病例**（Zimmer 等, 2018）。法律通常规定复种间隔；狂犬病疫苗通常带有 1 或 3 年的许可 DOI，复种间隔应主要基于当地法规。世界某些地区的建议是在 **12 周龄**时接种第一剂、一年后接种第二剂。**在法律要求与疫苗说明书不一致的国家，必须遵守法律；不应认为本地生产的具有 1 年 DOI 的狂犬病疫苗三年使用一次是安全有效的。**
- **钩端螺旋体病**：犬钩端螺旋体病是另一种危及生命的人畜共患疾病，在世界各地广泛分布。目前有单价、二价、三价和四价疫苗，包括 Icterohaemorrhagiae、Canicola、Grippotyphosa、Pomona 和 Australis；四价疫苗提供更广泛的保护。这些疫苗会引起强烈但短暂的血清转化；免疫力持续时间比血清阳性期长得多（长达 **15 个月**）；灭活疫苗需要进行两剂接种。**如果不确定应该接种哪种疫苗，则不能将疫苗指定为"核心"疫苗**。首选包含与所在特定地区相关的最常见血清型的获得许可的疫苗。
- **莱姆病**：伯氏疏螺旋体疫苗的使用存在争议，**蜱虫控制被认为更为重要**。没有一种针对莱姆病的疫苗可以提供完全的保护；这些疫苗的功效尚不确定，也不清楚它们是否能预防莱姆病肾炎这种最严重的疾病。
- **犬流感病毒（CIV）**：犬甲型流感病毒 H3N8 和 H3N2 已被证明是北美和东南亚国家犬类疾病的病因；CIV 会在社区中造成零星爆发，特别是在犬共同饲养的设施中（收容所、寄宿犬舍、犬日托中心、犬展和犬农场），因此对于因与其他犬混合而更有可能暴露的犬建议接种 H3N8 和 H3N2 CIV 灭活疫苗。CIV 疫苗目前仅在美国上市。
- **犬利什曼病（CanL）**：在欧洲和拉丁美洲的一些国家有针对 CanL 的疫苗。CanL 疫苗不能可靠地预防感染，因此即使接种的犬也可以成为婴儿利什曼原虫的储存库，并继续将疾病传播给其他犬和人类；接种可以预防某些犬出现疾病的临床症状，是一种辅助方法，不能替代极其重要的外用驱虫剂和杀虫剂治疗。', '', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 健康检查与就诊体验', '10.3 健康检查与就诊体验

VGG 强烈鼓励兽医向客户宣传**定期健康检查**（通常每年一次，有时更频繁）的价值，而不是谈论"疫苗接种咨询"——年度健康检查不仅仅是疫苗接种咨询，尽管它通常包括注射每年需要注射的选定疫苗。兽医还被鼓励接受旨在改善宠物、主人和兽医工作人员体验的培训；无恐惧训练计划和猫友好认证计划就是这样的例子。', 'cat', '', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'informational', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南 · 执行摘要要点（英文执行摘要 4 页浓缩）', '11. 执行摘要要点（英文执行摘要 4 页浓缩）

英文执行摘要与中文译本"执行摘要"章节内容一致；除第 1、2 节已覆盖的定位与分类外，要点为：

1. **总立场**：VGG 强烈建议**所有**犬和猫都应获得疫苗接种的益处——这不仅保护个体动物，还将提高"群体免疫力"，帮助最大限度降低传染病爆发的风险。
2. **核心构成**：世界各地犬用核心疫苗是针对 CDV、CAV（1 型）和 CPV（2 型）的疫苗；猫用核心疫苗是针对 FPV、FCV 和 FHV 的疫苗。狂犬病流行地区狂犬病疫苗接种对犬猫都应被视为必不可少的（即在这些地方狂犬病疫苗是核心疫苗），即使没有法律要求。在钩端螺旋体病流行的国家或地区，如果相关血清群已知且有合适的疫苗，强烈建议对所有犬接种并应视为当地核心。在许多 FeLV 相关疾病呈地方性流行的地区，FeLV 疫苗应被视为幼猫（< 1 岁）以及可户外活动的成年猫或与有其他户外活动的猫一起生活的猫的核心疫苗。
3. **MDA 与基础程序**：MDA 会严重干扰在幼犬和幼猫生命早期注射的大多数现有核心疫苗的功效。由于同窝内和不同窝间的 MDA 水平差异很大，VGG 建议每 **2 至 4 周**注射多剂核心疫苗，**最后一剂在 16 周龄或以上时注射**。在只能接种一次疫苗的情况下，应在 16 周龄以上接种核心疫苗。建议**在 26 周龄或之后复种疫苗**（而不是等到 12 至 16 月龄）。
4. **血清学**：VGG 支持**从 20 周龄起**使用血清学检测来检测接种后的血清转化（犬 CDV、CAV 和 CPV；猫 FPV）。
5. **不应不必要地接种**：成年动物中核心疫苗的接种频率不应超过必要的频率；大量已发表的证据表明大多数现代 MLV 核心疫苗提供的 DOI 长达多年。
6. **不推荐类**：VGG 将一些疫苗归类为不推荐疫苗，因为没有足够的科学证据证明在任何地方推荐使用这些疫苗是合理的。
7. **收容所与庇护所**：VGG 收容所指南最低规定，所有进入此类场所的犬猫都应在进入之前或进入时接种**核心 MLV 疫苗**；在经济允许的情况下，这些免疫应该从 **4 周龄**开始、**每 2 至 3 周**接种一次疫苗，一直持续到 **5 月龄**。针对呼吸道疾病的疫苗对于生活在家庭中的宠物犬被认为是非核心疫苗，但对于收容所的犬应该被认为是核心疫苗。
8. **健康检查**：强烈鼓励向客户宣传定期健康检查（通常每年一次，有时更频繁）的价值，而不是谈论"疫苗接种咨询"；大多数非核心疫苗提供的 DOI 约为 1 年。
9. **不良事件报告**：强烈鼓励兽医向**制造商和监管机构**报告所有可能的不良事件。
10. **最基本的概念**：目标应该是为每只犬和猫接种核心疫苗；在仔细考虑生活方式和当地流行情况后可能建议选择特定的非核心疫苗；核心和非核心疫苗应正确储存和管理，并仅在必要时使用，以提供终身保护。

> 说明：译本另含缩写对照表（AAFP、AAHA、ABCD、AEFV、CanL、CAV、CCoV、CDV、CIV、CKD、CPiV、CPV、DOI、EB、FAQ、FCV、FELV、FHV、FIP、FIV、FISS、FPV、Ig、IMHA、ITP、LiESP、MDA、mRNA、MLV、NPV、OA、Osp、PAW、PPV、SPC、VGG、WHO、WSAVA），本稿已在各节首次出现处以「中文（English）」形式给出。原文图 1 与图 2（对 16 周龄或以上幼犬幼猫最后一次接种 4 周以上血清学检测结果进行解释和采取行动的推荐方法流程图）的图形部分在文字提取稿中仅有图注。中文译本由"爱猫医生"实施翻译，审核毛军福；指南制定工作得到默沙东动物保健的支持，赞助公司代表没有出席 VGG 会议、公司也无权否决 VGG 的建议。利益冲突：四位作者此前都获得过一家或多家兽用疫苗制造商的财政支持。译者注：Bordetella bronchiseptica 按全国科学技术名词审定委员会 2019 年公布译为"支气管败血鲍特菌"，Revaccination 按 2012 年公布译为"复种"。', '', 'young', '', '疫苗,核心疫苗,非核心疫苗,不推荐疫苗,WSAVA VGG,CDV,指南目的与证据分级方法,疫苗分类,免疫学基础与母源抗体干扰', 'caution', '2024年WSAVA犬猫疫苗接种指南（中文整理稿）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 文件框架与执行摘要', '> 来源机构：世界小动物兽医协会（World Small Animal Veterinary Association, WSAVA）疫苗接种指南小组（Vaccination Guidelines Group, VGG）。文件：《Guidelines for the Vaccination of Dogs and Cats》（犬猫疫苗接种指南），编撰人 M. J. Day（英国布里斯托大学）、M. C. Horzinek（原荷兰乌得勒支大学）、R. D. Schultz（美国威斯康星大学麦迪逊分校）、R. A. Squires（澳大利亚昆士兰詹姆斯库克大学）；通讯作者 M. J. Day（M.J.Day@bristol.ac.uk）。原始文档：raw_extracts/WSAVA-Vaccination-Guidelines-2015.md（45 页英文 PDF，2020-01 上传版），本稿覆盖抽取分块 001–010（正文「# English」至参考文献起始、致谢止）。
> **重要提示：本 2015 版指南已被 WSAVA 2024 版犬猫疫苗接种指南取代，保留本稿仅用于历史版本对照；现行推荐请以 2024 版为准。**
> 整理约定：疫苗名、病原名、周龄/月龄、间隔、剂量、流行率数字一律照录原文；抽取稿中的断词、串行、页码残留（E1–E24）等以〔原文如此〕标注；中文术语参照官方简体中文译本（犬猫免疫指导手册，译者石慧）对照，凡译本与英文不一致处以英文原文为准。

犬猫疫苗接种指南 2015 版（上）

1. 文件框架与执行摘要

1.1 版本沿革与目录结构

原文目录（分块 001，页码为 PDF 内 E 编号）：执行摘要（E3）、引言（E4）、循证兽医学（E4）、指南的目的（E5）、小动物疫苗学当前议题（E5）、疫苗类型（E6）、犬疫苗接种指南（E7）、猫疫苗接种指南（E12）、救助所环境免疫（E15）、总体注意事项（E15）、表 1–7（E17）、致谢（E23）、参考文献（E23）、附录 I 犬猫传染病资料卡（E27）、附录 II 常见问题 FAQ（E33）。本稿覆盖至参考文献起始处，附录 I、II 在分块 011 之后（由「03-」稿整理）。

版本沿革（原文照录）：首版 2007 年发表（Day et al. 2007），2010 年更新（Day et al. 2010）；本文档为再次更新扩充版（即 2015 版，官网文件名为 WSAVA-Vaccination-Guidelines-2015.pdf，另挂 2016 年法语版）。VGG 于 2006 年召集成立。2011–2013 年 VGG 聚焦亚洲犬猫传染病与疫苗学，发表了面向亚洲从业者的区域性建议（Day et al. 2014）；2014–2015 年完成本次全球指南更新。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 执行摘要（Executive Summary）核心定义', '1.2 执行摘要（Executive Summary）核心定义

- **核心疫苗（core vaccines）**：VGG 定义为「所有犬猫，无论处境或地理位置，都应接种的疫苗」，保护动物免于在全球分布的、严重的、危及生命的疾病。
  - 犬核心疫苗：预防犬瘟热病毒（canine distemper virus, CDV）、犬腺病毒（canine adenovirus, CAV）及犬细小病毒 2 型（canine parvovirus type 2, CPV-2）各变体的疫苗。
  - 猫核心疫苗：预防猫细小病毒（feline parvovirus, FPV，即猫泛白细胞减少症）、猫杯状病毒（feline calicivirus, FCV）及猫疱疹病毒 1 型（feline herpesvirus-1, FHV-1）的疫苗。
  - **狂犬**：在狂犬病毒流行地区，即使没有法定常规免疫要求，针对该病原的疫苗也应视为犬猫两物种的核心疫苗。
- **母源抗体（maternally derived antibody, MDA）干扰**：MDA 显著干扰幼年犬猫多数现行核心疫苗的效力；由于窝间 MDA 水平差异很大，VGG 建议幼犬幼猫接种**多次核心疫苗剂量**，其中**最后一剂应在 16 周龄或 16 周龄以上**接种，随后在 **6 或 12 月龄**加强一次（原文作「6or 12-months」〔原文如此〕）。在文化或经济条件只允许给一只宠物接种一次疫苗的情形下，这一次应为核心疫苗，且在 16 周龄或更大时接种。
- **血清学监测**：VGG 支持使用简单的诊内检测（in-practice tests）测定核心疫苗组分（CDV、CAV、CPV-2 和 FPV）接种后的血清转化（seroconversion）、成年犬的血清保护状态，以及管理救助所传染病暴发。
- **不应无谓接种**：核心疫苗在幼龄基础免疫后的 6 或 12 月龄加强之后，**不应比每 3 年更频繁地接种**，因为免疫持续时间（duration of immunity, DOI）长达多年、甚至可能终生。
- **非核心疫苗（non-core vaccines）**：仅当动物的地理位置、当地环境或生活方式使其有感染某些特定疾病的风险时才需要的疫苗。
- **不推荐疫苗（not recommended vaccines）**：科学证据不足以支持其使用的疫苗；另有一批地域性受限的少数产品未纳入 VGG 讨论。
- **年度体检**：VGG 强烈支持定期（通常为每年）健康检查的理念，把重点和客户的期望从「每年重新接种」上移开；年度体检仍可包含选定的非核心疫苗接种——非核心疫苗应每年接种，因为其 DOI 一般只有 1 年。
- **救助所最低标准**：所有进入救助所的犬猫应在进入之前或进入之时接种核心疫苗；资金允许时，按指南规定的程序重复接种核心疫苗，并可包含针对呼吸道疾病的非核心疫苗。
- **不良反应报告**： wherever possible，兽医应被积极鼓励向制造商和/或监管部门报告所有可能的不良事件，以扩展推动疫苗安全性改进的知识基础。
- 执行摘要收尾句（原文照录）：**“We should aim to vaccinate every animal with core vaccines. Non-core vaccines should be given no more frequently than is deemed necessary.”**（我们应致力于用核心疫苗免疫每一只动物；非核心疫苗的接种频率不应超过必要。）', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 引言：2015 版相对 2010 版的具体变化', '2. 引言：2015 版相对 2010 版的具体变化

WSAVA 指南的适用范围比下列区域性指南更广：北美美国猫科医师协会（AAFP）指南（Scherk et al. 2013）、美国动物医院协会（AAHA）指南（Welborn et al. 2011）、欧洲猫病咨询委员会（Advisory Board on Cat Diseases, ABCD）指南（Hosie et al. 2013）。2015 版格式与大部分内容与 2010 版相似，具体变化（分块 001，10 条原文照录）：

1. 更明确地展示 WSAVA 建议的循证方法：建立了疫苗学专用的证据新分类方案，并更完整地引用科学文献。
2. 依据母源抗体持续时间的最新数据，修改幼犬幼猫核心免疫时机建议：基础免疫**最后一剂推迟到 16 周龄或 16 周龄以上**。
3. 修改幼犬幼猫 12 月龄加强疫苗建议：**提供缩短至 6 月龄（26 周龄）的选项**。
4. 澄清并进一步讨论成年猫接种 FHV-1 与 FCV 弱毒活疫苗的再免间隔。
5. 纳入新可用疫苗的信息（如犬口服支气管败血博德特氏菌疫苗、含两种毒株的 FCV 疫苗、多血清群钩端螺旋体疫苗）。
6. **将猫免疫缺陷病毒（feline immunodeficiency virus, FIV）疫苗重新归类为非核心疫苗。**
7. 修改救助所环境下幼犬幼猫核心疫苗的接种时机。
8. 扩展讨论针对核心疫苗抗原抗体的诊内血清学检测，及其在救助所传染病暴发管理中的应用。
9. 进一步考虑猫疫苗接种的最佳解剖部位。
10. 更新 VGG 疾病资料卡并扩充常见问题清单。

3. 循证兽医学（EBVM）证据分级

VGG 自设 4 级证据分类（分块 001–002），文中以 [EB1]–[EB4] 标注；每次仅给出可得的最高严格级别：

| 类别 | 定义（原文照录要点） |
|---|---|
| 1 类证据（Category 1） | 建议有同行评审科学刊物发表的实验或田间数据支持；尽管经过同行评审，因评审过程无全球统一标准，此类证据科学质量仍可能参差不齐 |
| 2 类证据（Category 2） | 建议有未发表的、商业敏感的研究支持，这些研究作为获批兽用疫苗注册资料包的一部分提交；本级别假定获批产品说明书上的信息已经过监管机构合格的同行评审 |
| 3 类证据（Category 3） | 建议有商业或独立的实验或田间数据支持，但这些数据未发表于同行评审文献、也未纳入正式注册资料包受监管审查 |
| 4 类证据（Category 4） | 建议无实验或田间数据支持，但由微生物学与免疫学「第一性原理」推定，或有广泛持有的专家意见支持 |', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 指南的目的：与产品说明书的关系', '4. 指南的目的：与产品说明书的关系

- 本指南**不是**全球适用的强制接种规则：WSAVA 有 80 个成员国，各国在传染病有无/流行率、疫苗产品可及性、有主与流浪犬猫群、执业与客户经济、社会观念上差异巨大；国家小动物兽医协会和单个诊所应自行阅读、讨论并改编本指南。指南不具规定性——在某国为非核心的疫苗，在他国可能作核心使用。
- **说明书（datasheet，欧洲称产品特征概要 summary of product characteristics, SPC）与指南的区别**（Thiry & Horzinek 2007 已充分讨论）：说明书是疫苗注册文件的一部分，载明质量、安全、效力及**最短 DOI**；DOI 基于攻毒实验证据，是最小值，不必反映真实 DOI。多数伴侣动物核心疫苗直到不久以前都是最短 1 年 DOI、每年加强；近年许多同类产品获批最短 3 年（有时 4 年）DOI，许多国家多数核心弱毒活疫苗（modified live virus, MLV）已获批成年动物每 3 年再免；但许多国家相同产品仍标注 1 年最短 DOI（厂商未申请修改标签，或国家审批机构未批准）。
- **即使 3 年许可也仅是核心疫苗的最短 DOI**；多数核心疫苗的真实 DOI 可能长得多乃至终生。当指南建议 3 年或更低频率再免、而国内所有产品仍是 1 年许可时，兽医可依指南（即当前科学认知）接种，但须取得并记录**知情同意**，作为偏离厂家推荐的「超说明书使用（off-label use）」。公司技术人员有义务继续坚持说明书推荐，兽医应知悉。
- 不同指南体系之间存在细微差异（当地专家组观点、疾病流行率、宠物生活方式不同），VGG 的定位是在各国/区域指南之间「取中道」。凡 VGG 建议与产品标签不同，执业者须确保取得客户书面知情同意。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 小动物疫苗学当前议题', '5. 小动物疫苗学当前议题

- 发达国家多数主要犬猫传染病对家养宠物已属「至多少见」，但仍有地域性疫点与散发暴发，流浪与救助群体情况截然不同；在许多发展中国家，这些疾病仍是小动物主要死因。即便发达国家估计也只有 **30–50%** 的宠物群体接种了疫苗，发展中国家显著更低；2008 年后的全球经济衰退进一步抑制预防保健支出，调查数据提示近期接种率下降（Anon 2013a）。
- **群体免疫（herd immunity）**：个体接种不仅保护个体，还减少区域群体中的易感动物数量、降低疾病流行率。依赖长效核心疫苗的群体免疫高度取决于**接种的动物百分比**而非每年接种次数。因此应尽量提高核心疫苗覆盖率。对个体动物，反复接种并不能诱导「更好」的免疫：每 3 年接种一次核心 MLV 的犬与每年接种的犬保护同等良好（Bohm et al. 2004, Mouzin et al. 2004, Mitchell et al. 2012）[EB1]；但猫核心疫苗未必如此（见第 8 节）。
- **One Health（同一健康/一体化健康）**：多数人兽新发传染病源于野生或家养动物，需人医、动物、环境健康专业协作管理（Gibbs 2014）。WSAVA 2010 年成立 One Health 委员会（Day 2010），其与 VGG 的工作在犬狂犬病与利什曼病两大人畜共患病上交叉。
- **减少「疫苗负担（vaccine load）」**：为减少不良反应潜能、减轻客户与兽医的时间与经济负担，提出核心/非核心分类与延长 DOI 的产品；这两点要求兽医从业者思维转变，现已被许多国家接受。
- 若某只宠物一生只能接种一次核心疫苗，VGG 强调最好给在其**免疫应答能力最佳的时间**，即**大于 16 周龄**时。
- 救助所：**最低免疫方案为入所时或入所之前单次接种核心疫苗**。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 疫苗类型', '6. 疫苗类型

| 类别 | 英文原名 | 定义与特性（原文照录要点） |
|---|---|---|
| 感染性疫苗 | infectious vaccines（MLV/attenuated） | 多数犬猫用感染性疫苗含减弱毒力的完整活性病原（弱毒活疫苗 MLV 或减毒疫苗），经诱导低水平感染并在体内复制产生免疫，不产生明显组织病理或临床症状。肠外给药时能更有效诱导相关解剖部位的免疫，更可能诱导强细胞介导免疫与体液（抗体介导）免疫；部分感染性疫苗直接黏膜给药（鼻内或口服），诱导黏膜保护免疫更有效。部分重组载体疫苗（携带靶病原抗原基因的活载体）亦属「感染性」，但载体对犬猫无关或不致病。**给无 MDA 的动物接种，一般单剂即产生保护** |
| 非感染性疫苗 | non-infectious vaccines（killed/inactivated、亚单位、裸 DNA） | 含灭活但抗原完整的病毒/病原，或源自它的天然/合成抗原，或可编码该抗原的 DNA；不能感染、复制或致病。一般需要**佐剂**增强效价，且通常需要**多剂**（即使成年动物）才能诱导保护；肠外给药；诱发细胞与体液免疫的可能性较低，DOI 一般短于感染性疫苗 |

7. 犬疫苗接种指南

7.1 基本免疫程序与三级分类

- 面向一般诊所的核心（推荐）、非核心（可选）与不推荐疫苗建议见表 1（本稿第 11 节）。
- **犬核心疫苗**：全世界所有犬必须按推荐间隔接种、以获得对全球性重要传染病终身保护的疫苗：CDV、CAV（1 型和 2 型）、CPV-2 及其变体。某些国家会自行增列核心疫苗，典型例子是**狂犬**：在狂犬流行地区应为保护宠物与人群常规免疫所有犬。VGG 强烈支持 WSAVA One Health 委员会与世界动物卫生组织（OIE）的联合声明——**2030 年全球消除犬源狂犬病**（Anon 2013b）。许多国家狂犬免疫为法定要求，国际宠物旅行也普遍要求。
- **非核心疫苗**：按个体的地理与生活方式暴露风险及**风险–效益比**决定使用（不接种而易感的风险、或接种而发生不良反应的风险，对比获得针对该感染保护的好处）。
- **不推荐疫苗**：几乎没有科学依据（证据基础不足）支持使用的疫苗。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 幼犬基础免疫与 6 或 12 月龄加强', '7.2 幼犬基础免疫与 6 或 12 月龄加强

- 多数幼犬出生头几周受 MDA 保护；多数幼犬被动免疫在 **8–12 周龄**消退到允许主动免疫的水平。MDA 低的幼犬更早即易感（也更早能对疫苗应答），有的幼犬 MDA 效价过高，**≥12 周龄仍不能应答**（Friedrich & Truyen 2000）[EB1]，故没有单一首免策略能覆盖所有情形。
- **VGG 建议：首剂核心疫苗 6–8 周龄接种，之后每 2–4 周一次，直到 16 周龄或 16 周龄以上**。基础剂次由起始年龄与所选间隔决定（可能程序见表 5）：6 或 7 周龄起、4 周间隔 → 4 剂基础核心苗；8 或 9 周龄起、同样 4 周间隔 → 3 剂。
- 许多说明书仍建议「两剂」核心基础程序，部分产品获批「10 周结束（10 week finish）」程序（第二剂在 10 周龄），目的是让幼犬「早期社会化」同时降低传染病风险。VGG 认可早期社会化对犬行为发育至关重要（Korbelik et al. 2011, AVSAB 2008）[EB1]；采用此类「幼犬课堂」程序时应保持警惕——只在受控场所、仅接触看似健康且完成免疫的犬只与成人；课堂最好设在诊所之外；若必须用诊所场地，每节课前清洁消毒地面，并选未知免疫/健康状态犬只不常经过的区域。美国近研究显示，参加社会化课堂的已免疫幼犬 CPV-2 风险极低（Stepita et al. 2013）。** Whenever possible，幼犬基础核心系列最后一剂应在 16 周龄或 16 周龄以上 [EB1]**。
- **「加强」苗**：传统在 12 月龄或最后一剂基础苗后 12 个月给予，主要目的是确保对基础系列中任一无应答的犬发展出保护性免疫应答，而不一定是「加强」免疫。选 12 月龄历史上是为顺便邀约首次年度体检；这意味幼犬若在基础期无应答，到 12 月龄苗之前一直处于无保护状态——这可解释部分<12 月龄已免疫幼犬发生传染病（如犬细小病毒肠炎）。**VGG 重新评估后建议：可将此剂从 52 周龄提前至 26 周龄**（26–52 周龄之间任意时点均可，26 周龄时间上方便）；此举要求宠主清楚理解原因，且按表 5，6/7 周龄起苗的程序在出生头 6 个月内可能多达 **5 次接种到访**。核心疫苗在 26 周龄加强后，**至少 3 年内**无需再接种。该新建议与 12 或 16 月龄「首次年度体检」不冲突——许多兽医希望在动物骨骼成熟前后检查。', 'dog', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 成年犬再免疫', '7.3 成年犬再免疫

- 对核心 MLV 疫苗有应答的犬，即使不再重复接种，也保持多年牢固免疫记忆（Bohm et al. 2004, Mouzin et al. 2004, Schultz 2006, Mitchell et al. 2012）[EB1]。**26 或 52 周龄加强之后，再免间隔 3 年或更长。**
- 强调：**3 年成年再免一般不适用于灭活核心疫苗（狂犬除外）、不适用于非核心疫苗，尤其不适用于含细菌抗原的疫苗**——钩端螺旋体（Leptospira）、博德特氏菌（Bordetella）、疏螺旋体（Borrelia，莱姆病）产品，以及副流感病毒组分，为获得可靠保护需更频繁加强（Ellis & Krakowka 2012, Klaasen et al. 2014, Ellis 2015, Schuller et al. 2015）[EB1]。
- 因此依本指南，成年犬仍可每年接种，但每年组分可不同：典型做法是核心疫苗每 3 年、选定的非核心产品每年。VGG 知悉一些国家只有核心+非核心多联产品，鼓励厂商供应全系列的减少组分疫苗（或至少核心与非核心分开，Mitchell et al. 2012）。
- 幼龄完成全套核心免疫（含 26 或 52 周龄加强）但成年后未定期接种的犬：仅需 **1 剂 MLV 核心疫苗**即可加强免疫（Mouzin et al. 2004, Mitchell et al. 2012）[EB1]。免疫史不明的领养成年犬（或>16 周龄幼犬）同样仅需 1 剂 MLV 核心疫苗即产生保护性应答；许多说明书此时建议两剂（如幼犬程序），**此做法无正当理由、违背基本免疫学原理**[EB4]。注意：对非核心疫苗不适用，其中许多在成年犬需两剂。

7.4 犬狂犬病疫苗特别问题（分块 003–004）

- 在狂犬流行国家，即使法律未要求，兽医也应强烈建议客户为犬接种。
- 狂犬再免间隔常由法律规定：国际可用灭活狂犬疫苗最初获批 1 年 DOI，法规因而要求每年再免；同产品在许多国家现已获批 3 年 DOI、法律随之修改。但有些国家法律与疫苗许可不一致；有些国家两者都未改；还有些国家本地生产的狂犬疫苗只有 1 年 DOI，**很可能不能安全延长到 3 年**。兽医应了解法律；若可及至少 3 年免疫的产品，国家协会可游说按当前科学证据修法。', 'dog', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 血清学检测监测犬疫苗免疫（分块 004）', '7.5 血清学检测监测犬疫苗免疫（分块 004）

- 2010 版发布以来，可检出犬个体 CDV、CAV、CPV-2 保护性抗体的**快速简便诊内试剂盒**可用性提高，与传统实验室方法（病毒中和试验、血凝抑制试验，仍是「金标准」）互补。已有两种商业化试剂盒在诊所与救助所应用并验证（Gray et al. 2012, Litster et al. 2012）[EB1]，受到希望为客户提供「3 年常规核心再免替代方案」的兽医欢迎；但试剂盒仍相对昂贵——**目前检测比一剂疫苗更贵**。
- **阴性**：犬几乎没有或无抗体，建议再免。部分血清阴性犬实际有免疫（假阴性），再免不必要，因会对疫苗产生快速强烈的回忆应答（anamnestic response）（Mouzin et al. 2004）；但此类犬无法轻易检出，故任何检测的阴性结果都应视为无抗体、潜在易感。**阳性**：结论为无需再免。
- 狂犬抗体监测一般不用于决定再免（再免由法律定）。国际宠物旅行要求认可参考实验室检测保护性狂犬抗体效价（原文作「more than 0·5 IU/ml」，即大于 0.5 IU/ml）。
- CDV、CAV、CPV-2 血清学适用场景：判定幼犬保护、决定成年犬再免间隔、救助所暴发管理。
- 尽责的宠主可在基础系列于 16 周龄或更大完成后，确认幼犬已获保护：**最后一剂至少 4 周后**采血检测——该间隔可确保 MDA 已不存在、且「慢应答」幼犬也已完成血清转化。血清阳性幼犬无需 26 或 52 周龄加强，下次核心疫苗可 3 年后。**图 1 流程**（抽取稿中图内文字被打散混入正文，「原文此处缺失」原图结构；按抽取文字重建）：

```
幼犬基础核心免疫于 16 周龄或 16 周龄以上完成
→ 末剂至少 4 周后测定 CDV、CAV、CPV-2 血清阳性
  ├─ 阳性 → 加强免疫间隔不长于每 3 年（无需 26/52 周龄加强）
  └─ 阴性 → 重复接种一次（可用不同产品）→ 再次血清学
              ├─ 阳性 → 同阳性路径
              └─ 阴性 → 该幼犬可能为血清学无应答者（non-responder），
                        可能保有细胞免疫（CMI）或先天免疫提供部分保护，
                        但很可能未受保护
```

- 疫苗不能在幼犬诱导保护的原因：
  1. **MDA 中和疫苗病毒**——最常见原因；末剂在 16 周龄或更大给予时 MDA 应已降至低水平（Friedrich & Truyen 2000）[EB1]，多数幼犬主动免疫会成功。
  2. **疫苗免疫原性差**——可涉及从设计、生产到给药各环节（毒株、传代史、批生产差错）；大型国际厂商因政府监管要求批效价放行，此类情况现实罕见。生产后因素——储存/运输错误（冷链中断）、诊所内处置（消毒剂使用）——可使 MLV 失活；VGG 认可「疫苗保管（vaccine husbandry）」在许多国家仍是问题，要点列入表 6。
  3. **动物为低/无应答者（遗传）**——反复再免后仍不产生抗体应答者应视为遗传性无应答者。1980 年代罗威纳与杜宾犬对 CPV-2 高易感（无论免疫史）被认为（但未证实）部分与无应答者比例高有关（Houston et al. 1994）[EB4]；如今美国这两个品种 CPV-2 无应答者似并不比其他品种多，可能是携带者已死于 CPV-2 感染。英国和德国的罗威纳中 CPV-2 无应答表型仍多见[EB3]，且新近研究显示该品种未能达到宠物旅行所需狂犬抗体效价的比例更高（Kennedy et al. 2007）[EB1]。犬群遗传性无应答者粗略估计：**CDV 约 1/5,000，CAV 约 1/100,000，CPV-2 约 1/1,000**[EB4]。', 'dog', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 血清学测定核心疫苗 DOI', '7.6 血清学测定核心疫苗 DOI

- 大量犬对 CDV、CPV-2、CAV-1、CAV-2 维持多年保护性抗体，众多实验研究支持（Bohm et al. 2004, Mouzin et al. 2004, Schultz 2006, Mitchell et al. 2012）[EB1]。**抗体缺失时（无论用何种检测）应予再免**（除非有医学理由不宜），尽管部分仍受免疫记忆保护。
- 对其他疫苗组分的抗体测定价值有限或无价值：抗体存续期短（如钩端螺旋体产品）或血清抗体与保护不相关（如钩端螺旋体、犬副流感）（Hartman et al. 1984, Klaasen et al. 2003, Ellis & Krakowka 2012, Martin et al. 2014）[EB1]。
- 目前此类检测相对昂贵；但循证原则提示，检测抗体状态（幼犬或成年犬）应优于单纯基于「安全且便宜」给加强苗。', 'dog', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 被动免疫（分块 004–005）', '7.7 被动免疫（分块 004–005）

- 病毒感染激发细胞与体液免疫，但降低病毒载量与康复主要由抗体应答贡献；许多病毒感染中抗体水平被作为保护相关指标。病毒血症期，预先存在或注入的针对病毒粒子表面结构的抗体与粒子结合、中和其感染性并便于清除。治疗上多数血清/免疫球蛋白制剂因来自不同物种而**皮下注射**，很快进入循环；同种来源的血浆/血清静脉输注同样有效。局部感染（如患狂犬病食肉动物咬伤）的暴露后抗体预防在人医中被证明极为宝贵：人狂犬免疫球蛋白在暴露后预防方案第 1 天给予即快速保护，尽量多渗入伤口及其周围，并可在远离同时接种狂犬疫苗的肌注部位给予。
- 伴侣动物预防性主动免疫已极普及，血清预防/治疗只在特殊情况下考虑（如就诊时已患犬瘟的犬、猫泛白细胞减少症，或犬舍/猫舍暴发）。血清/免疫球蛋白产品仍有市场，生产厂家存在于美国、德国、捷克、斯洛伐克、俄罗斯、巴西；制剂为同源或异源（如马源）、多价（针对多种病毒）、由血清或其免疫球蛋白组分构成。
- **VGG 建议审慎、经仔细考虑后才使用**。犬舍 CDV 暴发时，**用 CDV 疫苗免疫所有犬比给免疫血清更安全有效**（Larson & Schultz 2006）[EB1，见表 7]。既往曾建议 MLV 疫苗静脉给予（超说明书）而非皮下或肌注，但少有证据表明此举比皮下/肌注提供更有效或更快速的保护；任一途径给予 CDV 疫苗都会在接种时或接种后很短时间内保护动物免于重症与死亡——此时疫苗不预防感染，而防重症（尤其神经症状），动物存活后终生免疫。
- 猫舍 FPV 暴发或犬舍 CPV-2 暴发时：一项研究显示**出现临床症状后再给免疫血浆，对降低发病率或死亡率无益**（Bragg et al. 2012）[EB1]。但该工作受批评，因每只幼犬仅给小体积（12 ml）免疫血浆；研究人员与从业者常规使用大得多的体积（**6·6–11 ml/kg**〔原文如此，即 6.6–11 ml/kg〕），一些有经验的临床医师和研究者认为大剂量有效（Dodds 2012）[EB4]。要达到最大获益，免疫血清/血浆必须**在感染后、临床症状出现前**给予（最好在感染后 **24–48 小时**内），且需要大量高效价血清/血浆；须**肠外**给予（皮下、静脉或腹腔），**口服无益**——即使感染前开始也无好处。救助所还需权衡这些商业产品的相对成本。有时救助所用替代做法：采集所内康复或近期免疫动物的血清/血浆，但**有风险**——血清未必筛查过可传播病原（如血液原虫或猫逆转录病毒）。血清学检测是救助所控制暴发更有效的手段（见表 7）。', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 犬用新疫苗进展（分块 005）', '7.8 犬用新疫苗进展（分块 005）

- **口服支气管败血博德特氏菌（Bordetella bronchiseptica）疫苗**（Hess et al. 2011, Ellis 2015）与**含多种地域相关血清群的多价钩端螺旋体疫苗**在全球范围增多（Klaasen et al. 2012, 2014, Wilson et al. 2013, Schuller et al. 2015），详见表 1。
- **犬流感病毒（canine influenza virus, CIV）疫苗**：仅在美国获批（Deshpande et al. 2009, Larson et al. 2011）。甲型流感 H3N8 亚型早被确认为北美群养犬呼吸道疾病原因（Crawford et al. 2005, Payungporn et al. 2008, Castleman et al. 2010），其他地区至今仅零星暴发报告（Crawford et al. 2005, Daly et al. 2008, Kirkland et al. 2010, Pratelli & Colao 2014, Schulz et al. 2014）。CIV 疫苗为灭活苗：**6 周龄起首剂，2–4 周后第二剂，之后每年再免；第二剂后约 7 天产生免疫力**。视为非核心疫苗，仅推荐给北美因生活方式可能暴露的高风险犬（Anderson et al. 2013）[EB1]。撰写本文时，美国芝加哥与威斯康星地区报告了归因于 **H3N2** 亚型的犬流感局部暴发，针对该亚型的疫苗已获**限制性许可（conditionally licensed）**发布。
- **犬恶性黑色素瘤免疫治疗疫苗**：首个此类产品 2010 年获批；为把**人酪氨酸酶基因**装入质粒的「裸 DNA」疫苗，用高压经皮注射装置反复给药；用于犬口腔黑色素瘤的辅助治疗，诱导针对该黑色素瘤靶抗原的免疫应答。初期研究显示 II–IV 级黑色素瘤犬中位生存期增至 **389 天**（预期 90 天）（Bergman et al. 2006），但更近期研究显示效果较小（Grosenbaugh et al. 2011, Ottnod et al. 2013）[EB1]。欧洲亦有售，与北美一样仅限认可的兽医肿瘤专家使用。
- **犬利什曼病（leishmaniosis）疫苗**：巴西此前有两种获批（利什曼病在巴西对犬与人都是重大疾患）。第一种为含**多西利什曼原虫（Leishmania donovani）GP63（即岩藻甘露糖配基 fucose mannose ligand, FML）**的亚单位苗、皂素佐剂；被认为诱导阻断病原从犬向白蛉传播的抗体（阻止利什曼原虫结合白蛉中肠），已广泛进行免疫学与流行病学田间评价（Palatnik de Sousa et al. 2009; Palatnik de Sousa & Day 2011）[EB1]；**该产品最近已从巴西市场撤出**。第二种巴西苗含 L. donovani 的 **A2 抗原**、皂素佐剂；在同一流行区 11 个月自然暴露田间试验中与 FML 苗比较，报道有相似保护效果（血清转化、防感染与临床症状、防向媒介传播）；A2 苗犬体液免疫应答较低但接种后不良事件频率更高（Fernandes et al. 2014）。**欧洲疫苗**2011 年引入（Bongiorno et al. 2013; Moreno et al. 2013）：含**婴儿利什曼原虫（L. infantum）排泄–分泌抗原**加佐剂；用于 **6 月龄起血清阴性犬，3 剂基础、每 3 周一次，之后每年加强**；免疫犬会血清转化，说明书配有鉴别性血清学检测方法；有细胞介导免疫应答的证据提示；疫苗声称降低感染可能性并减轻已感染犬临床症状严重程度，但**不作影响人间疾病流行率的公共卫生声明**[EB2]。', 'dog', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 猫疫苗接种指南', '8. 猫疫苗接种指南', 'cat', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 基本免疫程序与核心疫苗特点', '8.1 基本免疫程序与核心疫苗特点

- 面向就诊猫的核心/非核心/不推荐疫苗建议见表 3。猫核心疫苗：**猫泛白细胞减少症（FPV）、FHV-1 和 FCV**。狂犬疫苗在部分国家/地区可视为核心：狂犬流行地区 VGG 建议所有猫常规免疫以保护宠物与人群；部分国家强制狂犬免疫为法定要求（但不总包括猫），国际宠物旅行亦要求。
- **猫核心呼吸道疫苗的保护不及 FPV 疫苗**：不应期望 FHV-1/FCV 疫苗提供犬核心疫苗那样强健的保护和 DOI。FCV 疫苗被设计为诱导对 FCV 多毒株的交叉保护，但已免疫成年动物仍可能发生感染和疾病（Pedersen et al. 2000, Schorr-Evans et al. 2003）[EB1]。**没有任何 FHV-1 疫苗能预防强毒感染**；感染可致强毒病毒潜伏（latent），在严重应激期再激活（Richter et al. 2009, Maes 2012）[EB1]；再激活病毒可在已免疫动物引起临床症状，或排出感染易感动物致病。
- VGG 建议**低风险猫对 FHV-1 与 FCV 每 3 年再免**，依据是一项已发表研究：这两种核心疫苗最短有部分但临床显著的免疫持续 **7.5 年**（Scott & Geissinger 1999）；更近期对某 MLV FHV-1/FCV 疫苗的研究显示接种 3 年后对 FHV-1 的部分保护弱得多，而 FCV 部分保护与 Scott & Geissinger 1999 所见相当（原文作「in1999」〔原文如此〕）（Jas et al. 2015）[EB1]。**较高风险情形建议每年再免 FHV-1/FCV。**
  - **低风险猫**定义：单独、室内、不进寄养猫舍的动物；**较高风险猫**：定期进寄养猫舍，或生活在多猫、室内外通行的家庭。
  - 此类疫苗最稳健的免疫在**接种后 3 个月内**（Gaskell et al. 2007）[EB1]，因此鼓励为定期寄养的高风险猫把 FHV-1/FCV 接种时间安排在每年去猫舍之前。
- **猫白血病病毒（feline leukaemia virus, FeLV）疫苗**：VGG 将其列为**非核心**（表 3），但完全理解其使用必须取决于个体猫的生活方式、感知暴露风险和当地感染流行率。许多猫科专家认为：尽管由于成功控制项目，世界许多地区 FeLV 感染流行率已显著下降（Weijer and Daams 1976, Weijer et al. 1986, 1989, Meichner et al. 2012）[EB1]，但在 FeLV 仍流行的地区，**任何 <1 岁、有任何户外生活成分的猫（哪怕与外出的猫同居）都应接种：2 剂、间隔 2–4 周，起始不早于 8 周龄**。FeLV 的「风险–效益」分析应构成猫免疫面谈的常规部分；**只有 FeLV 阴性猫才可接种**。
- **猫免疫缺陷病毒（FIV）疫苗重新分类**：在前两版中被列为「不推荐」，依据是（1）疫苗所含病毒亚型与不同地理地区野外亚型及重组株交叉保护存疑（Hosie et al. 1995, Dunham et al. 2006, Yamamoto et al. 2007, Coleman et al. 2014, Beczkowski et al. 2015a）[EB1]；（2）疫苗干扰用于 FIV 感染诊断的抗体检测（Hosie & Beatty 2007）[EB1]；（3）这是佐剂苗，需对易发注射部位肉瘤的物种反复接种（3 剂基础+每年再免）。VGG 知悉世界部分地区 FIV 血清阳性率和/或感染流行率仍显著（大量文献，Bennett et al. 1989 至 Rypula et al. 2014 等）[EB1]；现已有鉴别性血清学检测（Kusuhara et al. 2007, Levy et al. 2008, Westman et al. 2015）与更强健的 PCR 检测（Arjona et al. 2007, Wang et al. 2010, Morton et al. 2012）[EB1]。许多国家猫主人不太可能被说服让猫留在室内避开 FIV 主要传播风险（受感染猫咬伤）；FIV 感染猫的疾病进展受饲养条件与户内猫数影响（Beczkowski et al. 2015b）。鉴于该疫苗一些研究显示有效、另一些显示无效，且可能使某些有风险猫群获益，**VGG 将其重分类为非核心疫苗**。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 幼猫基础免疫与 6 或 12 月龄加强', '8.2 幼猫基础免疫与 6 或 12 月龄加强

- 与幼犬同理，多数幼猫出生头几周受 MDA 保护；未做血清检测时，无法知道保护水平及幼猫何时易感并能应答疫苗。一般 MDA 在 **8–12 周龄**消退到允许主动免疫；MDA 低的幼猫更早易感（也能更早应答），有的 MDA 效价高到 **12 周龄之后一段时间仍不能应答**。
- VGG 审阅近 studies：多达**三分之一**的幼猫对 16 周龄末剂核心疫苗可能无应答，部分幼猫 **20 周龄仍有阻断性 MDA**（DiGangi et al. 2012, Jakel et al. 2012）。VGG 指出其中一项研究样本相对少、以一个品种为主、在猫舍环境进行，数据未必适用于更大猫群。**尽管如此，VGG 将基础核心系列末剂的推荐年龄从 14–16 周龄提高到 16 周龄或 16 周龄以上**[EB1]。
- **幼猫核心免疫程序与幼犬一致：6–8 周龄起，每 2–4 周一次，直到 16 周龄或 16 周龄以上**；6 或 7 周龄起 → 4 剂，8 或 9 周龄起 → 3 剂（表 5）。
- 12 月龄（或末剂后 12 个月）「加强」苗的目的、历史缘由、与 26 周龄选项的论述与幼犬一节相同（VGG 建议可提前到 26 周龄、26–52 周龄之间均可；6/7 周龄起苗者头 6 个月可能多达 5 次到访）；**核心疫苗 26 周龄加强后（低风险猫）至少 3 年内无需再接种**；采纳 26 周龄做法不排斥 12 或 16 月龄首次年度体检。', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 成年猫再免', '8.3 成年猫再免

- 对核心 MLV 疫苗有应答的猫，即使不再接种，**对 FPV 保持多年牢固免疫**；但对 FCV 与 FHV-1 的免疫仅为部分（Scott and Geissinger 1999, Jas et al. 2015）。
- **低风险成年猫：MLV 核心疫苗每 3 年或更长间隔再免**。**较高风险猫**（定义见上）：FPV 疫苗不长于每 3 年，但 FCV 与 FHV-1 **每年**接种，并将这两苗安排在定期寄养年度到访前不久[EB1]。
- 上述同样不适用于灭活核心疫苗（狂犬除外）与非核心疫苗，尤其含细菌抗原疫苗：**衣原体（Chlamydia，旧称 Chlamydophila；Sachse et al. 2015）与博德特氏菌**产品若判断需用，为获得其提供的有限保护需每年加强[EB2]。
- 成年猫仍可每年接种，组分逐年可不同：典型为核心（尤其 FPV）每 3 年、呼吸道病毒苗按风险、选定非核心产品每年。VGG 知悉部分国家只有核心+非核心多联苗，鼓励厂商尽可能提供全系列产品，或至少为核心-only 组合。
- 幼龄完成 FPV、FHV-1、FCV 全套（含 6 或 12 月龄加强）但成年后未定期接种的成猫：仅需 **1 剂 MLV 核心疫苗**加强[EB4]。免疫史不明的领养成猫（或>16 周龄幼猫）：**FPV 仅需 1 剂 MLV** 即产生针对该病毒的保护应答；**但 FHV-1/FCV 应给 2 剂 MLV（间隔 2–4 周）**以建立足够免疫应答[EB2]。', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 猫的接种部位与猫注射部位肉瘤（feline injection site sar', '8.4 猫的接种部位与猫注射部位肉瘤（feline injection site sarcoma, FISS）

- 疫苗（任何类型）是与 **FISS** 发病相关的一类注射产品，含佐剂的 FeLV 与狂犬苗尤其受关注（Kass et al. 1993）。FISS 病理机制未证实，当前认为局部慢性炎症反应启动间充质细胞恶性转化，且此过程有某种遗传基础。多数皮下注射（含疫苗）传统打在猫**肩胛间（interscapular）区**，该区仍是 FISS 常见形成部位。肿瘤浸润性质使根治性手术切除常常必要（辅以其他治疗手段）（Martano et al. 2011, Ladlow 2013）。
- **北美方案**：将两种被认为高风险的佐剂苗打在更易手术切除的独立解剖部位——「**左腿白血病，右腿狂犬**（left leg leukaemia, right leg rabies）」：FeLV 苗打左后腿尽可能远端，狂犬苗打右后腿尽可能远端。此建议保留于现行 AAFP 指南（Scherk et al. 2013），其中还规定三种猫核心疫苗打**前肢远端**。
- 一项研究比较该建议提出前（1990–1996）与采纳后（1997–2006）FISS 解剖分布（Shaw et al. 2009）：肩胛间 FISS 流行率显著下降，右（而非左）前肢肿瘤比例增加；更值得注意的是，右后腿与右侧腹壁合并区（**12.5% → 25.0%**）、左后腿与左侧腹壁合并区（**11.4% → 13.8%**）报告肿瘤数增加——归因于远端后肢注射困难而意外打到了腹部（原文作「the difficultly」〔原文如此〕）。此做法在北美之外未被广泛采用。
- 最近一项研究显示**猫尾注射** FPV 与狂犬疫苗有效（Hendricks et al. 2014）：社区捕捉–绝育–放归项目的成年猫，三联 MLV 核心苗（FPV、FHV-1、FCV）注入**尾背侧远端 1/3**，灭活狂犬苗注入三联轴苗注射点远端 2 cm；FPV 全部血清转化，狂犬除一只外全部血清转化；该小型研究中尾注射耐受良好。2010 版 WSAVA 指南曾提出把疫苗注入**胸侧壁皮肤或更好的腹侧壁**（Day et al. 2010）。尾注射可能比远端肢或侧体壁注射更安全，但需更多研究。此领域仍混乱且具争议，从业者须自行决定其执业环境的可行方案，但以下原则应坚持（分块 006 项目符号原文照录）：
  - 疫苗提供的保护性免疫获益**重于**任何 FISS 风险；FISS 目前估计流行率为**每 5,000 至 12,500 只接种猫中 1 例**（Gobar and Kass 2002, Dean et al. 2013）。
  - 只要可能，**给猫使用非佐剂疫苗**。
  - **疫苗（尤其佐剂产品）及其他注射剂不应注入肩胛间区**。
  - **疫苗（尤其佐剂产品）应注入其他皮下部位（而非肌内）**；部位选择须权衡「万一发生 FISS 的手术切除便利」与「对注射者的可接受安全性」（避免保定困难时意外自伤注射）。
  - **每次接种更换部位（轮换）**，并用示意图把每次所用产品与部位记录在病历或免疫卡上；或者诊所制定团体政策：同一自然年度所有猫免疫固定一个部位，下一年度轮换。
  - VGG 鼓励所有疑似 FISS 病例通过相应的疑似不良反应国家报告途径报告，或报疫苗制造商。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 猫血清学检测（分块 007）', '8.5 猫血清学检测（分块 007）

- 2010 版以来，出现一种检测血清 FPV、FCV、FHV-1 抗体的商业化诊内快速检测，已验证并用于多项已发表研究（DiGangi et al. 2011, Mende et al. 2014）[EB1]。因 FPV 保护性抗体存在与抗感染力相关性极好，该试剂盒可用于判定 FPV 保护（Lappin et al.〔抽取稿此处断行，原文如此〕…）[EB1]：与血凝抑制试验比较，**FPV 试剂盒特异性 89%、敏感性 79%**（Mende et al. 2014），或**特异性 99%、敏感性 49%**（DiGangi et al. 2011）。
- 阴性：该猫几乎无抗体，建议再免；但部分血清阴性猫实为免疫（假阴性），再免不必要。阳性：无需再免。
- 循环血清抗体与 FCV、FHV-1 保护的相关性不如「充分的局部黏膜免疫（FCV）与细胞介导免疫（FHV-1）」，因此 FCV 或 FHV-1 抗体**阴性并不必然表示无保护**（Lappin et al. 2002）[EB1]。
- 应用场景与犬一致：判定 FPV 免疫后幼猫保护、判定成年猫 FPV 保护（为再免决策）、救助所 FPV 暴发控制。
- **强调：FIV 抗体检测用于诊断疾病，对判定 FIV 免疫力无价值**；若已用 FIV 疫苗又疑似 FIV 感染，诊断应用鉴别性血清学检测或（VGG 更推荐的）验证过的 PCR 检测。', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 救助所环境的犬猫免疫', '9. 救助所环境的犬猫免疫

- 救助所是收容等待领养、救援或原主领回动物的设施：来源随机、免疫史多数不明、群体周转率高、传染病风险高。「救助所」涵盖从拥有稳定群体的保护区、到日收数百动物的设施、再到照顾多个个体或整窝幼崽的救助/寄养家庭。**没有放之四海皆准的救助免疫策略**：暴露可能性与感染的潜在毁灭性后果要求有清晰定义的救助所免疫程序。救助医疗与个体诊疗不同——在这种环境中无法根除传染病，只能在高密度高风险群体中尽量减少传播、维持未感染个体健康。犬猫救助所用疫苗建议见表 2 与表 4。
- **本版统一的救助所幼龄动物建议**：核心疫苗**最早可 4–6 周龄开始**，（资金允许时）**每 2 周重复**直到 **20 周龄**（若动物届时仍在所内）[EB4]。
- 近期美国研究显示进入救助所的猫可能已对疫苗可预防病原血清阳性：**DiGangi et al. (2012)：FPV 60.2%、FHV-1 89%、FCV 63.4%；Fischer et al. (2007)：FPV 33%、FHV-1 21%、FCV 64%、狂犬病毒 3%**。犬：一家美国救助所 CDV 血清阳性（41.2%）低于 CPV（84.3%）（Litster et al. 2012）；另一项（Lechner et al. 2010）：35.5% 对 CDV 与 CPV 双阳性、7.7% 仅 CDV、31.5% 仅 CPV、25.3% 两者皆阴。
- 成年动物入所有明确免疫文件记录时，**犬核心疫苗无需再免**；但**猫核心疫苗、尤其 FCV 与 FHV-1，加强免疫可能有益**。
- **VGG 区分「救助所」与「寄养犬舍/猫舍」**：后者是完成免疫的动物短期寄养（如主人度假）的场所。进入任何此类设施应要求该犬猫**已按本指南完成核心产品免疫**；犬在这种情况下使用呼吸道非核心疫苗也是适当的。一些国家寄养免疫规程由地方当局制定、可能与本指南相悖（如坚持每年再免）；VGG 鼓励当局依当前科学认知与产品可及性重新考虑，并鼓励行业与国家协会游说修改。
- 2010 版以来，快速诊内血清学试剂盒的可用性**对救助所 CDV、CPV 或 FPV 暴发管理产生了重大影响**[EB3]；使用方法见表 7。

10. 总体注意事项（分块 007–010）', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 超越疫苗的全面个体化照护', '10.1 超越疫苗的全面个体化照护

- 过去兽医院从每年接种获益：年度接种邀约让兽医更早发现治疗疾病、向客户传递保健知识。不幸的是许多客户相信「疫苗是年度就诊最重要的原因」；兽医担心降低接种频率会使客户放弃年度就诊、医疗质量下降。因此必须强调全面个体化保健方案的各要素：详细病史采集、当着客户面做的完整体格检查、个体化照护；评估每只宠物时应涉及牙齿保健、适当营养、合适的诊断测试、寄生虫与人畜共患病控制；讨论行为问题，以及幼年、老年和有明确疾病易感品种需要更频繁的定制检查。**疫苗接种只是年度体检的一部分。**
- 定期（通常每年）体检中，临床医师应评估**该年度**核心与非核心疫苗的需要；向客户解释疫苗类型、潜在获益与风险、以及针对该动物生活方式和暴露风险的适用性。虽然动物不必每年打核心疫苗，但多数非核心疫苗需每年接种——宠主仍会每年看到动物被打针。还应讨论地区发病率与各种传染病的风险因素，及降低获得性疾病影响的方法（避免拥挤、改善营养、限制接触感染动物）。疫苗只应被看作**依据年龄、品种、健康状态、环境（有害因子暴露可能）、生活方式（与其他动物接触）和旅行习惯个体化制定的综合预防保健计划**的一个组成部分。
- **年龄**：幼犬/幼猫项目传统聚焦疫苗、驱虫与绝育，现今有机会纳入行为咨询与人畜共患病管理；老龄照护项目日益流行；营养、牙齿疾病与寄生虫控制的评估咨询应贯穿宠物一生。**没有证据**表明幼年完成全套免疫的老龄犬猫需要特殊核心免疫方案（Day 2010, Horzinek 2010, Schultz et al. 2010）。实验证据显示老龄犬猫对核心疫苗有持续的免疫记忆（血清抗体可检出），单剂疫苗即可轻易加强（Day 2010）[EB1]。成年动物多数核心产品（CDV、CAV、CPV 与 FPV）的再免决策可由血清学检测作出；提供此替代方案的从业者报告，担心接种频率的宠主非常欢迎，且此服务可成为「practice builder」（官方中译作「免疫保障」，与英文语义有出入，以英文为准）。相反，老龄动物对新抗原发起初次免疫应答可能效率不高（Day 2010）[EB1]；英国为宠物旅行首次接种狂犬苗的犬猫研究显示，老龄动物未达法定抗体效价的更多（Kennedy et al. 2007）[EB1]。
- **环境与旅行**：通过估计犬猫在无监管情况下与其他动物接触的程度，可评估非核心疫苗需要；去犬舍、美容店、公共区域、多林有蜱区域的犬风险更高。宠物人群日益流动，可暴露于其原居住地没有的病原、寄生虫与环境危害；每次就诊询问既往与预期旅行可让预防与诊断计划更个体化。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('犬猫疫苗接种指南 2015 版 · 病历记录与不良反应（分块 007–010）', '10.2 病历记录与不良反应（分块 007–010）

- 接种时应记录在动物**终生病历**中的信息（原文 4 条）：接种日期；执行人身份（姓名、姓名缩写或代号）；疫苗名称、批号或序列号、有效期与制造商；接种部位与途径。
- 可揭式疫苗标签与印记宠物轮廓的印章便利此类记录（某些国家为强制）。不良事件记录方式应能在日后就诊时提醒全体员工。**知情同意应记入病历**，证明已向客户提供相关信息并获授权（如前述「超说明书」使用）；至少应注明接种前已讨论风险与效益。VGG 建议免疫证明不仅写已接种日期，还应留出兽医填写**下次建议接种日期**的栏目，以减少宠主和犬舍/猫舍经营者的困惑。
- **不良事件（adverse events）定义**：与疫苗接种产品给药相关的任何副作用或意外后果（**包括无保护**）；包括与接种相关的任何损伤、毒性或超敏反应，无论能否直接归因于疫苗。**无论已确认还是仅怀疑，不良事件都应报告。**报告应识别涉及的产品与动物及报告提交人。报告田间观察到的意外疫苗表现，是让制造商与监管机构警觉可能需进一步调查的安全性/效力问题的最重要手段。上市前安全性研究的目的是发现相对常见的不良事件；罕见或迟发不良事件只能通过上市后对报告不良事件的分析来发现。应报告给制造商和/或当地监管机构——许多国家没有政府监督方案，此时应报制造商。VGG 认识到由于报告方案的被动性质，疫苗相关不良事件**严重报告不足**，妨碍了对这些产品持续安全性的了解[EB4]；VGG 积极鼓励所有兽医参与监督方案。已有充分记录的不良事件，其报告为未来比较提供基线；报告的不良事件还可导致：发现先前未认识的反应、发现已知反应增多、识别反应相关风险因素、识别有异常事件或更多不良事件的疫苗批号，并进一步刺激临床、流行病学或实验室研究。报告某疫苗的不良事件不是对该疫苗的指控；它有助于审查时间相关状况并充实产品安全数据库。

10.3 致谢与利益声明（分块 010）

VGG 工作由 **MSD Animal Health** 与 **WSAVA** 慷慨赞助；VGG 是独立学术专家组，未与行业协商即制定本指南；赞助公司代表不出席 VGG 会议，对 VGG 建议无否决权。VGG 感谢 AAHA 犬疫苗工作组、AAFP 猫疫苗顾问小组为北美犬/猫免疫建议所做的重要工作，并感谢欧洲 ABCD 从欧洲视角制定猫免疫建议的工作。**参考文献**列表自分块 010（E23–E24）开始、延续至分块 011–013，属引用信息，本稿不整理。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 指南总表（表 1–7）', '11. 指南总表（表 1–7）

抽取说明：分块 008–010 中的表格在 PDF 抽取中列序错乱（表头与注释列合并、疫苗名单元格内断词串行），以下按 2015 版原表逻辑重建单元格内容并照录文字；错乱处标〔原文如此〕。原文页面顺序为表 1（E17–E18）、表 2（E19）、表 3（E20–E21）、表 6（E22）、表 4（E22）、表 5（E22）、表 7（E22–E23）〔原文如此〕。', '', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 1. WSAVA 犬疫苗接种指南（第 1 部分）', '11.1 表 1. WSAVA 犬疫苗接种指南（第 1 部分）', 'dog', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 1. WSAVA 犬疫苗接种指南（第 1 部分） (2)', '| 疫苗 | 幼犬初始免疫 | 成年犬初始免疫 | 再免建议 | 注释与建议 |
|---|---|---|---|---|
| 犬细小病毒 2 型（CPV-2; MLV, parenteral）；犬瘟热病毒（CDV; MLV, parenteral）；重组犬瘟热病毒（rCDV, parenteral）；犬腺病毒 2 型（CAV-2; MLV, parenteral） | 6–8 周龄接种，之后每 2–4 周一次直到 16 周龄或 16 周龄以上 [EB1] | 厂家一般推荐两剂、间隔 2–4 周，但一剂 MLV 疫苗或 rCDV 被认为即有保护 [EB4] | 6 月龄或 1 岁加强，之后不长于每 3 年一次 | **Core（核心）** |
| CPV-2（killed, parenteral）〔灭活肠外〕 | 原文此处缺失（该列单元格在抽取中空置） | 原文此处缺失 | 原文此处缺失 | 有 MLV 可用时**不推荐（Not recommended）** |
| 犬腺病毒 1 型（CAV-1; MLV and killed parenteral） | 原文此处缺失 | 原文此处缺失 | 原文此处缺失 | 有 CAV-2 MLV 可用时**不推荐（Not Recommended）** |
| 狂犬（killed parenteral） | 12 周龄接种一剂；早于 12 周龄接种者应在 12 周龄再免；高风险地区可在首剂后 2–4 周给第二剂 | 单剂 | 1 岁加强。可用 1 或 3 年 DOI 的犬狂犬疫苗〔抽取原文作「1or 3-year」〕；加强时机由该许可 DOI 决定，某些地区由法规 dictates〔原文作「dictated by statute」〕 | **Core where required by statue〔原文如此，应为 statute〕 or in areas where the disease is endemic**（法律要求或疾病流行地区为核心） |
| 副流感病毒（CPiV; MLV, parenteral） | 6–8 周龄接种，之后每 2–4 周直到 16 周龄或 16 周龄以上 [EB4] | 厂家一般推荐两剂、间隔 2–4 周，但一剂被认为即有保护 [EB4] | 6 月龄或 1 岁加强，之后每年 | **Non-core**。原发感染部位在上呼吸道，故优先使用 CPiV（MLV-鼻内）产品而非肠外产品 |
| 支气管败血博德特氏菌（Bordetella bronchiseptica）（live avirulent bacteria, intranasal）+ CPiV (MLV) intranasal；B. bronchiseptica + CPiV (MLV) + CAV-2 (MLV) intranasal〔抽取原文断词串行作「(live avirulent bacteBordetella bronchiseptica ria, intranasal)」〕；B. bronchiseptica intranasal；B. bronchiseptica（live avirulent bacteria, oral） | 最早 3 周龄单剂；厂家现行推荐 8 周龄起使用 | 单剂 | 每年；年度加强仍不能保护的高风险动物更频繁 | **Non-core**。有 B. bronchiseptica 单价产品，或与 CPiV 联用、或与 CPiV+CAV-2 联用。接种动物小比例可出现短暂（3–10 天）咳嗽、喷嚏或鼻液。鼻内或口服疫苗**绝不可**经肠外注射给予，否则可致严重不良反应乃至死亡 |
| 博德特氏菌灭活类〔抽取原文作「(killed bacterin, Bordetella bronchiseptica parenteral (cell wall antigen Bordetella bronchiseptica extract, parenteral)」，串行〕：B. bronchiseptica（killed bacterin, parenteral）；B. bronchiseptica（cell wall antigen extract, parenteral） | 6–8 周龄一剂，10–12 周龄一剂 | 两剂、间隔 2–4 周 | 每年；年度加强仍不能保护的高风险动物更频繁 | **Non-core**。为提供局部保护，鼻内或口服产品优于灭活肠外产品〔EB4〕；但编制时发表的一篇综述对这一优势提出质疑（Ellis 2015） |', 'dog', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 1. WSAVA 犬疫苗接种指南（第 1 部分） (3)', '| 伯氏疏螺旋体〔抽取原文作「(Lyme borreliosis; killed Borrelia burgdorferi whole bacterin, parenteral) (rLyme borreliosis) Borrelia burgdorferi (recombinant-Outer surface protein A [OspA], parenteral)」，串行〕：Borrelia burgdorferi（Lyme borreliosis; killed whole bacterin, parenteral）；Borrelia burgdorferi（rLyme borreliosis; recombinant-OspA, parenteral） | 推荐首剂 12 周龄或更大，第二剂 2–4 周后。Borrelia 疫苗暴露高风险时最早可 9 周龄给予〔抽取原文此句串行作「vaccines Borrelia may be given as early as 9 weeks of age…」〕。对某些疫苗此举构成超说明书使用 | 两剂、间隔 2–4 周 | 每年；按地区定的蜱季开始之前再免 | **Non-core**。一般仅推荐用于已知高暴露风险、生活在或到访媒介蜱暴露风险被视为高的地区、或疾病已知流行地区的犬 |', 'dog', '', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 1.（续，第 2 部分：E18）', '11.2 表 1.（续，第 2 部分：E18）

| 疫苗 | 幼犬初始免疫 | 成年犬初始免疫 | 再免建议 | 注释与建议 |
|---|---|---|---|---|
| 钩端螺旋体（Leptospira interrogans，含 canicola 与 icterohaemorrhagiae 血清群; killed bacterin, parenteral）；美国等另含 grippotyphosa 与 pomona 血清群，欧洲含 grippotyphosa 与 australis，欧洲另有含 grippotyphosa 血清群产品；澳大利亚有含 australis 血清群单价苗；新西兰有 icterohaemorrhagiae 血清群单价苗 | 首剂 8 周龄或更大，第二剂 2–4 周后 | 两剂、间隔 2–4 周 | 每年 | **Non-core**。钩端螺旋体疫苗按不同地理区域已知循环致病血清群而研制。注意血清群（serogroup）可含多个血清型（serovar），「血清群/血清型」用词常混淆。接种应限于已确立暴露风险的地理地区，或生活方式构成风险的犬。已知此类疫苗提供的保护较不强健、持续时间可能较短，故**必须每年接种**[EB1]。过去曾提出菌苗类（bacterin）疫苗与更高比例过敏性不良事件相关——尤其小型犬；该说法证据等级低[EB4]，一项已发表研究显示菌苗并无更大风险（Moore 2005）[EB1]；欧洲钩端螺旋体病共识声明（Schuller et al. 2015）亦持此观点 |
| 犬流感病毒（CIV; H3N8; killed adjuvanted, parenteral） | 两剂、间隔 2–4 周，首剂 >6 周龄 | 两剂、间隔 2–4 周 | 每年 | **Non-core**。仅在美国获批。考虑用于群养高风险组，如犬舍、犬展、日托的犬[EB1] |
| 犬冠状病毒（CCV; killed and MLV, parenteral） | 原文此处缺失 | 原文此处缺失 | 原文此处缺失 | **Not Recommended（不推荐）**。CCV 感染通常亚临床或仅致轻微症状；确诊 CCV 疾病的流行率不足以证明使用现有疫苗是正当的。没有证据表明现有疫苗能保护致病性 CCV 变体（Buonavoglia et al. 2009, Decaro et al. 2009）[EB1]。尽管 CCV 可常被分离到，VGG 仍不能确信 CCV 是成年犬重要的原发性肠道病原——尚无研究满足该病原的科赫法则 |

表 1 脚注（原文照录大意）：凡本表建议与产品说明书（datasheets）不一致之处，注明支持该建议的证据等级〔抽取原文作「Where the recommendations in this table are not consistent with those on datasheets [EB2] the level of evidence supporting the recommendation is given」，[EB2] 为抽取串行所致错位〕。**VGG 未考虑以下地域可及性或用途受限的产品**（抽取原文串行重排，按原表脚注逻辑重建）：Crotalus atrox（西部响尾蛇疫苗）与 Crotalux adamanteus〔原文如此，应为 Crotalus adamanteus〕（东部响尾蛇疫苗）——美国农业部（USDA）限制性许可；Babesia 疫苗（B. canis 皂素中可溶性寄生虫抗原）——欧盟许可；犬疱疹病毒疫苗——欧盟许可；Leishmania 疫苗——巴西与欧盟许可。', 'dog', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 2. WSAVA 救助所环境犬免疫指南（E19）', '11.3 表 2. WSAVA 救助所环境犬免疫指南（E19）

| 各组合推荐疫苗 | 成年初始系列 | 幼犬初始系列 | 注释 |
|---|---|---|---|
| CDV + CAV-2 + CPV-2 (MLV) ± CPiV；rCDV + CAV-2 + CPV-2 ± CPiV；肠外（Parenteral） | 入所前或入所立即一剂；2 周后重复 | 入所前或入所立即一剂，最早 4 周龄；若动物仍在所内，每 2 周重复直到 20 周龄 | 理想情况下幼犬应从 6 周龄开始接种。面对暴发，早在 4 周龄接种（针对 CDV 和/或 CPV-2）可能是恰当的。MDA（若存在）可干扰免疫，但哺乳史常不可得 |
| B. bronchiseptica（live avirulent bacteria, intranasal）+ CPiV (MLV) intranasal；B. bronchiseptica + CPiV (MLV) + CAV-2 (MLV) intranasal；B. bronchiseptica intranasal；B. bronchiseptica（live avirulent bacteria, oral）〔抽取原文此处同样断词串行，见表 1〕 | 推荐两剂、间隔 2 周。单剂可能有保护，但在这种高风险情形第二剂或提供更好保护 [EB4] | 最早 3 周龄单剂。为获最佳效果，若 6 周龄前给予，6 周龄后应追加一剂 [EB4] | **强烈建议**在救助所情形使用鼻内或口服疫苗。鼻内或口服疫苗**绝不可**肠外给予，否则可致严重不良反应或死亡 |
| B. bronchiseptica（bacterin or antigen extract，仅用于肠外给药） | 两剂、间隔 2 周 | 入所时（6–8 周龄起）一剂，2 周后第二剂 | 仅在无法给予鼻内或口服疫苗时才建议肠外接种。犬传染病呼吸道复合症（「犬窝咳」）并非疫苗可预防性疾病，疫苗只应用于帮助管理该病 |
| Rabies（狂犬） | 离开设施时给予单剂 | 离开设施时给予单剂 | 是否接种狂犬疫苗取决于救助所是否位于狂犬流行国家，以及地方法规 |
| 抽取表末列（无疫苗名单元格，仅有注释）〔原文如此〕 | — | — | 在美国，救助所情形常使用 CIV 疫苗，可间隔 2 周给两剂。许多救助所建议与执业场景下对自家宠物犬使用同一疫苗的建议不同；这些建议考虑了救助所环境中潜在的高感染病原压力 |', 'dog', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 3. WSAVA 猫疫苗接种指南（E20）', '11.4 表 3. WSAVA 猫疫苗接种指南（E20）

| 疫苗 | 幼猫初始免疫 | 成年猫初始免疫 | 再免建议 | 注释 |
|---|---|---|---|---|
| 猫细小病毒（FPV; MLV, parenteral）；FPV（killed, adjuvanted 或 killed, non-adjuvanted, parenteral）；FPV（MLV, non-adjuvanted, intranasal） | 6–8 周龄开始，之后每 2–4 周直到 16 周龄或 16 周龄以上 [EB1] | 厂家一般推荐两剂、间隔 2–4 周，但一剂 MLV 疫苗被认为即有保护 [EB4] | 6 月龄或 1 岁加强，之后不长于每 3 年一次 | **Core**。应给猫皇后（queen）在**怀孕前**而非孕期接种。若孕期接种必不可少，只能用灭活核心疫苗；**MLV 疫苗不得用于妊娠动物**；MLV 疫苗不应用于 FeLV 和/或 FIV 感染猫 [EB4] |
| 猫疱疹病毒 1 型（FHV-1; MLV, non-adjuvanted，有肠外与鼻内产品）；FHV-1（killed, adjuvanted, parenteral） | 6–8 周龄开始，之后每 2–4 周直到 16 周龄或 16 周龄以上 [EB1] | 一般推荐两剂、间隔 2–4 周 | 6 月龄或 1 岁加强；低风险猫之后不长于每 3 年一次 [EB1]；高风险猫应每年再免 | **Core**。MLV FHV-1/FCV 疫苗 invariably 互相组合（恒为二价或与 FPV 等其他抗原组合）。鼻内接种后，或肠外 MLV 疫苗自注射部位雾化/渗漏时，偶见轻度上呼吸道症状。注：低风险与较高风险猫定义见正文 |
| 猫杯状病毒（FCV; MLV, non-adjuvanted，有肠外与鼻内产品）；FCV（killed, non-adjuvanted parenteral，含两种杯状病毒毒株）；FCV（killed, adjuvanted, parenteral） | 6–8 周龄开始，之后每 2–4 周直到 16 周龄或 16 周龄以上 [EB1] | 一般推荐两剂、间隔 2–4 周 | 6 月龄或 1 岁加强；低风险猫之后不长于每 3 年一次 [EB1]；较高风险猫应每年再免 | **Core**（上同 FHV-1 注释）；另：**FCV 接种后偶有一过性多关节炎（transient polyarthritis）报告**。注：风险定义见正文 |
| 狂犬（canary pox virus-vectored recombinant, non-adjuvanted, parenteral）〔金丝雀痘病毒载体重组苗〕 | 最早 12 周龄单剂，1 年后加强 | 单剂，1 岁时加强 | 按许可 DOI 或当地法规要求加强 | **Core in areas where the disease is endemic**（疾病流行地区为核心） |
| 狂犬（1 与 3 年 DOI 的 killed, adjuvanted products〔抽取原文作「1and 3-year」〕, parenteral） | 最早 12 周龄单剂，1 年后加强 | 单剂，1 年后再免 | 按许可 DOI 或当地法规要求加强 | **Core in areas where the disease is endemic** |
| 猫白血病病毒（FeLV; canary pox virus-vectored recombinant, non-adjuvanted, injectable） | 最早 8 周龄首剂；第二剂必须在 3–4 周后给予 | 两剂、间隔 3–4 周 | 初始系列末剂后 1 年单剂；对判定有持续暴露风险的猫，之后不长于每 2–3 年一次 [EB4] | **Non-Core**。只应给 FeLV 阴性猫接种；接种前必须做 FeLV 检测，以免不必要地给予疫苗 |
| FeLV（killed, adjuvanted, parenteral）；FeLV（recombinant protein subunit, adjuvanted, parenteral） | 最早 8 周龄首剂；第二剂必须在 3–4 周后给予 | 两剂、间隔 3–4 周 | 同上：末剂后 1 年单剂，之后持续风险猫不长于每 2–3 年 [EB4] | **Non-Core**。只应给 FeLV 阴性猫接种；接种前必须做 FeLV 检测〔抽取原文此单元格句子截断，与上一行同文而无「以免不必要地给予疫苗」尾句〕 |', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 3.（续，E21）', '11.5 表 3.（续，E21）

| 疫苗 | 幼猫初始免疫 | 成年猫初始免疫 | 再免建议 | 注释 |
|---|---|---|---|---|
| 猫免疫缺陷病毒（FIV; killed, adjuvanted, parenteral） | 需三剂。首剂最早 8 周龄；随后两剂按 2–3 周间隔给予 | 需三剂，每剂间隔 2–3 周 | 初始系列末剂后 1 年单剂，之后对判定有持续暴露风险的猫每年一次 | **Non-core**。接种诱导产生的抗体与 FIV 感染应答产生的抗体在用诊内试剂盒检测时无法区分。已有若干鉴别性血清学检测报道。验证过的 PCR 诊断正更广泛可得，VGG 推荐使用 |
| 猫衣原体（Chlamydia felis; avirulent live, non-adjuvanted, parenteral）；Chlamydia felis（killed, adjuvanted, parenteral） | 首剂最早 9 周龄；第二剂 2–4 周后给予 | 两剂、间隔 2–4 周 | 对持续暴露风险的猫建议每年加强 | **Non-Core**。疫苗最适合作为多猫环境中已确诊与临床疾病相关感染的控制方案的一部分使用。曾有意外结膜接种疫苗导致感染临床症状的报道 |
| 支气管败血博德特氏菌（Bordetella bronchiseptica; avirulent live, non-adjuvanted, intranasal） | 鼻内单剂，最早 4 周龄 | 鼻内单剂 | 对持续风险猫建议每年加强 | **Non-Core**。在猫可能面临特定感染风险时可考虑接种，例如大群饲养的猫 |
| 猫传染性腹膜炎（FIP; MLV, non-adjuvanted, intranasal） | 单剂最早 16 周龄，第二剂 3–4 周后 | 两剂、间隔 3–4 周 | 厂家建议每年加强 | **Not Recommended**。按现有有限研究，只有接种时已知为猫冠状病毒抗体阴性的猫才可能产生某种程度的保护。而 16 周龄或更大的猫极少是冠状病毒抗体阴性 |

表 3 脚注：本表建议与说明书不一致之处，注明支持该建议的证据等级〔抽取原文作「Where the recommendations in this table are not consistent with those on datasheets [EB2]…」，[EB2] 位置同表 1 说明〕。', 'cat', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'informational', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 4. WSAVA 救助所环境猫免疫指南（E22）', '11.6 表 6. 疫苗保管（vaccine husbandry）：兽医从业者要点（E22，抽取位于表 3 续与表 4 之间〔原文如此〕；[From Day & Schultz, 2014]）

- 疫苗最适贮存温度通常为 **2–8°C**（家用冰箱应保持在 4°C）。产品不得冻结，不得置于靠近冰箱冷冻室的位置，且应定期监测冰箱温度。运往现场的疫苗同样须保证「冷链」不中断。
- 冻干疫苗应**临用前**用合适稀释液或伴随液体疫苗复溶（按厂家建议）。早晨先把当天预计要用的疫苗全部配好是恶劣做法、属禁忌。某些疫苗组分（如 CDV、FHV-1）在这方面特别不稳定，不临用复溶则该疫苗可能无法诱导足够免疫。
- 只有厂家说明书明示可接受时，才能把疫苗在同一注射器中混合。
- 注射器与针头不得重复使用。
- 疫苗注射部位不得用酒精或其他消毒剂消毒，因其可使感染性（MLV）疫苗灭活。
- 疫苗应在有效期内，且批号、组分与注射部位的准确细节应记入动物病历。

11.7 表 4. WSAVA 救助所环境猫免疫指南（E22）

| 疫苗 | 幼猫（Kittens） | 成年（Adult） | 注释 |
|---|---|---|---|
| FPV、FHV-1、FCV | 入所前或入所时单剂，最早 4–6 周龄；若仍在所内，之后每 2 周一次直到 20 周龄 | 入所时单剂；若动物仍留在救助所，2 周后重复 | MLV 制剂为佳。救助所环境**不推荐**使用鼻内 FPV 疫苗（Schultz 2009）。当需要快速起效（48 hrs）免疫时，鼻内 FCV/FHV-1 MLV 疫苗或更可取。鼻内 FCV/FHV-1 疫苗后更常见的接种后喷嚏（post-vaccinal sneezing）无法与活动性感染区分 |
| Rabies（狂犬） | 离开设施时给予单剂 | 离开设施时给予单剂 | 是否接种由救助所是否位于该国疾病流行且法律要求接种决定 |

脚注：**VGG 不推荐在救助所情形使用其他猫用疫苗。**', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('犬猫疫苗接种指南 2015 版 · 表 5. 6–9 周龄首诊幼犬/幼猫每 3 或 4 周一次的核心免疫程序（E22', '11.8 表 5. 6–9 周龄首诊幼犬/幼猫每 3 或 4 周一次的核心免疫程序（E22）

| 首诊年龄 | 核心免疫程序 |
|---|---|
| 6 周 | 6、9、12、16 周，然后 26 或 52 周；或 6、10、14、18 周，然后 26 或 52 周 |
| 7 周 | 7、10、13、16 周，然后 26 或 52 周；或 7、11、15、19 周，然后 26 或 52 周 |
| 8 周 | 8、11、14、17 周，然后 26 或 52 周；或 8、12、16 周，然后 26 或 52 周 |
| 9 周 | 9、12、15、18 周，然后 26 或 52 周；或 9、13、17 周，然后 26 或 52 周 |

表注（原文照录大意）：本表给出兽医诊所在自有宠物情形通常每 3 或 4 周接种时的可能程序示例。虽然某些高感染压力地区可用每 2 周再免的程序，为呈现简洁未列出。26 或 52 周龄加强苗之后，核心产品接种不长于每 3 年一次（较高风险猫的猫呼吸道病毒疫苗除外）。

11.9 表 7. 血清学检测在救助所传染病暴发中的应用（E22–E23，跨分块 009/010）

| 情形 | 血清学状态 | 对动物的建议 |
|---|---|---|
| 救助所内疾病暴发：所内所有动物应做血清学检测（针对 CDV、CPV2〔原文如此，即 CPV-2〕与 FPV 暴发） | **血清阳性动物（Seropositive）** | 这些动物已受保护，不会感染或死亡。应与无/低应答动物分开。 |
| 同上 | **血清阴性动物（Seronegative）** | 应与血清阳性动物分开。这些动物易感，在感染的潜伏期过去之前不得领养出所（即 CPV 至少 2 周，CDV 至少 6 周）。这些动物应接种疫苗，并在上述潜伏期之后复检以确认血清阳性。 |
| 所外动物需在所内暴发期间进入 | **血清阳性动物** | 可安全进入救助所，因其已受疾病保护。 |
| 同上 | **血清阴性动物** | 应接种疫苗并送往寄养家庭，直到其血清转化；在血清阳性之前不得让其进入救助所。 |', '', 'young', '', '疫苗,母源抗体 MDA,免疫持续时间 DOI,弱毒活疫苗 MLV,CDV,CPV-2,文件框架与执行摘要,循证兽医学（EBVM）证据分级', 'caution', '犬猫疫苗接种指南 2015 版（上）：执行摘要、循证分级、犬猫免疫原则、救助所指南与总表 1–7', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · > 来源机构：WSAVA 疫苗指导小组（Vaccination Guidelin', '> 来源机构：WSAVA 疫苗指导小组（Vaccination Guidelines Group, VGG）
> 原始文档：《WSAVA Vaccination Guidelines 2015》（英文，45 页，抽取 194,104 字符；对应原文刊于 Journal of Small Animal Practice 增刊，页码 E1–E45，本稿覆盖 E25–E45）；原文抽取见 `raw_extracts/WSAVA-Vaccination-Guidelines-2015.md`
> **版本提示：本 2015 版已被 WSAVA 2024 版犬猫疫苗指南取代，本稿仅作历史对照与文献溯源用途，不作为当前临床推荐依据。**现行版本见本板块 `01-犬猫疫苗接种指南2024.md`。
> 分块范围：本稿只整理英文分块 011–020（前半部分 001–010 见 `02-` 号文件）。官方中文译本仅用于术语对照，未作为内容来源。

WSAVA 犬猫疫苗接种指南 2015 版（下）

3. 附录一：疫苗与疾病说明数据表（FACT SHEET）', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 七张数据表横向对照', '3.1 七张数据表横向对照

| 数据表 | 疫苗类型 | 自然感染后保护期（DOI） | MLV 疫苗 DOI | 灭活疫苗 DOI | 基础免疫末次与再免规则 | 抽取完整性 |
|---|---|---|---|---|---|---|
| CPV-2（犬细小病毒 2 型） | MLV（CPV-2a/2b/2c）；少数灭活苗 | 多数犬终生 | ≥9 年（Schultz et al. 2010） | ≥3 年 | 16 周龄或以上完成基础免疫，再于 26 或 52 **months**〔原文如此〕 时接种一次后，再免不必比每 3 年更频繁 | 完整 |
| CAV-2（犬腺病毒 2 型） | MLV（含肠外与鼻内剂型）；部分国家有灭活 CAV-1/CAV-2 | 犬传染性肝炎自然感染后多数终生 | ≥9 年（多数犬，Schultz et al. 2010） | 保护 ICH 者可能短于 MLV | 末次随其他核心病毒疫苗同给，16 周龄或以上；再于 26 或 52 **weeks**〔原文如此，与 CPV-2 表不一致〕 接种一次后不必比每 3 年更频繁 | 完整 |
| CDV（犬瘟热病毒） | MLV；金丝雀痘载体重组苗（rCDV）；灭活苗不易获得 | 多数犬终生 | ≥9 年（Schultz et al. 2010） | 可能短于 MLV 或重组苗 | rCDV 攻毒 ≥5 年、血清学 ≥6 年；MLV 基础免疫不早于 6 周龄（部分产品特许可自 4 周龄）；16 周龄或以上完成后同规则 | 完整 |
| FPV（猫细小病毒／猫泛白细胞减少症病毒） | MLV（注射与鼻内，无佐剂）；含佐剂灭活苗 | 终生 | ≥7 年（攻毒与血清学） | 至少 7.5 年（Scott & Geissinger 1999） | 16 周龄或以上完成基础免疫，26 或 52 周龄再接种一次后，不必比每 3 年更频繁 | 完整 |
| FHV-1（猫疱疹病毒 1 型） | MLV（注射与鼻内，无佐剂）；含佐剂灭活苗 | 自然感染后免疫不牢固、时程不定 | 攻毒保护不完整，难以评估 | 接种后抗体可检出 3 年（Scott & Geissinger 1997）；两剂后 7.5 年攻毒保护不完整但与 1 年相似 | 低风险猫不必比每 3 年更频繁；高风险猫（如经常进出寄养猫舍）应更频繁 | 完整（见 3.9 说明） |
| FCV（猫杯状病毒） | MLV（多为 F9 株，无佐剂）；含佐剂灭活苗；1 种不含佐剂灭活苗含 G1 与 431 两株 | 可显著减轻异株急性症状与口腔排毒，但非终生 | 未给数值 | 抗体至少持续 4 年（Scott & Geissinger 1997）；两剂后 7.5 年攻毒保护不完整但与 1 年相似 | 低风险猫不必比每 3 年更频繁；高风险猫可更频繁；幼猫基础免疫建议用同一毒株疫苗 | 完整 |
| 狂犬病（rabies） | MLV（野生动物口服）；载体重组苗（痘病毒/腺病毒）；灭活苗（犬猫个体免疫与大规模犬免疫的主流） | 无法评估（街毒感染后犬猫发病致死） | — | 商用灭活与重组产品 DOI 为 3 年（Jas et al. 2012） | 首免不早于 12 周龄，1 年后必须再免一次；只有第二次接种后，方可依 3 年 DOI 标签在法规上延长再免间隔至 3 年 | 完整（抽取中表头顺序倒置，见 3.8） |

通用判读规则（7 表反复出现，照录）：**主动免疫且年龄超过 20 周龄的动物，只要血清中存在抗体，无论滴度高低，均与保护相关**（狂犬例外，阈值 ≥0.5 IU/ml、判读年龄 ≥16 周龄）。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 犬细小病毒 2 型（CPV-2）疫苗说明', '3.2 犬细小病毒 2 型（CPV-2）疫苗说明

- **疫苗类型**：现有三种当代变体 CPV-2a、CPV-2b、CPV-2c。原始 CPV-2 变体现今很少分离到，但仍存在于某些弱毒活（Modified Live Virus, MLV）疫苗中，并可自免疫接种动物排出。最新出现的变体是 CPV-2c，在北美、南美、欧洲、非洲与亚洲均已被确认（Ohneiser et al. 2015）。所有基因型抗原上相关；攻毒试验表明，用含 CPV-2 或 CPV-2b 的现有 CPV 疫苗免疫犬，可对所有其他变体（含 CPV-2c）提供保护性免疫（Spibey et al. 2008、Decaro & Buonavoglia 2012、Wilson et al. 2013）。相反地，有一份已免疫成年犬中暴发 CPV-2c 感染的报告（Decaro et al. 2008）——这些犬在 42、57 与 90 日龄接种过，成年后每年打加强针。灭活（ killed）疫苗仅有少数，效果较差、诱导免疫应答所需时间明显长于 MLV（Pollock & Carmichael 1982b），不推荐常规使用；在部分不推荐 MLV 的情形（野生与外来种、妊娠母犬）灭活苗可能有价值，但 CPV-2 灭活苗在这些情形下从未做过安全性或效力试验。
- **机制与保护期**：见 3.1。母源抗体（Maternally Derived Antibody, MDA）依初乳抗体滴度与出生后吸收量不同，会在不同时段干扰幼犬主动免疫（Pollock & Carmichael 1982a）。
- **免疫空窗期（window of susceptibility）**：定义为幼犬可被野毒感染、但疫苗无法免疫的时间段。高效 MLV 疫苗（高效价、低传代）空窗期可短至 2 周或更短；低效 MLV 疫苗空窗期长达 10–12 周（Schultz & Larson 1996、Hoare et al. 1997）。
- **无 MDA 时**：MLV 疫苗最早在接种后 3 天即提供免疫（Schultz & Larson 1996）。
- **禁忌与注意**：MLV 不用于野生动物；除有特别标示外不用于妊娠母犬；4–6 周龄以下幼犬不应使用 MLV 产品。
- **疾病事实**：感染后 3–7 天出现症状；CPV-2 粪排毒极少持续超过 2 周；没有持续感染超过 4 周的报道，可预期动物在此期间死亡或清除病毒；环境中病毒可保持感染性 1 年或更久，因此所有曾收容感染动物的场所都必须视为已被污染。幼犬有犬细小病毒性肠炎临床症状且粪便抗原检测阳性时，该阳性结果**不是**由动物近期所接种的任何 CPV 疫苗造成（DeCaro et al. 2014）。', 'dog', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 犬腺病毒（CAV）-2 疫苗说明', '3.3 犬腺病毒（CAV）-2 疫苗说明

- **疫苗类型**：含 CAV-2 的 MLV 制品是最常见的产品，是唯一被推荐用于预防由 CAV-1 引起的犬传染性肝炎（Infectious Canine Hepatitis, ICH）、并减轻与 CAV-2 感染相关呼吸道症状的疫苗。它们非常有效，且不会引起 CAV-1 疫苗常见的过敏反应性葡萄膜炎（uveitis）或「蓝眼（blue eye）」不良反应（Curtis & Barnett, 1983）。除肠外 MLV CAV-2 制品外，还有用于对抗犬传染性呼吸道疾病综合征（Canine Infectious Respiratory Disease Complex, CIRDC）的组合或单价制品，成分包括支气管败血博德特氏菌（Bordetella bronchiseptica）、犬副流感病毒（canine parainfluenza virus, CPiV）与 CAV-2。含 CAV-2、CPiV 与博德特氏菌的鼻内制品可用于降低 CIRDC 严重程度，但**不应**作为预防 ICH 的唯一疫苗——为此目的还应给予肠外 MLV-CAV-2。灭活 CAV-1 与 CAV-2 疫苗在部分国家销售，但当有 MLV 可用时不推荐（效果较差）。
- **机制与保护期**：MDA 会阻断肠外制品接种后的免疫，因此末次剂量应在幼犬 16 周龄或以上、与其他核心病毒疫苗（如 CDV、CPV-2）一起给予。无 MDA 时，MLV 最早在接种后 5 天即可预防 ICH。CAV-2 疫苗通常没有像 CPV-2 那样的长空窗期（即 <2 周）。
- **注意**：鼻内 CAV-2 疫苗只作为预防 CAV-2 所致上呼吸道疾病的辅助，不用于预防 CAV-1 感染。
- **疾病事实**：CAV-1 主要通过被污染的分泌物/排泄物（唾液、尿液）传播；CAV-1 与 CAV-2 中等稳定，在环境中可存活数天至数周；实验感染 CAV-1 后需 5 天或更久才出现 ICH 症状；CAV-2 主要通过空气传播。CIRDC 发病机制复杂，涉及应激、通风不良、灰尘、不洁设施中的氨气，以及链球菌（Streptococcus spp.）、支气管败血博德特氏菌、支原体（Mycoplasma spp.）、CAV-2、CPiV、犬流感病毒（CIV）、犬肺炎病毒（canine pneumovirus）与犬呼吸道冠状病毒的感染。CAV-2 与其他 CIRDC 相关病原共同存在时可在 3–4 天内引起呼吸道疾病。CIRDC 属多因素疾病，**无法以疫苗预防**，现有疫苗仅有助于降低疾病严重程度。', 'dog', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 犬瘟热病毒（CDV）疫苗说明', '3.4 犬瘟热病毒（CDV）疫苗说明

- **疫苗类型**：MLV 为最常见制品，通常以不同滴度含有 Rockborn、Snyder Hill、Onderstepoort、Lederle 或其他 CDV 毒株。CDV 有许多致病型（pathotypes）〔原文引用处断行为「(Kapil et al. 2008, Espinal et al.」后接下一栏「- which can cause varying clinical signs…」，Espinal 条年份 2014 在抽取中缺失〕，可在广谱物种中引起不同临床症状；但各分离株间血清学差异不显著，用任一现有疫苗免疫都应能提供针对任何致病型的保护性免疫。MLV 不得用于野生动物，除非有证明其安全的特定证据。载体重组（rCDV）疫苗：金丝雀痘病毒（canarypox）重组制品在美国与少数其他国家有售；一种特定的金丝雀痘载体重组制品也曾用于野生与外来物种（Connolly et al. 2013）。灭活苗不易获得、效果较差，因此不应用于犬瘟热免疫（野生动物可能是例外）。
- **机制与保护期**：MLV ≥9 年；rCDV 攻毒试验 ≥5 年、血清学 ≥6 年；灭活苗可能短于 MLV 或重组苗。MDA 依初乳滴度与吸收量干扰幼犬主动免疫。CDV 疫苗通常没有像 CPV-2 那样的长空窗期（<2 周）。**幼犬 MLV 产品免疫不应早于 6 周龄开始**，除非产品有特别许可（某些产品可自 4 周龄使用）；16 周龄或以上完成系列、再于 26 或 52 周龄接种一次后，再免不必比每 3 年更频繁。无 MDA 时 MLV 与重组疫苗在接种后迅速提供免疫。
- **禁忌与注意**：MLV 制品是对家犬减毒（修饰且安全）的产品，不用于野生与外来物种——这些疫苗在那些物种高度毒力（如黑足鼬 black-footed ferret 与灰狐 grey fox），可引起疾病与死亡（Carpenter et al. 1976、Pearson 1977、Durchfeld et al. 1990）；4–6 周龄以下幼犬不应接种 MLV。
- **疾病事实**：症状在感染后 2–6 周出现；潜伏期内 CDV 造成免疫抑制，使动物更易受微生物感染，这些继发感染可能在典型犬瘟症状出现之前导致呼吸道疾病、肺炎与死亡；环境中病毒迅速失去感染性。', 'dog', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 猫细小病毒（FPV）疫苗说明', '3.5 猫细小病毒（FPV）疫苗说明

- **疫苗类型**：MLV 制品以不同滴度含减毒（无毒）猫细小病毒（猫泛白细胞减少症病毒，feline panleukopenia virus），不含佐剂；有注射剂型，也有与其他疫苗抗原（如 FCV 与 FHV-1）组合的鼻内剂型。MLV 优势为起效更快、克服母源抗体的效力更强、更可能赋予足够免疫（DiGangi et al. 2011、Lappin 2012）。**鼻内 FPV 组合疫苗不应在收容所（shelter）环境中使用**；若为取得 FCV/FHV-1 免疫而使用鼻内苗，则应同时给予 MLV-FPV 肠外制品（Schultz, 2009）。灭活苗：有含佐剂灭活 FPV 疫苗；某些产品单剂注射可在相对短时间内诱导 naïve 猫良好抗体应答，但**所有灭活 FPV 制品都需要间隔 2–4 周的两剂，且免疫只在第二剂后才存在**。在 MLV 不被推荐的野生与外来种、妊娠母猫或逆转病毒感染猫中，灭活苗可能有益。
- **机制与保护期**：自然感染/发病后 DOI 终生；MLV ≥7 年；灭活泛白细胞减少症疫苗至少 7.5 年（Scott & Geissinger 1999）。虽然多数猫泛白细胞减少症由 FPV 引起，但犬细小病毒变体（CPV-2a、CPV-2b、CPV-2c）已出现可感染猫并可能致病（Decaro & Buonavoglia 2012），某些现有 FPV 疫苗对这些 CPV 变体提供部分保护。FPV 的「免疫空窗期」按犬细小病毒类推——抗体水平低到不足以抵抗自然感染、却又高到干扰疫苗时，即存在免疫间隙。16 周龄或以上完成幼猫系列、再于 26 或 52 周龄接种一次后，再免不必比每 3 年更频繁。为控制收容所暴发而使用疫苗时，MLV 更快诱导免疫在临床上更有利；MLV 接种后保护起始极早（Brun & Chappuis 1979）。
- **禁忌与注意**：MLV FPV 不用于野生动物，除非有安全性证据；**绝不用于妊娠母猫**（病毒可传给胎儿并造成胎儿损害）——部分国家有许可用于妊娠母猫的灭活 FPV 疫苗，但原则上应避免对妊娠母猫做不必要的产品给予；**绝不给予 4–6 周龄以下幼猫**（避免损伤仍在发育的新生儿小脑）；不应用于严重免疫抑制个体——风险虽小，但在严重免疫抑制（如临床 FIV 或 FeLV 感染、或使用强免疫抑制药物）时无法控制病毒复制，可能于接种后出现临床症状。
- **疾病事实**：感染后 2–7 天出现症状；呕吐通常在发热开始后 1–2 天出现，腹泻可能更晚出现且并非必然；脱水迅速发生，病猫可能坐在水碗旁明显口渴却不饮水；终末期病例低体温，可发生脓毒性休克与弥散性血管内凝血（disseminated intravascular coagulation）；环境中病毒可保持感染性 1 年或更久（Gordon & Angrick 1986），故所有曾收容感染动物的设施都必须视为已被污染。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 猫疱疹病毒（FHV）-1 疫苗说明', '3.6 猫疱疹病毒（FHV）-1 疫苗说明

- **疫苗类型**：MLV 制品以不同滴度含减毒 FHV-1（猫鼻气管炎病毒 feline rhinotracheitis virus，单一血清型），不含佐剂；有注射剂型与鼻内剂型，可单独或与其他疫苗抗原（总与 FCV 联合）组合。另有含佐剂灭活苗。
- **机制与保护期**：FHV-1（与 FCV 一样）疫苗提供的保护不如 FPV 疫苗完整；不应期待这两种猫核心疫苗提供与犬核心疫苗或 FPV 同样强健的免疫强度与持续时间。DOI 评估困难：完全临床保护只在接种后短时间内可见，保护程度随时间下降（Gaskell et al. 2007）。自然感染/发病后免疫远非牢固，持续时间不定。灭活 FHV-1 疫苗接种后抗体滴度可检出 3 年（Scott & Geissinger 1997），但 FHV-1 抗体滴度与保护的相关性不好（Gaskell et al. 2007）；两剂灭活苗接种 7.5 年后以强毒 FHV-1 攻毒，保护不完整，但与该制品 1 年后的保护相似（Scott & Geissinger 1999）。低风险猫在 16 周龄或以上完成幼猫系列、再于 26 或 52 周龄接种一次后，再免不必比每 3 年更频繁；较高风险猫（如定期进出寄养猫舍者）应更频繁再免。既往规律免疫的猫若漏打加强针，单次注射即被认为足以唤起免疫记忆。**没有任何疱疹病毒疫苗能抵抗强毒野毒感染**；FHV-1 会转为潜伏，并可能在严重应激期被激活，激活的病毒可在已免疫动物引起临床症状、可被排出并传染易感动物、在易感幼猫与猫引起疾病（Gaskell et al. 2007）。细胞介导免疫在保护中起重要作用，因此已免疫猫检测不到血清抗体并不必然表示易感。MDA 依初乳滴度与吸收量干扰幼猫主动免疫；**初级免疫系列通常在约 6–8 周龄开始**；MDA 对 MLV 鼻内（IN）疫苗的干扰小于肠外 MLV 制品，预期在带有 MDA 的幼猫中 IN 疫苗会比肠外疫苗更早免疫。在繁殖猫舍中，感染多出现在断奶前幼猫，典型在 4–8 周龄、随 MDA 消退时发生；多数情况下感染源是母猫，其潜伏病毒因分娩与哺乳应激被激活。
- **禁忌与注意**：MLV 肠外 FHV-1 与 FCV 疫苗仍保留部分致病潜力，给予不当（意外雾化、食入、或从皮肤/被毛上的疫苗沉积处吸入）可能诱发疾病；鼻内接种后有时可见上呼吸道疾病症状。
- **疾病事实**：排毒最早可在感染后 24 小时开始，持续 1–3 周；急性疾病在 2–6 天后出现，10–14 天内缓解。病毒沿感觉神经扩散并到达神经元胞体，尤其三叉神经节（trigeminal ganglia）是主要潜伏部位；多数猫成为终生潜伏带毒者，在应激事件时周期性排毒（Gaskell et al. 2007）——相比之下 FCV 排毒在感染后连续数月。疱疹病毒基因组 DNA 在感染神经元核内持续存在而不复制。环境中病毒不稳定，常用消毒剂即可灭活。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 猫杯状病毒（FCV）疫苗说明', '3.7 猫杯状病毒（FCV）疫苗说明

- **疫苗类型**：MLV 制品最常含 F9 株 FCV，无佐剂；有注射与鼻内剂型，可单独或与其他抗原（总与 FHV 联合）组合。含佐剂灭活苗亦有售；一种不含佐剂的灭活苗含两种杯状病毒株（G1 与 431 株；Poulet et al. 2005）。
- **机制与保护期**：FCV 各株间抗原变异很大；先前感染某一株可显著减轻暴露于异源株时的急性临床症状，也减少口腔排毒；一般而言异源保护程度取决于所检毒株的配对。感染后中和抗体约第 7 天首次出现，其滴度与同源攻毒保护相关良好；猫在缺少血清抗体的情况下也可能被保护，因为已证明局部分泌型 IgA 抗体与细胞应答可给已免疫猫提供保护。含佐剂灭活 FCV 疫苗接种后抗体至少持续 4 年（Scott & Geissinger 1997）；两剂灭活佐剂苗 7.5 年后攻毒保护不完整，但与该产品 1 年时保护相似（Scott & Geissinger 1999）。FCV（与 FHV-1 一样）不如 FPV 疫苗完整，两种核心呼吸道疫苗不应期待与 FPV 或犬核心疫苗同等强健；已免疫猫可能再以不同株再感染 FCV。低风险猫在 16 周龄或以上完成系列并于 26 或 52 周龄再接种一次后，再免不必比每 3 年更频繁；高风险猫（如定期进出寄养猫舍）可更频繁再免。**建议幼猫系列使用含相同病毒株的疫苗。** MDA 在生命最初数周对保护重要，也可能干扰接种；**MDA 的平均半衰期被测定为 15 天，并可持续存在 10–14 周**（Johnson & Povey 1983）。一项田间研究中约 20% 的 6 周龄幼猫检测不到针对某种广泛使用疫苗株的抗体（原文引用 Dawson et al. 2001，该条位于分块 001–010 的 A–D 段参考文献，本稿范围外）。MDA 对经鼻 MLV 的干扰小于肠外 MLV 制品，预期在有 MDA 的幼猫中经鼻苗比肠外苗更早免疫。
- **禁忌与注意**：鼻内接种后偶尔可见上呼吸道疾病症状作为并发情况（Lappin et al. 2006, 2009）；由于田间循环的抗原各异病毒种类繁多，疫苗株组合的选取是为交叉保护以免于严重临床疾病，但已免疫猫仍可能发生轻微疾病。与 FHV-1 在应激后间歇排毒相反，FCV 为持续排毒，但通常在数个月后停止（Coyne et al. 2006a）；疫苗对排毒的影响仍有争议，观察从适度减少排毒到延长感染后排毒期不等。活的肠外 FCV 疫苗株可被排出，但少见。
- **疾病事实**：FCV 感染可引起急性口腔与上呼吸道症状，也与慢性齿龈口炎（可能为免疫介导）相关。潜伏期 2–10 天；口腔溃疡（尤其舌缘）、喷嚏与浆液性鼻漏为主要症状；急性口腔与上呼吸道症状主要见于幼猫。有一种独立综合征「毒力全身性猫杯状病毒（virulent systemic feline calicivirus, VS-FCV）病」偶有报道（Coyne et al. 2006b）：在收容所与医院暴露的猫中潜伏期 1–5 天，家庭环境可长达 12 天；该病在成年猫似比幼猫更严重。**现有疫苗不能保护猫抵抗田间感染**，但实验上已显示某种程度保护（Poulet & Lemeter 2008、Huang et al. 2010），这可能归因于超高毒力株的固有特性。美国有一种疫苗含灭活 VS-FCV 株（同时含「传统」与 VS-FCV 分离株），据报道可提供针对同源 VS-FCV 的保护（Huang et al. 2010）；该 VS-FCV 株是否提供针对异源 VS-FCV 株的保护尚不清楚。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 狂犬病（rabies）疫苗说明', '3.8 狂犬病（rabies）疫苗说明

〔抽取稿中该节表头「FACT SHEET: RABIES VACCINES / Types of Vaccines Available」出现在正文中部，而总标题「狂犬疫苗说明」被 PDF 抽取移到分块底部并排成空表头「| | 狂犬疫苗说明 | |」，本稿按逻辑顺序重排，文字照录。〕

- **疫苗类型**：MLV——除用于宠物犬猫外，被广泛用于野生动物的口服免疫（如加拿大与欧洲的狐狸、芬兰的貉子 raccoon dogs）；全部为 SAD（Street Alabama Dufferin）病毒株的安全衍生株。载体重组狂犬疫苗——重组疫苗病毒特别安全，因为它们只含与保护相关的狂犬病毒糖蛋白 G 基因；表达狂犬病毒糖蛋白的痘病毒（牛痘 vaccinia 与金丝雀痘 canarypox）与腺病毒载体在北美常规经口用于控制野生动物狂犬病（牛痘与腺病毒载体），经肠外用于猫（金丝雀痘载体）；这些疫苗在所有受试禽类与哺乳动物中均无毒力。灭活疫苗——是犬猫个体保护与大规模犬只免疫计划的常规选择；灭活苗在环境温度下稳定性好、比活制品更易管理，且自身意外注射不构成风险（MLV 则会有）。
- **机制与保护期**：犬猫狂犬病主要靠灭活苗控制；但在美国与欧洲，重组金丝雀痘载体狂犬疫苗已获许可并广泛用于猫，因为它不引起含佐剂狂犬疫苗造成的注射部位炎症（Day et al. 2007）。**所有首次狂犬疫苗接种后 1 年必须再免一次；只有在那第二次接种之后，才可以在法规上把再免间隔用带 3 年 DOI 标签的产品延长至 3 年。** 自然感染后 DOI 无法评估（街毒感染后发病在犬猫均致死）。商用灭活与重组产品接种后 DOI 为 3 年（攻毒与血清学，Jas et al. 2012）。**首免不早于 12 周龄**，1 年后再免；抗体滴度一般在接种后 4 周达到保护水平。当法律目的需要血清学检测时，接种与检测之间的间隔至关重要且可能因产品而异，应参考产品资料与法律要求。某些疫苗已证明可抵抗强毒狂犬病毒攻毒 3 年，但国家或地方法规可能要求每年加强——VGG 鼓励所有立法者在制定政策时考虑科学进展；某些疫苗（如国家本地生产的产品）可能无法可靠保护超过 1 年。**主动免疫且超过 16 周龄的犬只血清抗体 ≥0.5 IU/ml 与保护相关**；达到该浓度（≥0.5 IU/ml）也是某些国家宠物旅行的法定要求，这些国家的宠物移动方案包含接种后血清学检测。
- **疾病事实**：症状在感染后 2 周至数月出现（传播一般为咬伤或抓伤），取决于感染部位；任何无法解释的攻击行为或突然行为变化都必须视为可疑。疾病表现为「狂躁型（furious）」或「麻痹型（dumb）」。经典狂躁型症状包括眼睑反射、角膜反射与瞳孔反射减弱、斜视、下颌下垂、流涎、异食癖（pica）、癫痫发作、抽动、震颤、定向障碍、无目的踱步、无目的咬合与啃咬、情绪反应 exaggerated（易怒、暴怒、恐惧）、畏光，以及共济失调与麻痹，最终昏迷并死于呼吸停止。麻痹型狂犬病在犬比猫更常见，表现为下运动神经元麻痹，从咬伤部位进展累及整个中枢神经系统，麻痹迅速导致昏迷与死于呼吸衰竭。环境中病毒迅速失去感染性，含洗涤剂类消毒剂易于灭活。', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 本范围附录一的完整性说明', '3.9 本范围附录一的完整性说明

分块 013–015 内七张数据表（CPV-2、CAV-2、CDV、FPV、FHV-1、FCV、狂犬）的四个固定小节——「Types of Vaccines Available」「Mechanisms and Duration of Immunity (DOI)」「Precautions」「Disease Facts」——文字均可读且成段，未见整节缺失。异常仅为：条目内引用年份丢失（CDV 致病型处，见 3.4）、强化针月龄/周龄表述不一致（CPV-2，见 3.1）、页码标记与断词嵌入行内（见第 1 节）、狂犬节表头顺序倒置（见 3.8）。〔核对说明：官方中文译本在 FHV-1 节之后另有「方框 2：犬利什曼病（Phlebotomus scutellatus 和其他传播媒介）」的表格残片，但对应的英文原框文字不在分块 011–020 的抽取内容中，本稿不据译本补写，「原文此处缺失」〕

4. 附录二：常见问题（FREQUENTLY ASKED QUESTIONS, FAQS）

分块 015 底部至 020 结束为 FAQ 附录，原文以项目符号排列、分五个主题；英文抽取稿未给条目编号（正文内部仅出现两处交叉引用「see FAQ 60 above」与「see Q92」，抽取中无法对应编号）。下列编号为本稿检索编号（P=产品类、C=操作程序类、S=血清学类、H=年度体检类、A=不良反应类），非原文编号。', 'dog', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO', '4.1 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRODUCTS）', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO (2)', '- **P1 MLV 可否用于野生、外来种，或用于该疫苗许可保护对象之外的家养种？** 不可以，除非已证明对该物种安全，绝不给予 MLV 疫苗。许多 MLV 疫苗在许可对象以外的动物中引起过疾病。更糟的是，疫苗可能自野生动物排出、经多次传代恢复毒力，甚至对其原本开发的靶物种造成疾病。对 CDV 易感物种而言，安全有效的疫苗是金丝雀痘病毒载体重组 CDV 疫苗，有雪貂用单价制品与犬用组合制品；单价苗用于许多易感 CDV 的野生与外来种，但只在某些国家有售。
- **P2 高 CDV 风险的幼犬可否用人用麻疹疫苗免疫？** 不可以。因病毒量不足，人用麻疹（MV）疫苗对幼犬不具免疫原性。专为犬制造的麻疹疫苗（有时与 CDV 及附加病毒成分组合）可在比 CDV 疫苗更早的日龄提供暂时保护；幼犬在 16 周龄或以上必须接种 CDV 疫苗以获得永久免疫。
- **P3 某些疫苗能否更早免疫已有 CDV MDA 的幼犬？** 能。犬用异源麻疹疫苗比 MLV-CDV 疫苗约早 4 周免疫幼犬；金丝雀痘载体重组 CDV 疫苗约早 4 周免疫某些 MLV 苗；某些高效价 MLV 疫苗（安瓿内含更大病毒量）也能在有 MDA 的幼犬中更早免疫。
- **P4 MDA 既阻断 MLV，是否也阻断灭活苗的免疫？** 是。MDA 可阻断某些灭活苗。若灭活产品需两剂（常见）而第一剂被 MDA 阻断，则第二剂不会免疫；在此情形下第二剂起致敏（prime）作用（若未被阻断），还需第三剂才能免疫与加强。MLV 则不然——无 MDA 时单剂即可致敏、免疫与加强。尽管如此通常仍推荐两剂（尤其幼龄动物），以确保有一剂落在 MDA 消退、无法阻断之时。这就是幼犬/幼猫系列中**末剂应在 16 周龄或以上给予**的原因。
- **P5 有说法称某些犬 MLV 组合核心产品只需给两次、末次最早 10 周龄，准确吗？** VGG 知悉某些犬疫苗为让幼犬获得早期社会化好处而许可此种「提早完成（early finish）」。VGG 接受幼犬社会化的重要性，但对此免疫方案的免疫学有效性持保留意见。目前**没有任何组合核心产品**在 10 周龄给末剂时能免疫可接受比例的幼犬（尤其不能抵抗 CPV-2）。VGG 建议：只要可能，末剂应在 16 周龄或以上给予，无论此前给了几剂；未完成完整幼犬疫苗系列的幼犬，饲主应严格控制其在家庭环境外的暴露，仅允许与健康且完全免疫的犬接触。
- **P6 是否存在针对同一疾病的肠外与鼻内疫苗？** 有，尤其是抗犬 CIRDC 的犬疫苗与抗 FCV/FHV-1 上呼吸道疾病的猫疫苗。应严格按制品指定途径给予：若把肠外（皮下）含 FCV 与 FHV-1 的 MLV 疫苗局部使用（鼻内或口服），可能对猫造成严重疾病；若局部使用灭活 FCV/FHV-1 疫苗，则不会产生免疫且可能引起明显不良反应。若把鼻内活 CIRDC 疫苗肠外给予，可能造成严重坏死性局部反应甚至致死犬只；而把肠用灭活博德特氏菌疫苗鼻内给予则不会免疫并可能引起超敏反应。但两类产品可同时或在该动物生命不同时间给予。同时肠外与鼻内免疫实际可能优于只在单一部位免疫（Reagan et al. 2014、Ellis 2015）：肠外免疫在肺部提供保护，但上呼吸道免疫很少或没有（尤其局部分泌型 IgA 与细胞介导免疫 CMI）；鼻内免疫产生良好分泌型 IgA、局部 CMI 与非特异性免疫（如 I 型干扰素），但并非总是在肺部提供免疫。
- **P7 使用核心疫苗后，犬多久才产生可预防重症的免疫力？** 取决于动物、疫苗与疾病。最快的是 MLV 与重组金丝雀痘载体 CDV 疫苗——免疫应答在数分钟至数小时内开始，对无干扰水平 MDA、非严重免疫抑制的犬可在一天内提供保护。使用有效 MLV 时，CPV-2 与 FPV 免疫最早 3 天后形成、通常第 5 天已存在。相反，灭活 CPV-2 与 FPV 疫苗常需 2–3 周或更久才提供保护性免疫。肠外给予 CAV-2 MLV 会在 5–7 天提供针对 CAV-1 的免疫；但鼻内给予时，同等程度的 CAV-1 免疫需 2 周或更久才出现，某些犬根本不产生——因此针对 CAV-1 免疫推荐肠外 CAV-2。FCV 与 FHV-1 从接种到免疫的时间难以确定，因为有些动物不产生保护性免疫；一旦产生，需 7–14 天（Lappin 2012）。
- **P8 正确免疫的幼犬/犬与幼猫/猫，核心疫苗效力如何？** 用 MLV 或重组 CDV、CPV-2、CAV-2 正确免疫的犬，对疾病的保护 ≥98%，对感染的保护也预期极高。接受 MLV 疫苗并正确免疫的猫，预期 ≥98% 对 FPV 疾病与感染受保护。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO (3)', '相反，FCV 与 FHV-1 疫苗最好也只是保护免于疾病而非感染，在高度污染环境中尤其如此（如收容所）——在高危环境中保护见于 60%–70% 的受免个体。家养、不与其他猫接触或只与已免疫并长期家养的猫同处时保护率似乎高得多，因为病毒感染风险与应激水平都低得多。
- **P9 田间是否存在现有疫苗无法提供保护性免疫的 CDV 或 CPV-2 突变株（生物型/变体）？** 据现有知识没有。CDV 无争议。所有现有 CDV 与 CPV-2 疫苗在实验与田间条件下都能抵抗各自所有已知分离株。但有一份在意大利以 MLV 免疫过的犬中暴发 CPV-2c 的报告（Decaro et al. 2008），同一课题组另有报告称一只年长的已免疫犬发生 CPV-2c 相关疾病（原文引 Decaro et al. 2009）。
- **P10 现有 CPV-2 疫苗能否保护新变体 CPV-2c？保护多久？** 能。无论疫苗内含何种变体，CPV-2 疫苗刺激主动免疫应答（如抗体应答），攻毒时对目前所有 CPV-2 变体（2a、2b、2c）提供长期（4 年或更长）保护。
- **P11 细小病毒疫苗（CPV-2 与 FPV/泛白细胞减少症）可否口服？** 不可以。口服不免疫；鼻内可以免疫，但最有效途径是使用相应疫苗经肠外（皮下或肌肉）接种。
- **P12 某些 CPV-2 疫苗能否比其他 CPV-2 疫苗更早免疫有 MDA 的幼犬？** 能。某些具有更高病毒滴度（安瓿内病毒量更大）及/或更具免疫原性分离株（不论变体）的 CPV-2 疫苗，可比其他标准 CPV-2 疫苗提前数周免疫。
- **P13 使用钩端螺旋体（Leptospira）菌苗时，应选含两个血清群还是更多（如某些国家的三价或四价产品）？** 在高危犬使用钩体疫苗时，若可获得，应使用含该地区所有致病血清群的商品疫苗。许多国家对犬群中流行哪些血清群了解不足，VGG 鼓励收集此类数据。
- **P14 钩端螺旋体疫苗是否像核心病毒疫苗那样提供长期（数年）免疫且高度有效？** 不是。钩体疫苗提供相对短期免疫；且某些钩体产品可预防临床疾病，却不能保护免于感染与排菌，尤其是在接种 6 个月以后才发生感染时。接种后抗体常仅持续数月，提供保护的免疫记忆相对短（如 1 年）。
- **P15 有无猫白血病病毒（FeLV）疫苗（灭活佐剂、亚单位、重组）单剂即可保护？** 没有。所有 FeLV 疫苗至少需两剂；两剂最好间隔 2–4 周，自 8 周龄或以上开始。只有在完成那两次初始免疫后，才可用单剂加强。若初始两剂间隔超过 6 周或更久，建议重新免疫，并确保以 2–4 周间隔给予两剂。
- **P16 幼猫接受 FeLV 疫苗与 1 岁加强后，是否需要每年再免？** 不需要。再免应为每 2–3 年。含佐剂疫苗每年再免可能增加注射部位肉瘤发生的风险。
- **P17 为什么我的国家没有 FIV 疫苗？** 疫苗可及性通常由制造商与当地/区域监管机构依当地疾病状况的科学知识（以及市场考量）决定。现有 FIV 疫苗含两种 FIV 分支（亚型，clades/subtypes）A 与 D；虽声称对其他亚型有交叉保护，但不同国家流行的病毒存在地理差异。给予 FIV 疫苗的猫应在接种前检测血清抗体，并以微芯片识别。
- **P18 接种过 FIV 疫苗的猫会被 FIV 感染吗？** 会。该疫苗不能预防所有 FIV 亚型的感染与潜伏，因此 FIV 免疫过的猫也可能被感染，并可作为易感猫的病毒来源。
- **P19 现有 CIRDC 疫苗能否保护免于犬流感病毒（CIV）所致疾病？** 不能。发现感染并发生 CIV 疾病的赛级灵缇（racing greyhounds）此前每年常规用商品 CIRDC 疫苗免疫 3 次以上。CIV 与其他犬病毒在抗原上无关，但与马流感病毒（H3N8）相关。美国有 CIV 疫苗，推荐用于风险犬只；针对新出现（2015）的 H3N2 病毒的疫苗刚获条件性许可。
- **P20 是否有可用于辅助预防 CIV 所致疾病的疫苗？** 有。美国有旨在辅助预防犬 H3N8 流感的疫苗，为含佐剂灭活苗，与许多灭活疫苗一样需初免两剂、间隔 2–4 周。该 CIV 疫苗或未来其他疫苗的效力与保护期将在田间信息积累后的未来几年确定。
- **P21 有无并非为预防病毒、细菌、真菌/酵母与寄生虫所致传染病而设计的犬猫疫苗？** 有。有辅助预防某些蛇种咬伤致死的疫苗，也有辅助治疗犬口腔黑色素瘤的疫苗。
- **P22 病质制剂（nosodes，整体疗法制剂）可用于免疫宠物吗？** 不可以。nosodes 不能用于预防任何疾病；它们不含抗原，因此不具免疫作用。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与疫苗产品相关（QUESTIONS RELATED TO VACCINE PRO (4)', '- **P23 VGG 如何看待犬肠冠状病毒（canine enteric coronavirus）疫苗？** VGG 不推荐使用犬冠状病毒疫苗，因为没有足够证据表明该疫苗具保护力，也没有证据表明肠冠状病毒是重要的犬致病菌。有报道该病毒的变异株在世界多地引起成年犬与幼犬的严重全身性疾病，但不清楚现有疫苗能否保护免于这些变异株。检测试剂盒检出冠状病毒并不必然意味着它是疾病的原因。
- **P24 单价疫苗是否优于多价疫苗？** 成分尽可能少的疫苗使从业者更容易遵循 WSAVA 指南。多组分核心 MLV 疫苗（如 CDV、CAV-2 与 CPV-2）是核心免疫的理想递送方式，但非核心抗原（如钩端螺旋体、CIRDC）最好各自单苗，以便只在风险:益处分析提示有获益时才给予。就钩体疫苗而言，若其配方有支持纳入多血清群的证据，多组分产品可能提供最佳保护。
- **P25 多价疫苗中不同抗原的数量会否损害疫苗效力？** 不会。多价疫苗要获许可，制造商必须证明疫苗的每个组分都能诱导保护性免疫，通常通过攻毒试验。
- **P26 无既往免疫史的成犬可以一次给所有疫苗吗？** 与上题类似：可以，犬应能同时对同时给予的多种抗原生应答。但除资料表明确指示外，绝不把不同疫苗混在同一注射器内。从第一性原理看，把不同疫苗给予不同解剖部位以让不同淋巴结参与适应性免疫应答是良好实践，但没有研究正式证明这一点。
- **P27 MLV 疫苗与「基因改造」疫苗有何区别？** 基因改造疫苗包括病毒载体疫苗、基因突变（基因缺失）疫苗与裸 DNA 疫苗。理论上它们可能比某些 MLV 疫苗更安全，因为没有「回复毒力（reversion to virulence）」的可能；这些疫苗也被设计以产生最佳免疫应答。
- **P28 感染性（MLV）疫苗是否比非感染性（灭活或亚单位）疫苗更能「突破」MDA？** 是。某些 MLV 疫苗与某些基因改造疫苗在有 MDA 存在时，似乎能比非感染性疫苗更早产生免疫。
- **P29 为什么没有合适的核心疫苗组合可供按指南使用？** 并非所有国家都有合适产品。若当地没有，你与你所在国家的动物医院协会应向制造商与政府监管机构游说，把合适产品带入你的市场。许多情况下产业愿意提供新产品，但瓶颈在许可机构。
- **P30 使用含本地株的疫苗是否优于国际疫苗？** 没有证据表明国际核心疫苗在全球范围内不能对 CDV、CAV-1、CAV-2、CPV-2、FPV、FCV、FHV-1 与狂犬病毒提供良好保护。多数情况下，株间变异不会改变病原之间保守的关键保护性抗原。就钩端螺旋体而言，在疫苗中加入本地重要的额外血清群可提升保护。
- **P31 诊所如何知道送到的疫苗储存正确且仍然有效？** 国际制造商在散装运输阶段使用温度指示系统，确保从进口到送达诊所过程中冷链持续。
- **P32 犬破伤风有多常见？是否应当免疫？** 在世界许多地区，犬破伤风不常见。没有许可用于犬的破伤风疫苗，但在某些被认定高风险的地区，兽医师会在犬使用马破伤风疫苗（超说明书使用）。鉴于如今在世界许多地方破伤风比犬传染性肝炎与犬瘟更常被观察到，开发许可的犬用破伤风疫苗可能是合理且具有商业可行性的。
- **P33 VGG 是否推荐应使用哪个疫苗品牌？** 不推荐。VGG 是独立学术团体，不做产品特定建议。但就国际疫苗而言，VGG 知悉这些产品都经过了质量、安全性与效力的严格评估，因而得在许多国家获许可。VGG 不推荐某些疫苗——但这基于缺乏充分科学证据（即同行评审文献）证明该疫苗必要或有效。建议会定期复核并按需要调整。
- **P34 若只想用 DHPPi 而不含钩体成分，用什么复溶 DHPPi？** 应向该疫苗的制造商或供应商询问，但合适的稀释液可能是无菌生理盐水或无菌注射用水；若否，制造商应能提供所需的特定稀释液。
- **P35 狂犬疫苗可用于小型哺乳动物（兔、豚鼠等）吗？** VGG 不推荐小型哺乳动物常规接种狂犬疫苗，雪貂除外；不过某些狂犬疫苗许可用于所有哺乳动物种。
- **P36 高风险地区是否应每 6 个月使用钩体疫苗？** 没有明确证据表明钩体疫苗每 6 个月再免比每年再免提供更好保护，即使在高风险地区。
- **P37 幼犬接种初次狂犬疫苗后被流浪犬咬伤，是否应接受暴露后预防（post-exposure prophylaxis, PEP）？若接受 PEP 后数周再被咬，是否要再来一疗程？** 若被咬幼犬已正确免疫，应已受狂犬病保护。VGG 知悉在某些国家此情形仍使用 PEP，为幼犬利益、更重要的是为人家庭利益。**重复 PEP 不合理**：届时幼犬已接受多次接种，再注射不带来额外获益。', 'dog', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI', '4.2 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATION PROCEDURE）', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI (2)', '- **C1 可以把不同类型疫苗混在同一注射器吗？** 不可以。除资料表另有规定外，绝不把不同疫苗制品混在同一注射器。
- **C2 可以在同一动物体内共同注射不同疫苗（非同一商品产品）吗？** 可以。但不同疫苗应注入由不同淋巴结引流的独立部位。
- **C3 狂犬与 DHPPi 疫苗可以同时（并发）给予吗？** 可以，但若疫苗标签没有并发使用声明，这可能被视为「超说明书」使用。理想上这样同时使用的两种疫苗应在不同解剖部位给予，使疫苗抗原被带到不同淋巴结，在两处分别激发适应性免疫。
- **C4 小型犬可否用更小剂量以降低不良反应风险？** 不可以。制造商推荐的体积（如 1.0 ml）通常代表最小免疫剂量，因此必须给予全量。美国已上市一款为小型犬设计的新产品，配方为 0.5 ml 剂量，但含与常规 1.0 ml 疫苗大体相同的抗原与佐剂量。也有 0.5 ml 剂量的猫疫苗，同样只减少体积（不减抗原或佐剂含量）。
- **C5 大型犬（大丹）应与小型犬（吉娃娃）注射相同体积的疫苗吗？** 是。与剂量依赖的药物不同，疫苗不按每公斤体重（体型）计算，而按最小免疫剂量。
- **C6 可以给麻醉中的病畜接种吗？** 若可能最好不要，因为病畜可能发生超敏反应并呕吐，增加吸入风险；且麻醉剂可能具免疫调节作用。
- **C7 可以给妊娠宠物接种吗？** 除资料表明确指示外，妊娠期不应给予疫苗。最佳做法是确保繁殖母犬已接种（核心疫苗），但无需在妊娠前立即给繁殖母犬额外核心疫苗——其标准免疫计划（如每 3 年核心再免）就能为幼犬提供足够保护性免疫与初乳抗体。妊娠期间应尽可能避免 MLV 与灭活产品接种。例外情形存在，尤其在收容所：若妊娠动物从未接种且疾病（如 CDV 或 FPV）正在暴发，则建议接种。
- **C8 犬猫使用免疫抑制性糖皮质激素治疗会否干扰疫苗免疫？** 两个物种的研究提示，接种前或同时使用免疫抑制性糖皮质激素，对抗体产生没有显著抑制作用。但建议在糖皮质激素治疗结束后数周（2 周或以上）再免疫，尤其是当治疗发生在核心疫苗初免系列期间。
- **C9 可以给接受免疫抑制或细胞毒性治疗（糖皮质激素以外，如肿瘤或自身免疫病）的宠物接种吗？** 不可以。尤其应避免 MLV 产品，因其可能致病；灭活产品接种可能无效或加重免疫介导疾病。一项高剂量环孢素（ciclosporin）治疗猫的研究显示，治疗期间给予 FPV 与 FCV 加强苗的血清应答未受影响，但针对 FHV-1、FeLV 与狂犬的保护性抗体应答被延迟；相反，接受治疗猫在 FIV 疫苗初级系列后未能产生抗体，提示环孢素损害初次接种免疫应答而不影响记忆应答（Roberts et al. 2015）。
- **C10 停用免疫抑制治疗后要等多久再接种？** 至少 2 周。
- **C11 犬单核埃立克体（Ehrlichia canis）感染犬会免疫抑制，是否应接种？** 没有证据表明患单核细胞埃立克体病的犬不能对接种作出充分应答，也没有证据表明感染犬对核心疫苗成分的保护性抗体滴度会下降。理想做法是先治疗，并在治疗停止后再执行必要接种。无论如何，某些情况下给此类病例接种狂犬疫苗可能是法定要求。
- **C12 是否应给发病、高热或应激的动物接种？** 不应。这违背良好实践与多数疫苗资料表的建议。
- **C13 疾病高风险时可否每周接种？** 不可以。即使给予的是不同疫苗，接种间隔也不应比每隔一周（every other week）更频繁。
- **C14 若幼犬没有 MDA，应从何时开始接种？** 实践中很难证明幼犬无 MDA，这需要确切知道幼犬未摄入初乳。若确知，则核心疫苗可从 4–6 周龄给予。某些 MLV 疫苗不得早于 4 周龄给予，因可能对幼犬造成病理。若该幼犬确实无 MDA，可能在 6 周龄对单剂产生充分应答；但给第二剂于 16 周龄可能更务实。
- **C15 可以给 4 周龄以下幼犬接种吗？** 不可以。此龄幼犬有 MDA，会阻断 MLV 疫苗致敏免疫系统的能力；疫苗资料表也不支持此做法，且给如此幼龄动物 MLV 疫苗可能存在安全问题。一个例外是抗 CIRDC 的鼻内疫苗，可安全用于 3 周龄起。
- **C16 幼犬与幼猫疫苗系列的末次剂量应在何时给予？** 应在 16 周龄或以上给予末次剂量。
- **C17 为什么 VGG 建议狂犬疫苗不早于 12 周龄？** 某些狂犬疫苗许可早于 12 周龄给予，但我们建议在这样做的地方动物仍应在 12 周龄再接种一次。就狂犬病大规模免疫运动而言，重要的是免疫区域内尽可能多的犬，包括 12 周龄以下的幼犬。
- **C18 可否先注射灭活苗、随后短时间再对同一疾病注射 MLV？** 不可以。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI (3)', '灭活苗可能诱导体有效抗体应答而中和 MLV 疫苗中的病毒，从而阻止免疫。最好是先给 MLV 疫苗，若/当需要时再用灭活制品再免疫。
- **C19 可否把鼻内用的 MLV 博德特氏菌疫苗肠外注射？** 不可以。该疫苗可造成严重局部反应，甚至可能通过引起全身性疾病（如肝衰竭）致死宠物。
- **C20 可否把供肠外使用的灭活博德特氏菌疫苗鼻内给予？** 不可以。这不会刺激针对博德特氏菌的保护性应答，但可能引起超敏反应；应按资料表规定经鼻内途径给予活的鼻内疫苗。
- **C21 幼犬鼻内接种后打喷嚏，需要重新接种吗？** 鼻内产品使用后常见打喷嚏并损失部分疫苗。这些疫苗在设计时已考虑部分损失，因此通常无需重新接种，除非明显没有或仅有极少产品成功递送。
- **C22 在猫使用 MLV FHV-1/FCV 肠外疫苗时需要注意吗？** 需要。必须避免黏膜（如结膜与鼻腔）接触制品，因为疫苗病毒可致病。此类接触可能来自接种不当雾化，或猫舔食从注射部位渗出的疫苗。
- **C23 可以在免疫计划中使用不同品牌（制造商）的疫苗吗？** 可以。在动物一生中使用不同制造商的疫苗甚至可能更理想，因为不同产品可能含不同毒株（如猫杯状病毒）。但**不建议**在初级免疫计划中混合含不同毒株（如 FCV 或钩体血清群）的疫苗。
- **C24 初级系列中可以混用不同制造商的产品吗？** 不同国际供应商的核心 MLV 疫苗成分相似，初级系列中可以混用（例如幼犬 8–9 周龄在一位兽医师处接种某产品，之后转到使用另一产品线的兽医师处）。制造商不会支持此做法（会加以劝阻），因为他们未开展过证明其产品与其他制造商产品相容性的研究。非核心疫苗使用不同制造商也可能可接受，但**钩端螺旋体疫苗例外**——第一剂用两血清群产品、第二剂用四血清群产品，将无法对四价苗中额外两个血清群诱生免疫。FCV 疫苗适用同一原则（原文作「see FAQ 60 above」〔抽取稿无编号，无法对应，原文如此〕）。
- **C25 是否应在注射部位使用消毒剂（如酒精）？** 不应该。消毒剂可能使 MLV 制品失活，且据知并无益处。
- **C26 可以把组合产品中的疫苗拆分吗？** 可以。例如钩端螺旋体菌苗常作为病毒抗原组合的稀释液使用；可将「病毒 cake（冻干饼）」用无菌水或缓冲盐水重悬，而钩体菌苗在另一部位或另一时间单独给予，或弃去。
- **C27 单剂疫苗对犬或对猫会有任何获益吗？对犬猫群体有益吗？** 有。在 16 周龄或以上给予一剂 MLV 犬核心疫苗（CDV、CPV-2、CAV-2）或 MLV FPV 疫苗，应可提供长期免疫。每只 16 周龄或以上的幼犬与幼猫都应至少接受一剂 MLV 核心疫苗。就猫呼吸道核心疫苗（FCV 与 FHV-1）而言，给予两剂、间隔 2–4 周可使保护最大化；若这样做，群体（种群）免疫将显著改善。即使在免疫记录良好的美国，可能也只有 <50% 的幼犬与 <25% 的幼猫曾接受过疫苗。我们必须为群体中更多动物接种核心疫苗，以达到更好的群体免疫（如 75% 或更高）并预防暴发。
- **C28 动物首次接种需两剂才免疫的疫苗（如灭活钩体菌苗或 FeLV 疫苗），若未在 Ä6 周内回来接种第二剂〔原文为乱码符号「Ä6 weeks」，原文如此；据上下文应指超过 6 周〕，会有免疫吗？** 没有。两剂型疫苗的单剂不提供免疫：第一剂致敏免疫系统，第二剂才是免疫。若第二剂未在第一剂后 6 周内给予，应重新开始该方案，并确保两剂在 2–6 周内给予。两剂完成后，可以每年或更长间隔以单剂加强应答。
- **C29 复溶后的 MLV 疫苗在室温可放置多久而不失活性？** 在室温下，某些较敏感的制品（如 CDV、FHV-1）会在 2–3 小时内丧失免疫能力，而其他成分可保持免疫原性数天（如 CPV、FPV）。VGG 建议 MLV 疫苗复溶后应在 1 至 2 小时内用完。
- **C30 若动物已超过一般认为的核心疫苗最短保护期（CDV、CPV-2、CAV-2 为 7 至 9 年；FPV 为 7 年），是否必须重新开始疫苗系列（间隔 2–4 周多剂）？** 不必。对 MLV 疫苗，只有带 MDA 的幼犬或幼猫才需要多剂。VGG 知悉许多资料表确实建议重新开始免疫系列，但不认可这一做法，因为它与免疫系统的基本功能和免疫记忆原则不符。
- **C31 是否应给 FeLV 与/或 FIV 感染的猫接种？** 临床上健康的 FeLV 或 FIV 阳性猫理想上应室内饲养、远离其他猫，以尽量减少暴露于传染病的风险。但若认为有必要以核心成分（FPV、FCV 与 FHV-1）接种，专家团体目前建议应使用灭活（而非 MLV）疫苗。此类猫不应接种 FeLV 或 FIV 疫苗。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫操作程序相关（QUESTIONS RELATED TO VACCINATI (4)', '有临床疾病的 FeLV 或 FIV 阳性猫不应接种。某些国家的狂犬接种法定要求也涵盖逆转病毒感染猫。
- **C32 猫的疫苗应注射在哪里？** 猫疫苗（尤其含佐剂制品）不应注入肩胛间（inter-scapular）区域。在美国的做法是：狂犬疫苗注入右后肢远端、FeLV 疫苗注入左后肢远端、核心 FPV/FCV/FHV-1 疫苗注入某一只前肢远端。皮下注射的替代部位包括尾远端，或胸壁/腹壁外侧。这些选项在本文件正文中进一步讨论（正文部分在分块 001–010 范围内，本稿不复制）。无论选择哪个部位，疫苗都必须皮下注射而非肌肉注射。重要的是，猫的解剖接种部位应轮换，避免反复注射同一位置。可通过为每只动物在每次接种时记录部位并在其间轮换来实现，或采纳「每年使用一个解剖部位」的诊所政策。
- **C33 严重营养缺乏会影响疫苗的免疫应答吗？** 会。已证明某些严重的维生素与痕量矿物质缺乏（如维生素 E/硒）可干扰幼犬保护性免疫应答的形成。已知或疑似的营养缺乏应先通过适当营养补充纠正，然后重新接种，以确保有足够保护性免疫。
- **C34 若幼犬或幼猫未获得初乳，会从母体得到任何被动抗体保护吗？** 依母体抗体滴度而定，它们只有很少或（最可能）没有保护，因为新生幼犬幼猫约 95% 或以上的被动抗体来自初乳，出生后 24 小时内经肠道吸收进入体循环。
- **C35 未获得初乳、因而没有 MDA 阻断主动免疫的幼犬幼猫，应在生命最初数周接种吗？** 不可以。4–6 周龄以下的幼犬幼猫不应接种 MLV 核心疫苗。某些活疫苗病毒给 2 周龄以下、无 MDA 的幼犬幼猫时，可感染中枢神经系统及/或致病，可能致动物死亡。原因是出生后第一周或更长时间内几乎没有体温调节能力，因此先天与适应性免疫显著受损。
- **C36 这些失去初乳的幼龄动物如何免于核心疾病？** 若幼犬幼猫不足 1 日龄，可喂人工初乳。人工初乳为 50% 代乳粉（如 Esbilac™ 或类似产品）与 50% 免疫血清（最好来自母犬或与母犬同环境生活、完全免疫的动物）。若幼犬幼猫已满 1 日龄或更大，可皮下或腹腔给予来自完全免疫、无传染性疾病的成年动物的血清，或静脉给予枸橼酸化血浆。依动物体型，约 **3 至 10 ml** 血清或血浆，每日两次，最多 3 天。
- **C37 犬到多大年龄可以停止接种？** 就核心疫苗，目前推荐终身再免但不比每 3 年更频繁；若选用非核心疫苗，这些通常每年给予。可用血清学检测在任何成年犬确认对核心疾病（CDV、CAV 与 CPV-2）的保护，并选择不给该动物再免。目前的建议是每 3 年做一次血清学评估，但 10 岁以上犬应每年进行。许多国家也有按特定间隔接种狂犬疫苗的法定要求。
- **C38 未免疫成年犬推荐什么方案？** 核心疫苗以单剂 MLV（CDV、CAV-2、CPV-2）接种，流行地区加狂犬。无需给两剂。此后每 3 年或更长间隔再免（或对 CDV、CAV 与 CPV-2 做血清学检测）。非核心疫苗应基于该个体的风险:益处分析选择；非核心疫苗需两剂、间隔 2–4 周，随后每年加强。
- **C39 钩体免疫史不清的成犬推荐什么方案？也像幼犬那样两剂间隔 2–4 周吗？** 是，该犬需要两剂疫苗、间隔 2–4 周，随后每年再免。
- **C40 未免疫成年猫推荐什么方案？** 对从未接种的成年猫，VGG 建议核心疫苗以两剂 MLV（FPV、FCV、FHV-1）接种，流行地区加一剂狂犬疫苗。低风险猫，再免（或对 FPV 做血清学检测）不比每〔原文此处缺失间隔数值，据上下文应为 3 年〕此后更频繁；高风险猫 FPV 再免不比每 3 年更频繁，而 FHV-1 与 FCV 每年接种。非核心疫苗应基于该个体的风险:益处分析选择。
- **C41 猫若已有上呼吸道疾病症状，还应接种吗？** 当前有临床疾病的猫不应接种。一旦康复，猫会对 FCV 或 FHV（若两者都参与致病则对两者）有一定自然免疫，但这种免疫从来不是灭菌免疫（即使接种后也一样）。没有任何指征说明患过呼吸道病毒感染的猫在康复后不应接种。三联疫苗可保护免于 FPV，也保护免于先前未参与该次呼吸道疾病的呼吸道病毒（FHV-1 或 FCV）。
- **C42 我国某些地区停电常见，可能持续 2–3 天，当时冰箱里的疫苗怎么办——还能用吗？** 未在适当温度下保存 2–3 天的 MLV 疫苗不应使用。这些疫苗的某些成分（如 CDV）对温度敏感，病毒可能已失活。如有任何疑问，应联系制造商寻求建议。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与血清学检测使用相关（QUESTIONS ABOUT THE USE OF SE', '4.3 与血清学检测使用相关（QUESTIONS ABOUT THE USE OF SEROLOGICAL TESTING）

- **S1 血清抗体滴度对判定疫苗诱导的免疫有用吗？** 有用。对犬的 CDV、CPV-2 与 CAV-1、猫的 FPV，以及（法律目的）犬猫狂犬病毒尤其如此。对其他疫苗，血清抗体滴度价值有限或无价值。因技术与生物学原因，CMI（细胞介导免疫）检测对任何疫苗都几乎没有价值。这些问题对血清学检测影响较小，因为血清学检测更容易控制许多变量；然而仍会出现不一致结果，取决于该实验室的质量保证程序。
- **S2 CPV-2/CDV 接种后应等多久才可用诊所内检测测定保护性抗体浓度？** 这个问题对幼犬最相关，因为成犬在加强接种时很可能无论如何都已存在血清抗体。若幼犬在 16 周龄接受末次初免，则可从 **20 周龄起**检测。此时存在的任何抗体不可能来自被动母源，因此表示该幼犬已主动受保护。
- **S3 为什么 VGG 不推荐常规狂犬抗体检测？** 对许多兽医师而言此问题可能没有实际意义，因为许多国家犬猫定期狂犬接种是法定要求，不论任何滴度结果。狂犬抗体检测只在与国际宠物旅行相关的某些情形才需要。国际狂犬疫苗高度有效，通常认为无需在接种后证明免疫。
- **S4 能否用抗体检测（CDV、CPV-2 与 CAV）测定 MDA，以决定首次接种时间？** 理论上可以，多年前常用「列线图（nomogram）」依据母犬血清抗体滴度估算幼犬何时最可能对接种应答。实践中，为监测 MDA 下降而对幼犬反复采样检测会非常困难且昂贵。
- **S5 接种后 3 年期间抗体滴度如何变化？** 对 CDV、CAV-2、CPV-2 与 FPV，抗体会以相似滴度持续存在。多项田间血清学调查（最后一次接种可追溯至 9 年前的犬）与实验研究（最后一次接种可追溯至 14 年前的犬）已证实这一点。钩端螺旋体滴度在接种后会快速下降，且无论如何与保护相关性不好。血清抗体滴度对 FCV 与 FHV-1 相关性较低，因为最重要的免疫类型分别是黏膜免疫与细胞介导免疫。
- **S6 完成幼犬/幼猫基础免疫的动物，是否需要更高抗体滴度来抵御强攻击？** 对 CDV、CAV-2、CPV-2 与 FPV，答案是不需要。抗体的存在（无论滴度）即表示保护性免疫与免疫记忆存在于该动物体内。为提升抗体滴度而更频繁接种疫苗是无意义的尝试——不可能通过提高抗体滴度制造出「更强的免疫」。
- **S7 可以用检测犬只替代年度接种吗？我们担心「每 3 年才加强一次」的建议。** 当然可以。现在已有经验证良好的诊所用血清学检测试剂盒，可测定针对 CDV、CAV、CPV-2 与 FPV 的保护性血清抗体是否存在。在另一些国家，这些试剂盒用于每 3 年确认保护（而不是对核心疾病自动再免）。你可以每年做血清学，但若收集并分析你诊所内产生的数据，会很快发现每年检测并不合理。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与年度体检相关（QUESTIONS ABOUT THE ANNUAL HEALT', '4.4 与年度体检相关（QUESTIONS ABOUT THE ANNUAL HEALTH CHECK）

- **H1 年度体检应做哪些检查/检测？** 年度体检应聚焦于一次优秀的基本体格检查（包括体温、心脏听诊与触诊）〔原文作 "an excellent basic physical examination"〕。应采集详尽病史以了解生活方式与疾病风险（如旅行、寄养、室内与室外暴露）。应与饲主讨论营养与寄生虫控制的基本原则。在某些国家，体检也可能包含对当地常见传染病的常规检测。
- **H2 有些饲主不愿仅为年度体检复诊，如何推广体检概念以提高依从性？** 这完全是教育问题。客户应理解体检检查宠物健康与福利的各个方面，可能发现临床问题的早期阶段。就免疫而言，体检可能包含血清学（核心疫苗抗原每 3 年一次），或在需要时给予年度非核心疫苗。
- **H3 年度体检的费用对我的客户来说太高了。** 年度体检可以只像一次优秀的临床病史与体格检查那样简单——其成本纯粹是兽医师的专业时间。根本上，「年度体检」概念是用新方式交付多数从业者已作为「疫苗加强针加体格检查」提供的服务。对较富裕客群，年度体检已被证明是提供其他兽医服务并提高诊所盈利的途径。这也是实践更优质医学、重新定义兽医—客户关系的一个范例。', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 第 1 段', '4.5 与疫苗不良反应相关（QUESTIONS RELATED TO ADVERSE REACTIONS TO VACCINES）', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 第 2 段', '- **A1 给宠物过度接种是否有风险（如注射过频，或使用该宠物并不需要的疫苗）？** 有。不应无必要地给予疫苗，因为它们可能引起不良反应。疫苗是医疗产品，应根据个体动物需要定制。
- **A2 某些疫苗或疫苗组合是否比其他更容易引起不良反应？** 尽管常被这样假定，但鲜有科学证据支持。不良反应的发生常取决于动物遗传背景（如小型犬或某些犬家族）（Moore et al. 2005、Kennedy et al. 2007）。有人提出菌苗（灭活细菌疫苗）如钩端螺旋体、博德特氏菌、疏螺旋体（Borrelia）与衣原体比 MLV 病毒疫苗更易引起 I 型超敏反应，但缺乏支持证据。也有人提出含佐剂的 FeLV 与狂犬疫苗更可能与猫注射部位肉瘤相关，但证据相互矛盾。
- **A3 有不良反应或免疫介导疾病史（如荨麻疹、面部水肿、过敏性休克、注射部位肉瘤、自身免疫病等）的犬猫是否应接种？** 若疑似引起不良反应的是核心疫苗，可做血清学检测；若动物为血清阳性（含 CDV、CAV、CPV-2、FPV 抗体），则无需再免。若涉及的是可选非核心疫苗（如钩端螺旋体或博德特氏菌菌苗），则不建议再免。狂犬疫苗须咨询当地主管机关，决定是依法接种还是以测定抗体滴度作为替代。若绝对必须接种，换用不同产品（制造商）可能有帮助；但此策略未必总成功，因为已知超敏反应与疫苗内的辅料（excipients，如病毒培养过程中残留的牛血清白蛋白）有关，而这些辅料在许多不同产品中通用。接种前使用抗组胺药或抗炎剂量糖皮质激素是可接受的，且不干扰接种免疫应答。易感动物再免后应密切监测至接种后 24 小时，尽管此类反应（I 型超敏）通常在暴露后数分钟内发生。其他类型超敏（II、III 或 IV）可迟得多（如数小时至数月）。
- **A4 小型犬常见不良反应，可以减少疫苗剂量来避免吗？** 不可以。疫苗剂量不像药物那样按 mg/kg 计算；需要全部抗原来有效刺激免疫。不应拆分疫苗剂量，也不应给小型犬减少体积。美国已上市一款为小型犬设计的新产品，配方为 0.5 ml 剂量，但含与常规 1.0 ml 疫苗大体相同的抗原与佐剂量，不太可能显著降低小型犬不良反应事件的发生率。该产品及现在许多商品疫苗常含更低浓度的辅料（原文作「see Q92」〔抽取稿无编号，无法对应，原文如此〕），而减少外来蛋白浓度可能才是降低不良反应更重要的因素。
- **A5 疫苗会引起自身免疫病吗？** 疫苗本身不引起自身免疫病，但在遗传易感动物中，疫苗可能触发自身免疫反应继而发病——任何感染、药物或多种其他环境因素也同样可能。
- **A6 疫苗不良反应有多常见？** 没有确定答案，因为难以取得准确数据。不良反应频率的判定依赖兽医师或饲主向制造商或国家机构报告（在有此类途径之处）。目前认为我们使用的疫苗非常安全，副作用发生率极低。免于严重传染病的好处远大于发生不良反应的风险。近期对美国一家大型医院集团数据库的分析使基于大量犬猫的发表成为可能：接种犬在接种后 3 天内记录到不良反应（任何类型，含极轻微）为 **38/10,000**（Moore et al. 2005）；接种猫在接种后 30 天内记录到不良反应（任何类型，含极轻微）为 **52/10,000**（Moore et al. 2007）。但有些动物可能发生了未报告给该诊所、而报告给其他诊所或急诊诊所的反应。某些品种与宠物家族的不良反应风险可能高于一般动物群体。
- **A7 是否存在不能对疫苗产生免疫应答的犬猫？** 有。这是一种遗传特征，在某些品种尤为明显，这些动物称为「无应答者（non-responders）」。有亲缘关系（同家族或同品种）的动物常共享这种不应答性。若动物对高致病因子（如犬细小病毒或猫泛白细胞减少症病毒）是无应答者，则一旦感染可能死亡；若对很少致死病原是无应答者，可能发病但会存活（如支气管败血博德特氏菌感染之后）。
- **A8 幼犬在初始核心疫苗系列后会否出现免疫抑制？** 会。若使用含 MLV-CDV 与 MLV-CAV-2 及其他成分的组合制品，会出现约持续 1 周的免疫抑制，始于接种后第 3 天（Strasser et al. 2003）。这种免疫抑制是正常疫苗应答的一部分，极少（if ever）造成临床问题。若组合疫苗不含 MLV-CDV 或 MLV-CAV-2，则不发生这种抑制。
- **A9 既然所有幼犬都应接受核心疫苗（CDV、CPV-2 与 CAV-2），如何避免幼犬免疫抑制？** 幼犬可肠外接受含 CDV 与 CPV-2 的双价疫苗，CAV-2 稍后再给。
- **A10 钩端螺旋体免疫应答在某些犬引起超敏反应，该应答是否也短效（如 <1 年），像感染免疫那样？** 不是。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 与免疫力和 IgG 记忆相对短效（≤1 年）不同，经皮肤试验测定的速发型超敏记忆', '与免疫力和 IgG 记忆相对短效（≤1 年）不同，经皮肤试验测定的速发型超敏记忆是长效的（≥4 年）。
- **A11 可用类固醇治疗疫苗的轻度过敏反应病例吗？** 可以。面部水肿与瘙痒等反应可用抗炎（而非免疫抑制）剂量的口服糖皮质激素（如泼尼松龙 prednisolone）及/或抗组胺药治疗。
- **A12 有无证据表明皮肤血管炎可由接种引起？** 有，这是极罕见但已被认可的接种后不良反应，尤其见于狂犬疫苗接种后。
- **A13 猫会出现与犬相同的疫苗皮肤过敏表现吗？** 会。猫接种后可出现与犬相同的 I 型超敏表现（如面部水肿与皮肤瘙痒）。
- **A14 我们怎么知道一只猫的肉瘤是由疫苗引起？如何处理这类肉瘤？** 猫注射部位肉瘤（feline injection site sarcoma, FISS）发生于此前曾给予注射制品的解剖位置。据疑包括疫苗在内的多种注射制品都可能触发这些肿瘤。重要的是把猫的接种部位记录在动物的终身病历中，WSAVA 指南就猫建议的最佳接种位置给出了意见。只要可能应为猫选择不含佐剂的疫苗。遗憾的是这些肉瘤侵袭性很强：广泛浸润，约 **20%** 可发生转移；需要大范围手术切除（常最好由专科医师执行），并可使用辅助放疗与免疫治疗。
- **A15 为什么狂犬疫苗引起的超敏病例比以前更多？为什么在玩具贵宾犬更常见？** 任何类型疫苗都可能引起超敏反应。我们现在知道引起这些反应的主要抗原是牛血清白蛋白（bovine serum albumin, BSA），它在疫苗生产过程中被掺入疫苗。制造商现在正降低动物疫苗中的 BSA 浓度。这类反应在许多玩具品种中更常见，而在许多国家这些品种目前格外流行（Miyaji et al. 2012）。可能存在遗传易感性，但目前理解很少。
- **A16 为什么有些犬繁殖场持续出现犬死于 CDV 与 CPV-2 感染？** 最可能原因是种犬免疫不足。当母犬未有效接种、幼犬未获得足够 MDA 时可能暴发。相反，若幼犬接种未按 WSAVA 指南进行（即以 16 周龄或以上的末次幼犬疫苗），而当母犬确有高水平 MDA 时，部分幼犬可能处于未保护状态。最后，某些犬种（如罗威纳 Rottweiler、杜宾 Dobermann）是这些疫苗遗传性无应答者的风险更高。良好饲养管理、卫生与营养都在减少犬舍疾病暴发中起作用。
- **A17 弱毒活疫苗会否回复毒力？犬会被 MLV 疫苗感染吗？** 会，MLV 疫苗株理论上可回复毒力，但这极罕见。作为疫苗许可的一部分，制造商必须证明即使疫苗病毒被排出也不会发生回复毒力。MLV 疫苗被称为「感染性疫苗」，因为它们通过在犬内诱导足以引起免疫、但不致病的低水平感染（与病毒复制）起效。就犬细小病毒而言，免疫过的犬可能在接种后短期经粪便排出 MLV 疫苗株；这对其他犬不构成风险。
- **A18 有些幼犬 6 周龄接种 DHPPi，7 周龄即发生细小病毒感染，为什么？** 最常见原因是动物在接种前已在感染潜伏期。这些幼犬可能在「免疫空窗期」被感染——此时它们不再有足够的 MDA 完全抵抗强毒街毒，而现存的 MDA 仍足以干扰其对近期接种疫苗的免疫应答。
- **A19 除（很小的）不良反应风险外，年度接种还有什么其他风险？** 接种后不良反应风险确实相对小。对犬和猫，分别约为每 10,000 只接种动物 30 至 50 例反应，且绝大多数是非严重反应（如短暂发热、精神沉郁、过敏反应）。但如果客户的一只动物发生严重反应——那是很难进行的对话。采纳新指南不只是把不良反应风险降到最低，而是实践更好的、循证的兽医学，只在需要时才执行一项医疗操作（即接种）。
- **A20 有些犬是遗传性应答不良者（如罗威纳）。这类品种该如何接种？** WSAVA 指南含有一张有用的流程图帮助识别无应答犬。所有幼犬都应以同样方式接种（末次接种在 16 周龄或以上）；若担心品种与可能无应答的问题，应在 **20 周龄**做血清学检测。多数无应答者只对核心疫苗抗原中的一种（即 CDV、CAV 或 CPV-2）无法血清转换。你可以尝试为该犬再免疫并复测，但真正的无应答者（或低应答者）可能对再免疫仍无应答。这类动物就是缺乏对那特定抗原产生免疫应答的能力，永远不会对该疫苗成分应答。应让饲主意识到这些犬处于风险之中，理想上不应将其用于繁殖。
- **A21 我们应如何分析接种的风险:益处？** 风险:益处分析实际上只适用于非核心疫苗的选择，因为所有犬猫（无论居住与生活方式如何）都应接受核心疫苗（流行地区包括狂犬）是既定前提。该分析针对个体动物做出，考虑饲主告知的饲养方式、室内/室外活动、旅行与寄养频率、与其他动物接触情况（如是否为多宠家庭）等。', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 第 3 段', '应考虑的风险：(1) 接种后不良反应的风险；(2) 你在执行一项不必要医疗操作的风险；(3) 依据你所在地区疾病流行率科学知识，动物感染该病原的风险；(4) 感染后发生临床疾病的风险。可考虑的益处：(1) 若动物的生活方式或地理位置使其可能暴露于该病原，疫苗能否保护其免于感染；(2) 若动物被感染，疫苗能否减轻临床症状严重程度；(3) 被接种的动物是否对群体免疫有贡献。', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 时间表、剂量与阈值速查（照录）', '5. 时间表、剂量与阈值速查（照录）

| 项目 | 数值（照录英文分块 011–020） |
|---|---|
| 幼犬/幼猫核心系列末次接种 | 16 周龄或以上（无论此前给过几剂） |
| 系列后加强 | 26 或 52 周龄再接种一次（CPV-2 数据表原文作 "26 or 52 months of age"〔原文如此〕） |
| 核心疫苗再免间隔 | 不必比每 3 年更频繁（猫 FHV-1/FCV 高风险个体可更频繁；FeLV 每 2–3 年） |
| 两剂型疫苗（灭活/亚单位/重组）初免间隔 | 2–4 周；FeLV 自 8 周龄或以上开始；若间隔超过 6 周需重新开始，确保两剂在 2–6 周内 |
| 疫苗频率上限 | 不应比每隔一周更频繁，即使给予不同疫苗 |
| MLV 起始日龄 | CDV MLV 不早于 6 周龄（部分产品特许可自 4 周龄）；4–6 周龄以下不接种 MLV 核心苗；抗 CIRDC 鼻内苗可自 3 周龄 |
| 狂犬首免 | 不早于 12 周龄；1 年后必须再免；此后 3 年 DOI 标签产品可依法规用 3 年间隔 |
| 狂犬保护阈值 | 主动免疫且 >16 周龄犬血清抗体 ≥0.5 IU/ml 与保护相关；该值也是某些国家宠物旅行的法定要求 |
| 抗体与保护判读（核心病毒） | 主动免疫且 >20 周龄，血清中存在抗体（无论滴度）即与保护相关 |
| 幼犬末次接种后血清学检测 | 16 周龄末免者，20 周龄起可测（排除母源抗体干扰） |
| 血清学评估频率 | 每 3 年一次；>10 岁犬每年一次 |
| 无 MDA 时 MLV 起效 | CPV-2/FPV 最早 3 天、通常 5 天；CAV-1（肠外 CAV-2）5–7 天（鼻内 2 周以上或根本不产生）；CDV MLV/rCDV 数分钟至数小时起、1 天内保护；FCV/FHV-1 7–14 天（部分动物不产生）；灭活 CPV-2/FPV 常需 2–3 周或更久 |
| 已证保护率 | 犬 CDV/CPV-2/CAV-2 正确免疫 ≥98% 免于疾病；猫 FPV ≥98%；猫 FCV/FHV-1 高危环境仅 60–70% 且只防疾病不防感染 |
| 复溶 MLV 使用时限 | VGG 建议 1–2 小时内用完；室温下 CDV、FHV-1 2–3 小时即丧失免疫能力，CPV、FPV 可保持数天 |
| 免疫抑制治疗后再免等待 | 至少 2 周（糖皮质激素结束后数周，2 周或以上） |
| 未吃初乳幼崽替代方案 | 人工初乳 = 50% 代乳粉 + 50% 免疫血清（<1 日龄）；≥1 日龄可皮下/腹腔给免疫成年动物血清，或静脉给枸橼酸化血浆，约 3–10 ml、每日两次、最多 3 天 |
| 被动免疫比例 | 新生幼犬幼猫约 95% 或以上被动抗体来自初乳，出生后 24 小时内经肠吸收 |
| 群体免疫目标 | 提到需为更多动物接种核心疫苗以达到群体免疫（如 75% 或更高）；美国估计 <50% 幼犬、<25% 幼猫曾接种 |
| 不良反应发生率 | 犬 3 天内 38/10,000；猫 30 天内 52/10,000；概括为犬与猫各约每 10,000 只 30–50 例 |
| FISS | 已免疫猫中流行率数值在本范围未给出（正文在分块 001–010）；本范围记载约 20% 转移、应选无佐剂苗、禁肩胛间、必须皮下、部位轮换 |
| 环境稳定性 | CPV-2/FPV ≥1 年；CAV-1/CAV-2 数天至数周；CDV 与狂犬病毒迅速失去感染性；FHV-1 不稳定、常用消毒剂可灭活 |
| 排毒 | CPV-2 粪排毒极少 >2 周、持续感染 >4 周未见报道；FHV-1 感染后 24 小时开始排毒、持续 1–3 周、终生潜伏应激时排出；FCV 连续排毒通常数月后停止 |
| 潜伏期 | CPV-2 3–7 天；FPV 2–7 天；CDV 2–6 周；FCV 2–10 天；VS-FCV 收容所/医院 1–5 天、家庭可达 12 天；FHV-1 急性病 2–6 天出现、10–14 天缓解；CAV-1（实验感染）≥5 天；CAV-2 与其他 CIRDC 病原共同 3–4 天致病；狂犬 2 周至数月 |', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 禁忌症与注意事项汇总（可检索条目）', '6. 禁忌症与注意事项汇总（可检索条目）

| 类别 | 原文规则 |
|---|---|
| 野生动物与外来种 | 除有特定安全证据外不得使用 MLV（CPV-2、CDV、FPV 各表均列）；MLV 在黑足鼬与灰狐高度毒力可致死；CDV 用金丝雀痘载体重组苗为安全有效选择；灭活苗可考虑用于野生/外来种与妊娠动物（部分情形从未做过安全/效力试验），但狂犬 MLV/重组载体苗在禽类与哺乳动物受试中无毒力、野生动物口服免疫广泛使用 |
| 妊娠 | MLV 核心苗除特别标示外不用于妊娠母犬；FPV MLV **绝不**用于妊娠母猫（可致胎儿损害）；某些国家有许可用于妊娠母猫的灭活 FPV 苗；原则上妊娠期间避免 MLV 与灭活产品，收容所疾病暴发且从未免疫时例外；应确保繁殖母犬已核心免疫，无需配妊前额外核心苗 |
| 幼龄下限 | 4–6 周龄以下幼犬幼猫不接种 MLV 核心苗；FPV MLV 绝不用于 <4–6 周龄幼猫（小脑发育中，恐致损伤）；<2 周龄且无 MDA 者接种可感染中枢神经系统、致病甚至死亡；抗 CIRDC 鼻内苗例外（3 周龄起） |
| 严重免疫抑制 | 不用于严重免疫抑制个体（如临床 FIV/FeLV 感染或强免疫抑制药物）；接受免疫抑制/细胞毒性治疗者不接种，尤其 MLV；环孢素高剂量治疗延迟 FHV-1、FeLV、狂犬应答并阻断 FIV 初免应答 |
| 逆转录病毒阳性猫 | 健康 FeLV/FIV 阳性猫如需核心苗应使用灭活苗，不接种 FeLV 或 FIV 疫苗；有临床疾病者不接种；部分国家狂犬法定接种仍适用 |
| 发病/发热/应激 | 不应给发病、体温过高或应激动物接种；已有上呼吸道症状的猫等康复后再接种 |
| 麻醉中动物 | 尽可能不在麻醉下接种（超敏+呕吐致吸入风险；麻醉剂可能免疫调节） |
| 疫苗之间 | 绝不在同一注射器混合不同制品（除资料表指定）；不同疫苗注入不同淋巴结引流的部位；不可先灭活后短时间内同病种 MLV；先 MLV 后灭活更合适；FCV/FHV-1 肠外 MLV 不可鼻内/口服，灭活苗不可局部用；鼻内博德特氏菌 MLV 不可肠外，肠外灭活博德特氏菌不可鼻内 |
| 毒株一致性 | 初级系列不混用含不同毒株的疫苗（FCV、钩体血清群）；不同供应商核心 MLV 可混用；FCV 幼猫系列建议同一毒株 |
| 操作与保存 | 注射部位不用酒精/消毒剂；2–3 天未适当冷藏的 MLV 不可用；复溶后 1–2 小时内用完；小型犬不减量、不分剂；大丹与吉娃娃同体积；猫必须皮下、不肌注、不肩胛间、部位轮换；优先无佐剂产品；疑似 FISS 病例应上报 |
| 特殊检测判读 | 有不良反应史者若为核心疫苗可测血清学，阳性即不再免；非核心疫苗不良反应后不建议再免；狂犬依当地法规（接种或滴度）；换产品可能有帮助但辅料（BSA）常跨产品共有；接种前抗组胺或抗炎剂量糖皮质激素可接受 |
| 无应答者 | 罗威纳、杜宾对 CDV/CPV-2 无应答风险更高；末免 16 周龄或以上、20 周龄血清学筛查；真正无应答者再免仍无应答；不应留作种用 |
| 法规旅行 | 狂犬再免间隔常由法定；国际旅行需接种后血清学达 ≥0.5 IU/ml，且接种与检测间隔关键；VGG 鼓励立法者依据科学进展调整政策 |', '', 'young', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'caution', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗接种指南 2015 版 下 · 术语对照（本稿用词与官方 2015 中文译本对照）', '7. 术语对照（本稿用词与官方 2015 中文译本对照）

> 官方中文译本仅用于术语对照，未作为内容来源；两列不一致时以英文原文为准，并在第三列记录译本用词。

| 英文（原文） | 本稿中文 | 官方 2015 中文译本用词 |
|---|---|---|
| Vaccination Guidelines Group (VGG) | 疫苗指导小组 | 免疫指导小组 |
| core / non-core / not recommended vaccines | 核心疫苗 / 非核心疫苗 / 不推荐疫苗 | 同 |
| modified live virus (MLV) vaccine | 弱毒活疫苗 | 弱毒活疫苗（MLV） |
| inactivated (killed) vaccine / bacterin | 灭活疫苗／菌苗 | 灭活疫苗／菌苗 |
| vectored recombinant vaccine | 载体重组疫苗 | 载体重组（rCDV）疫苗 |
| duration of immunity (DOI) | 保护期 | 保护期（DOI） |
| maternally derived antibody (MDA) | 母源抗体 | 母源抗体（MDA） |
| window of susceptibility | 免疫空窗期 | 免疫空窗期／空窗期 |
| cell-mediated immunity (CMI) | 细胞介导免疫 | 细胞介导免疫（CMI） |
| canine infectious respiratory disease complex (CIRDC) | 犬传染性呼吸道疾病综合征 | 犬传染性呼吸道疾病综合症／犬呼吸道疾病综合症 |
| infectious canine hepatitis (ICH) | 犬传染性肝炎 | 犬传染性肝炎（ICH） |
| feline panleukopenia virus | 猫细小病毒／猫泛白细胞减少症病毒 | 猫细小病毒（FPV） |
| feline rhinotracheitis virus | 猫鼻气管炎病毒 | 猫鼻支病毒 |
| virulent systemic feline calicivirus (VS-FCV) | 毒力全身性猫杯状病毒 | 译本作「全身致病性猫冠状病毒」——与英文 calicivirus 不符，本稿按英文用「杯状病毒」 |
| feline injection site sarcoma (FISS) | 猫注射部位肉瘤 | 猫注射部位肉瘤（FISS） |
| post-exposure prophylaxis (PEP) | 暴露后预防 | 暴露后预防法（PEP） |
| herd (population) immunity | 群体免疫（种群免疫） | 种群免疫力 |
| non-responder / low-responder | 无应答者／低应答者 | 无反应者／免疫应答不良者 |
| risk:benefit analysis | 风险:益处分析 | 风险益处分析／利弊分析 |
| off-label use | 超说明书使用 | 不按标签使用 |
| bovine serum albumin (BSA) | 牛血清白蛋白 | 犊牛血清蛋白（BSA） |
| Ehrlichia canis / monocytic ehrlichiosis | 犬埃立克体／单细胞埃立克体病 | 埃里克体属／单细胞埃里克体属感染 |
| shelter | 收容所 | 救助所／救助组织 |
| boarding cattery / kennel | 寄养猫舍／寄养犬舍 | 猫舍／犬舍 |
| excipient | 辅料 | 赋形剂 |', '', '', '', '疫苗,参考文献列表,FACT SHEET,CPV-2,CAV-2,犬传染性肝炎 ICH,时间表、剂量与阈值速查（照录）', 'informational', 'WSAVA 犬猫疫苗接种指南 2015 版 下（参考文献 + 附录一疫苗/疾病说明数据表 + 附录二常见问题 FAQ）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · > 本稿覆盖切片 001-010；011-019 见 05-。', '> 本稿覆盖切片 001-010；011-019 见 05-。

1. 文件目的、方法与适用范围

本文《Recommendations on vaccination for Latin American small animal practitioners》作者为 M. J. Day、C. Crawford、M. Marcondes、R. A. Squires。世界小动物医学协会（World Small Animal Veterinary Association, WSAVA）疫苗指南组（Vaccination Guidelines Group, VGG）2016–2019 年在拉丁美洲（Latin America, LATAM）开展区域项目，本文是其成果，建议多适用于全 LATAM。

方法：三次实地考察（阿根廷 2016、巴西 2017、墨西哥 2018，共七城），与关键意见领袖（key opinion leaders, KoLs）小组讨论、走访诊所、检索文献；在线问卷回收阿根廷 175、巴西 579、墨西哥 552、厄瓜多尔 51、哥斯达黎加 33 份（哥伦比亚、古巴、秘鲁、委内瑞拉等其余国家无回收）；继续教育（continuing education, CE）活动直接触达逾 3500 名从业者。

证据分级（沿用 2016 全球指南，逐条标注 [EB1]–[EB4]，每处仅给最严格级别）：

| 类别 | 定义 |
|---|---|
| Category 1 [EB1] | 同行评议的实验或 field 数据出版物支持 |
| Category 2 [EB2] | 作为已注册疫苗监管包提交但未公开的商业敏感研究支持 |
| Category 3 [EB3] | 未发表于同行评议、也未入监管包的实验/field 数据支持 |
| Category 4 [EB4] | 无数据，由微生物学/免疫学「第一性原理」或广泛专家意见推定 |

执行摘要列出十项 LATAM 挑战：缺国家监管、私立兽医学校爆发式增长、社会经济限制预防保健、某些传染病高流行（FeLV 感染、犬内脏型利什曼病）、缺最小抗原产品、缺延长免疫期（duration of immunity, DOI）产品、供应他市场已撤出或 LATAM 独有产品（贾第虫疫苗、某些利什曼疫苗）、宠主/繁育者可直接取苗脱离兽医监督、疫苗学 CE 有限且无强制执业发展、同行评议数据缺乏（利什曼病除外）。因产品受限，VGG 分「务实（pragmatic）」与「理想（aspirational）」两套建议；西/葡译本经 VGG 网页免费提供。', 'dog', '', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 拉美现状：宠物、职业与教育', '2. 拉美现状：宠物、职业与教育

2016 GfK Global 调查（22 国 27000 人）示 LATAM 宠物拥有率全球最高：阿根廷/墨西哥上网人群 80%、巴西 75% 有宠；养狗阿根廷 66%、墨西哥 64%、巴西 58%，养猫 32%、24%、28%。2014 年巴西估计 5220 万犬、2210 万猫，阿根廷 KoLs 估 1000 万犬、300 万猫；部分区域多为自由漫游（free-roaming）动物。兽医人数：阿根廷约 21000、巴西 130000、墨西哥 45000；兽医学校：阿根廷 21、墨西哥 45，巴西逾 400（63 所公立）。无国家课程、教学质量参差、CE 非强制；多数诊所得用即时血清学试剂盒但缺诊断实验室，RT-PCR 常过贵。', '', '', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('拉美地区犬猫疫苗建议-上 · 犬猫疫苗可预防传染病的流行病学（表 1、表 2）', '3. 犬猫疫苗可预防传染病的流行病学（表 1、表 2）

LATAM 逾 2000 万 km²、20 国、逾 6.5 亿人口，跨赤道含温/亚热/热带，疾病频率应因地而异。表 1、表 2 为兽医临床「是否认识」该病、未含诊断稳健性，准确性不确定。

**表 1. 五国报告的主要犬传染病病原（报告从业者 %）**

| 疾病/病原 | 阿根廷 | 巴西 | 墨西哥 | 厄瓜多尔 | 哥斯达黎加 |
|---|---|---|---|---|---|
| CDV | 89.1 | 91.7 | 94.4 | 96.1 | 87.9 |
| CAV | 29.1 | 16.8 | 35.1 | 39.2 | 18.2 |
| CPV2 | 89.7 | 87.6 | 92.2 | 94.1 | 93.9 |
| Leptospirosis | 62.3 | 68.3 | 63.3 | 49.0 | 51.5 |
| 犬传染病呼吸道疾病复合征 | 97.7 | 87.8 | 86.2 | 92.1 | 90.1 |
| Rabies | 5.7 | 8.9 | 11.6 | 5.9 | 9.1 |
| Canine visceral leishmaniosis | 11.4 | 58.2 | 9.5 | 3.9 | 3.0 |
| 受访者数 | 175 | 579 | 552 | 51 | 33 |

注：CDV = Canine distemper virus（犬瘟热病毒），CAV = Canine adenovirus-1 or -2（犬腺病毒 1/2 型），CPV2 = Canine parvovirus-2 variants（犬细小病毒 2 型变异）。

**表 2. 五国报告的主要猫传染病病原（报告从业者 %）**

| 疾病/病原 | 阿根廷 | 巴西 | 墨西哥 | 厄瓜多尔 | 哥斯达黎加 |
|---|---|---|---|---|---|
| FPV | 44.4 | 42.0 | 60.5 | 58.9 | 48.5 |
| FHV1 | 78.1 | 94.9 | 44.1 | 41.2 | 30.3 |
| FCV | 78.1 | 54.8 | 63.3 | 56.9 | 60.6 |
| Chlamydia felis | 42.0 | 49.5 | 25.2 | 17.6 | 21.2 |
| Feline leukaemia virus（FeLV） | 63.3 | 82.1 | 84.6 | 88.2 | 96.9 |
| Feline immunodeficiency virus（FIV） | 72.2 | 82.3 | 57.6 | 80.4 | 90.9 |
| Feline infectious peritonitis（FIP） | 62.1 | 67.6 | 56.7 | 47.1 | 75.6 |
| Rabies | 4.7 | 7.8 | 7.3 | 1.9 | 9.1 |
| 受访者数 | 175 | 579 | 552 | 51 | 33 |

注：FPV = Feline parvovirus（猫细小病毒），FHV1 = Feline herpesvirus-1（猫疱疹病毒 1 型），FCV = Feline calicivirus（猫杯状病毒）；多数地区含 LATAM 无 FIP 疫苗。', '', '', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 犬传染病文献要点', '4. 犬传染病文献要点

CDV/CPV2 虽可苗防仍是问题：接种率低、大量未接种自由漫游犬（Hartmann et al. 2007）[EB1]；部分国家不要求仅兽医接种，故无临床检查、可从农商购苗在家自注。

- **CDV**：meta 分析（Costa et al. 2019）[EB1]示文献主要来自巴西、阿根廷、智利；巴西流行率 <10% 至 41-50%、阿根廷 31-40% 至 >70%（分子诊断）。巴西南部未接种犬血清流行率 27.3%（223/817）（Dezengrini et al. 2007）[EB1]；阿根廷 73.8%（73/99）RT-PCR 阳性、多数接种过但未完成全程（Calderon et al. 2007）[EB1]。
- **CPV2**：巴西南部未接种犬暴露血清流行率 68.7%（561/817）[EB1]；巴西 104 腹泻犬粪便 PCR 阳性 34.6%（36/104）（Gizzi et al. 2014）[EB1]；拉美多国亦有报道。
- **CAV1**（犬传染性肝炎）：确诊个案稀少。巴西复核 5361 剖检犬（1964–2006）62（1.2%）例、随访 27 例免疫组化确认 CAV1（Inkelmann et al. 2007/2008）[EB1]；同州 1996–2009 复核 6993 犬 23 例（0.34%）确诊（Oliveira et al. 2011）[EB1]。
- **CIRDC**（canine infectious respiratory disease complex；「kennel cough」犬窝咳）：巴西三收容所鼻拭 PCR——CAV2 单一感染 5.4%、7.8%，犬副流感病毒（canine parainfluenza virus, CPiV；型 5）29.7%、8.6%（Monteiro et al. 2016）[EB1]；墨西哥肺样免疫组化 CAV2 57.1%、CPiV 51.4%；支气管败血波氏杆菌（Bordetella bronchiseptica）墨西哥鼻拭分离 8.5%。
- **Leptospirosis（钩端螺旋体病）**：血清流行率高、分离少。显微镜凝集试验（microscopic agglutination test, MAT）首选但确认血清型差；须间隔 1 至 2 周双份血清、滴度 4 倍变化方支持近期感染，单次滴度 ≥800 仅提示不能确诊。主要病原 Leptospira interrogans、L. kirschneri，巴西另分离 L. noguchii、L. santarosai；巴西最常分离血清型 Canicola 与 Copenhageni、另报告 Pomona [EB1]。
- **Rabies（狂犬病）**：过去 20 年经群体接种病例降近 90%（Schneider et al. 2011）[EB1]；哥斯达黎加、法属圭亚那、圭亚那、巴拿马、苏里南、乌拉圭已无犬狂犬病；泛美卫生组织（PAHO）2010–2012 玻利维亚、海地占西半球犬传人病例 15%（6/40）、40%（16/40）[EB1]。
- **犬内脏型利什曼病（canine visceral leishmaniosis, CVL）**：由 Leishmania infantum 所致、墨西哥至阿根廷广泛流行，感染犬以百万计。巴西流行区血清流行率 3.1–36.0%；巴拉圭 2005–2016 升 23–32%、亚松森 2010 流浪犬达 69%；阿根廷 2006 首报 57.3%；乌拉圭萨尔托 22%；墨西哥 1.7–15.7%、委内瑞拉 5.6–40.0%、哥伦比亚 1.6–36.0%。', 'dog', '', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 猫传染病文献要点', '5. 猫传染病文献要点

- **FPV**：巴西南部 69.1%（67/97）猫血清阳性（接种 100%、未接种 66.6%、史不明 62.8%）（Johann et al. 2009）[EB1]；1996–2012 一教学医院 1850 猫剖检 33（1.78%）确诊（Castro et al. 2014）[EB1]。
- **猫上呼吸道感染**：巴西 302 猫 PCR 分离 FHV1 11.2%（34/302）、FCV 8.6%（26/302）（Henzel et al. 2012）[EB1]；108 只未接种幼猫 FHV1 57.4%、FCV 37.0%、C. felis 24.1%（Baumworcel et al. 2017）[EB1]。
- **猫逆转录病毒**：FeLV 研究多来自巴西、地区差异大（0.33% 至 47.5%，方法含 ELISA、IFAT、免疫层析、PCR；一研究 78.4%（29/37）白血病与 FeLV 相关），FIV 低于 FeLV（3.33% 至 14.7%）。阿根廷 FIV 21.45%/20.34%、FeLV 7.64%/11.82%（Novo et al. 2016）；智利一岛 FeLV 33%（26/78）；哥伦比亚 FIV 10.7%（184/1718）；危地马拉 FeLV 16.7%（5/30）；墨西哥、哥斯达黎加、委内瑞拉、乌拉圭等亦有报道 [EB1]。
- **猫狂犬病**：2005–2015 有 15 个 LATAM 国家报道犬猫狂犬病（Velasco-Villa et al. 2017）[EB1]。', '', 'young', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 拉美疫苗与疫苗实践现状', '6. 拉美疫苗与疫苗实践现状

接种不足：阿根廷 KoLs 估仅 20–35% 有主宠物接种；巴西 17% 犬、6–9% 猫年度就诊含接种。疫苗两来源——大型全球厂商「国际/质量保证疫苗（international/quality assured vaccines）」有北美/欧许可档案；少数国内厂商产品 VGG 无法评估（除巴西利什曼疫苗外，本文建议仅针对国际质量保证产品）。与美/欧相比 LATAM 产品更少、有独有产品（仅存 LATAM 的贾第虫疫苗）、倾向大型多抗原组合、同品 DOI 更短。核心难点——无三组分核心苗（犬 CDV/CAV/CPV2、猫 FPV/FHV1/FCV），核心抗原常与非核心/不推荐抗原合于大组合、注册 1 年 DOI（他市场同品 3 年）；狂犬苗法律强制年度、国际灭活苗 LATAM 多注册 1 年 DOI。诊所收入依赖疫苗销售（挂牌定价），形成「越多越好（more is better）」文化、组合可多至 10 种抗原、几乎全年度接种；「年度健康检查（annual health check）」与「保健计划（health care plan）」为新概念。接种不限于诊所（宠物店可先接种、宠主可自取苗）。FIAVAC 下 COLAVAC 已发布巴西/阿根廷/墨西哥（期刊另有秘鲁）指南，VGG 指出同苗各国建议不一、并强调专家组须独立于产业、经同行评议后刊于 Journal of Small Animal Practice。

**表 3. 疫苗保管（Vaccine husbandry）要点**（照抄原文列表）
- 存放于仅用于药品与疫苗的专用冰箱（不放食物饮料）
- 供电以无开关插座或标「do not switch off」插头保护，防误断电
- 最佳温度通常 2–8°C（家用冰箱保持 4°C）；勿冷冻、勿紧邻冷冻室；以最高最低温度计定期监测、理想每日记日志
- 留空气流通空间以维持恒温；在制造商包装内存放
- 指定货架并列清单于箱外，减少开门时间
- 维持正确库存勿超储；库存轮换、新库存置后
- field 运输延续「冷链（cold chain）」、用冷藏箱、勿与冰块/冰袋直接接触
- 冻干苗临用前以适当稀释剂或同予液体苗复溶；清晨配当日量属禁忌，某些组分（CDV、FHV-1）尤不稳定
- 仅当数据表注明可接受时才于同一注射器混合
- 注射器与针头不得复用；注射部位勿以酒精/消毒剂消毒（会灭活 MLV）
- 疫苗须在有效期内，把批号、组分、注射部位记入病历', '', '', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'caution', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · VGG 建议：教育、研究与疫苗供应', '7. VGG 建议：教育、研究与疫苗供应

教育：强调扎实免疫学与微生物学教学（尤其伴侣动物传染病与疫苗学）及临床年段的 client communication 与诊室接种；教学者应熟悉 WSAVA 指南；CE 需求巨大、协会与产业应负责、webinar 日普及；应讨论将强制执业发展纳入再注册。研究：LATAM 信息严重缺乏，因私立重教学、非人畜共患病难获资、声誉偏向生产动物、缺监测实验室基础设施，巴西高教/科研经费被削减令人担忧；VGG 支持厘清区域流行率与 field 病原分类（如钩体血清型）。疫苗供应：须从大组合（至 10 抗原）转向「三价/二价核心 + 单价/二价非核心」（目前仅阿根廷较可得），并从「疫苗驱动营收」转向年检/保健计划；产业应先引入新产品、VGG 支持接受他市场许可研究以免重复试验。', '', '', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 核心/非核心定义与犬疫苗理想方案（表 4）', '8. 核心/非核心定义与犬疫苗理想方案（表 4）

核心疫苗（core vaccines）指每只犬无论地域/生活方式都须接种者，含 CDV、CAV2、CPV2（宜为改良活病毒 modified live vaccine, MLV）；犬狂犬病流行国灭活狂犬苗亦为核心。非核心疫苗（non-core vaccines）针对有暴露风险的个体、无疾病证据处不用，含 Leptospira 与 CIRDC（通常 B. bronchiseptica ± CPiV）。不推荐用于任何犬：犬肠道（非泛嗜性）冠状病毒（enteric CCoV）灭活苗与贾第虫苗（理由见 FAQ）。

**表 4. 面向 LATAM 的理想（aspirational）疫苗程序**

| 疫苗类型 | 幼犬/幼猫接种 | 成体加强 |
|---|---|---|
| 质量保证核心 MLV（犬 CDV/CAV/CPV2；猫 FPV/FCV/FHV1） | 6–8 周龄起、每 2–4 周一次直至 16 周龄或更大 [EB1]；MLV 核心可更早但不早于 4 周龄；幼犬若可得高滴度 CDV+CPV2 可 4–6 周龄用、后换三价核心苗 8 周龄或更大 [EB1]；第 4 剂于 6–12 月龄、或第 3 剂后 12 个月、或 12 月龄给予 [EB4] | 核心 MLV 加强不应频繁于每 3 年一次 [EB1]；血清学可监测保护（CDV、CAV、CPV2、FPV）并辅助定间隔 [EB1]；唯一例外为上呼吸道病毒高风险猫、相应组分可每年 [EB1] |
| 质量保证犬狂犬病苗（有主宠物，非群体接种） | 按制造商建议；12 周龄起单剂 [EB1]；高风险区（非 LATAM 多数地区）2–4 周后追加第二剂、非高风险区第二剂 12 个月后或 12 月龄 | 质量保证犬狂犬苗在 LATAM 以外许多国家带 3 年注册 DOI [EB1] |
| 非核心（犬 Leptospira、CIRDC「kennel cough」、Leishmania；猫 FeLV 或 C. felis；猫用 FIV 与 Bordetella LATAM 无供应） | 一般两剂间隔 2–4 周；注射非核心与口服 CIRDC 苗一般 8 周龄起；鼻内 CIRDC 可更早（按制造商建议）[EB1] | 一般每年，除非数据表另荐；FeLV 苗可每 2 年给成猫（某些质量保证 FeLV 苗 LATAM 外带 2 或 3 年 DOI）[EB1] |
| 不推荐 | — | 冠状病毒（犬/猫）、贾第虫、Microsporum canis 疫苗 |

表注：应与现行 WSAVA 指南（Day et al. 2016）一并阅读；仅当产品将核心与非核心分开时方可按 WSAVA 接种；仅适用大型国际公司生产的质量保证疫苗。

WSAVA 建议幼犬在国际 MLV 核心苗出生后前 4 个月内定时间隔加强以克服母源抗体（maternally-derived antibody, MDA）干扰 [EB1]，末剂 6 月至 1 岁给予以确保至少一剂在无 MDA 下赋免 [EB4]（保护取决于给予时间而非剂数）；成体每 3 年加强有充分证据 [EB1]。LATAM 要求年度者不当使用客户资金；增加频率不增个体保护，正确接种更多动物（群体免疫 herd immunity）远更重要。VGG 鼓励监管者允许「标签外（off-label）」使用并知情同意。', '', 'young', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 犬疫苗务实方案（表 5）、利什曼与狂犬', '9. 犬疫苗务实方案（表 5）、利什曼与狂犬

因产品可得性、注册 DOI 与流行率认知受限，LATAM 应游说得仅含 MLV 核心（CDV、CPV2、CAV2）或非核心（Leptospira、CPiV、Bordetella）的国际苗；现有多为 MLV 核心 + 非核心 Leptospira + 不推荐 enteric CCoV 合苗。仅负担一苗者应选含 MLV 核心组分产品、于无母源干扰时可赋长效保护之点（4 月龄或更大）给予。

**表 5. 面向 LATAM 从业者 2019 年的务实（pragmatic）疫苗程序**

| 疫苗类型 | 目标 | 幼犬/幼猫接种 | 成体加强 |
|---|---|---|---|
| 犬猫核心 | 选允许最小核心抗原组合（犬 CDV/CAV/CPV2；猫 FPV/FHV1/FCV）的质量保证 MLV；若某非核心苗对该动物非必需，改用替代稀释剂而非以该非核心苗复溶 | 同表 4 幼期方案 [EB1][EB4] | 与客户讨论新全球核心加强法、取得同意以不超每 3 年一次给核心 MLV [EB1]；唯一例外为上呼吸道病毒极高风险猫可每年，但该组合 FPV 组分实非必需 [EB1] |
| 质量保证犬狂犬苗（有主宠物） | 若可得选国际质量保证产品 | 同表 4 幼期方案 [EB1] | 遵从当地年度法规，但继续游说协会/政府允许带 3 年注册 DOI 产品三年一次，并游说产业在本国登记 3 年 DOI |
| 非核心（同表 4 举例） | 与客户讨论个体生活方式/暴露风险——该苗是否确有必要？选仅含所需抗原、或在与其他非必要组分组合中含该抗原的质量保证产品 | 同表 4 幼期方案 [EB1] | 一般每年除非数据表另荐；FeLV 苗无须每年给成猫（见表 4） |
| 不推荐 | 考虑是否有足够科学证据 | — | 冠状病毒（犬/猫）、贾第虫、Microsporum canis 苗 |

9.1 犬利什曼病（CVL）

LATAM 最重要人畜共患病之一、分布扩大；因部分接种犬仍可进行性感染经白蛉传播，流行区用杀虫剂尤其项圈防白蛉叮咬比接种更重要（两者宜结合），既往接种史不能排除 CVL。LATAM 仅两支注册苗：一支含 L. donovani 重组 A2 蛋白加佐剂（巴西、巴拉圭），另一支为 L. infantum 纯化排泄–分泌蛋白（LiESP）加佐剂（巴拉圭、阿根廷）。方案为三剂、间隔 3 周、之后每年加强；A2 从 4 月龄起、LiESP 从 6 月龄起；从未接种成犬同一方案。仅给流行区有风险犬、按制造商建议只接血清阴性犬。', '', 'young', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 犬狂犬病', '9.2 犬狂犬病

群体接种多年控制多数国家犬（及人）狂犬病但仍有「热点」，多数国家持续监测并法律强制年度接种。针对自由漫游流浪/社区犬的群体接种运动，年度加强因群体更替必不可少；对有主就诊个体宠物，国际苗应赋至少 3 年 DOI。

10. 猫疫苗：理想与务实方案

10.1 理想方案

所有国家 FPV、FHV1、FCV 为核心、狂犬流行国狂犬苗亦核心；非核心按风险–效益、当地频率与生活方式使用（FeLV 某些区域常见他处罕见；C. felis 等致病性低或可抗生素治）；FIP 苗归「不推荐」。巴西东南部/深南 FeLV 高、北部低，应先确立本地流行率。高质量 MLV FPV 苗长效、每 3 年加强，更频繁不增保护反增不良反应；FCV/FHV1 MLV 保护不如 FPV、不能防感染或携带，低风险（纯室内不进寄养）猫每 3 年足、户外/寄养暴露猫每年；某些国家可仅购 FCV+FHV1 二价以便三价每 3 年、二价间隔年用（尚未全球一致可得）。幼猫系列不早于 16 周龄完成，因相当比例幼猫到高达 20 周龄仍有显著 MDA 干扰；部分国际猫用狂犬苗可保护至少 3 年。

10.2 务实方案

LATAM 目前无法全盘采纳，因非核心理性使用受疾病频率信息缺乏阻碍（缺证据时预防性过度使用）、核心苗少有批准两年/三年或更低频率者、单价非核心苗匮乏（C. felis 常仅与核心 FPV/FHV1/FCV 合、FeLV 仅与前四者合，故有三/四/五组分猫苗却无单价非核心品，想防 FeLV 无须防 C. felis 者被迫接多余组分）。若法规允许，知情同意下「标签外」使用有帮助；VGG 希望核心 MLV 数据表最终在 LATAM 更新。

11. 预防保健计划与年检在拉美应用

LATAM 以「卖苗驱动就诊、支撑收入」为主导文化（约 25 年前成熟市场亦如此，现已更新）：从「年度疫苗加强就诊」转向以年检交付的整体预防保健包、并延伸为按月付费的保健计划。年检时间更长，可讨论营养、牙科、行为、体内外寄生虫、媒介病检测及本次应交付的核心/非核心苗；许多成熟市场以诊室血清学「滴度检测」判核心（犬 CDV/CAV/CPV2、猫 FPV）是否已受保护、无须再接种——WSAVA 有力支持。

致谢与利益冲突：VGG 感谢三国 KoLs、受访诊所与问卷填写者；物流与 CE 由 MSD Animal Health 承担。VGG 工作获其财务支持，但为完全独立学术专家组，撰写未与产业协商、赞助方代表不出席会议、对建议无否决权。', '', 'young', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'informational', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议-上 · 常见问题精选（切片 001-010）', '12. 常见问题精选（切片 001-010）

- **肠道犬冠状病毒苗**：证据不足，CCoV 作为成犬原发致肠病原证据弱（共感染 CPV2 才重），仅接 CPV2 即可防两病毒攻毒，注射苗不诱保护性粪便 IgA；巴西两组粪便检出无差异。
- **贾第虫苗**：防排毒/防感染证据弱；一 6000 犬 field 研究接种幼犬反更易腹泻、包囊/抗原检出无差异；病不致命、极少人畜共患、流行率低、可治；已撤出全球市场仅 LATAM 除外。
- **鼻内/口服 vs 注射 CIRDC 苗**：黏膜接种更可能诱导黏膜 IgA/IgG [EB1]；鼻内苗最早 3 周龄单剂、每年加强，有 Bb、Bb+CPiV、Bb+CPiV+CAV2（视市场、非全在 LATAM）；口服抗 Bb 苗见于澳/北美/欧、仅单一抗原、8 周龄起、每年加强、LATAM 无供应。
- **Borrelia（伯氏疏螺旋体）苗**：需先研究病原/蜱媒/野生动物保主是否存在；巴西有袋症样病（Baggio–Yoshinari 综合征）人感染报道，但伴侣动物病原据作者所知未自病犬分离，暂无引进依据。〔原文此处断裂：Gonçalves et al. 引文年份残缺〕
- **核心苗突破母源免疫 / 注册每年苗如何每 3 年给**：高滴度国际苗更可能早突破，早于 8 周开始可用高滴度 CDV+CPV2 组合，但不保证每幼犬早期应答，应遵末剂 16 周龄或更大、6–12 月龄追加。对注册 1 年 DOI 的核心苗，过去全球兽医以知情同意「标签外」使用解决、从无成功起诉或延长间隔致感染案例。
- **现行 CPV 苗能否防所有循环型**：CPV2（1978 首认）演化出 CPV2a/2b/2c（VP2 氨基酸变化），多数苗含 CPV2 或 CPV2b；研究显示交叉保护、现行苗 field 仍有效；偶发接种犬发病多因未按指南接、或已潜伏强毒者接种。
- **钩体血清型 / 是否应为核心**：证据最少、金标准（间隔 2 周双份血清 MAT + 分离）常被忽视；field 主导血清型或仍为 L. interrogans 的 Canicola 与 Copenhageni，含两者的传统「L2」苗或足够（北美/欧有 L3/L4，目前不足以荐用）。VGG 不能列钩体苗为全球核心，主张按区域监测与生活方式用非核心：户外尤其接触经啮齿/家畜污染水源、可被野生动物入内的院养犬应接种。
- **LATAM FeLV 偏高可学什么**：30–40 年前欧洲 FeLV 远高于今日、归因检测 + 感染猫管理 + 广泛接种；首步确定本地流行率，多中心/颅纵隔淋巴瘤与重度非再生性贫血高发提示流行；首免前理想先检测，是否用非核心 FeLV 苗取决于风险–效益。
- **猫核心选 MLV 还是灭活**：孕猫/免疫抑制猫若必须接种，第一性原理灭活更安全（证据有限）；佐剂（灭活/亚单位苗有、MLV 一般无）被认为与猫注射部位肉瘤（feline injection site sarcoma, FISS）相关、是灭活苗缺点；狂犬流行国猫接种时除重组产品外灭活佐剂苗是唯一选择。〔「是否推荐重组疫苗」问在切片 010 结尾，答案见 05-〕', '', 'young', '', '疫苗,WSAVA VGG,核心疫苗,非核心疫苗,CDV,CPV2,文件目的、方法与适用范围,拉美现状：宠物、职业与教育', 'caution', '拉美地区犬猫疫苗建议-上', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 第 1 段', '> 来源说明：本稿整理自 WSAVA 疫苗接种指南组（Vaccination Guidelines Group, VGG）《Recommendations on vaccination for Latin American small animal practitioners》（拉美地区小动物执业者疫苗建议，英文，全文共 19 个抽取分块）的分块 011–019。该文件是 WSAVA 疫苗板块下的**区域性补充文件**，针对拉美（LATAM, Latin America）执业兽医师编写，非 WSAVA《犬猫疫苗接种全球指南》正文；全球核心/非核心疫苗分类等正文内容见分块 001–010 整理稿《04-拉美地区犬猫疫苗建议-上.md》。本稿覆盖分块 011–019 的实际内容：**执业常见问题解答（FAQ）后半部分**（疫苗产品与品牌、接种时机与递送、母源抗体与品种、特殊临床情形、钩端螺旋体病疫苗、成犬成猫免疫程序、猫白血病病毒疫苗、妊娠/注射技术/冷链/驱虫、兽医职业防护、不良事件与血清学检测）、**参考文献全列表**（015 末–018），以及**附录：WSAVA 2016–2019 拉美问卷调查表**（019）。文内出现的「Question 15/18/25/34/39/43/62/67/68」「Table 3」等交叉引用指向前半部分（分块 001–010），「see main text of this document」指正文主体（亦在前半部分）。原文证据等级标注〔EB1〕〔EB2〕〔EB4〕照录〔原文如此〕。

拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'caution', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 分块 011–019 内容与结构总览', '1. 分块 011–019 内容与结构总览

| 分块 | 内容 |
|---|---|
| 011 | FAQ：疫苗产品与品牌问题收尾（重组病毒载体疫苗、狂犬病 3 年免疫间隔、体重与抗原量、治疗性疫苗、犬小孢子菌疫苗）；「疫苗递送问题」开始（4 周龄幼犬核心免疫、初乳缺乏幼仔、核心疫苗剂次、血清学测定接种时机） |
| 012 | FAQ 续：血清学测试-kit 不能定幼犬接种时间但可定 26–52 周龄剂次；母源抗体（maternally-derived antibody, MDA）与品种；同窝差异；年度 vs 三年加强母犬的 MDA；社交化与易感窗口；外出遛狗时机；绝育时接种；收容所幼犬程序；鼻喷接种后喷嚏；同日多联接种；免疫抑制病（犬瘟热、埃希希体病）后接种；犬瘟热康复后接种是否会诱发神经症状（提问） |
| 013 | FAQ 续：上述神经症状问题的答复；流浪犬入场与幼犬暴露处置；细小/犬瘟康复犬是否还需接种；糖皮质激素治疗后接种间隔；化疗期间与化疗后接种；手术后接种；老龄犬免疫；罗威纳犬剂次；品种特异免疫程序；钩端螺旋体病（Leptospirosis）漏针补免、抗体判读、高风险犬加强频率；多联疫苗 vs 小组合/单价分开注射（提问） |
| 014 | FAQ 续：小抗原组合疫苗优选与拉美可及性挑战；无免疫史成年犬猫剂次；拉美低风险免疫间隔担忧（群体免疫优先）；Giardia 疫苗与寄养机构规定；FeLV 相关四问（成年猫再免疫频率、FeLV 阳性猫、纯室内猫、FeLV 阳性家庭新幼猫）；妊娠动物接种；注射前酒精擦拭；冷藏疫苗回温；冷链中断；接种前驱虫（提问续 015） |
| 015 | FAQ 续：驱虫与免疫应答；兽医自身狂犬病等职业免疫；不良事件问题集（疫苗犹豫、不良事件发生率与类型、过敏后再接种、糖皮质激素预处理、免疫介导病康复后再免疫、佐剂与猫注射部位肉瘤、FISS 注射部位、血清学检测替代成体核心再免疫、猫抗体检测试剂盒）；参考文献开始 |
| 016–018 | 参考文献列表（A–Z），大量拉美地区流行病学与诊断文献（犬瘟热/犬细小病毒、FeLV/FIV、利什曼病、钩端螺旋体血清型、伯氏疏螺旋体/蜱传病、狂犬病等，见本稿第 12 节归类摘要） |
| 019 | 附录：WSAVA VGG 拉美项目（2016 to 2019）问卷全文（个人/诊所/犬传染病/猫传染病/诊所现有疫苗/犬猫免疫习惯六个部分）；尾注「These WSAVA vaccination guidelines have been published as submitted to JSAP and have been through an abridged peer-review process.」 |

**关于地区性疫病的说明**：分块 011–019 正文 FAQ 涉及的地区性疫病话题为：钩端螺旋体病（补免与抗体判读）、利什曼病（仅经由引用文献与问卷选项出现，正文论述在分块 001–010）、狂犬病（拉美年度加强法定要求）、犬瘟热/犬细小病毒（拉美母犬免疫史不佳背景下的早期免疫）。**分块 011–019 中未出现黄热病（yellow fever）相关内容**；内脏利什曼病、犬利什曼病与钩端螺旋体血清型（Leptospira serovars）在本部分仅见于参考文献题名（见第 12 节）与附录问卷选项（visceral leishmaniosis vaccine 等，见第 13 节），照录如下，不作补充。', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'caution', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 疫苗产品与品牌相关问题（FAQ，续分块 010）', '2. 疫苗产品与品牌相关问题（FAQ，续分块 010）

2.1 商业品牌与重组病毒载体疫苗

- VGG 不就特定商业疫苗品牌、也不就疫苗大类作推荐。世界部分地区有重组病毒载体疫苗（recombinant virus-vectored vaccines）可防犬瘟热病毒（canine distemper virus, CDV）、猫白血病病毒（feline leukaemia virus, FeLV）与狂犬病，某些情形下有优势：用于野生动植物种、以及避免在猫使用佐剂狂犬病疫苗——后者是被关联到猫注射部位肉瘤（feline injection site sarcoma, FISS）的众多可注射制品（疫苗及非疫苗注射物）之一（见 Questions 15、67 和 68）。
- **「据我们所知，此类单价制品（monovalent products）在拉美不可获得。」**（原文：To our knowledge, such monovalent products are not available in LATAM.）

2.2 哪些国家规定狂犬病疫苗每 3 年接种一次？有科学依据吗？

| 要点 | 原文照录内容 |
|---|---|
| 北美/欧洲 | 个体宠物犬猫在兽医处常规每 3 年接种狂犬病疫苗；当地法定要求为成年犬猫三年加强；所用国际质量保证（qualityassured〔原文如此，应为 quality-assured〕）狂犬病疫苗均带 3 年免疫持续时间（duration of immunity, DOI）注册；许可基于坚实科学证据与注册研究（如 Lakshmanan et al. 2006）〔EB1〕；无此证据法律不会改为允许 3 年加强 |
| 亚洲、非洲与拉美 | **相同狂犬病疫苗制品被按年度接种**，原因是地区或国家法律未修改、行业未按北美/欧洲方式以 3 年 DOI 重新注册产品。**在拉美，法律上仍须每年接种狂犬病疫苗**；但兽医行业应游说修改法律并重新注册产品。此规定仅适用于到兽医处接种疫苗的个体宠物 |
| 大规模 field 免疫运动 | 在政府或非政府组织实施的大规模现场免疫运动中，狂犬病疫苗仍每年接种尽可能多的犬（含自由漫游犬 free-roaming dogs），因自由漫游犬群体更替率高，需年度再免疫以维持 **70%** 的群体免疫（herd immunity）水平〔EB1〕 |', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 体重与疫苗抗原量：小犬应少打吗？', '2.3 体重与疫苗抗原量：小犬应少打吗？

- 疫苗不同于药物，**不按 mg/kg 给药**。疫苗含定量抗原，即刺激初发或继发免疫应答所需的量。每个个体有由 T 细胞受体与 B 细胞受体（TCRs 和 BCRs）界定的抗原特异性 T/B 淋巴细胞「免疫库（immunological repertoire）」。
- Burnett「克隆选择学说（clonal selection theory）」提出每个 T/B 细胞携带唯一受体特异性，现已知单一受体可识别多个抗原表位（TCR「degeneracy〔原文如此〕」与 BCR 交叉反应）。疫苗只需含有能被加工提呈给 TCR 或被 BCR 构象识别的抗原表位，激活相应淋巴细胞产生主动免疫与免疫记忆。**因此靶动物大小无关紧要**，疫苗配方含足量抗原即可。
- 有证据显示低体重犬对某些抗原产生更高血清学应答（Kennedy et al. 2007），且接种后不良事件发生率高于大犬（Moore et al. 2005）〔EB1〕；但目前没有任何疫苗按体重配方的提议。北美有部分疫苗为 0.5 mL 而非 1.0 mL 装，但抗原含量相似。
- **绝不可将一剂疫苗分给多头动物，或给予不足全剂量的疫苗**。此为「off label」使用，若该动物随后在免疫后发生感染，接种者须担责。

2.4 治疗性疫苗（如犬黑色素瘤疫苗）

- 21 世纪的疫苗接种已不仅是防感染病：治疗性「疫苗」用于刺激或调节肿瘤（如犬黑色素瘤疫苗 canine melanoma vaccine）或过敏（特应性皮炎用过敏原特异性免疫疗法）的免疫应答；人类医学正活跃研究自身免疫病治疗性疫苗。**VGG 不考虑这些替代用途**，一般属兽医专科范畴；VGG 的关注点始终是全球可用于犬猫感染病预防、在第一线执业中广泛使用的产品。

2.5 犬小孢子菌（Microsporum canis）疫苗

- 拉美部分地区现用于犬猫防皮肤真菌病。VGG **不推荐**用疫苗预防犬猫皮肤真菌病（dermatophytosis），因发表的效果研究极少。
- 虽有反刍牛与毛皮动物抗皮肤真菌疫苗成功的报告，猫的反应似乎不同——这些疫苗不能抵抗攻击感染（challenge infection）（Deboer & Moriello 1994, Deboer et al. 2002, Frymus et al. 2013）〔EB1〕。
- 美国曾注册一种由 killed M. canis 组成的商品疫苗用于治疗猫；但该疫苗并未使已建立感染的猫比未接种对照更快治愈，该产品已撤市（Frymus et al. 2013）〔EB1〕。

3. 疫苗递送与幼龄免疫程序问题（FAQ）', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'caution', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 周龄能否给将满 6 周出售的幼犬接种核心疫苗？', '3.1 4 周龄能否给将满 6 周出售的幼犬接种核心疫苗？

| 要点 | 原文照录数值/表述 |
|---|---|
| 福利前提 | 6 周龄对幼犬断奶、离开母犬和出售来说实在太小。欧洲现已**禁止出售不满 8 周龄的幼犬**；拉美兽医行业应认领这一福利议题、教育繁育者合理断奶时机。把 4–6 周龄幼犬聚集到周末「幼犬市场（puppy markets）」在传染病传播上是「灾难配方（recipe for disaster）」，也属福利问题 |
| 免疫学考虑 | 若母犬免疫良好，其血清针对核心抗原（CDV、CAV〔犬腺病毒 canines adenovirus，原文缩写〕、CPV2〔犬细小病毒 2 canine parvovirus 2〕）抗体浓度高，经初乳传给幼犬；此时 4 周或 6 周龄幼犬很难应答核心免疫，但使用为幼龄幼犬设计的高滴度 CDV+CPV2 组合疫苗可改善应答机会 |
| 拉美现实 | 拉美母犬很可能免疫不佳，因此**尽早为幼犬提供保护是正确的**；最恰当方式是用含 CDV 和 CPV、为幼龄幼犬设计的疫苗。**此类制品可从 4 周龄起接种；但 MLV（改良活疫苗 modified live vaccine）绝不可早于 4 周龄给予**，否则可能令新生动物发生感染与畸形 |
| 后续程序 | 6 周龄后每 2–4 周接种一次（8 周龄时换为 CDV、CAV、CPV2 三联苗）。**最重要的核心疫苗剂次是 16 周龄或以后那一剂**（彼时所有幼犬应已丧失 MDA、能应答疫苗）；随后应在 **26–52 周龄间给予第四剂核心免疫（以靠近该区间低端为宜）** |

3.2 已知未摄入初乳的幼犬幼猫何时可免疫？

- 绝对确定一窝幼仔（或其中个别）未获初乳很困难。若怀疑，首要建议是实施优秀饲养管理：尽量提供清洁、隔离环境；可考虑在生命最初 24 小时内使用由合格免疫成年动物血清或血浆配成的乳替代粉配制的「人工初乳（artificial colostrum）」。
- 实验证明缺失初乳动物能在生命极早期对核心疫苗产生免疫应答（Chappuis 1998）〔EB1〕；**但 MLV 疫苗绝不可早于 4 周龄使用**（可致新生动物感染或发育缺陷）。该情形下核心免疫可自 4 周龄开始。
- 理论上无 MDA 抑制的个体对单剂犬核心疫苗或单剂 FPV〔猫细小病毒 feline panleukopenia virus〕疫苗应有应答，但仍务实遵循 WSAVA 幼犬/幼猫推荐程序为宜。即使缺失初乳的幼猫，**也至少推荐两剂 FHV1（猫疱疹病毒 1）和 FCV（猫杯状病毒）疫苗**。4 周龄时推荐使用为幼龄幼犬设计的核心 CDV 和 CPV2 疫苗。', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 幼犬应接种几剂核心疫苗？', '3.3 幼犬应接种几剂核心疫苗？

- 取决于首次接种时年龄。理想上首剂在幼犬仍与母犬一起时由繁育者安排。例如在欧洲（8 周龄后才能售、母犬多免疫良好），繁育者可安排 8–9 周龄核心免疫，后续责任移交新主人。
- 在拉美（幼犬取得年龄可能更早），核心免疫可早至 **4–6 周龄**开始（见上）。据 WSAVA 指南，幼犬可每 2–4 周接核心疫苗，**早期生命最后一剂应在 16 周龄或以后**给予；故实际剂次取决于起始年龄与给药频率。
- 北美/欧洲「标准」程序可为 **8、12、16 周龄各一剂核心疫苗，26 周龄第四剂**；拉美可因核心免疫起始更早而调整该程序。

3.4 能否用血清学检测决定幼犬接种时机（代替多剂接种）？

- 市售临床血清学检测试剂盒可检出 CDV、CAV、CPV2 血清抗体，但其设计用途是**为成犬再免疫决策提供信息，而非测定幼犬最佳接种时间**。对极幼龄犬反复采血不现实且有福利问题；更重要的是，**16 周龄以前无法区分 MDA 与幼犬自身免疫系统受疫苗刺激产生的抗体**。
- **结论：「no」——不能用于测定幼犬最佳接种时间。**（见 5.4 节：但可用于判定 26–52 周龄那剂是否需要。）

4. 母源抗体与品种相关问题（FAQ）

4.1 血清学 kit 与 26–52 周龄剂次

- 若幼犬在 **20 周龄**检测（即 16 周龄或以后的末剂核心免疫后 4 周）并对 CDV、CAV 和 CPV2 血清阳性，则那些抗体必反映幼犬自身免疫应答、表明已诱导免疫保护；此时**该幼犬无需在 26–52 周龄再接种**，可直接进入成体再免疫程序。', 'dog', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 品种与 MDA 传递', '4.2 品种与 MDA 传递

| 要点 | 原文照录 |
|---|---|
| 传递量 | 无证据表明 MDA 传递与品种或体型相关。传递取决于饲养管理因素，如母犬为「好母亲」、能在生命最初 **24 小时**关键窗口内哺乳所有幼犬（有研究提示肠道对 MDA 的「闭合（gut closure）」可能更早发生） |
| 水平变异 | MDA 水平因母犬免疫状况而异；同一母犬对三种主要疫苗抗原（CDV、CAV 和 CPV2）的 MDA 浓度也可能不同 |
| 低应答品种 | 某些品种（如罗威纳 rottweilers、杜宾 dobermanns）可能更常含针对个别疫苗抗原的遗传性「低应答者（low responders）」或「无应答者（non-responders）」（Day et al. 2016）。北美/欧洲公认个别罗威纳更易感 CPV2 感染（Houston et al. 1996），提示疫苗免疫应答不足；但一项研究中该品种犬应答充分（Coyne 2000）。罗威纳对狂犬病疫苗的血清学应答也较低（Kennedy et al. 2007）〔EB1〕 |
| 处置 | 血清学检测可识别无应答个体；理想上**不应用作繁殖**（无法传递足量 MDA 给幼犬） |

4.3 同窝幼犬 MDA 是否等量？

- 理想上相等，但大窝中个体幼犬必须在最初 24 小时内主动找到乳头摄入足量初乳；较小较弱者做不到，摄入 MDA 较少——**这些个体早期受保护时间更短，但应比哺乳更成功、获更多初乳的同胞更早具备内源性疫苗应答能力**。

4.4 母犬年度加强 vs 三年加强所产幼犬的 MDA 有差别吗？

- 无证据。接受三年核心再免疫的成年犬在每个 3 年周期内保持稳定的保护性抗体滴度；实验数据显示早期生命正确免疫（此后成年不再接种）的犬对 CDV、CAV、CPV2 维持保护性抗体平台（Schultz——**原文此处引用被截断，其后为「- 〔EB1〕」残行**〔原文如此〕）。
- 大量血清学数据表明成年犬年度核心再免疫没有必要，三年（或更久）再免疫足以维持保护性滴度（Abdelmagid et al. 2004, Bohm et al. 2004, Mouzin et al. 2004, Gore et al. 2005, Schultz 2006, Larson & Schultz 2007, Mitchell et al. 2012, Killey et al.——**原文此处引用被截断**〔原文如此，据参考文献应为 Killey et al. 2018〕）〔EB1〕。
- 有些兽医喜欢在配种前给繁殖母犬接种，但**无证据表明其 MDA 质量高于标准三年核心再免疫程序**。', 'dog', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 易感窗口与幼犬社交化', '4.5 易感窗口与幼犬社交化

- 有效社交化幼犬的窗口与传染病「易感窗口（window of susceptibility）」重叠——后者指 MDA 已不足以完全保护、但尚足以阻断 MLV 核心疫苗诱导内源性应答的短暂时期（Cutler et al. 2017）〔EB1〕。因此参加幼犬班、外出等理论上存在感染风险；这是兽医面临的两难。
- 但**必须鼓励社交化**，因为行为问题是成年宠物犬被弃养（relinquishment）的主因之一。最小化风险的三项实际措施：（1）在相对清洁的环境举办幼犬班；（2）确保所有幼犬与成犬参与者均已免疫；（3）确保该幼犬完成 WSAVA 推荐的完整核心免疫程序。
- 美国一项研究监测参加幼犬班的幼犬，**未记录到一例感染**（Stepita et al. 2013）〔EB1〕；凭常识行事，风险很小。

4.6 末次疫苗接种后多久可带幼犬上街遛？

- 最坏情形：幼犬存在阻断性 MDA，直至 16 周龄或以后的那剂才诱导出内源性应答。该剂核心免疫后数日内即产生部分免疫力，**最高血清抗体滴度可能在接种后约 2 周达到**。许多幼犬会更早应答；拉美因核心免疫开始更早，可预期保护在更早年龄获得。
- 上街散步是社交化的一部分，答案与上问重叠：以常识行事，早期生命尽量减少暴露风险，例如**不建议把如此年幼的犬带到公园的犬只活动区**。

5. 特殊情形与临床时机问题（FAQ）

5.1 若给动物绝育是唯一接种机会，应打吗？

- 无证据表明绝育时接种疫苗不能激发主动免疫。麻醉剂本身不具免疫抑制性，手术伴随的短暂应激与炎症不影响疫苗免疫诱导〔EB4〕。唯一避免在绝育时接种的理由与极罕见的疫苗相关 I 型超敏反应有关——动物未禁食可能呕吐并在手术中误吸。这与疫苗诱生保护性免疫的效果无关。
- 一项研究显示早期绝育时给幼猫接种疫苗不影响免疫应答（Reese et al. 2008）〔EB1〕。

5.2 为什么收容所幼犬要从 6 周龄到 20 周龄每 2 周接种一次核心疫苗（既然 MDA 可持续至 16 周龄）？

- 收容所一般是高风险环境：动物密度高、免疫史与感染暴露史不明；入所幼犬的母犬免疫史通常也不详。为在此类环境优化幼犬保护，**VGG 推荐该核心免疫程序（在收容所能够负担时）**。收容所环境与繁育场及个体幼犬的新家明显不同。

5.3 鼻内（intranasal）疫苗喷注后犬打喷嚏，需要补注吗？

- **不需要。**此类产品配方含有抗原量「超量（overage）」，以容忍给药过程中部分制品的损失。如有任何疑问，应联系疫苗生产厂家。', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 犬患过免疫抑制性疾病（犬瘟热、埃希希体病）康复后多久可接种？', '5.4 能否同日给犬接种多种疫苗（核心组合、狂犬病和 CIRDC〔犬传染性呼吸道疾病复合体〕疫苗），特别是小型犬？还是应分散到不同周？

- 免疫系统可同时应答（或主动耐受）数千种不同抗原；皮肤黏膜表面本就持续接触大量抗原（微生物组、日粮、吸入抗原）。因此**免疫学上一次性给予多种疫苗抗原对免疫系统不构成问题**〔EB4〕。
- 多组分疫苗的注册要求是证明每个组分均能诱导保护性免疫；厂家还常证明自家产品组合的可共售用性（compatibility）〔EB2〕。故**把疫苗分散到不同周接种在免疫学上没有意义**，反而增加客户就诊次数、增加关键接种被「错过」的可能。
- 一条实用建议：给予多针不同注射（如核心疫苗与狂犬病疫苗分开）时，**应注射在不同皮下位点，使免疫启动靶向不同引流淋巴结**。
- 两项美国研究与此相反向：显示随单次给予抗原数量增加，犬（尤其低体重犬）和猫接种后发生不良反应的可能性更大（Moore et al. 2005, 2007）〔EB1〕。按 WSAVA 指南接种可最小化单次就诊递送的抗原数。

5.5 犬患过免疫抑制性疾病（犬瘟热、埃希希体病）康复后多久可接种？

- 基本原则：**临床患病动物不应接种**，应推迟至康复。真正从 CDV 感染康复的犬对再感染已有天然免疫，可能优于疫苗诱导的免疫；因此可先检测，若血清阳性则不需 CDV 再免疫。但因 CDV 抗原常与其他核心疫苗抗原混装，该犬未来仍可能随标准核心再免疫接受 CDV 苗。
- 若必须给 CDV 康复犬再免疫，**康复后 4 周**可让免疫功能恢复。
- 犬埃希希体（Ehrlichia canis）感染情形更复杂：疾病有急性期与慢性期，治疗过的犬仍可能携带病原，未来任何应激事件后疾病可复发。**诊断并正确治疗后，应至少临床正常 4 周才考虑接种。**
- 上述两种情形下，做简单血液学与血清生化学检查也可提示免疫学恢复（白细胞计数与血清 γ 球蛋白恢复正常）。

5.6 犬瘟热康复后再接种犬瘟热疫苗，会诱发神经症状吗？

- 简单回答是「不会」。如前（Question 34），自然康复犬对再感染已有强健天然免疫，实际不需要 CDV 疫苗（但多半仍作为多抗原核心疫苗成分接种）。核心疫苗病毒是减毒的，不具备诱导组织病理与临床疾病的能力。
- 近期有一例报告及若干历史病例：幼犬接种后 CDV 脑炎（post vaccinal CDV encephalitis）（Fairley et al. 2015）〔EB1〕，但属非常罕见。', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 流浪犬捡回家中、家中幼犬核心免疫未完成，该犬数日后出现 CDV 感染征象，幼犬应', '5.7 流浪犬捡回家中、家中幼犬核心免疫未完成，该犬数日后出现 CDV 感染征象，幼犬应立即接种吗？

-  Whenever 可能都应把新引入成年犬与幼犬隔离（直至幼犬完成核心免疫程序）——此为本篇抽取文本中夹杂英文残留句「It would always be good practice to isolate…」，照录。每个幼犬「易感窗口」的准确时点无法得知，引入时刻有的幼犬可能已免疫、有的不是。
- **若幼犬正处于两次核心疫苗间 2–4 周的间隔期内，此时提前于原日程再免疫无害**，之后重排日程至 16 周龄或以后的那剂；但在 16 周龄或以上的末剂之前，不能保证所有个体获得保护。

5.8 患过细小或犬瘟热康复的犬还应接种这些病吗？

- 从 CDV 或 CPV2 自然感染康复的犬已建立强健免疫保护、相应病毒血清阳性；这种天然免疫甚至优于疫苗可达的免疫。康复犬虽不需要针对该病原的疫苗，**但核心疫苗为三联制品，仍须接种以确保对另外两种病原的保护**（如 CDV 康复犬仍需防 CAV 与 CPV2）。

5.9 糖皮质激素治疗结束后多久可接种？

| 剂量档 | 原文照录 |
|---|---|
| 抗炎剂量 | 如泼尼松龙（prednisolone）0.5–1.0 mg/kg，**不会**损害免疫系统应答疫苗的能力 |
| 免疫抑制剂量 | 如泼尼松龙 2–4 mg/kg（尤其与其他免疫抑制剂合用）则旨在抑制免疫功能；因此**应至少在糖皮质激素减量并停用后 4 周再接种**，且犬此时应临床健康〔EB4〕 |

- 无糖皮质激素疗法对犬疫苗应答的正式研究；但有关环孢素（ciclosporin）对猫疫苗免疫应答的研究：用药期间猫对已见过的疫苗抗原（FPV、FHV1、FCV、FeLV 和狂犬病）能作出充分的保护性应答，但该药**损害首次接种 FIV〔猫免疫缺陷病毒〕疫苗的应答**（Roberts et al. 2015）〔EB1〕。

5.10 犬在化疗期间能接种吗？化疗结束后要等多久？化疗后需要重新免疫吗？

- 接受强免疫抑制化疗药的犬**不应接种**——这些药在攻击靶肿瘤细胞同时也攻击快速分裂的免疫细胞。**停药后应至少间隔 4 周**再给任何疫苗；犬应临床康复，理想上血液学与血清生化评估显示免疫功能恢复。
- 化疗药虽影响免疫功能（见 question 39），但**不会摧毁免疫系统或消灭记忆淋巴细胞**，故化疗结束后无需常规重新免疫（照常核心/非核心再免疫循环即可）；若担忧保护水平，可对核心疫苗抗原做血清学检测。人类化疗患者也在治疗结束时不被重新接种。', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 手术后要等多久才能接种？', '5.11 手术后要等多久才能接种？

- 手术过程与麻醉剂本身均不干扰免疫系统应答疫苗的能力〔EB4〕；但依手术性质，术后恢复期犬可能临床不适并接受多种治疗。按第一性原理，**应等待犬临床健康并完成术后药物治疗后再接种**。

5.12 老龄犬要免疫到多大年龄？需要每年打核心疫苗吗？

- 对核心疫苗（CDV、CAV 和 CPV2），良好证据表明幼龄正确免疫可诱导**终身保护性免疫**，无需规律成年再免疫。研究显示老龄犬（**10 岁及以上**）维持针对这三种核心病毒抗原的保护性抗体水平，且不因「免疫衰老（immunosenescence）」随龄下降（HogenEsch et al. 2004）〔EB1〕。
- 但给老年犬接种一种此前从未给过的新疫苗，其初次免疫应答弱于年轻时（Day 2010）〔EB1〕。因此**老龄犬不需要比年轻成年犬更频繁的核心再免疫**，可安全维持标准三年核心再免疫程序。
- 若以血清学（滴度）检测决定核心再免疫，VGG 建议老龄犬可**每年（而非每三年）检测一次**，仅为提供「无需再免疫」的安心依据〔EB4〕。

5.13 罗威纳犬应接种几剂？需要比别的品种多打 CPV2 剂次吗？

- 罗威纳是公认含高于平均比例的对 CPV2 与狂犬病疫苗的遗传性低/无应答者的品种。**没有理由比其它品种更频繁接种**——若属该遗传类型，意味着其缺乏对该特定抗原（如 CPV2）产生应答的免疫能力，无论多频繁接种都不会应答。此情形正是血清学检测的实际用武之地：检测试剂盒可判定罗威纳接种后对 CPV2 是否血清阴性（**注意不适用于狂犬病**）。血清阴性犬存在感染风险，应采取适当措施最小化；更重要的是**此类犬不应作繁殖用**。

5.14 有犬种特异的免疫程序吗？

- 无证据表明任何犬种或品种群需要特异免疫程序。已有讨论涉及小型犬（见 Question 18）及罗威纳是否因 CPV2/狂犬病疫苗应答不良的品种倾向而需不同核心程序（见 Questions 25 和 43）。
- 魏玛犬（Weimaraner）相关系犬易感一组综合征：肥厚性骨病、慢性反复感染与血清 IgG 缺乏〔原文正文作 hypertrophic osteopathy，所引 Harrus et al. 2002 标题作 hypertrophic osteodystrophy〕〔原文如此〕。有提示该综合征起病可能受疫苗接种影响（Harrus et al. 2002），故有过针对该品种免疫程序的讨论。**但总体而言证据不足，除按指南推荐的标准核心与非核心免疫外，不能为任何品种提出其他建议。**

6. 钩端螺旋体病疫苗专题（FAQ）', 'dog', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 年度 Leptospira 加强针错过超过 3 个月，补 1 剂还是 2 剂？', '6.1 年度 Leptospira 加强针错过超过 3 个月，补 1 剂还是 2 剂？

| 逾期时长 | 原文处置 |
|---|---|
| 逾期不超过 3 个月 | 单剂「加强」即可 |
| 逾期超过 3 个月（即距上次疫苗 15 个月间隔） | **应给两剂（间隔 2–4 周）以重建免疫，此后年度加强** |

- 某些厂家可能宣称保护可延至 18 个月才需新一轮基础免疫，但 VGG 在泛论所有疫苗时采取更审慎立场。

6.2 疫苗接种会影响钩端螺旋体抗体滴度的判读吗？

- 会。接种后产生抗体应答，但可能维持不久——**接种后滴度可在 4 个月内下降甚至消失**，尽管疫苗 12 个月保护期内该犬仍有保护。接种后滴度往往偏低，但若犬接触田间株，滴度可持续 4 个月以上且高水平。与非疫苗血清型（serovar）的交叉反应也可发生（Sykes et al. 2010）〔EB1〕。
- 因此，试图在临床患病犬确证钩体病诊断时，必须考虑既往接种时间——这也是钩体病临床诊断只能靠**间隔 2 周采集的双份血清 MAT（显微镜凝集试验）检测**来正确完成的主因之一：**疫苗抗体不会出现滴度升高，而针对可能感染血清型的抗体应显示 4 倍滴度升高**。
- 犬可对疫苗未含血清型产生滴度，有时最高滴度反而针对非疫苗血清型。已免疫犬出现符合钩体病的临床征象时，对非疫苗血清型的阳性滴度应谨慎解读（Barr et al. 2005, Martin et al. 2014）〔EB1〕。

6.3 高风险犬应每 6 个月还是每年接种 Leptospira 疫苗？

- 钩体病高风险犬指常可进入可能有啮齿动物污染的水环境、或有家畜的农场环境的犬；**城市犬也可能因此处于风险**。
- 早期版本的 WSAVA 全球指南曾建议对高风险犬考虑每 6 个月再免疫钩体病，**后来因科学证据不足撤销了该建议**。因此，**即使是高风险犬也只需每年再免疫钩端螺旋体病疫苗。**

6.4 多联大组合一针 vs 小编辑/单价分开注射？

- VGG **始终推荐小抗原组合疫苗**（如三联或二联核心疫苗+单独非核心疫苗），以便按 WSAVA 指南对个体动物灵活接种。此类产品线可根据暴露风险的生活方式评估（lifestyle assessment），为个体动物递送**最少必需的抗原组分**。
- **给予多针较小抗原组分疫苗，远优于单针注射含有该动物不需要或不推荐抗原的大多组分疫苗。**
- **这是拉美面临的最大挑战之一**：确保其他市场可及的小抗原组分产品线进入拉美，以便兽医能按 WSAVA 指南接种。

7. 成年动物免疫程序与地区性担忧（FAQ）', 'dog', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 无既往免疫史的成年犬或猫应接种几剂？', '7.1 无既往免疫史的成年犬或猫应接种几剂？

| 情形 | 原文照录 |
|---|---|
| 核心疫苗与狂犬病疫苗 | **单剂 MLV 国际质量保证疫苗即可在成年动物诱导保护性免疫**（成年动物没有幼犬幼猫那样的阻断性 MDA） |
| 例外：成年猫 FHV1 与 FCV 疫苗 | 为确保最佳应答，可给**两剂（间隔 2–4 周）**。在有单价以外的三联（FPV、FHV1、FCV）与二联（FHV1、FCV）制品可及时容易做到；**但在拉美仅有三联制品上市，做到这一点就必须追加一剂（不必要的）FPV 疫苗**。此外血清学检测可判定成年犬是否实际需要防 CDV/CAV/CPV2 的接种、成年猫是否需要防 FPV 的接种（**写作时猫用检测试剂在拉美不可获得**） |
| 非核心疫苗 | **均需两剂（间隔 2–4 周），随后按推荐间隔加强** |

7.2 拉美疾病流行高、接种率低，三年防 CPV 和 CDV 够吗？要继续年度核心免疫吗？

- 在拉美，**提高群体免疫远比提高个体动物接种负荷重要**：群体中接种的犬猫越多，传染病越难传播。核心疫苗一旦接种即诱导保护性免疫，**保护性免疫没有程度之分**。
- 存在针对核心疫苗抗原的抗体，**无论滴度多高或多低**，即表明该动物有免疫保护与免疫记忆，任何病原暴露都会触发快速继发（记忆）免疫应答。**不可能通过更频繁接种使个体「更免疫」；恰恰相反，从第一性原理看，超出推荐水平的重复接种更可能诱导免疫「耐受（tolerance，不应答）」而非保护**〔EB4〕。
- 因此**按 WSAVA 指南三年核心再免疫完全足够，即使对最高风险的犬也一样。宝贵的疫苗剂量应用于提高群体免疫，而不是浪费在已受良好保护的动物身上。**

7.3 客户因寄养场要求接种 Giardia 疫苗怎么办？VGG 为何不推荐该疫苗？

- 专业兽医应追问「这个规定是谁制定的？」。许多国家（包括北美和欧洲）寄养场与猫舍的外行业主因循历史惯例制定规则；这些善意者并非受过科学训练的兽医，普遍不了解过去数十年兽医疫苗学的进展。**应由兽医行业教育这一群体，协助制定与现代科学一致的规则。**

8. 猫白血病病毒（FeLV）相关专题（FAQ）

8.1 成年猫获得 FeLV 抵抗力后，再免疫应持续到什么年龄？

- 普遍认为成年猫确实会对 FeLV 感染产生某种程度的天然抵抗力，因此**给幼猫建立免疫比给成年猫更重要**〔EB4〕。任何有风险生活方式的幼猫（可进出的室内–室外、多猫环境），尤其居于已知高流行区者（拉美高流行区分布见本文档主体，即分块 001–010），均可从 FeLV 接种获益。
- 对成年猫，VGG 现时推荐 **FeLV 再免疫每 2 或 3 年一次而非每年；应终身维持**。', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · FeLV 检测阳性的猫还要接种（FeLV）吗？', '8.2 FeLV 检测阳性的猫还要接种（FeLV）吗？

- **不。**临床 FeLV 诊断试验检测病毒抗原，真阳性意味着该猫当前感染 FeLV 或正在清除近期感染；有些猫成功清除，有些变为持续或进行性感染。
- 流程：检测阳性的猫应**立即用另一厂家的试剂复检以排除假阳性**；若第二次仍阳性，**4–6 个月后**复检；4–6 个月后仍阳性则提示进行性感染。
- 要点：无病毒血症的感染猫可出现抗原检测阴性，意味着你可能在给无症状但已感染 FeLV 的猫接种——**该疫苗不会造成伤害，但也几乎不会带来益处**。

8.3 纯室内猫要接种 FeLV 吗？

- FeLV 感染风险因素包括：室外活动，以及经由唾液分泌物（舔舐、互相理毛、共享食盆水盆、打斗咬伤）接触其他猫。只会因年度兽医就诊离开室内环境的纯室内猫**不是非核心疫苗（含 FeLV）的接种对象**。
- 鉴于 FeLV 疫苗在幼猫使用最有效，而对该猫未来生活方式的预判有时令业主为难：若有迹象表明猫未来可能有室外活动、或与有室外活动的猫共同生活，**在生命早期考虑 FeLV 接种是有意义的**，在感染高流行区尤其如此。

8.4 家中已有 FeLV 阳性猫，又收养新幼猫，如何给它接种？

- 理想情况：已知 FeLV 感染猫应室内隔离饲养，并建议业主不要再引入其他猫。但若该情形不可避免，**新幼猫当然应尽快接种 FeLV 疫苗，理想上在进入家庭之前**。**标准幼猫 FeLV 程序：自 8 周龄起两剂（间隔 2–4 周），随后 12 个月加强。**

9. 妊娠、注射技术、保存与冷链、驱虫（FAQ）

9.1 可以给妊娠动物接种吗？

- 理想上**妊娠动物不应接种**。就需传递 MDA 的核心疫苗而言，平时已免疫的成年母犬/母猫应有足够抗体滴度供传递，**甚至在受孕前立即再免疫都没有必要**。除非厂家明确标示孕期接种安全（确有一些产品有此声明），孕期使用 MLV 疫苗对胎儿也存在理论风险。
- **非核心疫苗孕期也不应给予**；非核心疫苗不像核心疫苗那样经初乳传递保护性抗体。

9.2 注射疫苗前要用酒精擦拭皮肤吗？

- **完全没有证据支持该操作**，尽管其仍被广泛实践。酒精有可能灭活疫苗中一部分 MLV 病毒颗粒，因此擦拭其实是**禁忌（contraindicated）**。皮肤虽有正常菌群，但针头注射几乎不会因「携带」微生物进入皮下微环境而引起感染。另注：人类医学中，按照 WHO 与 CDC 建议，可注射疫苗的接种部位已不再进行酒精擦拭（如 WHO Best Practices for Injections and Related Procedures Toolkit，可在线获取）〔EB1〕。', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'caution', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 疫苗可以刚从冰箱取出即注射，还是需要先回温？', '9.3 疫苗可以刚从冰箱取出即注射，还是需要先回温？

- 使用前**即刻**用手心轻加温一剂疫苗无害，但其实没有必要。一项猫注射部位肉瘤研究提示递送冷疫苗可能是肿瘤风险因素之一（Kass et al. 2003）〔EB1〕。
- 但**疫苗绝不可过度加温，或在室温放置超过 1 小时**——MLV 疫苗部分病毒组分不耐热（thermo-intolerant），加温会损害效力。**绝不可清晨复溶后留用一整天**。疫苗应始终恰当保存（参见正文主体 Table 3，位于分块 001–010 内容中）。

9.4 冷链维持困难的国家，疫苗能在室温存放多久？

- 对 MLV 疫苗，**即使 1–2 小时室温**（室温因地理区域与季节波动很大）也足以开始灭活部分疫苗病毒组分。对诊所更麻烦的是停电导致疫苗冰箱长时间断电；此情形下的建议始终是**联系疫苗厂家征询意见**。
- 近期研究提示国际灭活（killed）狂犬病疫苗其实相当耐热（thermotolerant），但此类研究是以现场大规模免疫为背景完成的，而非从诊所内执业质量兽医学的角度（Lankester et al. 2016）〔EB1〕。

9.5 幼犬幼猫应在接种前先驱虫吗？

- 这是在世界多地流传的普遍信念。**几乎所有幼犬幼猫出生即带体内寄生虫**；现行建议是定期驱虫自**幼犬 2 周龄、幼猫 3 周龄**开始（如 ESCCAP Guidelines; https://www.esccap.org/guidelines/），这自然早于核心疫苗给予（自 4–6 周龄起）。
- 若就诊幼犬/幼猫寄生虫负荷巨大至严重贫血、临床患病，当然最好推迟接种至其康复；但多数带虫幼犬幼猫外观健康。**目前没有证据表明「正常」寄生虫负荷会干扰幼犬（或幼猫）应答疫苗的能力**；事实上，提供针对危及生命病毒病的保护可能比担忧寄生虫对疫苗的可能影响更重要。
- 免疫学上，大量研究显示寄生虫感染可通过把免疫拉向「与免疫抑制相关的 T 调节反应」和「以体液免疫为主、细胞介导免疫较弱的 Th2 型反应」来影响免疫应答性质，犬亦有此示（Junginger et al. 2017）〔EB1〕；小鼠和猪的实验研究显示体内寄生虫损害疫苗免疫应答（Urban et al. 2007）〔EB1〕，**但目前缺少任何犬猫体内寄生虫感染损害疫苗免疫应答的证据**。
- 驱虫显然是犬猫预防保健的重要部分（并有公共卫生意义），但**目前没有任何依据要求把易感动物的接种推迟到完成驱虫之后**。

10. 兽医职业防护与不良事件（FAQ）', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'caution', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 兽医自身应该接种狂犬病疫苗吗？还有其他需接种的职业病吗？', '10.1 兽医自身应该接种狂犬病疫苗吗？还有其他需接种的职业病吗？

- 任何在狂犬病流行国家执业的兽医、接触可能自狂犬病流行国输入动物者、或接触野生动物（**尤其是蝙蝠**）者，都应按照现行针对人的推荐常规接种狂犬病疫苗。狂犬病是致死性疾病，任何有暴露风险的兽医都不应 unprotected〔原文用词〕。
- 从伴侣动物执业角度看，**没有其他有可用或推荐人用疫苗的人畜共患病**。

10.2 如何说服因担心不良事件而不愿给宠物免疫的客户？

- 这即所谓「疫苗犹豫（vaccination hesitancy）」，在世界范围内人类与兽医医学中日受关注。拥有强大网络的存在活跃游说团体，营造针对儿童与宠物疫苗潜在不良事件的恐惧文化。人类医学的悲剧是：此类活动近年已致常见儿童病群体免疫下降、已受控疾病（如麻疹）出现暴发与死亡。
- 兽医如今确实经常面对拒绝给宠物免疫的客户。**职业责任是平静解释接种的理由、个体与群体免疫的重要性，以及疫苗的安全性（不良事件发生率极低）**。这也是 VGG 制作了全球兽医指南配套文件的原因之一——面向宠物业主与繁育者、以通俗语言写成（遗憾的是只有英文版），可作为关注疫苗的客户的事实信息来源。写作本文时，VGG 还在进行小动物执业疫苗犹豫的全球调查，**结果将于 2020 年发布**。

10.3 接种后不良事件有多常见？临床可见哪些类型？

- 接种后已识别的不良事件范围很广：多数短暂而轻微（如接种即刻的 I 型超敏反应），但有些可诱发更严重疾病（如免疫介导性溶血性贫血 immune-mediated haemolytic anaemia, IMHA、猫注射部位肉瘤 feline injection site sarcoma, FISS）。
- **最常见的单条「反应」是接种后 2–3 天的轻度嗜睡、厌食与发热（pyrexia）——这其实不是不良反应，而是疫苗刺激了免疫与炎症通路、正在产生保护性免疫的征象。**
- 不良反频率的准确数据难以获取。汇总全球信息：**临床每 10,000 剂接种约发生 30–50 次不良反应（多为轻度短暂）**（Moore et al. 2005, 2007, Miyaji et al. 2012）〔EB1〕。**（在拉美这类环境中）罹患危及生命传染病的风险远大于不良事件风险。**', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'caution', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 动物既往有接种后过敏史，还能再接种吗？', '10.4 动物既往有接种后过敏史，还能再接种吗？

- 理论上，若反应为 IgE 介导的 I 型超敏反应，该动物已被免疫致敏，再次接触同一抗原可能再发同类反应；现实中并非每次都发生，有时此类反应仅出现一次。
- 若反应发生在尚未完成早期生命全程疫苗的幼犬/幼猫身上，**则必须再接种以完成核心疫苗全部程序**。可斟酌非核心疫苗对该动物是否必要；成年后血清学检测可提示核心疫苗需求。
- 避免再次发生的实际措施：**更换疫苗品牌可能有效也可能无效**；接种前即刻给予一剂抗组胺药或抗炎剂量糖皮质激素无害，**不会干扰疫苗效力**；接种后最好把动物**留在诊所观察数小时**而非回家。

10.5 能否在有过敏史的动物接种前用糖皮质激素预防反应？

- **可以**，可用抗炎剂量的糖皮质激素，也可用一剂抗组胺药。不能保证预防反应再发，但不应干扰疫苗效力。

10.6 犬患可能由疫苗触发的免疫介导病，康复后如何再免疫？

- 免疫介导/自身免疫病是复杂多因素疾病：触发因素作用于遗传易感个体的免疫失调背景。犬免疫介导病公认触发因素包括潜在感染、肿瘤、慢性炎症或近期接触药物/疫苗。
- 犬疫苗相关自身免疫的证据有限，仅限临床观察：**免疫介导病始于接种后 2–4 周**且无其他可能触发因素。与疫苗关联最多的是 IMHA；免疫介导性血小板减少（IMTP）与免疫介导性多关节炎的证据则互相矛盾。
- 因接种是潜在触发因素、且免疫介导病有缓解-复发模式，对已治愈康复的犬应**审慎考虑再免疫方案**：血清学检测已具免疫者可**避免核心再免疫**；非核心疫苗应仔细选择，权衡疾病暴露风险与免疫介导病复发风险。
- **避免狂犬病再免疫在法律上可能行不通；不过美国一些州允许兽医批准狂犬病再免疫「医学豁免（medical exemption）」。**
- 上述预防措施虽合理（第一性原理），但两项近期研究实际显示从 IMHA 或 IMTP 康复的犬再接种并无显著不良影响（Ellis et al. 2016b, Moon & Veir 2019）〔EB1〕。', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 佐剂疫苗导致 FISS 的证据是什么？', '10.7 佐剂疫苗导致 FISS 的证据是什么？

- 疫苗只是与 FISS 相关联的很长一串可注射制品之一。**猫（相对于犬）的皮下组织有其独特性**，反复注射（任何物质）可能建立慢性炎症状态，某一点可转化为肿瘤性疾病。猫总体上似在局部创伤或慢性炎症后更易发生肉瘤（Morrison 2012）〔原文作 caner〔原文如此〕〕。
- 疫苗中的佐剂是否使其更可能诱发该反应仍有争论：毫无疑问**佐剂会在注射部位诱导持久的局部慢性炎症反应（远甚于非佐剂疫苗）**（Day et al. 2007）〔原文引用作 Day et al. 2007，参考文献另录 AbdelMageed et al. 2018 讨论铝的独立作用〕〔原文如此〕，但任何疫苗都被认为可能诱发此反应。
- 实践建议：**按 WSAVA 指南尽量最小化猫的全部疫苗接种；并作为预防措施尽量减少佐剂疫苗的使用**；还应考虑猫的接种部位（见 Question 68，即下节 10.8）。

10.8 为降低 FISS 风险，猫的最佳解剖接种部位是哪里？

- **没有任何特定解剖部位能降低肉瘤发生的风险**；但有些策略可在肉瘤发生时便于处理。不同组织与作者推荐不同选项：包括**尽可能远端皮下注射于后肢与前肢、注射于侧腹壁皮肤、以及尽可能远端注射于尾根部**。
- **WSAVA 不推荐单一选项**，但建议至少：**不使用颈背部（scruff of the neck）；每次轮换接种部位；并将部位记录在动物病历中**。

11. 血清学检测与再免疫决策（FAQ）

11.1 VGG 是否推荐用血清学检测代替成体核心再免疫？

- **是。**VGG 支持使用临床血清学检测判断成年犬是否已受保护（即有血清抗体）防 CDV、CAV 和 **CVP2**〔原文如此，应为 CPV2 拼写颠倒〕，以及成年猫是否受保护防 FPV（**写作时猫用检测在拉美不可获得**）。
- 注意：**血清学不能预测对 FHV1 或 FCV 的保护，也不能预测任何非核心疫苗抗原的保护**。
- 狂犬病疫苗效果的血清学检测常因宠物旅行所需；但这种检测一般在接种后限定期内（如 4 周）进行，**血清学不用于普通临床来证明狂犬病保护，因为滴度可在推荐检测间隔之后下降**。应选择有同行评审科学文献支持的、经过良好验证的试剂盒。
- 血清学可在年度或每三年的健康检查就诊时进行；许多担心疫苗安全性的业主（见 question 62）会为宠物选择该方案。', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 有检测猫抗体滴度的试剂盒吗？', '11.2 有检测猫抗体滴度的试剂盒吗？

- **有**：一家厂家生产检测猫血清 FPV、FHV1 和 FCV 抗体的院内试剂盒（Mende et al. 2014），但**写作时该检测在拉美不可获得**〔EB1〕。
- 重要限定：**只有针对 FPV 的抗体可预测保护；针对上呼吸道病毒（FHV1、FCV）的抗体与保护不相关。**

13. 附录：WSAVA 问卷调查（分块 019）

13.1 项目背景信（VGG 主席致同事信）

- 抬头：「APPENDIX: THE WSAVA QUESTIONNAIRE SURVEY / WSAVA VACCINATION GUIDELINES GROUP / FOCUS ON LATIN AMERICA / PROJECT 2016 to 2019」。
- 要点：VGG 自 2004 年起推出犬猫疫苗全球建议；2016 年启动聚焦**拉美地区地方性传染病与疫苗接种**的新项目；VGG 将对地区内各国开展一系列实地了解访问，会见执业者、行业、学术与政府兽医专业人员，以制定本区宠物犬猫最佳接种实践建议。访问前通过所附简短问卷收集并分析在这些国家执业的小动物兽医对传染病和犬猫疫苗的认知；数据对 VGG 保密，仅以匿名汇总形式发表。落款「Chairman, WSAVA Vaccination Guidelines Group」。', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 问卷结构与条目（照录）', '13.2 问卷结构与条目（照录）

**SECTION 1. ABOUT YOU**：性别（Male or Female）；年龄段（20 to 30 years／31 to 40／41 to 50／51 to 60／> 60）；执业年数（<5／5 to 10／11 to 20／21 to 30／> 30 years）；毕业兽医学院（填空）。

**SECTION 2. ABOUT THE PRACTICE YOU WORK IN**：诊所位于 rural 或 urban (city)；small animal only 或 mixed animal (including livestock)；本诊所全职/兼职兽医人数、支持人员（护士、前台、犬舍人员）全职/兼职人数；是否使用计算机化病历（Yes/No）；是否只接诊日间病人（Yes/No），若否，是否有过夜或更久住院部（Yes/No）；患者构成百分比（dogs___ cats___ other species___）；是否可及诊断实验室（Onsite___ University___ Private___）；若有自有院内实验室，可开展项目（表格照录）：

| Haematology |  |
|---|---|
| Serum biochemistry |  |
| Cytological examination |  |
| Antibody titres for vaccine-preventable diseases | List: |
| Others | List: |

**SECTION 3. ABOUT CANINE INFECTIOUS DISEASES IN YOUR PRACTICE**：勾选认为本地区存在的传染病并估计年诊断例数（表格照录）：

| Disease | Seen in my practice | Estimated number of cases seen/year |
|---|---|---|
| Canine distemper (CDV) |  |  |
| Canine hepatitis (adenovirus, CAV1) |  |  |
| Canine parvovirus (CPV2) |  |  |
| Rabies |  |  |
| Leptospirosis |  |  |
| Kennel cough (canine infectious respiratory disease complex) |  |  |

**SECTION 4. ABOUT FELINE INFECTIOUS DISEASES IN YOUR PRACTICE**：同上格式，猫病清单（表格照录，「Chylamydia felis」拼写照录〔原文如此〕）：', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 问卷结构与条目（照录） (2)', '| Disease | Present in my practice | Number of cases seen/year |
|---|---|---|
| Feline parvovirus (FPV) |  |  |
| Feline herpesvirus (FHV) |  |  |
| Feline calicivirus (FCV) |  |  |
| Rabies |  |  |
| Feline leukaemia virus (FeLV) |  |  |
| Feline immunodeficiency virus (FIV) |  |  |
| Feline infectious peritonitis (FIP) |  |  |
| Chylamydia felis infection |  |  |

**SECTION 5. ABOUT THE VACCINES YOU HAVE IN YOUR PRACTICE**：勾选诊所现有疫苗类型；犬疫苗是否全部来自单一厂家（Yes/No，哪一个）；猫疫苗同问（表格照录）：

| For Dogs | For Cats |
|---|---|
| Combined CDV, CAV2 and CPV2 vaccine | Combined FPV, FHV and FCV vaccine |
| Combined CDV, CAV2, CPV2, CPi | Combined FPV, FHV, FCV and Chlamydia vaccine |
| Combined CDV, CAV2, CPV2, CPi, Leptospira | Combined FPV, FHV, FCV, Chlamydia and FeLV vaccine |
| Combined CDV, CAV2, CPV2, CPi, CCv |  |
| Combined CDV, CAV2, CPV2, CPi, CCv, Leptospira |  |
| Combined CPV2, CCv |  |
| Combined CPV2, CDV |  |
| Giardia vaccine |  |
| Rabies vaccine | Rabies vaccine |
| Combined Bordetella/Canine Parainfluenza Intranasal parenteral |  |
| ___ ___ Leptospirosis vaccine | FeLV vaccine |
| Visceral leishmaniosis vaccine | FIV vaccine |
| Others (please name) | Others (please name) |', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 问卷结构与条目（照录） (3)', '（注：「Combined Bordetella/Canine Parainfluenza Intranasal parenteral」与「___ ___ Leptospirosis vaccine」两行为抽取残行〔原文如此〕。）

**SECTION 6. ABOUT VACCINATING DOGS IN YOUR PRACTICE**：核心犬疫苗（CDV、CAV 和 CPV）曾接种患者百分比；首次为幼犬接种的年龄；幼犬接种次数与周间隔；末次「幼犬免疫」年龄；是否在幼犬免疫完成后约 1 年再免疫（Yes/No）；成年犬核心疫苗频率（选项：Every 6 months／Annually (every year)／Triennially (every 3 years)／Less often (>3 years)）；当地犬狂犬病接种是否法定（Yes/No）；幼犬首剂狂犬病年龄；是否第二剂及月龄；是否建议成年犬狂犬病再免疫及频率；除核心（CDV、CAV2 和 CPV2）外成犬还使用哪些疫苗及频率。

**SECTION 6. ABOUT VACCINATING CATS IN YOUR PRACTICE**（**原文两处均编号 SECTION 6**〔原文如此〕）：核心猫疫苗（FPV、FHV 和 FCV）曾接种患者百分比；首次幼猫接种年龄；次数与间隔；末次「幼猫免疫」年龄；完成后 1 年是否再免疫；成年猫核心疫苗频率（选项：6 monthly／annually／triennially／longer (>3 years)）；当地猫狂犬病是否法定（填空）；幼猫首剂狂犬病年龄；是否第二剂及月龄；成年猫狂犬病再免疫建议与频率；除核心（FPV/FCV/FHV1）外成猫附加疫苗及频率。

**收尾开放题**：本地区关于传染病或免疫实践还有什么想告诉 VGG 的；「FINALLY」：贵地是否有目前**尚无疫苗可用**的重要疾病（Yes/No；若有列出）；如果有疫苗可用是否会使用（Yes/No）。致谢语：「THANK YOU FOR TAKING THE TIME TO COMPLETE THIS QUESTIONNAIRE IT WILL PROVIDE VALUABLE INFORMATION FOR THE VGG TO HELP FORMULATE RECOMMENDATIONS FOR VACCINATION IN LATAM」。

**文件尾注（照录）**：「These WSAVA vaccination guidelines have been published as submitted to JSAP and have been through an abridged peer-review process.」', '', 'young', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'informational', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('拉美地区犬猫疫苗建议 · 拉美执业要点速查（本部分 FAQ 数值汇总）', '14. 拉美执业要点速查（本部分 FAQ 数值汇总）

| 主题 | 关键数值/结论（均出自分块 011–019 原文） |
|---|---|
| 狂犬病法律间隔 | 拉美法定**年度**接种；北美/欧洲成体犬猫法定 3 年 DOI；现场大规模免疫运动仍年度接种、维持 70% 群体免疫 |
| MLV 最小接种年龄 | **绝不早于 4 周龄**（感染与畸形风险）；为幼龄设计疫苗可自 4 周（或 4–6 周）起；6 周龄后每 2–4 周一剂；8 周龄换三联；末剂 ≥16 周龄；26–52 周龄第四剂（可被 20 周龄血清阳性免除） |
| 收容所幼犬 | 6–20 周龄每 2 周一剂核心 |
| 成年无免疫史 | 核心+狂犬 MLV 国际质量苗单剂；成年猫 FHV1/FCV 可 2 剂（间隔 2–4 周）；非核心一律 2 剂（间隔 2–4 周）后按推荐间隔加强 |
| 钩端螺旋体 | 逾期 ≤3 个月补 1 剂；>3 个月（15 个月间隔）补 2 剂（2–4 周间隔）后年度；高风险犬也只年度（6 个月方案已撤销）；接种 4 个月后疫苗抗体可能消失；诊断靠 2 周间隔双份血清 MAT 4 倍升高 |
| 糖皮质激素/化疗/疾病康复 | 抗炎剂量泼尼松龙 0.5–1.0 mg/kg 不影响；免疫抑制剂量 2–4 mg/kg 停药后 ≥4 周；化疗停药 ≥4 周、无需重免；CDV/E. canis 康复 ≥4 周 |
| 老龄犬 | >10 岁维持三年核心程序；若用滴度检测则建议年检 |
| FeLV | 幼猫 8 周龄起 2 剂（2–4 周间隔）+12 个月加强；成猫每 2 或 3 年、终身；阳性不接种（先换试剂复检、4–6 个月复测）；纯室内且无外出前景者不接种 |
| 不良事件率 | 约 30–50 次/10,000 剂（多轻度短暂）；最常见为 2–3 天嗜睡/厌食/发热；过敏史者接种前可抗组胺或抗炎激素预处理、留观数小时 |
| FISS | 佐剂致持久局部慢性炎症；最小化猫一切疫苗与佐剂苗；避免颈部（scruff）、轮换部位并记录；冷疫苗可能为风险因子（Kass 2003） |
| 保存与冷链 | 室温放置勿超 1 小时；MLV 室温 1–2 小时即开始失效；勿清晨复溶全天使用；断电联系厂家 |
| 驱虫 | 幼犬 2 周、幼猫 3 周起驱虫（ESCCAP），早于核心疫苗；「正常」寄生虫负荷不构成推迟接种的理由 |
| 注射操作 | 不酒精擦拭（禁忌）；不拆剂量、不共用；多针分不同皮下位点；鼻内苗喷嚏后不补注 |
| 血清学 | 犬 kit 测 CDV/CAV/CPV2、猫 kit 测 FPV 可辅助成体再免疫（**猫 kit 写作时拉美不可得**）；不用于幼龄定接种时机；不能预测 FHV1/FCV 及非核心保护；狂犬滴度检测仅用于宠物旅行 |
| 职业防护 | 流行国/进口动物/野生动物（蝙蝠）接触者自身接种狂犬病苗；伴侣动物执业无其他人共患疫苗指征 |', '', '', '', '疫苗,拉美 LATAM,重组病毒载体疫苗,单价制品不可得,狂犬病年度法定,3 年 DOI,分块 011–019 内容与结构总览,疫苗递送与幼龄免疫程序问题（FAQ）', 'caution', '拉美地区犬猫疫苗建议（下）：执业常见问题解答、参考文献与 WSAVA 问卷附录', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 文献信息与目次（分块 001–002）', '> 本稿为英文全典分块 001–006 的中文整理稿，与 `01-犬猫疫苗接种指南2024.md`（基于官方中文译本 + 英文执行摘要）互补：本稿保留英文原文结构、作者与目次信息、图表图例及推荐建议完整措辞。
> 排版残留说明：原文抽取文本中反复插入下载水印行「17485827, 0, Downloaded from https://onlinelibrary.wiley.com/doi/10.1111/jsap.13718 by UNIVERSIDADE ESTADUAL PAULISTA, Wiley Online Library on [03/04/2024]. See the Terms and Conditions ... OA articles are governed by the applicable Creative Commons License」，该水印多次切断正文句子（如执行摘要中「Where finances permit, these … vaccines should be administered every 2 to 3 weeks」被切断）。本稿仅在必要处标注，不再逐条重复。

1. 文献信息与目次（分块 001–002）', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 标题与作者', '1.1 标题与作者

- 文章标题：NEW: 2024 Vaccination Guidelines for Dogs and Cats – compiled by the Vaccination Guidelines Group (VGG) of the World Small Animal Veterinary Association (WSAVA)。
- 作者：R. A. Squires\\*、C. Crawford†、M. Marcondes‡、N. Whitley§。
  - \\*  formerly, Discipline of Veterinary Science, James Cook University, Townsville, QLD 4814, Australia（通讯作者邮箱 r.a.squires@hotmail.com）。
  - † College of Veterinary Medicine, University of Florida, 2015 SW 16th Avenue, Gainesville, FL 32608, USA。
  - ‡ Department of Clinical Medicine, Surgery and Animal Reproduction, São Paulo State University, Rua Sergipe 575, ap. 32, São Paulo, 01243-001, SP, Brazil。
  - § Internal Medicine, Davies Veterinary Specialists, Manor Farm Business Park, Higham Gobion, Hertfordshire, SG5 3HR, UK。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 原文目次（含页码，照录）', '1.2 原文目次（含页码，照录）

| 英文目次条目 | 页码 |
|---|---|
| Executive Summary | 3 |
| Introduction | 4 |
| The Purpose of WSAVA Vaccination Guidelines | 5 |
| Vaccines as Part of Comprehensive Preventative Health Care | 6 |
| Different Types of Vaccine | 6 |
| Effects of Maternally Derived Antibodies on Immunisation | 7 |
| Serological Testing of Dogs and Cats to Assist in Vaccination-Related Decision-Making | 8 |
| Current and Emerging Topics in Canine and Feline Clinical Vaccinology | 9 |
| Canine Vaccination Guidelines | 11 |
| Feline Vaccination Guidelines | 16 |
| Vaccination of Dogs and Cats in Shelters and Sanctuaries | 22 |
| Adverse Events Following Vaccination (AEFVs) | 24 |
| Frequently Asked Questions (FAQs) | 27 |
| References | 36 |

1.3 本切片内容边界

- 分块 001–006 覆盖正文页 1 至「CANINE VACCINATION GUIDELINES / Core vaccines for pet dogs」及 **Table 1 的前三行**（犬瘟热/腺病毒/细小核心疫苗、重组核心疫苗、狂犬病疫苗）。
- Table 1 自钩端螺旋体（Leptospira spp.）行起延续到分块 007，**不在本稿范围内**；猫科指南、收容所、不良事件、FAQ 与参考文献（分块 007–022）亦不在本稿范围内。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 执行摘要（分块 002）', '2. 执行摘要（分块 002）', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 执行摘要（分块 002） (2)', '- 召集目的：WSAVA VGG 为制定**面向全球兽医**的犬猫疫苗接种指南而召集。前版指南发布于 2007、2010、2016 年，在同行评审文献中被引用数百次、被下载数万次；本文是其更新版。
- 定位：VGG 承认其推荐**必须宽泛并基于基本免疫学原理**，因为对某些国家或地区合适的细节化建议在其他地区适用性可能差很多。指南为兽医决策提供宽泛指引，**不描述强制性或最低护理标准（not mandatory or minimum standards of care）**；国家和地区兽医协会、个体兽医或诊所可据此制定适合本地条件的接种计划。
- **推荐建议（完整措辞）**：VGG **强烈推荐（strongly recommends）所有犬和猫都应获得疫苗接种的益处（ALL dogs and cats should receive the benefit of vaccination）**。这不仅保护个体动物，还将改善「群免（herd immunity）」以帮助最小化传染病暴发的风险。
- 核心疫苗（core vaccines）定义：VGG 将核心疫苗定义为**在考虑生活方式与所居住或前往的地理区域后，所有犬猫都应接种的疫苗**。某些核心疫苗防治全球分布的潜在致死性疾病，另一些防治仅在特定国家或地区流行的致死性疾病。
  - 全球犬核心疫苗：防治犬瘟热病毒（canine distemper virus, CDV）、犬腺病毒 1 型（canine adenovirus type 1, CAV）、犬细小病毒 2 型（canine parvovirus type 2, CPV）。
  - 全球猫核心疫苗：防治猫细小病毒（feline parvovirus, FPV）、猫杯状病毒（feline calicivirus, FCV）、猫疱疹病毒 1 型（feline herpesvirus-1, FHV）。
  - 狂犬病：在狂犬病流行的地区，犬猫接种狂犬病疫苗应视为必需（即狂犬病疫苗在那些地方为核心），**即使没有法律要求**。
  - 钩端螺旋体病：犬钩端螺旋体病（leptospirosis）是另一种广泛分布的致死性人畜共患病。在犬钩端螺旋体病流行、 implicated 血清群已知且有合适疫苗的国家或地区，**强烈推荐（highly recommended）**所有犬接种，且这些疫苗在那些地方应视为核心。
  - 猫白血病病毒：在许多（但非全部）地区猫白血病病毒（feline leukaemia virus, FeLV）相关疾病流行。在这些地方，FeLV 疫苗对**幼年猫（<1 岁）**及**可外出或与可外出的其他猫同住的成年猫**应视为核心。
- 母源抗体与幼龄接种程序：VGG 承认母源抗体（maternally derived antibodies, MDAs）会实质性干扰幼犬幼猫早期接种的多数现有核心疫苗的效力（幼犬防 CDV/CAV/CPV，幼猫防 FPV/FCV/FHV）。由于 MDA 水平在同窝内和窝间差异很大，**VGG 推荐幼犬幼猫接种多剂核心疫苗，每 2 至 4 周一次，末剂在 16 周龄或更大时给予**。
  - 在幼犬幼猫**只能接种一次**的情形（如费用受限），应以核心疫苗在 **16+ 周龄**接种。
  - 建议**在 26 周龄或之后复种（而非等到 12 至 16 月龄）**，以便对可能在 16+ 周龄接种时仍残留干扰性 MDA 的少数动物不失时机地免疫。
- 血清学检测：VGG 支持**自 20 周龄起**进行血清学检测以检出接种后的血清转化（犬 CDV、CAV、CPV；猫 FPV）。这有助于确认年轻及青年动物的主动免疫保护、优化成熟成年动物的复种间隔，并在某些情形下帮助管理收容所的传染病暴发。
- 不应滥用疫苗：**不应无必要地接种疫苗（Vaccines should not be given needlessly）**；成年动物核心疫苗复种频率不应超过必要。有大量同行评审发表证据显示多数现代改良活病毒（modified live virus, MLV）核心疫苗提供的免疫持续时间（duration of immunity, DOI）达多年。
- 非核心疫苗（non-core vaccines）定义：**高度推荐给**那些因地理位置和/或生活方式（如室内-室外进出、多宠物家庭）而面临感染特定非核心指定疾病风险的动物。兽医师与主人之间需要一次审慎的对话来决定为每位患者推荐哪些非核心疫苗。
- 不推荐疫苗（not recommended vaccines）：科学证据不足以支持在任何地区推荐使用者。VGG 未考虑少数地理可及性或适用性极受限的「次要（minor）」疫苗产品。', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 执行摘要（分块 002） (3)', '- 就诊模式：VGG 强烈鼓励兽医教育客户认识**定期健康检查（通常每年，有时更频繁）的价值，而不是说「疫苗接种咨询（vaccination consultations）」**。年度健康检查远不止是一次疫苗接种咨询，尽管它通常包含接种那些需要每年接种的选定疫苗。多数非核心疫苗提供的 DOI 约 1 年。
- 就诊体验培训：鼓励兽医接受旨在改善宠物、主人和诊所员工在就诊前后体验的培训。原文举例：Free Fear 培训项目（<https://fearfreepets.com/fear-free-certification-overview/>）与 Cat Friendly Certificate 项目（<https://catvets.com/cfp/cat-friendly-certificate-program/>）。
- 收容所与庇护所：VGG 考虑了收容所与庇护所中的疫苗使用，并再次认识到其中一些机构运作的财务约束。**VGG 收容所最低指南（minimum shelter guidelines）规定，进入此类机构的所有犬猫应在入场前或入场时用核心 MLV 疫苗接种**。在财务允许的情况下，这些疫苗应**自 4 周龄起每 2 至 3 周接种一次，持续到 5 月龄**〔原文此句被 Wiley 下载水印切断，此处按原文顺序拼合〕。
  - 防治呼吸道疾病的疫苗对典型家庭饲养的宠物犬被视为非核心，但**对收容所收容犬应考虑为核心**。
- 不良反应报告：VGG 认识到不良反应报告体系的重要性，但理解这些体系在不同国家发展程度不一。**强烈鼓励兽医向厂商和监管机构报告所有可能的不良事件**，以扩展推动开发更安全疫苗的知识基础。
- 关键信息框：原文称「VGG 提出的最基本概念由以下简短陈述概括（The most fundamental concepts proposed by VGG are captured in the following brief statement）」，但抽取文本中该框内容未紧跟出现；同一陈述在分块 003 与 004 中出现（见第 4 节与第 5 节）。**该框图与正文的位置关系在原文抽取中错乱，原文此处缺失（框内文字与标题的对应排版无法核实）**。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 引言：与其他指南的关系（分块 002–003）', '3. 引言：与其他指南的关系（分块 002–003）

- VGG 于 **2006 年**召集，制定面向全球兽医的犬猫疫苗接种指南。前版发布于 2007（Day, Horzinek & Schultz 2007a）、2010（Day et al., 2010）与 2016（Day et al., 2016）年。
- 因追求全球适用性，推荐必须宽泛并基于基本免疫学原理。在国家或地区已有优秀指南时，本 WSAVA 指南的相关性可能不如当地已有内容。原文列举：
  - 以色列：犬（Harrus, 2020）、猫（Baneth, 2020）。
  - 斯里兰卡：犬（Silva, 2016）。
  - 北美：猫——美国动物医院协会（American Animal Hospital Association, AAHA）与美国猫科医生协会（American Association of Feline Practitioners, AAFP）（Stone et al., 2020）；犬——AAHA（Ellis et al., 2022）。
  - 欧洲：猫——猫病咨询委员会（Advisory Board on Cat Diseases, ABCD）（ABCD, 2020a, 2020b, 2022; Hosie et al., 2015）。
- 这些及其他指南的一个关键特征是把疫苗分类为**核心、非核心或不推荐（core, non-core or not recommended）**。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗三类定义的修订版（分块 003）', '4. 疫苗三类定义的修订版（分块 003）

原文说明：在最新版中，**核心疫苗的定义做了轻微调整以避免自相矛盾并改善清晰度**，这也导致部分疫苗被重新归类。

| 类别 | 英文原文定义（照录要点） | 中文 |
|---|---|---|
| 核心疫苗（core vaccines） | those that ALL dogs and cats should receive, after considering their lifestyle and the geographical locations where they live or to which they travel | 在考虑生活方式与其居住或前往的地理位置后，**所有**犬猫都应接种的疫苗 |
| 非核心疫苗（non-core vaccines） | highly recommended only for those animals whose geographical location and/or lifestyle (e.g. indoor-outdoor access, multi-pet household) place them at risk of contracting specific infections not designated as core | 仅对那些因地理位置和/或生活方式（如室内-室外进出、多宠物家庭）而面临感染特定非核心指定疾病风险的动物**高度推荐** |
| 不推荐疫苗（not recommended vaccines） | those for which there is insufficient scientific evidence to justify recommending their use anywhere | 科学证据不足以支持在任何地区推荐使用的疫苗 |

按地点/人群的核心化判定（分块 003 措辞）：

- 全球犬核心：防治 CDV、CAV 与 **CPV 变异株（CPV variants）**〔注意此处与执行摘要的「CPV」表述略有差异，均照录〕。
- 全球猫核心：防治 FPV、FCV 与 FHV。
- 狂犬病：对犬猫，狂犬病病毒疫苗在**疾病流行的所有国家或地区**应视为核心。
- 钩端螺旋体病：防治犬钩端螺旋体的疫苗**在前版指南中被归为非核心**。在犬钩端螺旋体病发生、implicated 血清群已知且有合适疫苗的国家或地区，强烈推荐所有犬接种，且在那些地方应视为核心。
- FeLV：FeLV 在世界许多但非所有地区仍是猫发病与死亡的重要原因。在 FeLV 流行或仍受关注之处，FeLV 疫苗对**小于 1 岁的猫**及**可外出或与可外出的猫同住的成年猫**应视为核心。

核心信息框（原文在分块 003 中出现，措辞一）：「We should aim to vaccinate every dog and cat with the core vaccines. Selected non-core vaccines may be recommended after careful consideration of each pet''s lifestyle and local prevalence of vaccine-manageable diseases. Core and non-core vaccines should be stored and administered correctly, and used only as frequently as necessary to provide lifelong protection against the diseases that threaten **our** dogs and cats, wherever they live or travel.」（我们应力图为每只犬和猫接种核心疫苗；在审慎考虑每只宠物生活方式与当地疫苗可控疾病流行情况后，可推荐选定的非核心疫苗；核心与非核心疫苗应正确储存和接种，并仅按终身保护所需的频率使用。）', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 本版相对 2016 版的具体变更（分块 003）', '5. 本版相对 2016 版的具体变更（分块 003）

原文称本修订的基本结构与最近一版（Day et al., 2016）相似，但已大幅更新并加入大量新引文。列明的具体变更：

1. 修订「核心」疫苗定义，并解释为何认为此变更有益。
2. 新增专门处理**母源抗体（MDA）**的章节。
3. 更新犬猫临床疫苗学（clinical vaccinology）当前与新兴主题章节。
4. 更新「疫苗类型（types of vaccine）」章节。
5. 重写「收容所和庇护所中的疫苗（vaccines in shelters and sanctuaries）」章节。
6. 删除先前包含的「被动免疫（passive immunisation）」章节，以便聚焦预防性疫苗。
7. 纳入许多新参考文献并删除部分较旧参考文献。
8. **停用全文中的证据基础（evidence base, EB）符号 EB1 至 EB4**（Day et al., 2016）。原文解释：EB2 证据先前指作为兽用疫苗许可监管包一部分提交的**未发表、商业敏感**研究；EB3 证据指未作为监管包一部分提交的类似研究；此前 WSAVA 指南迭代中极少引用 EB2 与 EB3 来源。
9. 进一步讨论在 **26+ 周龄**用选定核心疫苗为幼犬幼猫接种、而非等到 12 至 16 月龄的推荐。
10. 纳入自上一版指南撰写以来发布的部分疫苗信息。
11. 进一步考虑猫疫苗接种的解剖部位。
12. 新增一份常见问题（frequently asked questions, FAQs）清单。

> **证据等级/推荐强度说明**：本版已停用 EB1–EB4 符号，因此**本切片（001–006）内不出现任何数值化证据等级或推荐强度标注**。原文仅以自然语言措辞表达强度，本稿照录如下对应关系：strongly recommends（强烈推荐）、highly recommended（高度推荐）、is advised（建议）、supports the use of（支持使用）、should be considered（应考虑）、it is not recommended / not advised（不推荐/不建议）、VGG minimum shelter guidelines state that（VGG 收容所最低指南规定）。

6. 指南目的、法规关系与方法学（分块 003）', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 目的与全球异质性', '6.1 目的与全球异质性

- 本指南旨在为国家小型动物兽医协会、兽医诊所与个体兽医提供**宽泛、最新、有科学支持**的犬猫疫苗接种建议。它们在某些领域提供强建议，但**不是一套规则**。要对 WSAVA **100 多个成员协会（对应 100 多个国家）以及 20 多万名（more than 200,000）个体兽医**都适用的规则是不可能制定的。
- 各成员协会之间存在巨大差异：传染病流行情况、对流行情况的了解程度、可用疫苗产品、有主犬猫与流浪犬猫群体规模、诊所与客户经济学、社会对宠物的态度。在某国或地区被兽医认为至关重要的疫苗，在另一处可能被合理地认为无用且不必要，或者根本不可获得。
- 由国家级协会、本地学术领袖和个体兽医在本地传染病流行等背景下阅读、讨论并改编这些宽泛指南。部分国家和地区近年已这样做。

6.2 与说明书/法规的关系

- 执业者有时担心某些指南推荐与产品说明书或数据表（欧洲称产品特性摘要，Summary of Product Characteristics, SPC）中的信息相悖。例如：若对成年动物以低于说明书建议的频率复种，或给 12 至 20 周龄之间的动物追加疫苗剂量，可能招致严重批评。原文称这通常不成立（Thiry & Horzinek, 2007），但执业者应确保随时了解任何可能妨碍其遵循指南的本地或国家规定。
- 若此类规定与基于当前科学证据和理解的建议相悖，本地或国家兽医组织可考虑游说当局修订规定。
- **产品说明书/数据表/SPC 是构成疫苗注册包一部分的法律文件**，提供产品安全性与效力细节，并载明正确接种后可预期的**最低** DOI。
- 指南基于关于犬猫疫苗所诱导 DOI 的**所有可用证据**，而非仅厂商生成的最低 DOI 数据；因此指南可能建议对某些在某些国家仍标注 1 年 DOI 声称的核心疫苗产品每三年或更低频率复种。
- **标签外使用（off-label use）**：尽管指南建议有时与说明书不同，兽医通常可通过取得主人对偏离说明书的知情同意来按指南（即按当前科学思想）使用疫苗。建议将知情同意记录于医疗记录。一个可能且少见的例外是某些国家兽医可能被政府法规强制要求遵守标签建议。
- 了解限制兽医偏离说明书自由度的本地法规很重要。兽医还应记住，公司代表通常会继续建议兽医遵守其说明书中的指示——**他们有时依法必须这样做**，即使他们更愿意支持指南建议。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 方法学格式', '6.3 方法学格式

- 本指南尽可能基于已发表的同行评审证据，但也不可避免地基于未发表或非同行评审的科学证据以及专家意见。
- 鉴于单份文件需覆盖材料的广度，**再次采用叙述性评论（narrative review）格式作为唯一适合的格式**（Baethge et al., 2019）。所有其他国际伴侣动物疫苗接种指南撰写团队也选择同一格式（Ellis et al., 2022; Hosie et al., 2015; Stone et al., 2020）。
- VGG 在规划本次更新时曾考虑采用系统审查格式，或基于德尔菲（Delphi）流程达成共识推荐的正式结构化方法（Gattrell et al., 2022），但**因材料广度与撰写团队规模而很快被认为不适用**。尽管如此，推荐仍基于所发现的最有力科学证据。
- 本文件旨在处理犬猫疫苗学当前议题，并提出帮助兽医与兽医组织改善这些物种疫苗理性使用的实践步骤。
- 原文再次标注「VGG 最重要的信息由以下简短陈述概括」，但框内文字在抽取文本中未紧随其后（见第 4 节的框图措辞）。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗作为综合预防保健的一部分（分块 003–004）', '7. 疫苗作为综合预防保健的一部分（分块 003–004）

- 定期评估疫苗需求只是**终生健康照护计划**的一个组成部分。个体化患者照护需要定期（通常每年）健康检查，预防保健计划围绕宠物的**年龄、品种、生活方式、环境和旅行活动**以及主人的情况来设计。
- 疫苗接种讨论是该类就诊的重要部分之一，与以下内容并列：体外与体内寄生虫的检出、治疗和预防；虫媒与人畜共患疾病预防；牙科护理；营养建议；行为评估与建议；以及是否有必要进行更频繁的定制检查。
- 血清学检测指导复种：在成年动物中，关于对某些核心产品（犬 CDV、CAV、CPV；猫 FPV）复种的决定可由血清学检测提供依据（Burr, 2006）。部分提供此替代方案的执业者报告，某些主人对此非常赞赏（Killey et al., 2018）。
- **老年动物**：
  - 很少证据表明，一生按本指南接种的老年犬猫在生命晚期需要专门或增强的核心复种程序（Day, 2010; Horzinek, 2010; Schultz et al., 2010）。
  - 有证据显示多数老年犬猫对核心 MLV 疫苗保有持续的免疫记忆（Dall''Ara et al., 2023; Day, 2010; HogenEsch et al., 2004; Schultz et al., 2010），并在给予**单剂**疫苗后迅速重获防御（Mouzin et al., 2004a, 2004b）。
  - 相对地，老年动物对初次接触的新病原体或抗原产生初次免疫反应的能力可能较差（Day, 2010）。
  - 一项近期研究（Dall''Ara et al., 2023）中，**超过 3 年前接种过的老年犬，其抗 CDV 与 CAV 保护性抗体滴度低于 1 至 3 年前接种过的老年犬**；该研究未研究这些老年犬复种后的血清学反应。尽管如此，基于这些发现，**可建议对老年宠物每三年或更频繁地复种**。
  - 对因宠物出行而首次接种狂犬病疫苗的英国犬猫研究显示，许多老年动物未能达到法律要求的抗体滴度（Kennedy et al., 2007; Mansfield et al., 2004）；较年轻的动物更可能被成功免疫。
- 核心信息框（原文在分块 004 中再次出现，措辞二）：与第 4 节措辞一基本相同，差异为「…against the diseases that threaten dogs and cats…」（无「our」）。〔原文两处措辞不一致，照录〕', '', 'senior', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 医疗记录与接种证书（分块 004）', '8. 医疗记录与接种证书（分块 004）

原文规定，在接种疫苗时应把以下信息记录在患者的永久医疗记录中：

1. 疫苗接种日期（Date of vaccine administration）；
2. 接种者身份（姓名、首字母缩写或代码）；
3. 疫苗名称、批号或序列号、有效期和制造商；
4. 疫苗接种的解剖部位与途径。

- 使用可剥离疫苗标签和能在医疗记录上盖印宠物轮廓的图章有助于此类记录，**这在某些国家是强制性的**。
- 任何不良事件都应以能在日后就诊时提醒全体员工的方式记录。
- **知情同意**应记录于医疗记录，以证明已向客户提供相关信息且客户授权该操作（例如上文讨论的疫苗「标签外」使用）。至少，该记录应表明在接种前进行了风险与获益的讨论。
- **接种证书（vaccination certificates）**：VGG 推荐证书设计不仅包含接种疫苗的日期，还应包含一个供兽医师说明**该动物预计在未来多长时间内受疫苗保护**的字段，以帮助减少宠物主人和犬舍/猫舍经营者心中的困惑。

9. 疫苗类型（分块 004）

原文说明：自上一版 WSAVA 指南发布以来已有新型疫苗开发与上市（Day et al., 2016），但全球范围内成熟 Established 的疫苗类型仍占主导和重要地位，**尤其是改良活疫苗与灭活疫苗**。

9.1 改良活疫苗/活 attenuated 疫苗（Modified live or live attenuated vaccines, MLV）

- 含活的但已减弱（attenuated）的完整病毒或细菌，能附着细胞、感染并在其中复制，建立低水平、一过性感染，从而激发强免疫反应而不引起明显疾病。
- 一般比多数其他类型**免疫原性更强**；许多 MLV 疫苗特别强效，通常**需要更少剂量**即可获得强免疫反应。
- 在无 MDA 干扰的动物中，某些改良活疫苗**单剂后即可产生持续多年的一致而持久的免疫反应**。
- 经肠胃外（通常为皮下）接种时，能更有效地在相关解剖部位诱导免疫；与多数其他类型相比更可能诱导**强健的细胞免疫以及体液（抗体介导）免疫**。
- 某些改良活疫苗直接用于黏膜部位（如鼻内或口服疫苗），在局部诱导保护性黏膜免疫。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 灭活（ killed）疫苗（Inactivated vaccines）', '9.2 灭活（ killed）疫苗（Inactivated vaccines）

- 含完整的、已灭活的、抗原齐全的微生物，不能感染或复制，但能刺激免疫反应。
- 因不模拟自然感染，通常产生的免疫反应较弱，可能无法产生足够的黏膜或细胞免疫，**一般需要多剂并需佐剂**才能刺激足够的免疫反应。
- 例外：**某些灭活疫苗异常强效，例如灭活狂犬病病毒疫苗**——其中一些高度免疫原性，单剂后可诱导持久保护。
- 幼猫接种单剂灭活疫苗后的血清转化在 **FHV 与 FPV 疫苗**中亦有显示（Lappin, 2012）。在一项后续 FHV 攻击研究（Summers et al., 2017）中，接种后第 7 天攻击时，灭活疫苗提供的保护与 MLV 疫苗相似。
- 然而，**多数灭活疫苗无论动物年龄都被认为至少需要两剂初始接种**：第一剂通常致敏（prime）免疫反应，第二剂（有时第三剂）通常在**间隔 2 至 4 周**给予并提供保护性免疫反应。完全的保护性免疫反应可能在**第二剂或末剂后 2 周**才形成。
- 与 MLV 相比，灭活疫苗通常产生**较短的 DOI**，需要更频繁复种（增强免疫，boosting）以维持保护。

9.3 亚单位疫苗（Subunit vaccines）

- 由从培养物中提取纯化、或用重组 DNA 技术（基因剪接与蛋白表达）合成的病原微生物抗原组分构成。
- 往往免疫原性低于 MLV 疫苗，因此通常含佐剂并产生较短 DOI（类似多数灭活疫苗）。
- 原文举例：莱姆病（Lyme disease）亚单位疫苗（Eschner & Mugnai, 2015; Grosenbaugh et al., 2018），以及较新含菌毛抗原（fimbrial antigens）的**支气管败血波氏杆菌（Bordetella bronchiseptica）**亚单位疫苗，供犬使用（HPRA, 2024; MSD Animal Health, 2024）。

9.4 重组活疫苗与新型 CPV 疫苗

- 重组 DNA 技术近期用于生产**抗 CPV 的新型重组活疫苗**（Pearce et al., 2023）。该新型 CPV 组分与较常规的 MLV CDV 组分组合（European Medicines Agency, 2021）。
- **该疫苗旨在在非常小的年龄（4 周龄）保护幼犬抵御 CPV 感染**，通过比上一代疫苗更有效地突破 MDA 干扰。
- 该疫苗含**重组嵌合细小病毒基因组，一部分为 CPV-2c、一部分为 CPV-2**。在生产过程中，用该重组基因组产生活细小病毒，能像常规生产的活 attenuated 疫苗一样感染细胞并在接种幼犬体内增殖。', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 载体疫苗（Vectored vaccines）', '9.5 载体疫苗（Vectored vaccines）

- 另一类重组疫苗：将编码一种或多种病原免疫原性蛋白的一个或多个基因直接克隆入载体病毒或生物体的基因组（例如把狂犬病病毒表面糖蛋白基因剪接到位的减毒金丝雀痘病毒载体）。
- 这种禽源重组嵌合病毒在哺乳动物宿主中只能**极有限地复制**，但确实在宿主细胞表面表达引入的基因，模拟自然感染。
- 载体疫苗**不能回复毒力**；载体被选择为非致病性，有时具免疫刺激作用。可诱导体液与细胞免疫反应，通常**无需佐剂**。
- 减毒金丝雀痘病毒已用于抗狂犬病、犬瘟热与 FeLV 感染的载体疫苗。

9.6 核酸疫苗（DNA 与 RNA 疫苗）

- 相对新型的疫苗形式，通过操控核酸在免疫后产生病毒抗原靶蛋白的拷贝。
- 信使 RNA（messenger RNA, mRNA）疫苗在当前 COVID-19 大流行期间为许多人所熟悉；通常需要**非常低温的运输与储存**。mRNA 疫苗采用递送系统（如脂质纳米颗粒）保护核酸免于降解并允许细胞摄取与 mRNA 释放。
- DNA 远不如 mRNA 脆弱，因此**裸 DNA 疫苗（naked DNA vaccines）更稳定**。
- **目前犬猫没有可用的 mRNA 疫苗，也没有可用的裸 DNA 疫苗。**

10. 母源抗体对免疫接种的影响（分块 004–005）

10.1 来源与作用机制

- MDA 主要由新生幼犬幼猫在出生后最初数小时摄入初乳（colostrum）获得（Chastant & Mila, 2019; Rossi et al., 2021）。**MDA 提供被动免疫（passive immunity）**。
- 虽然对保护幼犬幼猫在最初几周至关重要，但 MDA 也会干扰幼弱动物对多数疫苗产生自身免疫反应的能力（DiGangi, Levy, et al., 2011b; Friedrich & Truyen, 2000）。**血清 MDA 抑制幼动物体内的免疫球蛋白 G（immunoglobulin G, IgG）生成，并阻止疫苗抗原刺激主动免疫反应。**', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 关键时间参数与「易感窗口」定义', '10.2 关键时间参数与「易感窗口」定义

- 在多数幼犬幼猫中，MDA 下降到允许对疫苗产生主动免疫反应的水平约为 **8 至 12 周龄**。
- MDA 量少的幼犬可能在更早年龄即易感（并能对疫苗产生反应）；另一些可能 MDA 水平高到 **≥12 周龄**前无法对疫苗产生反应（Friedrich & Truyen, 2000; Thibault et al., 2016）。
- **关键定义**：MDA 既不足以提供完全免疫保护、又足以干扰主动免疫反应的这段时间，称为该幼犬或幼猫的「**易感窗口（window of susceptibility）**」。在此期间，幼犬幼猫**不能被常规疫苗免疫**，但接触「街头（street）」或强毒病原时**易感疾病**。
- **不采用血清学检测就无法预测这一窗口何时开启或结束（开始或终止）**，因为传给个体幼犬幼猫的 MDA 量在窝间和窝内都有差异。
- **不推荐对非常年幼的幼犬常规检测 MDA（It is not recommended to routinely measure MDA in very young puppies）**——有些幼犬接受的 MDA 比图 1 示例幼犬多或少得多。正因如此，才每 2 至 4 周重复接种，以尽可能缩窄幼犬幼猫的「易感窗口」。

10.3 为什么初免是多剂而非「加强免疫」

- 由于无法在不采血检测的情况下预测 MDA 何时衰减到足够低，**初始核心免疫程序通常涉及给予多剂、连续的疫苗**。**这些重复剂量不是加强免疫剂量（The repeated doses are not booster doses）**，其目的在于 MDA 下降到足够低后尽快触发主动免疫反应（见图 1）。
- MDA 可同时干扰对**改良活疫苗与灭活疫苗**的免疫反应。
  - 若在给予灭活疫苗**第一剂**时 MDA 足以阻断主动免疫反应，则**致敏不会发生**；此时灭活疫苗的第二剂将**无法**免疫该动物。
  - 相反，在 MDA 已足够衰减后给予**单剂 MLV 疫苗通常足以免疫**。', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 血清学检测辅助疫苗接种相关决策（分块 005）', '10.4 图 1 图例（How maternally derived antibody (MDA) interferes with a veterinarian''s ability to immunise puppies or kittens through early vaccination）

原文图例逐条：

- 图表示幼犬血清抗体（Ab）浓度或「滴度」为纵轴，周龄为横轴。所示抗体恰好针对犬细小病毒，但同样的原理适用于幼犬与幼猫面对多种病原的情形。
- 出生后不久，该幼犬通过初乳从母体获得大量抗细小病毒抗体，即所谓的「母源抗体（MDA）」（红线）。**MDA 呈指数下降，半衰期约为 9 至 10 天。**
- 注射器图标代表重复接种，其中**第一剂在 6 周龄**给予。**该首次接种未能免疫幼犬**，因为有干扰性 MDA 中和了疫苗；接下来两次接种同样如此。
- **在 8 周龄时**，该幼犬对细小病毒肠炎易感，因为其 MDA 浓度降到不足以抵抗中等剂量犬细小病毒攻击的水平；**但该年龄仍不能被免疫**，因为 MDA 水平仍足以干扰疫苗并阻止主动免疫。
- **约 13.5 周龄时**，该幼犬的 MDA 降到足以允许免疫的水平。**16 周龄时复种**，幼犬随即产生自身的主动免疫反应（蓝色曲线）。
- 虚线之间的粉红色阴影矩形代表该幼犬的「易感（或窗口）期」，在此期间对细小病毒病易感。
- 图注缩写：Ab Antibody（抗体）；MDA Maternally derived antibody（母源抗体）；注射器图标表示接种。

11. 血清学检测辅助疫苗接种相关决策（分块 005）

11.1 诊所内检测试剂盒

- 伴侣动物实践的一项进展是可商业获得能在诊所内检出犬 CDV、CPV、CAV 抗体及猫 FPV 抗体的检测试剂盒。其中一些试剂盒已通过验证可用于诊所与收容所场景且易于使用（Egerer et al., 2022; Gray et al., 2012; Litster et al., 2012; Meazzi et al., 2022），**在 20 至 30 分钟内给出阳性或阴性的快速结果**。
- 其中一些试剂盒可有用地补充传统实验室方法（如**病毒中和试验与血凝抑制试验**），后者仍是血清学检测的「金标准（gold standards）」（Jenkins et al., 2020）。', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 抗体存在与缺失的解释', '11.2 抗体存在与缺失的解释

- 对成年犬的 CDV、CPV、CAV 及成年猫的 FPV，**血清抗体的存在提供主动体液免疫反应的证据，很可能指示疾病保护**。在某些宠物中这些抗体**持续远超 3 年**。已接种犬可对 CDV、CPV、CAV 维持多年保护性免疫（Bohm et al., 2004; Jensen et al., 2015; Mitchell et al., 2012; Mouzin et al., 2004a, 2004b; Schultz, 2006; Schultz et al., 2010）；猫的 FPV 同样如此。
- 相反，目前认为**抗 FHV 或 FCV 抗体的存在并不可靠地预示对任一病毒的免疫保护**（Egberink et al., 2022; Stone et al., 2020），尽管较早一项研究在收容所猫中提供了支持性结果（DiGangi et al., 2011a）。旨在防 FHV 与 FCV 的疫苗可引起血清转化，但**可能只提供部分疾病保护，且不能有效保护免受感染或避免发展为带毒状态（carrier state）**。
- 在猫中，**抗 FPV 抗体检测被认为比抗 FHV 与抗 FCV 抗体检测更可靠地指示保护**（Mende et al., 2014）。
- **抗体缺失并不能可靠预示对感染与疾病易感**：因为抗体检测不评估细胞免疫与先天免疫，且许多动物被认为在无检出性血清抗体的情况下由免疫记忆稳健保护（Killey et al., 2018）。支持此点的是，先前接种过而血清阴性的宠物在复种后很快出现强烈回忆（anamnestic）抗体反应，表明它们很可能对攻击有稳健保护（Mitchell et al., 2012; Mouzin et al., 2004a, 2004b）。
- 尽管如此，**抗体缺失通常仍被作为复种的临床指征**——这是基于**预防原则（precautionary principle）**，因为在多数临床场景中记忆的证据（除通过复种与复检回顾性获得外）不易取得。

11.3 幼犬幼猫初免程序完成后的确认流程

- 主人可能希望确认幼犬幼猫在完成基础免疫后产生了主动免疫反应。若如此，可在 **20 周龄或之后、且距最后一剂疫苗至少 4 周**采集血清样本检测。
- 检出**血清阴性**的动物（可能只占很小百分比）应复种，并在数周后复检。
- 若动物再次检测阴性，应**初步视为无应答者（non-responder）**，可能对检测呈阴性的病原无法产生保护性免疫。
- 在此阶段执行金标准血清学检测可能否定先前的诊所内结果，或显示无应答犬典型的低或不可检出抗体滴度（见图 2）。', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 试剂盒性能与局限', '11.4 试剂盒性能与局限

- 诊所内血清学检测试剂盒受到一些兽医青睐，他们希望为客户提供常规复种（例如每 3 年一次）的便捷替代方案。
- 但已显示这些试剂盒与参考金标准检测相比，在**敏感度、特异度、阳性与阴性预测值（PPV 与 NPV）及总体准确率（overall accuracy, OA）**上存在差异（Bergmann et al., 2020; Bergmann, Halzheu, et al., 2021a; Bergmann, Zablotski, et al., 2021b; Dall''Ara et al., 2021; DiGangi, Gray, et al., 2011a; Egerer et al., 2022; Meazzi et al., 2022; Mende et al., 2014）。
- **若要依赖诊所内血清学检测试剂盒，其特异度需要高**（Bergmann et al., 2020; Bergmann, Halzheu, et al., 2021a; Bergmann, Zablotski, et al., 2021b）。假阳性结果会提示动物有抗体且受保护；而由于结果实为假阳性，**当前指南建议对该动物应予复种**。
- 德国一项近期研究将数种不同的诊所内检测试剂盒与金标准比较（Bergmann et al., 2020; Bergmann, Halzheu, et al., 2021a; Bergmann, Zablotski, et al., 2021b），试剂盒在易用性与相对金标准的表现上各异：
  - 某些试剂盒在检出犬血清 **CPV-2 抗体**方面表现很好（Bergmann et al., 2020）；但检出 **CDV 抗体**的试剂盒与一种检出 **CAV 抗体**的试剂盒表现差得多（Bergmann, Halzheu, et al., 2021a; Bergmann, Zablotski, et al., 2021b）。
  - 将**四种**不同的 CDV 抗体诊所内试剂盒与金标准比较：对急性患病犬或看似健康的慢性病犬检测时，它们都不可靠（Bergmann, Zablotski, et al., 2021b）。同一论文还对**金标准 CDV 病毒中和试验在急性患病或慢性病犬中的可靠性提出质疑**。总体而言，该工作不支持在这些动物中使用这些试剂盒检测抗 CDV 抗体的诊所内血清学检测的有用性。
  - 一种检出抗 CAV 抗体的单一试剂盒**特异度差**（Bergmann, Holzheu, et al., 2021a）〔原文此处作者名拼作「Holzheu」，前文作「Halzheu」，前后不一致，〔原文如此〕照录〕。
  - 原文明确：**需要进一步研究以推动这一重要领域的进展。**', 'dog', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 对执业者的建议', '11.5 对执业者的建议

- 理解血清学检测作为疫苗接种决策辅助的效用与局限要求很高。**兽医不应觉得有义务在其诊所中开始使用血清学或「滴度」检测，如果他们并不愿意这样做。** 本版指南新增了几条关于血清学检测的 FAQ，供有意进一步探讨此主题者使用。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 图 2 图例（原文抽取严重串行，照录并标注）', '11.6 图 2 图例（原文抽取严重串行，照录并标注）

图题：Algorithm showing the recommended approach to interpreting and acting upon serological test results obtained >4 weeks after the last puppy or kitten vaccination at 16 weeks of age or older（显示如何解读并处理在 16 周龄或更大时最后一剂幼犬/幼猫疫苗接种后 >4 周获得的血清学检测结果的建议流程）。原文另注：**理想情况下，血清学检测——尤其是抗 CDV 抗体检测——应在参考实验室进行，而不是使用即时检测（point-of-care testing）**。

图注缩写：CAV Canine adenovirus（犬腺病毒）、CDV Canine distemper virus（犬瘟热病毒）、CPV Canine parvovirus（犬细小病毒）、MLV Modified live virus（改良活病毒）。

流程图文字（原文抽取为碎片化、列序串行，〔原文如此〕照录）：

> core MLV vaccines finished at 16 weeks or older / CAV and CPV at > 20 weeks of age, / dose of vaccine for / Revaccinate against CDV, CAV and CPV / years / Repeat serology no less than 4 weeks later / This puppy may be a serological non-responder / Could be inadequately protected / Cellular and or innate immunity for this puppy if it cannot respond to one of the three

- 该流程图节点与箭头的对应关系在文本抽取中已丢失，**原文此处缺失（无法据抽取文本复原算法框图的分支结构）**。可复原的仅有：血清样本在 >20 周龄采集、距末剂 4 周以上复测血清学（「no less than 4 weeks later」）、针对 CDV/CAV/CPV 复种，以及再次阴性时判定为血清学无应答者、可能保护不足、其防御可能依赖细胞和/或先天免疫。

12. 犬猫临床疫苗学的当前与新兴主题（分块 005–006）', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 免疫覆盖率与群免', '12.1 免疫覆盖率与群免

- 2016 版讨论的多数当代议题仍具当前意义，但此后出现许多新主题。自 2016 年以来，在一些国家对**接受疫苗益处的宠物比例偏低**的担忧增加（Malter et al., 2022; Taylor et al., 2022）。
- 低接种比例对「群免（herd immunity）」产生不利影响（Datta & Roy, 2022）。**群免概念需要被伴侣动物兽医理解并付诸行动。**
- **在群体中对小比例宠物频繁接种，对改善群免几乎无益。相反，提高群体中受种宠物的比例——即使每只只接受一剂、时机良好的核心疫苗——将取得多得多的成效。**
- **过度的、无正当理由的「疫苗负荷（vaccine load）」仍令人担忧，且在某些国家情况还在恶化。** 含核心与非核心组分混合的多组分疫苗仍然常见。至少在某个国家，**单价（monovalent）疫苗的选择不是如预期的那样增加，而是减少。**

12.2 「同一健康」与 COVID-19（分块 006）

- 「同一健康（One Health）」概念对伴侣动物实践的重要性从未像今天这样迫切。COVID-19 大流行期间人类的苦难与其伴侣猫狗的苦难相互交织（Baptista et al., 2020）。正如大流行推迟了无数人的择期手术与医疗操作，它也阻止宠物主人为宠物获得及时兽医照护，尤其是疫苗接种（Owczarczak-Garstecka et al., 2022）。所幸自疫情开始以来，许多国家的情况已改善。
- COVID-19 还有许多其他同一健康意含：对大流行防范的全球重新聚焦为同一健康倡议提供机会，因为许多潜在人类病原体有动物宿主或 equivalents 动物病原体；用于人类病原体的新疫苗平台技术可能催化创新性兽用疫苗开发。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗犹豫（vaccination hesitancy）', '12.3 疫苗犹豫（vaccination hesitancy）

- 「疫苗犹豫」是另一项具有重要当代意义的议题。兽医与医学组织成员都对疫苗犹豫恶化表达关切（Lee et al., 2022; Mattson, 2020）。
- 定义（引原文）：疫苗或接种犹豫被描述为「**…delay in acceptance or refusal of vaccination despite availability of vaccination services.**（尽管有疫苗接种服务可用，仍延迟接受或拒绝接种）」（MacDonald, 2015）。
- 疫苗犹豫对全球公共卫生当局（包括世界卫生组织 [World Health Organization, WHO]）是巨大且不断增长的关切。**2019 年，疫苗犹豫被列为全球人类健康的十大威胁之一（top 10 threats to global human health）**（WHO, 2019）。
- 「vaccine hesitancy」一词于 **2010 年**首次出现在 Web of Science Core Collection；此后使用大幅增加，**仅 2020 年就有超过 350 篇相关论文发表**（Squires, 2021a）。
- **对小伴侣动物执业者而言，上述定义包容性不足**：许多选择不为宠物接种的人从未咨询兽医——他们既非延迟接受也非拒绝，而是**完全回避任何讨论**（Squires, 2021b）。
- 小伴侣动物实践中疫苗犹豫数据稀少，但一项非正式调查有**来自众多国家的 2500 多名兽医执业者**应答，结果显示许多兽医将其视为一个正在增长的问题（Squires, 2021b）。', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 覆盖率数据（照录数值）', '12.4 覆盖率数据（照录数值）

英国 PDSA 数据（2011 至 2022 年收集的伴侣动物福利多方面数据，PDSA, 2022）：

| 指标 | 数值 |
|---|---|
| 主人报告幼犬已接受基础免疫（2019 PAW Report） | 72%（约自 2016 年的 88% 下降） |
| 主人报告幼猫已接受基础免疫（2019 PAW Report） | 61%（约自 2016 年的 82% 下降） |
| 下降趋势首次被注意到的年份 | 2017 |
| 2020–2022 情况 | 似乎稳定或改善，受种比例略高；但 COVID-19 大流行的混杂效应使近期数字难以解读 |
| 2019 PAW Report 中未接种的首要原因之一 | 「太贵了（It''s too expensive）」占全部宠物主人的 17% |
| 成年猫主人不复种的最大抑制因素 | 不愿带猫去诊所令猫受压：**影响 22% 的主人**，略强于费用的 **21%** |
| 成年犬猫接受常规加强复种的比例 | 原文称「更低（even lower）」，未给出数字 |

- 原文推论：因此 **Fear Free Pets®** 及其他类似组织或许能在提高接种推荐依从性方面发挥重要作用。
- 值得注意：2019 PAW Report 中，**对疫苗安全的担忧并未被列为不给犬猫接种的原因**。

Taylor 等（2022）英国近 100 万只犬的研究：

- 在 12 个月研究期内，**仅 49% 的犬接受过至少一剂钩端螺旋体病疫苗**。
- **8 岁以上犬获得钩端螺旋体病疫苗益处的可能性比 1 岁以下犬低 12.5 倍**（原文：Dogs over 8 years of age were 12.5 times less likely…）〔原文该句「Dogs」大写，系抽取排版残留，照录〕。

Malter 等（2022）美国诊所犬猫非核心疫苗变异度研究（这些动物**核心疫苗均为最新（up to date）**）：

| 物种 | 疫苗 | 诊所中位接种率 |
|---|---|---|
| 犬 | 钩端螺旋体病 | 70.5% |
| 犬 | 支气管败血波氏杆菌（Bordetella bronchiseptica） | 68.7% |
| 猫 | FeLV（成年猫） | 34.6% |
| 猫 | FeLV（幼猫与 1 岁猫） | 36.8% |

- 原文结论：显然，兽医与兽医组织在改善小型伴侣动物接种率方面仍有相当大的空间，**包括在一些相当富裕的国家**。', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 「疫苗负荷」实例：澳大利亚 FeLV 疫苗', '12.5 「疫苗负荷」实例：澳大利亚 FeLV 疫苗

- 原文：关于过度的「疫苗负荷」，令人失望的是，例如在**澳大利亚已无法购买单价 FeLV 疫苗**，自上一版指南以来情况恶化。现在的唯一选择是注射**包含 FeLV 的五价（pentavalent）灭活疫苗**。此前曾有若干单价选择。原文推测是相对较小市场中的商业驱动因素导致了这一局面。

13. 犬疫苗接种指南：核心疫苗（分块 006，本切片末段）

13.1 全球核心与地方核心化

- 犬的核心疫苗信息概要见 Table 1（疫苗类型细节见前文「疫苗类型」章节）。
- 与收容所无关的宠物犬，全球相关的核心疫苗防治由 **CDV、CAV 与 CPV** 引起的疾病。此外，在某些地区执业的兽医会把其他疫苗指定为核心，例如防治**狂犬病与钩端螺旋体病**的疫苗。
- 狂犬病：凡是狂犬病流行之处，**所有犬猫都应接种以保护宠物与人类，即使法律不要求**。大规模犬只接种已被显示可大幅减少或消除狂犬病病例（Zimmer et al., 2018）。
- 钩端螺旋体病：在犬钩端螺旋体病流行、implicated 血清群已知且有合适疫苗可供使用的国家或地区，**强烈推荐**所有犬接种，且这些疫苗在那些地方应视为核心。

13.2 幼犬核心疫苗初始免疫程序（VGG 推荐，完整措辞）

- **VGG 推荐在 6 至 8 周龄为幼犬初次接种 CDV、CAV 与 CPV 核心疫苗，然后每 2 至 4 周一次，直到 16 周龄或更大。**
- 这些接种给予得越频繁，幼犬的「易感窗口」就越窄（或越短）。
- **不建议比每 2 周更频繁地接种（Vaccinating more frequently than every 2 weeks is not advised）。**
- 由此，这些基础核心接种的次数会有所不同，取决于开始接种的年龄与所选的接种间隔。
- **这些早期疫苗剂量中最重要的是在 16 周龄或更大时给予的那一剂**——可以预期在那么大年龄时，绝大多数幼犬的 MDA 已大幅衰减，因此几乎所有幼犬即使更早不能、此时也应能对疫苗产生反应。', '', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · Table 1「Vaccines for pet dogs (non-shelt', '13.3 Table 1「Vaccines for pet dogs (non-shelter)」——本切片包含的表体部分

原文表格标题：Table 1. Vaccines for pet dogs (non-shelter)。列：Vaccine / Puppies ≤16 weeks / Dogs >16 weeks / Revaccination / Comments and recommendations。分组行标题：Core vaccines for pet dogs, all parenteral（宠物犬核心疫苗，全部为肠胃外接种）。', 'dog', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · Table 1「Vaccines for pet dogs (non-shelt (2)', '| Vaccine | Puppies ≤16 weeks | Dogs >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| Canine parvovirus-2 (modified live virus, MLV) + canine distemper virus (MLV or recombinant) + canine adenovirus-2 (CAV-2, MLV) | Start no earlier than 6 weeks of age. Revaccinate every 3 to 4 weeks until 16 weeks of age. In especially high-risk situations continue until 20 weeks of age and consider vaccinating every 2 to 3 weeks（不早于 6 周龄开始；每 3 至 4 周复种至 16 周龄；在特别高风险情形下持续到 20 周龄并考虑每 2 至 3 周接种） | Two doses 2 to 4 weeks apart are recommended by some manufacturers. However, a single dose of MLV or recombinant vaccine will likely protect most dogs（部分厂商推荐间隔 2 至 4 周的两剂；但单剂 MLV 或重组疫苗很可能保护大多数犬） | Consider revaccinating at about 6 months of age, rather than waiting until the dog is 12 to 16 months of age. This will narrow the window of susceptibility for any puppies that failed to mount an active immune response earlier. Thereafter, revaccinate at 3 years of age and thereafter no more frequently than every 3 years（考虑约 6 月龄复种而非等到 12 至 16 月龄；此后再于 3 岁复种，此后复种频率不低于每 3 年一次〔原文为「no more frequently than every 3 years」〕） | These core vaccines are among the most important received by puppies and dogs. The aim should be to vaccinate as large as possible a proportion of the entire population. Careful socialisation of puppies (during their sensitive period for socialisation) can begin before the completion of this vaccination series（这些核心疫苗是幼犬与犬所接受的最重要疫苗之一；目标应是让尽可能大比例的全体群体接种；幼犬在敏感化期内的小心社会化可在本免疫程序完成前开始） |
| Canine parvovirus-2 (recombinant) + canine distemper virus (MLV) | Administer a single dose from 4 weeks of age before commencing routine primary vaccinations（自 4 周龄起给予单剂，然后再开始常规基础免疫） | 〔原表此格为空〕 | 〔原表此格为空〕 | This recently introduced product is aimed specifically at young puppies, likely to have interfering MDA, rather than for revaccination of older dogs（这一新近推出的产品专门针对可能有干扰性 MDA 的幼龄幼犬，而非用于较大犬只的复种） |', 'dog', 'young', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · Table 1「Vaccines for pet dogs (non-shelt (3)', '| Rabies (inactivated)（狂犬病，灭活） | Follow any local laws or regulations as a priority. Follow the product leaflets of locally manufactured vaccines. In some countries, the first dose is generally not given before 12 weeks of age（优先遵循任何本地法律法规；遵循本地生产疫苗的产品说明书；在某些国家第一剂通常不早于 12 周龄给予） | Follow any local laws or regulations as a priority. Follow the product leaflets of locally manufactured vaccines | Follow any local laws or regulations as a priority. Follow the product leaflets of locally manufactured vaccines. Revaccination at 1 year of age (or in some countries 1 year after the primary vaccination) is required. Canine rabies vaccines with either a 1- or 3-year DOI are available. Timing of boosters is determined by the licensed DOI, but in some areas may be dictated by law（1 龄复种〔或在某些国家为基础免疫后 1 年〕是必需的；有 1 年或 3 年 DOI 的犬用狂犬病疫苗；加强免疫时间由注册的 DOI 决定，但某些地区可能由法律决定） | Core wherever the disease is endemic or wherever local laws or regulations require（疾病流行或本地法律法规要求之处为核心） |

**表格延续性说明**：Table 1 的后续行（自「Leptospira spp. (killed bacterin)…」起）位于分块 007，属其他整理稿范围，本稿不予覆盖。', 'dog', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 原文中术语与缩写（本切片内出现的）', '14. 原文中术语与缩写（本切片内出现的）

| 缩写 | 英文全称 | 中文 |
|---|---|---|
| WSAVA | World Small Animal Veterinary Association | 世界小动物兽医协会 |
| VGG | Vaccination Guidelines Group | 疫苗接种指南小组 |
| AAHA | American Animal Hospital Association | 美国动物医院协会 |
| AAFP | American Association of Feline Practitioners | 美国猫科医生协会 |
| ABCD | Advisory Board on Cat Diseases | 猫病咨询委员会 |
| CDV | Canine distemper virus | 犬瘟热病毒 |
| CAV | Canine adenovirus（正文含 type 1；表中为 CAV-2） | 犬腺病毒（正文指 1 型；表中为 2 型） |
| CPV | Canine parvovirus（含 CPV-2、CPV-2c） | 犬细小病毒 |
| FPV | Feline parvovirus | 猫细小病毒 |
| FCV | Feline calicivirus | 猫杯状病毒 |
| FHV | Feline herpesvirus-1 | 猫疱疹病毒 1 型 |
| FeLV | Feline leukaemia virus | 猫白血病病毒 |
| MDA | Maternally derived antibody(ies) | 母源抗体 |
| MLV | Modified live virus | 改良活病毒 |
| DOI | Duration of immunity | 免疫持续时间 |
| SPC | Summary of Product Characteristics | 产品特性摘要（说明书/数据表） |
| EB | Evidence base | 证据基础（本版已停用 EB1–EB4 符号） |
| FAQs | Frequently asked questions | 常见问题 |
| AEFVs | Adverse events following vaccination | 接种后不良事件（仅见于目次） |
| PPV / NPV | Positive / negative predictive value | 阳性/阴性预测值 |
| OA | Overall accuracy | 总体准确率〔注意原文 OA 亦用作 WSAVA 相关机构简称之外的独立缩写，此处特指检测试剂盒总体准确率〕 |
| IgG | Immunoglobulin G | 免疫球蛋白 G |
| mRNA | Messenger RNA | 信使 RNA |
| WHO | World Health Organization | 世界卫生组织 |
| PAW | PDSA PAW Report（原文未展开缩写） | 原文此处缺失（PAW 全称在本切片未给出） |', '', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 本切片的内容缺失与不可复原之处（照实记录）', '15. 本切片的内容缺失与不可复原之处（照实记录）

1. **执行摘要末尾的「最基本原则简短陈述」框**：原文以「The most fundamental concepts proposed by VGG are captured in the following brief statement」引出，但抽取文本未紧随其后给出框内文本；同一陈述在分块 003 与 004 中两处出现（措辞略有差异，见第 4、7 节），框与正文的对应排版无法核实——**原文此处缺失**。
2. **分块 003 中「The most important messages of the VGG are captured in the following, brief statement」同样未紧跟框内文本**。
3. **图 2 算法流程图**：抽取文本为串行碎片，节点-箭头分支关系不可复原（见 11.6）。
4. **图 1 与图 2 的图形本身**：仅有图例文字，无数值刻度/坐标轴数据可转录。
5. **Table 1 未完成**：本切片仅含表格标题行与前三行（犬细小/犬瘟热/腺病毒三联、重组二联、狂犬病），其余（钩端螺旋体、支气管败血波氏杆菌、莱姆病、犬流感、CCV、犬胞内体等犬用非核心/不推荐疫苗行）在分块 007 及之后。
6. **本切片内无任何证据等级或推荐强度数值标注**（因 EB1–EB4 停用），仅有自然语言强度措辞；如需等级需查其他切片或原文 PDF。
7. **目次中的 Feline Vaccination Guidelines、Shelters and Sanctuaries、AEFVs、FAQs、References 章节正文**（页 16–40）不在 001–006 范围内。
8. 「Bergmann, Halzheu」与「Bergmann, Holzheu」引文拼写前后不一致——原文如此，未做订正。
9. 分块 002 中被 Wiley 水印切断的句子（收容所接种频率句）已按原文词序拼合，并在相应处标注。', 'dog', '', '', '疫苗,WSAVA,VGG,英文全典,切片001-006,执行摘要,文献信息与目次（分块 001–002）,执行摘要（分块 002）', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（一）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 第 1 段', '> 本篇为英文全典中文整理稿第二部分，逐条覆盖切片 007–011 的表 1（续）犬用疫苗、犬非核心/不推荐疫苗正文、表 2 宠物猫疫苗及其正文、收容所与庇护所（shelters and sanctuaries）犬猫疫苗接种及表 3、表 4。', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 本稿范围、起点与切片残留说明', '1. 本稿范围、起点与切片残留说明', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 本稿范围、起点与切片残留说明 (2)', '- **本稿起点为切片 007，前文见 06-**。切片 007 开头即为上一段（表 1「宠物犬核心疫苗」中钩端螺旋体行的中段）的续句：首行以 `| Leptospira spp. (killed bacterin). The serogroups included in vaccines depend on the geographical region...` 起头，该行「Vaccine」列的起始文字在切片 006，本切片仅余后半列内容〔原文如此〕。
- 切片 011 结尾止于表 4（收容所猫核心疫苗）第 3 行，其后内容续入切片 012（由 08- 整理稿覆盖）。
- **证据等级/推荐强度**：切片 007–011 全文未出现任何证据基础（Evidence Base, EB）符号或推荐强度标注。与本系列前版一致，2024 版已停止使用 EB1–EB4 符号，改为叙述性评论，故本稿各条建议只能照录原文措辞，无可转录的等级标记。原文此处缺失。
- ** Wiley 下载水印残留**（原文如此，逐字照录一次；下文不再重复）：
  > 17485827, 0, Downloaded from https://onlinelibrary.wiley.com/doi/10.1111/jsap.13718 by UNIVERSIDADE ESTADUAL PAULISTA, Wiley Online Library on [03/04/2024]. See the Terms and Conditions (https://onlinelibrary.wiley.com/terms-and-conditions) on Wiley Online Library for rules of use; OA articles are governed by the applicable Creative Commons License
  该水印在切片 007、008、009、010、011 中反复出现，且多次**从句子中间截断正文**。已确认的截断位置：切片 008 中「…the oral route〔水印〕(Ellis et al., 2016)」（同一句被拆成两行）；切片 007 中「A detailed comparison is beyond the scope of this document.〔水印〕」；切片 009 与 010、011 的段末亦为水印与正文粘连；切片 011 开头整行为孤立水印，其前的「…immunocompromised cats have recently been provided in an excellent review (Hartmann et al., 2022).」属切片 010 末。
- **断词/软连字符残留**（原文如此）：切片中大量出现 `non-­core`、`high-­risk`、`low-­risk`、`1-­and 3-y­ear`、`in-­practice`、`FeLV-­negative`、`antibody-­negative`、`FeLV-­related`、`pantropic or more highly pathogenic`、`Canine Herpesvirus-­1`、`parainfluenza`、`chimaeric`（英式拼写，意为"嵌合"）等带软连字符的片段；排版换行导致的串行（如 `B.` 与 `burgdorfe` 被拆开、`B. bronchiseptica` 与 `CPiV` 行间断裂、`Leishmania infantum` 行与 `CanL` 行分置、`Gourkow et al., 2014;` 与 `Gourkow & Phillips, 2015)` 跨切片拼接）均照录。', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 本稿范围、起点与切片残留说明 (3)', '- **章节标题与正文串行**（原文如此，PDF 抽取将小标题并入段落）：切片 008 中「Non-­core vaccines for pet dogs」与「Not recommended vaccines for dogs」、切片 009 中「FELINE VACCINATION GUIDELINES」「Core vaccines for pet cats」、切片 010 中「Non-­core vaccines for pet cats」、切片 011 中「Not recommended vaccines for cats」「VACCINATION OF DOGS AND CATS IN SHELTERS AND SANCTUARIES」「Core vaccines for shelter dogs and cats」均无独立成行，本稿按语义拆分并在标题处标明。
- 表格跨页重复的 `Table 1. (Continued)` / `Table 2. (Continued)` 表头照录；表中空缺单元格一律标「原文此处空缺」。', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·犬核心疫苗末行与首个非核心行〔切片 007〕', '2. 表 1（续）·犬核心疫苗末行与首个非核心行〔切片 007〕

表 1 标题为 *Table 1. Vaccines for pet dogs (non-shelter)*（宠物犬〔非收容所〕疫苗），列标题为 Vaccine | Puppies ≤16 weeks | Dogs >16 weeks | Revaccination | Comments and recommendations。本切片首两行为该表遗留内容。

2.1 钩端螺旋体（Leptospira spp.，灭活菌苗 killed bacterin）行〔承接切片 006，本切片为该行后半〕

| Vaccine | Puppies ≤16 weeks | Dogs >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| 〔前文见 06-〕Leptospira spp.（killed bacterin，灭活菌苗）。疫苗所含血清群（serogroups）取决于地理区域。多数疫苗至少含两个血清群，但有一价为单价（monovalent）、部分为三价（trivalent）、部分为四价（quadrivalent） | 首剂通常自 8 周龄起。开始时间遵循产品说明书（product leaflet）建议。2 周后接种第二剂 | 两剂，间隔 2 至 4 周 | 每年 | 在犬钩端螺旋体病（canine leptospirosis）流行、涉案血清群已知、且含涉案血清型（serovars）的合适疫苗有商品供应的地区，对犬为**核心疫苗（core）** |', 'dog', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 犬副流感病毒（CPiV）行——非核心疫苗栏起始', '2.2 犬副流感病毒（CPiV）行——非核心疫苗栏起始

| 栏目标题 | 内容 |
|---|---|
| Non-core vaccines for pet dogs（宠物犬非核心疫苗） | 表中分隔行，其余四列原文此处空缺 |
| Canine Parainfluenza Virus（CPiV，犬副流感病毒；MLV〔改良活疫苗，modified live virus〕，parenteral〔注射途径〕） | 自 6 周龄起接种，此后每 2 至 4 周一次，直至 16 周龄或更大 |
| Puppies ≤16 weeks | 自 6 周龄起，之后每 2–4 周一次直至 16 周龄或更大 |
| Dogs >16 weeks | 制造商一般推荐两剂，间隔 2 至 4 周 |
| Revaccination | 每年 |
| Comments | **非核心（Non-core）**。在宠物犬中提供的免疫持续时间不确定。CPiV（MLV-黏膜）与支气管败血波氏菌（*Bordetella bronchiseptica*）联合使用可能更可取，因 CPiV 并未作为单一抗原产品广泛可得 |', 'dog', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·宠物犬非核心疫苗逐条〔切片 007〕', '3. 表 1（续）·宠物犬非核心疫苗逐条〔切片 007〕', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·宠物犬非核心疫苗逐条〔切片 007〕 (2)', '| Vaccine | Puppies ≤16 weeks | Dogs >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| *Bordetella bronchiseptica*（支气管败血波氏菌；live avirulent bacteria，活无毒菌株，intranasal 鼻内）；*B. bronchiseptica* + CPiV（MLV）鼻内；*B. bronchiseptica* + CPiV（MLV）+ CAV-2（犬腺病毒 2 型，MLV）鼻内；*B. bronchiseptica*（live avirulent bacteria，oral 口服）；*B. bronchiseptica* + CPiV（MLV）口服 | 这些经黏膜施用（mucosally applied）的疫苗**每剂即可提供保护**（single dose）。部分可早至 3 周龄施用，另一些在 7 或 8 周龄。遵循产品说明书建议 | 单剂 | 每年 | **非核心**。这些用于鼻内或口服的活疫苗**绝不能**被误以注射途径（parenterally）给予，否则可导致严重不良反应（severe adverse reaction） |
| *Bordetella bronchiseptica*（killed bacterin，灭活菌苗，parenteral 注射）；*Bordetella bronchiseptica*（cell wall antigen extract，细胞壁抗原提取物，注射）；*Bordetella bronchiseptica*（fimbrial antigen，菌毛抗原，注射） | 这些注射用菌苗或亚单位（subunit）疫苗需**两剂**才能免疫，一般间隔 2 至 4 周。查阅并遵循产品说明书的间隔 | 两剂。查阅并遵循具体产品说明书间隔，因产品之间存在差异 | 多数为每年。查阅并遵循具体产品说明书间隔。**菌毛抗原疫苗有特殊的复种说明** | **非核心**。这些注射用疫苗不应被误以鼻内或口服给予。那样既无效，又可能造成不必要的不适 |
| *Borrelia burgdorferi*（伯氏疏螺旋体；Lyme borreliosis 莱姆疏螺旋体病；killed whole bacterin 灭活全菌苗，注射）；*Borrelia burgdorferi*〔subunit-Outer surface protein A (OspA，外表面蛋白 A)，注射〕；*Borrelia burgdorferi*（subunit OspA 与嵌合 chimaeric OspC 蛋白） | 这些注射用菌苗或亚单位疫苗需两剂才能免疫，一般自约 8 周龄开始。查阅并遵循具体产品说明书间隔 | 两剂，间隔 2 至 4 周。查阅并遵循具体产品说明书间隔 | 每年。在蜱季开始前复种，蜱季起始按地区判定 | **非核心**。通常仅建议用于已知高暴露风险、居住或前往媒介蜱暴露风险被认为高的地区、或已知疾病流行的地区的犬。伯氏疏螺旋体预防的主干是勤勉的体外寄生虫控制（ectoparasite control）。不发生犬对犬的直接传播 |
| Canine influenza virus（犬流感病毒，CIV；H3N8；killed adjuvanted 灭活加佐剂，注射）；CIV（H3N2；灭活加佐剂，注射）；CIV（Bivalent H3N8+H3N2 双价；灭活、加佐剂、注射） | 这些注射用灭活病毒疫苗需两剂才能免疫。首剂可自 6 周龄给予。查阅并遵循具体产品说明书间隔 | 两剂。查阅并遵循具体产品说明书间隔，一般为 2 至 4 周 | 每年 | **非核心**。仅在 USA（美国）获许可。可考虑用于共同饲养（co-housed）的犬等高危群体，例如寄养犬舍（kennels）、犬展（dog shows）或日托中心（day care）中的犬 |
| Canine leishmaniosis（犬利什曼病，CanL；recombinant protein A2 重组蛋白 A2，注射） | 三剂，间隔 3 周，首剂在 >4 月龄 | 三剂，间隔 3 周 | 每年 | **非核心**（原文此处大小写作 "Non-­Core"〔原文如此〕）。犬利什曼病的预防关键在于勤勉的体外寄生虫控制以尽量减少与媒介的接触。疫苗接种可视为辅助性控制措施，**不能**替代勤勉的体外寄生虫控制 |', 'dog', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·宠物犬非核心疫苗逐条〔切片 007〕 (3)', '| CanL〔excreted-secreted proteins (LiESP) of *L. infantum*，*L. infantum*（婴儿利什曼原虫）排泄-分泌蛋白，注射〕 | 三剂，间隔 3 周，首剂在 >6 月龄 | 三剂，间隔 3 周 | 每年 | 原文此处空缺（评注并入上方 CanL 条目） |
| CanL（recombinant Protein Q 重组蛋白 Q，注射） | >6 月龄单剂 | 单剂 | 每年 | 原文此处空缺（评注并入上方 CanL 条目） |
| Canine herpesvirus-1（犬疱疹病毒-1，CHV-1；subunit 亚单位，注射） | 不适用。本疫苗 intended for pregnant bitches（用于妊娠母犬） | 妊娠期两剂。第一剂——发情期（oestrus）或假定交配日期后 7 至 10 天；第二剂——预计分娩日期前 1 至 2 周。遵循产品说明书 | 制造商建议在**每一次后续妊娠**重复该两针方案 | 本疫苗旨在保护新生仔犬。感染（通常来自母犬）对未被保暖（not kept warm）的 <3 周龄幼仔可为致死性 |', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 正文·犬：幼犬系列收尾、20 周龄血清学检测与 26+ 周龄复种〔切片 007〕', '4. 正文·犬：幼犬系列收尾、20 周龄血清学检测与 26+ 周龄复种〔切片 007〕

4.1 母源抗体持续导致少数仔犬应答不足

- 即使最后一针仔犬疫苗在 16 周龄或稍晚给予，仍有一小部分仔犬因持续存在的**母源抗体（maternally derived antibody, MDA）**而对疫苗未能充分应答（Friedrich & Truyen, 2000; Thibault et al., 2016）。
- 因此 VGG 建议：在末次仔犬接种后至少 4 周做**血清学检测**（serological testing）（即若遵循本指南，则在 20 周龄或更晚），**或**作为替代，在 26 周龄或紧随其后追加一次接种。

4.2 取代 12–16 月龄"首年加强"，并收窄为"26 周龄或紧随其后"

- 本建议首次提出并解释于前版指南（Day et al., 2016），**取代**了早前在 12 至 16 月龄用核心疫苗打"首年加强针（first annual booster）"的建议。
- 在 26+ 周龄而非等到 52 周龄或更晚接种仔犬，**不会**增加动物所接受的核心疫苗剂次，但将大幅缩短那些尚未建立主动免疫应答的少数个体的易感期。
- VGG 先前建议（Day et al., 2016）为该次接种在 **26 至 52 周龄**给予；在本版指南中，修订建议为在 **26 周龄或紧随其后**给予。若在 20+ 周龄血清学检测显示已对 CPV（犬细小病毒-2，canine parvovirus-2）、CDV（犬瘟热病毒，canine distemper virus）和 CAV（犬腺病毒，canine adenovirus）获得保护，则**无需** 26+ 周龄那次接种。

4.3 与约 1 岁首次健康检查并行

- 该早期复种建议**绝不互相排斥**，也不应排除在约 1 岁时进行首次年度健康检查、并给予狂犬病疫苗（如需）及任何被认为必要的非核心疫苗。理解兽医迫切希望复查其照护的犬在达到或接近骨骼与行为成熟时的状况。
- 一些获许可疫苗的 datasheet（数据表）建议仔犬系列在 10 或 12 周龄收尾。小型实验研究（例如 Bergman et al., 2006）支持该建议。然而其他实验研究与田间研究得出相反结果，且部分支持性实验证据被所谓**"pen effect"（围栏效应/圈舍效应）**削弱（Ellis, 2015）。该效应指实验仔犬被群养、得以在组内共享经黏膜排出的**疫苗病毒（vaccinal virus）**，这会使它们获得免疫的机会被大幅且人为地增加，从而可能**高估**疫苗带来的收益。', 'dog', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · VGG 的持续立场与早期社会化', '4.4 VGG 的持续立场与早期社会化

- VGG 因此继续推荐：**收尾不早于 16 周龄**，并优选在此后接以血清学检测或 26+ 周龄复种。
- "早期收尾"方案的部分理由是允许仔犬早期社会化（early socialisation）。VGG 强烈支持早期社会化，认为其对犬的健康行为发育与未来福祉至关重要（Korbelik et al., 2011）；在遵循本 WSAVA 疫苗接种指南的同时即可实现早期社会化。
- 研究表明，处于初始疫苗系列中段的仔犬因参加早期社会化课程而罹患 CPV 相关疾病的风险很低（Stepita et al., 2013）；对 CDV 与 CAV 亦可能如此。对 MLV 核心疫苗应答最佳的犬，在无重复接种的情况下可维持多年稳固免疫（Bohm et al., 2004; Jensen et al., 2015; Mitchell et al., 2012; Mouzin et al., 2004a; Schultz, 2006; Schultz et al., 2010）。

4.5 建立主动免疫后的复种频率与灭活/重组疫苗的差异

- 仔犬一旦建立主动免疫应答，后续复种**不必比每三年一次更频繁**（no more often than triennially）。
- 若核心疫苗在 26+ 周龄给予，则为使核心接种与年度健康检查同步（仅为委托方便），下一剂可在 **3 岁**给予（而非等到 3.5 岁）。
- 需强调：犬用**灭活（inactivated）核心病毒疫苗**提供的保护**不如 MLV 疫苗持久**；**重组（recombinant）核心犬用疫苗**提供的保护与 MLV 疫苗相似。原文随后写「A detailed comparison is beyond the scope of this document.」（本文件不作详细比较）。', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 1（续）·不推荐用于宠物犬的疫苗〔切片 007–008〕', '5. 表 1（续）·不推荐用于宠物犬的疫苗〔切片 007–008〕

表中分隔行标题：Vaccines not recommended for pet dogs（不推荐用于宠物犬的疫苗）。

| Vaccine | Puppies ≤16 weeks | Dogs >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| Canine parvovirus-2（CPV；killed 灭活，parenteral 注射） | 在已有 MLV 疫苗可用时，**不推荐**用于宠物犬的一般使用。抗 CPV-2 的 MLV 疫苗效力更强、诱导更长的免疫持续时间（duration of immunity, DOI）。部分 MLV 疫苗已被证明对妊娠母犬使用安全，查阅产品说明书以确认。若特定地区无安全的 MLV 疫苗，则使用灭活疫苗有其正当性 | 原文此处空缺 | 原文此处空缺 | 原文此处空缺 |
| Canine coronavirus（犬冠状病毒，CCoV；killed and MLV，注射） | **不推荐**。CCoV 是成年犬重要主要病原（primary pathogen）的证据薄弱。CCoV 感染相关的小狗腹泻通常轻微，且感染通常发生在幼龄仔犬，有时在首次接种之前。与犬细小病毒-2 的共感染（co-infection）可通过对细小病毒感染的强力防护来管理。没有证据表明现有 CCoV 疫苗能保护 against 该病毒不断出现且检出率不高的突变致病型（pantropic 泛嗜性或更高致病性毒株） | 原文此处空缺 | 原文此处空缺 | 原文此处空缺 |
| *Giardia* spp. vaccines（贾第鞭毛虫属疫苗） | **不推荐**。没有足够科学证据支持其使用。*Giardia duodenalis*（十二指肠贾第虫）感染不危及生命、对治疗有反应，且很少由仔犬或犬传给人。没有足够证据表明贾第虫疫苗能阻止贾第虫**卵囊（oocysts）**的排出。疫苗不能阻止感染，且已免疫犬可出现感染的临床症状 | 原文此处空缺 | 原文此处空缺 | 原文此处空缺 |
| *Microsporum canis* vaccines（犬小孢子菌疫苗） | **不推荐**。没有足够科学证据支持其使用 | 原文此处空缺 | 原文此处空缺 | 原文此处空缺 |

6. 正文·犬：免疫史不明的成年犬、狂犬病与犬钩端螺旋体病的"核心"定位〔切片 008〕', 'dog', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 免疫史不明或不完整的成年犬', '6.1 免疫史不明或不完整的成年犬

- 此类犬很常就诊接种。**单剂 MLV 核心疫苗极可能足以**在 26 周龄以上的宠物犬诱导免疫，并提供持久保护。
- 在高危情形（如疫情暴发 outbreaks）下，审慎的做法是考虑给予第二剂，间隔 2 至 4 周。
- 在狂犬病流行地区，也应接种狂犬病疫苗。多数狂犬病疫苗为灭活疫苗，但**免疫原性显著**；与许多其他灭活疫苗不同，**单剂即可免疫**。

6.2 犬狂犬病疫苗的时间表、法定复种与法律优先

- 世界部分地区的一项建议是在 **12 周龄**给予首剂狂犬病疫苗、**一年后再给第二剂**；不过某些国家本地生产的狂犬病疫苗推荐给药方案可能与此不同，应予遵循（Pimburage et al., 2017）。
- 犬狂犬病疫苗的复种间隔常由**法律强制规定**。狂犬病疫苗通常带有 1 年或 3 年的获许可 DOI。复种间隔应**首先依据当地法规**，在无法规时依据 datasheet 的 DOI 主张。
- 在法律规定与疫苗 datasheet 冲突的国家，**必须遵法**。本地生产的 1 年 DOI 狂犬病疫苗**不应被假定**可安全有效地用于三年一次。兽医应留意法律；但当其可获得已被证明提供至少 3 年免疫的产品时，国家兽医协会可考虑游说以修改当地法规使之匹配当前科学证据。', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 犬钩端螺旋体病疫苗何时列为核心', '6.3 犬钩端螺旋体病疫苗何时列为核心

- 在本指南中，若在该犬生活或前往的地区，犬钩端螺旋体病流行、涉案血清群已知、且有合适疫苗商品供应，则抗该病疫苗**现被视为核心疫苗**。即按本指南，此类疫苗在世界许多（但非全部）地区会被定为核心。
- 在少数被仔细研究的地区（例如南澳大利亚 South Australia），几乎无犬钩端螺旋体病发生的证据（Zwijnenberg et al., 2008）。遗憾的是，在世界许多地区尚未确定当地疫苗需含哪些血清群才能保护犬。若不确定应给予何种疫苗，则**不能**将某疫苗定为"核心"。
- 目前情况仍如此，尽有一些有趣且挑战既有范式的法国工作提示不同血清群成员之间可能存在一定程度的**交叉保护**（cross protection）（André-Fontaine & Triger, 2018）。
- 应热切期待"**泛保护（pan-protective）**"疫苗的商业开发（Chaurasia et al., 2022），此类疫苗或能保护犬免受绝大多数已知致病型所致钩端螺旋体病；若成功开发，将大幅扩展可将钩端螺旋体病疫苗视为"核心"的世界地区。
- 全球目前已有单价、双价、三价与四价抗犬钩端螺旋体病疫苗。它们分别含有属于 **Icterohaemorrhagiae、Canicola、Grippotyphosa、Pomona 与 Australis** 血清群的血清型（Francey et al., 2020; Klaasen et al., 2012, 2014; Schuller et al., 2015; Sykes et al., 2023; Wilson et al., 2013）。**四价疫苗提供更广的保护**。一般而言，这些疫苗激起强烈但短暂的抗体阳转（seroconversion）（Martin et al., 2014）；免疫（对强毒攻击的保护）持续时间远长于血清阳性期（可达 15 个月；Grosenbaugh & Pardo, 2018）。
- 灭活疫苗（如抗钩端螺旋体病疫苗）需**两剂**才能免疫。

7. 正文·宠物犬非核心疫苗〔切片 008〕

（原文此处「Non-­core vaccines for pet dogs」标题与上一句串行。）', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 总览', '7.1 总览

- 犬非核心疫苗的总结信息载于**表 1**。使用最广的犬非核心疫苗是抗**支气管败血波氏菌（*Bordetella bronchiseptica*）**与**犬副流感病毒（CPiV）**的疫苗。地理可得性更受限的其他非核心疫苗包括抗**伯氏疏螺旋体（*Borrelia burgdorferi*）**、**犬流感病毒（CIV）**与**婴儿利什曼原虫（*Leishmania infantum*）**的疫苗。
- 另有抗**犬疱疹病毒-1（CHV-1）**的亚单位疫苗，专门用于妊娠期的母犬。该疫苗已被证明可诱导血清阴性母犬**母体血清中和抗体**增加；此抗体经初乳（colostrum）被动转移，并被证明可保护仔犬在早期生命（<3 周）不受可能致死的感染（Poulet et al., 2001; Rota et al., 2020）。出生后吮乳不佳的仔犬将得不到良好保护（Larsen et al., 2015）。
- 非核心疫苗一般需要**每年**给予才能提供可靠保护。因此依本指南，成年犬可每年接种，但**各年所含成分不同**。提供特别持久保护者（如抗 CPV、CDV、CAV 的疫苗）可远低于其他疫苗的频次给予；许多犬中，抗 CPV、CDV、CAV 的疫苗每三年或更低频次接种，同时其他所需产品每年给予。
- **保护"中断"（lapse）的处理**：对非核心疫苗与钩端螺旋体病疫苗，若任保护中断（即该犬先前已正确免疫，但距上次接受该疫苗已有较长间隔），则作为预防措施建议"重新开始"，给予两剂、间隔 2 至 4 周。', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 呼吸道病原非核心疫苗', '7.2 呼吸道病原非核心疫苗

- 抗呼吸道病原的非核心疫苗**不能阻止感染**，但可减轻疾病严重度。抗 CPiV、*B. bronchiseptica* 与**犬腺病毒 2 型（CAV-2）**的疫苗以这三种抗原的不同组合形式供应：注射用（subunit *B. bronchiseptica* 亚单位；inactivated *B. bronchiseptica* 灭活；MLV CPiV）、鼻内（attenuated *B. bronchiseptica* 减毒，含或不含 CPiV 与 CAV-2）或口服（attenuated *B. bronchiseptica*，含或不含 CPiV）制剂。
- 注射给予的 CPiV 与 *B. bronchiseptica* 疫苗提供的保护水平可能不同于黏膜疫苗（Ellis, 2015）；有一些证据显示**鼻内途径与口服途径相比临床结局更优**（Ellis et al., 2016)（原文此处被 Wiley 水印从句中截断〔原文如此〕）。
- 以鼻内或口服疫苗接种的一小部分犬可出现**短暂**的咳嗽、喷嚏与眼或鼻分泌物（transient coughing, sneezing and ocular or nasal discharge）（Ellis et al., 2016; Scott-Garrard et al., 2018）。

7.3 犬流感病毒（CIV）

- **甲型犬流感病毒**（canine influenza A virus）亚型 **H3N8 与 H3N2** 已被记录为北美与东南亚国家犬只疾病的原因（Crawford et al., 2005; Klivleyeva et al., 2022; Payungporn et al., 2008; Song et al., 2008; Voorhees et al., 2017）。这些流感病毒引起与其他呼吸道病毒病原类似的呼吸道疾病，且因缺乏既存免疫，多数犬对感染易感。
- CIV 在社区中造成散发性暴发，尤其在共同饲养犬的设施，如收容所（shelters）、寄养犬舍、犬日托中心、犬展与犬场（dog farms）（Anderson et al., 2013; Lee et al., 2009; Parrish & Voorhees, 2019）。
- 因此，灭活的 H3N8 与 H3N2 CIV 疫苗**推荐用于因与其他犬混合接触而更可能暴露的犬**。与其他呼吸道病原疫苗类似，CIV 疫苗不阻止感染，但可减轻临床症状的严重度与持续时间（Deshpande et al., 2009）。CIV 疫苗目前**仅在 USA 可得**。', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 犬利什曼病（CanL）', '7.4 犬利什曼病（CanL）

- 在一些欧洲与拉丁美洲国家有抗 CanL 疫苗可得。CanL 疫苗**不能可靠阻止感染**，因此即使已免疫的犬仍可充当 *L. infantum* 的**储存宿主（reservoir）**，继续将疾病传播给其他犬与人（Fernandez Cotrina et al., 2018; Regina-Silva et al., 2016; Velez et al., 2020）。疫苗化可**预防部分犬的疾病临床征候**（同前引）。
- 抗 CanL 疫苗是有助于保护已暴露、且已在接受至关重要的局部驱避剂与杀虫剂（如项圈）治疗的犬的**额外工具**。', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 伯氏疏螺旋体（莱姆病）疫苗', '7.5 伯氏疏螺旋体（莱姆病）疫苗

- *Borrelia burgdorferi* 疫苗的使用**存在争议**（Littman et al., 2018）。**蜱控制被认为重要得多**。在莱姆病流行地区，预防其他蜱媒疾病至关重要，依赖速效体外杀虫剂的使用与对犬只蜱的常规检查；这也有助于预防莱姆病。
- **无莱姆病疫苗提供完全保护**。这些疫苗的功效不确定，且尚不清楚它们是否保护 against **莱姆性肾炎（Lyme nephritis）**——该病最严重的形式（O’Bier et al., 2021; Vogt et al., 2019; Vogt & Stevens, 2021）。
- 视地区而定，有若干菌苗（单价、双价、三价）与亚单位疫苗可用于犬莱姆病预防：一种重组、单价、非佐剂（non-adjuvanted）、脂化（lipidated）的 **OspA** 疫苗，以及另一种由 **OspA 与七种 OspC** 组成的嵌合重组疫苗（Grosenbaugh et al., 2018; Izac & Marconi, 2019; Littman et al., 2018; Marconi, Garcia-Tapia, et al., 2020a; Marconi, Honsberger, et al., 2020b; Vogt et al., 2019; Vogt & Stevens, 2021）（原文此处人名串行为 "Marconi, Garcia-­Tapia, et al." 与 "Marconi, Honsberger, et al."〔原文如此〕）。
- 一项关于北美犬 *B. burgdorferi* 疫苗功效的系统评价提示，已免疫犬出现临床征候的机会低于未免疫犬（Vogt et al., 2019）。ACVIM（美国兽医内科学院）犬猫莱姆疏螺旋体病共识更新的作者们**未能就**是否在 *B. burgdorferi* 流行地区的犬中推荐疫苗使用达成共识（Littman et al., 2018）。他们**确实一致同意**：患病或**蛋白尿（proteinuric）**的犬不应接种。

7.6 不推荐用于犬的疫苗（正文）

（原文此处「Not recommended vaccines for dogs」标题与正文串行。）

- 某些国家有商品供应但不推荐用于犬的疫苗总结信息载于表 1。抗**犬肠道冠状病毒（CCoV）**与**贾第虫（*Giardia duodenalis*）**的疫苗不推荐。
- 理由：CCoV 是导致成年犬肠道疾病的主要病原的证据薄弱；感染相关的小狗腹泻一般轻微；感染通常发生在幼龄仔犬，因此**在 6 至 12 周龄接种对预防许多感染为时已晚**。

8. 正文·犬不推荐疫苗之续与猫指南起始〔切片 009〕', '', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('2024年WSAVA犬猫疫苗接种指南·英文全典 · CCoV 与 Giardia 的补充理由', '8.1 CCoV 与 Giardia 的补充理由

- 此外，对 CCoV 的保护取决于肠道中**分泌型 IgA（secretory IgA）**的存在，而经注射途径接种的犬**不会**产生保护性的肠道 IgA 抗体应答（Decaro et al., 2004）。
- 没有证据表明现有疫苗能保护 against 偶有出现的该病毒突变致病型（**pantropic 泛嗜性毒株**）。
- 犬贾第虫疫苗已从**全球多数市场撤出**，但在部分国家仍有。*Giardia duodenalis* 感染不危及生命、对治疗有反应，且很少由仔犬或犬传给人（de Lucio et al., 2017; McDowall et al., 2011）。没有足够证据表明贾第虫疫苗能阻止卵囊排出；疫苗不阻止感染，且已免疫犬可出现临床征候。

8.2 猫疫苗接种指南·宠物猫核心疫苗总述

（原文此处「FELINE VACCINATION GUIDELINES」与「Core vaccines for pet cats」标题串入段落。）

- 不生活在收容所的猫的核心疫苗总结信息载于**表 2**。
- 在世界所有地区相关的猫核心疫苗是保护 against **猫泛白细胞减少症病毒（feline panleukopenia virus, FPV）**、**FHV（猫疱疹病毒，feline herpesvirus）**与**FCV（猫杯状病毒，feline calicivirus）**的疫苗。
- VGG 推荐：**6 至 8 周龄**给予首剂**三价**仔猫核心疫苗，此后**每 2 至 4 周一次直至 16 周龄或更大**，随后在 **26 周龄或更大**给予一剂；届时 MDA 可能已消退到足以让所有仔猫对疫苗产生应答。这些建议基于 MDA 干扰在某些仔猫中重要且持续的证据（DiGangi, Levy, et al., 2011b; Jakel et al., 2012）。
- 初次核心接种的剂次取决于开始接种的年龄与所选接种间隔。
- 关于在 26 周龄或更大接种（作为在约 1 岁接种的替代），**绝不互相排斥**，也不排除在约 1 岁时进行首次年度健康检查。

9. 表 2·宠物猫（非收容所）疫苗：核心〔切片 009〕

表 2 标题为 *Table 2. Vaccines for pet cats (non-shelter)*，列标题为 Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations。表中分组行（"Core vaccines for pet cats" 及各途径小标题行）其余列原文此处空缺。', '', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · FPV+FCV+FHV：注射、活减毒', '9.1 FPV+FCV+FHV：注射、活减毒

| Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| Feline panleukopenia virus（FPV）+ feline herpesvirus-1（FHV-1）+ feline calicivirus（FCV） | **不早于 6 周龄**开始，此后每 3 至 4 周复种直至 16 周龄。在特别高危的情形中，持续至 **20 周龄**并考虑每 2 至 3 周接种 | 一般推荐两剂间隔 2 至 4 周，尽管**单剂可预期保护多数猫** | 考虑在**约 6 月龄**复种，而非等到猫 12 至 16 月龄。这将缩窄任何早前未建立主动免疫应答仔猫的易感窗口。此后，"低危（low risk）"猫在 **3 岁**复种，且此后**不低于每 3 年一次** | **全球核心**。活减毒 FPV 成分提供快速、强效、持久的保护。对更高危的猫应考虑更频繁复种（最高至每年）。例如进入寄养猫舍或前往其他高应激、高危环境的猫，应在暴露前 **1 至 2 周**复种。**妊娠母猫与 <4 周龄仔猫不应**以活减毒疫苗接种。意外气雾化（aerosolisation）本疫苗或注射部位过度外漏（excessive leakage）后可见**上呼吸道疾病征候** |', 'cat', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · FPV+FCV+FHV：注射、灭活', '9.2 FPV+FCV+FHV：注射、灭活

| Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| Feline panleukopenia virus（FPV）+ feline herpesvirus-1（FHV-1）+ feline calicivirus（FCV） | 不早于 6 周龄开始，此后每 3 至 4 周复种直至 16 周龄。在特别高危情形中持续至 20 周龄并考虑每 2 至 3 周接种 | 两剂，间隔 2 至 4 周 | 考虑在约 6 月龄复种，而非等到 12 至 16 月龄（理由同上，缩窄易感窗口）。此后"低危"猫在 3 岁复种、每 3 年一次。**较高危猫建议每年复种** | **全球核心**。灭活注射 FPV 疫苗通常不提供如 MLV FPV 疫苗那样起效快、强效、持久的保护。**有非佐剂选择可得**。对妊娠母猫使用被认为比 MLV 疫苗更安全。**逆转录病毒（retrovirus）感染的猫不应回避接种**；在某些逆转录病毒感染的猫中灭活疫苗或优于 MLV 疫苗。**双价（bivalent，双毒株）灭活 FCV 疫苗**旨在提供更广的保护。对更高危的猫应考虑更频繁复种（最高至每年），例如进入寄养猫舍或前往其他高应激、高危环境的猫可在暴露前 1 至 2 周复种 |

9.3 FHV+FCV ±FPV：鼻内、活减毒

| Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| FPV+FHV+FCV 或 FHV+FCV | 遵循产品说明书 | 单剂 | 每年 | **鼻内 FPV 接种不如注射途径有效**。即使使用三价鼻内疫苗，也应**同时**给予注射（皮下）FPV 疫苗。使用后可见上呼吸道疾病征候。对 FHV 与 FCV **起效快**。鼻内与注射 FHV/FCV 疫苗同时使用可能提供增强保护。进入寄养猫舍或前往其他高应激、高危环境的猫可在暴露前 1 至 2 周复种 |', 'cat', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 狂犬病：重组与灭活〔切片 009〕', '9.4 狂犬病：重组与灭活〔切片 009〕

| Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| Rabies（canarypoxvirus-vectored recombinant，金丝雀痘病毒载体重组，non-adjuvanted 非佐剂，parenteral 注射） | **优先遵循当地法规**。若无法规，遵循产品说明书 | 优先遵循当地法规；若无法规，遵循产品说明书 | 按当地法规要求复种，或按获许可的**免疫持续时间（DOI）/产品说明书** | 在疾病流行地区为**核心** |
| Rabies（1 年与 3 年 DOI 灭活、加佐剂产品，注射） | 优先遵循当地法规；若无法规，遵循产品说明书 | 优先遵循当地法规；若无法规，遵循产品说明书 | 按当地法规要求复种，或按获许可 DOI/产品说明书 | 在疾病流行地区为**核心** |

9.5 猫白血病病毒（FeLV）：重组与灭活〔切片 009〕

| Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| FeLV（recombinant 重组，adjuvanted 加佐剂，注射） | 最早可自 **8 周龄**开始；第二剂于 3 至 4 周后给予 | 两剂，间隔 3 至 4 周 | 在初始系列末剂后 **1 年**复种；此后对**持续高暴露风险**接触其他 FeLV 感染猫的猫（室内或室外）**每年**复种 | 在 FeLV 感染流行地区生活的 **<1 岁幼猫**，以及有持续暴露风险的年长猫（例如在 FeLV 流行地区有定期、无人监管室外活动的成年猫），FeLV 疫苗为**核心**。**避免暴露是预防 FeLV 感染的最佳方式**。**只应接种 FeLV 阴性猫；接种前应做 FeLV 检测**。尚需进一步研究以确定持续有被潜在 FeLV 感染猫咬伤高危的成年猫应以何频次复种 |
| FeLV（inactivated 灭活，adjuvanted 加佐剂，注射） | 最早可自 8 周龄开始；第二剂于 3 至 4 周后给予 | 两剂，间隔 3 至 4 周 | 在初始系列末剂后 1 年复种；此后对持续高暴露风险接触 FeLV 感染猫的猫（室内或室外）每年复种；对接触潜在 FeLV 感染猫风险低的猫，按产品说明书（例如每 2 或 3 年）复种 | 原文此处空缺（评注并入上方 FeLV 条目） |', '', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫非核心疫苗：FIV〔切片 009〕', '9.6 猫非核心疫苗：FIV〔切片 009〕

| Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| Feline immunodeficiency virus（猫免疫缺陷病毒，FIV；killed 灭活，adjuvanted 加佐剂，注射） | 需**三剂**才能免疫。首剂最早在 8 周龄给予；随后两剂应以 **2 至 3 周**间隔给予 | 需三剂，每剂间隔 2 至 3 周 | 初始系列末剂后 1 年单剂，此后对被判定为**持续暴露风险**的猫每年一次 | **避免暴露是预防 FIV 感染的最佳方式**。本疫苗目前仅在 **Japan、Australia 与 New Zealand**（日本、澳大利亚、新西兰）可得。关于其功效的报道差异很大。接种会诱产生用于**感染诊断**的抗体；然而某些临床实践用（in-practice）诊断试剂盒可可靠区分已免疫未感染猫与感染猫。经验证、可靠的 **PCR（聚合酶链反应）诊断试验**也正更广泛可得 |

10. 正文·猫：狂犬病、FPV/FCV/FHV 保护性质与复种频率〔切片 009–010〕

10.1 狂犬病

- 在狂犬病流行地区，VGG 推荐**所有猫**接种狂犬病疫苗以同时保护宠物与人，**即使立法并未对猫作此要求**。
- 猫用获许可狂犬病疫苗一般有 1 年或 3 年 DOI 主张。复种频率应首先依据当地法规，无法规时依据 datasheet DOI 主张。', '', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 三大猫核心成分的保护并不等同', '10.2 三大猫核心成分的保护并不等同

- 犬三种全球相关核心疫苗成分（CPV、CDV、CAV）在正确使用时都提供强且持久的保护（Schultz et al., 2010）；**相比之下，核心 FCV 与 FHV 疫苗成分提供的保护不及 FPV 疫苗**。
- FCV 疫苗产生针对 FCV 多毒株的**一定程度交叉保护免疫**，但完全免疫的成年动物仍可能发生感染与疾病（Pedersen et al., 2000; Schorr-Evans et al., 2003）。
- **没有能阻止感染的 FHV 疫苗**。感染常导致病毒在神经组织中**潜伏（latent）**，并可能在应激期间**再激活（reactivation）**（Maes, 2012; Richter et al., 2009）；再激活的病毒可在已免疫动物引起临床征候，或排出给易感动物并使之发病。
- 对 MLV 核心疫苗产生应答的猫，在无重复接种的情况下对 **FPV** 维持多年稳固免疫；而**对 FCV 与 FHV 的免疫仅为部分（only partial）**（Jas et al., 2015），并可能被寄养应激削弱（Gourkow et al., 2014; Gourkow & Phillips, 2015）（切片 009 末与 010 首由此跨切片接续）。', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 成年猫的复种频率、二价疫苗与灭活疫苗持久性〔切片 010〕', '10.3 成年猫的复种频率、二价疫苗与灭活疫苗持久性〔切片 010〕

- VGG 对成年**"低危"猫**（独居、室内、不访问寄养猫舍的动物）的建议是以 **MLV 核心疫苗、间隔 3 年或更长**复种。对"较高危"猫，为保护 against FCV 与 FHV，更频繁复种（最高至每年）可能是必要的，包括定期访问寄养猫舍或与其他潜在感染猫有接触者。
- 对寄养的猫，可在每年主要寄养行程前 **1 至 2 周**给予 FCV/FHV 疫苗（Gaskell et al., 2007; Stone et al., 2020）。
- 在一些国家，除较典型的三价 FPV/FCV/FHV 疫苗外，**双价 FCV/FHV 疫苗**有商品供应。这些双价疫苗使兽医能对较高危猫每年接种 FCV/FHV、而对 FPV 每三年或更低频次接种。
- 一些国家有鼻内 MLV FPV/FHV/FCV 与 FHV/FCV 疫苗可得（Lappin, Sebring, et al., 2006b; Reagan et al., 2014）。**上述关于复种频率的建议适用于 MLV 疫苗**。
- 灭活 FPV 疫苗通常不提供如 MLV FPV 疫苗那样持久的保护。灭活 FCV 与 FHV 疫苗经实验证明提供**持久的部分保护**（long-lasting, partial protection）（Scott & Geissinger, 1997, 1999）；但该研究环境极为稳定、猫体验上大概率为"低应激"，与典型寄养猫舍情形不同。', 'cat', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · FeLV 在本版被定为部分地区核心〔切片 010〕', '10.4 FeLV 在本版被定为部分地区核心〔切片 010〕

- 在本版指南中，VGG 决定在**已知有 FeLV 相关疾病发生的地区**将 FeLV 疫苗定为**核心**。
- 在这些地区，该定位适用于幼猫（<1 岁）以及有室外活动或与有室外活动其他猫同养的年长猫。
- 世界有些地区 FeLV 感染已知罕见、FeLV 相关疾病仅在进口猫中极偶被诊断（Westman, Paul, et al., 2016b）。因成功控制项目，许多地区的 FeLV 暴露与感染已显著减少（Studer et al., 2019）。**这不应成为自满的理由**，因为改善速率可能已趋平缓。
- VGG 完全支持**依据生活方式与个体猫感知暴露风险**使用 FeLV 疫苗。在许多 FeLV 感染仍然流行的地区，任何 <1 岁的猫都应通过常规接种获得保护。在这些地方，FeLV 疫苗应在幼猫以及接触室外环境的年长猫中被视为核心。
- 若年长猫被允许无人监管地到室外，则需要保护：**咬伤是成年猫中日益被认识的 FeLV 传播方式**（Little et al., 2020）。
- 需进一步研究以确定有在室外被咬伤风险的成年猫应以何频次复种 FeLV。支持成年猫 FeLV **两年或三年**复种的攻击试验（challenge studies）并非为直接证明对经咬伤传播 FeLV 的长期保护而设计。
- 每次年度健康检查都应权衡 FeLV 接种的成本、风险与潜在收益，**除 FeLV 感染已知极其罕见的地区外**。**只应接种 FeLV 阴性猫**。', 'cat', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 2（续）·猫非核心疫苗与不推荐疫苗〔切片 010〕', '11. 表 2（续）·猫非核心疫苗与不推荐疫苗〔切片 010〕

| Vaccine | Kittens ≤16 weeks | Cats >16 weeks | Revaccination | Comments and recommendations |
|---|---|---|---|---|
| *Chlamydia felis*（猫衣原体；avirulent live 无毒活苗，non-adjuvanted 非佐剂，注射）／*Chlamydia felis*（killed 灭活，adjuvanted 加佐剂，注射） | 首剂最早在 **9 周龄**给予；第二剂于 2 至 4 周后给予 | 给予两剂，间隔 2 至 4 周 | 对持续暴露风险的猫需**每年**加强 | 接种最适合作为**多猫环境**控制方案的一部分，用于与临床疾病相关的感染已被确认的场所。据报道，活疫苗意外**结膜接种（conjunctival inoculation）**可引起临床疾病 |
| *Bordetella bronchiseptica*（avirulent live 无毒活苗，non-adjuvanted 非佐剂，**intranasal 鼻内**） | 最早在 **4 周龄**鼻内给予单剂 | 鼻内给予单剂 | 对持续暴露风险的猫需每年加强 | **不常规用于宠物猫**。对饲养于异常大型猫群（unusually large colonies）的宠物猫可考虑使用 |
| 分组行：Vaccines not recommended for pet cats（不推荐用于宠物猫的疫苗） | 其余列原文此处空缺 | | | |
| Feline infectious peritonitis（猫传染性腹膜炎，FIP；live attenuated 活减毒，non-adjuvanted 非佐剂，**intranasal 鼻内**） | **没有足够科学证据支持对该疫苗作出广泛使用推荐**。本疫苗标注用于自 **16 周龄**的仔猫。它含一种**温度敏感（temperature-sensitive）**活病毒，可在鼻腔复制但在更高核心体温下不能复制，这对疫苗安全性重要。按可用的有限研究，**仅在接种时已知为猫冠状病毒抗体阴性（antibody-negative）的猫**才可能产生某种程度的保护，而猫在 16 周龄或更大时冠状病毒抗体阴性并不常见。此外，本疫苗所含病毒毒株与一些充分研究地区发现的临床重要毒株不同 | 原文此处空缺 | 原文此处空缺 | 原文此处空缺 |
| *Giardia* spp. vaccines（贾第鞭毛虫属疫苗） | 没有足够科学证据支持其使用 | 原文此处空缺 | 原文此处空缺 | 原文此处空缺 |
| *Microsporum canis* vaccines（犬小孢子菌疫苗） | 没有足够科学证据支持其使用 | 原文此处空缺 | 原文此处空缺 | 原文此处空缺 |', '', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 正文·猫：FeLV 产品谱、免疫史不明成猫与非核心疫苗〔切片 010〕', '12. 正文·猫：FeLV 产品谱、免疫史不明成猫与非核心疫苗〔切片 010〕

12.1 FeLV 疫苗类型与保护边界

- 有多种 FeLV 疫苗可得，包括**灭活全病毒**与**亚单位**疫苗（两者均加佐剂），以及一种**重组、病毒载体（减毒金丝雀痘病毒）、非佐剂**产品。
- 这些疫苗提供针对**进展性（progressive）FeLV 感染**及相关疾病的保护，但**可能不能保护 against FeLV 感染的所有结局**（Little et al., 2020）。

12.2 免疫史不明或不完全的成年猫

- 此类猫很常就诊接种。**单剂 MLV FPV 疫苗**对绝大多数 26 周龄以上的宠物猫即足以诱导持久免疫。
- 然而，含 FPV、FHV 与 FCV 的 MLV 疫苗多数制造商推荐**两剂，间隔 2 至 4 周**。鉴于 MLV FHV 与 FCV 疫苗效力不及 MLV FPV 疫苗，VGG **支持**该推荐。
- 重要的是，若使用**灭活核心疫苗（FPV、FHV、FCV、FeLV）**，建议给予**两剂**以完成免疫。', 'cat', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫非核心疫苗综述（C. felis、B. bronchiseptica、FIV）', '12.3 猫非核心疫苗综述（C. felis、B. bronchiseptica、FIV）

（原文此处「Non-­core vaccines for pet cats」标题串入段落。）

- 猫非核心疫苗包括保护 against ***Chlamydia felis*（猫衣原体）**、***Bordetella bronchiseptica***（支气管败血波氏菌）与**猫免疫缺陷病毒（FIV）**的疫苗。总结信息载于表 2。
- 抗 *C. felis* 疫苗对感染与疾病提供**不完全保护**。可推荐用于该病原已知曾致病的多猫家庭中的猫。有活减毒与灭活加佐剂注射疫苗可得；可在 **8 至 9 周龄**幼猫使用，第二剂于 2 至 4 周后给予，并对持续暴露风险的成年猫每年加强。
- 某些国家供应的猫用 *B. bronchiseptica* 疫苗可考虑用于高危情境下的猫，例如饲养在大型猫群中的猫。该疫苗为减毒**鼻内**产品，可对 4 周龄以上仔猫单次使用，并每年加强。
- **史上仅有一种 FIV 疫苗曾获许可**。它**从未在欧洲获许可**，并于 **2017 年退出 USA 与 Canada 市场**；目前仍在 **Japan、Australia 与 New Zealand** 可得。
- 虽然已显示该疫苗对实验性**异源（heterologous）**FIV 攻击的功效，但关于它能否对不同地理区域的众多 FIV 亚型有效交叉保护，长期存在争论（Beczkowski et al., 2015; Coleman et al., 2014; Dunham et al., 2006; Hosie et al., 1995; Stickney et al., 2020; Westman et al., 2022; Yamamoto et al., 2007）。实验研究结果相互矛盾，一些显示强保护，另一些显示无保护。
- 澳大利亚开展了一项设计优良的回顾性**田间研究**（Westman, Malik, et al., 2016a），所发表研究报告已免疫猫的**保护率为 56%**；然而该研究**缺乏统计学效力**，置信区间极大（**20 至 84%**），且已免疫与未免疫猫感染率之差**无统计学显著性**。较近的一项田间研究在新西兰情境下显示疫苗未能提供保护（Stickney et al., 2020）。这两项研究都未在该疫苗的两个不同田间情境中提供关于其有效或无效的有力证据，需进一步研究。
- 在此期间，VGG 决定**继续将唯一商业可得的 FIV 疫苗归类为"非核心"**。保护猫免受 FIV 感染最有效的方式，是**限制其无人监管的室外活动**，因为在室外它们有被 FIV 感染猫咬伤的风险；然而部分主人无法被说服以限室内或受保护室外围场来保护其猫。
- **诊断干扰**：不久前，该 FIV 疫苗的使用曾使 FIV 感染诊断复杂化，因为接种导致抗体产生，而抗体存在通常被用于诊断 FIV 感染（Westman et al., 2022）。幸运的是，有商业可得的临床实践用抗体检测试剂盒可区分 FIV 感染与未感染猫，只要**不在接种后不久**检测（Westman et al., 2017）。用于 FIV 感染诊断的**PCR 检测**也已更可靠、更广泛可得（Nichols et al., 2017）。
- **FIV 疫苗方案**：该疫苗为灭活、加佐剂产品，可对自 8 周龄的仔猫给予，随后两针间隔 2 至 3 周，之后在第 12 个月注射一针；此后对持续暴露风险的猫每年复种。鉴于该疫苗提供不完全保护的很大可能，**每年重新检测（annual retesting）**是必要的。**只应接种未感染猫**。', 'cat', 'young', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 多联产品可得性与免疫抑制猫', '12.4 多联产品可得性与免疫抑制猫

- VGG 知悉在一些国家，猫仅有含核心与非核心疫苗组合的多联产品可得，并**鼓励制造商**在可能范围内提供完整疫苗谱，或至少提供**仅核心**组合，用于非核心疫苗使用无正当理由的情形。
- 关于免疫受损（immunocompromised）猫接种的建议近期已在一篇优秀综述中给出（Hartmann et al., 2022）。

13. 正文·不推荐用于猫的疫苗〔切片 011〕

（切片 011 首行为孤立 Wiley 下载水印〔原文如此〕，随后进入本节。）

- 某些有商品供应但不推荐用于猫的疫苗总结信息载于表 2。抗**猫传染性腹膜炎（FIP）**的疫苗**不推荐用于猫**。
- 理由：该 FIP 疫苗诱导临床相关保护的证据不足；仅在接种时已知为猫冠状病毒抗体阴性的猫才可能产生某种程度的保护；该疫苗标注自 16 周龄给予，但**许多仔猫在此年龄之前已感染冠状病毒**；此外，该疫苗含 **FIP 病毒血清型 II（serotype II）**毒株，**不对血清型 I 诱导交叉反应性保护，而血清型 I 是美洲与欧洲流行的毒株**。
- 旨在保护猫免受 ***Giardia* spp.** 与 ***Microsporum canis*** 的疫苗（在世界部分地区可得）也**不推荐**，因为没有足够科学证据表明它们提供收益。

14. 收容所与庇护所中犬猫的疫苗接种〔切片 011〕

（原文此处大写标题「VACCINATION OF DOGS AND CATS IN SHELTERS AND SANCTUARIES」串入段落。）

14.1 两类机构与总体风险

- 收容无家可归动物的机构有两类基本类型：**传统收容所（traditional shelters）**，在安置入家庭前提供临时寄居；**庇护所（sanctuaries）**，动物终身留居。
- 传统收容所群体周转率更高、居住期短、动物不断进出。庇护所群体更稳定，基于长期居住与低周转。两类机构的平均群体规模都可从数十只到数百只。
- 两类机构都接收来自社区的随机来源动物，其中多数此前无任何兽医照护，这**显著增加**传染性疾病传入与传播、以及建立起地方性（endemic）疾病的风险。
- 收容所中的高疾病暴露风险要求**强有力的疫苗项目**，不仅保护每只个体，也保护整个群体。**在低暴露风险家庭环境中对个体动物最有利做法，并不适用于高风险的收容所环境。**', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 引用《收容所兽医协会照护标准指南》', '14.2 引用《收容所兽医协会照护标准指南》

- 依 *Association of Shelter Veterinarians'' Guidelines for Standards of Care in Animal Shelters, 2nd Edition*（收容所兽医协会 [Association of Shelter Veterinarians, ASV] 动物收容所照护标准指南第 2 版）（The Association of Shelter Veterinarians, 2022）原文引述（照录）：
  > "Shelter vaccine protocols differ from protocols used in private practice because shelter animals are subject to an increased risk of infectious disease… Key differences in [shelter vaccine] protocols compared to those recommended in private practice include an earlier and longer age range for juveniles, a shorter time span between vaccines, and different core and noncore products."
  （译文：收容所疫苗方案不同于私人执业所用方案，因为收容所动物面临更高的传染病风险……与私人执业推荐方案相比，〔收容所疫苗〕方案的关键差异包括未成年动物的起始年龄更早、适用年龄范围更长、疫苗间隔更短，以及核心与非核心产品不同。）
- 对收容所而言，决定接种哪些疫苗、哪些动物接受、何时接受的**风险评估是针对整个群体进行的，而非仅针对每只个体**。

14.3 最佳实践收容所疫苗项目的三个要素（原文以项目符号列出）

保护个体与整个群体的三个关键要素：

- **在入院时为所有动物接种核心疫苗**（Vaccinate all animals at admission with core vaccines）；
- **使用能快速诱导保护的疫苗**（Use vaccines that induce rapid protection）；
- **在 1 月龄开始未成年动物的初次接种，并在收容所期间每 2 至 3 周重复，直至 5 月龄**。', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所病原学与入院抗体本底', '14.4 收容所病原学与入院抗体本底

- **CDV、CPV 与 FPV** 常在收容所的犬猫引起危及生命的疾病。每个收容所都是这些病原的高危暴露环境，多数曾受代价高昂的疫情（暴发）影响，表现为动物痛苦与死亡。
- 虽然 CDV、CPV 与 FPV 感染致死率最高，但**传染性呼吸道疾病是收容所中最常发生的疾病形式**。
- ***B. bronchiseptica*、CAV-2、CPiV 与 CDV** 是收容所犬中流行的呼吸道病原（Day et al., 2020; Lavan & Knesl, 2015; Monteiro et al., 2016; Schulz et al., 2014; Sowman et al., 2018）。**FHV 与 FCV** 是在收容所猫中检出最多的呼吸道病原（Bannasch & Foley, 2005; McManus et al., 2014）。
- 在美国的收容所中，**多数 6 月龄以下的仔犬仔猫，以及 30% 至 50% 的成年犬猫**，在入院时对 CDV、CPV、FPV、FHV 与 FCV **几乎没有或完全没有可检出抗体**（DiGangi et al., 2012; Fischer et al., 2007; Lechner et al., 2010; Litster et al., 2012）。这表明许多动物入院时对最常见疾病防护不足。
- 因此，**尽可能早为尽可能多的个体免疫**是收容所疾病控制的首要之事。其基石是**在入院时立即为所有犬猫接种**。仅 1 天的延迟即可显著增加感染风险与群体内疾病传播（Bannasch & Foley, 2005）；接种疫苗的延迟对收容所动物的后果大于典型家庭中的动物。', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所犬猫核心疫苗总述', '14.5 收容所犬猫核心疫苗总述

（原文此处小标题「Core vaccines for shelter dogs and cats」串入段落。收容所犬核心疫苗总结信息载于**表 3**，收容所猫载于**表 4**。）

- **改良活疫苗（modified-live vaccines）被认为是收容所的首选疫苗**，因为它们一般被认为比灭活疫苗**起效更快、并更早突破 MDA 干扰**，而这些因素在入院后很可能很快发生暴露时很重要（DiGangi et al., 2012; Fischer et al., 2007; Jas et al., 2009; Lappin, 2012; Lappin et al., 2009; Patterson et al., 2007）。
- **收容所犬的核心疫苗**包括改良活 **CDV、CPV、CAV-2、CPiV 与 *Bordetella bronchiseptica***。**收容所猫的核心疫苗**为改良活 **FPV、FHV 与 FCV**。
- 以改良活核心疫苗在**摄入时（on intake）**对全部犬猫进行的接种应具**全面性**，包括：流浪动物、主人放弃（owner-surrendered）的宠物、因狂犬病检疫而被扣押（impounded）的动物、虐待案件动物、妊娠或哺乳动物、患轻症或受伤的动物，以及为**诱捕-绝育-放归（trap-neuter-release, TNR）**或**归野（return-to-field, RTF）**项目收容的社区犬猫。
- 虽然以某些改良活疫苗为典型家庭中妊娠、患病或受伤的宠物接种并不被建议，但在收容所环境中这些疫苗提供的快速保护，**超过**对胎儿或动物本身造成伤害的风险。简言之，**若某犬或猫不能在入院时安全接种改良活核心疫苗，则该动物留在收容所的感染风险过大**。
- 出于财务原因，收容所可能只给可能被领养的犬猫接种、而不给面临安乐死风险者接种。**将接种限于可领养动物会制造庞大的易感动物池**，随后出现地方性疾病与疫情，其代价高于疫苗成本。
- **家庭环境**的仔犬仔猫接种通常自 6 至 8 周龄开始，每 3 至 4 周重复，直至**至少 4 月龄**；相比之下，**收容所**进入的仔犬仔猫接种**自 1 月龄开始**，每 **2 至 3 周**重复，以尽可能少的延迟突破母源抗体干扰。
- 已显示**多达 37% 的仔猫**（仔犬中比例不确定）在 **4 月龄之后**仍有持续性的母源抗体干扰其对一种或多种核心疫苗的应答（Carmichael, 1983; Dawson et al., 2001; DiGangi et al., 2012; Jakel et al., 2012; Johnson & Povey, 1985; Kruse et al., 2010; Pollock & Carmichael, 1982; Reese et al., 2008）。因此基于** precautionary principle（预防性原则）**，收容所兽医建议收容所仔犬仔猫的核心疫苗接种应**持续至 5 月龄**。
- 预防性原则同样是对收容所内 **5 月龄以上犬给予两剂改良活核心疫苗、间隔 2 至 3 周**这一建议的基础。
- ***B. bronchiseptica* ± CPiV 疫苗**对家庭环境犬是非核心疫苗，但因暴露与传播风险高并随之广泛致病，**对收容所犬为核心疫苗**。**所有成年犬以及至少 3 周龄的仔犬**应在入院时接种含改良活 *B. bronchiseptica* 及改良活……的**鼻内**疫苗（切片 011 此处句子被水印截断，续文见切片 012〔原文如此〕）。', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 3·收容所犬核心疫苗〔切片 011〕', '14.6 表 3·收容所犬核心疫苗〔切片 011〕

表 3 标题为 *Table 3. Core vaccines for dogs in shelters*，列标题为 Vaccines | <5 months old | ≥5 months old | Comments。

| Vaccines | <5 months old（<5 月龄） | ≥5 months old（≥5 月龄） | Comments |
|---|---|---|---|
| CDV+CAV+CPV+CPiV（MLV，parenteral 注射）；重组 CDV 联合 MLV CAV+CPV+CPiV（注射） | **入院时立即接种，自 1 月龄开始**；每 2 至 3 周重复直至 5 月龄 | 入院时立即接种；2 至 3 周后重复 | 使用含改良活病毒的联合疫苗或重组 CDV，以获得更快的免疫起效 |
| *Bordetella bronchiseptica* + CPiV（modified-live 改良活，intranasal 鼻内）；*B. bronchiseptica* + CPiV + CAV（改良活，鼻内） | 入院时立即接种，自 **3 周龄**开始 | 入院时立即接种 | 含改良活 *B. bronchiseptica* 及至少 CPiV 的鼻内疫苗因能快速起效达最佳免疫而被优先选择。它们可早至 3 周龄给予 |
| *B. bronchiseptica*（改良活，oral 口服）；*B. bronchiseptica* + CPiV（改良活，口服） | 入院时立即接种，自 **7 或 8 周龄**开始，取决于所选疫苗 | 入院时立即接种 | 口服疫苗可用于 7 或 8 周龄及以上的犬，但更年幼者**必须**使用鼻内疫苗 |
| **Rabies Virus（狂犬病病毒；inactivated 灭活，parenteral 注射）** | **遵循当地法律规定的最小接种年龄**。短住型收容所在**出院时**给予，长住型收容所在**入院时**给予 | 原文此处空缺 | **仅狂犬病流行国家**。按当地法律给予 |
| 缩写说明行（表末） | CDV Canine distemper virus（犬瘟热病毒）、CAV Canine adenovirus type 2（犬腺病毒 2 型）、CPV Canine parvovirus type 2（犬细小病毒 2 型）、CPiV Canine parainfluenza virus（犬副流感病毒）、MLV Modified live virus（改良活病毒）〔原文以逗号串列，无分隔〕 | | |', 'dog', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 表 4·收容所猫核心疫苗〔切片 011〕', '14.7 表 4·收容所猫核心疫苗〔切片 011〕

表 4 标题为 *Table 4. Core vaccines for cats in shelters*，列标题为 Vaccines | <5 months old | ≥5 months old | Comments。

| Vaccines | <5 months old（<5 月龄） | ≥5 months old（≥5 月龄） | Comments |
|---|---|---|---|
| FPV+FHV+FCV（MLV，parenteral 注射） | **入院时立即接种，最早可自 1 月龄开始**；每 2 至 3 周重复直至 5 月龄 | 入院时立即接种；2 至 3 周后重复 | 使用含改良活病毒的联合疫苗以获得快速免疫起效 |
| FPV（MLV，intranasal 鼻内） | 原文此处空缺 | 原文此处空缺 | **鼻内 FPV 疫苗不推荐用于收容所**，因它们不提供针对 FPV 的可靠保护 |
| FHV+FCV（MLV，鼻内） | 原文此处空缺 | 原文此处空缺 | 含改良活 FHV+FCV 的鼻内疫苗可用于更快的免疫起效 |

（切片 011 在表 4 第 3 行处结束；收容所疫苗后续内容、狂犬病疫苗行完整措辞等承接切片 012，见 08- 整理稿。）', '', '', '', '疫苗,本稿范围、起点与切片残留说明', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（二）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所/庇护所犬猫疫苗接种（承接上半部分的表 4 尾行与正文）', '> 本稿为该英文全典**后半部分**（抽取分块 012–022）的中文整理稿；前半（001–011）见同目录 `06-` 文件。英文原版由 Wiley 在线图书馆下载，页脚带下载水印与版权行，本稿照录相关残留并标注〔原文如此〕。

1. 收容所/庇护所犬猫疫苗接种（承接上半部分的表 4 尾行与正文）

> 本节为分块 012 开头部分，紧接前半（011）的表 4"收容所中猫的核心疫苗"。分块 012 从表 4 的最后一行（狂犬病行）及其缩写注开始，随后是收容所操作正文、收容所非核心疫苗，以及"同期接种与绝育"的论述。

1.1 表 4（收容所中猫的核心疫苗）末行与缩写注（照录）

| 疫苗 | ≤5 月龄 | >5 月龄 | 注释 |
|------|---------|---------|------|
| 狂犬病病毒（灭活，肠外）〔Rabies Virus (inactivated, parenteral)〕 | 遵守当地法律规定的最低接种年龄；短期寄养收容所在出院时接种，或长期庇护所在入院时接种 | 原文此处缺失 | 仅限狂犬病流行国家，按当地法律或法规管理 |

缩写注（原文）：FPV 猫泛白细胞减少症病毒（Feline panleukopenia virus）、FHV 猫疱疹病毒-1（Feline herpesvirus-1）、FCV 猫杯状病毒（Feline calicivirus）、MLV 改良活病毒（Modified live virus）。

〔原文如此〕表 4 其余各行（FPV+FHV+FCV 等）在前半 011 分块，此处缺失。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所黏膜疫苗与肠外疫苗要点', '1.2 收容所黏膜疫苗与肠外疫苗要点

- 所有成年犬和至少 3 周龄幼犬在入院时接种**鼻内**改良活支气管败血鲍特菌（*Bordetella bronchiseptica*）联合改良活 CPiV 疫苗，可在 **3 至 7 天内**诱导针对两种病原体的快速黏膜免疫应答，显著减少临床疾病与病原体脱落（Ellis 2016、2017；Jacobs 2007；Kontor 1981；Larson 2013）。
- 无法使用鼻内疫苗时，**口服**支气管败血鲍特菌疫苗可用于成年犬及至少 **7 或 8 周龄**幼犬（取决于所选疫苗）；在一些国家该口服疫苗也含 CPiV。
- 研究显示口服疫苗几乎与鼻内疫苗同样有效，两者均优于含细胞抗原提取物的肠外灭活支气管败血鲍特菌疫苗。**鼻内和口服疫苗只需在接收时接种一次**，因其不被母源抗体灭活，并提供 **13 个月的免疫持续时间（duration of immunity, DOI）**（Jacobs 2005；Scott-Garrard 2020）。
- 对收容所犬在入院时接种含改良活犬瘟热病毒（canine distemper virus, CDV）、犬腺病毒 2 型（canine adenovirus 2, CAV-2）、犬副流感病毒（canine parainfluenza virus, CPiV）的肠外疫苗，并联合鼻内改良活支气管败血鲍特菌 + CPiV 疫苗，与呼吸道疾病发生率降低相关（Andrukonis 2021）。
- 收容所猫**必须**使用含改良活猫泛白细胞减少症病毒（feline panleukopenia virus, FPV）的肠外疫苗，以对该病原体快速产生强健免疫。部分国家有含猫疱疹病毒-1（feline herpesvirus-1, FHV）与猫杯状病毒（feline calicivirus, FCV）的鼻内改良活疫苗，可在 **4 至 6 天内**诱导快速保护，有利于收容所猫（Edinboro 1999；Lappin, Sebring 等 2006b）。
- 狂犬病病毒是狂犬病流行地区收容所犬猫的核心疫苗。动物短期停留的收容所，建议在**收养时**接种以助确保符合当地狂犬病接种要求；所有居住于庇护所或预计停留数月的犬猫，应在入院时按当地法律接种狂犬病疫苗；长期收容所和庇护所中犬猫的复种应遵守当地法律。', '', 'young', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 收容所犬猫的非核心疫苗', '1.3 收容所犬猫的非核心疫苗

- **犬**：伯氏疏螺旋体（*Borrelia burgdorferi*，莱姆病）疫苗、钩端螺旋体病（leptospirosis）疫苗、H3N8/H3N2 犬流感（canine influenza）疫苗属非核心，在收容所内**限制使用**。若基于当地社区或收容所群体内已记录病例判定暴露风险高，应按厂商说明书为收容所每只犬及入院新犬启动基础免疫系列。短期收容所中许多犬在完成基础免疫系列前即离开，应鼓励收养者携犬与兽医完成后续接种。存在重大暴露风险时，应将伯氏疏螺旋体、钩端螺旋体病或犬流感病毒（canine influenza virus, CIV）疫苗纳入终生居留庇护所（如庇护所）或预计停留数月的犬的接种计划。
- **猫**：猫白血病病毒（feline leukaemia virus, FeLV）疫苗对收容所猫为非核心。根据 2020 年 AAFP 猫逆转录病毒检测和管理指南（Little 等, 2020），**所有猫在接种 FeLV 疫苗前应检测 FeLV 感染**——原文引述："若某已接种猫的状态未知、后来发现其 FeLV 感染，疫苗效力将受质疑并被疑为疫苗失败。猫应在初次接种前检测 FeLV 感染。" 资源充足的收容所可对每只未感染猫检测并接种；但资源较差收容所中**单独饲养的猫**因病毒传播风险低，无需 FeLV 检测与接种，应建议收养者与兽医讨论。群养猫的收容所中，FeLV 检测对甄别未感染猫入组至关重要；群养猫 FeLV 接种取决于停留时长——推荐用于长期居留收容所或庇护所中群养猫，**不推荐**用于短期收容所中群养猫。这些收容所未接种猫的收养者可依猫在新家的生活方式与兽医讨论是否接种。
- 支气管败血鲍特菌与猫支原体（*C. felis*，即 *Mycoplasma felis*，原文简写作 *C. felis*〔原文如此〕）疫苗对收容所猫为非核心，因这些细菌感染是呼吸道感染的较少见原因。当收容所中有因确诊支气管败血鲍特菌感染致肺炎的咳嗽猫时，应使用鼻内改良活支气管败血鲍特菌疫苗（Williams 2002）：在此情形下，应在入院时对**所有至少 1 月龄的猫**在数月期间接种鼻内改良活疫苗，以累积群体免疫力并阻断传播。同样，在已确诊猫支原体感染致病的收容所，猫支原体疫苗可作为感染控制计划的一部分。犬猫之间可发生支气管败血鲍特菌的**种间传播**；有猫支气管败血鲍特菌问题的收容所，若同时养有犬或员工同时接触犬猫，应考虑种间传播的可能。
- 在收容所及诱捕-绝育-放归（trap-neuter-return, TNR）或重返家园（return-to-field, RTF）计划中，**同时接种疫苗与绝育**的做法很普遍。虽然理想上应将接种与绝育等操作分开，但多项研究表明麻醉与手术不会显著削弱对疫苗接种的抗体应答（Fischer 2007；Kelly 1980；Miyamoto 195；Reese 2008）。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗接种后不良事件（adverse events following vacci', '2. 疫苗接种后不良事件（adverse events following vaccination, AEFVs）

2.1 定义与表现（正文，非 FAQ）

- 不良事件（adverse event）是疫苗接种后产生的有害的、意外的后果，**包括缺乏保护**；包括任何超敏反应、疾病、损伤或明显的毒性作用。
- 局部反应如注射部位疼痛和肿胀、全身反应如嗜睡、厌食、发热和呕吐较常观察到；荨麻疹与过敏反应（anaphylaxis）较少见；猫注射部位肉瘤（feline injection-site sarcoma, FISS）等更严重后果罕见〔正文此处未列更严重清单，仅在 FAQ 中举例〕。

2.2 报告义务与漏报

- 即使仅**疑似**与疫苗接种相关，也应报告 AEFVs。每份报告应注明：所涉疫苗产品（**包括批号**）、涉及动物的详细信息、不良事件的详细信息、提交报告兽医的联系方式。
- 兽医报告的现场观察是使**厂商与监管机构**警觉潜在疫苗安全或效力问题最重要的方式。注册前安全性研究仅能检出相对常见的不良事件；罕见不良事件通过上市后监测与对已报不良事件的分析发现。
- 报告应发送给**厂商和当地监管机构**。一些国家尚无政府监测计划，故只能报告给厂商。VGG 认识到存在 AEFVs 的**严重漏报（gross under-reporting）**，这阻碍了对疫苗产品安全与效力认知的增长；VGG 积极鼓励所有兽医大力参与疑似疫苗相关不良事件的报告。

2.3 疫苗缺乏预期效力作为不良事件与"疫苗管理不善"

- **疫苗缺乏预期效力是一种不良事件**。幼年动物的常见原因是母体初乳抗体干扰；其他重要原因包括**疫苗管理不善（poor vaccine husbandry）**，是一个出人意料地普遍的问题。诊所应考虑指定特定工作人员负责监督、监测和报告疫苗管理。
- 具体风险点：批量重配的疫苗在抽取注射前静置数小时可能失去效力，尤易影响较脆弱成分如 CDV；放在冰箱中距冷冻室过近的疫苗可能冻结而失效（旧冰箱尤易如此），并可能密封缺陷致疫苗储存温度不足够低（一般 **2 至 8°C**）；使用多剂量小瓶（如单瓶 10 剂狂犬病疫苗）时，每次抽取前若未充分混匀悬浊液可致效力不足，并可能使部分受种者**过量接种**，增加超敏反应、注射疼痛与接种后肿胀等其他不良事件的可能。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗剂量与体型、品种风险', '2.4 疫苗剂量与体型、品种风险

- 家养犬成犬体型与体重存在近 **100 倍**变异，但厂商仍建议各种体型成犬接种**相同剂量**；且多数疫苗幼犬剂量与更大更成熟成犬相同。（原文对比：人类近期决定给幼儿较小剂量的 COVID-19 疫苗、给老年较高剂量的流感疫苗。）
- 各种体型与年龄犬提供相同剂量仍是当前标准做法，VGG 不鼓励兽医保偏离厂商建议；但值得注意的，**小型犬更易发生接种后不良事件**；不良事件率随同一次就诊接种的不同疫苗数量增加而增加。大型犬与巨型犬不如小型犬对狂犬病疫苗产生足够免疫应答。一项研究中，体重与抗 CPV 和抗 CDV 抗体应答强度呈负相关——各种体型犬都能产生足够的保护性应答，但小型犬比大型和巨型犬产生更强的抗体应答（Taguchi 2012）。美国近 500 万只犬的最新研究显示，**品种**似乎是 AEFVs 发生可能性的决定因素，与体重无关（Moore 2023）。〔分块正文此处分品种列举为"法国斗牛犬、腊肠犬、波士顿梗犬风险最高"；见 3.9 节 FAQ 处列举五种犬，两处出入照录。〕

2.5 黏膜改良活细菌疫苗与人的健康

- 不良事件的定义未来可能扩展，以纳入对免疫功能低下宠主更明确的、罕见/潜在/实际的接种后健康后果。
- 例如，经黏膜使用的改良活细菌疫苗（如某些支气管败血鲍特菌疫苗）近期被认为可能对某些人（**包括囊性纤维化患者**）构成健康危害（Moore, Rendall & Millar 2022）。风险虽小，但有建议称，在使用改良活支气管败血鲍特菌黏膜疫苗时，要求免疫功能低下的客户宠主离开诊室或许是谨慎做法（Weese 2021）。原文反问：兽医如何知道该要求哪些客户离开？询问客户的免疫健康状况在伴侣动物医学中尚不常见。假定亚单位或灭活支气管败血鲍特菌疫苗能提供同等保护，则对免疫功能低下的宠主可能更安全（Ellis 2015）。', 'dog', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫注射部位肉瘤（FISS）与注射部位', '2.6 猫注射部位肉瘤（FISS）与注射部位', 'cat', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 猫注射部位肉瘤（FISS）与注射部位 (2)', '- 疫苗和其他注射产品与 FISS 发病机制有关（Carminato 2011；Srivastav 2012），研究众多、综述多次。最初特别关注当时新出现的佐剂化 FeLV 与狂犬病疫苗，开创性工作（Kass 等, 1993）表明这些疫苗与 FISS 发展相关。
- FISS 的病因发病机制仍不确定；有证据显示**佐剂化疫苗可能比非佐剂化疫苗影响更大**，但一些专家认为该证据不令人信服。一些疫苗佐剂会引起炎症，推测局部慢性炎症反应中的**间充质细胞发生恶性肉瘤转化**。猫眼外伤后肉瘤（通常在头部外伤多年后发生）可能有类似发病机制；猫（与犬和人相比）特别易患这些形式的肿瘤。
- 传统上大多数皮下注射（含疫苗）注射到猫的**肩胛间沟（interscapular furrow）**，这对 FISS 仍是棘手的解剖位置。此类肿瘤浸润性强，常需根治性手术切除；起源于肩胛间隙时手术往往不成功（Muller & Kessler 2018）。为提高治愈机会，手术常辅以免疫疗法、抗肿瘤化疗、放射疗法等辅助手段，费用高昂且常不成功。**肩胛间沟处生长的肿块可能直到相当大时才被发现。建议不要在猫的此解剖位置进行皮下注射。**
- 北美提出并被广泛采用 **"左腿白血病"（FeLV 疫苗）与"右腿狂犬病"（狂犬病疫苗）**：最初选择后腿，并建议尽可能远端注射，**最好在膝关节（stifle）处或以下**。过去三十年许多美国兽医已精通在此部位皮下接种猫用疫苗；当前 AAHA/AAFP 猫用疫苗指南（Stone 等, 2020）仍推荐此解剖位置。VGG 强烈支持此做法。**皮下注射疫苗优于肌内注射**，因为肌内 FISS 通常比皮下 FISS 更难发现。
- 在 FISS 感知或已知远比北美少见的国家，兽医对远端肢体注射有顾虑。某国当地指南小组根据执业兽医意见（Westman 等, 2022）提出在**肩关节背侧肌隆凸、背中线外侧 4 厘米**处接种的建议〔原文特别澄清：该建议**并非**基于"从此部位根治性切除晚期 FISS 能治愈"的错误认识〕；其逻辑是确保接种后生长的肿块更凸出、因而远早于肩胛间沟处被发现，从而实现更早检查与治疗、 presumably 治疗成功可能性更大。**远端肢体注射仍是黄金标准方法，应大力鼓励采用。** VGG 强烈认可并推荐 2020 年 AAHA/AAFP 猫用疫苗指南中的 **"3-2-1"规则**：任何疫苗接种后肿块 (1) 在接种 **3 个月**后仍存在；或 (2) 在任何时间点直径大于 **2 厘米**；或 (3) 接种后 **1 个月**体积仍增大者，应行**切开活检（incisional biopsy）**。之所以选切开而非切除活检，是因为若诊断为 FISS，手术切除需广泛、很可能涉及大范围手术，这对诊断性活检很不合适。
- 2014 年研究显示在猫尾部接种 FPV 与狂犬病疫苗有效（Hendricks 等, 2014）：社区 TNR 计划的成年猫在**尾背远端三分之一处**注射三价 MLV 核心疫苗（FPV、FHV、FCV），并在三价疫苗接种部位**远端 2 厘米**处注射灭活狂犬病疫苗；所有猫均发生 FPV 血清转化，除一只猫外其余均发生狂犬病病毒血清转化；该小型研究中猫对尾部接种耐受良好。尾部注射未来或可成为远端肢体注射的替代，但仍需进一步研究。
- VGG 关于 FISS 与猫注射解剖部位的意见和建议（逐条，原文列表）：
  - 不应在猫的肩胛间沟内进行皮下注射。
  - 如果皮下注射是合法的替代方法，则不应肌内注射疫苗。
  - 每次使用时应将疫苗注射到不同的解剖部位。
  - 目前尚不清楚任何种类的疫苗是否绝对安全。
  - 疫苗所带来的保护性免疫力的益处，远远超过 FISS 的任何风险。
  - FISS 很少发病，在一些国家和地区可能比其他国家和地区少得多（Dean 等, 2013）。
  - 佐剂与慢性炎症在 FISS 发病中的作用尚不清楚，但有证据提示佐剂化疫苗比非佐剂化疫苗更具相关性；专家对如何解读此证据意见不一——一些专家认为证据太弱，不偏向任何一种猫用疫苗（Stone 等, 2020）；VGG 与其他专家（Hartmann 2021）一致，建议**在已知发生 FISS 且有替代疫苗选择的国家，优先使用无佐剂猫疫苗**；若无可接受的替代品，接种含佐剂产品比完全不接种好得多。
  - 注射的解剖部位应记录在病历或疫苗卡上，包括用图示标明某次接种使用了哪些产品；每次都应"轮换"注射部位；或诊所可制定团队政策，在一个日历年将所有猫疫苗注射到特定位置、下一年更换。
  - 鼓励所有疑似 FISS 病例，通过适当的国家疑似不良反应报告途径上报，或向疫苗制造商通报。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 常见问题（frequently asked questions, FAQs）', '3. 常见问题（frequently asked questions, FAQs）

> 本节为英文全典后半的主体，分块 012 末至 018 中，分为三大组：关于疫苗及其使用、关于接种后不良事件、关于使用血清学/"滴度"检测判断动物是否受保护。以下逐条整理，关键数字照录。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（一）：保护持续时间、同接多苗、首末剂龄', '3.1 疫苗与使用（一）：保护持续时间、同接多苗、首末剂龄

- **问：按指南用 MLV 核心疫苗（犬 CDV、CAV、CPV），犬能保护多久？** 答：有有力证据表明，正确运输储存的质量保证犬核心 MLV 疫苗可强健保护至少 **3 至 4 年**；另有（未详述的）攻毒试验提示免疫持续至少 **7 年**（Schultz 2006；Schultz 等, 2010）。
- **问：猫用 MLV 核心疫苗（FPV、FCV、FHV）能保护多久？** 答：质量保证猫核心 MLV 疫苗可强健预防 FPV 至少 **3 至 4 年**。一种灭活疫苗对 FCV 和 FHV 提供部分但具临床意义的保护长达 **7.5 年**（Scott & Geissinger 1999），但这些猫攻毒时处于无压力的饲养环境。一般而言，MLV FCV 与 FHV 疫苗被认为不如 MLV FPV 疫苗那样提供强效持久的保护。
- **问：现有钩端螺旋体病疫苗能否像犬核心 MLV 疫苗那样长效免疫？** 答：不能到同等程度。现有钩端螺旋体菌苗（bacterin）提供相对短期的免疫，被认为少于 **18 个月**；多项攻毒试验证明保护持续至少 **12 至 14 个月**（Klaasen 2003、2014；Minke 2009）。
- **问：能否对一只无既往接种史的成年犬或猫一次性注射所有必需疫苗？** 答：可以，健康犬猫应能对同时给予的多种疫苗抗原做出应答。一些地区政府当局要求厂商证明同时使用两种或多种疫苗产品安全有效（该证明可能见于产品说明书）。**除非产品说明书支持，切勿在同一注射器中混合不同疫苗**；建议在不同解剖部位注射不同疫苗。
- **问：能否有些疫苗比别的更早成功免疫幼犬？我担心幼犬仍有针对 CDV/CAV/CPV 的 MDA 干扰接种。** 答：能，疫苗在这方面确有差异。一些 MLV 与重组疫苗免疫原性更强，能更早突破母源干扰性免疫——可能因所用病毒株特别具免疫原性和/或每支安瓿含病毒量大于常规。
- **问：听说某些犬核心 MLV 疫苗只需两次、第二剂早在 10 周龄即接种，指南是否如此建议？** 答：**不是**。尽管某些疫苗确实能更早突破 MDA，但 VGG **不建议常规 10 周龄完成**。VGG 知悉某些国家的幼犬疫苗获准"提前完成"，据称是为了便利早期社会化。幼犬社会化很重要，通常可在完成幼犬接种系列前开始；若操作得当，对 CPV 已证明是安全的（Stepita 2013）。VGG 建议尽可能在 **16 周龄或以上**给予幼犬接种系列的最后一剂，无论此前已接种多少剂。未完成完整幼犬接种系列的幼犬应在受控条件下社会化，但谨慎防止其接触家外可能污染环境，只允许接触健康幼犬和完全接种的成年犬。
- **问：幼猫/幼犬最后一次核心 MLV 疫苗应在什么年龄接种？** 答：**不早于 16 周龄**；在暴露风险特别高的地区，**18 至 20 周**可能更合适。此后 VGG 建议在 **26 周龄或以上（26+ weeks）**用核心 MLV 疫苗复种。
- **问：现有 CPV 疫苗能否预防 CPV-2c 所致疾病？** 答：能，现有 MLV 与重组 CPV 疫苗可刺激主动免疫应答，对当前流行的 CPV 变异株（**2a、2b 和 2c**）提供长期保护——前提是疫苗按本指南使用。
- **问：储存疫苗的冰箱较旧，需要担心吗？** 答：不一定，但应定期检查旧冰箱能否可靠控制内部温度。世界某些地方这类检查是兽医医院认证要求：**每日温度必须测量并记录在日志本**。疫苗必须储存于 **2 至 8°C**，不得冷冻。某些冰箱中紧邻冷冻室下方或旁边的物品可能过冷甚至冻结。若旧冰箱不再可靠、无法维持内部温度于 2 至 8°C，应修理或更换。
- **问：我刚入职的诊所里，护士们常规在每段会诊开始前重配多剂疫苗，这好吗？重配的 MLV 疫苗能在室温放置多久而不失活性？** 答：**不好**。室温下一些较敏感成分（如 CDV、FHV）可能在几小时后失去免疫能力，而另一些成分（如 CPV、FPV）可能在几天内仍保持免疫原性。VGG 建议**在立即或临用前重配 MLV 疫苗**。', '', 'young', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（二）：钩端螺旋体病疫苗专问', '3.2 疫苗与使用（二）：钩端螺旋体病疫苗专问

- **问：在高风险地区、时有病例，是否应每 6 个月给每只犬接种钩端螺旋体病疫苗？** 答：就已获准、质量保证的钩端螺旋体疫苗而言，**没有明确证据**表明 6 个月复种比年度复种提供更强的保护——即使在高风险地区；反之，有证据显示保护强健持续 12 至 14 个月，可能更长。
- **问：如何决定在所在地区使用哪种钩端螺旋体疫苗？** 答：若在犬钩端螺旋体病流行的地区工作，VGG 建议将钩端螺旋体疫苗视为"核心"。理想情况下，你所在地区相关血清群应已被研究、能预防相关血清群成员的合适疫苗已上市。血清群之间可能存在一定交叉保护，但未详细研究。优选包含你所在特定地区最常累及血清群成员的、尽可能多血清群、且已获准的疫苗。遗憾的是，在太多国家和地区，对当地哪些血清型/血清群重要、致犬发病仍知识不足。VGG 鼓励收集此类数据，以助开发优化疫苗。
- **问：钩端螺旋体接种史未知的成年犬推荐什么方案？仍像幼犬那样两剂间隔 2 至 4 周吗？** 答：是，该犬需两剂、间隔 2 至 4 周，此后每年复种。
- **问：犬上次接种钩端螺旋体疫苗在 18 个月或更久前，需重新开始接种系列（两剂间隔 2 至 4 周）吗？** 答：尽管支持该建议的证据稀少，基于**预防原则**答案为"是"。
- **问：使用含当地重要毒株的核心疫苗，是否比使用为其他国家宠物优化的疫苗更好？** 答：对钩端螺旋体疫苗确实如此；但**对 CDV、CAV、CPV、FPV、FHV、FeLV 和狂犬病病毒的疫苗并非如此**——这些病毒在世界一地制造的疫苗似乎可在全球满意地保护宠物。就 FCV 而言，即使在同一国家内也存在巨大遗传变异，**没有任何 FCV 疫苗能预防所有 FCV 株**。若完全接种的猫发生 FCV 相关疾病，建议换用含不同株的不同品牌疫苗（Hofmann-Lehmann 等, 2022），或有帮助。
- **问：多价疫苗中不同抗原的数量会损害疫苗效力吗？** 答：不会。典型健康犬猫的免疫系统每天受到大量不同抗原侵袭并良好应对。多价疫苗要获准上市，厂商必须证明疫苗的每种成分都能诱导保护性免疫，通常通过攻毒试验。
- **问：为何犬冠状病毒（canine coronavirus, CCoV）疫苗在本指南中被列为"不推荐"？** 答：VGG 不推荐使用 CCoV 疫苗，因这些疫苗提供有益保护的证据不足（Pratelli 等, 2003）。幼犬 CCoV 感染常发生在生命早期，有时在常规接种开始前；幼犬 CCoV 感染相关腹泻通常轻微。肠外接种的犬似乎**不产生保护性肠道 IgA 抗体应答**。没有充分证据表明 CCoV 是成年犬严重肠道疾病的常见原因。CCoV/CPV 合并感染确实发生，但可通过正确接种 CPV 预防。变异株 CCoV 偶尔被报道致成年犬和幼犬严重呕吐或全身性疾病（Decaro & Buonavoglia 2011；Radford 等, 2021），但现有 CCoV 疫苗能否预防此类变异株的证据很少。', '', 'young', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（三）：糖皮质激素、强免疫抑制与抗肿瘤治疗', '3.3 疫苗与使用（三）：糖皮质激素、强免疫抑制与抗肿瘤治疗

- **问：糖皮质激素治疗是否实质性干扰犬猫疫苗诱导免疫的形成？** 答：两个物种的研究表明，接种前或同时给予抗炎甚至免疫抑制剂量的糖皮质激素，对疫苗抗体产生**没有实质性抑制作用**（即使是幼犬的初次疫苗；Nara 等, 1979）。不过仍建议在糖皮质激素治疗结束后复种，特别是初次核心疫苗系列期间使用了糖皮质激素。给药、减量与疗程因适应证和临床判断而异：**短疗程**应在**停药后至少 2 周**复种；**较长疗程**应延长至 **3 个月**；若糖皮质激素用于治疗较重的疾病，应推迟接种至动物恢复正常健康；若无法停药，则仅在糖皮质激素稳定剂量良好控制疾病数周后才接种；不适动物应加以管理，避免其在未受保护状态下暴露。对此类动物可用金标准技术进行血清学监测（针对 CPV、CDV、CAV 及 FPV 视情况），常能确保治疗期间核心疾病保护不丢失、或停药后无需复种。
- **问：正在接受强效免疫抑制或抗肿瘤治疗（糖皮质激素除外或加用）、原发病控制良好、外观健康的宠物是否应接种？** 答：这类情形应寻求临床专科医生（临床肿瘤学家或免疫学家）建议。过去可能对这类动物一概建议不接种——尽管这部分患者疫苗相关不良事件的报告很少。这些建议的证据基础（evidence base, EB）薄弱，但该主题已被全面综述，并纳入鼠与人类模型的对比数据以补充犬猫数据（Hartmann 等, 2022）。按本指南，提供一种更细致、个体化的方法供参考，以适应此类方案涉及的多靶点免疫应答的多种药物。例如，一些传统"骨髓抑制"（细胞毒性）药物在特定情况下甚至起免疫刺激而非免疫抑制作用。关于核心 MLV 疫苗，假定该宠物幼犬/幼猫期已充分接种，**最好是等待**——该宠物很可能已被既往核心 MLV 接种保护。MLV 疫苗通常在人类强免疫抑制患者中避免使用。一项研究中，肿瘤患犬接受化疗后 CDV、CPV 和狂犬病病毒滴度未检测到显著变化（Henry 等, 2001）。鼓励此情形下用金标准技术血清学检测，常能确保部分或全部核心疫苗抗原免疫仍完好、从而减少需复种的疾病；如需要，复种核心 MLV 疫苗**不早于强效免疫抑制或抗肿瘤治疗结束后 3 个月**。
- **高剂量环孢素（ciclosporin）治疗的猫**：一项研究显示，治疗期间接种的 FPV 和 FCV 疫苗产生正常血清学反应，但对 FHV、FeLV 和狂犬病的反应延迟；相反，治疗猫在初次 FIV 疫苗系列后未能产生抗体，提示环孢素治疗可能损害**初次（primary）而非记忆性（memory）**疫苗免疫应答（Roberts 等, 2015）。
- 关于犬钩端螺旋体病接种：宠主可能希望继续享受某些涉水活动以最大化犬的生活质量；犬钩端螺旋体病在许多地区流行。免疫抑制治疗可能降低钩端螺旋体疫苗效力，但不一定，尤其若犬一年前接种过——犬可能保留免疫记忆。菌苗疫苗造成危害的可能性小于 MLV 疫苗。灭活疫苗用于严重免疫功能低下的人类患者（Ljungman 2012）。', '', 'young', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（四）：感染 FeLV / FIV 的猫', '3.4 疫苗与使用（四）：感染 FeLV / FIV 的猫

- 感染 FeLV 的猫**不应**接种 FeLV 疫苗，感染 FIV（猫免疫缺陷病毒, feline immunodeficiency virus）的猫**不应**接种 FIV 疫苗，因为对已感染的猫无益处。
- 对于外观健康的感染逆转录病毒的猫，所有其他疫苗的决定（即接种哪些、多久一次）应基于**个体化风险-效益评估**；**不应因感染逆转录病毒而避免接种**。选择灭活或重组疫苗而非 MLV 疫苗或许谨慎（Hartmann 等, 2022），尽管 MLV 疫苗损害逆转病毒感染猫的证据非常稀少。理想情况下，逆转病毒感染猫应饲养在室内或受保护的户外围栏中，以尽量减少其对其他户外猫的风险、并减少其接触其他传染因子。
- 逆转病毒感染猫若同时感染 FPV、FCV 和/或 FHV，可能发展为特别严重的疾病，故预防这些病毒很重要。一般而言，**FeLV 的致病性强于 FIV**。有建议称，即使 100% 室内生活的 FeLV 感染猫也需**每年**复种 FHV、FCV 和 FPV（Hartmann 等, 2022）；允许户外活动的 FIV 感染猫也需每年针对这些核心病原体复种；100% 室内生活的 FIV 感染猫可减少针对这些核心病原体的接种（例如每三年一次）。狂犬病流行地区，狂犬病接种应照常遵循当地规定。对于仅感染 FIV 或仅感染 FeLV 的室内外猫，也可考虑针对"另一种"逆转录病毒接种。与一只或多只逆转病毒感染猫同处的多猫家庭的管理已在别处综述（Little 等, 2020）。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（五）：接种频率、年龄下限、操作细节', '3.5 疫苗与使用（五）：接种频率、年龄下限、操作细节

- **问：动物患病风险非常高（例如收容所中），是否应每周接种？** 答：**本指南不推荐**（其他指南也不推荐），尽管缺乏已发表的 EB。担忧在于：幼犬过于频繁复种可能没有足够时间让免疫应答正常形成，且疫苗抗原可能与 MDA 结合而削弱幼年犬猫的保护。尽管缺乏证据，也有人担忧免疫耐受（减敏）的形成，会与期望相反。
- **问：是否给 4 周龄以下的幼犬接种？** 答：一般**不**。此年龄大多数犬含有能阻断疫苗免疫的 MDA；且疫苗产品说明书不支持此做法，肠外 MLV 疫苗可能对如此幼龄动物造成伤害。**一个例外**是使用针对犬传染性呼吸道疾病复合征（canine infectious respiratory disease complex, CIRDC）的**鼻内疫苗**，从 **3 周龄**起可安全使用。
- **问：攻击性犬能否把鼻内改良活支气管败血鲍特菌疫苗皮下注射并期望好效果？** 答：**绝对不行**。该鼻内改良活疫苗若皮下注射可引起严重局部反应，甚至可能引起严重全身性疾病（如肝病, hepatopathy）并导致动物死亡。
- **问：能否鼻内给予本应皮下注射的灭活支气管败血鲍特菌疫苗？** 答：**不能**。这样不会刺激有效免疫应答，并可能引起不必要的不适。
- **问：幼犬鼻内接种后打喷嚏，需要再接种吗？** 答：使用鼻内产品后打喷嚏并流失部分疫苗常见。这些疫苗设计时已允许产品的部分损失，所以除非明显没有或只有极少量成功滴入，**不需要**复种。
- **问：猫用注射型 MLV FHV/FCV 疫苗需注意什么？** 答：避免使任何用于皮下或肌内注射的改良活 FHV/FCV 疫苗**雾化**——例如不要轻弹注射器试图喷出微小气泡，这完全没必要。诊室中雾化的疫苗可能接触猫的黏膜（结膜和/或口鼻）而致病；这些活疫苗被设计为肠外给药安全，而非经黏膜给药。若一些疫苗从注射部位渗漏到猫的皮毛中，应尽可能清除（如用干纸巾），然后在最后清洁步骤前对受累皮肤和皮毛区域应用消毒剂。
- **问：需两剂才能免疫的疫苗（如钩端螺旋体菌苗或 FeLV 疫苗），若第一剂后 6 周内未接种第二剂，有免疫力吗？** 答：最安全地假定**没有**。两剂疫苗的单剂应假定不提供任何免疫：第一剂启动免疫系统、第二剂用于免疫。若第一剂后 6 周内未接种第二剂，需**重新开始该方案**，按产品说明书确保两剂在 2 至 4 周内接种。此后两剂完成后，可按产品说明书以年度或更长间隔单剂复种以增强应答。
- **问：犬或猫最后一次核心 MLV 疫苗在 3 年以前，需重新开始系列（两剂间隔 2 至 4 周）吗？** 答：**不需要**。对 MLV 核心疫苗，多剂只是幼犬幼猫的需要（因其含 MDA）。VGG 知悉许多产品说明书确实建议以两剂重新开始系列，但几乎没有证据表明必要。对 MLV 疫苗，单剂应足够。', '', 'young', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（六）：初乳、老年、未免疫成年犬猫方案', '3.6 疫苗与使用（六）：初乳、老年、未免疫成年犬猫方案

- **问：幼犬幼猫未摄入任何初乳，会从母体获得被动抗体保护吗？** 答：取决于母体抗体滴度，它们将获得很少、更可能是**没有**保护。正常哺乳的新生幼犬幼猫血液中大约 **95% 或更多**的 MDA 来自初乳，出生后通过肠道吸收进入体循环可达 **24 小时**，尤其是最初 **4 小时**。幼犬幼猫在出生后最初几小时成功吮乳很重要。
- **问：犬到多大年龄可以安全停止接种？** 答：因达到某一高龄而**停止给犬接种是不合适的**。对核心 MLV 疫苗，当前建议终身接种频率不超过每 **3 年**；若选用钩端螺旋体疫苗或一种或多种非核心疫苗，这些通常需**每年**接种。
- **问：未免疫成年犬推荐什么方案？** 答：核心 MLV 疫苗（针对 CDV、CAV-1、CPV），加狂犬病和流行地区钩端螺旋体病疫苗。**狂犬病与 MLV 核心疫苗单剂即足够，但钩端螺旋体疫苗必须两剂才能免疫。** 此后 CDV、CAV-1、CPV 复种频率不超过每 3 年，钩端螺旋体病需每年复种，狂犬病按当地法规或说明书复种。非核心疫苗（如副流感病毒、支气管败血鲍特菌等）应基于每只动物的风险-效益分析选择；灭活非核心疫苗需两剂间隔 2 至 4 周、此后年度加强。
- **问：未免疫成年猫推荐什么方案？** 答：对可能从未接种的成猫，VGG 建议核心 MLV 疫苗（FPV、FCV、FHV）**两剂间隔 2 至 4 周**，加流行地区狂犬病疫苗一剂。**1 岁以下幼猫，或有户外活动、或与有户外活动的猫同处室内的成猫，还应接种 FeLV（两次初始剂，随后按说明书每 2 至 3 年加强）**。低风险生活方式的猫，三价 MLV 核心复种频率不超过每 3 年；高风险生活方式的猫，建议 FPV 复种不超过每 3 年、FHV 和 FCV 每年。〔承接〕但一些国家无法获得仅含 FHV 和 FCV 的二价疫苗，这些国家高风险猫需每年接种三价（FPV、FCV、FHV）疫苗。非核心疫苗（如猫衣原体 *Chlamydia*）应基于每只动物风险-效益分析选择；非核心疫苗通常需两剂间隔 2 至 4 周、此后年度加强。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 疫苗与使用（七）：CAV-2、繁育、犬流感、野生/外来、顺势疗法', '3.7 疫苗与使用（七）：CAV-2、繁育、犬流感、野生/外来、顺势疗法

- **问：犬核心 MLV 疫苗为何含 CAV-2 而非 CAV-1？CAV-1 不是更重要、更致病吗？** 答：过去犬核心 MLV 疫苗确实含 CAV-1，偶尔引起一过性"蓝眼"或角膜水肿——一种不常见但令人不安的不良效应。现代含 CAV-2 的犬核心 MLV 疫苗对 CAV-1 提供强交叉保护，且不引起角膜水肿。因此 CAV-2 已取代 CAV-1。
- **问：如何对待繁育母犬母猫的接种？** 答：尽管怀孕期接种致害的证据稀少，但通常建议尽可能避免在怀孕期间给繁育母犬母猫接种；理想上应在怀孕前安排所需疫苗。若怀孕期间需要核心疫苗，历史上建议使用灭活疫苗而非 MLV，尽管如今越来越多的犬 MLV 疫苗已获批在认为必要时用于怀孕期。繁育母犬母猫像所有其他犬猫一样需要核心疫苗，非核心疫苗基于风险-效益使用。一些专家建议对繁育母犬**每年而非每三年**复种 MLV 核心疫苗，以最大限度提高初乳抗体浓度；但给怀孕期已免疫母犬追加 MLV 核心剂只会提高少数母犬的血清抗体水平。**怀孕期间使用 MLV 核心疫苗对母猫的风险可能大于母犬（主要顾虑是 FPV），没有 MLV 核心疫苗被批准用于母猫此用途。** 一些 MLV 疫苗在说明书中注明怀孕期使用的具体禁忌——这很可能是因为相关安全性试验尚未在怀孕母犬/母猫中进行，而非记录了危害。详情需咨询疫苗制造商。
- **问：世界各地犬流感现状如何？需要接种吗？** 答：原文给出美国疾控中心（CDC）犬流感页面链接。犬甲型流感 H3N8 病毒从马传播给犬，适应新宿主后能在犬间传播引起呼吸道疾病（尤其群养犬），随后在美国大部分地区犬中被检出；已开发出保护犬的疫苗并有售。**然而认为此病毒可能已不再在美国犬中循环，可能已灭绝。** 犬甲型流感 H3N2 病毒最初从鸟传播给犬，适应后能在犬间传播引起呼吸道疾病；也曾从感染犬传给家猫。犬 H3N2 于 **2007 年**首次在**韩国**犬中检出，在**东南亚若干国家地方性流行**；随后通过从流行国家引入感染犬被传入美国和加拿大，在美国零星循环。已开发出保护犬抵御犬甲型 H3N2 流感的疫苗并有售。
- **问：给野生/外来物种、或给 MLV 疫苗获批靶物种以外的家养物种使用 MLV 疫苗好吗？** 答：**不好，除非已证明对其拟保护物种安全，切勿给予 MLV 疫苗**。许多 MLV 疫苗用于最初获批靶物种以外的动物时会导致疾病和死亡；更糟的是，疫苗可从野生动物脱落、在它们之间传播，并通过多次传代重新获得毒力，甚至可能对原疫苗开发的靶物种致病。一种安全有效、**重组金丝雀痘病毒载体 CDV 疫苗**已在某些国家获批用于雪貂；该疫苗也被建议作为许多野生和外来物种的标签外犬瘟热首选，因为它**不含活的犬瘟热病毒**。
- **问：顺势疗法的"nosodes（病源制剂）"能否成功使宠物免疫？** 答：**不能**。不能期望 nosodes 预防任何传染病，其安全性与效力证据极少；在少数出版物中已证明 nosodes 缺乏效力（Rieder & Robinson 2015）。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于接种后不良事件的问答', '3.8 关于接种后不良事件的问答', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于接种后不良事件的问答 (2)', '- **问：什么是"接种后不良事件（AEFV）"？** 答：不良事件是疫苗接种后产生的任何有害的、意外的后果（**包括缺乏保护**）。局部反应如注射部位疼痛肿胀、轻微全身反应如嗜睡、厌食、发热、呕吐发作常见；荨麻疹与过敏反应较少见；更严重后果（如猫注射部位肉瘤, FISS）罕见。
- **问：接种后不良事件有多常见？** 答：不常见但无疑存在漏报，故难确知。疫苗生产方法改进已旨在降低发生率。
  - **日本研究（2006–2007 犬非狂犬病联合疫苗, Miyaji 等, 2012）**：在 **573** 家兽医医院（每家最后 100 只犬）共接种 **57,300** 次，共 **359** 只犬发生 AEFVs，即每 10,000 只接种犬 **62.7** 只；**死亡 1 只、过敏反应 41 只、胃肠道症状 160 只、皮肤病症状 244 只、其他临床症状 106 只**；**83.3%** 在接种后 12 小时内被发现；出现过敏反应的犬全部在 60 分钟内发生，其中近一半（**46.3%**）在 5 分钟内。
  - **美国较早研究**：任何不良事件（含很轻微反应）在接种后前 3 天内记录，为每 10,000 只接种犬 **38** 只（Moore 2005）；猫为前 30 天内每 10,000 只 **52** 只（Moore 2007）。一些动物可能有未报告给本诊所、而报告给就诊的其他诊所或急诊诊所的反应。
  - **美国近期约 500 万只犬研究（Moore 2023）**：某些品种发生急性 AEFVs 的风险远高于普通犬群——**腊肠犬、波士顿梗犬、小型杜宾犬、法国斗牛犬和哈瓦那犬风险较高**；每次就诊接种多剂的小型犬风险特别高。〔注：分块正文（2.4 节）品种列举为法国斗牛犬、腊肠犬、波士顿梗犬三者，与 FAQ 五者表述略有出入，两处均照录。〕
- **问：曾发生严重不良事件（如荨麻疹/面部水肿、过敏反应或免疫介导性疾病）的中年犬应复种吗？** 答：不一定。若疑致不良事件的是 MLV 核心疫苗、且该犬此前已按指南接种，则很可能仍受保护、**可能无需复种**；主人特别担心时可考虑金标准血清学检测。狂犬病疫苗应咨询地方当局是否允许抗体滴度测定或其他避免使用该方法。**若支气管败血鲍特菌注射疫苗被疑，可推荐替代疫苗（如鼻内或口服）。若钩端螺旋体疫苗被疑、且犬的生活方式与地理位置使其风险特别高，可考虑使用被证明含极低浓度辅料（excipients，如牛血清白蛋白）的新型疫苗复种。** 若决定确需接种，改用不同产品或有帮助，但支持证据稀少——部分原因是超敏反应已知与疫苗中的辅料（如培养过程使用的微量牛血清白蛋白）相关，这些辅料许多产品共有，尽管不同产品含量差异大。复种前使用抗组胺药或抗炎剂量糖皮质激素是可以接受的，不应干扰疫苗免疫应答。复种的敏感动物应密切监测至接种后 **24 小时**，尽管此类反应（I 型超敏反应）通常在接触后数分钟至 1 小时内发生；其他类型超敏反应（II、III 或 IV）可能晚得多（数小时至数月）。
- **问：有免疫介导性疾病史（甚至无疫苗触发嫌疑，即所谓"非相关性疾病"）的成年犬，到期时是否应给予加强疫苗？** 答：顾虑在于疫苗本质上是抗原刺激，可能使易感患者的免疫稳态失衡、导致自身免疫复发（如免疫介导性溶血性贫血 [immune-mediated haemolytic anaemia, IMHA]、免疫介导性血小板减少 [ITP] 或多发性关节炎）。此处可用血清学检测 CPV、CDV 和 CAV，及狂犬病（但需与监管部门确认狂犬病）。若计划复种，进行风险-效益分析和解读任何后续不良结局时应考虑以下信息：所有免疫介导性疾病无论是否给予加强剂均有自发复发可能；上述三种免疫介导性疾病诊断后最初几个月的复发率明显更高——**这通常正是犬接受较高剂量免疫抑制剂并逐渐减量的时期，此期间不应接种疫苗**，以避免在脆弱期进一步增加疾病复发风险。**12 个月后，长期自发复发率大大降低（通常为患病动物的 10% 至 15%）。**
  - IMHA：近期综述中，从 IMHA 康复的 **44** 只犬有 **22** 只接受加强剂，其中 **4** 只接受超过一次加强剂；这 22 只中有一只在加强剂后不久出现 IMHA 复发（Weingart 等, 2019）。
  - ITP：一份研究摘要描述了以加强疫苗作为复发免疫介导性疾病潜在原因的调查（Ellis 2016）：缓解期（不再接受免疫抑制剂）的 **22** 只犬长期随访，其中 **9** 只未接受加强疫苗、另 **12** 只接受了（有些是多年多次加强），两组中没有犬复发。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于接种后不良事件的问答 (3)', '- 若加强接种后 **4 周内**出现复发，须牢记**时间关联不能证明因果关系**，但这确实凸显了对进一步接种疫苗需更严格审查，并应作为 AEFV 向有关当局报告。
- **问：为减少不良反应风险，能否给小型或超小型犬注射半剂或 1/4 剂？** 答：**不推荐**，尽管有新兴证据显示小型犬更易发生不良反应、且对标准剂量产生比大型和巨型犬更高的抗体滴度。严重不良反应在小/超小型犬中也不常见，一项以摘要发表的近期研究中，不良反应风险与品种的关联强于与体型的关联（Moore 2023）。一些疫苗进一步开发改良，显著降低了被认为与许多不良反应相关的辅料成分（如牛血清白蛋白）浓度；另一些被重新配方为在更小容量（例如 **0.5 mL**）中含有等量抗原，更适合超小型犬。仍需研究超小型犬与巨型犬各自需求；VGG **不建议给小型或超小型犬注射少于全剂量**。
- **问：既然缺乏效力是一种重要不良事件，为何一些繁育犬舍持续有犬死于 CDV 和 CPV-2 感染？** 答：最可能原因是**繁育犬群接种不足**。疫情可能发生在未从母犬获得足够 MDA 的幼犬（因母犬接种不当）。相反，若幼犬接种不按指南安排（指南建议幼犬最后一剂在 16 周龄或以上），则存在风险——干扰性 MDA 持续超过 12 至 14 周龄，可能使一些幼犬未受保护。良好饲养、卫生、营养、避免过度拥挤和减轻压力，都有助减少犬舍疫情。
- **问：幼犬 9 周龄接种 CPV 疫苗，却 10 周龄出现细小病毒性肠炎，为什么？是疫苗致病吗？** 答：接种后不久发生疫苗可预防疾病的幼龄接种犬最常见原因是动物在接种前**已处于潜伏期**。也可能这些幼犬在"易感窗口（window of susceptibility）"期间被感染——此时其 MDA 已不足以充分保护它们免受强毒野毒株侵害，但 MDA 浓度或滴度仍足以干扰其对最近接种疫苗的免疫应答。
- **问：听说猫"过度接种"有时导致慢性肾病（chronic kidney disease, CKD），是真的吗？** 答：CKD 是老年猫常见且重要的疾病，但仅少数研究探索其风险因素。一项 2016 年基于问卷的研究（Finch 等, 2016）显示宠主报告的猫（**> 9 岁**）每年/频繁复种与氮质血症性 CKD 发展之间存在关联，年龄与严重牙周病是其他独立风险因素；该研究报告 148 只猫中有 27 只发展为氮质血症性 CKD，**未证明因果关系，只提供关联证据**。若干实验室研究对因果关系的可行性有所提示：一些含 FPV、FCV、FHV 的猫疫苗在源于猫肾组织的细胞（Crandell-Rees 猫肾细胞, CRFK）上培养，疫苗中很可能含有猫蛋白；已报道将 CRFK 细胞裂解物、或很可能在 CRFK 上生长的疫苗肠外注射实验猫，可诱导产生能结合猫肾细胞提取物、各种猫肾蛋白和 CRFK 细胞的抗体。**实验性超量接种 CRFK 细胞裂解物（最初 50 周内 12 次，一年后再次一次）使 6 只猫中 3 只出现淋巴浆细胞性间质性肾炎**（Lappin, Basaraba & Jensen 2006a）；然而一项较新研究使用 FPV/FCV/FHV 疫苗（而非细胞裂解物）过度接种（**14 周内接种八次**）**未诱发 CKD 或间质性肾炎**（Summers 等, 2022）。**成年猫每年/频繁接种尚未被证明会导致 CKD**；尽管如此，避免不必要地过度使用疫苗是合理的，正如本指南全篇所强调。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于使用血清学/"滴度"检测判断动物是否受保护的问答', '3.9 关于使用血清学/"滴度"检测判断动物是否受保护的问答', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于使用血清学/"滴度"检测判断动物是否受保护的问答 (2)', '- **问：我是否有义务在诊所常规开始使用血清学/"滴度"检测？** 答：没有，这是个人选择。现代质量保证疫苗是安全的。一些专家建议按日程常规复种（如犬 MLV 每三年一次），很少或不用常规血清学检测（Ellis 等, 2022）。你可能在遇到"应接种但正在使用强效免疫抑制或抗肿瘤药物"的患宠时首次考虑血清学检测；或遇到"有既往严重接种后不良事件史"的患宠。
- **问：对哪些感染因子可用血清学检测预测动物是否受保护？** 答：犬为 CDV、CAV 和 CPV；猫为 FPV。用金标准实验室检测抗 CDV 与抗 CAV 抗体可能比诊所内检测更可靠。检测针对其他感染因子（如钩端螺旋体）的抗体作为保护预测因子**远不如**这些可靠。
- **问：一般而言，成年动物对这四个病毒（犬 CDV、CAV、CPV，猫 FPV）血清学阳性意味着什么？** 答：意味着检测到抗体。自然暴露或接种后的免疫应答极为复杂，远不止抗体产生。但就这四个病毒，抗体存在被普遍认为表明已产生主动免疫应答的动物获得保护。抗体不是保护的唯一介质，但 **20 周龄以上**动物血清中存在这些病毒的抗体被指示为受保护；狂犬病病毒亦如此，但许多其他病毒并非如此。
- **问：若血清学对上述任一感染因子检测为阴性，怎么办？** 答：告知主人该检测表明动物可能未受保护，并建议**立即复种**。
- **问：血清学检测有多可靠？** 答：仅考虑犬 CDV、CAV、CPV 和猫 FPV。有需由诊断实验室完成的金标准血清学检测，无法在诊所做；也有多家厂商的商品化诊所内诊断试剂盒，显然更方便。据信金标准检测结果比诊所内试剂盒更可靠（尽管这一点偶受质疑），尤其对抗 CDV 与抗 CAV 抗体的检测。若能便捷地通过诊断实验室做金标准检测，应能给出临床可及的最可靠结果。**诊所内血清学检测最大的担忧据说在于其特异性**（Bergmann 等, 2020、2021a、2021b）。假阳性会表明动物有抗体、受保护、因而不需接种，而按当前指南它其实应接种。近期在德国将若干不同诊所内诊断试剂盒与金标准比较（Bergmann 系列），对某些病毒的诊所内试剂盒可靠性提出关注。
- **问：现有诊所内血清学试剂盒的可靠性与易用性是否都差不多，还是需要慎重选择？** 答：值得充分了解其差异。这些试剂盒近期被仔细研究和比较，易用性和相对于金标准的性能有差异；**其中最好的检测抗 CPV 抗体者相对于金标准表现很好**。
- **问：这些诊所内试剂盒检测某些病毒抗体是否比另一些更可靠？CPV 如何？** 答：是的，这是关键。先看宠物犬 CPV 抗体检测——一些诊所内试剂盒在此表现尤其好。检测抗 CPV 抗体的最佳试剂盒被用于检测 **198** 只客户饲养的犬（Bergmann 等, 2020），产生 **154 个真阳性、仅 1 个假阳性**；用于 **43** 只特定无病原（CPV 抗体阴性）犬时**未产生任何假阳性**；但在客户饲养犬中产生了许多**假阴性**。须知阴性结果通常会引发复种建议，假阴性使实际上有保护抗体的动物被复种——这可能浪费但通常无害；相反假阳性会使潜在的易感动物未受保护，这是更严重的情形，故此研究中出现很少假阳性是很好的。其余三种检测抗 CPV 抗体的诊所内试剂盒 PPV 和特异性几乎与最佳试剂盒同样好，但更重要的点是：**最佳试剂盒最重要的优势不是其略高的 PPV，而是即便在低血清流行率下仍能提供可靠结果的优越能力**——即使该试剂盒用于仅 10% 犬 CPV 血清阳性的群体，仍能产生令人印象深刻的阳性预测值（positive predictive value, PPV）。
- **问：相比之下，检测抗 CDV 与抗 CAV 抗体的诊所内试剂盒表现如何？** 答：据近期研究（Bergmann 2021a、2021b）**远不如**前者可靠。单一检测抗 CAV 抗体的诊所内试剂盒**特异性较低**；几种检测抗 CDV 抗体的诊所内试剂盒不可靠，**尤其在检测患慢性病的看似健康的犬和急性发病的犬时**。
- **问：何谓所谓的"保护性滴度（protective titre）"？** 答：你并不孤独地感到困惑——这是个复杂话题。"保护性滴度"指血液中对疾病 X 足以保护动物免受疾病 X 的抗体量或浓度。该表述对尚未对自身产生主动免疫应答的幼龄幼犬幼猫最贴切、最易理解。对这些幼犬幼猫，母源初乳抗体尤其重要；若它们有足够 MDA（即达到"保护性滴度"），应能免受中等毒力攻毒的保护。但 MDA 的金标准测定是复杂的生物测定，故结果在各实验室间会略有差异；病毒攻毒剂量性质也各异，故按一个实验室预测（仅勉强）受保护的动物，可能被另一实验室判为易感或（相当地）保护良好。', '', 'young', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 关于使用血清学/"滴度"检测判断动物是否受保护的问答 (3)', '对已产生自身主动免疫的年长动物情况更复杂——它们除自身抗体和记忆细胞外还应已产生细胞免疫。在多年进行、未详细发表的大型攻毒研究（Schultz 2006；Schultz 等, 2010）中发现：**仅抗体的存在（而非某一特定滴度）就足以表明对以下病毒的强健免疫——犬 CDV、CAV、CPV，猫 FPV**；对这些病毒（而非其他病毒），即使很低量的抗体存在也被发现能预测攻毒免疫。遗憾的是这一大量有趣工作未被全文详述发表，此后也未再进行同等规模的研究。
- **问：CPV/CDV 接种后应等多久才能用诊所内检测测量保护性抗体浓度？** 答：该问题对幼犬最相关，因为成年犬在加强接种时更可能已存在血清抗体，无论距上次接种多久。若幼犬在 **16 周龄**接受最后一次初种，则从 **20 周龄起**可检测；检测应不早于**最后一次疫苗接种后至少 4 周**。该阶段存在的任何抗体极不可能来自被动母源，因而表明幼犬已主动受保护。', '', 'young', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 致谢、作者贡献与利益冲突', '4. 致谢、作者贡献与利益冲突

> 分块 018 中部。

- **致谢（Acknowledgements）**：WSAVA 疫苗接种指南小组（VGG）制定本指南的工作由**默沙东动物保健（MSD Animal Health）**慷慨支持。VGG 四名成员作为工作组编写本指南；赞助公司代表未出席 VGG 会议，公司也无权否决 VGG 的建议。VGG 认可 AAHA 犬类疫苗接种指南任务组与 AAHA/AAFP 猫类疫苗接种指南任务组在制定尤其适用于北美的犬猫接种建议方面的重要工作；也认可欧洲 ABCD 在制定尤其适用于欧洲的猫接种建议方面的工作；感谢多个国家撰写了部分取材于既往 WSAVA 指南的国家指南的同行；并特别感谢 Michael Lappin 教授审阅并提供有益评述。
- **作者贡献（Author contributions）**：Richard Adrian Squires、Cynda Crawford、Mary Marcondes、Nathaniel Whitley 四位作者均（同等）参与概念化、形式分析、调查、方法学、资源、撰写—初稿、撰写—审阅与编辑；Squires 为项目管理（主导），其余三位为项目管理（支持）。
- **利益冲突（Conflict of interest）**：本指南四位作者此前均从一家或多家兽用疫苗制造商获得过至少一些财政支持，形式为演讲费、专家建议费、差旅报销或学术研究费用；完整详情可应要求提供。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 缩写对照（Abbreviations，英文原版列表照录）', '5. 缩写对照（Abbreviations，英文原版列表照录）

> 分块 018。下表按原文顺序逐条列出英文全称与中文；个别条目标签在抽取稿中串行，已照录并标注〔原文如此〕。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 缩写对照（Abbreviations，英文原版列表照录） (2)', '| 缩写 | 英文全称 | 中文 |
|------|----------|------|
| AAFP | The American Association of Feline Practitioners | 美国猫科医生协会 |
| AAHA | The American Animal Hospital Association | 美国动物医院协会 |
| Ab | antibody | 抗体 |
| ABCD | The Advisory Board on Cat Diseases | 猫病咨询委员会 |
| AEFV | adverse event following vaccination | 接种后不良事件 |
| CanL | canine leishmaniosis | 犬利什曼病 |
| CAV | canine adenovirus | 犬腺病毒 |
| CCoV | canine coronavirus | 犬冠状病毒 |
| CDV / CIV | canine distemper virus ／ canine influenza virus〔原文如此：抽取稿中 "CDV canine distemper virus" 后紧接 "canine influenza virus"，"CIV" 标签缺失〕 | 犬瘟热病毒 ／ 犬流感病毒 |
| CKD | chronic kidney disease | 慢性肾病 |
| CPiV | canine parainfluenza virus | 犬副流感病毒 |
| CPV | canine parvovirus type 2 and its variants | 犬细小病毒 2 型及其变异株 |
| DOI | duration of immunity | 免疫持续时间 |
| EB | evidence base | 证据基础 |
| FAQ | frequently asked question | 常见问题 |
| FCV | feline calicivirus | 猫杯状病毒 |
| FeLV | feline leukaemia virus | 猫白血病病毒 |
| FHV | feline herpesvirus-1 | 猫疱疹病毒-1 |
| FIP | feline infectious peritonitis | 猫传染性腹膜炎 |
| FIV | feline immunodeficiency virus | 猫免疫缺陷病毒 |
| FISS | feline injection site sarcoma | 猫注射部位肉瘤 |
| FPV | feline panleukopenia virus / feline parvovirus | 猫泛白细胞减少症病毒 / 猫细小病毒 |
| Ig | immunoglobulin | 免疫球蛋白 |
| IMHA | immune-mediated haemolytic anaemia | 免疫介导性溶血性贫血 |
| ITP | immune-mediated thrombocytopenia | 免疫介导性血小板减少 |
| LiESP | excreted-secreted proteins of Leishmania infantum | 婴儿利什曼原虫排泄-分泌蛋白 |
| MDA | maternally derived antibody | 母源抗体 |
| mRNA | messenger RNA | 信使 RNA |
| MLV | modified live virus | 改良活病毒 |
| NPV | negative predictive value | 阴性预测值 |
| OA | overall accuracy | 整体准确度 |
| Osp | outer surface protein | 外表面蛋白 |
| PAW | pet animal welfare | 宠物动物福利 |
| PPV | positive predictive value | 阳性预测值 |
| SPC | summary of product characteristics | 产品特性摘要 |
| VGG | Vaccination Guidelines Group | 疫苗接种指南小组 |
| WHO | World Health Organization | 世界卫生组织 |
| WSAVA | World Small Animal Veterinary Association | 世界小动物兽医协会 |', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'caution', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('2024年WSAVA犬猫疫苗接种指南·英文全典 · 缩写对照（Abbreviations，英文原版列表照录） (3)', '〔原文如此〕原文每页均带 Wiley 下载水印行："17485827, 0, Downloaded from https://onlinelibrary.wiley.com/doi/10.1111/jsap.13718 by UNIVERSIDADE ESTADUAL PAULISTA, Wiley Online Library on [03/04/2024]..."，以及 "OA articles are governed by the applicable Creative Commons License" 等版权行——均为页眉页脚残留，非正文内容。DOI 显示本文发表于 *Journal of Small Animal Practice*（jsap.13718）。', '', '', '', '疫苗,收容所疫苗方案,庇护所,TNR,RTF,鼻内支气管败血鲍特菌', 'informational', '2024年WSAVA犬猫疫苗接种指南·英文全典（三）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 宠物犬（非收容所）疫苗速查表', '> - Dogs-Vaccination-Table（宠物犬非收容所核心/非核心疫苗表）：https://wsava.org/wp-content/uploads/2025/06/Dogs-Vaccination-Table.pdf
> - Cats-Vaccination-Table（宠物猫非收容所核心/非核心疫苗表）：https://wsava.org/wp-content/uploads/2025/06/Cats-Vaccination-Table.pdf
> - Shelter-Dogs-and-Cats-Vaccination-Table（收容所犬猫核心疫苗表）：https://wsava.org/wp-content/uploads/2025/06/Shelter-Dogs-and-Cats-Vaccination-Table.pdf
>
> 用途：这是最浓缩的表格版本，适合快速查询起始免疫年龄、加强间隔与关键备注。**速查表为浓缩版，任何细节、定义与理由以完整版 2024 指南（见 01-犬猫疫苗接种指南2024.md）为准**。
> 整理说明：以下表格逐格重建自 raw_extracts 抽取稿；抽取稿中为空的格子标「原文此处缺失」；抽取稿内的排版残迹（如 "product leafel ts"、"Parainful enza"、"subunitOuter"、"confrimed"、"highstress"、多余 "]" 号等 PDF 提取错字/断词）在中文转写时按原意连读，未新增任何内容。

1. 宠物犬（非收容所）疫苗速查表

对应原表标题原文：*Core and Non-Core Vaccines for Pet Dogs (non-shelter) according to the 2024 guidelines for the vaccination of dogs and cats – compiled by the World Small Animal Veterinary Association (WSAVA) Vaccination Committee.*', '', '', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET DOGS）', '1.1 核心疫苗（CORE VACCINES FOR PET DOGS）

| 疫苗 | ≤16 周龄幼犬 | >16 周龄犬 | 复种（Revaccination） | 备注与建议 |
|---|---|---|---|---|
| • 犬细小病毒-2（CPV；改良活病毒疫苗 MLV）+<br>• 犬瘟热病毒（CDV；MLV 或重组）+<br>• 犬腺病毒-2（CAV-2；MLV）：肠外（parenteral） | 最早 6 周龄开始。每 3–4 周加强一次，直至 16 周龄。在特别高风险的情形下持续至 20 周龄，并考虑每 2–3 周接种一次。 | 部分厂商推荐两剂、间隔 2–4 周。但单剂 MLV 或重组疫苗很可能即可保护大多数犬。 | 可考虑在约 6 月龄时复种，而不是等到 12–16 月龄。这可缩小早前未能建立主动免疫应答的任何幼犬的易感窗口。此后在 3 岁龄复种，之后频率不超过每 3 年一次。 | 这些核心疫苗是幼犬和犬所接种疫苗中最重要的一类。目标应是为尽可能大比例的整体群体接种。对幼犬的细心社会化（在其社会化敏感期内）可以在本免疫系列完成之前开始。 |
| • 犬细小病毒-2（CPV；重组）+<br>• 犬瘟热病毒（CDV；MLV）：肠外 | 自 4 周龄起给予单剂，然后再开始常规初次免疫。 | —（抽取稿此格为连字符占位） | —（抽取稿此格为连字符占位） | 这一新近上市的产品专门针对可能存在母源抗体（MDA）干扰的幼龄幼犬，而非用于较大犬只的复种。 |
| • 狂犬病（灭活）：肠外 | 优先遵守任何地方法律或法规。遵守当地生产疫苗的产品说明书（product leaflet）。在一些国家，首剂通常不早于 12 周龄给予。 | 优先遵守任何地方法律或法规。遵守当地生产疫苗的产品说明书。 | 优先遵守任何地方法律或法规。遵守当地生产疫苗的产品说明书。要求在 1 岁龄（或在一些国家为初次免疫 1 年后）复种。市售犬用狂犬病疫苗有 1 年或 3 年免疫持续期（DOI）。加强针时间由核准的 DOI 决定，但某些地区可能由法律规定。 | 在疾病流行地区、或地方法律或法规有要求的地区为核心（Core）疫苗。 |
| • 钩端螺旋体属（Leptospira spp.；灭活菌苗）：肠外。<br>疫苗所含血清群取决于地理区域。多数疫苗至少含 2 个血清群，也有单价、三价和四价产品。 | 首剂通常从 8 周龄开始。何时起种遵循产品说明书的建议。2–4 周后给予第二剂。 | 两剂，间隔 2–4 周。 | 每年一次。 | 在犬钩端螺旋体病流行、相关血清群已知、且有包含相关血清型的合适疫苗可商业获得的地区，为核心疫苗。 |', 'dog', 'young', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 非核心疫苗（NON-CORE VACCINES FOR PET DOGS）', '1.2 非核心疫苗（NON-CORE VACCINES FOR PET DOGS）

| 疫苗 | ≤16 周龄幼犬 | >16 周龄犬 | 复种（Revaccination） | 备注与建议 |
|---|---|---|---|---|
| • 犬副流感病毒（CPiV；MLV）：肠外 | 自 6 周龄起给予，此后每 2–4 周一次，直至 16 周龄或更大。 | 厂商一般推荐两剂、间隔 2–4 周。 | 每年一次。 | 对宠物犬提供的免疫持续期不确定。由于 CPiV 作为单一抗原产品的供应并不广泛，将 CPiV（MLV-黏膜）与支气管败血鲍特菌（Bordetella bronchiseptica）联合使用可能更可取。 |
| • 支气管败血鲍特菌（活无毒菌）：鼻内<br>• B. bronchiseptica（活无毒菌）+ CPiV（MLV）：鼻内<br>• B. bronchiseptica（活无毒菌）+ CPiV（MLV）+ CAV-2（MLV）：鼻内<br>• B. bronchiseptica（活无毒菌）：口服<br>• B. bronchiseptica + CPiV（MLV）：口服 | 这些经黏膜施用（鼻内/口服）的疫苗每种单剂即可提供保护。有些最早可于 3 周龄施用，另一些为 7 或 8 周龄。遵循产品说明书建议。 | 单剂。 | 每年一次。 | 这些供鼻内或口服使用的活疫苗**绝不可**被误作肠外注射，否则可能导致严重不良反应。 |
| • B. bronchiseptica（灭活菌苗）：肠外<br>• B. bronchiseptica（细胞壁抗原提取物）：肠外<br>• B. bronchiseptica（菌毛/fimbrial 抗原）：肠外 | 这些肠外菌苗或亚单位疫苗需要两剂才能完成免疫，一般间隔 2–4 周给予。审阅并遵循产品说明书的间隔。 | 两剂。因产品之间存在差异，请审阅并遵循具体产品说明书的间隔。 | 多数为每年一次。审阅并遵循具体产品说明书的间隔。菌毛（fimbrial）抗原疫苗的复种有特别指示。 | 这些供肠外使用的疫苗不应被误经鼻内或口服给予。这样既无效，又可能造成不必要的痛苦。 |
| • 伯氏疏螺旋体（Borrelia burgdorferi；莱姆疏螺旋体病；灭活全菌苗）：肠外<br>• B. burgdorferi（亚单位—外表面蛋白 A，OspA）：肠外<br>• B. burgdorferi（亚单位 OspA 与嵌合 OspC 蛋白）：肠外 | 这些肠外菌苗或亚单位疫苗需要两剂才能完成免疫，一般约自 8 周龄开始。审阅并遵循具体产品说明书的间隔。 | 两剂，间隔 2–4 周。审阅并遵循具体产品说明书的间隔。 | 每年一次。在（按地区确定的）蜱季开始前即刻加强。 | 一般仅推荐用于已知高暴露风险的犬：居住在或前往媒介蜱暴露风险被认为很高的地区，或疾病已知流行的地区。伯氏疏螺旋体病预防的主要手段是勤勉的体外寄生虫控制。不发生犬对犬的直接传播。 |
| • 犬流感病毒（H3N8；灭活含佐剂）：肠外<br>• 犬流感病毒（H3N2；灭活含佐剂）：肠外<br>• 犬流感病毒（H3N8+H3N2 二价；灭活含佐剂）：肠外 | 这些肠外灭活病毒疫苗需要 2 剂才能完成免疫。首剂可自 6 周龄给予。审阅并遵循具体产品说明书的间隔。 | 两剂。审阅并遵循具体产品说明书的间隔，一般为 2–4 周。 | 每年一次。 | 仅在美国获准上市。可考虑用于同群饲养的高风险犬群，如寄养犬舍（kennels）、犬展或日托中心的犬。 |
| • 犬利什曼病（CanL；重组蛋白 A2）：肠外<br>• CanL（L. infantum 排泄-分泌蛋白 LiESP）：肠外<br>• CanL（重组蛋白 Q）：肠外 | • 三剂，间隔 3 周，首剂在 >4 月龄。<br>• 三剂，间隔 3 周，首剂在 >6 月龄。<br>• 单剂，在 >6 月龄。 | • 三剂，间隔 3 周。<br>• 三剂，间隔 3 周。<br>• 单剂。 | 每年一次。 | 犬利什曼病的预防关键在于勤勉的体外寄生虫控制，以尽量减少与媒介的接触。疫苗可视为补充性控制措施，而非勤勉体外寄生虫控制的替代品。 |
| • 犬疱疹病毒-1（CHV-1；亚单位）：肠外 | 不适用。本疫苗针对妊娠母犬。 | 妊娠期间两剂。第一剂——发情期内或假定交配日期后 7–10 天。第二剂——预产期前 1–2 周。遵循产品说明书。 | 厂商推荐在随后的每次妊娠中重复该 2 针方案。 | 本疫苗旨在保护新生幼犬。感染（通常来自母犬）对未注意保温的 <3 周龄幼犬可致命。 |', 'dog', 'young', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'caution', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 表头附注与图例（原文措辞照录）', '1.3 表头附注与图例（原文措辞照录）

- 表顶不推荐疫苗说明（原文）：*"Vaccines against canine enteric coronavirus, Giardia spp and Microsporum canis, available in some countries, are considered not recommended for pet dogs."* —— 针对犬肠道冠状病毒、贾第虫（Giardia spp.）和犬小孢子菌（Microsporum canis）的疫苗（部分国家有售）被认定为**不推荐（not recommended）**用于宠物犬。
- 分类词原文：核心 = "CORE"，非核心 = "NON-CORE"；表内条件性表述原文："Core wherever the disease is endemic or wherever local laws or regulations require"、"Core for dogs in regions where canine leptospirosis is endemic…"、"Licensed only in USA"、"Not applicable"。
- 说明书用语原文：本表不使用"per label"字样，而统一用 "Follow the product leaflet" / "Review and follow the specific product leaflet intervals"（遵循/审阅并遵循产品说明书间隔）等措辞；抽取稿中未出现 "consider according to lifestyle" 措辞。

2. 宠物猫（非收容所）疫苗速查表

对应原表标题原文：*Core and Non-Core Vaccines for Pet Cats (non-shelter) according to the 2024 guidelines for the vaccination of dogs and cats – compiled by the World Small Animal Veterinary Association (WSAVA) Vaccination Committee.*', '', '', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET CATS）', '2.1 核心疫苗（CORE VACCINES FOR PET CATS）', 'cat', '', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET CATS） (2)', '| 疫苗 | ≤16 周龄幼猫 | >16 周龄猫 | 复种（Revaccination） | 备注与建议 |
|---|---|---|---|---|
| • 猫泛白细胞减少症病毒（FPV；改良活病毒 MLV）+ 猫疱疹病毒-1（FHV；MLV）+ 猫杯状病毒（FCV；MLV）：肠外 | 最早 6 周龄开始，每 3–4 周加强一次直至 16 周龄。在特别高风险的情形下持续至 20 周龄，并考虑每 2–3 周接种一次。 | 一般推荐两剂、间隔 2–4 周，尽管单剂可望保护许多猫。 | 可考虑在约 6 月龄时复种，而不是等到 12–16 月龄。这可缩小早前未能建立主动免疫应答的任何幼猫的易感窗口。此后，"低风险（low risk）"猫在 3 岁龄复种，之后频率不超过每 3 年一次。 | 全球范围核心（Core worldwide）。活减毒 FPV 组分提供快速、强效、持久的保护。对较高风险的猫应考虑更频繁的复种（最高至每年一次）。例如，入住寄养猫舍或出入其他高应激、高风险环境的猫，应在暴露前 1–2 周复种。妊娠母猫和 <4 周龄幼猫不应接种活减毒疫苗。本疫苗被意外雾化（ aerosolization ）或注射部位渗出过多时，可能见到上呼吸道疾病症状。 |
| • FPV（灭活）+ FHV（灭活）+ FCV（灭活）：肠外 | 最早 6 周龄开始，每 3–4 周加强一次直至 16 周龄。在特别高风险的情形下持续至 20 周龄，并考虑每 2–3 周接种一次。 | 两剂，间隔 2–4 周。 | 可考虑在约 6 月龄时复种，而不是等到 12–16 月龄。这可缩小早前未能建立主动免疫应答的任何幼猫的易感窗口。此后，"低风险"猫在 3 岁龄复种，之后每 3 年一次。对较高风险的猫建议每年复种。 | 全球范围核心。肠外灭活 FPV 疫苗一般不会提供像 MLV FPV 疫苗那样起效快、强效、持久的保护。有非佐剂（non-adjuvanted）产品可选。对妊娠母猫被认为比 MLV 疫苗更安全。感染逆转录病毒的猫不应避免接种；对某些感染逆转录病毒的猫，灭活疫苗可能优于 MLV。双毒株（二价）灭活 FCV 疫苗旨在提供更广的保护。对较高风险的猫应考虑更频繁的复种（最高至每年一次）。例如，入住寄养猫舍或出入其他高应激、高风险环境的猫，可在暴露前 1–2 周复种。 |
| • FPV（MLV）+ FHV（MLV）+ FCV（MLV）：鼻内；或<br>• FHV（MLV）+ FCV（MLV）：鼻内 | 遵循产品说明书。 | 单剂。 | 每年一次。 | 鼻内 FPV 接种不如肠外接种有效。即使使用三价鼻内疫苗，也应同时接种肠外（皮下）FPV 疫苗。使用后可能见到上呼吸道疾病症状。对 FHV 和 FCV 起保护快。鼻内与肠外 FHV/FCV 疫苗联合使用可能提供增强保护。入住寄养猫舍或出入其他高应激、高风险环境的猫，可在暴露前 1–2 周复种。 |
| • 狂犬病（金丝雀痘病毒载体重组、非佐剂）：肠外 | 优先遵守当地法规。若没有法规，遵循产品说明书。 | 优先遵守当地法规。若没有法规，遵循产品说明书。 | 按当地法规要求或按核准的免疫持续期（DOI）/产品说明书复种。 | 在疾病流行地区为核心。 |
| • 狂犬病（1 年和 3 年 DOI 灭活、含佐剂产品）：肠外 | 优先遵守当地法规。若没有法规，遵循产品说明书。 | 优先遵守当地法规。若没有法规，遵循产品说明书。 | 按当地法规要求或按核准的免疫持续期（DOI）/产品说明书复种。 | 在疾病流行地区为核心。 |
| • 猫白血病病毒（FeLV；重组，含或不含佐剂）：肠外 | 最早可自 8 周龄开始。3–4 周后给予第二剂。 | 两剂，间隔 3–4 周。 | 在初免系列最后一剂后 1 年复种。此后，对持续处于与其他 FeLV 感染猫接触高风险的猫（室内或室外）每年复种。 | 在 FeLV 感染流行的地区，FeLV 疫苗对 <1 岁的年轻猫为核心；对持续有暴露风险的成年猫（例如在 FeLV 流行地区有经常、无监管户外通行的成猫）亦为核心。避免暴露是预防 FeLV 感染的最佳方式。**仅 FeLV 阴性猫应接种**。接种疫苗前应进行 FeLV 检测。被可能 FeLV 感染猫咬伤而持续处于高风险的成年猫应以何种频率复种 FeLV 疫苗，值得进一步研究。 |
| • FeLV（灭活，含或不含佐剂）：肠外 | 最早可自 8 周龄开始。3–4 周后给予第二剂。 | 两剂，间隔 3–4 周。 | 在初免系列最后一剂后 1 年复种。此后，对持续处于与 FeLV 感染猫接触高风险的猫（室内或室外）每年复种。对可能接触 FeLV 感染猫风险较低的猫，按产品说明书（例如每 2 或 3 年）复种。', '', 'young', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 核心疫苗（CORE VACCINES FOR PET CATS） (3)', '| 原文此处缺失（抽取稿该格为空）。 |', '', '', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 非核心疫苗（NON-CORE VACCINES FOR PET CATS）', '2.2 非核心疫苗（NON-CORE VACCINES FOR PET CATS）

| 疫苗 | ≤16 周龄幼猫 | >16 周龄猫 | 复种（Revaccination） | 备注与建议 |
|---|---|---|---|---|
| • 猫免疫缺陷病毒（FIV；灭活、含佐剂）：肠外 | 需三剂才能完成免疫。首剂最早可于 8 周龄给予；随后两剂以 2–3 周间隔给予。 | 需三剂。每剂间隔 2–3 周给予。 | 在初免系列最后一剂后 1 年给予单剂，此后对被判定处于持续暴露风险的猫每年一次。 | 避免暴露是预防 FIV 感染的最佳方式。本疫苗目前仅在亚洲、澳大利亚和新西兰有售。关于其有效性的报道差异很大。接种会诱导出用于感染诊断的抗体。不过，一些临床用诊断试剂盒能够可靠区分已接种未感染猫与感染猫。经验证的可靠 PCR 诊断检测也在变得更广泛可得。 |
| • 猫衣原体（Chlamydia felis；无毒活疫苗、非佐剂）：肠外<br>• C. felis（灭活、含佐剂）：肠外 | 首剂最早可于 8–9 周龄给予；第二剂在 2–4 周后给予。 | 给予两剂，间隔 2–4 周。 | 对处于持续暴露风险的猫，指征为每年加强。 | 疫苗最适宜用作多猫环境中控制方案的一部分——在这些环境中，与临床疾病相关的感染已被证实。有报道活疫苗不慎结膜接种（conjunctival inoculation）可引起临床疾病。 |
| • 支气管败血鲍特菌（Bordetella bronchiseptica；无毒活疫苗、非佐剂）：鼻内 | 最早可于 4 周龄鼻内给予单剂。 | 鼻内给予单剂。 | 对处于持续暴露风险的猫，指征为每年加强。 | 宠物猫不常规使用。对饲养在特别大规模猫群（unusually large colonies）中的宠物猫可考虑使用。 |', 'cat', 'young', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 表头附注与图例（原文措辞照录） (2)', '2.3 表头附注与图例（原文措辞照录）

- 表顶不推荐疫苗说明（原文）：*"Vaccines against feline infectious peritonitis, Giardia spp and Microsporum canis, available in some countries, are considered not recommended for pet cats."* —— 针对猫传染性腹膜炎、贾第虫（Giardia spp.）和犬小孢子菌（Microsporum canis）的疫苗（部分国家有售）被认定为**不推荐（not recommended）**用于宠物猫。
- 分类词原文：核心 = "CORE"，非核心 = "NON-CORE"；表内条件性表述原文："Core worldwide"、"Core in areas where the disease is endemic"、"Annual boosters are indicated for cats at sustained risk of exposure"。
- 说明书用语原文：本表同样使用 "Follow product leaflet" / "Revaccinate according to product leaflet (e.g. every 2 or 3 years)" 等措辞；抽取稿中未出现 "per label" 或 "consider according to lifestyle" 字样。

3. 收容所犬猫疫苗速查表

对应原表标题原文：*Core Vaccines for Dogs and Cats in Shelters according to the 2024 guidelines for the vaccination of dogs and cats – compiled by the World Small Animal Veterinary Association (WSAVA) Vaccination Committee.*
（注意：收容所速查表只列核心疫苗，未收录非核心疫苗。）', '', '', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 收容所犬核心疫苗（CORE VACCINES FOR SHELTER DOGS）', '3.1 收容所犬核心疫苗（CORE VACCINES FOR SHELTER DOGS）

| 疫苗 | <5 月龄 | ≥5 月龄 | 备注（Comments） |
|---|---|---|---|
| • 犬细小病毒-2（CPV；MLV）+<br>• 犬瘟热病毒（CDV；MLV 或重组）+<br>• 犬腺病毒-2（CAV-2；MLV）+<br>• 犬副流感病毒（CPiV；MLV）：肠外（抽取稿原文此格末尾有一个多余的 "]" 排印残迹） | 入院时立即给予，自 1 月龄开始。每 2–3 周重复一次，直至 5 月龄。 | 入院时立即给予。2–3 周后重复。 | 使用含改良活病毒或重组 CDV 的联合疫苗，以获得更快的免疫起效。 |
| • B. bronchiseptica（活无毒菌）+ CPiV（MLV）：鼻内<br>• B. bronchiseptica（活无毒菌）+ CPiV（MLV）+ CAV-2（MLV）：鼻内<br>• B. bronchiseptica（活无毒菌）：口服<br>• B. bronchiseptica + CPiV（MLV）：口服 | 入院时立即给予，自 3 周龄开始。／入院时立即给予，依所选疫苗自 7 或 8 周龄开始。（抽取稿此格为两句并列） | 入院时立即给予。／入院时立即给予。（抽取稿此格为两句重复并列） | 含改良活 B. bronchiseptica 及至少 CPiV 的鼻内疫苗更适合快速达到最佳免疫起效。它们最早可于 3 周龄给予。口服疫苗可用于 7 或 8 周龄及以上犬，但更年幼的犬必须使用鼻内疫苗。 |
| • 狂犬病病毒（灭活）：肠外 | 遵守当地法律关于最低接种年龄的规定。短期留置收容所在放行（discharge）时给予，长期留置收容处在入院时给予。 | 原文此处缺失（抽取稿该格为空） | 仅狂犬病流行国家。按当地法律给予。 |', 'dog', '', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 收容所猫核心疫苗（CORE VACCINES FOR SHELTER CATS）', '3.2 收容所猫核心疫苗（CORE VACCINES FOR SHELTER CATS）

| 疫苗 | <5 月龄 | ≥5 月龄 | 备注（Comments） |
|---|---|---|---|
| • FPV（MLV）+ FHV（MLV）+ FCV（MLV）：肠外<br>• FHV（MLV）+ FCV（MLV）：鼻内 | 入院时立即给予，最早可自 1 月龄开始。每 2–3 周重复一次，直至 5 月龄。 | 入院时立即给予。2–3 周后重复。 | 使用含改良活病毒的联合疫苗以快速起效免疫。含改良活 FHV+FCV 的鼻内疫苗可用于更快的免疫起效。不推荐在收容所使用鼻内 FPV 疫苗，因为它们不能提供针对 FPV 的可靠保护。 |
| • 狂犬病病毒（灭活）：肠外 | 遵守当地法律关于最低接种年龄的规定。短期留置收容所在放行时给予，长期留置收容处在入院时给予。 | 原文此处缺失（抽取稿该格为空） | 仅狂犬病流行国家。按当地法律或法规给予。 |

3.3 表头附注与图例（原文措辞照录）

- 收容所表仅包含核心疫苗（"Core Vaccines for Dogs and Cats in Shelters"），列标题原文为 "Vaccine | < 5 Months Old | ≥ 5 Months Old | Comments"，与宠物犬猫表的五列结构（含 Puppies/Kittens ≤ 16 weeks、Dogs/Cats > 16 weeks、Revaccination）不同。
- 关键措辞原文："Administer immediately at/upon admission"（入院时立即给予）、"starting at 1 month of age"、"Repeat every 2 to 3 weeks until 5 months old"、"Follow local laws for minimum age for vaccination"、"Rabies-endemic countries only"。', '', 'young', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫疫苗速查表 · 三表通用缩写与术语（均照抽取稿原文展开）', '3.4 三表通用缩写与术语（均照抽取稿原文展开）

| 缩写 | 原文全称 | 中文 |
|---|---|---|
| MLV | modified live virus | 改良活病毒 |
| CPV | Canine Parvovirus-2 | 犬细小病毒-2 型 |
| CDV | Canine Distemper Virus | 犬瘟热病毒 |
| CAV-2 | Canine Adenovirus-2 | 犬腺病毒-2 型 |
| CPiV | Canine Parainfluenza Virus | 犬副流感病毒 |
| MDA | maternally derived antibody（犬表注："interfering MDA"） | 母源抗体 |
| DOI | duration of immunity | 免疫持续期 |
| product leaflet | 原文用词（未用 "per label"） | 产品说明书 |
| FPV | Feline Panleukopenia Virus | 猫泛白细胞减少症病毒 |
| FHV | Feline Herpesvirus-1 | 猫疱疹病毒-1 型 |
| FCV | Feline Calicivirus | 猫杯状病毒 |
| FeLV | Feline Leukemia Virus（原文作 "FeLV infected cats"） | 猫白血病病毒 |
| FIV | Feline Immunodeficiency Virus | 猫免疫缺陷病毒 |
| CHV-1 | Canine herpesvirus-1 | 犬疱疹病毒-1 型 |
| CanL | Canine leishmaniosis | 犬利什曼病 |
| LiESP | excreted-secreted proteins (of L. infantum) | 婴儿利什曼原虫排泄-分泌蛋白 |
| OspA / OspC | Outer surface protein A / C (Borrelia burgdorferi) | 伯氏疏螺旋体外表面蛋白 A / C |
| parenteral / intranasal / oral | 原文施用语 | 肠外（注射）／鼻内／口服 |', '', '', '', '疫苗,疫苗速查表,速查表,核心疫苗,非核心疫苗,不推荐疫苗,宠物犬（非收容所）疫苗速查表,宠物猫（非收容所）疫苗速查表,收容所犬猫疫苗速查表', 'informational', 'WSAVA 犬猫疫苗速查表（宠物犬／宠物猫／收容所）', 'official', 'https://wsava.org/global-guidelines/vaccination-guidelines/', 'approved'),
('WSAVA 犬猫营养指南知识库 — 总索引 · 第 1 段', 'WSAVA 犬猫营养指南知识库 — 总索引

> 本知识库基于 World Small Animal Veterinary Association (WSAVA) Global Nutrition Committee 发布的官方营养指南资料整理而成，共19个原始PDF文档，整合为10个主题文档，适用于RAG知识库检索。', '', '', '', '营养,知识库文档清单,核心概念速查,适用场景索引', 'informational', 'WSAVA 犬猫营养指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 犬猫营养指南知识库 — 总索引 · 知识库文档清单', '知识库文档清单

| 编号 | 文档名称 | 主要内容 | 原始PDF来源 |
|------|---------|---------|-------------|
| 01 | [WSAVA营养评估指南概述](01-WSAVA营养评估指南概述.md) | 营养评估两步流程、第五生命体征、风险因素、实施策略、沟通技巧 | Implementing the WSAVA Nutrition Guidelines; Quick Tips on Implementing |
| 02 | [犬猫每日能量需求参考表](02-犬猫每日能量需求参考表.md) | RER/DER计算公式、猫热量表（1-7kg）、犬热量表（2-49kg）、住院RER速查表、计算步骤 | Calorie Needs for Healthy Adult Cats; Calorie Needs for Healthy Adult Dogs |
| 03 | [犬猫体况评分BCS系统](03-犬猫体况评分BCS系统.md) | 9分制BCS标准、猫/犬各评分描述、评估要点、与MCS关系 | WSAVA BCS Cat; WSAVA BCS Dog |
| 04 | [犬猫肌肉状况评分MCS](04-犬猫肌肉状况评分MCS.md) | MCS评估方法、4级评分标准、与BCS独立关系、触诊要点 | Muscle Condition Score Chart for Dogs (Tufts Univ.) |
| 05 | [饮食历史表与营养评估清单](05-饮食历史表与营养评估清单.md) | 饮食历史表模板、营养评估清单流程、筛查/扩展评估、建议与监测 | Diet History Form; Nutritional Assessment Checklist |
| 06 | [住院犬猫喂养指南](06-住院犬猫喂养指南.md) | 营养干预时机、喂养途径决策、RER计算、喂养方案制定、监测表 | Feeding Guide for Hospitalized Dogs and Cats; Feeding Instructions and Monitoring Chart |
| 07 | [宠物食品选择指南](07-宠物食品选择指南.md) | 品牌评估四问、标签评估四问、AAFCO/FEDIAF标准、质量控制 | Selecting a Pet Food (Updated 2021) |
| 08 | [宠物生肉基饮食指南](08-宠物生肉基饮食指南.md) | RMBD定义、细菌/骨骼/营养/寄生虫风险、临床注意事项 | Raw Meat-Based Diets for Pets |
| 09 | [犬猫零食喂养指南](09-犬猫零食喂养指南.md) | 10%原则、热量上限表、有毒食物清单、常见食物热量密度 | Guide to Treats for Cats (2025); Guide to Treats for Dogs (2025) |
| 10 | [互联网营养信息评估指南](10-互联网营养信息评估指南.md) | 网站评估八准则、可信来源列表、ACVN/ECVCN认证说明 | Savvy Cat Owner''s Guide; Savvy Dog Owner''s Guide |', '', '', '', '营养,知识库文档清单,核心概念速查,适用场景索引', 'informational', 'WSAVA 犬猫营养指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 犬猫营养指南知识库 — 总索引 · 核心概念速查', '核心概念速查

营养评估核心

| 概念 | 说明 | 详见 |
|------|------|------|
| 第五生命体征 | 营养评估应与体温、脉搏、呼吸、疼痛并列为每次体检必做项目 | 01 |
| 筛查评估 | 每次就诊对每只宠物进行：饮食历史、体重、BCS、MCS | 01, 05 |
| 扩展评估 | 发现风险因素时进行：生化、血常规、被毛皮肤等详细检查 | 01, 05 |
| 营养风险因素 | 分强制和可选两级，涵盖年龄、疾病、饮食类型、BCS异常等 | 01, 05 |

能量与喂养核心

| 概念 | 公式/标准 | 详见 |
|------|----------|------|
| RER（静息能量需求） | `70 × BW^0.75` 或 `30 × BW(kg) + 70`（2-30kg简化） | 02, 06 |
| 猫DER | 消瘦型：`100 × BW`；易胖型：`130 × BW^0.67` | 02 |
| 犬DER | 活跃：`130 × BW^0.75`；不活跃：`95 × BW^0.75` | 02 |
| 住院喂养目标 | 达到RER，可分2-3天逐步达到 | 06 |
| 营养干预时机 | 厌食5天必须干预；已营养不良则血流动力学稳定后立即干预 | 06 |

体况评估核心

| 概念 | 标准 | 详见 |
|------|------|------|
| BCS理想值 | 猫/犬均为 4-5/9 | 03 |
| BCS异常 | <4 偏瘦需排查；>5 偏胖需减重 | 03 |
| MCS分级 | 正常/轻度/中度/重度肌肉流失 | 04 |
| BCS与MCS独立性 | 超重动物也可能肌肉流失；偏瘦动物也可能肌肉正常 | 03, 04 |

食品安全与选择核心

| 概念 | 要点 | 详见 |
|------|------|------|
| 品牌评估 | 营养师资质、配方者、质量控制、研究发表 | 07 |
| 标签评估 | 营养充分性声明、热量标注、联系方式、制造商 | 07 |
| 零食原则 | 不超过每日总热量的10% | 09 |
| 生肉饮食 | WSAVA不推荐——细菌/寄生虫/营养不均衡风险 | 08 |
| 有毒食物 | 巧克力、木糖醇、葡萄/葡萄干、洋葱类、澳洲坚果（犬） | 09 |

适用场景索引

场景 1：日常营养咨询

**流程：** 饮食历史 → BCS/MCS评估 → 能量需求计算 → 饮食建议

**参考文档：** 01, 02, 03, 04, 05

场景 2：肥胖管理

**流程：** BCS评估 → 当前热量摄入计算 → 目标热量设定 → 喂养方案调整 → 监测

**参考文档：** 02, 03, 09', '', '', '', '营养,知识库文档清单,核心概念速查,适用场景索引', 'informational', 'WSAVA 犬猫营养指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 犬猫营养指南知识库 — 总索引 · 场景 3：住院营养支持', '场景 3：住院营养支持

**流程：** 厌食天数评估 → RER计算 → 喂养途径选择 → 喂养计划制定 → 每日监测

**参考文档：** 02, 06

场景 4：宠物食品推荐

**流程：** 品牌评估四问 → 标签评估四问 → 生命阶段匹配 → 具体推荐

**参考文档：** 07, 10

场景 5：特殊饮食咨询（生食/自制）

**流程：** 了解当前饮食 → 风险评估 → 营养不均衡排查 → 替代方案建议

**参考文档：** 08, 09, 10

场景 6：客户教育

**流程：** 评估客户信息来源 → 指导网站评估方法 → 推荐可信资源

**参考文档：** 10

关键缩写对照表

| 缩写 | 英文全称 | 中文 |
|------|---------|------|
| WSAVA | World Small Animal Veterinary Association | 世界小动物兽医协会 |
| BCS | Body Condition Score | 体况评分 |
| MCS | Muscle Condition Score | 肌肉状况评分 |
| RER | Resting Energy Requirement | 静息能量需求 |
| DER | Daily Energy Requirement | 每日能量需求 |
| NRC | National Research Council | 美国国家研究委员会 |
| AAFCO | Association of American Feed Control Officials | 美国饲料管理官员协会 |
| FEDIAF | European Pet Food Industry Federation | 欧洲宠物食品工业联合会 |
| ACVN | American College of Veterinary Nutrition | 美国兽医营养学院 |
| ECVCN | European College of Veterinary Comparative Nutrition | 欧洲兽医比较营养学院 |
| AAHA | American Animal Hospital Association | 美国动物医院协会 |
| AVMA | American Veterinary Medical Association | 美国兽医协会 |
| RMBD | Raw Meat-Based Diet | 生肉基饮食 |', '', '', '', '营养,知识库文档清单,核心概念速查,适用场景索引', 'informational', 'WSAVA 犬猫营养指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 犬猫营养指南知识库 — 总索引 · 原始PDF文件来源', '原始PDF文件来源

| 文件名 | 主题 | 页数 |
|--------|------|------|
| Calorie-Needs-for-Healthy-Adult-Cats-updated-July-2020.pdf | 猫每日热量需求 | 1 |
| Calorie-Needs-for-Healthy-Adult-Dogs-updated-July-2020.pdf | 犬每日热量需求 | 1 |
| Diet-History-Form.pdf | 饮食历史表 | 1 |
| Feeding-Guide-for-Hospitalized-Dogs-and-Cats.pdf | 住院喂养指南 | 2 |
| Feeding-Instructions-and-Monitoring-Chart-for-Hospitalized-Patients.pdf | 住院喂养指导表 | 2 |
| Implementing-the-WSAVA-Nutrition-Guidelines.pdf | 实施营养评估指南 | 2 |
| Muscle-Condition-Score-Chart-for-Cats.pdf | 猫MCS评分图（纯图片） | 1 |
| Muscle-Condition-Score-Chart-for-Dogs.pdf | 犬MCS评分图 | 1 |
| Nutritional-Assessment-Checklist.pdf | 营养评估清单 | 2 |
| Quick-Tips-on-Implementing-the-WSAVA-Nutrition-Guidelines.pdf | 实施快速提示 | 14 |
| Raw-Meat-Based-Diets-for-Pets_WSAVA-Global-Nutrition-Toolkit.pdf | 生肉基饮食 | 1 |
| Selecting-a-pet-food-for-your-pet-updated-2021_WSAVA-Global-Nutrition-Toolkit.pdf | 宠物食品选择 | 1 |
| The-Savvy-Cat-Owner-s-Guide-to-Nutrition-on-the-Internet.pdf | 猫主人互联网营养指南 | 2 |
| The-Savvy-Dog-Owner-s-Guide-to-Nutrition-on-the-Internet.pdf | 犬主人互联网营养指南 | 2 |
| WSAVA_BCSCat_BCSCat_Nutrition_250612.pdf | 猫BCS评分图 | 1 |
| WSAVA_BCSCat_BCSDog_Nutrition_250612.pdf | 犬BCS评分图 | 1 |
| WSAVA_GuidetoTreats_Cats_251107.pdf | 猫零食指南 | 4 |
| WSAVA_GuidetoTreats_Dogs_251107.pdf | 犬零食指南 | 4 |', '', '', '', '营养,知识库文档清单,核心概念速查,适用场景索引', 'informational', 'WSAVA 犬猫营养指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 犬猫营养指南知识库 — 总索引 · 版权说明', '版权说明

本文档内容整理自 WSAVA（World Small Animal Veterinary Association）Global Nutrition Committee 发布的公开营养指南资料。

- © World Small Animal Veterinary Association (WSAVA) 2011-2025. All rights reserved.
- © Copyright Tufts University, 2013. Used with permission.（MCS评分图）
- 所有权利归原作者和机构所有。本文档仅供内部知识库研究使用。
- WSAVA官方网站：wsava.org', '', '', '', '营养,知识库文档清单,核心概念速查,适用场景索引', 'informational', 'WSAVA 犬猫营养指南知识库 — 总索引', 'official', '', 'approved'),
('WSAVA 营养评估指南概述 · 第 1 段', 'WSAVA 营养评估指南概述

1. 指南背景与目的

WSAVA（世界小动物兽医协会）于2011年7月发布了《犬猫营养评估指南》（Nutritional Assessment Guidelines for Dogs and Cats），旨在为兽医团队提供营养评估的框架，帮助他们为患者做出营养评估和营养建议。

**核心目标：** 在每次体检中，为每只宠物进行营养评估并给出具体的饮食建议。

**制定原因：**
- 营养是宠物最佳护理不可分割的一部分
- 评估犬猫的营养需求需要考虑诸多因素（健康宠物和患病宠物均如此）
- AAHA（美国动物医院协会）2003年合规研究发现：仅有7%可能从治疗性食品中受益的宠物实际上在使用此类食品
- 90%的宠物主人希望获得营养建议，但只有15%认为实际得到了建议

**支持机构：**
- AAHA（美国动物医院协会）
- AVMA（美国兽医协会）
- ACVN（美国兽医营养学院）
- CVMA（加拿大兽医协会）
- ECVCN（欧洲兽医比较营养学院）
- NAVTA（美国兽医技师协会）

2. 营养评估的两步流程

营养评估分为两个部分：

2.1 筛查评估（Screening Evaluation）

**对象：** 每只宠物，每次就诊时进行

**内容：**
- 饮食历史/活动水平
- 体重
- 体况评分（BCS）
- 肌肉状况评分（MCS）

**目的：** 作为常规病史采集和体格检查的一部分，无缝整合到每次患者检查中，评估当前营养状况、摄入量和活动水平。

2.2 扩展评估（Extended Evaluation）

**触发条件：** 当筛查评估发现或怀疑存在一个或多个营养相关风险因素时

**内容包括：**
- 饮食摄入变化的详细评估
- 血清生化指标异常检查
- 被毛/皮肤状况评估
- 血常规异常检查
- 粪便/尿液分析

3. 营养风险因素

3.1 需要扩展评估的风险因素（强制性）

- 胃肠道功能异常病史（呕吐、腹泻、恶心、胀气、便秘）
- 既往或现有疾病
- 正在接受药物和/或膳食补充剂
- 非常规饮食（生食、自制、素食、不熟悉的饮食）
- 零食/零食/餐桌食物 > 总热量的10%
- 不适当或不充足的住所环境
- 体况评分 <4 或 >5（9分制）
- 肌肉状况评分：轻度、中度或重度肌肉萎缩
- 无法解释的体重变化
- 牙齿异常或疾病
- 皮肤或被毛状况差
- 新发疾病

3.2 可选扩展评估的风险因素

- 极低或极高活动水平
- 多宠物家庭
- 妊娠期
- 哺乳期
- 生长期
- 年龄 >7岁', '', '', '', '营养,WSAVA,营养评估,筛查评估,扩展评估,第五生命体征,指南背景与目的,营养评估的两步流程,营养风险因素', 'informational', 'WSAVA 营养评估指南概述', 'official', '', 'approved'),
('WSAVA 营养评估指南概述 · 营养——第五大生命体征', '4. 营养——第五大生命体征

WSAVA将营养定义为**第五大生命体征**（The 5th Vital Assessment），与体温（T）、脉搏（P）、呼吸（R）、疼痛（P）并列。

**核心原则：** 每只宠物，每次就诊，都要进行营养评估并给出具体饮食建议。

5. 实施成功的关键因素

5.1 制定定制化书面方案

成功的实施需要诊所制定定制化的书面方案，确保：
- 每位患者都接受营养评估和具体饮食建议
- 评估和建议是体格检查流程的组成部分
- 评估和建议记录在宠物的病历中
- 每次检查都对每只宠物完成此流程

5.2 团队承诺

- 实践主人和高级员工需树立榜样，展示对营养在患者护理中价值的强烈信念
- 医疗团队的每个成员都需理解自己在将营养纳入患者护理中的角色
- 所有团队成员都应真正相信为每只宠物提供营养评估和具体饮食建议是"最佳医学实践"

5.3 持续培训

- 建立定期的员工培训论坛
- 每个团队成员都能回答关于诊所营养理念和推荐饮食关键要点的基本问题
- 前台员工在客户沟通中发挥关键作用
- 指定一名或多名兽医技师作为诊所内的营养倡导者

5.4 一致的沟通

- 定期进行员工培训或讨论，练习如何以最有效的方式传递一致的信息
- 医疗团队需理解良好的倾听技巧可能是有效客户沟通最重要的组成部分

6. 沟通技巧

6.1 评估患者——探索宠物的营养和喂养方案

- "在正常的一天，[宠物名] 吃什么？请包括任何零食或人食。"
- "[宠物名] 的饮食最近有什么变化吗？"
- "[宠物名] 在当前的食物上有遇到过什么问题吗？之前的食物呢？"
- "[宠物名] 不喜欢什么食物？能告诉我更多吗？"

6.2 了解客户的观点

- "[宠物名] 当前的食物对您来说效果如何？有什么顾虑吗？"
- "在选择宠物食物时，什么对您来说最重要？"
- "您提到想为[宠物名]选择最好的；您说的''最好''具体是什么意思？"

6.3 做出具体的营养建议

- "我们都想为[宠物名]提供最好的。根据您之前分享的信息，以及我的经验和这方面的研究，我相信[食物名称和形式]将对[宠物名]及其长期健康和幸福最有益，因为……"
- **务必告诉客户为什么做出这个特定建议**

6.4 结束讨论——回到客户的角度

- "您对实施这些变化有什么顾虑？"
- "您预见到什么挑战？"
- "您还有什么问题想问我？"', '', '', '', '营养,WSAVA,营养评估,筛查评估,扩展评估,第五生命体征,指南背景与目的,营养评估的两步流程,营养风险因素', 'informational', 'WSAVA 营养评估指南概述', 'official', '', 'approved'),
('WSAVA 营养评估指南概述 · 自我评估清单', '7. 自我评估清单

诊所可通过以下维度评估自身营养实践的实施情况：

| 维度 | 评估要点 |
|------|---------|
| 热情与承诺 | 实践主人和高级员工是否树立榜样？网站/教育材料是否传达营养的重要性？ |
| 团队协作 | 每个成员是否理解自己的角色？是否有机会在病例讨论中讨论营养的关键作用？ |
| 信念与文化 | 所有成员是否相信"每只宠物每次检查都进行营养评估"是最佳医学实践？ |
| 一致沟通 | 是否有定期培训？团队是否理解倾听技巧的重要性？ |
| 持续培训 | 是否有定期培训论坛？每个成员能否回答基本营养问题？ |
| 文档记录 | 是否有书面方案明确定义每个团队成员的角色和责任？ |
| 评估流程 | 是否有流程审查病历以确保营养方案得到执行？ |', '', '', '', '营养,WSAVA,营养评估,筛查评估,扩展评估,第五生命体征,指南背景与目的,营养评估的两步流程,营养风险因素', 'informational', 'WSAVA 营养评估指南概述', 'official', '', 'approved'),
('WSAVA 犬猫每日能量需求参考表 · 第 1 段', 'WSAVA 犬猫每日能量需求参考表

1. 计算公式

1.1 静息能量需求（RER）

RER 是动物在静息状态下维持基本生命功能所需的能量，是所有能量需求计算的基础。

**通用公式：**
```
RER = 70 × (体重kg)^0.75
```

**简化公式（适用于 2kg ~ 30kg 的犬猫）：**
```
RER = 30 × 体重kg + 70
```

1.2 猫每日维持能量需求（DER）

基于 2006 NRC 每日维持能量需求（Maintenance Energy Requirement, MER）：

| 猫类型 | 公式 |
|--------|------|
| 消瘦型成年猫（Lean Adult） | `100 kcal × 体重kg` |
| 易胖型成年猫（Obese-prone Adult） | `130 kcal × 体重kg^0.67` |

1.3 犬每日维持能量需求（DER）

基于 2006 NRC 每日维持能量需求：

| 犬类型 | 公式 |
|--------|------|
| 活跃成年犬（Active Adult） | `130 kcal × 体重kg^0.75` |
| 不活跃成年犬（Inactive Adult） | `95 kcal × 体重kg^0.75` |

> **注意：** 以上推荐仅供参考。每只宠物都是个体，部分宠物可能需要更高或更低的热量摄入来维持理想的体态。

2. 健康成年猫每日热量需求表

适用于理想体况的健康成年猫。

| 体重 (kg) | 体重 (lb) | 每日千卡 (kcal/day) |
|-----------|-----------|---------------------|
| 1.0 | 2.2 | 100–130 |
| 1.5 | 3.3 | 130–150 |
| 2.0 | 4.4 | 160–170 |
| 2.5 | 5.5 | 180–190 |
| 3.0 | 6.6 | 200–210 |
| 3.5 | 7.7 | 215–230 |
| 4.0 | 8.8 | 225–250 |
| 4.5 | 9.9 | 240–270 |
| 5.0 | 11.0 | 250–290 |
| 5.5 | 12.1 | 260–310 |
| 6.0 | 13.2 | 265–330 |
| 6.5 | 14.3 | 275–350 |
| 7.0 | 15.4 | 280–370 |

**说明：** 范围的低值对应易胖型猫（130 × BW^0.67），高值对应消瘦型猫（100 × BW）。', '', '', '', '营养,能量需求,热量计算,RER,DER,维持能量,计算公式,健康成年猫每日热量需求表,健康成年犬每日热量需求表', 'informational', 'WSAVA 犬猫每日能量需求参考表', 'official', '', 'approved'),
('WSAVA 犬猫每日能量需求参考表 · 健康成年犬每日热量需求表', '3. 健康成年犬每日热量需求表

适用于理想体况的健康成年犬。

| 体重 (kg) | 体重 (lb) | 每日千卡 (kcal/day) | 体重 (kg) | 体重 (lb) | 每日千卡 (kcal/day) |
|-----------|-----------|---------------------|-----------|-----------|---------------------|
| 2 | 4.4 | 140–177 | 26 | 57.2 | 970–1209 |
| 3 | 6.6 | 190–239 | 27 | 59.4 | 1000–1244 |
| 4 | 8.8 | 240–297 | 28 | 61.6 | 1020–1278 |
| 5 | 11.0 | 280–351 | 29 | 63.8 | 1050–1312 |
| 6 | 13.2 | 320–403 | 30 | 66.0 | 1080–1346 |
| 7 | 15.4 | 360–452 | 31 | 68.2 | 1100–1397 |
| 8 | 17.6 | 400–499 | 32 | 70.4 | 1130–1413 |
| 9 | 19.8 | 440–546 | 33 | 72.6 | 1160–1446 |
| 10 | 22.0 | 470–590 | 34 | 74.8 | 1180–1478 |
| 11 | 24.2 | 510–634 | 35 | 77.0 | 1210–1511 |
| 12 | 26.4 | 540–677 | 36 | 79.2 | 1240–1543 |
| 13 | 28.6 | 580–719 | 37 | 81.4 | 1260–1575 |
| 14 | 30.8 | 610–760 | 38 | 83.6 | 1290–1607 |
| 15 | 33.0 | 640–800 | 39 | 85.8 | 1310–1639 |
| 16 | 35.2 | 670–840 | 40 | 88.0 | 1340–1670 |
| 17 | 37.4 | 700–879 | 41 | 90.2 | 1360–1701 |
| 18 | 39.6 | 730–918 | 42 | 92.4 | 1390–1732 |
| 19 | 41.8 | 760–956 | 43 | 94.6 | 1410–1763 |
| 20 | 44.0 | 790–993 | 44 | 96.8 | 1440–1794 |
| 21 | 46.2 | 820–1030 | 45 | 99.0 | 1460–1824 |
| 22 | 48.4 | 850–1067 | 46 | 101.2 | 1480–1855 |
| 23 | 50.6 | 880–1103 | 47 | 103.4 | 1510–1885 |
| 24 | 52.8 | 910–1139 | 48 | 105.6 | 1530–1915 |
| 25 | 55.0 | 940–1174 | 49 | 107.8 | 1560–1945 |

**说明：** 范围的低值对应不活跃成年犬（95 × BW^0.75），高值对应活跃成年犬（130 × BW^0.75）。', 'dog', '', '', '营养,能量需求,热量计算,RER,DER,维持能量,计算公式,健康成年猫每日热量需求表,健康成年犬每日热量需求表', 'informational', 'WSAVA 犬猫每日能量需求参考表', 'official', '', 'approved'),
('WSAVA 犬猫每日能量需求参考表 · 住院动物静息能量需求（RER）速查表', '4. 住院动物静息能量需求（RER）速查表

适用于住院期间的犬猫，用于制定喂养计划。

| 体重 (kg) | RER (kcal/day) | 体重 (kg) | RER (kcal/day) |
|-----------|----------------|-----------|----------------|
| 1.0 | 70 | 15.0 | 534 |
| 1.5 | 95 | 16.0 | 560 |
| 2.0 | 118 | 17.0 | 586 |
| 2.5 | 139 | 18.0 | 612 |
| 3.0 | 160 | 19.0 | 637 |
| 3.5 | 179 | 20.0 | 662 |
| 4.0 | 198 | 22.5 | 723 |
| 4.5 | 216 | 25.0 | 783 |
| 5.0 | 234 | 27.5 | 841 |
| 5.5 | 251 | 30.0 | 897 |
| 6.0 | 268 | 32.5 | 953 |
| 6.5 | 285 | 35.0 | 1007 |
| 7.0 | 301 | 37.5 | 1061 |
| 7.5 | 317 | 40.0 | 1113 |
| 8.0 | 333 | 42.5 | 1165 |
| 8.5 | 348 | 45.0 | 1216 |
| 9.0 | 364 | 47.5 | 1267 |
| 9.5 | 379 | 50.0 | 1316 |
| 10.0 | 394 | 52.5 | 1365 |
| 11.0 | 423 | 55.0 | 1414 |
| 12.0 | 451 | 57.5 | 1462 |
| 13.0 | 479 | 60.0 | 1509 |
| 14.0 | 507 | | |

5. 能量需求计算步骤

步骤 1：计算静息能量需求（RER）
- 体重 2kg–30kg：`RER = 体重(kg) × 30 + 70`
- 体重 <2kg 或 >30kg：`RER = 70 × 体重(kg)^0.75`

步骤 2：计算每日能量需求的百分比
根据动物状况选择 RER 的倍数系数：
- 住院动物通常需要 100% RER（可能需要 2-3 天逐步达到）
- 可根据具体情况给予 25%、50%、75% 或 100% RER

步骤 3：确定食物的能量密度
查看食物标签获取每克/毫升/杯的千卡数

步骤 4：计算每日所需食物量
`每日食物量 = 每日千卡需求 ÷ 每克/毫升食物的千卡数`

步骤 5：计算每餐食物量
`每餐食物量 = 每日总量 ÷ 每日喂食次数`', '', '', '', '营养,能量需求,热量计算,RER,DER,维持能量,计算公式,健康成年猫每日热量需求表,健康成年犬每日热量需求表', 'informational', 'WSAVA 犬猫每日能量需求参考表', 'official', '', 'approved'),
('WSAVA 犬猫体况评分 · 第 1 段', 'WSAVA 犬猫体况评分（BCS）系统

> 参考文献：
> - Laflamme DP. Development and validation of a body condition score system for cats. Feline Pract 1997;25:13-18.
> - Laflamme DP. Development and validation of a body condition score system for dogs. Canine Pract 1997;22:10-15.
> - Bjornvad CR, et al. Evaluation of a nine-point body condition scoring system in physically inactive pet cats. AJVR 2011;72:433-437.
> - Kealy RD, et al. Effects of diet restriction on life span and age-related changes in dogs. JAVMA 2002;220:1315-1320.
> - Teng KT et al. Strong associations of 9-point body condition scoring with survival and lifespan in cats. J Feline Med Surg. 2018;20(12):1110-1118.

1. 概述

体况评分（Body Condition Score, BCS）是评估宠物体脂含量的标准化方法，采用9分制。BCS是WSAVA营养评估指南中每次就诊必须评估的核心指标之一。

**评分体系：**
- 1–3 分：体重不足（Under Ideal）
- 4–5 分：理想体况（Ideal）
- 6–9 分：超重/肥胖（Over Ideal）

**理想体况：** BCS 5/9（部分情况下 6/9 对某些猫也可接受，尤其是老年猫）

**重要性：**
- BCS与宠物的生存期和寿命有强相关性
- 限制饮食（维持理想BCS）可延长犬的寿命并延缓衰老相关变化
- 每次就诊都应评估BCS', '', 'senior', '', '营养,体况评分,BCS,9分制,理想体况,肥胖,概述,猫体况评分标准（9分制）,犬体况评分标准（9分制）', 'informational', 'WSAVA 犬猫体况评分（BCS）系统', 'official', '', 'approved'),
('WSAVA 犬猫体况评分 · 猫体况评分标准（9分制）', '2. 猫体况评分标准（9分制）

| 评分 | 描述 |
|------|------|
| **1/9** | 极瘦。肋骨非常容易看到（短毛猫）。无脂肪垫。腹部严重内收。腰椎和骨盆骨骼容易看到且可触及。 |
| **2/9** | 消瘦。肋骨容易看到（短毛猫）。腰椎明显。腹部明显内收。无脂肪垫。 |
| **3/9** | 偏瘦。肋骨容易触及，脂肪覆盖极少。腰椎明显。肋骨后方腰部明显。腹部脂肪垫极少。 |
| **4/9** | 偏瘦至理想。肋骨可触及，脂肪覆盖极少。腰部明显。腹部轻微内收。腹部脂肪垫极少。 |
| **5/9** | **理想。** 体型匀称。肋骨可触及，有薄层脂肪覆盖。肋骨后方可见腰部，但不明显。腹部脂肪垫最小。 |
| **6/9** | 偏胖。肋骨可触及，脂肪覆盖略多。腰部和腹部脂肪垫存在但不明显。腹部内收消失。*（某些猫可能可接受）* |
| **7/9** | 超重。肋骨不易触及，中等脂肪覆盖。腰部不易看到。腹部轻微圆形隆起。中等腹部脂肪垫。 |
| **8/9** | 肥胖。肋骨因过多脂肪覆盖而无法触及。腰部消失。腹部明显圆形隆起，腹部脂肪垫突出。下背部区域有脂肪沉积。 |
| **9/9** | 严重肥胖。肋骨因厚重脂肪覆盖而无法触及。腰部完全消失。腹部严重膨胀。面部、四肢和下背部区域有大量脂肪沉积。广泛的腹部脂肪沉积。 |

猫BCS评估要点

- **肋骨触诊：** 从1分的"极易看到"到9分的"完全无法触及"
- **腰部观察：** 从上方观察肋骨后方的腰部收窄程度
- **腹部脂肪垫：** 评估腹部悬挂的脂肪量
- **短毛猫特殊注意：** 短毛猫肋骨在较瘦时可能直接可见', 'cat', '', '', '营养,体况评分,BCS,9分制,理想体况,肥胖,概述,猫体况评分标准（9分制）,犬体况评分标准（9分制）', 'informational', 'WSAVA 犬猫体况评分（BCS）系统', 'official', '', 'approved'),
('WSAVA 犬猫体况评分 · 犬体况评分标准（9分制）', '3. 犬体况评分标准（9分制）

| 评分 | 描述 |
|------|------|
| **1/9** | 极瘦。肋骨、腰椎、骨盆骨骼和所有骨性突起从远处即可看到。无可察觉的体脂。明显的肌肉量流失。 |
| **2/9** | 消瘦。肋骨、腰椎和骨盆骨骼容易看到。无可触及的脂肪。其他骨性突起有一些迹象。肌肉量流失极小。 |
| **3/9** | 偏瘦。肋骨容易触及，可能可见，无可触及脂肪。腰椎顶部可见。骨盆骨骼开始突出。腰部和腹部内收明显。 |
| **4/9** | 偏瘦至理想。肋骨容易触及，脂肪覆盖极少。从上方观察腰部容易看到。腹部内收明显。 |
| **5/9** | **理想。** 肋骨可触及，脂肪覆盖适度。从上方观察肋骨后方可见腰部。从侧面观察腹部内收。 |
| **6/9** | 偏胖。肋骨可触及，脂肪覆盖略多。从上方观察腰部可辨别但不突出。腹部内收明显。 |
| **7/9** | 超重。肋骨触及困难；脂肪覆盖厚重。腰椎区域和尾根部有明显的脂肪沉积。腰部缺失或勉强可见。腹部内收可能存在。 |
| **8/9** | 肥胖。肋骨在极厚重脂肪覆盖下无法触及，或需要很大力度才能触及。腰椎区域和尾根部有大量脂肪沉积。腰部消失。无腹部内收。可能存在明显的腹部膨胀。 |
| **9/9** | 严重肥胖。胸部、脊柱和尾根部有大量脂肪沉积。腰部和腹部内收均消失。颈部和四肢有脂肪沉积。明显的腹部膨胀。 |

犬BCS评估要点

- **肋骨触诊：** 最重要的评估指标，理想状态下应可触及但有薄层脂肪覆盖
- **腰部观察（俯视）：** 从上方观察肋骨后方的腰部收窄
- **腹部内收（侧视）：** 从侧面观察腹部的上提
- **骨性突起：** 极瘦的犬可见腰椎、骨盆等骨性突起
- **肌肉量：** 注意区分肌肉流失和脂肪覆盖

4. BCS在营养评估中的应用

4.1 评估时机
- 每次就诊时评估
- 与肌肉状况评分（MCS）同时评估
- 记录在病历中

4.2 异常BCS的处理
- **BCS < 4（偏瘦）：** 需要扩展评估，排查疾病原因，增加热量摄入
- **BCS > 5（偏胖）：** 需要扩展评估，制定减重计划，调整热量摄入
- **BCS = 4-5（理想）：** 维持当前饮食方案

4.3 与MCS的关系
- 动物可能体重超标（BCS > 5）但有显著的肌肉流失
- 动物也可能BCS偏低（< 4）但肌肉流失极少
- 因此**每次就诊都必须同时评估BCS和MCS**
- 对于超重动物，触诊评估肌肉流失尤为重要', 'dog', '', '', '营养,体况评分,BCS,9分制,理想体况,肥胖,概述,猫体况评分标准（9分制）,犬体况评分标准（9分制）', 'informational', 'WSAVA 犬猫体况评分（BCS）系统', 'official', '', 'approved'),
('WSAVA 犬猫肌肉状况评分 · 第 1 段', 'WSAVA 犬猫肌肉状况评分（MCS）

> 版权：© Copyright Tufts University, 2013. Used with permission.

1. 概述

肌肉状况评分（Muscle Condition Score, MCS）是通过视觉观察和触诊评估宠物肌肉量的方法。MCS是WSAVA营养评估指南中每次就诊必须评估的核心指标之一，与体况评分（BCS）互补使用。

**评估部位：** 脊柱、肩胛骨、颅骨和髂骨翼

**评估方法：** 视觉观察 + 触诊

**分级标准：**
- 正常（Normal）
- 轻度肌肉流失（Mild Loss）
- 中度肌肉流失（Moderate Loss）
- 重度肌肉流失（Severe Loss）

2. 评估要点

2.1 肌肉流失的观察顺序

肌肉流失通常在**脊柱两侧的轴旁肌（epaxial muscles）**最先被注意到。其他部位的肌肉流失可能更为多变。

2.2 MCS与BCS的独立关系

**重要概念：MCS和BCS是独立的评估维度。**

- **超重动物也可能有显著的肌肉流失：** BCS > 5 的动物仍可能存在肌肉萎缩
- **偏瘦动物也可能肌肉流失很少：** BCS < 4 的动物可能MCS正常
- 因此，**每次就诊都必须同时评估BCS和MCS**

2.3 触诊的重要性

当肌肉流失为轻度时，触诊尤为重要，特别是对于超重动物——厚重的脂肪覆盖可能掩盖肌肉流失的视觉迹象。

3. 评分标准

3.1 正常肌肉量（Normal）

- 脊柱两侧肌肉饱满
- 肩胛骨区域肌肉充实
- 臀部肌肉圆润
- 触诊肌肉阻力正常

3.2 轻度肌肉流失（Mild Loss）

- 脊柱两侧肌肉轻度凹陷
- 肩胛骨区域轻度松弛
- 触诊可感知肌肉量轻度减少
- 视觉上变化不明显，需要仔细触诊

3.3 中度肌肉流失（Moderate Loss）

- 脊柱两侧明显凹陷
- 肩胛骨轮廓更加明显
- 臀部肌肉明显减少
- 视觉和触诊均可确认肌肉流失

3.4 重度肌肉流失（Severe Loss）

- 脊柱两侧严重凹陷，脊椎骨突出
- 肩胛骨明显突出
- 骨盆骨骼突出
- 全身肌肉量严重不足
- 可能伴随运动能力下降

4. MCS在营养评估中的应用

4.1 记录方式

在病历中记录为：
- 正常
- 轻度肌肉萎缩
- 中度肌肉萎缩
- 重度肌肉萎缩

4.2 异常MCS的处理

- **轻度肌肉流失：** 评估饮食蛋白质摄入、活动水平、潜在疾病
- **中度肌肉流失：** 需要扩展营养评估，可能需要增加蛋白质摄入、进行康复训练
- **重度肌肉流失：** 紧急营养干预，排查严重疾病（肿瘤、内分泌疾病等）', '', '', '', '营养,肌肉状况评分,MCS,肌肉流失,肌肉萎缩,触诊,概述,评估要点,评分标准', 'caution', 'WSAVA 犬猫肌肉状况评分（MCS）', 'official', '', 'approved'),
('WSAVA 犬猫肌肉状况评分 · 监测', '4.3 监测

- 每次就诊时评估并记录
- 与体重、BCS一起跟踪变化趋势
- 住院动物每日评估', '', '', '', '营养,肌肉状况评分,MCS,肌肉流失,肌肉萎缩,触诊,概述,评估要点,评分标准', 'informational', 'WSAVA 犬猫肌肉状况评分（MCS）', 'official', '', 'approved'),
('WSAVA 饮食历史表与营养评估清单 · 第 1 段', 'WSAVA 饮食历史表与营养评估清单

1. 饮食历史表（Diet History Form）

饮食历史表由宠物主人填写，是营养筛查评估的核心工具。

1.1 基本信息

| 项目 | 内容 |
|------|------|
| 宠物名字 | |
| 品种/物种 | |
| 年龄 | |
| 主人姓名 | |
| 填写日期 | |
| 性别 | 公 / 母 |
| 绝育状态 | 是 / 否 |

1.2 活动与生活状况评估

**活动水平：**
- 非常活跃
- 中等活跃
- 不太活跃

**体重评估（主人自评）：**
- 超重
- 理想体重
- 偏瘦

**生活环境：**
- 室内
- 室外
- 室内外兼有

1.3 饮食详细记录

记录所有食物、零食、零食、洁牙产品、生皮以及宠物当前食用的任何其他食物（包括用于给药的食物）。

**记录表格格式：**

| 食物 | 形式 | 数量 | 频率 | 开始时间 |
|------|------|------|------|----------|
| 示例：Purina Dog Chow | 干粮 | 1½ 杯 | 2次/天 | 2010年1月 |
| 示例：Science Diet Adult | 湿粮 | ½ 罐 | 2次/天 | 2010年1月 |
| 示例：90%瘦汉堡 | 煎制 | 3盎司(85克) | 1次/周 | 2011年5月 |
| 示例：Milk Bone中型 | 干零食 | 2个 | 3次/天 | 2012年8月 |

**关键追问：**
- 如果按体积喂食，使用什么尺寸的测量工具？
- 如果喂食罐头食品，罐头尺寸是多少？

1.4 膳食补充剂

- 是否给予膳食补充剂（如维生素、氨基葡萄糖、脂肪酸等）？
- 如果是，列出品牌和用量

1.5 兽医填写部分

| 项目 | 内容 |
|------|------|
| 当前体重 | |
| 理想体重 | |
| 当前体况评分（BCS） | ___/9 或 ___/5 |
| 肌肉状况评分（MCS） | 正常 / 轻度萎缩 / 中度萎缩 / 重度萎缩 |

2. 营养评估清单（Nutritional Assessment Checklist）

营养评估清单由医疗团队完成，指导系统化的营养评估流程。

2.1 前置检查

- [ ] 饮食历史表是否已审阅？如未审阅，请先审阅', 'dog', '', '', '营养,饮食历史,营养评估清单,筛查评估,扩展评估,风险因素', 'informational', 'WSAVA 饮食历史表与营养评估清单', 'official', '', 'approved'),
('WSAVA 饮食历史表与营养评估清单 · 筛查评估记录', '2.2 筛查评估记录

| 项目 | 记录 |
|------|------|
| 当前体重 | |
| 理想体重 | |
| 当前BCS | ___/9 或 ___/5 |
| MCS | 正常 / 轻度萎缩 / 中度萎缩 / 重度萎缩 |

**判断逻辑：**
- 本页无任何勾选项目 → 营养评估完成，无需额外扩展评估
- 本页有任何勾选项目 → 继续下一页的扩展评估

2.3 营养筛查风险因素（可选扩展评估）

以下情况出现时，**可选**进行扩展评估：
- [ ] 极低或极高活动水平
- [ ] 家庭中有多只宠物
- [ ] 妊娠
- [ ] 哺乳
- [ ] 生长期
- [ ] 年龄 > 7岁

2.4 营养筛查风险因素（强制扩展评估）

以下情况出现时，**必须**进行扩展评估：
- [ ] 胃肠道功能异常病史（呕吐、腹泻、恶心、胀气、便秘）
- [ ] 既往或现有疾病
- [ ] 正在接受药物和/或膳食补充剂
- [ ] 非常规饮食（生食、自制、素食、不熟悉的饮食）
- [ ] 零食/零食/餐桌食物 > 总热量的10%
- [ ] 不适当或不充足的住所环境
- [ ] BCS < 4 或 > 5（9分制）
- [ ] MCS：轻度、中度或重度肌肉萎缩
- [ ] 无法解释的体重变化
- [ ] 牙齿异常或疾病
- [ ] 皮肤或被毛状况差
- [ ] 新发疾病

2.5 扩展评估内容

A. 饮食摄入或行为变化

| 项目 | 选项 |
|------|------|
| 食量变化 | 增加 / 减少 |
| 咀嚼 | 正常 / 异常 |
| 吞咽 | 正常 / 异常 |
| 恶心 | 是 / 否 |
| 呕吐 | 是 / 否 |
| 反流 | 是 / 否 |

B. 血清生化指标异常

| 指标 | 低 / 正常 / 高 |
|------|----------------|
| 血糖 | |
| 白蛋白 | |
| 总蛋白 | |
| 电解质 | 低：____ / 高：____ |
| 尿素 | |
| 肌酐 | |
| 总T4 | |

C. 被皮肤状况

- [ ] 毛发易拔除
- [ ] 皮肤薄
- [ ] 皮肤干燥或脱屑

D. 血常规异常

- [ ] 贫血
- [ ] 淋巴细胞减少

E. 其他检查异常

- 粪便浮集/涂片/培养异常
- 尿液分析异常
- 其他诊断检查异常', '', '', '', '营养,饮食历史,营养评估清单,筛查评估,扩展评估,风险因素', 'informational', 'WSAVA 饮食历史表与营养评估清单', 'official', '', 'approved'),
('WSAVA 饮食历史表与营养评估清单 · 建议与监测', '2.6 建议与监测

热量摄入调整

- 是否需要改变热量摄入？ 否 / 是
- 如果"是"：
  - 当前热量摄入：____ kcal 或 kJ/day（来自饮食历史表）
  - 推荐热量摄入：____ kcal 或 kJ/day（来自热量需求计算）

饮食调整

- 是否建议更换饮食？ 否 / 是
- 如果"是"，描述：新推荐饮食 ______

喂养管理调整

- 是否建议改变喂养管理？ 否 / 是
- 如果"是"：
  - 每餐量：____ 杯 / ____ 罐 / ____ 克
  - 每日喂食次数：____
  - 零食：数量和每日次数 ______
  - 需与主人具体讨论餐桌食物、补充剂和给药方式

环境因素调整

- 是否建议改变环境因素（多宠物问题、其他喂食者、丰富化程度、宠物活动量、环境压力源）？
- 否 / 是，描述：______

监测建议

- 是否向客户提供监测建议（体重、BCS、MCS、食物摄入、食欲、胃肠道临床症状、活动量、整体外观）？
- 否 / 是，描述：______

后续跟进

- 客户是否购买了推荐的食物？ 否 / 是
- 是否提供了教育信息或工具？ 否 / 是', '', '', '', '营养,饮食历史,营养评估清单,筛查评估,扩展评估,风险因素', 'informational', 'WSAVA 饮食历史表与营养评估清单', 'official', '', 'approved'),
('WSAVA 住院犬猫喂养指南 · 第 1 段', 'WSAVA 住院犬猫喂养指南

1. 何时对住院患者进行营养干预

1.1 干预时机判断

根据厌食/食欲减退的天数（包括在家中的厌食/食欲减退天数）：

| 厌食/食欲减退天数 | 干预措施 |
|-------------------|----------|
| **1–2 天** | 写下喂养医嘱，每日监测食物摄入和临床状况 |
| **3–4 天** | 如果恢复不迫在眉睫，可能需要营养支持。如果患者将被麻醉，考虑放置饲管 |
| **5 天** | **必须**进行营养支持！放置饲管或启动肠外营养 |

> **重要提示：** 如果患者已经存在营养不良，应在血流动力学稳定后**尽快**开始营养支持，不必等待上述天数。

2. 住院动物喂养计划制定

2.1 制定喂养计划

为每只住院动物制定具体的喂养计划，包括四个要素：
1. **饮食（Diet）** — 选择什么食物
2. **途径（Route）** — 如何喂食
3. **数量（Amount）** — 喂多少
4. **频率（Frequency）** — 多久喂一次

**目标：** 达到静息能量需求（RER），但可能需要 2–3 天逐步达到目标量。

2.2 喂养途径决策流程

```
患者厌食或无法进食
├── 上消化道功能正常 → 肠内营养
│   ├── 患者未营养不良且厌食可能 <5天
│   │   └── 食道饲管 / 鼻胃管
│   └── 患者未营养不良且厌食可能 >5天
│       ├── 需要剖腹手术 → 手术胃造口管
│       └── 不需要剖腹手术 → PEG管 或 食道造口管
├── 上消化道功能异常
│   └── 空肠造口管
└── 整个消化道功能异常
    └── 每日重新评估肠外营养需求（厌食3-5天后）
        └── 肠外营养
```

2.3 自愿进食与辅助喂养

**第一步：** 如果动物能够进食，尝试自愿口服进食或诱导进食（coax feeding）

**第二步：** 写下具体的喂养医嘱，格式为：
> "喂 [具体饮食] [具体量] 口服 每[间隔时间]"
>
> 示例："Feed 1/4 can Diet X orally q 6 hrs."

**第三步：** 监测摄入量。如果口服摄入量不足，需要辅助喂养技术

3. 喂养指导表（Feeding Instructions）

3.1 患者信息

| 项目 | 内容 |
|------|------|
| 患者姓名 | |
| 患者编号 | |
| 客户姓名 | |
| 物种 | |
| 品种 | |
| 性别/年龄 | |
| 兽医/护士 | |
| 日期 | |', '', '', '', '营养,住院喂养,营养支持,饲管,肠内营养,肠外营养,何时对住院患者进行营养干预,住院动物喂养计划制定', 'informational', 'WSAVA 住院犬猫喂养指南', 'official', '', 'approved'),
('WSAVA 住院犬猫喂养指南 · 当日评估', '3.2 当日评估

| 项目 | 记录 |
|------|------|
| 今日体重 | |
| 今日BCS（9分制） | |
| 肌肉萎缩程度 | 无 / 轻度 / 中度 / 重度 |

3.3 喂养方案

| 项目 | 选项 |
|------|------|
| 喂养途径 | 自愿（经口） / 辅助喂养（经饲管）* |
| 饮食类型 | 干粮 / 湿粮 / 流质 / 其他（请注明） |
| RER百分比 | 100% / 75% / 50% / 25% / 其他 |
| 每日喂食次数 | |
| 特殊注意事项 | |

> *经肠内营养输送时，尽量避免单次喂食量超过 10ml/kg

3.4 家庭喂养偏好

了解并记录：
- 在家吃什么类型的饮食？
- 吃多少？
- 什么时间喂食？
- 是否给零食？
- 碗的类型和品牌/口味偏好

4. 每日能量需求和食物摄入量计算

步骤 1：计算 RER

- 体重 2kg–30kg：`RER = 体重(kg) × 30 + 70`
- 体重 <2kg 或 >30kg：`RER = 70 × 体重(kg)^0.75`

步骤 2：计算每日所需热量

`每日热量 = RER × 百分比系数`

步骤 3：确定食物的能量密度

查看食物标签获取每克/毫升的千卡数

步骤 4：计算每日所需食物量

`每日食物量(g/ml) = 每日热量需求(kcal) ÷ 每克/毫升食物的热量(kcal/g或kcal/ml)`

步骤 5：计算每餐食物量

`每餐食物量 = 每日总量 ÷ 每日喂食次数`

5. 营养监测表（Nutrition Monitoring Chart）

住院期间每日记录营养摄入情况：

| 日期 | 时间 | 提供的饮食或管饲食物 | 提供量(ml或g) | 喂养方式（手喂/管饲） | 实际摄入量(ml或g) | 是否达到热量需求？ YES( )/NO(×) | 备注 |
|------|------|---------------------|---------------|----------------------|-------------------|-------------------------------|------|
| | | | | | | | |

5.1 监测要点

- 每日记录食物提供量和实际摄入量
- 计算每次喂食是否达到热量需求
- 如果摄入不足，调整喂养方案
- 记录任何异常情况（呕吐、腹泻等）', '', '', '', '营养,住院喂养,营养支持,饲管,肠内营养,肠外营养,何时对住院患者进行营养干预,住院动物喂养计划制定', 'informational', 'WSAVA 住院犬猫喂养指南', 'official', '', 'approved'),
('WSAVA 宠物食品选择指南 · 第 1 段', 'WSAVA 宠物食品选择指南

1. 概述

宠物食品标签包含大量必需和有用的信息，但也包含旨在促进产品销售而非传递营养信息的营销图片和短语。一些不受监管的术语（如"天然"、"高端"等）对营养评估几乎没有实际价值。

**兽医团队在帮助宠物主人做出明智的饮食决策方面发挥着关键作用。**

2. 评估宠物食品品牌——四个关键问题

2.1 品牌是否雇佣了营养师？

**合格的资质：**
- 动物营养学博士学位（PhD in Animal Nutrition）
- 或获得美国兽医营养学院（ACVN）认证
- 或获得欧洲兽医比较营养学院（ECVCN）认证

**需要确认的信息：**
- 营养师的姓名、资质和雇佣状态
- 顾问营养师的影响力可能不如全职营养师

2.2 谁负责配方设计？

- 配方是否由有经验的宠物食品配方师（动物营养学硕士或博士）开发？
- 还是由兽医、宠物主人/繁殖者/训练师开发？
- 配方设计是一个复杂的过程，需要了解营养学、原材料和加工知识——这些在兽医学校课程中并不教授
- 受过训练和有经验的配方师可能具有食品科学与技术学位，以指导成分选择和营养水平
- ACVN或ECVCN认证的专家也可能接受过宠物食品配方的交叉培训，或与有经验的配方师合作

2.3 原料和成品的质量控制流程是什么？

**营养标准：**
- 饮食应标注符合AAFCO（美国饲料管理官员协会）或FEDIAF（欧洲宠物食品工业联合会）指南
- 是否通过分析数据库或成品化学分析来满足营养标准？

**质量控制应包含：**
- 原料（食品和补充剂）验证
- 最终饮食营养分析
- 毒理学检测
- 细菌学检测
- 包装/保质期筛查
- 覆盖生产前、生产中和生产后

2.4 是否进行了产品研究或营养学研究？是否在同行评审期刊上发表？

- 宠物食品公司不需要进行或赞助营养研究即可生产和销售食品
- 但如果他们进行了研究，表明对动物健康和福利的承诺

> **如果制造商无法或不愿提供上述任何信息，兽医和主人应谨慎喂食该品牌。**

3. 评估宠物食品标签——四个关键问题

3.1 是否有营养充分性声明？

**完整性饮食：**
- 食品应标注是否提供"完全"饮食，包含所有必需营养素
- 标签可能指定这是通过生命阶段喂养试验还是通过配方满足需求来确定的

**非完整性饮食：**
- 标注为"短期"、"间歇性"或"补充性"喂养的食品只能作为饮食的一小部分（10%或更少）
- 或在兽医监督下作为治疗性饮食使用

**生命阶段匹配：**
- AAFCO和FEDIAF为不同生命阶段（繁殖、生长、成年）提供推荐营养水平
- 标注"适用于所有生命阶段"的饮食是为繁殖和生长配制的', '', '', '', '营养,宠物食品选择,品牌评估,营养师,配方设计,质量控制,概述,评估宠物食品品牌——四个关键问题,评估宠物食品标签——四个关键问题', 'informational', 'WSAVA 宠物食品选择指南', 'official', '', 'approved'),
('WSAVA 宠物食品选择指南 · 每克或每份食物含有多少热量？', '3.2 每克或每份食物含有多少热量？

- 宠物肥胖患病率在世界许多地区不断上升
- 获取准确的宠物食品热量信息有助于防止意外过度喂食
- 热量信息仅在美国的宠物食品标签上是强制性的
- 在标签未提供时，应通过联系制造商或从标签营养分析计算获取

3.3 公司是否提供即时联系信息（电话号码或电子邮件）？

- 公司代表应易于联系以回答额外问题
- 如标签上未列出的特定营养素含量
- 宠物食品公司应能提供其食品中所有必需营养素的"平均"或"典型"分析

3.4 谁生产这种食品？

- 公司可能自己生产（"Made by"）
- 或使用第三方制造商（"Made for" 或 "Distributed by"）

4. 品牌评估总结表

| 评估维度 | 关键问题 | 理想答案 |
|----------|---------|---------|
| 营养师 | 是否雇佣合格营养师？ | 全职ACVN/ECVCN认证或PhD |
| 配方 | 谁开发配方？ | 有经验的配方师（MS/PhD）或ACVN认证 |
| 质量控制 | 原料和成品的QC流程？ | 全面的分析、检测、筛查流程 |
| 研究 | 是否进行并发表研究？ | 在同行评审期刊发表 |
| 营养充分性 | 标签是否有AAFCO/FEDIAF声明？ | 完整的生命阶段饮食 |
| 热量信息 | 是否标注每克/每份热量？ | 明确标注 |
| 联系方式 | 是否提供联系信息？ | 电话或电子邮件 |
| 制造商 | 谁生产？ | 自有工厂或知名第三方 |', '', '', '', '营养,宠物食品选择,品牌评估,营养师,配方设计,质量控制,概述,评估宠物食品品牌——四个关键问题,评估宠物食品标签——四个关键问题', 'informational', 'WSAVA 宠物食品选择指南', 'official', '', 'approved'),
('WSAVA 宠物生肉基饮食 · 第 1 段', 'WSAVA 宠物生肉基饮食（RMBD）指南

1. 什么是生肉基饮食？

生肉基饮食（Raw Meat-Based Diets, RMBD）是指：
- 基于未煮熟的肉、骨头和内脏（器官肉）的食物
- 通常脂肪含量较高，碳水化合物含量较低
- 可能具有高消化率
- 但生食（类似熟食）品质参差不齐——成分、能量含量和营养特征差异很大

2. 生肉基饮食是否比干粮或罐头更健康？

**WSAVA的立场：没有证据表明生肉基饮食比商业平衡饮食或自制熟食饮食更健康。**

具体事实：
- 高脂肪、低纤维饮食（生的和熟的）可能被许多宠物良好耐受，但其他宠物会出现胃肠道问题，如腹泻，甚至胰腺炎
- 越来越多的证据表明，喂食生肉对宠物和主人都是健康风险

3. 风险分析

3.1 细菌污染风险（高）

**致病菌种类：**
- 大肠杆菌（E. coli）
- 沙门氏菌（Salmonella spp.）
- 耶尔森氏菌（Yersinia）
- 弯曲杆菌（Campylobacter spp.）
- 单核细胞增生李斯特菌（Listeria monocytogenes）
- 牛分枝杆菌（Mycobacterium bovis）

**感染风险：**
- 食源性感染可能对宠物和人严重甚至致命
- 宠物护理者和家庭其他成员可通过处理食物或宠物粪便而感染
- 免疫系统受损的个体风险更高（幼儿、孕妇、老年人、患病或服用特定药物的人）
- 即使他们没有主动喂食宠物，也可能被感染

**抗生素耐药性：**
- 在生肉基产品中发现的一些细菌可能具有抗生素耐药性
- 研究发现生食喂养与犬粪便中抗菌药物耐药细菌的存在之间存在关联

**诊所风险：**
- 喂食生食的宠物也可能成为其他就诊宠物的风险因素
- 它们可能携带和排出致病细菌

**常见误解：**
- 冷冻、脱水或冻干**不能**杀死食物中的所有细菌

3.2 骨骼风险

- 骨头被提供给宠物作为消遣和感知到的牙齿益处
- 但可能导致：
  - 牙齿断裂
  - 肠道或食道梗阻
  - 便秘
- 喂食骨头**不能**降低牙菌斑或因牙周炎导致牙齿脱落的风险

3.3 营养不均衡风险

- 自制熟食和生肉基饮食可能存在重要的营养缺陷和过量
- 不均衡的饮食对幼犬和幼猫尤其有害
- 可能导致疼痛的骨骼疾病和病理性骨折

3.4 寄生虫风险

- 生肉基饮食中可能存在寄生虫
- 某些寄生虫（如弓形虫 Toxoplasma）可感染人类
- 孕妇面临特别大的风险，因为弓形虫病可影响胎儿
- 犬还可能将食物来源的寄生虫传播给农场动物

4. 兽医实践中的注意事项

**重要提示：** 从业者必须知道其患者是否在喂食生肉基饮食，因为营养不均衡或受污染的食物可能导致健康问题或加重疾病临床症状。', '', '', '', '营养,生肉饮食,RMBD,细菌污染,沙门氏菌,大肠杆菌,什么是生肉基饮食？,生肉基饮食是否比干粮或罐头更健康？,风险分析', 'caution', 'WSAVA 宠物生肉基饮食（RMBD）指南', 'official', '', 'approved'),
('WSAVA 宠物生肉基饮食 · 需要关注的临床信号', '4.1 需要关注的临床信号

- 胃肠道症状（呕吐、腹泻）
- 营养缺乏症状
- 感染症状
- 骨骼异常（幼犬/幼猫）

4.2 高风险人群

以下人群在接触生肉基饮食环境时风险更高：
- 幼儿
- 孕妇
- 老年人
- 免疫系统受损的个体
- 服用特定药物的个体', '', '', '', '营养,生肉饮食,RMBD,细菌污染,沙门氏菌,大肠杆菌,什么是生肉基饮食？,生肉基饮食是否比干粮或罐头更健康？,风险分析', 'informational', 'WSAVA 宠物生肉基饮食（RMBD）指南', 'official', '', 'approved');

INSERT INTO knowledge_docs (title, content, species, life_stage, breed_tags, topics, severity, source_name, source_type, source_url, review_status) VALUES
('WSAVA 犬猫零食喂养指南 · 第 1 段', 'WSAVA 犬猫零食喂养指南

1. 什么是零食？

零食（Treats）是指在完整均衡饮食之外给予宠物的任何食物。包括：
- 零食（snacks）
- 咀嚼物（chews）
- 补充剂（supplements）
- 用于给药的食物

可以是商业产品或使用人类食品自制。

2. 零食的作用与风险

2.1 零食的积极作用

- 用作训练辅助工具或良好行为的奖励
- 提供丰富化和精神刺激
- 加强与宠物的纽带关系

2.2 零食的潜在危害

过多的零食可能有害，如果它们：
- **打破了主食的营养平衡**
- **导致非预期的体重增加**

3. 健康零食习惯

3.1 核心原则

**零食热量不应超过宠物每日总热量摄入的10%。**

具体建议：
- 维持最佳体重对支持宠物健康和生活质量至关重要
- 商业零食如标签未标注热量信息，应联系制造商获取
- 零食**不应替代正餐**——每只宠物都需要完整均衡的饮食
- 确保提供的零食大小和形状适当，以降低窒息风险
- 与宠物的兽医医疗团队沟通，确定合适的零食数量和类型
- 在宠物使用咀嚼物、零食和玩具时进行监督
- 考虑其他方式与宠物共度有趣的高质量时光

3.2 猫零食热量上限表

基于健康成年猫在理想体况下的每日热量需求。

| 猫体重 (kg) | 每日零食热量上限 (kcal) |
|-------------|------------------------|
| 2.5 | 18 |
| 3.0 | 20 |
| 3.5 | 21 |
| 4.0 | 22 |
| 4.5 | 24 |
| 5.0 | 25 |
| 5.5 | 26 |
| 6.0 | 26 |
| 7.0 | 28 |

3.3 犬零食热量上限表

基于健康成年犬在理想体况下的每日热量需求。

| 犬体重 (kg) | 每日零食热量上限 (kcal) |
|-------------|------------------------|
| 2 | 14 |
| 4 | 24 |
| 6 | 32 |
| 8 | 32 |
| 10 | 32 |
| 15 | 32 |
| 20 | 32 |
| 25 | 32 |
| 30 | 32 |
| 35 | 32 |
| 40 | 32 |
| 45 | 32 |

4. 不安全零食

4.1 通用风险

- 错误的零食即使受欢迎，也可能导致**肥胖、创伤、梗阻甚至死亡**
- 如果宠物有疾病、饮食敏感或正在食用兽医处方饮食，常规零食可能不适合
- 骨头（生的和熟的）可能非常危险，咀嚼和/或吞咽后可能造成严重损害
- 未加工的生动物基零食有病原体传播风险', '', '', '', '营养,零食,零食指南,10%原则,零食热量,有毒食物,什么是零食？,零食的作用与风险,健康零食习惯', 'caution', 'WSAVA 犬猫零食喂养指南', 'official', '', 'approved'),
('WSAVA 犬猫零食喂养指南 · 猫的不安全零食', '4.2 猫的不安全零食

- **骨头（生的和熟的）** — 可能导致食道异物
- **未加工的生动物基零食** — 沙门氏菌等病原体风险
- **人类食物和餐桌残余** — 可能不健康且潜在危险

**猫有毒食物成分：**
- 洋葱、韭葱、青葱、大蒜、细香葱
- 葡萄、葡萄干、醋栗和苏丹葡萄
- 巧克力
- 木糖醇（甜味剂）
- 酒精和生酵母面团
- 含咖啡因的饮料（咖啡、茶、能量饮料）
- 牛奶和乳制品*（许多猫有乳糖不耐受）

4.3 犬的不安全零食

- **骨头（生的和熟的）** — 可能导致牙齿断裂、食道梗阻
- **过度坚硬的咀嚼物和零食** — 如鹿角和蹄，以及有锋利边缘的
- **未加工的生动物基零食** — 如受污染的猪耳，有病原体传播风险
- **人类食物和餐桌残余** — 可能不健康且潜在危险

**犬有毒食物成分：**
- 巧克力
- 澳洲坚果
- 洋葱、韭葱、青葱、大蒜、细香葱
- 葡萄、葡萄干、醋栗和苏丹葡萄
- 木糖醇（甜味剂）
- 酒精和生酵母面团
- 含咖啡因的饮料（咖啡、茶、能量饮料）

5. 常见人类食物的热量密度

5.1 猫常喂食物热量

| 食物 | 份量 | 热量 (kcal) |
|------|------|-------------|
| 2%脂肪茅屋奶酪 | 1oz / 28g | 25 |
| 半脱脂牛奶 | 2 fl oz / 59ml | 27 |
| 熟虾 | 1oz / 28g | 29 |
| 水浸金枪鱼罐头 | 1oz / 28g | 36 |
| 熟三文鱼（鱼排） | 1oz / 28g | 39 |
| 火腿 | 1oz / 28g | 46 |
| 熟鸡胸肉（去皮） | 1oz / 28g | 47 |
| 熟火鸡胸肉（去皮） | 1oz / 28g | 50 |
| 瘦熟牛肉 | 1oz / 28g | 64 |
| 切达奶酪 | 1oz / 28g | 120 |

> 对于许多猫来说，仅食用上述一种食物的指定量就可能超过其每日推荐的零食热量上限。', '', '', '', '营养,零食,零食指南,10%原则,零食热量,有毒食物,什么是零食？,零食的作用与风险,健康零食习惯', 'caution', 'WSAVA 犬猫零食喂养指南', 'official', '', 'approved'),
('WSAVA 犬猫零食喂养指南 · 犬常喂食物/咀嚼物热量', '5.2 犬常喂食物/咀嚼物热量

| 食物 | 份量 | 热量 (kcal) |
|------|------|-------------|
| 火腿 | 1oz / 28g | 46 |
| 熟鸡胸肉（去皮） | 1oz / 28g | 47 |
| 熟火鸡胸肉（去皮） | 1oz / 28g | 50 |
| 瘦熟牛肉 | 1oz / 28g | 64 |
| 消化饼干 | 0.6oz / 17g（1块） | 75 |
| 花生酱 | 1汤匙 | 81 |
| 切达奶酪 | 1oz / 28g | 120 |
| 牛肚棒 | 1oz / 28g | 217 |
| 干猪耳 | 2oz / 56g | 242 |
| 生皮骨 | 6.7oz / 190g | 700 |

> 对于某些犬来说，仅食用上述一种食物的指定量就可能超过其每日推荐的零食热量上限。', 'dog', '', '', '营养,零食,零食指南,10%原则,零食热量,有毒食物,什么是零食？,零食的作用与风险,健康零食习惯', 'informational', 'WSAVA 犬猫零食喂养指南', 'official', '', 'approved'),
('WSAVA 互联网营养信息评估指南 · 第 1 段', 'WSAVA 互联网营养信息评估指南

1. 概述

互联网为宠物主人提供了大量信息，但这些信息几乎不受监管，质量从优秀到纯粹的骗术不等。宠物营养是一个热门话题，有数千个网站推广各种内容：

- 生食和素食食谱
- 补充剂和"天然"食品广告
- 声称可预防或治愈疾病的饮食推荐
- "快速致富"的营养补充剂传销计划
- 由"营养师"运营的咨询服务

**现实情况：** 许多营养谬误被传播，许多半真半假被强化，许多不正确的事实被传达。当然也有一些优秀信息——但远没有那么丰富。

2. 评估网站可靠性的八大准则

2.1 与兽医讨论

在网上读到的信息应该**补充**而非**替代**兽医的建议。如有疑问，请兽医帮助评估。

2.2 调查作者资质

- 作者是宠物主人、公司、兽医、动物营养学博士还是认证的兽医营养师？
- 警惕自称"宠物营养师"或"认证营养师"的人——培训没有标准化
- **唯一例外：** 获得ACVN（美国兽医营养学院）或ECVCN（欧洲兽医比较营养学院）认证的兽医营养师
  - 这些兽医经过数年的严格研究生营养培训
  - 在批准的住院医师项目中完成训练
  - 通过了ACVN或ECVCN的认证考试

2.3 查看网站地址

| 域名后缀 | 含义 |
|----------|------|
| .com | 商业网站 |
| .edu | 教育机构 |
| .org | 非营利组织 |

大型宠物食品公司通常有高质量的网站，提供与产品信息分开的优质通用营养信息。

2.4 检查信息来源

- 作者是否只是简单地声称产品"预防癌症"？
- 还是引用了科学研究？
- 如果有引用，引用来源是什么？
  - 作者自己的文章或宣传材料？
  - 同行评审的兽医期刊？
- 大多数网上产品不引用研究来支持其声明
- 引用的研究经常是在人类、大鼠或狗身上进行的，可能与猫/狗无关

2.5 检查信息时效性

- 兽医医学（尤其是营养学领域）变化迅速
- 许多网站已过时
- 两年前推荐的可能不是今天的公认做法
- 好的网站会频繁更新

2.6 警惕轶事信息

- 一个人经验的描述可能具有误导性
  - 示例："当我的宠物被诊断出肾病时，我给了它''GETBETTER''营养补充剂，现在它痊愈了"
- 积极的评估并不意味着实际的产品或治疗真的有益
- 始终与兽医讨论所听到的信息

2.7 小心评分网站

- 大多数对宠物食品进行排名的网站基于意见或不必然确保食品质量的标准（如价格、成分、公司规模）
- 使用更客观的标准（科学、质量控制）来判断宠物食品

2.8 对宏大声明持怀疑态度

- 记住老话：**如果听起来好得不像真的，那可能就不是真的**
- 对困难问题的简单答案保持警惕

3. 推荐的可信营养信息来源', '', '', '', '营养,互联网营养,网站评估,资质认证,ACVN,ECVCN,概述,评估网站可靠性的八大准则,推荐的可信营养信息来源', 'informational', 'WSAVA 互联网营养信息评估指南', 'official', '', 'approved'),
('WSAVA 互联网营养信息评估指南 · 营养指南', '3.1 营养指南

| 来源 | 内容 |
|------|------|
| WSAVA营养评估指南 | 犬猫营养评估框架 |
| AAHA营养评估指南 | 美国动物医院协会营养评估标准 |

3.2 兽医医疗团队工具

| 来源 | 内容 |
|------|------|
| WSAVA全球营养委员会营养工具包 | 兽医实践工具 |
| Pet Nutrition Alliance | 提高对最佳宠物营养重要性的认识 |

3.3 宠物营养通用信息

| 来源 | 内容 |
|------|------|
| 美国国家研究委员会（NRC） | 犬/猫营养需求手册（可下载） |

3.4 宠物食品信息

| 来源 | 内容 |
|------|------|
| AAFCO | 宠物食品法规、标签和信息 |
| FDA宠物食品网站 | 食品安全、召回、标签、报告 |
| 宠物食品研究所 | 成分定义、标签法规 |
| Pet Food Report | 消费者宠物食品指南 |

3.5 营养咨询

| 来源 | 内容 |
|------|------|
| ACVN | 认证兽医营养师名单（可提供营养咨询） |
| ECVCN | 欧洲认证兽医营养师名单 |

3.6 自制饮食

| 来源 | 内容 |
|------|------|
| ACVN | 认证营养师可配制营养均衡的自制饮食食谱 |
| BalanceIT | 提供半定制化平衡自制饮食食谱的商业网站 |
| ECVCN | 欧洲认证营养师 |

3.7 肥胖管理

| 来源 | 内容 |
|------|------|
| Pet Obesity Prevention | 体重评估、热量需求和减重工具 |

3.8 膳食补充剂

| 来源 | 内容 |
|------|------|
| Consumerlab | 独立评估膳食补充剂（需订阅费） |
| FDA | 补充剂监管和安全问题 |
| NIH膳食补充剂办公室 | 评估、事实表、安全通知 |
| USDA食品营养信息中心 | 通用补充剂和营养信息 |
| USP膳食补充剂验证项目 | 独立检测（仅限人类补充剂） |

3.9 生肉饮食

| 来源 | 内容 |
|------|------|
| Tufts大学兽医学院 | 生食饮食事实表 |
| FDA | 安全处理和生食指南文件 |

3.10 其他

| 来源 | 内容 |
|------|------|
| Ohio State室内宠物计划 | 优化室内宠物环境的营养和其他建议 |
| USDA营养素数据库 | 数千种人类食品的完整营养概况 |', '', '', '', '营养,互联网营养,网站评估,资质认证,ACVN,ECVCN,概述,评估网站可靠性的八大准则,推荐的可信营养信息来源', 'informational', 'WSAVA 互联网营养信息评估指南', 'official', '', 'approved');
