package net.spb.spb.domain;

import java.time.LocalDateTime;
import java.time.LocalTime;

public class LectureHistoryVO {
    private int lectureHistoryIdx;
    private String lectureHistoryMemberId;
    private int lectureHistoryChapterIdx;
    private LocalTime lectureHistoryLastPosition;
    private LocalTime lectureHistoryWatchTime;
    private LocalDateTime lectureHistoryLastWatchDate;
    private int lectureHistoryCompleted;
}
