package net.spb.spb.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostReportDTO {
    private String reportIdx;
    private String reportPostIdx;
    private String reportMemberId;
    private Date reportCreatedAt;
    private String reportState;

    // tbl_post
    private String postTitle, postMemberId, postContent;
    private LocalDateTime postCreatedAt;
}
