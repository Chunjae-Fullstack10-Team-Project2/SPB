package net.spb.spb.dto.mystudy;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class PlanDetailResponseDTO {
    private int planIdx;
    private int planLectureIdx;
    private String lectureTitle;
    private String planMemberId;
    private String planContent;
    private LocalDate planDate;
    private LocalDateTime planCreatedAt;
    private LocalDateTime planUpdatedAt;
}
