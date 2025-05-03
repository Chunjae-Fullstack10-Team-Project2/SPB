package net.spb.spb.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class PlanListResponseDTO {
    private int planIdx;
    private int planLectureIdx;
    private String planContent;
    private LocalDate planDate;
}
