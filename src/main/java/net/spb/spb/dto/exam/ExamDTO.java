package net.spb.spb.dto.exam;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class ExamDTO {
    private int examIdx;
    @NotNull
    private int examLectureIdx;
    @NotBlank(message="제목은 필수입니다.")
    @Size(max=50, message="제목은 1자 이상 50자 이하로 입력해주세요.")
    private String examTitle;
    @Size(max=19000, message="내용은 19,000자 이하로 입력해주세요.")
    private String examDescription;
    private LocalDateTime examCreatedAt;
    private LocalDateTime examUpdatedAt;
}
