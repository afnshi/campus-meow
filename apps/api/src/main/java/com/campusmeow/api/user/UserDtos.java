package com.campusmeow.api.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

public final class UserDtos {
    private UserDtos() {
    }

    public record UpdateProfileRequest(
        @NotBlank @Size(max = 50) String nickname,
        @PastOrPresent LocalDate birthday,
        @Size(max = 100) String school,
        @Size(max = 100) String className,
        @Size(max = 255) String bio,
        @Size(max = 500) String avatarUrl
    ) {
    }

    public record UserResponse(Long id, String username, String nickname, LocalDate birthday,
                               String school, String className, String bio, String avatarUrl) {
        public static UserResponse from(User user) {
            return new UserResponse(user.getId(), user.getUsername(), user.getNickname(), user.getBirthday(),
                user.getSchool(), user.getClassName(), user.getBio(), user.getAvatarUrl());
        }
    }

    public record UserSummary(Long id, String nickname, String school, String avatarUrl) {
        public static UserSummary from(User user) {
            return new UserSummary(user.getId(), user.getNickname(), user.getSchool(), user.getAvatarUrl());
        }
    }
}

