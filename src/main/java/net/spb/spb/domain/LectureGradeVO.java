package net.spb.spb.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class LectureGradeVO {
    private int lectureGradeIdx;
    private int lectureGradeRefIdx;
    private String lectureGradeMemberId;
    private String lectureGradeScore;
    private String lectureGradeFeedback;
    private LocalDateTime lectureGradeCreatedAt;
    private LocalDateTime lectureGradeUpdatedAt;
}
