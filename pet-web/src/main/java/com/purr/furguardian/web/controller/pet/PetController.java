package com.purr.furguardian.web.controller.pet;

import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.PetWeightLogDO;
import com.purr.furguardian.biz.service.PetService;
import com.purr.furguardian.common.context.UserContext;
import com.purr.furguardian.common.result.Result;
import com.purr.furguardian.web.dto.pet.PetCreateDTO;
import com.purr.furguardian.web.dto.pet.WeightLogDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pet")
@Tag(name = "宠物档案")
public class PetController {

    private final PetService petService;

    public PetController(PetService petService) {
        this.petService = petService;
    }

    @PostMapping
    @Operation(summary = "创建宠物")
    public Result<Long> create(@RequestBody @Valid PetCreateDTO dto) {
        PetDO pet = toEntity(dto);
        Long id = petService.createPet(UserContext.getUserId(), pet);
        return Result.ok(id);
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新宠物")
    public Result<Void> update(@PathVariable Long id, @RequestBody @Valid PetCreateDTO dto) {
        PetDO pet = toEntity(dto);
        petService.updatePet(UserContext.getUserId(), id, pet);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除宠物")
    public Result<Void> delete(@PathVariable Long id) {
        petService.deletePet(UserContext.getUserId(), id);
        return Result.ok();
    }

    @GetMapping("/{id}")
    @Operation(summary = "宠物详情")
    public Result<PetDO> detail(@PathVariable Long id) {
        return Result.ok(petService.getPet(UserContext.getUserId(), id));
    }

    @GetMapping("/list")
    @Operation(summary = "我的宠物列表")
    public Result<List<PetDO>> list() {
        return Result.ok(petService.listPets(UserContext.getUserId()));
    }

    @PostMapping("/{id}/weight")
    @Operation(summary = "记录体重")
    public Result<Void> addWeight(@PathVariable Long id, @RequestBody WeightLogDTO dto) {
        petService.addWeightLog(UserContext.getUserId(), id, dto.getWeightKg(), dto.getBcs(), dto.getRecordedAt());
        return Result.ok();
    }

    @GetMapping("/{id}/weight-history")
    @Operation(summary = "体重历史")
    public Result<List<PetWeightLogDO>> weightHistory(@PathVariable Long id) {
        return Result.ok(petService.getWeightHistory(UserContext.getUserId(), id));
    }

    private PetDO toEntity(PetCreateDTO dto) {
        PetDO pet = new PetDO();
        pet.setName(dto.getName());
        pet.setSpecies(dto.getSpecies());
        pet.setBreed(dto.getBreed());
        pet.setSex(dto.getSex());
        pet.setNeutered(Boolean.TRUE.equals(dto.getNeutered()) ? 1 : 0);
        pet.setBirthday(dto.getBirthday());
        pet.setActivityLevel(dto.getActivityLevel());
        pet.setBcs(dto.getBcs());
        pet.setPhysiology(dto.getPhysiology());
        return pet;
    }
}
