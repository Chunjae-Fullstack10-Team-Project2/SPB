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
public class StudentLectureResponseDTO {
    private int lectureRegisterIdx;
    private String lectureRegisterMemberId;
    private int lectureRegisterRefIdx;
    private String lectureTitle;
    private String lectureTeacherId;
    private String teacherName;
    private LocalDateTime lectureRegisterStartedAt;
    private String lectureRegisterStatus;
    private LocalDateTime lectureHistoryLastWatchDate;
    private int lectureProgress;
    private boolean hasLectureReview;
}
