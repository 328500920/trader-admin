package com.trader.controller;

import com.trader.common.Result;
import com.trader.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 全局搜索控制器
 */
@RestController
@RequestMapping("/search")
public class SearchController {

    @Autowired
    private SearchService searchService;

    /**
     * 全局搜索
     * @param keyword 搜索关键词
     * @param limit 每类结果数量限制
     */
    @GetMapping("/global")
    public Result globalSearch(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "5") Integer limit) {
        return Result.success(searchService.globalSearch(keyword, limit));
    }
}
