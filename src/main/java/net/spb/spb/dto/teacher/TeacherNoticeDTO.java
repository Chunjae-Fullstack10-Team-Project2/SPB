package net.spb.spb.dto.teacher;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherNoticeDTO {
    @NotNull
    private int teacherNoticeIdx;

    @NotBlank(message="제목은 필수 항목입니다.")
    @Size(max=50, message="제목은 1자 이상 50자 이하로 입력해주세요.")
    private String teacherNoticeTitle;

    @NotBlank(message = "내용은 필수 항목입니다.")
    @Size(max = 19000, message = "내용은 19,000자 이하로 입력해주세요.")
    private String teacherNoticeContent;

    private String teacherNoticeMemberId;

    @Min(0)
    @Max(1)
    private int teacherNoticeFixed;

    private LocalDateTime teacherNoticeCreatedAt;
    private LocalDateTime teacherNoticeUpdatedAt;
}
