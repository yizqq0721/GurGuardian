package com.purr.furguardian.nutrition.standard;

import com.purr.furguardian.nutrition.model.LifeStage;
import com.purr.furguardian.nutrition.model.Species;

public interface NutritionStandard {

    Species getSpecies();

    double proteinMinDm(LifeStage stage);

    double fatMinDm(LifeStage stage);

    double calciumMinDm(LifeStage stage);

    double phosphorusMinDm(LifeStage stage);

    double taurineMinDm(LifeStage stage);

    double lysineMinDm(LifeStage stage);
}
