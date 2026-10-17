package com.purr.furguardian.nutrition.standard;

import com.purr.furguardian.nutrition.model.LifeStage;
import com.purr.furguardian.nutrition.model.Species;

public class CatNutritionStandard implements NutritionStandard {

    @Override
    public Species getSpecies() { return Species.CAT; }

    @Override
    public double proteinMinDm(LifeStage stage) {
        return stage == LifeStage.BABY ? 28.0 : 25.0;
    }

    @Override
    public double fatMinDm(LifeStage stage) {
        return 9.0;
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
        return 0.1;
    }

    @Override
    public double lysineMinDm(LifeStage stage) {
        return 0;
    }
}
