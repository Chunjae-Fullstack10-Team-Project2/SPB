package net.spb.spb.domain;

import lombok.*;

import jakarta.validation.constraints.NotNull;
import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class QnaVO {
    @NotNull
    private String qnaIdx;
    @NotNull
    private String qnaQMemberId;
    @NotNull
    private String qnaQContent;
    @NotNull
    private String qnaTitle;
    @NotNull
    private String qnaAMemberId;
    private String qnaAContent;
    @NotNull
    private int qnaState;
    @NotNull
    private Date qnaCreatedAt;
    private Date qnaAnsweredAt;
    private int qnaQPwd;
}
