package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.LearnQuiz;
import com.trader.entity.LearnQuizRecord;
import com.trader.security.RequireRole;
import com.trader.service.LearnQuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 测验题库控制器
 */
@RestController
@RequestMapping("/learn/quiz")
@RequiredArgsConstructor
public class LearnQuizController {
    
    private final LearnQuizService quizService;
    
    /**
     * 获取章节测验题目（用于答题，不含答案）
     */
    @GetMapping("/chapter/{chapterId}")
    public Result<List<LearnQuiz>> getQuizForTest(@PathVariable Long chapterId) {
        return Result.success(quizService.getQuizForTest(chapterId));
    }
    
    /**
     * 获取章节所有题目（含答案，用于复习）
     */
    @GetMapping("/chapter/{chapterId}/all")
    public Result<List<LearnQuiz>> listByChapter(@PathVariable Long chapterId) {
        return Result.success(quizService.listByChapter(chapterId));
    }
    
    /**
     * 获取题目详情
     */
    @GetMapping("/{id}")
    public Result<LearnQuiz> getQuiz(@PathVariable Long id) {
        return Result.success(quizService.getQuiz(id));
    }
    
    /**
     * 提交测验答案
     */
    @PostMapping("/submit")
    public Result<Map<String, Object>> submitQuiz(@RequestBody Map<String, Object> params) {
        Long chapterId = Long.valueOf(params.get("chapterId").toString());
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> answers = (List<Map<String, Object>>) params.get("answers");
        Integer timeSpent = params.get("timeSpent") != null 
                ? Integer.valueOf(params.get("timeSpent").toString()) : null;
        
        return Result.success(quizService.submitQuiz(chapterId, answers, timeSpent));
    }
    
    /**
     * 获取用户测验记录
     */
    @GetMapping("/record/list")
    public Result<PageResult<LearnQuizRecord>> listRecords(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(quizService.listRecords(pageNum, pageSize));
    }
    
    /**
     * 获取用户某章节的最佳成绩
     */
    @GetMapping("/record/best/{chapterId}")
    public Result<LearnQuizRecord> getBestRecord(@PathVariable Long chapterId) {
        return Result.success(quizService.getBestRecord(chapterId));
    }
    
    /**
     * 获取章节测验统计
     */
    @GetMapping("/stats/{chapterId}")
    public Result<Map<String, Object>> getChapterQuizStats(@PathVariable Long chapterId) {
        return Result.success(quizService.getChapterQuizStats(chapterId));
    }
    
    /**
     * 获取题库统计信息
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", quizService.countByDifficulty(null));
        stats.put("basic", quizService.countByDifficulty(1));
        stats.put("intermediate", quizService.countByDifficulty(2));
        stats.put("advanced", quizService.countByDifficulty(3));
        return Result.success(stats);
    }
    
    // ============ 管理员和讲师接口 ============
    
    @GetMapping("/admin/list")
    @RequireRole({"admin", "teacher"})
    public Result<PageResult<LearnQuiz>> listAllQuizzes(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Long chapterId,
            @RequestParam(required = false) String questionType,
            @RequestParam(required = false) Integer difficulty,
            @RequestParam(required = false) Integer status) {
        return Result.success(quizService.listAllQuizzes(pageNum, pageSize, 
                chapterId, questionType, difficulty, status));
    }
    
    @PostMapping
    @RequireRole({"admin", "teacher"})
    public Result<Void> createQuiz(@RequestBody LearnQuiz quiz) {
        quizService.createQuiz(quiz);
        return Result.success();
    }
    
    @PutMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> updateQuiz(@PathVariable Long id, @RequestBody LearnQuiz quiz) {
        quiz.setId(id);
        quizService.updateQuiz(quiz);
        return Result.success();
    }
    
    @DeleteMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> deleteQuiz(@PathVariable Long id) {
        quizService.deleteQuiz(id);
        return Result.success();
    }
}
