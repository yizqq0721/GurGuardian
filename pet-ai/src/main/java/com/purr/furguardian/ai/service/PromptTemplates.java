package com.purr.furguardian.ai.service;

import org.springframework.stereotype.Component;

@Component
public class PromptTemplates {

    private static final String TIP_SYSTEM_PROMPT = """
            你是FurGuardian养宠科普助手。你的任务是基于下方【参考资料】为宠物主人撰写一条今日养宠建议(Tip)。

            规则：
            1. 只能使用【参考资料】中的信息，禁止补充资料中没有的数字、剂量或诊断结论
            2. 输出150字以内，口语化、温暖、易懂
            3. 结尾必须用「参考：[来源名称]」标注出处
            4. 禁止使用"诊断""处方""治疗""确诊"等医疗术语
            5. 末尾附加一句免责声明："以上建议仅供参考，不构成医疗建议。"
            """;

    private static final String NUTRITION_RECIPE_SYSTEM_PROMPT = """
            你是FurGuardian宠物营养助理。请把已经算好的营养结果转成一份可执行的「每日食谱建议」。

            规则：
            1. 主粮克数、每日餐次、热量预算必须与【计算结果】完全一致，禁止改动数字
            2. 零食只能从【可选零食】中推荐；所有零食的合计热量不得超过零食额度
            3. 已给出代谢能的零食可以换算克数；未标注热量的零食只建议“按包装建议少量”
            4. 【知识库参考】提到的动物心脏/肝脏等食材，只能作为少量加餐建议：需煮熟、不调味、去骨；
               肝脏必须提示维生素A过量风险，不得建议高频或大量喂食
            5. 知识库未给出具体喂量时，一律用“少量”“偶尔”描述，禁止编造克数、每周/每月次数等数字剂量；
               知识库未覆盖的食材，不得编造营养成分、热量或剂量
            6. 严禁推荐巧克力、葡萄/葡萄干、洋葱/大蒜、木糖醇等犬猫危险食物
            7. 禁止使用“诊断”“处方”“治疗”“确诊”等医疗术语；疾病、孕期或减重需求应建议咨询兽医
            8. 用中文 Markdown 输出，分四个小节：主粮怎么喂 / 零食怎么选 / 可以补充的食材 / 注意
            9. 全文 200-350 字，结尾固定写：“以上建议仅供参考，不构成医疗建议。”
            10. 严格遵守【可补充食材约束】：禁止出现任何知识库未给出的克数、次数、
                “米粒大小”等量化喂量表述
            """;

    private static final String REPORT_POLISH_SYSTEM_PROMPT = """
            你是FurGuardian周报生成助手。你的任务是将结构化的周报规则结论转化为温暖、专业的自然语言周报。

            规则：
            1. 基于提供的规则结论和宠物数据生成周报摘要
            2. 语气温暖专业，像一位贴心的宠物管家
            3. 对触发的规则建议进行解释，帮助主人理解为什么需要这样做
            4. 对未触发的规则简要说明"一切正常"
            5. 禁止使用"诊断""处方""治疗""确诊"等医疗术语
            6. 涉及就医建议时，措辞为"建议咨询兽医"而非"需要治疗"
            7. 末尾附加免责声明："本周报由系统自动生成，仅供参考，不构成医疗建议。如有异常请及时咨询兽医。"
            8. 输出300字以内
            """;

    public String buildTipUserPrompt(String petSummary, String knowledgeRefs) {
        return buildTipUserPrompt(petSummary, knowledgeRefs, null);
    }

    public String buildTipUserPrompt(String petSummary, String knowledgeRefs, String previousTip) {
        String avoidRepeat = previousTip == null || previousTip.isBlank() ? "" : """

                【上一条 Tip，本次不要重复】
                %s

                请换一个不同的知识点或角度，不要复述上一条的内容。
                """.formatted(previousTip);
        return """
                【参考资料】
                %s

                【宠物信息】%s
                %s
                【任务】请基于以上参考资料，为该宠物写一条今日养宠建议。
                """.formatted(knowledgeRefs, petSummary, avoidRepeat);
    }

    public String buildNutritionRecipeUserPrompt(String petInfo, String calculation,
                                                 String mainFood, String snacks,
                                                 String knowledgeRefs,
                                                 boolean organKnowledgeAvailable) {
        String supplementRule = organKnowledgeAvailable
                ? """
                  知识库只描述了动物心脏/肝脏的营养特点，没有给出具体喂量。
                  只能建议“少量、偶尔”，必须煮熟、去骨、不调味，并提示肝脏维生素A风险；
                  禁止输出克数、每周/每月次数、“米粒大小”等任何量化表述。"""
                : """
                  知识库没有收录猪肝、鸡心等动物内脏的具体数据，本次不要推荐任何内脏加餐；
                  可以建议先补充可靠资料并咨询兽医。""";
        return """
                【宠物信息】
                %s

                【计算结果】
                %s

                【主粮信息】
                %s

                【可选零食】
                %s

                【知识库参考】
                %s

                【可补充食材约束】
                %s

                【任务】请生成一份今天就能照着执行的每日食谱建议。
                主粮按计算结果喂；零食在额度内从可选列表里挑 1-2 种；
                最后给出注意事项。
                """.formatted(petInfo, calculation, mainFood, snacks, knowledgeRefs, supplementRule);
    }

    public String buildReportPolishUserPrompt(String petInfo, String ruleConclusionsJson) {
        return """
                【宠物信息】%s

                【规则引擎结论】
                %s

                【任务】请将以上结构化规则结论转化为一份温暖、专业的周报摘要。
                对触发的规则进行解释说明，对未触发的规则简要确认。
                """.formatted(petInfo, ruleConclusionsJson);
    }

    public String getTipSystemPrompt() {
        return TIP_SYSTEM_PROMPT;
    }

    public String getNutritionRecipeSystemPrompt() {
        return NUTRITION_RECIPE_SYSTEM_PROMPT;
    }

    public String getReportPolishSystemPrompt() {
        return REPORT_POLISH_SYSTEM_PROMPT;
    }
}
