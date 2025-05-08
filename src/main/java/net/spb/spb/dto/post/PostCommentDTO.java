package net.spb.spb.dto.post;

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
    private String postCommentContent;
    private LocalDateTime postCommentCreatedAt;
    private LocalDateTime postCommentUpdatedAt;
    private int postCommentState;
}
