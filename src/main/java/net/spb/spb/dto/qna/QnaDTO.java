package net.spb.spb.dto.qna;

import jakarta.validation.constraints.*;
import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class QnaDTO {

    private String qnaIdx;

    @NotBlank(message = "제목은 필수 입력값입니다.")
    @Size(max = 100, message = "제목은 100자 이하여야 합니다.")
    private String qnaTitle;

    @Size(max = 20, message = "작성자 ID는 20자 이하여야 합니다.")
    private String qnaQMemberId;

    @Size(max = 20, message = "답변자 ID는 20자 이하여야 합니다.")
    private String qnaAMemberId;

    @NotBlank(message = "내용은 필수 입력값입니다.")
    @Size(max = 19000, message = "질문 내용은 19,000자 이하여야 합니다.")
    private String qnaQContent;

    @Size(max = 19000, message = "답변 내용은 19,000자 이하여야 합니다.")
    private String qnaAContent;

    private int qnaState;

    private Date qnaCreatedAt;

    private Date qnaAnsweredAt;

    private String qnaQPwd;
}
