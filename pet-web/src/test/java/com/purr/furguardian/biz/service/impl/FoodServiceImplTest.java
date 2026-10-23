package com.purr.furguardian.biz.service.impl;

import com.purr.furguardian.biz.entity.food.FoodDO;
import com.purr.furguardian.biz.mapper.food.FoodMapper;
import com.purr.furguardian.biz.mapper.food.FoodNutrientMapper;
import com.purr.furguardian.common.exception.BizException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

class FoodServiceImplTest {

    private final FoodMapper foodMapper = mock(FoodMapper.class);
    private final FoodNutrientMapper nutrientMapper = mock(FoodNutrientMapper.class);
    private final FoodServiceImpl service = new FoodServiceImpl(foodMapper, nutrientMapper);

    private FoodDO food(Long userId) {
        FoodDO food = new FoodDO();
        food.setId(7L);
        food.setUserId(userId);
        food.setName("皇家成犬粮");
        return food;
    }

    @Test
    @DisplayName("公共食品（userId 为空）不允许修改")
    void should_rejectUpdate_when_foodIsPublic() {
        when(foodMapper.selectById(7L)).thenReturn(food(null));

        BizException ex = assertThrows(BizException.class,
                () -> service.updateFood(9L, 7L, food(9L), null));

        assertEquals(403, ex.getCode());
        verify(foodMapper, never()).updateById(any(FoodDO.class));
    }

    @Test
    @DisplayName("公共食品（userId 为空）不允许删除")
    void should_rejectDelete_when_foodIsPublic() {
        when(foodMapper.selectById(7L)).thenReturn(food(null));

        BizException ex = assertThrows(BizException.class,
                () -> service.deleteFood(9L, 7L));

        assertEquals(403, ex.getCode());
        verify(foodMapper, never()).deleteById(anyLong());
        verifyNoInteractions(nutrientMapper);
    }

    @Test
    @DisplayName("他人食品不允许修改")
    void should_rejectUpdate_when_foodBelongsToAnotherUser() {
        when(foodMapper.selectById(7L)).thenReturn(food(8L));

        BizException ex = assertThrows(BizException.class,
                () -> service.updateFood(9L, 7L, food(9L), null));

        assertEquals(403, ex.getCode());
        verify(foodMapper, never()).updateById(any(FoodDO.class));
    }

    @Test
    @DisplayName("本人食品可以正常修改")
    void should_updateFood_when_ownerMatches() {
        when(foodMapper.selectById(7L)).thenReturn(food(9L));
        FoodDO update = food(9L);
        update.setName("新名称");

        service.updateFood(9L, 7L, update, null);

        verify(foodMapper).updateById(update);
    }

    @Test
    @DisplayName("本人删除食品时一并清理营养成分")
    void should_deleteNutrients_when_ownerDeletesFood() {
        when(foodMapper.selectById(7L)).thenReturn(food(9L));

        service.deleteFood(9L, 7L);

        verify(foodMapper).deleteById(7L);
        verify(nutrientMapper).delete(any());
    }
}
