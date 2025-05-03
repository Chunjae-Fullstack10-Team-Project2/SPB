package net.spb.spb.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.YearMonth;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlanListRequestDTO {
    private String memberId;
    private YearMonth currentMonth;
}
