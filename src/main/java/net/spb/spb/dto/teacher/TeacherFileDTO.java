package net.spb.spb.dto.teacher;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherFileDTO {
    private int teacherFileIdx;
    private String teacherFileMemberId;

    @NotBlank(message="제목은 필수입니다.")
    @Size(max = 50, message = "제목은 1자 이상 50자 이하로 입력해주세요.")
    private String teacherFileTitle;

    @Size(max = 19000, message = "내용은 19,000자 이하로 입력해주세요.")
    private String teacherFileContent;

    private LocalDateTime teacherFileCreatedAt;
    private LocalDateTime teacherFileUpdatedAt;

    private int teacherFileFileIdx;
}
