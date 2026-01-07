package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.BusinessException;
import com.trader.common.PageResult;
import com.trader.entity.LearnVideoCourse;
import com.trader.entity.LearnVideoProgress;
import com.trader.mapper.LearnVideoCourseMapper;
import com.trader.mapper.LearnVideoProgressMapper;
import com.trader.utils.SecurityUtils;
import cn.hutool.core.util.StrUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class LearnVideoCourseService {
    
    private final LearnVideoCourseMapper videoCourseMapper;
    private final LearnVideoProgressMapper videoProgressMapper;
    
    @Value("${file.upload-path}")
    private String uploadBasePath;
    
    // 视频存储子目录
    private static final String VIDEO_DIR = "videos/";
    private static final String COVER_DIR = "covers/";
    
    // 支持的视频格式
    private static final Set<String> SUPPORTED_VIDEO_FORMATS = new HashSet<>(
        Arrays.asList("mp4", "webm", "avi", "mov", "mkv", "flv", "wmv")
    );
    
    // 最大文件大小 1GB
    private static final long MAX_FILE_SIZE = 1024L * 1024 * 1024;

    /**
     * 学员获取视频列表（只返回已发布的）
     */
    public PageResult<LearnVideoCourse> list(int pageNum, int pageSize, String category) {
        Page<LearnVideoCourse> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnVideoCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnVideoCourse::getStatus, 1);
        if (StrUtil.isNotBlank(category)) {
            wrapper.eq(LearnVideoCourse::getCategory, category);
        }
        wrapper.orderByAsc(LearnVideoCourse::getSortOrder)
               .orderByDesc(LearnVideoCourse::getCreateTime);
        
        Page<LearnVideoCourse> result = videoCourseMapper.selectPage(page, wrapper);
        
        // 填充用户观看进度
        Long userId = SecurityUtils.getUserId();
        if (userId != null) {
            result.getRecords().forEach(video -> {
                LearnVideoProgress progress = videoProgressMapper.findByUserAndVideo(userId, video.getId());
                if (progress != null) {
                    video.setUserProgress(progress.getProgress());
                    video.setIsCompleted(progress.getIsCompleted() == 1);
                }
            });
        }
        
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    /**
     * 管理员获取视频列表（包括草稿）
     */
    public PageResult<LearnVideoCourse> listAll(int pageNum, int pageSize, String category, Integer status) {
        Page<LearnVideoCourse> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnVideoCourse> wrapper = new LambdaQueryWrapper<>();
        if (StrUtil.isNotBlank(category)) {
            wrapper.eq(LearnVideoCourse::getCategory, category);
        }
        if (status != null) {
            wrapper.eq(LearnVideoCourse::getStatus, status);
        }
        wrapper.orderByAsc(LearnVideoCourse::getSortOrder)
               .orderByDesc(LearnVideoCourse::getCreateTime);
        
        Page<LearnVideoCourse> result = videoCourseMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    /**
     * 获取视频详情
     */
    public LearnVideoCourse getById(Long id) {
        LearnVideoCourse video = videoCourseMapper.selectById(id);
        if (video == null) {
            throw new BusinessException("视频不存在");
        }
        
        // 填充用户观看进度
        Long userId = SecurityUtils.getUserId();
        if (userId != null) {
            LearnVideoProgress progress = videoProgressMapper.findByUserAndVideo(userId, id);
            if (progress != null) {
                video.setUserProgress(progress.getProgress());
                video.setIsCompleted(progress.getIsCompleted() == 1);
            }
        }
        
        return video;
    }

    /**
     * 获取所有分类
     */
    public List<String> listCategories() {
        LambdaQueryWrapper<LearnVideoCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.select(LearnVideoCourse::getCategory)
               .eq(LearnVideoCourse::getStatus, 1)
               .isNotNull(LearnVideoCourse::getCategory)
               .groupBy(LearnVideoCourse::getCategory);
        
        List<LearnVideoCourse> list = videoCourseMapper.selectList(wrapper);
        List<String> categories = new ArrayList<>();
        list.forEach(v -> {
            if (StrUtil.isNotBlank(v.getCategory())) {
                categories.add(v.getCategory());
            }
        });
        return categories;
    }

    /**
     * 创建视频课程
     */
    public void create(LearnVideoCourse video) {
        video.setViewCount(0);
        videoCourseMapper.insert(video);
    }

    /**
     * 更新视频课程
     */
    public void update(LearnVideoCourse video) {
        videoCourseMapper.updateById(video);
    }

    /**
     * 删除视频课程
     */
    @Transactional
    public void delete(Long id) {
        LearnVideoCourse video = videoCourseMapper.selectById(id);
        if (video != null) {
            // 删除视频文件
            if (StrUtil.isNotBlank(video.getVideoUrl())) {
                deleteFile(video.getVideoUrl());
            }
            // 删除封面文件
            if (StrUtil.isNotBlank(video.getCoverUrl())) {
                deleteFile(video.getCoverUrl());
            }
            // 删除观看记录
            LambdaQueryWrapper<LearnVideoProgress> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(LearnVideoProgress::getVideoId, id);
            videoProgressMapper.delete(wrapper);
            // 删除视频记录
            videoCourseMapper.deleteById(id);
        }
    }

    /**
     * 上传视频
     */
    public Map<String, Object> uploadVideo(MultipartFile file) throws IOException {
        // 检查文件大小
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new BusinessException("视频文件不能超过1GB");
        }
        
        // 检查文件格式
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename).toLowerCase();
        if (!SUPPORTED_VIDEO_FORMATS.contains(extension)) {
            throw new BusinessException("不支持的视频格式，支持: " + String.join(", ", SUPPORTED_VIDEO_FORMATS));
        }
        
        // 生成文件名
        String filename = UUID.randomUUID().toString() + "." + extension;
        String relativePath = VIDEO_DIR + filename;
        
        // 保存文件
        saveFile(file, relativePath);
        
        Map<String, Object> result = new HashMap<>();
        result.put("url", "/uploads/" + relativePath);
        result.put("filename", filename);
        result.put("size", file.getSize());
        return result;
    }

    /**
     * 上传封面
     */
    public Map<String, Object> uploadCover(MultipartFile file) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename).toLowerCase();
        
        // 生成文件名
        String filename = UUID.randomUUID().toString() + "." + extension;
        String relativePath = COVER_DIR + filename;
        
        // 保存文件
        saveFile(file, relativePath);
        
        Map<String, Object> result = new HashMap<>();
        result.put("url", "/uploads/" + relativePath);
        result.put("filename", filename);
        return result;
    }

    /**
     * 更新观看进度
     */
    public void updateProgress(Long videoId, Integer progress, Boolean completed) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return;
        }
        
        LearnVideoProgress videoProgress = videoProgressMapper.findByUserAndVideo(userId, videoId);
        
        if (videoProgress == null) {
            // 新建记录
            videoProgress = new LearnVideoProgress();
            videoProgress.setUserId(userId);
            videoProgress.setVideoId(videoId);
            videoProgress.setProgress(progress);
            videoProgress.setIsCompleted(completed != null && completed ? 1 : 0);
            videoProgress.setWatchCount(1);
            videoProgress.setLastWatchTime(LocalDateTime.now());
            videoProgressMapper.insert(videoProgress);
            
            // 增加观看次数
            videoCourseMapper.incrementViewCount(videoId);
        } else {
            // 更新记录
            videoProgress.setProgress(progress);
            if (completed != null && completed) {
                videoProgress.setIsCompleted(1);
            }
            videoProgress.setLastWatchTime(LocalDateTime.now());
            videoProgressMapper.updateById(videoProgress);
        }
    }

    /**
     * 获取用户观看统计
     */
    public Map<String, Object> getUserStats() {
        Long userId = SecurityUtils.getUserId();
        Map<String, Object> stats = new HashMap<>();
        
        if (userId == null) {
            stats.put("watchedCount", 0);
            stats.put("completedCount", 0);
            stats.put("totalWatchTime", 0);
            return stats;
        }
        
        LambdaQueryWrapper<LearnVideoProgress> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnVideoProgress::getUserId, userId);
        List<LearnVideoProgress> progressList = videoProgressMapper.selectList(wrapper);
        
        int watchedCount = progressList.size();
        int completedCount = (int) progressList.stream().filter(p -> p.getIsCompleted() == 1).count();
        int totalWatchTime = progressList.stream().mapToInt(LearnVideoProgress::getProgress).sum();
        
        stats.put("watchedCount", watchedCount);
        stats.put("completedCount", completedCount);
        stats.put("totalWatchTime", totalWatchTime);
        
        return stats;
    }

    // ========== 私有方法 ==========
    
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }
    
    private void saveFile(MultipartFile file, String relativePath) throws IOException {
        // 使用配置的绝对路径
        File dest = new File(uploadBasePath + relativePath);
        File parentDir = dest.getParentFile();
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }
        file.transferTo(dest);
    }
    
    private void deleteFile(String url) {
        // url 格式: /uploads/videos/xxx.mp4
        if (url != null && url.startsWith("/uploads/")) {
            String relativePath = url.substring("/uploads/".length());
            File file = new File(uploadBasePath + relativePath);
            if (file.exists()) {
                file.delete();
            }
        }
    }
}
