package net.spb.spb.dto.qna;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AnswerDTO {
    @NotNull
    private String qnaAMemberId;
    @NotNull
    @Size(max = 19000, message = "답변 내용은 19,000자 이하여야 합니다.")
    private String qnaAContent;
    private Date qnaAnsweredAt;
}
