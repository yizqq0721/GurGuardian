package com.purr.furguardian.ai.model;

import java.util.ArrayList;
import java.util.List;

/** AI 每日食谱建议：正文 + 知识来源 + 本次参考的零食 */
public class NutritionRecipe {

    private String content;
    private List<SourceRef> sources = new ArrayList<>();
    private List<SnackRef> snacks = new ArrayList<>();
    private boolean isFallback;

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public List<SourceRef> getSources() { return sources; }
    public void setSources(List<SourceRef> sources) { this.sources = sources; }
    public List<SnackRef> getSnacks() { return snacks; }
    public void setSnacks(List<SnackRef> snacks) { this.snacks = snacks; }
    public boolean getIsFallback() { return isFallback; }
    public void setIsFallback(boolean fallback) { isFallback = fallback; }

    public static class SourceRef {
        private Long docId;
        private String title;
        private String sourceName;

        public SourceRef() {}
        public SourceRef(Long docId, String title, String sourceName) {
            this.docId = docId;
            this.title = title;
            this.sourceName = sourceName;
        }

        public Long getDocId() { return docId; }
        public void setDocId(Long docId) { this.docId = docId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getSourceName() { return sourceName; }
        public void setSourceName(String sourceName) { this.sourceName = sourceName; }
    }

    public static class SnackRef {
        private Long id;
        private String name;
        private String brand;
        private Double labeledMeKcal;
        /** 零食额度全部给这一种时的每日上限克数；未标注热量则为 null */
        private Double maxGrams;

        public SnackRef() {}
        public SnackRef(Long id, String name, String brand, Double labeledMeKcal, Double maxGrams) {
            this.id = id;
            this.name = name;
            this.brand = brand;
            this.labeledMeKcal = labeledMeKcal;
            this.maxGrams = maxGrams;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getBrand() { return brand; }
        public void setBrand(String brand) { this.brand = brand; }
        public Double getLabeledMeKcal() { return labeledMeKcal; }
        public void setLabeledMeKcal(Double labeledMeKcal) { this.labeledMeKcal = labeledMeKcal; }
        public Double getMaxGrams() { return maxGrams; }
        public void setMaxGrams(Double maxGrams) { this.maxGrams = maxGrams; }
    }
}
