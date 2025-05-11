package net.spb.spb.dto.teacher;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherQnaResponseDTO {
    private int teacherQnaIdx;
    private String teacherQnaTitle;
    private String teacherQnaQContent;
    private String teacherQnaQMemberId;
    private String questionMemberName;
    private String questionMemberProfileImg;
    private LocalDateTime teacherQnaCreatedAt;
    private String teacherQnaAContent;
    private String teacherQnaAMemberId;
    private String answerMemberName;
    private String answerMemberProfileImg;
    private LocalDateTime teacherQnaAnsweredAt;
    private String teacherQnaPwd;
}
