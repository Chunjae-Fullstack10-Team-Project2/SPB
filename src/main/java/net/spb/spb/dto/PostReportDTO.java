package net.spb.spb.dto;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostReportDTO {
    private String reportIdx;
    private String reportPostIdx;
    private String reportMemberId;
}
