package com.trader.controller;

import com.trader.annotation.OperationLog;
import com.trader.annotation.OperationLog.OperationType;
import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.LearnVideoCourse;
import com.trader.security.RequireRole;
import com.trader.service.LearnVideoCourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/learn/video")
@RequiredArgsConstructor
public class LearnVideoCourseController {
    
    private final LearnVideoCourseService videoCourseService;

    /**
     * 学员获取视频列表
     */
    @GetMapping("/list")
    public Result<PageResult<LearnVideoCourse>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "12") int pageSize,
            @RequestParam(required = false) String category) {
        return Result.success(videoCourseService.list(pageNum, pageSize, category));
    }

    /**
     * 获取视频详情
     */
    @GetMapping("/{id}")
    public Result<LearnVideoCourse> getById(@PathVariable Long id) {
        return Result.success(videoCourseService.getById(id));
    }

    /**
     * 获取所有分类
     */
    @GetMapping("/categories")
    public Result<List<String>> listCategories() {
        return Result.success(videoCourseService.listCategories());
    }

    /**
     * 更新观看进度
     */
    @PostMapping("/{id}/progress")
    public Result<Void> updateProgress(
            @PathVariable Long id,
            @RequestBody Map<String, Object> params) {
        Integer progress = (Integer) params.get("progress");
        Boolean completed = (Boolean) params.get("completed");
        videoCourseService.updateProgress(id, progress, completed);
        return Result.success();
    }

    /**
     * 获取用户观看统计
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getUserStats() {
        return Result.success(videoCourseService.getUserStats());
    }

    // ========== 管理员接口 ==========

    /**
     * 管理员获取视频列表
     */
    @GetMapping("/admin/list")
    @RequireRole({"admin", "teacher"})
    public Result<PageResult<LearnVideoCourse>> listAll(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Integer status) {
        return Result.success(videoCourseService.listAll(pageNum, pageSize, category, status));
    }

    /**
     * 创建视频课程
     */
    @PostMapping
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "视频课程", type = OperationType.CREATE, description = "创建视频课程")
    public Result<Void> create(@RequestBody LearnVideoCourse video) {
        videoCourseService.create(video);
        return Result.success();
    }

    /**
     * 更新视频课程
     */
    @PutMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "视频课程", type = OperationType.UPDATE, description = "更新视频课程")
    public Result<Void> update(@PathVariable Long id, @RequestBody LearnVideoCourse video) {
        video.setId(id);
        videoCourseService.update(video);
        return Result.success();
    }

    /**
     * 删除视频课程
     */
    @DeleteMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "视频课程", type = OperationType.DELETE, description = "删除视频课程")
    public Result<Void> delete(@PathVariable Long id) {
        videoCourseService.delete(id);
        return Result.success();
    }

    /**
     * 上传视频
     */
    @PostMapping("/upload/video")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "视频课程", type = OperationType.IMPORT, description = "上传视频")
    public Result<Map<String, Object>> uploadVideo(@RequestParam("file") MultipartFile file) {
        try {
            return Result.success(videoCourseService.uploadVideo(file));
        } catch (Exception e) {
            return Result.error("上传失败: " + e.getMessage());
        }
    }

    /**
     * 上传封面
     */
    @PostMapping("/upload/cover")
    @RequireRole({"admin", "teacher"})
    public Result<Map<String, Object>> uploadCover(@RequestParam("file") MultipartFile file) {
        try {
            return Result.success(videoCourseService.uploadCover(file));
        } catch (Exception e) {
            return Result.error("上传失败: " + e.getMessage());
        }
    }
}
