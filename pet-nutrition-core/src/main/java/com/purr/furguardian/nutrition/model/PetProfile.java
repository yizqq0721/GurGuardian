package com.purr.furguardian.nutrition.model;

public class PetProfile {

    private Species species;
    private String breed;
    private boolean neutered;
    private int ageInMonths;
    private double weightKg;
    private Double idealWeightKg;
    private ActivityLevel activityLevel;
    private int bcs;
    private PhysiologyStatus physiologyStatus;

    public PetProfile() {
        this.activityLevel = ActivityLevel.MODERATE;
        this.bcs = 5;
        this.physiologyStatus = PhysiologyStatus.NORMAL;
    }

    public Species getSpecies() { return species; }
    public void setSpecies(Species species) { this.species = species; }
    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }
    public boolean isNeutered() { return neutered; }
    public void setNeutered(boolean neutered) { this.neutered = neutered; }
    public int getAgeInMonths() { return ageInMonths; }
    public void setAgeInMonths(int ageInMonths) { this.ageInMonths = ageInMonths; }
    public double getWeightKg() { return weightKg; }
    public void setWeightKg(double weightKg) { this.weightKg = weightKg; }
    public Double getIdealWeightKg() { return idealWeightKg; }
    public void setIdealWeightKg(Double idealWeightKg) { this.idealWeightKg = idealWeightKg; }
    public ActivityLevel getActivityLevel() { return activityLevel; }
    public void setActivityLevel(ActivityLevel activityLevel) { this.activityLevel = activityLevel; }
    public int getBcs() { return bcs; }
    public void setBcs(int bcs) { this.bcs = bcs; }
    public PhysiologyStatus getPhysiologyStatus() { return physiologyStatus; }
    public void setPhysiologyStatus(PhysiologyStatus physiologyStatus) { this.physiologyStatus = physiologyStatus; }

    public LifeStage getLifeStage() {
        if (species == Species.DOG) {
            if (ageInMonths < 4) return LifeStage.BABY;
            if (ageInMonths >= 84) return LifeStage.SENIOR;
            return LifeStage.ADULT;
        } else {
            if (ageInMonths < 12) return LifeStage.BABY;
            if (ageInMonths >= 132) return LifeStage.SENIOR;
            return LifeStage.ADULT;
        }
    }
}
