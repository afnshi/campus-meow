package com.campusmeow.api.auth;

import com.campusmeow.api.auth.AuthDtos.AuthResponse;
import com.campusmeow.api.auth.AuthDtos.LoginRequest;
import com.campusmeow.api.auth.AuthDtos.RegisterRequest;
import com.campusmeow.api.common.exception.ApiException;
import com.campusmeow.api.common.security.JwtService;
import com.campusmeow.api.user.User;
import com.campusmeow.api.user.UserDtos.UserResponse;
import com.campusmeow.api.user.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {
    private final UserRepository users;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository users, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.users = users;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (users.existsByUsername(request.username())) {
            throw new ApiException("USERNAME_EXISTS", "Username is already registered", HttpStatus.CONFLICT);
        }
        User user = users.save(new User(request.username(), passwordEncoder.encode(request.password()),
            request.nickname()));
        return response(user);
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        User user = users.findByUsername(request.username()).orElseThrow(this::invalidCredentials);
        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw invalidCredentials();
        }
        return response(user);
    }

    private AuthResponse response(User user) {
        return new AuthResponse(jwtService.create(user.getId(), user.getUsername()), "Bearer",
            jwtService.getTtlSeconds(), UserResponse.from(user));
    }

    private ApiException invalidCredentials() {
        return new ApiException("INVALID_CREDENTIALS", "Username or password is incorrect", HttpStatus.UNAUTHORIZED);
    }
}

