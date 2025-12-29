package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.*;
import com.trader.mapper.*;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ToolService {
    private final ToolChecklistMapper checklistMapper;
    private final ToolLinkMapper linkMapper;
    private final ToolDailyAnalysisMapper analysisMapper;

    public List<ToolChecklist> listChecklists() {
        Long userId = SecurityUtils.getUserId();
        return checklistMapper.selectList(new LambdaQueryWrapper<ToolChecklist>()
                .eq(ToolChecklist::getIsSystem, 1).or().eq(ToolChecklist::getCreateBy, userId)
                .orderByDesc(ToolChecklist::getIsSystem).orderByDesc(ToolChecklist::getCreateTime));
    }

    public ToolChecklist getChecklist(Long id) {
        return checklistMapper.selectById(id);
    }

    public void createChecklist(ToolChecklist checklist) {
        checklist.setCreateBy(SecurityUtils.getUserId());
        checklist.setIsSystem(0);
        checklistMapper.insert(checklist);
    }

    public List<ToolLink> listLinks() {
        return linkMapper.selectList(new LambdaQueryWrapper<ToolLink>()
                .eq(ToolLink::getStatus, 1).orderByAsc(ToolLink::getSortOrder));
    }

    public void createLink(ToolLink link) {
        link.setStatus(1);
        linkMapper.insert(link);
    }

    public void updateLink(ToolLink link) {
        linkMapper.updateById(link);
    }

    public void deleteLink(Long id) {
        linkMapper.deleteById(id);
    }

    public PageResult<ToolDailyAnalysis> listAnalysis(int pageNum, int pageSize) {
        Long userId = SecurityUtils.getUserId();
        Page<ToolDailyAnalysis> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ToolDailyAnalysis> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ToolDailyAnalysis::getUserId, userId).orderByDesc(ToolDailyAnalysis::getAnalysisDate);
        Page<ToolDailyAnalysis> result = analysisMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    public ToolDailyAnalysis getAnalysis(LocalDate date) {
        Long userId = SecurityUtils.getUserId();
        return analysisMapper.selectOne(new LambdaQueryWrapper<ToolDailyAnalysis>()
                .eq(ToolDailyAnalysis::getUserId, userId).eq(ToolDailyAnalysis::getAnalysisDate, date));
    }

    public void saveAnalysis(ToolDailyAnalysis analysis) {
        Long userId = SecurityUtils.getUserId();
        ToolDailyAnalysis existing = analysisMapper.selectOne(new LambdaQueryWrapper<ToolDailyAnalysis>()
                .eq(ToolDailyAnalysis::getUserId, userId).eq(ToolDailyAnalysis::getAnalysisDate, analysis.getAnalysisDate()));
        if (existing != null) {
            analysis.setId(existing.getId());
            analysisMapper.updateById(analysis);
        } else {
            analysis.setUserId(userId);
            analysisMapper.insert(analysis);
        }
    }
}
