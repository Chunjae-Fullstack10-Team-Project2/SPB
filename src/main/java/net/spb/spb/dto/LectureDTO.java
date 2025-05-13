package net.spb.spb.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;
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
    @NotBlank(message = "강좌 제목은 필수입니다.")
    @Size(max=50, message="강좌 제목은 50자 이하여야 합니다. ")
    private String lectureTitle;
    private String lectureDescription;
    @NotBlank(message = "선생님 선택은 필수입니다.")
    @Size(max=20, message="선생님 아이디는 20자 이하여야 합니다. ")
    private String lectureTeacherId;
    private Date lectureCreatedAt;
    private String lectureThumbnailImg;
    private int lectureAmount;
    private int lectureState;
    private String lectureTeacherName;
    private int lectureChapterCount;
    private String lectureSubject;
}