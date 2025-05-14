package net.spb.spb.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class ExamVO {
    private int examIdx;
    private int examLectureIdx;
    private String examTitle;
    private String examDescription;
    private LocalDateTime examCreatedAt;
}
