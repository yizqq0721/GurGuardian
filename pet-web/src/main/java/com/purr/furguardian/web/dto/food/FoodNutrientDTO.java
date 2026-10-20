package com.purr.furguardian.web.dto.food;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;

public class FoodNutrientDTO {

    @Schema(description = "水分≤(%)", example = "10.00")
    private BigDecimal moistureMax;

    @Schema(description = "粗蛋白质≥(%)", example = "24.00")
    private BigDecimal crudeProteinMin;

    @Schema(description = "粗脂肪≥(%)", example = "13.00")
    private BigDecimal crudeFatMin;

    @Schema(description = "粗纤维≤(%)", example = "5.00")
    private BigDecimal crudeFiberMax;

    @Schema(description = "粗灰分≤(%)", example = "8.00")
    private BigDecimal ashMax;

    @Schema(description = "钙≥(%)", example = "1.000")
    private BigDecimal calciumMin;

    @Schema(description = "总磷≥(%)", example = "0.800")
    private BigDecimal phosphorusMin;

    @Schema(description = "牛磺酸≥(%,猫)", example = "0.150")
    private BigDecimal taurineMin;

    @Schema(description = "赖氨酸≥(%,犬)", example = "0.630")
    private BigDecimal lysineMin;

    public BigDecimal getMoistureMax() { return moistureMax; }
    public void setMoistureMax(BigDecimal moistureMax) { this.moistureMax = moistureMax; }
    public BigDecimal getCrudeProteinMin() { return crudeProteinMin; }
    public void setCrudeProteinMin(BigDecimal crudeProteinMin) { this.crudeProteinMin = crudeProteinMin; }
    public BigDecimal getCrudeFatMin() { return crudeFatMin; }
    public void setCrudeFatMin(BigDecimal crudeFatMin) { this.crudeFatMin = crudeFatMin; }
    public BigDecimal getCrudeFiberMax() { return crudeFiberMax; }
    public void setCrudeFiberMax(BigDecimal crudeFiberMax) { this.crudeFiberMax = crudeFiberMax; }
    public BigDecimal getAshMax() { return ashMax; }
    public void setAshMax(BigDecimal ashMax) { this.ashMax = ashMax; }
    public BigDecimal getCalciumMin() { return calciumMin; }
    public void setCalciumMin(BigDecimal calciumMin) { this.calciumMin = calciumMin; }
    public BigDecimal getPhosphorusMin() { return phosphorusMin; }
    public void setPhosphorusMin(BigDecimal phosphorusMin) { this.phosphorusMin = phosphorusMin; }
    public BigDecimal getTaurineMin() { return taurineMin; }
    public void setTaurineMin(BigDecimal taurineMin) { this.taurineMin = taurineMin; }
    public BigDecimal getLysineMin() { return lysineMin; }
    public void setLysineMin(BigDecimal lysineMin) { this.lysineMin = lysineMin; }
}
