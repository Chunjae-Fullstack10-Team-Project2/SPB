package net.spb.spb.domain;

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
public class PlanVO {
    private int planIdx;
    private int planLectureIdx;
    private String lectureTitle;
    private String planMemberId;
    private String planContent;
    private LocalDate planDate;
    private int planState;
    private LocalDateTime planCreatedAt;
    private LocalDateTime planUpdatedAt;
}
