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
        return """
                【参考资料】
                %s

                【宠物信息】%s

                【任务】请基于以上参考资料，为该宠物写一条今日养宠建议。
                """.formatted(knowledgeRefs, petSummary);
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

    public String getReportPolishSystemPrompt() {
        return REPORT_POLISH_SYSTEM_PROMPT;
    }
}
