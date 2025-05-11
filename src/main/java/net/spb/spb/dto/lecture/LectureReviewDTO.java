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

    @NotBlank
    private String lectureReviewContent;

    private String lectureReviewMemberId;

    @NotNull
    @Min(0)
    @Max(5)
    private int lectureReviewGrade;

    private LocalDateTime lectureReviewCreatedAt;
    private LocalDateTime lectureReviewUpdatedAt;
}
