package net.spb.spb.dto;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostLikeRequestDTO {
    private int postLikeRefIdx;
    private int postIdx;
    private String postLikeRefType;
    private String postLikeMemberId;
}
