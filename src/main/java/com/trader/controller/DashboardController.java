package com.trader.controller;

import com.trader.common.Result;
import com.trader.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {
    private final DashboardService dashboardService;

    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        return Result.success(dashboardService.getStats());
    }

    @GetMapping("/recent-trades")
    public Result<?> getRecentTrades() {
        return Result.success(dashboardService.getRecentTrades());
    }

    @GetMapping("/tasks")
    public Result<?> getTasks() {
        return Result.success(dashboardService.getCurrentTasks());
    }
}
