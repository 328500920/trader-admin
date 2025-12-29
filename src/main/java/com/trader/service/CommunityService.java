package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.*;
import com.trader.mapper.*;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommunityService {
    private final CommunityPostMapper postMapper;
    private final CommunityCommentMapper commentMapper;
    private final CommunityLikeMapper likeMapper;
    private final SysUserMapper userMapper;

    public PageResult<CommunityPost> listPosts(int pageNum, int pageSize, String category, String keyword) {
        Page<CommunityPost> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<CommunityPost> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CommunityPost::getStatus, 1);
        if (StrUtil.isNotBlank(category)) wrapper.eq(CommunityPost::getCategory, category);
        if (StrUtil.isNotBlank(keyword)) wrapper.like(CommunityPost::getTitle, keyword);
        wrapper.orderByDesc(CommunityPost::getIsTop).orderByDesc(CommunityPost::getCreateTime);
        Page<CommunityPost> result = postMapper.selectPage(page, wrapper);
        Long userId = SecurityUtils.getUserId();
        for (CommunityPost post : result.getRecords()) {
            SysUser author = userMapper.selectById(post.getUserId());
            if (author != null) {
                post.setAuthorName(author.getNickname() != null ? author.getNickname() : author.getUsername());
                post.setAuthorAvatar(author.getAvatar());
            }
            post.setIsLiked(likeMapper.selectCount(new LambdaQueryWrapper<CommunityLike>()
                    .eq(CommunityLike::getUserId, userId).eq(CommunityLike::getTargetType, 1)
                    .eq(CommunityLike::getTargetId, post.getId())) > 0);
        }
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    public CommunityPost getPost(Long id) {
        CommunityPost post = postMapper.selectById(id);
        if (post != null) {
            post.setViewCount(post.getViewCount() + 1);
            postMapper.updateById(post);
            SysUser author = userMapper.selectById(post.getUserId());
            if (author != null) {
                post.setAuthorName(author.getNickname() != null ? author.getNickname() : author.getUsername());
                post.setAuthorAvatar(author.getAvatar());
            }
            Long userId = SecurityUtils.getUserId();
            post.setIsLiked(likeMapper.selectCount(new LambdaQueryWrapper<CommunityLike>()
                    .eq(CommunityLike::getUserId, userId).eq(CommunityLike::getTargetType, 1)
                    .eq(CommunityLike::getTargetId, id)) > 0);
        }
        return post;
    }

    public void createPost(CommunityPost post) {
        post.setUserId(SecurityUtils.getUserId());
        post.setViewCount(0);
        post.setLikeCount(0);
        post.setCommentCount(0);
        post.setIsTop(0);
        post.setStatus(1);
        postMapper.insert(post);
    }

    public void updatePost(CommunityPost post) {
        postMapper.updateById(post);
    }

    public void deletePost(Long id) {
        postMapper.deleteById(id);
        commentMapper.delete(new LambdaQueryWrapper<CommunityComment>().eq(CommunityComment::getPostId, id));
    }

    public void likePost(Long postId) {
        Long userId = SecurityUtils.getUserId();
        CommunityLike existing = likeMapper.selectOne(new LambdaQueryWrapper<CommunityLike>()
                .eq(CommunityLike::getUserId, userId).eq(CommunityLike::getTargetType, 1).eq(CommunityLike::getTargetId, postId));
        CommunityPost post = postMapper.selectById(postId);
        if (existing != null) {
            likeMapper.deleteById(existing.getId());
            post.setLikeCount(Math.max(0, post.getLikeCount() - 1));
        } else {
            CommunityLike like = new CommunityLike();
            like.setUserId(userId);
            like.setTargetType(1);
            like.setTargetId(postId);
            likeMapper.insert(like);
            post.setLikeCount(post.getLikeCount() + 1);
        }
        postMapper.updateById(post);
    }

    public List<CommunityComment> listComments(Long postId) {
        List<CommunityComment> comments = commentMapper.selectList(new LambdaQueryWrapper<CommunityComment>()
                .eq(CommunityComment::getPostId, postId).eq(CommunityComment::getParentId, 0)
                .eq(CommunityComment::getStatus, 1).orderByAsc(CommunityComment::getCreateTime));
        for (CommunityComment comment : comments) {
            fillCommentAuthor(comment);
            List<CommunityComment> replies = commentMapper.selectList(new LambdaQueryWrapper<CommunityComment>()
                    .eq(CommunityComment::getParentId, comment.getId()).eq(CommunityComment::getStatus, 1));
            replies.forEach(this::fillCommentAuthor);
            comment.setReplies(replies);
        }
        return comments;
    }

    private void fillCommentAuthor(CommunityComment comment) {
        SysUser author = userMapper.selectById(comment.getUserId());
        if (author != null) {
            comment.setAuthorName(author.getNickname() != null ? author.getNickname() : author.getUsername());
            comment.setAuthorAvatar(author.getAvatar());
        }
    }

    public void createComment(CommunityComment comment) {
        comment.setUserId(SecurityUtils.getUserId());
        comment.setLikeCount(0);
        comment.setStatus(1);
        commentMapper.insert(comment);
        CommunityPost post = postMapper.selectById(comment.getPostId());
        post.setCommentCount(post.getCommentCount() + 1);
        postMapper.updateById(post);
    }

    public void deleteComment(Long id) {
        CommunityComment comment = commentMapper.selectById(id);
        if (comment != null) {
            commentMapper.deleteById(id);
            CommunityPost post = postMapper.selectById(comment.getPostId());
            post.setCommentCount(Math.max(0, post.getCommentCount() - 1));
            postMapper.updateById(post);
        }
    }
}
