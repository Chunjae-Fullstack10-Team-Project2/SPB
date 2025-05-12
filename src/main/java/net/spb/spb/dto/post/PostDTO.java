package net.spb.spb.dto.post;

import lombok.*;
import net.spb.spb.dto.FileDTO;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import jakarta.validation.constraints.*;
import net.spb.spb.util.ReportRefType;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Builder
public class PostDTO {
    private int postIdx;
    @NotBlank(message="제목은 필수입니다.")
    @Size(max = 50, message = "제목은 1자 이상 50자 이하로 입력해주세요.")
    private String postTitle;
    @NotBlank(message="내용은 필수입니다.")
    @Size(max = 20000, message = "내용은 20,000자 이하로 입력해주세요.")
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
    private String memberProfileImg;
    private int postReportCnt;
    private String memberName;

    private String reportIdx;
    private String reportRefIdx;
    private String reportMemberId;
    private Date reportCreatedAt;
    private Integer reportState;
    private ReportRefType reportRefType;
    private String reportCount;
}
