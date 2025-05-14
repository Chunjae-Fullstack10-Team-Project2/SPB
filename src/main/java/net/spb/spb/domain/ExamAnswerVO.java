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
public class ExamAnswerVO {
    private int examAnswerIdx;
    private int examAnswerRefIdx;
    private String examAnswerMemberId;
    private String examAnswerContent;
    private int examAnswerStatus;
    private LocalDateTime examAnswerCreatedAt;
}
