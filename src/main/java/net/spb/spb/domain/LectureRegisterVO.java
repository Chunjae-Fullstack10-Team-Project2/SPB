package net.spb.spb.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LectureRegisterVO {
    private int lectureRegisterIdx;
    private String lectureRegisterMemberId;
    private int lectureRegisterRefIdx;
    private LocalDateTime lectureRegisterStartedAt;
    private int lectureRegisterStatus;
}
