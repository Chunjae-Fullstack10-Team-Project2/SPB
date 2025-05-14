package net.spb.spb.dto.teacher;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherQnaQuestionDTO {
    @NotBlank(message="제목은 필수 항목입니다.")
    @Size(max=50, message="제목은 1자 이상 50자 이하로 입력해주세요.")
    private String teacherQnaTitle;
    @NotBlank(message = "내용은 필수 항목입니다.")
    @Size(max = 20000, message = "내용은 20,000자 이하로 입력해주세요.")
    private String teacherQnaQContent;
    private String teacherQnaQMemberId;
    private String teacherQnaAMemberId;
    @Pattern(regexp = "^\\d{4}$", message = "비밀번호는 숫자 4자리여야 합니다.")
    private String teacherQnaPwd;
}
