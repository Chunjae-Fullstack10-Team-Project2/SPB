package net.spb.spb.util;

import jakarta.annotation.Resource;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.service.FileService;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class FileUtil {

    private final FileService fileService;
    @Resource(name="uploadPath")
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
                .build();
        int fileIdx = fileService.insertFile(fileDTO);
        return fileIdx;
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

}
