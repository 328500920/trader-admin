package com.trader.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.Result;
import com.trader.entity.UserFavorite;
import com.trader.service.UserFavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户收藏控制器
 */
@RestController
@RequestMapping("/user/favorite")
public class UserFavoriteController {
    
    @Autowired
    private UserFavoriteService favoriteService;
    
    /**
     * 获取收藏列表
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getFavoriteList(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam(required = false) String targetType,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        
        Page<UserFavorite> page = favoriteService.getFavoriteList(userId, targetType, pageNum, pageSize);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", page.getRecords());
        result.put("total", page.getTotal());
        
        return Result.success(result);
    }
    
    /**
     * 获取收藏统计
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getFavoriteStats(
            @RequestParam(defaultValue = "1") Long userId) {
        
        Map<String, Object> stats = favoriteService.getFavoriteStats(userId);
        return Result.success(stats);
    }
    
    /**
     * 添加收藏
     */
    @PostMapping("/add")
    public Result<Boolean> addFavorite(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam String targetType,
            @RequestParam Long targetId) {
        
        boolean success = favoriteService.addFavorite(userId, targetType, targetId);
        return Result.success(success);
    }
    
    /**
     * 取消收藏
     */
    @PostMapping("/remove")
    public Result<Boolean> removeFavorite(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam String targetType,
            @RequestParam Long targetId) {
        
        boolean success = favoriteService.removeFavorite(userId, targetType, targetId);
        return Result.success(success);
    }
    
    /**
     * 检查是否已收藏
     */
    @GetMapping("/check")
    public Result<Boolean> checkFavorite(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam String targetType,
            @RequestParam Long targetId) {
        
        boolean isFavorited = favoriteService.isFavorited(userId, targetType, targetId);
        return Result.success(isFavorited);
    }
    
    /**
     * 切换收藏状态
     */
    @PostMapping("/toggle")
    public Result<Boolean> toggleFavorite(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam String targetType,
            @RequestParam Long targetId) {
        
        boolean isFavorited = favoriteService.isFavorited(userId, targetType, targetId);
        if (isFavorited) {
            favoriteService.removeFavorite(userId, targetType, targetId);
            return Result.success(false); // 返回新状态：未收藏
        } else {
            favoriteService.addFavorite(userId, targetType, targetId);
            return Result.success(true); // 返回新状态：已收藏
        }
    }
}
