package com.campusmeow.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.campusmeow.api.forum.CommentRepository;
import com.campusmeow.api.forum.PostRepository;
import com.campusmeow.api.user.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class ApiIntegrationTest {
    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private UserRepository users;
    @Autowired
    private PostRepository posts;
    @Autowired
    private CommentRepository comments;

    @BeforeEach
    void cleanDatabases() {
        comments.deleteAll();
        posts.deleteAll();
        users.deleteAll();
    }

    @Test
    void registrationLoginProfileAndForumFlowUsesRealDatabases() throws Exception {
        String registerJson = """
            {"username":"student01","password":"password123","nickname":"Meow"}
            """;
        String registration = mockMvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON).content(registerJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.data.user.nickname").value("Meow"))
            .andReturn().getResponse().getContentAsString();
        JsonNode registrationJson = objectMapper.readTree(registration);
        String token = registrationJson.at("/data/accessToken").asText();

        mockMvc.perform(get("/api/v1/users/me").header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data.username").value("student01"));

        String postJson = """
            {"title":"First post","content":"Hello CampusMeow","imageUrls":[],"tags":["campus"]}
            """;
        mockMvc.perform(post("/api/v1/posts").header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON).content(postJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.data.title").value("First post"));

        mockMvc.perform(get("/api/v1/posts"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data.totalElements").value(1));
    }

    @Test
    void protectedEndpointRejectsAnonymousUser() throws Exception {
        mockMvc.perform(get("/api/v1/users/me"))
            .andExpect(status().isUnauthorized());
    }
}

