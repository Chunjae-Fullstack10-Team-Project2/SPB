package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

import java.time.LocalDateTime;
import java.util.Date;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookmarkDTO {
    private int bookmarkIdx;
    private int bookmarkLectureIdx;
    private String bookmarkMemberId;
    private int bookmarkState;
    private Date bookmarkCreatedAt;

    // tbl_lecture
    private int lectureIdx;
    private String lectureTitle;
    private String lectureDescription;
    private String lectureTeacherId;
    private Date lectureCreatedAt;
    private String lectureThumbnailImg;
    private int lectureAmount;
    private String lectureTeacherName;
    private int lectureChapterCount;
    private int lectureState;

    // tbl_teacher
    private int teacherIdx;
    private String teacherName;
    private String teacherId;
    private String teacherIntro;
    private String teacherSubject;
    private int teacherState;
    private String teacherProfileImg;
}
