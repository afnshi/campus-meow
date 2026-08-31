package com.campusmeow.api.user;

import com.campusmeow.api.common.exception.ApiException;
import com.campusmeow.api.user.UserDtos.UpdateProfileRequest;
import com.campusmeow.api.user.UserDtos.UserResponse;
import com.campusmeow.api.user.UserDtos.UserSummary;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {
    private final UserRepository users;

    public UserService(UserRepository users) {
        this.users = users;
    }

    @Transactional(readOnly = true)
    public User requireUser(long id) {
        return users.findById(id).orElseThrow(() ->
            new ApiException("USER_NOT_FOUND", "User does not exist", HttpStatus.NOT_FOUND));
    }

    @Transactional(readOnly = true)
    public UserResponse get(long id) {
        return UserResponse.from(requireUser(id));
    }

    @Transactional(readOnly = true)
    public UserSummary summary(long id) {
        return UserSummary.from(requireUser(id));
    }

    @Transactional
    public UserResponse update(long id, UpdateProfileRequest request) {
        User user = requireUser(id);
        user.updateProfile(request.nickname(), request.birthday(), request.school(), request.className(),
            request.bio(), request.avatarUrl());
        return UserResponse.from(user);
    }
}

