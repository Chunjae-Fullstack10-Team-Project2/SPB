package net.spb.spb.dto.teacher;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
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

    @NotNull
    private String teacherNoticeTitle;

    @NotNull
    private String teacherNoticeContent;

    private String teacherNoticeMemberId;

    @NotNull
    @Min(0)
    @Max(1)
    private int teacherNoticeFixed;

    private LocalDateTime teacherNoticeCreatedAt;
    private LocalDateTime teacherNoticeUpdatedAt;
}
