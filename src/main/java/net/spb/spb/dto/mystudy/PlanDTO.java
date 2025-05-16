package net.spb.spb.dto.mystudy;

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
    private Integer planIdx;
    private int planLectureIdx;
    private String planMemberId;
    private String planContent;
    private LocalDate planDate;
    private LocalDateTime planCreatedAt;
    private LocalDateTime planUpdatedAt;
}
