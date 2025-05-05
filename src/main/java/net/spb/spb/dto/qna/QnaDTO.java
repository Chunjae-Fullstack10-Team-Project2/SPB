package net.spb.spb.dto.qna;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import lombok.*;

import jakarta.validation.constraints.NotNull;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class QnaDTO {

    private String qnaIdx;

    private String qnaTitle;

    @NotNull
    private String qnaQMemberId;

    private String qnaAMemberId;

    @NotNull
    private String qnaQContent;

    private String qnaAContent;

    @NotNull
    private int qnaState;

    private Date qnaCreatedAt;

    private Date qnaAnsweredAt;

//    @Pattern(regexp = "^\\d{4}$", message = "비밀번호는 숫자 4자리여야 합니다.")
//    @Nullable
    private String qnaQPwd;
}

