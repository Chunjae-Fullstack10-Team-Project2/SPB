package net.spb.spb.domain;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public final class FileVO {
    private int fileIdx;
    private String fileName;
    private String filePath;
    private String fileExt;
}
