package net.spb.spb.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class ExamReportVO {
    private int examReportIdx;
    private int examReportRefIdx;
    private String examReportMemberId;
    private int examReportScore;
    private String examReportFeedback;
    private LocalDateTime examReportCreatedAt;
    private LocalDateTime examReportUpdatedAt;
}
