package com.campusmeow.api.forum;

import com.campusmeow.api.common.api.PageResponse;
import com.campusmeow.api.common.exception.ApiException;
import com.campusmeow.api.forum.ForumDtos.CommentRequest;
import com.campusmeow.api.forum.ForumDtos.CommentResponse;
import com.campusmeow.api.forum.ForumDtos.PostRequest;
import com.campusmeow.api.forum.ForumDtos.PostResponse;
import com.campusmeow.api.user.UserService;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
public class ForumService {
    private final PostRepository posts;
    private final CommentRepository comments;
    private final UserService users;

    public ForumService(PostRepository posts, CommentRepository comments, UserService users) {
        this.posts = posts;
        this.comments = comments;
        this.users = users;
    }

    public PostResponse createPost(long userId, PostRequest request) {
        users.requireUser(userId);
        Post post = posts.save(new Post(userId, request.title(), request.content(),
            request.imageUrls(), request.tags()));
        return toResponse(post);
    }

    public PageResponse<PostResponse> listPosts(int page, int size) {
        Page<Post> result = posts.findByStatusOrderByCreatedAtDesc("PUBLISHED", pageRequest(page, size));
        return page(result.map(this::toResponse));
    }

    public PageResponse<PostResponse> listUserPosts(long userId, int page, int size) {
        Page<Post> result = posts.findByAuthorIdAndStatusOrderByCreatedAtDesc(
            userId, "PUBLISHED", pageRequest(page, size));
        return page(result.map(this::toResponse));
    }

    public PostResponse getPost(String id) {
        return toResponse(requirePost(id));
    }

    public PostResponse updatePost(long userId, String id, PostRequest request) {
        Post post = requirePost(id);
        requireOwner(userId, post.getAuthorId());
        post.update(request.title(), request.content(), request.imageUrls(), request.tags());
        return toResponse(posts.save(post));
    }

    public void deletePost(long userId, String id) {
        Post post = requirePost(id);
        requireOwner(userId, post.getAuthorId());
        comments.deleteByPostId(id);
        posts.delete(post);
    }

    public CommentResponse createComment(long userId, String postId, CommentRequest request) {
        requirePost(postId);
        users.requireUser(userId);
        return toResponse(comments.save(new Comment(postId, userId, request.content())));
    }

    public PageResponse<CommentResponse> listComments(String postId, int page, int size) {
        requirePost(postId);
        Page<Comment> result = comments.findByPostIdAndStatusOrderByCreatedAtDesc(
            postId, "VISIBLE", pageRequest(page, size));
        return page(result.map(this::toResponse));
    }

    public void deleteComment(long userId, String id) {
        Comment comment = comments.findById(id).orElseThrow(() ->
            new ApiException("COMMENT_NOT_FOUND", "Comment does not exist", HttpStatus.NOT_FOUND));
        requireOwner(userId, comment.getAuthorId());
        comments.delete(comment);
    }

    private Post requirePost(String id) {
        return posts.findById(id).filter(post -> "PUBLISHED".equals(post.getStatus())).orElseThrow(() ->
            new ApiException("POST_NOT_FOUND", "Post does not exist", HttpStatus.NOT_FOUND));
    }

    private void requireOwner(long actorId, long ownerId) {
        if (actorId != ownerId) {
            throw new ApiException("FORBIDDEN", "Only the owner can perform this operation", HttpStatus.FORBIDDEN);
        }
    }

    private PostResponse toResponse(Post post) {
        return PostResponse.from(post, users.summary(post.getAuthorId()));
    }

    private CommentResponse toResponse(Comment comment) {
        return CommentResponse.from(comment, users.summary(comment.getAuthorId()));
    }

    private PageRequest pageRequest(int page, int size) {
        return PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    private <T> PageResponse<T> page(Page<T> source) {
        List<T> items = source.getContent();
        return new PageResponse<>(items, source.getNumber(), source.getSize(),
            source.getTotalElements(), source.getTotalPages());
    }
}

