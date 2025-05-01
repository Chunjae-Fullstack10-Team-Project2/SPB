package net.spb.spb.util;

import jakarta.annotation.Resource;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.service.FileService;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;

import java.io.File;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class FileUtil {

    private final FileService fileService;
    @Resource(name="uploadPath")
    private String uploadDir;

    public int uploadFile(String orgName, byte[] fileData) throws Exception {
        UUID uuid = UUID.randomUUID();
        String saveName = uuid + orgName;
        File targetFile = new File(uploadDir + saveName);
        FileCopyUtils.copy(fileData, targetFile);
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
