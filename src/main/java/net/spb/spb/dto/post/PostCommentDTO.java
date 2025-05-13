package net.spb.spb.dto.post;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class PostCommentDTO {
    private int postCommentIdx;
    private int postCommentRefPostIdx;
    private int postCommentParentIdx;
    private String postCommentMemberId;
    @NotBlank(message = "내용을 입력해주세요.")
    @Size(max=3000, message="내용을 3,000자 이내로 입력하세요.")
    private String postCommentContent;
    private LocalDateTime postCommentCreatedAt;
    private LocalDateTime postCommentUpdatedAt;
    private int postCommentState;
    private String postCommentMemberProfileImg;
}
