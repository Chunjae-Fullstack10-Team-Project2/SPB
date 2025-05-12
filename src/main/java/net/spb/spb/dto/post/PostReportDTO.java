package net.spb.spb.dto.post;

import lombok.*;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.util.ReportRefType;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

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
    private Integer reportState;
    private ReportRefType reportRefType;
    private String reportCount;

    // tbl_post
    private int postIdx;
    private String postTitle;
    private String postContent;
    private String postMemberId;
    private String postCategory;
    private int postReadCnt;
    private LocalDateTime postCreatedAt;
    private LocalDateTime postUpdatedAt;
    private short postState;
    private List<PostCommentDTO> postComments;
    private List<FileDTO> postFiles;
    private int postLikeCnt;
    private boolean isLike;

    // tbl_lecture_review
    private int lectureReviewIdx;
    private int lectureReviewRefIdx;
    private String lectureReviewContent;
    private String lectureReviewMemberId;
    private int lectureReviewGrade;
    private LocalDateTime lectureReviewCreatedAt;
    private LocalDateTime lectureReviewUpdatedAt;
    private int lectureReviewState;
}
