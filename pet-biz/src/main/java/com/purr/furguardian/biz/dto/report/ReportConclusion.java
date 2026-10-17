package com.purr.furguardian.biz.dto.report;

import java.util.ArrayList;
import java.util.List;

public class ReportConclusion {

    private List<RuleResult> rules = new ArrayList<>();
    private String summary;

    public List<RuleResult> getRules() { return rules; }
    public void setRules(List<RuleResult> rules) { this.rules = rules; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public void addRule(RuleResult rule) {
        this.rules.add(rule);
    }

    public static class RuleResult {
        private String ruleId;
        private String ruleName;
        private boolean triggered;
        private String severity;
        private String suggestion;
        private String detail;

        public RuleResult() {}

        public RuleResult(String ruleId, String ruleName, boolean triggered, String severity, String suggestion, String detail) {
            this.ruleId = ruleId;
            this.ruleName = ruleName;
            this.triggered = triggered;
            this.severity = severity;
            this.suggestion = suggestion;
            this.detail = detail;
        }

        public String getRuleId() { return ruleId; }
        public void setRuleId(String ruleId) { this.ruleId = ruleId; }
        public String getRuleName() { return ruleName; }
        public void setRuleName(String ruleName) { this.ruleName = ruleName; }
        public boolean isTriggered() { return triggered; }
        public void setTriggered(boolean triggered) { this.triggered = triggered; }
        public String getSeverity() { return severity; }
        public void setSeverity(String severity) { this.severity = severity; }
        public String getSuggestion() { return suggestion; }
        public void setSuggestion(String suggestion) { this.suggestion = suggestion; }
        public String getDetail() { return detail; }
        public void setDetail(String detail) { this.detail = detail; }
    }
}
