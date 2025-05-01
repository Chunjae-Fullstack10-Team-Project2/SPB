package net.spb.spb.domain;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class TeacherVO {
    private int teacherIdx;
    private String teacherName;
    private String teacherId;
    private String teacherIntro;
    private String teacherSubject;
    private String teacherApproval;
    private String teacherProfileImg;
}
