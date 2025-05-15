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
public class LectureGradeListDTO {
    private int lectureRegisterIdx;
    private String lectureRegisterMemberId;
    private int lectureRegisterRefIdx;
    private String lectureTitle;
    private String lectureTeacherId;
    private String teacherName;
    private LocalDateTime lectureRegisterStartedAt;
    private int lectureGradeIdx;
    private String lectureGradeFeedback;
    private String lectureGradeScore;
}
