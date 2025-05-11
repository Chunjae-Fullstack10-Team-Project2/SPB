package net.spb.spb.dto.lecture;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LectureReviewResponseDTO {
    private int lectureReviewIdx;
    private int lectureReviewRefIdx;
    private String lectureTitle;
    private String lectureTeacherId;
    private String teacherName;
    private String lectureReviewContent;
    private String lectureReviewMemberId;
    private String memberName;
    private int lectureReviewGrade;
    private LocalDateTime lectureReviewCreatedAt;
    private LocalDateTime lectureReviewUpdatedAt;
}
