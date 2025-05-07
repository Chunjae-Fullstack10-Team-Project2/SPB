package net.spb.spb.dto;

import lombok.*;
import net.spb.spb.domain.NoticeVO;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class NoticeDTO {
    private int noticeIdx;
    private String noticeTitle;
    private String noticeContent;
    private String noticeMemberId;
    private Boolean noticeIsFixed;
    private LocalDateTime noticeCreatedAt;
    private LocalDateTime noticeUpdatedAt;

    public NoticeDTO(NoticeVO vo) {
        this.noticeIdx = vo.getNoticeIdx();
        this.noticeTitle = vo.getNoticeTitle();
        this.noticeContent = vo.getNoticeContent();
        this.noticeMemberId = vo.getNoticeMemberId();
        this.noticeIsFixed = vo.getNoticeIsFixed();
        this.noticeCreatedAt = vo.getNoticeCreatedAt();
        this.noticeUpdatedAt = vo.getNoticeUpdatedAt();
    }

    public NoticeVO toVO() {
        return NoticeVO.builder()
                .noticeIdx(this.noticeIdx)
                .noticeTitle(this.noticeTitle)
                .noticeContent(this.noticeContent)
                .noticeMemberId(this.noticeMemberId)
                .noticeIsFixed(this.noticeIsFixed)
                .noticeCreatedAt(this.noticeCreatedAt)
                .noticeUpdatedAt(this.noticeUpdatedAt)
                .build();
    }
}
