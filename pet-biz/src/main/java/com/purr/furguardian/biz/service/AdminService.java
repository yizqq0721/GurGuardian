package com.purr.furguardian.biz.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.purr.furguardian.biz.dto.admin.AdminUserDetail;
import com.purr.furguardian.biz.dto.admin.AdminUserSummary;

public interface AdminService {

    Page<AdminUserSummary> listUsers(Long operatorId, int page, int size, String keyword);

    AdminUserDetail getUserDetail(Long operatorId, Long userId);

    void updateUserStatus(Long operatorId, Long userId, Integer status);
}
