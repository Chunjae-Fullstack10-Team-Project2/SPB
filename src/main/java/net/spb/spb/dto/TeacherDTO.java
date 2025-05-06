package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TeacherDTO {
    private int teacherIdx;
    private String teacherName;
    private String teacherId;
    private String teacherIntro;
    private String teacherSubject;
    private String teacherApproval;
    private String teacherProfileImg;
}
