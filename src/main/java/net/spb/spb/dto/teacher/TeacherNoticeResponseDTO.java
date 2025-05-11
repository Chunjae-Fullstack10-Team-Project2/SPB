package net.spb.spb.dto.teacher;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherNoticeResponseDTO {
    private int teacherNoticeIdx;
    private String teacherNoticeTitle;
    private String teacherNoticeContent;
    private String teacherNoticeMemberId;
    private String teacherName;
    private int teacherNoticeFixed;
    private LocalDateTime teacherNoticeCreatedAt;
    private LocalDateTime teacherNoticeUpdatedAt;
}
