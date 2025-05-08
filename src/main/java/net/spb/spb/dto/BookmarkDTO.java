package net.spb.spb.dto;

import lombok.*;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookmarkDTO {
    private int bookmakrIdx;
    private int bookmarkLectureIdx;
    private String bookmarkMemberId;
}
