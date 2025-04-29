package net.spb.spb.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PlanDTO {
    private int planIdx;
    private int planLectureIdx;
    private String planMemberId;
    private String planContent;
    private LocalDate planDate;
    private int planState;
    private LocalDateTime planCreatedAt;
    private LocalDateTime planUpdatedAt;
}
