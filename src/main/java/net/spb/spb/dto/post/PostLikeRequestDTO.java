package net.spb.spb.dto.post;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostLikeRequestDTO {
    private int postLikeIdx;
    private int postLikeRefIdx;
    private int postIdx;
    private String postLikeRefType;
    private String postLikeMemberId;
    private Date postLikeCreatedAt;

    // tbl_post
    private String postTitle, postMemberId, postContent;
    private LocalDateTime postCreatedAt;
}
