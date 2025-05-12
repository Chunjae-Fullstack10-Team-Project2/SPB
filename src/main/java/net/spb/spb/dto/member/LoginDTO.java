package net.spb.spb.dto.member;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class LoginDTO {

    @NotBlank(message = "아이디를 입력해주세요.")
    @Pattern(regexp = "^[A-Za-z0-9]{4,15}$", message = "아이디 형식이 올바르지 않습니다.")
    private String memberId;

    @NotBlank(message = "비밀번호를 입력해주세요.")
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$", message = "비밀번호 형식이 올바르지 않습니다.")
    private String memberPwd;
}
