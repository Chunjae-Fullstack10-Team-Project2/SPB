package net.spb.spb.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
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
    @NotBlank(message="선생님 이름은 필수입니다.")
    @Size(max = 10, message = "선생님 이름은 10자 이하여야 합니다.")
    private String teacherName;
    @NotBlank(message="선생님 아이디는 필수입니다.")
    @Size(max = 20, message = "선생님 아이디는 20자 이하여야 합니다.")
    private String teacherId;
    @NotBlank(message="선생님 소개는 필수입니다.")
    @Size(max = 5000, message = "선생님 소개는 5,000자 이하여야 합니다.")
    private String teacherIntro;
    @NotBlank(message="선생님 담당 과목은 필수입니다.")
    @Size(max = 50, message = "선생님 담당 과목은 50자 이하여야 합니다.")
    private String teacherSubject;
    private int teacherState;
    private String teacherProfileImg;
}
