package net.spb.spb.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import lombok.extern.log4j.Log4j2;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Log4j2
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LectureHistoryDTO {
    private int lectureIdx;
    private int lectureHistoryIdx;
    private String lectureMemberId;
    private int lectureHistoryChapterIdx;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss")
    private LocalTime lectureHistoryLastPosition;

    private LocalTime lectureHistoryWatchTime;
    private LocalDateTime lectureHistoryLastWatchDate;
    private boolean lectureHistoryCompleted;
}
