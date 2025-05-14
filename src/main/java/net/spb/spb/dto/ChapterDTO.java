package net.spb.spb.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
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
    @Positive(message="강좌 정보는 필수입니다.")
    private int chapterLectureIdx;
    @NotBlank(message="강의명은 필수입니다.")
    private String chapterName;
    private String chapterVideo;
    private String chapterRuntime;
    private int lectureChapterCount;
    private int chapterState;
    private String lectureTitle;
}
