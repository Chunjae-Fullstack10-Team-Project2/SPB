package net.spb.spb.domain;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookmakrVO {
    private int bookmakrIdx;
    private int bookmarkLectureIdx;
    private String bookmarkMemberId;
}
