package net.spb.spb.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.service.FileService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@PropertySource("classpath:application.properties")
public class FileUtil {

    private final FileService fileService;

    @Value("${app.upload.path}")
    private String uploadDir;

    public String saveFile(String orgName, byte[] fileData) throws Exception {
        UUID uuid = UUID.randomUUID();
        String extension = "";
        int dotIndex = orgName.lastIndexOf(".");
        if (dotIndex > -1) {
            extension = orgName.substring(dotIndex);
        }
        String saveName = uuid + extension;
        File targetFile = new File(uploadDir + saveName);
        FileCopyUtils.copy(fileData, targetFile);
        return saveName;
    }

    public File saveFile(MultipartFile multipartFile) throws IOException {
        String orgName = multipartFile.getOriginalFilename();
        if (orgName == null || !orgName.contains(".")) {
            throw new IllegalArgumentException("잘못된 파일명입니다.");
        }
        String extension = orgName.substring(orgName.lastIndexOf("."));
        String saveName = UUID.randomUUID() + extension;
        File targetFile = new File(uploadDir + saveName);
        FileCopyUtils.copy(multipartFile.getBytes(), targetFile);
        return targetFile;
    }

    public int uploadFile(String orgName, byte[] fileData) throws Exception {
        String saveName = saveFile(orgName, fileData);
        FileDTO fileDTO = FileDTO.builder()
                .fileName(saveName)
                .fileExt(orgName.substring(orgName.lastIndexOf(".")))
                .filePath("/upload")
                .fileOrgName(orgName)
                .fileSize(fileData.length)
                .build();
        return fileService.insertFile(fileDTO);
    }

    public void deleteFile(String fileName) throws Exception {
        File file = new File(uploadDir + fileName);
        boolean isDeleted = false;
        // 파일 삭제
        if (file.exists()) {
            isDeleted = file.delete();
        }
        // DB에서 삭제
        if (isDeleted) {
            fileService.deleteFileByFileName(fileName);
        }
    }

    public void downloadFile(String sFileName, String oFileName, HttpServletResponse response) throws Exception {
        File file = new File(uploadDir + sFileName);

        InputStream inputStream = new FileInputStream(file);
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(oFileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");

        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            response.getOutputStream().write(buffer, 0, bytesRead);
        }
        response.getOutputStream().flush();
    }

    public static String getIconClass(String ext) {
        ext = ext.toLowerCase();
        return switch (ext) {
            case "pdf" -> "bi-file-earmark-pdf-fill text-danger";
            case "doc", "docx" -> "bi-file-earmark-word-fill text-primary";
            case "xls", "xlsx" -> "bi-file-earmark-excel-fill text-success";
            case "ppt", "pptx" -> "bi-file-earmark-ppt-fill text-warning";
            case "zip", "rar", "7z" -> "bi-file-earmark-zip-fill text-secondary";
            case "txt" -> "bi-file-earmark-text";
            default -> "bi-file-earmark";
        };
    }

    public static String formatFileSize(long size) {
        if (size < 1024) return size + " B";
        double kb = size / 1024.0;
        if (kb < 1024) return String.format("%.1f KB", kb);
        return String.format("%.1f MB", kb / 1024.0);
    }

}
