package com.campusmeow.api.common.security;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

class JwtServiceTest {
    @Test
    void createsAndParsesToken() {
        JwtService service = new JwtService("unit-test-secret-at-least-32-characters", 3600);

        CurrentUser user = service.parse(service.create(42L, "student"));

        assertThat(user.id()).isEqualTo(42L);
        assertThat(user.username()).isEqualTo("student");
    }
}