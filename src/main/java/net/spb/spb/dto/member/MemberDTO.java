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

    @Pattern(regexp = "^[A-Za-z0-9]{4,15}$", message = "아이디는 영문 대소문자와 숫자 조합의 4~15자여야 합니다.")
    private String memberId;

    @Pattern(
            regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$",
            message = "비밀번호는 대소문자와 숫자를 포함한 4~15자여야 합니다."
    )
    private String memberPwd;

    @Pattern(
            regexp = "^[a-zA-Z가-힣]{1,30}$",
            message = "이름은 한글 또는 영어만 입력 가능하며 30자 이하여야 합니다."
    )
    private String memberName;

    @Size(max = 100, message = "주소는 100자 이하여야 합니다.")
    private String memberAddr1;

    @Size(max = 100, message = "상세주소는 100자 이하여야 합니다.")
    private String memberAddr2;

    @Pattern(
            regexp = "^\\d{5}$",
            message = "우편번호는 5자 이하여야 합니다."
    )
    private String memberZipCode;

    @Pattern(
            regexp = "^\\d{8}$",
            message = "생년월일은 YYYYMMDD 형식의 숫자 8자리여야 합니다."
    )
    private String memberBirth;

    private String memberState;

    private String memberGrade;

    @Email(message = "이메일 형식이 올바르지 않습니다.")
    @Size(max = 100, message = "이메일은 100자 이하여야 합니다.")
    private String memberEmail;

    @Pattern(
            regexp = "^01[0-1]\\d{7,8}$",
            message = "휴대전화 번호 형식이 올바르지 않습니다. 예: 01012345678"
    )
    private String memberPhone;

    private String memberJoinPath;

    private int memberIdx;

    private LocalDate memberPwdChangeDate;
    private LocalDate memberCreatedAt;
    private LocalDate memberLastLogin;

    private String memberAgree;

    private String memberProfileImg;
}
