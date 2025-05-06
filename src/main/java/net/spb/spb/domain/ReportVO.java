package net.spb.spb.domain;

import lombok.*;
import net.spb.spb.util.ReportRefType;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReportVO {
    private String reportIdx;
    private String reportRefIdx;
    private ReportRefType reportRefType;
    private String reportMemberId;
    private Date reportCreatedAt;
    private String reportState;
}
