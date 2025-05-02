package net.spb.spb.dto.member;

import lombok.*;
import jakarta.validation.constraints.*;
import java.time.LocalDate;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@ToString
public class MemberDTO {
    @NotNull
    @Pattern(regexp = "^[A-Za-z0-9]{4,15}$", message = "아이디는 영문 대소문자와 숫자 조합의 4~15자여야 합니다.")
    private String memberId;

    @NotNull
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$", message = "비밀번호는 대소문자와 숫자를 포함한 4~15자여야 합니다.")
    private String memberPwd;

    @NotNull
    private String memberName;

    @NotNull
    private String memberAddr1;

    @NotNull
    private String memberAddr2;

    private String memberZipCode;

    @NotNull
    @Pattern(regexp = "^\\d{8}$", message = "생년월일은 YYYYMMDD 형식이어야 합니다.")
    private String memberBirth;

    private String memberState;

    @NotNull
    private String memberGrade;

    @NotNull
    private String memberEmail;

    @NotNull
    @Pattern(regexp = "^01[0-1]\\d{7,8}$", message = "휴대전화 번호 형식이 올바르지 않습니다.")
    private String memberPhone;
    private String memberJoinPath;

    private int memberIdx;

    private LocalDate memberPwdChangeDate;
    private LocalDate memberCreatedAt;
}
