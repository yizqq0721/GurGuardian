package com.purr.furguardian.nutrition.model;

import java.util.ArrayList;
import java.util.List;

public class NutritionResult {

    private double rerKcal;
    private double merKcal;
    private double mainFoodGrams;
    private double snackBudgetKcal;
    private double snackBudgetGrams;
    private int mealsPerDay;
    private double gramsPerMeal;
    private double energyDensityKcalPer100g;
    private boolean energyEstimated;
    private String calculationProcess;

    private Double idealWeightUsed;
    private boolean overweight;
    private boolean underweight;
    private String weightAdvice;

    private List<NutritionValidation> validations = new ArrayList<>();
    private List<String> warnings = new ArrayList<>();

    public double getRerKcal() { return rerKcal; }
    public void setRerKcal(double rerKcal) { this.rerKcal = rerKcal; }
    public double getMerKcal() { return merKcal; }
    public void setMerKcal(double merKcal) { this.merKcal = merKcal; }
    public double getMainFoodGrams() { return mainFoodGrams; }
    public void setMainFoodGrams(double mainFoodGrams) { this.mainFoodGrams = mainFoodGrams; }
    public double getSnackBudgetKcal() { return snackBudgetKcal; }
    public void setSnackBudgetKcal(double snackBudgetKcal) { this.snackBudgetKcal = snackBudgetKcal; }
    public double getSnackBudgetGrams() { return snackBudgetGrams; }
    public void setSnackBudgetGrams(double snackBudgetGrams) { this.snackBudgetGrams = snackBudgetGrams; }
    public int getMealsPerDay() { return mealsPerDay; }
    public void setMealsPerDay(int mealsPerDay) { this.mealsPerDay = mealsPerDay; }
    public double getGramsPerMeal() { return gramsPerMeal; }
    public void setGramsPerMeal(double gramsPerMeal) { this.gramsPerMeal = gramsPerMeal; }
    public double getEnergyDensityKcalPer100g() { return energyDensityKcalPer100g; }
    public void setEnergyDensityKcalPer100g(double energyDensityKcalPer100g) { this.energyDensityKcalPer100g = energyDensityKcalPer100g; }
    public boolean isEnergyEstimated() { return energyEstimated; }
    public void setEnergyEstimated(boolean energyEstimated) { this.energyEstimated = energyEstimated; }
    public String getCalculationProcess() { return calculationProcess; }
    public void setCalculationProcess(String calculationProcess) { this.calculationProcess = calculationProcess; }
    public Double getIdealWeightUsed() { return idealWeightUsed; }
    public void setIdealWeightUsed(Double idealWeightUsed) { this.idealWeightUsed = idealWeightUsed; }
    public boolean isOverweight() { return overweight; }
    public void setOverweight(boolean overweight) { this.overweight = overweight; }
    public boolean isUnderweight() { return underweight; }
    public void setUnderweight(boolean underweight) { this.underweight = underweight; }
    public String getWeightAdvice() { return weightAdvice; }
    public void setWeightAdvice(String weightAdvice) { this.weightAdvice = weightAdvice; }
    public List<NutritionValidation> getValidations() { return validations; }
    public void setValidations(List<NutritionValidation> validations) { this.validations = validations; }
    public List<String> getWarnings() { return warnings; }
    public void setWarnings(List<String> warnings) { this.warnings = warnings; }
}
