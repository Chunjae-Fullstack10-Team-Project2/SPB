package net.spb.spb.domain;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public final class PostFileVO {
    private int postFileIdx;
    private int postFilePostIdx;
    private int postFileFileIdx;
}
