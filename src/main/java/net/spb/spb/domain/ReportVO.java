package net.spb.spb.domain;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReportVO {
    private String reportIdx;
    private String reportRefIdx;
    private String reportRefType;
    private String reportMemberId;
    private Date reportCreatedAt;
    private String reportState;
}
