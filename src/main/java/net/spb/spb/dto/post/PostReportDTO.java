package net.spb.spb.dto.post;

import lombok.*;
import net.spb.spb.util.ReportRefType;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostReportDTO {
    private String reportIdx;
    private String reportRefIdx;
    private String reportMemberId;
    private Date reportCreatedAt;
    private String reportState;
    private ReportRefType reportRefType;

    // tbl_post
    private String postTitle, postMemberId, postContent;
    private LocalDateTime postCreatedAt;
}
