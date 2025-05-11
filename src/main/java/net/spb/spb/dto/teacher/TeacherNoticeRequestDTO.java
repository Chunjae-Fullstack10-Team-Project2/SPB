package net.spb.spb.dto.teacher;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class TeacherNoticeRequestDTO {
    private int teacherNoticeIdx;
    private String teacherNoticeMemberId;
}
