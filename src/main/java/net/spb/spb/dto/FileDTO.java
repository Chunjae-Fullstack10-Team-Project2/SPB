package net.spb.spb.dto;

import lombok.*;
import lombok.experimental.SuperBuilder;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public final class FileDTO {
    private int fileIdx;
    private String fileName;
    private String filePath;
    private String fileExt;
    private String fileOrgName;
    private long fileSize;
    private boolean isImage;
}
