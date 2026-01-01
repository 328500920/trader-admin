package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.trader.entity.LearnQuiz;
import com.trader.entity.LearnWrongQuestion;
import com.trader.mapper.LearnQuizMapper;
import com.trader.mapper.LearnWrongQuestionMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 错题本服务
 */
@Service
@RequiredArgsConstructor
public class LearnWrongQuestionService extends ServiceImpl<LearnWrongQuestionMapper, LearnWrongQuestion> {
    
    private final LearnQuizMapper quizMapper;
    
    /**
     * 分页获取错题列表
     */
    public Page<LearnWrongQuestion> getWrongQuestionList(Long userId, Integer pageNum, Integer pageSize, 
                                                          Long chapterId, Integer isMastered) {
        Page<LearnWrongQuestion> page = new Page<>(pageNum, pageSize);
        
        LambdaQueryWrapper<LearnWrongQuestion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnWrongQuestion::getUserId, userId);
        
        if (isMastered != null) {
            wrapper.eq(LearnWrongQuestion::getIsMastered, isMastered);
        }
        
        wrapper.orderByDesc(LearnWrongQuestion::getLastWrongTime);
        
        Page<LearnWrongQuestion> result = page(page, wrapper);
        
        // 填充题目信息
        List<Long> quizIds = result.getRecords().stream()
                .map(LearnWrongQuestion::getQuizId)
                .collect(Collectors.toList());
        
        if (!quizIds.isEmpty()) {
            List<LearnQuiz> quizzes = quizMapper.selectBatchIds(quizIds);
            Map<Long, LearnQuiz> quizMap = quizzes.stream()
                    .collect(Collectors.toMap(LearnQuiz::getId, q -> q));
            
            // 如果指定了章节筛选
            if (chapterId != null) {
                result.setRecords(result.getRecords().stream()
                        .filter(wq -> {
                            LearnQuiz quiz = quizMap.get(wq.getQuizId());
                            return quiz != null && chapterId.equals(quiz.getChapterId());
                        })
                        .collect(Collectors.toList()));
            }
            
            result.getRecords().forEach(wq -> wq.setQuiz(quizMap.get(wq.getQuizId())));
        }
        
        return result;
    }
    
    /**
     * 添加错题
     */
    public void addWrongQuestion(Long userId, Long quizId, String userAnswer) {
        LambdaQueryWrapper<LearnWrongQuestion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnWrongQuestion::getUserId, userId)
               .eq(LearnWrongQuestion::getQuizId, quizId);
        
        LearnWrongQuestion existing = getOne(wrapper);
        
        if (existing != null) {
            // 更新错误次数
            existing.setWrongCount(existing.getWrongCount() + 1);
            existing.setLastWrongTime(LocalDateTime.now());
            existing.setUserAnswer(userAnswer);
            existing.setIsMastered(0); // 重新标记为未掌握
            existing.setMasteredTime(null);
            updateById(existing);
        } else {
            // 新增错题记录
            LearnWrongQuestion wrongQuestion = new LearnWrongQuestion();
            wrongQuestion.setUserId(userId);
            wrongQuestion.setQuizId(quizId);
            wrongQuestion.setWrongCount(1);
            wrongQuestion.setLastWrongTime(LocalDateTime.now());
            wrongQuestion.setUserAnswer(userAnswer);
            wrongQuestion.setIsMastered(0);
            save(wrongQuestion);
        }
    }
    
    /**
     * 标记为已掌握
     */
    public void markAsMastered(Long userId, Long quizId) {
        LambdaQueryWrapper<LearnWrongQuestion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnWrongQuestion::getUserId, userId)
               .eq(LearnWrongQuestion::getQuizId, quizId);
        
        LearnWrongQuestion wrongQuestion = getOne(wrapper);
        if (wrongQuestion != null) {
            wrongQuestion.setIsMastered(1);
            wrongQuestion.setMasteredTime(LocalDateTime.now());
            updateById(wrongQuestion);
        }
    }
    
    /**
     * 取消已掌握标记
     */
    public void unmarkMastered(Long userId, Long quizId) {
        LambdaQueryWrapper<LearnWrongQuestion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnWrongQuestion::getUserId, userId)
               .eq(LearnWrongQuestion::getQuizId, quizId);
        
        LearnWrongQuestion wrongQuestion = getOne(wrapper);
        if (wrongQuestion != null) {
            wrongQuestion.setIsMastered(0);
            wrongQuestion.setMasteredTime(null);
            updateById(wrongQuestion);
        }
    }
    
    /**
     * 获取错题统计
     */
    public Map<String, Object> getWrongQuestionStats(Long userId) {
        LambdaQueryWrapper<LearnWrongQuestion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnWrongQuestion::getUserId, userId);
        
        List<LearnWrongQuestion> all = list(wrapper);
        
        long total = all.size();
        long mastered = all.stream().filter(wq -> wq.getIsMastered() == 1).count();
        long unmastered = total - mastered;
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", total);
        stats.put("mastered", mastered);
        stats.put("unmastered", unmastered);
        
        return stats;
    }
    
    /**
     * 删除错题
     */
    public void removeWrongQuestion(Long userId, Long quizId) {
        LambdaQueryWrapper<LearnWrongQuestion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnWrongQuestion::getUserId, userId)
               .eq(LearnWrongQuestion::getQuizId, quizId);
        remove(wrapper);
    }
}
