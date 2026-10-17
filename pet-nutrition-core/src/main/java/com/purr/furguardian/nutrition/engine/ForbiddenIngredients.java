package com.purr.furguardian.nutrition.engine;

import java.util.List;

public final class ForbiddenIngredients {

    private static final List<String> FORBIDDEN = List.of(
            "洋葱", "大葱", "蒜", "onion", "garlic",
            "葡萄", "葡萄干", "grape", "raisin",
            "巧克力", "chocolate",
            "木糖醇", "xylitol",
            "酒精", "alcohol",
            "澳洲坚果", "macadamia",
            "咖啡因", "caffeine",
            "生面团", "raw dough"
    );

    private ForbiddenIngredients() {}

    public static boolean containsForbidden(String ingredientText) {
        if (ingredientText == null || ingredientText.isBlank()) {
            return false;
        }
        String lower = ingredientText.toLowerCase();
        for (String forbidden : FORBIDDEN) {
            if (lower.contains(forbidden.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    public static String findForbidden(String ingredientText) {
        if (ingredientText == null || ingredientText.isBlank()) {
            return null;
        }
        String lower = ingredientText.toLowerCase();
        for (String forbidden : FORBIDDEN) {
            if (lower.contains(forbidden.toLowerCase())) {
                return forbidden;
            }
        }
        return null;
    }
}
