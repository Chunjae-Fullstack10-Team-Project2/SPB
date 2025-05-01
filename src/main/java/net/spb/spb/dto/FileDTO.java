package net.spb.spb.dto;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public final class FileDTO {
    private int fileIdx;
    private String fileName;
    private String filePath;
    private String fileExt;
}
