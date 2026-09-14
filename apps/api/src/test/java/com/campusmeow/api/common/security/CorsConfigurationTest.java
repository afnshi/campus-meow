package com.campusmeow.api.common.security;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.web.cors.DefaultCorsProcessor;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class CorsConfigurationTest {
    @Test
    void allowsProductionRegistrationBehindHttpProxy() throws Exception {
        var request = request("POST", "https://www.afnshi.cn");
        var response = new MockHttpServletResponse();
        assertTrue(process(request, response));
        assertEquals("https://www.afnshi.cn", response.getHeader("Access-Control-Allow-Origin"));
    }

    @Test
    void allowsProductionPreflight() throws Exception {
        var request = request("OPTIONS", "https://www.afnshi.cn");
        request.addHeader("Access-Control-Request-Method", "POST");
        request.addHeader("Access-Control-Request-Headers", "content-type");
        assertTrue(process(request, new MockHttpServletResponse()));
    }

    @Test
    void rejectsUntrustedOrigin() throws Exception {
        var response = new MockHttpServletResponse();
        assertFalse(process(request("POST", "https://untrusted.example"), response));
        assertEquals(403, response.getStatus());
    }

    private MockHttpServletRequest request(String method, String origin) {
        var request = new MockHttpServletRequest(method, "/api/v1/auth/register");
        request.setScheme("http");
        request.setServerName("www.afnshi.cn");
        request.setServerPort(80);
        request.addHeader("Origin", origin);
        return request;
    }

    private boolean process(MockHttpServletRequest request, MockHttpServletResponse response) throws Exception {
        var source = new SecurityConfig(null, null).corsConfigurationSource();
        return new DefaultCorsProcessor().processRequest(source.getCorsConfiguration(request), request, response);
    }
}
