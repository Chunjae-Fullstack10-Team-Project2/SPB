package net.spb.spb.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class FaqDTO {

    private String faqIdx;

    @NotBlank(message = "질문 내용을 입력해주세요.")
    @Size(max = 19000, message = "질문은 19,000자 이하여야 합니다.")
    private String faqQuestion;

    @NotBlank(message = "답변 내용을 입력해주세요.")
    @Size(max = 19000, message = "답변은 19,000자 이하여야 합니다.")
    private String faqAnswer;

    private Date faqCreatedAt;

    private Date faqUpdatedAt;

    private String faqState;
}