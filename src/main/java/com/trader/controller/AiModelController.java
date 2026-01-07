package com.trader.controller;

import com.trader.common.Result;
import com.trader.entity.SysAiModel;
import com.trader.security.RequireRole;
import com.trader.service.AiModelService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ai/model")
@RequiredArgsConstructor
public class AiModelController {
    
    private final AiModelService aiModelService;

    /**
     * 获取所有模型配置
     */
    @GetMapping("/list")
    @RequireRole("admin")
    public Result<List<SysAiModel>> list() {
        List<SysAiModel> list = aiModelService.listAll();
        // 隐藏API Key
        list.forEach(m -> {
            if (m.getApiKey() != null && m.getApiKey().length() > 8) {
                m.setApiKey(m.getApiKey().substring(0, 4) + "****" + m.getApiKey().substring(m.getApiKey().length() - 4));
            }
        });
        return Result.success(list);
    }

    /**
     * 获取当前启用的模型
     */
    @GetMapping("/active")
    public Result<SysAiModel> getActive() {
        SysAiModel model = aiModelService.getActiveModel();
        if (model != null) {
            model.setApiKey(null); // 不返回API Key
        }
        return Result.success(model);
    }

    /**
     * 创建模型配置
     */
    @PostMapping
    @RequireRole("admin")
    public Result<Void> create(@RequestBody SysAiModel model) {
        aiModelService.create(model);
        return Result.success();
    }

    /**
     * 更新模型配置
     */
    @PutMapping("/{id}")
    @RequireRole("admin")
    public Result<Void> update(@PathVariable Long id, @RequestBody SysAiModel model) {
        model.setId(id);
        aiModelService.update(model);
        return Result.success();
    }

    /**
     * 启用指定模型
     */
    @PutMapping("/{id}/activate")
    @RequireRole("admin")
    public Result<Void> activate(@PathVariable Long id) {
        aiModelService.activate(id);
        return Result.success();
    }

    /**
     * 删除模型配置
     */
    @DeleteMapping("/{id}")
    @RequireRole("admin")
    public Result<Void> delete(@PathVariable Long id) {
        aiModelService.delete(id);
        return Result.success();
    }
}
