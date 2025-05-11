package net.spb.spb.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LectureReviewVO {
    private int lectureReviewIdx;
    private int lectureReviewRefIdx;
    private String lectureReviewContent;
    private String lectureReviewMemberId;
    private int lectureReviewGrade;
    private LocalDateTime lectureReviewCreatedAt;
    private LocalDateTime lectureReviewUpdatedAt;
}
