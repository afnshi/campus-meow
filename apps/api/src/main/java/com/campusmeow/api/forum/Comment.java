package com.campusmeow.api.forum;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("comments")
@CompoundIndex(name = "post_created_idx", def = "{'postId': 1, 'createdAt': -1}")
public class Comment {
    @Id
    private String id;
    private String postId;
    @Indexed
    private long authorId;
    private String content;
    private String status;
    private Instant createdAt;

    public Comment(String postId, long authorId, String content) {
        this.postId = postId;
        this.authorId = authorId;
        this.content = content;
        this.status = "VISIBLE";
        this.createdAt = Instant.now();
    }

    public String getId() { return id; }
    public String getPostId() { return postId; }
    public long getAuthorId() { return authorId; }
    public String getContent() { return content; }
    public String getStatus() { return status; }
    public Instant getCreatedAt() { return createdAt; }
}

