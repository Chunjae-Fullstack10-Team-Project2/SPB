package net.spb.spb.dto.lecture;

import jakarta.validation.constraints.*;
import lombok.*;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LectureReviewDTO {
    @NotNull
    private int lectureReviewIdx;

    @NotNull
    private int lectureReviewRefIdx;

    @NotBlank(message = "내용은 필수 항목입니다.")
    @Size(max = 19000, message = "내용은 19,000자 이하로 입력해주세요.")
    private String lectureReviewContent;

    private String lectureReviewMemberId;

    @NotNull
    @Min(0)
    @Max(5)
    private int lectureReviewGrade;

    private LocalDateTime lectureReviewCreatedAt;
    private LocalDateTime lectureReviewUpdatedAt;
}
