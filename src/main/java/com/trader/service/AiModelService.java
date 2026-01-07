package com.trader.service;

import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.trader.common.BusinessException;
import com.trader.entity.SysAiModel;
import com.trader.mapper.SysAiModelMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.function.Consumer;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiModelService {
    
    private final SysAiModelMapper aiModelMapper;

    /**
     * 获取所有模型配置
     */
    public List<SysAiModel> listAll() {
        LambdaQueryWrapper<SysAiModel> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(SysAiModel::getSortOrder);
        return aiModelMapper.selectList(wrapper);
    }

    /**
     * 获取当前启用的模型
     */
    public SysAiModel getActiveModel() {
        return aiModelMapper.findActiveModel();
    }

    /**
     * 创建模型配置
     */
    public void create(SysAiModel model) {
        if (model.getIsActive() == null) {
            model.setIsActive(0);
        }
        aiModelMapper.insert(model);
    }

    /**
     * 更新模型配置
     */
    public void update(SysAiModel model) {
        aiModelMapper.updateById(model);
    }

    /**
     * 启用指定模型
     */
    @Transactional
    public void activate(Long id) {
        // 先禁用所有
        aiModelMapper.deactivateAll();
        // 启用指定模型
        SysAiModel model = new SysAiModel();
        model.setId(id);
        model.setIsActive(1);
        aiModelMapper.updateById(model);
    }

    /**
     * 删除模型配置
     */
    public void delete(Long id) {
        SysAiModel model = aiModelMapper.selectById(id);
        if (model != null && model.getIsActive() == 1) {
            throw new BusinessException("不能删除正在使用的模型");
        }
        aiModelMapper.deleteById(id);
    }

    /**
     * 调用AI模型（非流式）
     */
    public String chat(String prompt) {
        SysAiModel model = getActiveModel();
        if (model == null) {
            throw new BusinessException("没有可用的AI模型，请先配置");
        }
        if (StrUtil.isBlank(model.getApiKey())) {
            throw new BusinessException("AI模型API Key未配置");
        }
        
        JSONObject requestBody = buildRequestBody(model, prompt, false);
        
        try {
            HttpResponse response = HttpRequest.post(model.getApiUrl())
                    .header("Authorization", "Bearer " + model.getApiKey())
                    .header("Content-Type", "application/json")
                    .body(requestBody.toString())
                    .timeout(120000)
                    .execute();
            
            if (!response.isOk()) {
                log.error("AI调用失败: {}", response.body());
                throw new BusinessException("AI调用失败: " + response.getStatus());
            }
            
            JSONObject result = JSONUtil.parseObj(response.body());
            return result.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getStr("content");
        } catch (Exception e) {
            log.error("AI调用异常", e);
            throw new BusinessException("AI调用异常: " + e.getMessage());
        }
    }

    /**
     * 调用AI模型（流式输出）
     */
    public void chatStream(String prompt, Consumer<String> onMessage, Runnable onComplete) {
        SysAiModel model = getActiveModel();
        if (model == null) {
            throw new BusinessException("没有可用的AI模型，请先配置");
        }
        if (StrUtil.isBlank(model.getApiKey())) {
            throw new BusinessException("AI模型API Key未配置");
        }
        
        JSONObject requestBody = buildRequestBody(model, prompt, true);
        
        try {
            HttpRequest.post(model.getApiUrl())
                    .header("Authorization", "Bearer " + model.getApiKey())
                    .header("Content-Type", "application/json")
                    .body(requestBody.toString())
                    .timeout(120000)
                    .then(response -> {
                        if (!response.isOk()) {
                            throw new BusinessException("AI调用失败: " + response.getStatus());
                        }
                        
                        String body = response.body();
                        String[] lines = body.split("\n");
                        
                        for (String line : lines) {
                            if (line.startsWith("data: ")) {
                                String data = line.substring(6).trim();
                                if ("[DONE]".equals(data)) {
                                    break;
                                }
                                try {
                                    JSONObject json = JSONUtil.parseObj(data);
                                    JSONArray choices = json.getJSONArray("choices");
                                    if (choices != null && !choices.isEmpty()) {
                                        JSONObject delta = choices.getJSONObject(0).getJSONObject("delta");
                                        if (delta != null) {
                                            String content = delta.getStr("content");
                                            if (content != null) {
                                                onMessage.accept(content);
                                            }
                                        }
                                    }
                                } catch (Exception e) {
                                    // 忽略解析错误
                                }
                            }
                        }
                        
                        if (onComplete != null) {
                            onComplete.run();
                        }
                    });
        } catch (Exception e) {
            log.error("AI流式调用异常", e);
            throw new BusinessException("AI调用异常: " + e.getMessage());
        }
    }

    /**
     * 构建请求体
     */
    private JSONObject buildRequestBody(SysAiModel model, String prompt, boolean stream) {
        JSONObject body = new JSONObject();
        body.set("model", model.getModel());
        body.set("stream", stream);
        body.set("max_tokens", model.getMaxTokens());
        body.set("temperature", model.getTemperature());
        
        JSONArray messages = new JSONArray();
        JSONObject systemMsg = new JSONObject();
        systemMsg.set("role", "system");
        systemMsg.set("content", "你是一位专业的加密货币交易分析师，擅长分析交易数据并给出专业建议。");
        messages.add(systemMsg);
        
        JSONObject userMsg = new JSONObject();
        userMsg.set("role", "user");
        userMsg.set("content", prompt);
        messages.add(userMsg);
        
        body.set("messages", messages);
        return body;
    }
}
