package net.spb.spb.domain;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CartVO {
    private int cartIdx;
    private String cartMemberId;
    private int cartLectureIdx;
}
