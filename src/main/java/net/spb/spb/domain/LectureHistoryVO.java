package net.spb.spb.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LectureHistoryVO {
    private int lectureHistoryIdx;
    private String lectureHistoryMemberId;
    private int lectureHistoryChapterIdx;
    private LocalTime lectureHistoryLastPosition;
    private LocalTime lectureHistoryWatchTime;
    private LocalDateTime lectureHistoryLastWatchDate;
    private int lectureHistoryCompleted;
}
