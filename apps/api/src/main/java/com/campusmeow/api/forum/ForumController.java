package com.campusmeow.api.forum;

import com.campusmeow.api.common.api.ApiResponse;
import com.campusmeow.api.common.api.PageResponse;
import com.campusmeow.api.common.security.CurrentUser;
import com.campusmeow.api.forum.ForumDtos.CommentRequest;
import com.campusmeow.api.forum.ForumDtos.CommentResponse;
import com.campusmeow.api.forum.ForumDtos.PostRequest;
import com.campusmeow.api.forum.ForumDtos.PostResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/v1")
public class ForumController {
    private final ForumService forumService;

    public ForumController(ForumService forumService) {
        this.forumService = forumService;
    }

    @PostMapping("/posts")
    @ResponseStatus(HttpStatus.CREATED)
    ApiResponse<PostResponse> createPost(CurrentUser user, @Valid @RequestBody PostRequest request) {
        return ApiResponse.success(forumService.createPost(user.id(), request));
    }

    @GetMapping("/posts")
    ApiResponse<PageResponse<PostResponse>> listPosts(
        @RequestParam(defaultValue = "0") @Min(0) int page,
        @RequestParam(defaultValue = "20") @Min(1) @Max(50) int size) {
        return ApiResponse.success(forumService.listPosts(page, size));
    }

    @GetMapping("/posts/{id}")
    ApiResponse<PostResponse> getPost(@PathVariable String id) {
        return ApiResponse.success(forumService.getPost(id));
    }

    @PutMapping("/posts/{id}")
    ApiResponse<PostResponse> updatePost(CurrentUser user, @PathVariable String id,
                                          @Valid @RequestBody PostRequest request) {
        return ApiResponse.success(forumService.updatePost(user.id(), id, request));
    }

    @DeleteMapping("/posts/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    void deletePost(CurrentUser user, @PathVariable String id) {
        forumService.deletePost(user.id(), id);
    }

    @GetMapping("/users/me/posts")
    ApiResponse<PageResponse<PostResponse>> myPosts(
        CurrentUser user,
        @RequestParam(defaultValue = "0") @Min(0) int page,
        @RequestParam(defaultValue = "20") @Min(1) @Max(50) int size) {
        return ApiResponse.success(forumService.listUserPosts(user.id(), page, size));
    }

    @PostMapping("/posts/{postId}/comments")
    @ResponseStatus(HttpStatus.CREATED)
    ApiResponse<CommentResponse> createComment(CurrentUser user, @PathVariable String postId,
                                                @Valid @RequestBody CommentRequest request) {
        return ApiResponse.success(forumService.createComment(user.id(), postId, request));
    }

    @GetMapping("/posts/{postId}/comments")
    ApiResponse<PageResponse<CommentResponse>> listComments(
        @PathVariable String postId,
        @RequestParam(defaultValue = "0") @Min(0) int page,
        @RequestParam(defaultValue = "20") @Min(1) @Max(50) int size) {
        return ApiResponse.success(forumService.listComments(postId, page, size));
    }

    @DeleteMapping("/comments/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    void deleteComment(CurrentUser user, @PathVariable String id) {
        forumService.deleteComment(user.id(), id);
    }
}

