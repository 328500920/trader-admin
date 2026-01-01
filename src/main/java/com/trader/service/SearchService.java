package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.trader.entity.*;
import com.trader.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 全局搜索服务
 */
@Service
public class SearchService {

    @Autowired
    private LearnChapterMapper chapterMapper;
    
    @Autowired
    private LearnCaseMapper caseMapper;
    
    @Autowired
    private LearnResourceMapper resourceMapper;
    
    @Autowired
    private LearnTopicMapper topicMapper;
    
    @Autowired
    private LearnToolGuideMapper toolGuideMapper;

    /**
     * 全局搜索
     */
    public Map<String, Object> globalSearch(String keyword, Integer limit) {
        Map<String, Object> result = new HashMap<>();
        
        // 搜索章节
        LambdaQueryWrapper<LearnChapter> chapterQuery = new LambdaQueryWrapper<>();
        chapterQuery.like(LearnChapter::getTitle, keyword)
                .or()
                .like(LearnChapter::getContent, keyword)
                .eq(LearnChapter::getStatus, 1)
                .last("LIMIT " + limit);
        List<LearnChapter> chapters = chapterMapper.selectList(chapterQuery);
        result.put("chapters", chapters.stream().map(c -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", c.getId());
            map.put("title", c.getTitle());
            map.put("description", "第" + c.getWeekNumber() + "周");
            return map;
        }).collect(Collectors.toList()));
        
        // 搜索案例
        LambdaQueryWrapper<LearnCase> caseQuery = new LambdaQueryWrapper<>();
        caseQuery.like(LearnCase::getTitle, keyword)
                .or()
                .like(LearnCase::getBackground, keyword)
                .or()
                .like(LearnCase::getLessons, keyword)
                .eq(LearnCase::getStatus, 1)
                .last("LIMIT " + limit);
        List<LearnCase> cases = caseMapper.selectList(caseQuery);
        result.put("cases", cases.stream().map(c -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", c.getId());
            map.put("title", c.getTitle());
            map.put("description", c.getSymbol() + " - " + c.getCaseType());
            return map;
        }).collect(Collectors.toList()));
        
        // 搜索资源
        LambdaQueryWrapper<LearnResource> resourceQuery = new LambdaQueryWrapper<>();
        resourceQuery.like(LearnResource::getTitle, keyword)
                .or()
                .like(LearnResource::getDescription, keyword)
                .or()
                .like(LearnResource::getAuthor, keyword)
                .eq(LearnResource::getStatus, 1)
                .last("LIMIT " + limit);
        List<LearnResource> resources = resourceMapper.selectList(resourceQuery);
        result.put("resources", resources.stream().map(r -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("title", r.getTitle());
            map.put("description", r.getPlatform());
            map.put("url", r.getUrl());
            return map;
        }).collect(Collectors.toList()));
        
        // 搜索专题
        LambdaQueryWrapper<LearnTopic> topicQuery = new LambdaQueryWrapper<>();
        topicQuery.like(LearnTopic::getTitle, keyword)
                .or()
                .like(LearnTopic::getSubtitle, keyword)
                .or()
                .like(LearnTopic::getDescription, keyword)
                .eq(LearnTopic::getStatus, 1)
                .last("LIMIT " + limit);
        List<LearnTopic> topics = topicMapper.selectList(topicQuery);
        result.put("topics", topics.stream().map(t -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", t.getId());
            map.put("title", t.getTitle());
            map.put("description", t.getSubtitle());
            return map;
        }).collect(Collectors.toList()));
        
        // 搜索工具指南
        LambdaQueryWrapper<LearnToolGuide> toolQuery = new LambdaQueryWrapper<>();
        toolQuery.like(LearnToolGuide::getToolName, keyword)
                .or()
                .like(LearnToolGuide::getDescription, keyword)
                .eq(LearnToolGuide::getStatus, 1)
                .last("LIMIT " + limit);
        List<LearnToolGuide> tools = toolGuideMapper.selectList(toolQuery);
        result.put("tools", tools.stream().map(t -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", t.getId());
            map.put("toolName", t.getToolName());
            map.put("description", t.getDescription());
            return map;
        }).collect(Collectors.toList()));
        
        return result;
    }
}
