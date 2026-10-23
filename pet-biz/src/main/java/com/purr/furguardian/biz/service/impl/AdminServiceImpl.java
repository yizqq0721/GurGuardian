package com.purr.furguardian.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.purr.furguardian.biz.dto.admin.AdminUserDetail;
import com.purr.furguardian.biz.dto.admin.AdminUserSummary;
import com.purr.furguardian.biz.entity.pet.PetDO;
import com.purr.furguardian.biz.entity.pet.UserDO;
import com.purr.furguardian.biz.mapper.pet.PetMapper;
import com.purr.furguardian.biz.mapper.pet.UserMapper;
import com.purr.furguardian.biz.service.AdminService;
import com.purr.furguardian.common.exception.BizException;
import com.purr.furguardian.common.result.ErrorCode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AdminServiceImpl implements AdminService {

    private final UserMapper userMapper;
    private final PetMapper petMapper;
    private final String adminUsername;

    public AdminServiceImpl(UserMapper userMapper, PetMapper petMapper,
                            @Value("${fg.admin.username:admin}") String adminUsername) {
        this.userMapper = userMapper;
        this.petMapper = petMapper;
        this.adminUsername = adminUsername;
    }

    @Override
    public Page<AdminUserSummary> listUsers(Long operatorId, int page, int size, String keyword) {
        requireAdmin(operatorId);
        int safePage = Math.max(page, 1);
        int safeSize = Math.min(Math.max(size, 1), 100);

        LambdaQueryWrapper<UserDO> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim();
            wrapper.and(w -> w.like(UserDO::getUsername, kw).or().like(UserDO::getNickname, kw));
        }
        wrapper.orderByAsc(UserDO::getId);

        Page<UserDO> userPage = userMapper.selectPage(new Page<>(safePage, safeSize), wrapper);
        List<AdminUserSummary> records = userPage.getRecords().stream().map(this::toSummary).toList();
        Map<Long, Long> petCounts = petCounts(records.stream().map(AdminUserSummary::getId).toList());
        records.forEach(item -> item.setPetCount(petCounts.getOrDefault(item.getId(), 0L)));

        Page<AdminUserSummary> result = new Page<>(userPage.getCurrent(), userPage.getSize(), userPage.getTotal());
        result.setRecords(records);
        return result;
    }

    @Override
    public AdminUserDetail getUserDetail(Long operatorId, Long userId) {
        requireAdmin(operatorId);
        UserDO user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "用户不存在");
        }

        AdminUserDetail detail = new AdminUserDetail();
        detail.setId(user.getId());
        detail.setUsername(user.getUsername());
        detail.setNickname(user.getNickname());
        detail.setAvatar(user.getAvatar());
        detail.setStatus(user.getStatus());
        detail.setIsAdmin(adminUsername.equalsIgnoreCase(user.getUsername()));
        detail.setCreatedAt(user.getCreatedAt());
        detail.setUpdatedAt(user.getUpdatedAt());
        detail.setPets(petMapper.selectList(new LambdaQueryWrapper<PetDO>()
                .eq(PetDO::getUserId, userId)
                .orderByDesc(PetDO::getCreatedAt)));
        return detail;
    }

    @Override
    public void updateUserStatus(Long operatorId, Long userId, Integer status) {
        requireAdmin(operatorId);
        if (status == null || (status != 0 && status != 1)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "状态值只能为 0 或 1");
        }
        if (userId.equals(operatorId)) {
            throw new BizException(ErrorCode.BAD_REQUEST, "不能修改自己的账号状态");
        }
        UserDO user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.DATA_NOT_FOUND, "用户不存在");
        }

        UserDO update = new UserDO();
        update.setId(userId);
        update.setStatus(status);
        update.setUpdatedAt(LocalDateTime.now());
        userMapper.updateById(update);
    }

    private void requireAdmin(Long operatorId) {
        UserDO operator = operatorId == null ? null : userMapper.selectById(operatorId);
        if (operator == null
                || !Integer.valueOf(1).equals(operator.getStatus())
                || !adminUsername.equalsIgnoreCase(operator.getUsername())) {
            throw new BizException(ErrorCode.FORBIDDEN, "仅管理员可访问");
        }
    }

    private Map<Long, Long> petCounts(List<Long> userIds) {
        if (userIds.isEmpty()) {
            return Map.of();
        }
        return petMapper.selectList(new LambdaQueryWrapper<PetDO>().in(PetDO::getUserId, userIds))
                .stream()
                .collect(Collectors.groupingBy(PetDO::getUserId, Collectors.counting()));
    }

    private AdminUserSummary toSummary(UserDO user) {
        AdminUserSummary summary = new AdminUserSummary();
        summary.setId(user.getId());
        summary.setUsername(user.getUsername());
        summary.setNickname(user.getNickname());
        summary.setAvatar(user.getAvatar());
        summary.setStatus(user.getStatus());
        summary.setIsAdmin(adminUsername.equalsIgnoreCase(user.getUsername()));
        summary.setCreatedAt(user.getCreatedAt());
        return summary;
    }
}
