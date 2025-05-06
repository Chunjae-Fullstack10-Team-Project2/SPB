package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChapterDTO {
    private int chapterIdx;
    private int chapterLectureIdx;
    private String chapterName;
    private String chapterVideo;
    private String chapterRuntime;
}
