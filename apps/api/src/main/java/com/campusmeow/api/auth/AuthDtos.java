package com.campusmeow.api.auth;

import com.campusmeow.api.user.UserDtos.UserResponse;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public final class AuthDtos {
    private AuthDtos() {
    }

    public record RegisterRequest(
        @NotBlank @Pattern(regexp = "[A-Za-z0-9_]{3,50}") String username,
        @NotBlank @Size(min = 8, max = 72) String password,
        @NotBlank @Size(max = 50) String nickname
    ) {
    }

    public record LoginRequest(@NotBlank String username, @NotBlank String password) {
    }

    public record AuthResponse(String accessToken, String tokenType, long expiresIn, UserResponse user) {
    }
}

