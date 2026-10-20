package com.purr.furguardian.nutrition.standard;

import com.purr.furguardian.nutrition.model.LifeStage;
import com.purr.furguardian.nutrition.model.Species;

public class DogNutritionStandard implements NutritionStandard {

    @Override
    public Species getSpecies() { return Species.DOG; }

    @Override
    public double proteinMinDm(LifeStage stage) {
        return stage == LifeStage.BABY ? 22.0 : 18.0;
    }

    @Override
    public double fatMinDm(LifeStage stage) {
        return stage == LifeStage.BABY ? 8.0 : 5.0;
    }

    @Override
    public double calciumMinDm(LifeStage stage) {
        return stage == LifeStage.BABY ? 1.0 : 0.6;
    }

    @Override
    public double phosphorusMinDm(LifeStage stage) {
        return stage == LifeStage.BABY ? 0.8 : 0.5;
    }

    @Override
    public double taurineMinDm(LifeStage stage) {
        return 0;
    }

    @Override
    public double lysineMinDm(LifeStage stage) {
        return stage == LifeStage.BABY ? 0.77 : 0.63;
    }
}
