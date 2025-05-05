package net.spb.spb.domain;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostReportVO {
    private String reportIdx;
    private String reportPostIdx;
    private String reportMemberId;
    private Date reportCreatedAt;
    private String reportState;
}
