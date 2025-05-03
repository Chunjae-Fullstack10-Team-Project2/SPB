package net.spb.spb.dto.qna;

import lombok.*;

import jakarta.validation.constraints.NotNull;
import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class QnaDTO {
    @NotNull
    private String qnaIdx;
    @NotNull
    private String qnaQMemberId;
    private String qnaAMemberId;
    @NotNull
    private String qnaQContent;
    @NotNull
    private String qnaTitle;
    private String qnaAContent;
    @NotNull
    private int qnaState;
    @NotNull
    private Date qnaCreatedAt;
    private Date qnaAnsweredAt;
}
