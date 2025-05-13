package net.spb.spb.dto.qna;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.*;
import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class QnaDTO {

    private String qnaIdx;

    @Size(max = 19000, message = "제목은 19,000자 이하여야 합니다.")
    private String qnaTitle;

    @NotNull
    private String qnaQMemberId;

    private String qnaAMemberId;

    @NotNull
    @Size(max = 19000, message = "질문 내용은 19,000자 이하여야 합니다.")
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

