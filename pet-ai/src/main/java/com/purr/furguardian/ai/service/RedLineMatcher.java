package com.purr.furguardian.ai.service;

import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
public class RedLineMatcher {

    private static final List<String> RED_LINE_KEYWORDS = Arrays.asList(
            "抽搐", "呼吸困难", "中毒", "尿闭", "难产", "大量出血", "昏迷",
            "眼球脱出", "腹部胀硬", "误食", "吞食", "车祸", "坠落",
            "意识丧失", "持续抽搐", "不停呕吐", "血便", "便血",
            "无法排尿", "排尿困难", "公猫尿不出"
    );

    private static final List<String> EMERGENCY_SYMPTOMS = Arrays.asList(
            "呕吐不止", "频繁呕吐", "腹泻带血", "便血", "血便",
            "呼吸急促", "呼吸窘迫", "张嘴呼吸",
            "精神极度萎靡", "完全拒食", "拒食超过24小时",
            "饮水量骤增", "排尿困难", "尿血",
            "皮肤肿块快速增大", "伤口化脓",
            "持续咳嗽", "打喷嚏带血",
            "跛行不能站立", "后肢瘫痪",
            "体重骤降", "腹部异常膨大"
    );

    public boolean matchRedLine(String userInput) {
        if (userInput == null || userInput.isEmpty()) {
            return false;
        }
        for (String keyword : RED_LINE_KEYWORDS) {
            if (userInput.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    public String getRedLineResponse() {
        return "⚠️ 您描述的症状可能属于紧急情况，建议尽快带宠物前往兽医处就诊。\n\n" +
                "在就医前请注意：\n" +
                "1. 保持宠物安静，避免剧烈运动\n" +
                "2. 如怀疑中毒，请带上疑似毒物包装前往医院\n" +
                "3. 记录症状出现的时间和频率，方便兽医判断\n\n" +
                "以上建议仅供参考，不构成医疗建议。请尽快咨询专业兽医。";
    }

    public boolean matchEmergencySymptom(String text) {
        if (text == null || text.isEmpty()) {
            return false;
        }
        for (String symptom : EMERGENCY_SYMPTOMS) {
            if (text.contains(symptom)) {
                return true;
            }
        }
        return false;
    }
}
