package com.campusmeow.api.forum;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CommentRepository extends MongoRepository<Comment, String> {
    Page<Comment> findByPostIdAndStatusOrderByCreatedAtDesc(String postId, String status, Pageable pageable);
    void deleteByPostId(String postId);
}

