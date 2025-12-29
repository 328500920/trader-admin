package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.CommunityComment;
import com.trader.entity.CommunityPost;
import com.trader.service.CommunityService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/community")
@RequiredArgsConstructor
public class CommunityController {
    private final CommunityService communityService;

    @GetMapping("/post/list")
    public Result<PageResult<CommunityPost>> listPosts(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword) {
        return Result.success(communityService.listPosts(pageNum, pageSize, category, keyword));
    }

    @GetMapping("/post/{id}")
    public Result<CommunityPost> getPost(@PathVariable Long id) {
        return Result.success(communityService.getPost(id));
    }

    @PostMapping("/post")
    public Result<Void> createPost(@RequestBody CommunityPost post) {
        communityService.createPost(post);
        return Result.success();
    }

    @PutMapping("/post/{id}")
    public Result<Void> updatePost(@PathVariable Long id, @RequestBody CommunityPost post) {
        post.setId(id);
        communityService.updatePost(post);
        return Result.success();
    }

    @DeleteMapping("/post/{id}")
    public Result<Void> deletePost(@PathVariable Long id) {
        communityService.deletePost(id);
        return Result.success();
    }

    @PostMapping("/post/{id}/like")
    public Result<Void> likePost(@PathVariable Long id) {
        communityService.likePost(id);
        return Result.success();
    }

    @GetMapping("/comment/list")
    public Result<List<CommunityComment>> listComments(@RequestParam Long postId) {
        return Result.success(communityService.listComments(postId));
    }

    @PostMapping("/comment")
    public Result<Void> createComment(@RequestBody CommunityComment comment) {
        communityService.createComment(comment);
        return Result.success();
    }

    @DeleteMapping("/comment/{id}")
    public Result<Void> deleteComment(@PathVariable Long id) {
        communityService.deleteComment(id);
        return Result.success();
    }
}
