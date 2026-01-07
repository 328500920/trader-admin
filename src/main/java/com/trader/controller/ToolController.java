package com.trader.controller;

import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.*;
import com.trader.security.RequireRole;
import com.trader.service.ToolService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/tool")
@RequiredArgsConstructor
public class ToolController {
    private final ToolService toolService;

    @GetMapping("/checklist/list")
    public Result<List<ToolChecklist>> listChecklists() {
        return Result.success(toolService.listChecklists());
    }

    @GetMapping("/checklist/{id}")
    public Result<ToolChecklist> getChecklist(@PathVariable Long id) {
        return Result.success(toolService.getChecklist(id));
    }

    @PostMapping("/checklist")
    public Result<Void> createChecklist(@RequestBody ToolChecklist checklist) {
        toolService.createChecklist(checklist);
        return Result.success();
    }

    @GetMapping("/link/list")
    public Result<List<ToolLink>> listLinks() {
        return Result.success(toolService.listLinks());
    }

    @PostMapping("/link")
    @RequireRole("admin")
    public Result<Void> createLink(@RequestBody ToolLink link) {
        toolService.createLink(link);
        return Result.success();
    }

    @PutMapping("/link/{id}")
    @RequireRole("admin")
    public Result<Void> updateLink(@PathVariable Long id, @RequestBody ToolLink link) {
        link.setId(id);
        toolService.updateLink(link);
        return Result.success();
    }

    @DeleteMapping("/link/{id}")
    @RequireRole("admin")
    public Result<Void> deleteLink(@PathVariable Long id) {
        toolService.deleteLink(id);
        return Result.success();
    }

    @GetMapping("/analysis/list")
    public Result<PageResult<ToolDailyAnalysis>> listAnalysis(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(toolService.listAnalysis(pageNum, pageSize));
    }

    @GetMapping("/analysis/{date}")
    public Result<ToolDailyAnalysis> getAnalysis(
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return Result.success(toolService.getAnalysis(date));
    }

    @PostMapping("/analysis")
    public Result<Void> saveAnalysis(@RequestBody ToolDailyAnalysis analysis) {
        toolService.saveAnalysis(analysis);
        return Result.success();
    }
}
