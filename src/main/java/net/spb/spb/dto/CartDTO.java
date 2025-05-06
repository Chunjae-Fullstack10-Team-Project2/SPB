package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

import java.util.List;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CartDTO {
    private int cartIdx;
    private String cartMemberId;
    private int cartLectureIdx;
    private String lectureTitle;
    private String lectureTeacherId;
    private int lectureAmount;
    private List<Integer> selectCartItemIds;
}
