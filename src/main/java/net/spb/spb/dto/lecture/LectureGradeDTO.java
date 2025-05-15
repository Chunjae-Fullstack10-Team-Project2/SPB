package net.spb.spb.dto.lecture;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class LectureGradeDTO {
    private int lectureGradeIdx;
    @NotNull
    private int lectureGradeRefIdx;
    @NotNull
    private String lectureGradeMemberId;
    @NotNull
    @Positive
    private int lectureGradeScore;
    @Size(max=19000, message = "내용은 19,000자 이하로 입력해주세요.")
    private String lectureGradeFeedback;
    private LocalDateTime lectureGradeCreatedAt;
    private LocalDateTime lectureGradeUpdatedAt;
}
