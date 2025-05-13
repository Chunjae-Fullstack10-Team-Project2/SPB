package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.service.FileService;
import net.spb.spb.service.teacher.TeacherFileServiceIf;
import net.spb.spb.util.FileUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.File;
import java.io.IOException;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/file")
public class FileController {

    private final FileUtil fileUtil;
    private final FileService fileService;

    @GetMapping("/download/library/{fileIdx}")
    public void downloadFile(@PathVariable("fileIdx") int fileIdx, HttpServletResponse response) throws IOException {
        FileDTO fileDTO = fileService.getFileByIdx(fileIdx);
        if (fileDTO == null) return;

        try {
            fileUtil.downloadFile(fileDTO.getFileName(), fileDTO.getFileOrgName(), response);
        } catch (Exception e) {
            log.info(e.getMessage());
        }
    }
}
