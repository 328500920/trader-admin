package com.trader.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.Result;
import com.trader.entity.LearnWrongQuestion;
import com.trader.service.LearnWrongQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 错题本控制器
 */
@RestController
@RequestMapping("/learn/wrong-question")
public class LearnWrongQuestionController {
    
    @Autowired
    private LearnWrongQuestionService wrongQuestionService;
    
    /**
     * 获取错题列表
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getWrongQuestionList(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long chapterId,
            @RequestParam(required = false) Integer isMastered) {
        
        Page<LearnWrongQuestion> page = wrongQuestionService.getWrongQuestionList(
                userId, pageNum, pageSize, chapterId, isMastered);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", page.getRecords());
        result.put("total", page.getTotal());
        
        return Result.success(result);
    }
    
    /**
     * 获取错题统计
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getWrongQuestionStats(
            @RequestParam(defaultValue = "1") Long userId) {
        
        Map<String, Object> stats = wrongQuestionService.getWrongQuestionStats(userId);
        return Result.success(stats);
    }
    
    /**
     * 添加错题
     */
    @PostMapping("/add")
    public Result<Void> addWrongQuestion(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam Long quizId,
            @RequestParam(required = false) String userAnswer) {
        
        wrongQuestionService.addWrongQuestion(userId, quizId, userAnswer);
        return Result.success();
    }
    
    /**
     * 标记为已掌握
     */
    @PostMapping("/master")
    public Result<Void> markAsMastered(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam Long quizId) {
        
        wrongQuestionService.markAsMastered(userId, quizId);
        return Result.success();
    }
    
    /**
     * 取消已掌握标记
     */
    @PostMapping("/unmaster")
    public Result<Void> unmarkMastered(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam Long quizId) {
        
        wrongQuestionService.unmarkMastered(userId, quizId);
        return Result.success();
    }
    
    /**
     * 删除错题
     */
    @DeleteMapping("/remove")
    public Result<Void> removeWrongQuestion(
            @RequestParam(defaultValue = "1") Long userId,
            @RequestParam Long quizId) {
        
        wrongQuestionService.removeWrongQuestion(userId, quizId);
        return Result.success();
    }
}
