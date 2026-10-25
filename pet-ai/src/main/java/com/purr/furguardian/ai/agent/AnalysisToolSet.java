package com.purr.furguardian.ai.agent;

import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import org.springframework.stereotype.Component;

/**
 * 照护分析 Agent 的工具面：只能读档案、体重、喂食、提醒。
 * 与计划 Agent 的工具集不重叠，角色分工由可调用范围保证，而不只是提示词。
 */
@Component
public class AnalysisToolSet {

    private final PetAgentTools tools;

    public AnalysisToolSet(PetAgentTools tools) {
        this.tools = tools;
    }

    @Tool("读取当前宠物的档案：品种、性别、年龄、绝育情况、体况评分BCS、活动量。")
    public String petProfile() {
        return tools.petProfile();
    }

    @Tool("查询当前宠物最近若干天的体重记录：起止体重、变化量、BCS 变化和逐条记录。问体重、胖瘦、长肉或掉秤时使用。")
    public String weightTrend(@P("回溯天数，7 表示最近 7 天") int days) {
        return tools.weightTrend(days);
    }

    @Tool("查询当前宠物最近若干天的喂食打卡汇总：有记录的天数、餐数、有记录日均克数与热量、未打卡日期、最近一餐。未打卡只表示没有记录，不等于没有喂食。")
    public String feedingSummary(@P("回溯天数，7 表示最近 7 天") int days) {
        return tools.feedingSummary(days);
    }

    @Tool("查询当前宠物的提醒执行情况：近若干天各提醒应做/已完成次数与漏做日期、今天要做且未打卡的、未来若干天到期的疫苗/驱虫事件、已过期未完成的事件。")
    public String reminderStatus(@P("回溯与后看的天数，7 表示近 7 天执行情况和未来 7 天事件") int days) {
        return tools.reminderStatus(days);
    }
}
