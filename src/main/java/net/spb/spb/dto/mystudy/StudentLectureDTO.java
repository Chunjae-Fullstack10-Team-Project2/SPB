package net.spb.spb.dto.mystudy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StudentLectureDTO {
    private int lectureRegisterIdx;
    private int lectureRegisterRefIdx;
    private String lectureTitle;
    private String teacherName;
    private LocalDateTime lectureRegisterStartedAt;
    private String lectureRegisterStatus;
    private LocalDateTime lectureHistoryLastWatchDate;
    private int lectureProgress;
}
