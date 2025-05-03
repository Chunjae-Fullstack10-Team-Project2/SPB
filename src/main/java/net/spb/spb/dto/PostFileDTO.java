package net.spb.spb.dto;

import lombok.*;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public final class PostFileDTO {
    private int postFileIdx;
    private int postFilePostIdx;
    private int postFileFileIdx;
}
