package net.spb.spb.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherFileVO {
    private int teacherFileIdx;
    private String teacherFileMemberId;
    private String teacherFileTitle;
    private String teacherFileContent;
    private LocalDateTime teacherFileCreatedAt;
    private LocalDateTime teacherFileUpdatedAt;
    private int teacherFileFileIdx;
}
