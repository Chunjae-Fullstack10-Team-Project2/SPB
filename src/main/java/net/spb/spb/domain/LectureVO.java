package net.spb.spb.domain;

import lombok.*;
import lombok.extern.log4j.Log4j2;

import java.util.Date;

@Log4j2
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class LectureVO {
    private int lectureIdx;
    private String lectureTitle;
    private String lectureDescription;
    private String lectureTeacherId;
    private Date lectureCreateAt;
    private String lectureThumbnailImg;
    private int lectureAmount;
    private String lectureTeacherName;
}
