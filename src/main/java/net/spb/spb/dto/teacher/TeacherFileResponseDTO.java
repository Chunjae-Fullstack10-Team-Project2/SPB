package net.spb.spb.dto.teacher;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import net.spb.spb.dto.FileDTO;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherFileResponseDTO {
    private int teacherFileIdx;
    private String teacherFileMemberId;
    private String teacherName;
    private String teacherProfileImg;
    private String teacherFileTitle;
    private String teacherFileContent;
    private LocalDateTime teacherFileCreatedAt;
    private LocalDateTime teacherFileUpdatedAt;
    private int teacherFileFileIdx;
    private FileDTO fileDTO;
}
