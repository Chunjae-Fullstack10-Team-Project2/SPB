package net.spb.spb.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class PlanResponseDTO {
    private int planIdx;
    private int planLectureIdx;
    private String lectureTitle;
    private String planContent;
    private LocalDate planDate;
    private LocalDateTime planCreatedAt;
    private LocalDateTime planUpdatedAt;
}
