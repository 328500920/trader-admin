package com.trader.controller;

import com.trader.common.BusinessException;
import com.trader.common.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.IdUtil;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/file")
@RequiredArgsConstructor
public class FileController {

    @Value("${file.upload-path}")
    private String uploadPath;

    @Value("${file.allowed-types}")
    private String allowedTypes;

    @Value("${file.max-size}")
    private Long maxSize;

    @PostMapping("/upload")
    public Result<Map<String, String>> upload(@RequestParam("file") MultipartFile file) {
        return Result.success(doUpload(file));
    }

    @PostMapping("/upload/image")
    public Result<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file) {
        String ext = FileUtil.extName(file.getOriginalFilename()).toLowerCase();
        if (!Arrays.asList(allowedTypes.split(",")).contains(ext)) {
            throw new BusinessException("不支持的图片格式");
        }
        return Result.success(doUpload(file));
    }

    private Map<String, String> doUpload(MultipartFile file) {
        if (file.isEmpty()) {
            throw new BusinessException("文件不能为空");
        }
        if (file.getSize() > maxSize) {
            throw new BusinessException("文件大小超过限制");
        }

        String ext = FileUtil.extName(file.getOriginalFilename());
        String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String fileName = IdUtil.simpleUUID() + "." + ext;
        String relativePath = dateDir + "/" + fileName;
        String fullPath = uploadPath + relativePath;

        try {
            FileUtil.mkdir(uploadPath + dateDir);
            file.transferTo(new File(fullPath));
        } catch (IOException e) {
            throw new BusinessException("文件上传失败");
        }

        Map<String, String> result = new HashMap<>();
        result.put("url", "/uploads/" + relativePath);
        result.put("name", file.getOriginalFilename());
        return result;
    }
}
