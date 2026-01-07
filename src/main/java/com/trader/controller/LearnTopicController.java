package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.LearnTopic;
import com.trader.security.RequireRole;
import com.trader.service.LearnTopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 专题内容控制器
 */
@RestController
@RequestMapping("/learn/topic")
@RequiredArgsConstructor
public class LearnTopicController {
    
    private final LearnTopicService topicService;
    
    /**
     * 获取专题列表（不分页）
     */
    @GetMapping("/all")
    public Result<List<LearnTopic>> listAllTopics(
            @RequestParam(required = false) String topicType,
            @RequestParam(required = false) Integer difficulty) {
        return Result.success(topicService.listTopics(topicType, difficulty));
    }
    
    /**
     * 分页查询专题列表
     */
    @GetMapping("/list")
    public Result<PageResult<LearnTopic>> listTopics(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String topicType,
            @RequestParam(required = false) Integer difficulty) {
        return Result.success(topicService.listTopicsPaged(pageNum, pageSize, topicType, difficulty));
    }
    
    /**
     * 获取专题详情
     */
    @GetMapping("/{id}")
    public Result<LearnTopic> getTopic(@PathVariable Long id) {
        return Result.success(topicService.getTopic(id));
    }
    
    /**
     * 搜索专题
     */
    @GetMapping("/search")
    public Result<PageResult<LearnTopic>> searchTopics(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(topicService.searchTopics(pageNum, pageSize, keyword));
    }
    
    /**
     * 根据周数获取相关专题
     */
    @GetMapping("/week/{weekNumber}")
    public Result<List<LearnTopic>> listByWeek(@PathVariable Integer weekNumber) {
        return Result.success(topicService.listByWeek(weekNumber));
    }
    
    /**
     * 获取专题统计信息
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", topicService.countByType(null));
        stats.put("supplement", topicService.countByType("supplement"));
        stats.put("advanced", topicService.countByType("advanced"));
        stats.put("special", topicService.countByType("special"));
        return Result.success(stats);
    }
    
    // ============ 管理员和讲师接口 ============
    
    /**
     * 管理员查询专题列表
     */
    @GetMapping("/admin/list")
    @RequireRole({"admin", "teacher"})
    public Result<PageResult<LearnTopic>> listAllTopicsAdmin(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String topicType,
            @RequestParam(required = false) Integer status) {
        return Result.success(topicService.listAllTopics(pageNum, pageSize, topicType, status));
    }
    
    /**
     * 创建专题
     */
    @PostMapping
    @RequireRole({"admin", "teacher"})
    public Result<Void> createTopic(@RequestBody LearnTopic topic) {
        topicService.createTopic(topic);
        return Result.success();
    }
    
    /**
     * 更新专题
     */
    @PutMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> updateTopic(@PathVariable Long id, @RequestBody LearnTopic topic) {
        topic.setId(id);
        topicService.updateTopic(topic);
        return Result.success();
    }
    
    /**
     * 删除专题
     */
    @DeleteMapping("/{id}")
    @RequireRole({"admin", "teacher"})
    public Result<Void> deleteTopic(@PathVariable Long id) {
        topicService.deleteTopic(id);
        return Result.success();
    }
}
