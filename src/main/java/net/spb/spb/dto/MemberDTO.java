package net.spb.spb.dto;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class MemberDTO {
    private String memberId;
    private String memberPwd;
    private String memberName;
    private String memberAddr1;
    private String memberAddr2;
    private String memberZipCode;
    private String memberBirth;
    private String memberState;
    private String memberEmail;
    private String memberPhone;
    private int memberIdx;
    private LocalDate memberPwdChangeDate;
    private LocalDate memberRegistDate;
}
