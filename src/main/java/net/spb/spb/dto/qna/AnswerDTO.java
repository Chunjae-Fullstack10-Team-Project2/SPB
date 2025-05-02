package net.spb.spb.dto.qna;

import jakarta.validation.constraints.NotNull;
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
    private String qnaAContent;
    private Date qnaAnsweredAt;
}
