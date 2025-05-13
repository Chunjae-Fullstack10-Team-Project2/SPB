package net.spb.spb.dto.teacher;

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
public class TeacherFileDTO {
    private int teacherFileIdx;
    private String teacherFileMemberId;

    @NotNull
    @Size(min=1, max=50)
    private String teacherFileTitle;

    private String teacherFileContent;

    private LocalDateTime teacherFileCreatedAt;
    private LocalDateTime teacherFileUpdatedAt;

    private int teacherFileFileIdx;
}
