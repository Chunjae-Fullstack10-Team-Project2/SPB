package net.spb.spb.dto.lecture;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class LectureGradeDetailDTO {
    private int lectureGradeIdx;
    private int lectureGradeRefIdx;
    private String lectureTitle;
    private String lectureDescription;
    private String lectureThumbnailImg;
    private String lectureGradeMemberId;
    private String memberName;
    private String memberProfileImg;
    private int lectureGradeScore;
    private String lectureGradeFeedback;
    private LocalDateTime lectureGradeCreatedAt;
    private LocalDateTime lectureGradeUpdatedAt;
}
