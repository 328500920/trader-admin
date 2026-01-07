package com.trader.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.trader.common.PageResult;
import com.trader.entity.*;
import com.trader.mapper.*;
import com.trader.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LearnService {
    private final LearnCourseMapper courseMapper;
    private final LearnChapterMapper chapterMapper;
    private final LearnTaskMapper taskMapper;
    private final LearnProgressMapper progressMapper;
    private final LearnTaskRecordMapper taskRecordMapper;
    private final LearnNoteMapper noteMapper;
    private final LearnMaterialMapper materialMapper;

    public List<LearnCourse> listCourses(Integer stage) {
        LambdaQueryWrapper<LearnCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnCourse::getStatus, 1);
        if (stage != null) wrapper.eq(LearnCourse::getStage, stage);
        wrapper.orderByAsc(LearnCourse::getStage).orderByAsc(LearnCourse::getSortOrder);
        List<LearnCourse> courses = courseMapper.selectList(wrapper);
        Long userId = SecurityUtils.getUserId();
        for (LearnCourse course : courses) {
            int chapterCount = chapterMapper.selectCount(new LambdaQueryWrapper<LearnChapter>()
                    .eq(LearnChapter::getCourseId, course.getId())).intValue();
            int completedCount = progressMapper.selectCount(new LambdaQueryWrapper<LearnProgress>()
                    .eq(LearnProgress::getUserId, userId)
                    .eq(LearnProgress::getIsCompleted, 1)
                    .inSql(LearnProgress::getChapterId, "SELECT id FROM learn_chapter WHERE course_id = " + course.getId())).intValue();
            course.setChapterCount(chapterCount);
            course.setCompletedCount(completedCount);
        }
        return courses;
    }

    public LearnCourse getCourse(Long id) {
        LearnCourse course = courseMapper.selectById(id);
        if (course != null) {
            List<LearnChapter> chapters = chapterMapper.selectList(new LambdaQueryWrapper<LearnChapter>()
                    .eq(LearnChapter::getCourseId, id).orderByAsc(LearnChapter::getSortOrder));
            Long userId = SecurityUtils.getUserId();
            List<Long> completedIds = progressMapper.selectList(new LambdaQueryWrapper<LearnProgress>()
                    .eq(LearnProgress::getUserId, userId).eq(LearnProgress::getIsCompleted, 1))
                    .stream().map(LearnProgress::getChapterId).collect(Collectors.toList());
            
            int completedCount = 0;
            for (LearnChapter c : chapters) {
                boolean completed = completedIds.contains(c.getId());
                c.setIsCompleted(completed);
                if (completed) completedCount++;
                // 加载每个章节的任务
                List<LearnTask> tasks = taskMapper.selectList(new LambdaQueryWrapper<LearnTask>()
                        .eq(LearnTask::getChapterId, c.getId()).orderByAsc(LearnTask::getSortOrder));
                List<Long> completedTaskIds = taskRecordMapper.selectList(new LambdaQueryWrapper<LearnTaskRecord>()
                        .eq(LearnTaskRecord::getUserId, userId).eq(LearnTaskRecord::getIsCompleted, 1))
                        .stream().map(LearnTaskRecord::getTaskId).collect(Collectors.toList());
                tasks.forEach(t -> t.setIsCompleted(completedTaskIds.contains(t.getId())));
                c.setTasks(tasks);
            }
            course.setChapters(chapters);
            course.setChapterCount(chapters.size());
            course.setCompletedCount(completedCount);
        }
        return course;
    }

    public LearnChapter getChapter(Long id) {
        LearnChapter chapter = chapterMapper.selectById(id);
        if (chapter != null) {
            List<LearnTask> tasks = taskMapper.selectList(new LambdaQueryWrapper<LearnTask>()
                    .eq(LearnTask::getChapterId, id).orderByAsc(LearnTask::getSortOrder));
            Long userId = SecurityUtils.getUserId();
            List<Long> completedTaskIds = taskRecordMapper.selectList(new LambdaQueryWrapper<LearnTaskRecord>()
                    .eq(LearnTaskRecord::getUserId, userId).eq(LearnTaskRecord::getIsCompleted, 1))
                    .stream().map(LearnTaskRecord::getTaskId).collect(Collectors.toList());
            tasks.forEach(t -> t.setIsCompleted(completedTaskIds.contains(t.getId())));
            chapter.setTasks(tasks);
        }
        return chapter;
    }

    @Transactional
    public void completeChapter(Long chapterId) {
        Long userId = SecurityUtils.getUserId();
        LearnProgress progress = progressMapper.selectOne(new LambdaQueryWrapper<LearnProgress>()
                .eq(LearnProgress::getUserId, userId).eq(LearnProgress::getChapterId, chapterId));
        if (progress == null) {
            progress = new LearnProgress();
            progress.setUserId(userId);
            progress.setChapterId(chapterId);
            progress.setIsCompleted(1);
            progress.setCompleteTime(LocalDateTime.now());
            progressMapper.insert(progress);
        } else if (progress.getIsCompleted() == 0) {
            progress.setIsCompleted(1);
            progress.setCompleteTime(LocalDateTime.now());
            progressMapper.updateById(progress);
        }
    }

    @Transactional
    public void completeTask(Long taskId) {
        Long userId = SecurityUtils.getUserId();
        LearnTaskRecord record = taskRecordMapper.selectOne(new LambdaQueryWrapper<LearnTaskRecord>()
                .eq(LearnTaskRecord::getUserId, userId).eq(LearnTaskRecord::getTaskId, taskId));
        if (record == null) {
            record = new LearnTaskRecord();
            record.setUserId(userId);
            record.setTaskId(taskId);
            record.setIsCompleted(1);
            record.setCompleteTime(LocalDateTime.now());
            taskRecordMapper.insert(record);
        } else {
            record.setIsCompleted(record.getIsCompleted() == 1 ? 0 : 1);
            record.setCompleteTime(record.getIsCompleted() == 1 ? LocalDateTime.now() : null);
            taskRecordMapper.updateById(record);
        }
    }

    public Map<String, Object> getProgress() {
        Long userId = SecurityUtils.getUserId();
        int totalChapters = chapterMapper.selectCount(new LambdaQueryWrapper<LearnChapter>().eq(LearnChapter::getStatus, 1)).intValue();
        int completedChapters = progressMapper.selectCount(new LambdaQueryWrapper<LearnProgress>()
                .eq(LearnProgress::getUserId, userId).eq(LearnProgress::getIsCompleted, 1)).intValue();
        Map<String, Object> result = new HashMap<>();
        result.put("total", totalChapters);
        result.put("completed", completedChapters);
        result.put("percent", totalChapters > 0 ? (completedChapters * 100 / totalChapters) : 0);
        return result;
    }

    public PageResult<LearnNote> listNotes(int pageNum, int pageSize) {
        Long userId = SecurityUtils.getUserId();
        Page<LearnNote> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<LearnNote> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnNote::getUserId, userId).orderByDesc(LearnNote::getUpdateTime);
        Page<LearnNote> result = noteMapper.selectPage(page, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize);
    }

    public LearnNote getNoteByChapter(Long chapterId) {
        Long userId = SecurityUtils.getUserId();
        LambdaQueryWrapper<LearnNote> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(LearnNote::getUserId, userId)
               .eq(LearnNote::getChapterId, chapterId)
               .orderByDesc(LearnNote::getUpdateTime)
               .last("LIMIT 1");
        return noteMapper.selectOne(wrapper);
    }

    public LearnNote saveNote(LearnNote note) {
        Long userId = SecurityUtils.getUserId();
        // 查找是否已有该章节的笔记
        LearnNote existing = getNoteByChapter(note.getChapterId());
        if (existing != null) {
            // 更新
            existing.setContent(note.getContent());
            if (note.getTitle() != null) {
                existing.setTitle(note.getTitle());
            }
            noteMapper.updateById(existing);
            return existing;
        } else {
            // 新建
            note.setUserId(userId);
            noteMapper.insert(note);
            return note;
        }
    }

    public void createNote(LearnNote note) {
        note.setUserId(SecurityUtils.getUserId());
        noteMapper.insert(note);
    }

    public void updateNote(LearnNote note) {
        note.setUserId(SecurityUtils.getUserId());
        noteMapper.updateById(note);
    }

    public void deleteNote(Long id) {
        noteMapper.deleteById(id);
    }

    // 管理员方法
    public void createCourse(LearnCourse course) {
        course.setCreateBy(SecurityUtils.getUserId());
        courseMapper.insert(course);
    }

    public void updateCourse(LearnCourse course) {
        courseMapper.updateById(course);
    }

    public void deleteCourse(Long id) {
        courseMapper.deleteById(id);
        chapterMapper.delete(new LambdaQueryWrapper<LearnChapter>().eq(LearnChapter::getCourseId, id));
    }

    public void createChapter(LearnChapter chapter) {
        chapterMapper.insert(chapter);
    }

    public void updateChapter(LearnChapter chapter) {
        chapterMapper.updateById(chapter);
    }

    public void deleteChapter(Long id) {
        chapterMapper.deleteById(id);
        taskMapper.delete(new LambdaQueryWrapper<LearnTask>().eq(LearnTask::getChapterId, id));
    }

    public List<LearnCourse> listAllCourses() {
        return courseMapper.selectList(new LambdaQueryWrapper<LearnCourse>().orderByAsc(LearnCourse::getStage).orderByAsc(LearnCourse::getSortOrder));
    }

    public List<LearnChapter> listChaptersByCourse(Long courseId) {
        return chapterMapper.selectList(new LambdaQueryWrapper<LearnChapter>().eq(LearnChapter::getCourseId, courseId).orderByAsc(LearnChapter::getSortOrder));
    }

    // 学习资料相关方法
    public List<LearnMaterial> listMaterials(Long chapterId) {
        return materialMapper.selectList(new LambdaQueryWrapper<LearnMaterial>()
                .eq(LearnMaterial::getChapterId, chapterId)
                .eq(LearnMaterial::getStatus, 1)
                .orderByAsc(LearnMaterial::getSortOrder));
    }

    public LearnMaterial getMaterial(Long id) {
        return materialMapper.selectById(id);
    }

    public void createMaterial(LearnMaterial material) {
        material.setCreateBy(SecurityUtils.getUserId());
        material.setStatus(1);
        materialMapper.insert(material);
    }

    public void updateMaterial(LearnMaterial material) {
        materialMapper.updateById(material);
    }

    public void deleteMaterial(Long id) {
        materialMapper.deleteById(id);
    }
}
