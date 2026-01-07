package com.trader.controller;

import com.trader.annotation.OperationLog;
import com.trader.annotation.OperationLog.OperationType;
import com.trader.common.PageResult;
import com.trader.common.Result;
import com.trader.entity.*;
import com.trader.security.RequireRole;
import com.trader.service.LearnService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/learn")
@RequiredArgsConstructor
public class LearnController {
    private final LearnService learnService;

    @GetMapping("/course/list")
    public Result<List<LearnCourse>> listCourses(@RequestParam(required = false) Integer stage) {
        return Result.success(learnService.listCourses(stage));
    }

    @GetMapping("/course/{id}")
    public Result<LearnCourse> getCourse(@PathVariable Long id) {
        return Result.success(learnService.getCourse(id));
    }

    @GetMapping("/chapter/{id}")
    public Result<LearnChapter> getChapter(@PathVariable Long id) {
        return Result.success(learnService.getChapter(id));
    }

    @PostMapping("/progress/complete")
    public Result<Void> completeChapter(@RequestBody Map<String, Long> params) {
        learnService.completeChapter(params.get("chapterId"));
        return Result.success();
    }

    @PostMapping("/task/complete")
    public Result<Void> completeTask(@RequestBody Map<String, Long> params) {
        learnService.completeTask(params.get("taskId"));
        return Result.success();
    }

    @GetMapping("/progress")
    public Result<Map<String, Object>> getProgress() {
        return Result.success(learnService.getProgress());
    }

    @GetMapping("/note/list")
    public Result<PageResult<LearnNote>> listNotes(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(learnService.listNotes(pageNum, pageSize));
    }

    @GetMapping("/note/get")
    public Result<LearnNote> getNoteByChapter(@RequestParam Long chapterId) {
        return Result.success(learnService.getNoteByChapter(chapterId));
    }

    @PostMapping("/note/save")
    public Result<LearnNote> saveNote(@RequestBody LearnNote note) {
        return Result.success(learnService.saveNote(note));
    }

    @PostMapping("/note")
    public Result<Void> createNote(@RequestBody LearnNote note) {
        learnService.createNote(note);
        return Result.success();
    }

    @PutMapping("/note/{id}")
    public Result<Void> updateNote(@PathVariable Long id, @RequestBody LearnNote note) {
        note.setId(id);
        learnService.updateNote(note);
        return Result.success();
    }

    @DeleteMapping("/note/{id}")
    public Result<Void> deleteNote(@PathVariable Long id) {
        learnService.deleteNote(id);
        return Result.success();
    }

    // 管理员和讲师接口
    @PostMapping("/course")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.CREATE, description = "创建课程")
    public Result<Void> createCourse(@RequestBody LearnCourse course) {
        learnService.createCourse(course);
        return Result.success();
    }

    @PutMapping("/course/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.UPDATE, description = "修改课程")
    public Result<Void> updateCourse(@PathVariable Long id, @RequestBody LearnCourse course) {
        course.setId(id);
        learnService.updateCourse(course);
        return Result.success();
    }

    @DeleteMapping("/course/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.DELETE, description = "删除课程")
    public Result<Void> deleteCourse(@PathVariable Long id) {
        learnService.deleteCourse(id);
        return Result.success();
    }

    @PostMapping("/chapter")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.CREATE, description = "创建章节")
    public Result<Void> createChapter(@RequestBody LearnChapter chapter) {
        learnService.createChapter(chapter);
        return Result.success();
    }

    @PutMapping("/chapter/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.UPDATE, description = "修改章节")
    public Result<Void> updateChapter(@PathVariable Long id, @RequestBody LearnChapter chapter) {
        chapter.setId(id);
        learnService.updateChapter(chapter);
        return Result.success();
    }

    @DeleteMapping("/chapter/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.DELETE, description = "删除章节")
    public Result<Void> deleteChapter(@PathVariable Long id) {
        learnService.deleteChapter(id);
        return Result.success();
    }

    @GetMapping("/course/all")
    @RequireRole({"admin", "teacher"})
    public Result<List<LearnCourse>> listAllCourses() {
        return Result.success(learnService.listAllCourses());
    }

    @GetMapping("/chapter/list")
    public Result<List<LearnChapter>> listChapters(@RequestParam Long courseId) {
        return Result.success(learnService.listChaptersByCourse(courseId));
    }

    // 学习资料接口
    @GetMapping("/material/list")
    public Result<List<LearnMaterial>> listMaterials(@RequestParam Long chapterId) {
        return Result.success(learnService.listMaterials(chapterId));
    }

    @GetMapping("/material/{id}")
    public Result<LearnMaterial> getMaterial(@PathVariable Long id) {
        return Result.success(learnService.getMaterial(id));
    }

    @PostMapping("/material")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.CREATE, description = "创建学习资料")
    public Result<Void> createMaterial(@RequestBody LearnMaterial material) {
        learnService.createMaterial(material);
        return Result.success();
    }

    @PutMapping("/material/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.UPDATE, description = "修改学习资料")
    public Result<Void> updateMaterial(@PathVariable Long id, @RequestBody LearnMaterial material) {
        material.setId(id);
        learnService.updateMaterial(material);
        return Result.success();
    }

    @DeleteMapping("/material/{id}")
    @RequireRole({"admin", "teacher"})
    @OperationLog(module = "课程管理", type = OperationType.DELETE, description = "删除学习资料")
    public Result<Void> deleteMaterial(@PathVariable Long id) {
        learnService.deleteMaterial(id);
        return Result.success();
    }
}
