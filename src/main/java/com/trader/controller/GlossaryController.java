package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.GlossaryCategory;
import com.trader.entity.GlossaryTerm;
import com.trader.service.GlossaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/glossary")
@RequiredArgsConstructor
public class GlossaryController {
    
    private final GlossaryService glossaryService;
    
    /**
     * 获取分类列表
     */
    @GetMapping("/category")
    public Result<List<GlossaryCategory>> getCategoryList() {
        return Result.success(glossaryService.getCategoryList());
    }
    
    /**
     * 获取术语列表
     */
    @GetMapping("/term")
    public Result<PageResult<GlossaryTerm>> getTermList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer difficulty,
            @RequestParam(required = false) String keyword) {
        return Result.success(glossaryService.getTermList(pageNum, pageSize, categoryId, difficulty, keyword));
    }
    
    /**
     * 获取术语详情
     */
    @GetMapping("/term/{id}")
    public Result<GlossaryTerm> getTermById(@PathVariable Long id) {
        return Result.success(glossaryService.getTermById(id));
    }
    
    /**
     * 搜索术语
     */
    @GetMapping("/search")
    public Result<List<GlossaryTerm>> search(@RequestParam String keyword) {
        return Result.success(glossaryService.search(keyword));
    }
    
    /**
     * 获取热门术语
     */
    @GetMapping("/hot")
    public Result<List<GlossaryTerm>> getHotTerms(
            @RequestParam(defaultValue = "10") int limit) {
        return Result.success(glossaryService.getHotTerms(limit));
    }
    
    /**
     * 切换收藏状态
     */
    @PostMapping("/favorite/{termId}")
    public Result<Map<String, Object>> toggleFavorite(@PathVariable Long termId) {
        boolean isFavorite = glossaryService.toggleFavorite(termId);
        Map<String, Object> result = new HashMap<>();
        result.put("isFavorite", isFavorite);
        return Result.success(result);
    }
    
    /**
     * 获取收藏列表
     */
    @GetMapping("/favorite")
    public Result<List<GlossaryTerm>> getFavorites() {
        return Result.success(glossaryService.getFavorites());
    }
    
    /**
     * 获取浏览历史
     */
    @GetMapping("/history")
    public Result<List<GlossaryTerm>> getHistory(
            @RequestParam(defaultValue = "10") int limit) {
        return Result.success(glossaryService.getHistory(limit));
    }
}
