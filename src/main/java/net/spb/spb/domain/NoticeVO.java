package net.spb.spb.domain;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Builder
public class NoticeVO {
    private int noticeIdx;
    private String noticeTitle;
    private String noticeContent;
    private String noticeMemberId;
    private Boolean noticeIsFixed;
    private LocalDateTime noticeCreatedAt;
    private LocalDateTime noticeUpdatedAt;
}