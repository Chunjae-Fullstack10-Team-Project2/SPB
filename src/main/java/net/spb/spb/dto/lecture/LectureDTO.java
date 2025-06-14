package net.spb.spb.dto.lecture;

import jakarta.validation.constraints.*;
import lombok.*;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.util.StringEscapeUtils;

import java.time.LocalDate;

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

    @NotBlank(message="강좌 설명은 필수입니다.")
    @Size(max=100, message="강좌 설명은 100자 이하여야 합니다.")
    private String lectureDescription;

    @NotBlank(message = "선생님 선택은 필수입니다.")
    @Size(max=20, message="선생님 아이디는 20자 이하여야 합니다. ")
    private String lectureTeacherId;

    private LocalDate lectureCreatedAt;
    private String lectureThumbnailImg;

    @Max(value=50000000, message="강좌 금액은 최대 5,000,000원 입니다.")
    private int lectureAmount;

    private int lectureState;
    private String lectureTeacherName;
    private int lectureChapterCount;
    private String lectureSubject;

    public String getLectureTitle() {
        return lectureTitle == null ? null : StringEscapeUtils.unescapeHtml4(lectureTitle);
    }

    public String getLectureDescription() {
        return lectureDescription == null ? null : StringEscapeUtils.unescapeHtml4(lectureDescription);
    }
}
