package com.purr.furguardian.ai.agent;

import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import org.springframework.stereotype.Component;

/**
 * 行动计划 Agent 的工具面：只能查知识库和生成待确认计划。
 * 它没有体重/喂食/提醒的查询工具，因此必须使用照护分析 Agent 交来的结论。
 */
@Component
public class PlanToolSet {

    private final PetAgentTools tools;

    public PlanToolSet(PetAgentTools tools) {
        this.tools = tools;
    }

    @Tool("检索宠物营养与健康知识库（WSAVA 等权威来源），用于带依据的行动建议。")
    public String searchKnowledge(@P("检索关键词，例如：驱虫频率、体重下降、幼犬喂养") String query) {
        return tools.searchKnowledge(query);
    }

    @Tool("为当前宠物新建或修改一条提醒的待确认计划（不会直接创建）。用户要求或建议需要跟进时使用，只提案，由用户确认后才会保存。")
    public String proposeReminder(
            @P("提醒标题，例如：每日补记喂食") String title,
            @P("提醒类型：FEED 喂食 / WALK 遛弯 / WATER 喂水 / GROOMING 梳毛 / DEWORM 驱虫 / VACCINE 疫苗 / BATH 洗澡 / CUSTOM 自定义") String reminderType,
            @P("计划日期 yyyy-MM-dd；周期提醒可留空") String date,
            @P("提醒时间 HH:mm，例如 09:00") String time,
            @P("重复规则：ONCE 仅一次 / DAILY 每天 / WEEKLY 每周 / MONTHLY 每月 / YEARLY 每年") String repeatRule,
            @P("WEEKLY 时指定星期，逗号分隔且 1=周一 … 7=周日，例如 1,3,5；其它情况留空") String repeatDays) {
        return tools.proposeReminder(title, reminderType, date, time, repeatRule, repeatDays);
    }
}
