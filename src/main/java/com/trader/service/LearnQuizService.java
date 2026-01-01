package com.trader.service;

import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.LearnQuiz;
import com.trader.entity.LearnQuizRecord;
import com.trader.entity.LearnChapter;
import com.trader.mapper.LearnQuizMapper;
import com.trader.mapper.LearnQuizRecordMapper;
import com.trader.mapper.LearnChapterMapper;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 测验题库服务类
 */
@Service
@RequiredArgsConstructor
public class LearnQuizService {
    
    private final LearnQuizMapper quizMapper;
    private final LearnQuizRecordMapper recordMapper;
    private final LearnChapterMapper chapterMapper;
    
    /**
     * 根据章节ID获取题目列表
     */
    public List<LearnQuiz> listByChapter(Long chapterId) {
        return quizMapper.selectList(new LambdaQueryWrapper<LearnQuiz>()
                .eq(LearnQuiz::getChapterId, chapterId)
                .eq(LearnQuiz::getStatus, 1)
                .orderByAsc(LearnQuiz::getSortOrder));
    }
    
    /**
     * 获取章节测验（不含答案，用于答题）
     */
    public List<LearnQuiz> getQuizForTest(Long chapterId) {
        List<LearnQuiz> quizzes = listByChapter(chapterId);
        // 隐藏答案和解析
        quizzes.forEach(q -> {
            q.setAnswer(null);
            q.setExplanation(null);
        });
        return quizzes;
    }
    
    /**
     * 获取题目详情（含答案）
     */
    public LearnQuiz getQuiz(Long id) {
        LearnQuiz quiz = quizMapper.selectById(id);
        if (quiz != null) {
            LearnChapter chapter = chapterMapper.selectById(quiz.getChapterId());
            quiz.setChapter(chapter);
        }
        return quiz;
    }
    
    /**
     * 提交测验答案
     */
    @Transactional
    public Map<String, Object> submitQuiz(Long chapterId, List<Map<String, Object>> answers, Integer timeSpent) {
        Long userId = SecurityUtils.getUserId();
        List<LearnQuiz> quizzes = listByChapter(chapterId);
        
        int totalQuestions = quizzes.size();
        int correctCount = 0;
        int totalScore = 0;
        
        // 计算得分
        for (LearnQuiz quiz : quizzes) {
            for (Map<String, Object> ans : answers) {
                if (quiz.getId().equals(Long.valueOf(ans.get("quizId").toString()))) {
                    String userAnswer = ans.get("answer") != null ? ans.get("answer").toString() : "";
                    if (quiz.getAnswer().equalsIgnoreCase(userAnswer.trim())) {
                        correctCount++;
                        totalScore += quiz.getPoints() != null ? quiz.getPoints() : 10;
                        ans.put("correct", true);
                    } else {
                        ans.put("correct", false);
                    }
                    ans.put("correctAnswer", quiz.getAnswer());
                    ans.put("explanation", quiz.getExplanation());
                    break;
                }
            }
        }
        
        // 保存记录
        LearnQuizRecord record = new LearnQuizRecord();
        record.setUserId(userId);
        record.setChapterId(chapterId);
        record.setTotalQuestions(totalQuestions);
        record.setCorrectCount(correctCount);
        record.setScore(totalScore);
        record.setTimeSpent(timeSpent);
        record.setAnswers(JSONUtil.toJsonStr(answers));
        recordMapper.insert(record);
        
        // 返回结果
        Map<String, Object> result = new HashMap<>();
        result.put("totalQuestions", totalQuestions);
        result.put("correctCount", correctCount);
        result.put("score", totalScore);
        result.put("accuracy", totalQuestions > 0 ? (correctCount * 100 / totalQuestions) : 0);
        result.put("answers", answers);
        result.put("recordId", record.getId());
        
        return result;
    }
    
    /**
     * 获取用户测验记录
     */
    public PageResult<LearnQuizRecord> listRecords(int pageNum, int pageSize) {
        Long userId = SecurityUtils.getUserId();
        Page<LearnQuizRecord> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnQuizRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnQuizRecord::getUserId, userId)
               .orderByDesc(LearnQuizRecord::getCreateTime);
        
        Page<LearnQuizRecord> result = recordMapper.selectPage(page, wrapper);
        
        // 填充章节信息
        for (LearnQuizRecord r : result.getRecords()) {
            LearnChapter chapter = chapterMapper.selectById(r.getChapterId());
            r.setChapter(chapter);
        }
        
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
    
    /**
     * 获取用户某章节的最佳成绩
     */
    public LearnQuizRecord getBestRecord(Long chapterId) {
        Long userId = SecurityUtils.getUserId();
        return recordMapper.selectOne(new LambdaQueryWrapper<LearnQuizRecord>()
                .eq(LearnQuizRecord::getUserId, userId)
                .eq(LearnQuizRecord::getChapterId, chapterId)
                .orderByDesc(LearnQuizRecord::getScore)
                .last("LIMIT 1"));
    }
    
    /**
     * 获取章节测验统计
     */
    public Map<String, Object> getChapterQuizStats(Long chapterId) {
        Long userId = SecurityUtils.getUserId();
        
        int totalQuizzes = quizMapper.selectCount(new LambdaQueryWrapper<LearnQuiz>()
                .eq(LearnQuiz::getChapterId, chapterId)
                .eq(LearnQuiz::getStatus, 1)).intValue();
        
        int attemptCount = recordMapper.selectCount(new LambdaQueryWrapper<LearnQuizRecord>()
                .eq(LearnQuizRecord::getUserId, userId)
                .eq(LearnQuizRecord::getChapterId, chapterId)).intValue();
        
        LearnQuizRecord bestRecord = getBestRecord(chapterId);
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalQuizzes", totalQuizzes);
        stats.put("attemptCount", attemptCount);
        stats.put("bestScore", bestRecord != null ? bestRecord.getScore() : 0);
        stats.put("bestAccuracy", bestRecord != null && bestRecord.getTotalQuestions() > 0 
                ? (bestRecord.getCorrectCount() * 100 / bestRecord.getTotalQuestions()) : 0);
        
        return stats;
    }
    
    /**
     * 统计题目数量
     */
    public long countByDifficulty(Integer difficulty) {
        LambdaQueryWrapper<LearnQuiz> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnQuiz::getStatus, 1);
        if (difficulty != null) {
            wrapper.eq(LearnQuiz::getDifficulty, difficulty);
        }
        return quizMapper.selectCount(wrapper);
    }
    
    // ============ 管理员方法 ============
    
    public void createQuiz(LearnQuiz quiz) {
        quiz.setCreateBy(SecurityUtils.getUserId());
        quiz.setStatus(1);
        quizMapper.insert(quiz);
    }
    
    public void updateQuiz(LearnQuiz quiz) {
        quizMapper.updateById(quiz);
    }
    
    public void deleteQuiz(Long id) {
        quizMapper.deleteById(id);
    }
    
    public PageResult<LearnQuiz> listAllQuizzes(int pageNum, int pageSize, 
            Long chapterId, String questionType, Integer difficulty, Integer status) {
        Page<LearnQuiz> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnQuiz> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(LearnQuiz::getStatus, status);
        }
        if (chapterId != null) {
            wrapper.eq(LearnQuiz::getChapterId, chapterId);
        }
        if (StringUtils.hasText(questionType)) {
            wrapper.eq(LearnQuiz::getQuestionType, questionType);
        }
        if (difficulty != null) {
            wrapper.eq(LearnQuiz::getDifficulty, difficulty);
        }
        
        wrapper.orderByDesc(LearnQuiz::getCreateTime);
        
        Page<LearnQuiz> result = quizMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }
}
