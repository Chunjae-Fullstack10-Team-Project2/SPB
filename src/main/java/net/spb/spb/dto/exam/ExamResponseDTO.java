package net.spb.spb.dto.exam;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class ExamResponseDTO {
    private int examIdx;
    private int examLectureIdx;
    private String lectureTitle;
    private String examTitle;
    private String examDescription;
    private LocalDateTime examCreatedAt;
    private LocalDateTime examUpdatedAt;
}
