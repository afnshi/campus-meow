package com.campusmeow.api.forum;

import com.campusmeow.api.user.UserDtos.UserSummary;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.util.List;

public final class ForumDtos {
    private ForumDtos() {
    }

    public record PostRequest(
        @NotBlank @Size(max = 100) String title,
        @NotBlank @Size(max = 5000) String content,
        @Size(max = 9) List<@Size(max = 500) String> imageUrls,
        @Size(max = 10) List<@Size(max = 30) String> tags
    ) {
        public PostRequest {
            imageUrls = imageUrls == null ? List.of() : List.copyOf(imageUrls);
            tags = tags == null ? List.of() : List.copyOf(tags);
        }
    }

    public record CommentRequest(@NotBlank @Size(max = 500) String content) {
    }

    public record PostResponse(String id, UserSummary author, String title, String content,
                               List<String> imageUrls, List<String> tags, Instant createdAt, Instant updatedAt) {
        public static PostResponse from(Post post, UserSummary author) {
            return new PostResponse(post.getId(), author, post.getTitle(), post.getContent(),
                post.getImageUrls(), post.getTags(), post.getCreatedAt(), post.getUpdatedAt());
        }
    }

    public record CommentResponse(String id, String postId, UserSummary author, String content, Instant createdAt) {
        public static CommentResponse from(Comment comment, UserSummary author) {
            return new CommentResponse(comment.getId(), comment.getPostId(), author,
                comment.getContent(), comment.getCreatedAt());
        }
    }
}

