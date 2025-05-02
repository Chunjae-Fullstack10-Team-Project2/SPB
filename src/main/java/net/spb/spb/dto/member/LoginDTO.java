package net.spb.spb.dto.member;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class LoginDTO {

    @NotNull
    @Pattern(regexp = "^[A-Za-z0-9]{4,15}$", message = "아이디는 영문 대소문자와 숫자 조합의 4~15자여야 합니다.")
    private String memberId;

    @NotNull
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$", message = "비밀번호는 대소문자와 숫자를 포함한 4~15자여야 합니다.")
    private String memberPwd;
}
