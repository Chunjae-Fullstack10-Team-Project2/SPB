package net.spb.spb.dto.teacher;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class TeacherQnaAnswerDTO {
    @NotNull
    private int teacherQnaIdx;
    @NotBlank(message = "내용은 필수 항목입니다.")
    @Size(max = 19000, message = "내용은 19,000자 이하로 입력해주세요.")
    private String teacherQnaAContent;
    private String teacherQnaAMemberId;
}
