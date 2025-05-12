package net.spb.spb.dto.teacher;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class TeacherQnaDTO {
    private int teacherQnaIdx;
    private String teacherQnaTitle;
    private String teacherQnaQContent;
    private String teacherQnaQMemberId;
    private LocalDateTime teacherQnaCreatedAt;
    private String teacherQnaAContent;
    private String teacherQnaAMemberId;
    private LocalDateTime teacherQnaAnsweredAt;
    private String teacherQnaPwd;
}
