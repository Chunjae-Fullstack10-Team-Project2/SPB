package net.spb.spb.domain;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Builder
public class PostVO {
    private int postIdx;
    private String postTitle;
    private String postContent;
    private String postMemberId;
    private String postCategory;
    private int postReadCnt;
    private LocalDateTime postCreatedAt;
    private LocalDateTime postUpdatedAt;
    private short postState;
}
