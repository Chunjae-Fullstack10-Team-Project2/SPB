package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

import java.util.Date;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LectureDTO {
    private int lectureIdx;
    private String lectureTitle;
    private String lectureDescription;
    private String lectureTeacherId;
    private Date lectureCreateAt;
    private String lectureThumbnailImg;
    private int lectureAmount;
}
