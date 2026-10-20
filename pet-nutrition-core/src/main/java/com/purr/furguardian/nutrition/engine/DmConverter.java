package com.purr.furguardian.nutrition.engine;

public final class DmConverter {

    private DmConverter() {}

    public static double toDryMatterPercent(double asFedValue, double moisturePercent) {
        double dmFraction = (100.0 - moisturePercent) / 100.0;
        if (dmFraction <= 0) {
            throw new IllegalArgumentException("水分值必须小于100%");
        }
        return asFedValue / dmFraction;
    }

    public static double dryMatterFraction(double moisturePercent) {
        return (100.0 - moisturePercent) / 100.0;
    }
}
