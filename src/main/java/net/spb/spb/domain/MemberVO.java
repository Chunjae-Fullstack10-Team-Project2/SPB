package net.spb.spb.domain;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class MemberVO {
    private String memberId;
    private String memberPwd;
    private String memberName;
    private String memberAddr1;
    private String memberAddr2;
    private String memberZipCode;
    private String memberBirth;
    private String memberState;
    private String memberGrade;
    private String memberEmail;
    private String memberPhone;
    private int memberIdx;
    private LocalDate memberPwdChangeDate;
    private LocalDate memberCreatedAt;
    private String memberJoinPath;
}
