package com.purr.furguardian.nutrition.model;

public class NutritionValidation {

    private String nutrient;
    private double actualValue;
    private double requiredMin;
    private boolean passed;
    private String unit;

    public NutritionValidation() {}

    public NutritionValidation(String nutrient, double actualValue, double requiredMin, boolean passed, String unit) {
        this.nutrient = nutrient;
        this.actualValue = actualValue;
        this.requiredMin = requiredMin;
        this.passed = passed;
        this.unit = unit;
    }

    public String getNutrient() { return nutrient; }
    public void setNutrient(String nutrient) { this.nutrient = nutrient; }
    public double getActualValue() { return actualValue; }
    public void setActualValue(double actualValue) { this.actualValue = actualValue; }
    public double getRequiredMin() { return requiredMin; }
    public void setRequiredMin(double requiredMin) { this.requiredMin = requiredMin; }
    public boolean isPassed() { return passed; }
    public void setPassed(boolean passed) { this.passed = passed; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
}
