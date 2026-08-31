package com.campusmeow.api.forum;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("posts")
public class Post {
    @Id
    private String id;
    @Indexed
    private long authorId;
    private String title;
    private String content;
    private List<String> imageUrls;
    private List<String> tags;
    private String status;
    @Indexed
    private Instant createdAt;
    private Instant updatedAt;

    public Post(long authorId, String title, String content, List<String> imageUrls, List<String> tags) {
        this.authorId = authorId;
        this.title = title;
        this.content = content;
        this.imageUrls = new ArrayList<>(imageUrls);
        this.tags = new ArrayList<>(tags);
        this.status = "PUBLISHED";
        this.createdAt = Instant.now();
        this.updatedAt = createdAt;
    }

    public void update(String title, String content, List<String> imageUrls, List<String> tags) {
        this.title = title;
        this.content = content;
        this.imageUrls = new ArrayList<>(imageUrls);
        this.tags = new ArrayList<>(tags);
        this.updatedAt = Instant.now();
    }

    public String getId() { return id; }
    public long getAuthorId() { return authorId; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public List<String> getImageUrls() { return List.copyOf(imageUrls); }
    public List<String> getTags() { return List.copyOf(tags); }
    public String getStatus() { return status; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
}

