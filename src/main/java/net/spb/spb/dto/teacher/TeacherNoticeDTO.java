package net.spb.spb.dto.teacher;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
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
public class TeacherNoticeDTO {
    @NotNull
    private int teacherNoticeIdx;

    @NotNull(message="제목은 필수 항목입니다.")
    @Size(min=1, max=50, message="제목은 1자 이상 50자 이하로 입력해주세요.")
    private String teacherNoticeTitle;

    @NotNull(message = "내용은 필수 항목입니다.")
    private String teacherNoticeContent;

    private String teacherNoticeMemberId;

    @Min(0)
    @Max(1)
    private int teacherNoticeFixed;

    private LocalDateTime teacherNoticeCreatedAt;
    private LocalDateTime teacherNoticeUpdatedAt;
}
