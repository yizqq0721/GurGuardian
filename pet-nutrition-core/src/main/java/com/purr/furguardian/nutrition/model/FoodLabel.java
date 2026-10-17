package com.purr.furguardian.nutrition.model;

public class FoodLabel {

    public enum ProductType {
        COMPLETE_FEED,
        COMPLEMENTARY_FEED,
        SNACK
    }

    private String name;
    private ProductType productType;
    private GuaranteedAnalysis guaranteedAnalysis;
    private Double labeledMeKcalPerKg;

    public FoodLabel() {
        this.productType = ProductType.COMPLETE_FEED;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public ProductType getProductType() { return productType; }
    public void setProductType(ProductType productType) { this.productType = productType; }
    public GuaranteedAnalysis getGuaranteedAnalysis() { return guaranteedAnalysis; }
    public void setGuaranteedAnalysis(GuaranteedAnalysis guaranteedAnalysis) { this.guaranteedAnalysis = guaranteedAnalysis; }
    public Double getLabeledMeKcalPerKg() { return labeledMeKcalPerKg; }
    public void setLabeledMeKcalPerKg(Double labeledMeKcalPerKg) { this.labeledMeKcalPerKg = labeledMeKcalPerKg; }
}
