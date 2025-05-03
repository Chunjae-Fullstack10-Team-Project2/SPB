package net.spb.spb.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Builder
public class PostDTO {
    private int postIdx;
    private String postTitle;
    private String postContent;
    private String postMemberId;
    private String postCategory;
    private int postReadCnt;
    private LocalDateTime postCreatedAt;
    private LocalDateTime postUpdatedAt;
    private short postState;
    private List<PostCommentDTO> postComments;
    private List<FileDTO> postFiles;
    private int postLikeCnt;
    private boolean isLike;
}
