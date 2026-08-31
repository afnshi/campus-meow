package com.campusmeow.api.user;

import com.campusmeow.api.common.api.ApiResponse;
import com.campusmeow.api.common.security.CurrentUser;
import com.campusmeow.api.user.UserDtos.UpdateProfileRequest;
import com.campusmeow.api.user.UserDtos.UserResponse;
import com.campusmeow.api.user.UserDtos.UserSummary;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    ApiResponse<UserResponse> me(CurrentUser currentUser) {
        return ApiResponse.success(userService.get(currentUser.id()));
    }

    @PutMapping("/me")
    ApiResponse<UserResponse> update(CurrentUser currentUser, @Valid @RequestBody UpdateProfileRequest request) {
        return ApiResponse.success(userService.update(currentUser.id(), request));
    }

    @GetMapping("/{id}/summary")
    ApiResponse<UserSummary> summary(@PathVariable long id) {
        return ApiResponse.success(userService.summary(id));
    }
}

