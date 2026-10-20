package com.purr.furguardian.nutrition.engine;

import com.purr.furguardian.nutrition.model.GuaranteedAnalysis;

public final class EnergyEstimator {

    private static final double ATWATER_PROTEIN = 3.5;
    private static final double ATWATER_FAT = 8.5;
    private static final double ATWATER_NFE = 3.5;

    private EnergyEstimator() {}

    public static double estimateModifiedAtwater(GuaranteedAnalysis ga) {
        double moisture = defaultMoisture(ga);
        double protein = defaultProtein(ga);
        double fat = defaultFat(ga);
        double fiber = defaultFiber(ga);
        double ash = defaultAsh(ga);

        double nfe = 100.0 - moisture - protein - fat - fiber - ash;
        if (nfe < 0) nfe = 0;

        return ATWATER_PROTEIN * protein + ATWATER_FAT * fat + ATWATER_NFE * nfe;
    }

    public static double estimateAafco(GuaranteedAnalysis ga, boolean isDog) {
        double moisture = defaultMoisture(ga);
        double protein = defaultProtein(ga);
        double fat = defaultFat(ga);
        double fiber = defaultFiber(ga);
        double ash = defaultAsh(ga);

        double nfe = 100.0 - moisture - protein - fat - fiber - ash;
        if (nfe < 0) nfe = 0;

        double fiberDm = (moisture < 100) ? fiber / ((100.0 - moisture) / 100.0) : fiber;

        double ge = 5.7 * protein + 9.4 * fat + 4.1 * (nfe + fiber);
        double digestibility;
        if (isDog) {
            digestibility = 91.2 - 1.43 * fiberDm;
        } else {
            digestibility = 87.9 - 0.88 * fiberDm;
        }
        double de = ge * digestibility / 100.0;
        double me;
        if (isDog) {
            me = de - 1.04 * protein;
        } else {
            me = de - 0.77 * protein;
        }
        return me;
    }

    public static double estimate(GuaranteedAnalysis ga, boolean isDog) {
        double moisture = defaultMoisture(ga);
        double fiber = defaultFiber(ga);
        double fiberDm = (moisture < 100) ? fiber / ((100.0 - moisture) / 100.0) : fiber;

        if (fiberDm > 8.0) {
            return estimateAafco(ga, isDog);
        }
        return estimateModifiedAtwater(ga);
    }

    private static double defaultMoisture(GuaranteedAnalysis ga) {
        return ga.getMoistureMax() != null ? ga.getMoistureMax() : 10.0;
    }

    private static double defaultProtein(GuaranteedAnalysis ga) {
        return ga.getCrudeProteinMin() != null ? ga.getCrudeProteinMin() : 26.0;
    }

    private static double defaultFat(GuaranteedAnalysis ga) {
        return ga.getCrudeFatMin() != null ? ga.getCrudeFatMin() : 14.0;
    }

    private static double defaultFiber(GuaranteedAnalysis ga) {
        return ga.getCrudeFiberMax() != null ? ga.getCrudeFiberMax() : 4.0;
    }

    private static double defaultAsh(GuaranteedAnalysis ga) {
        return ga.getAshMax() != null ? ga.getAshMax() : 8.0;
    }
}
