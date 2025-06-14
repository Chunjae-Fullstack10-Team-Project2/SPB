package net.spb.spb.service.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class MailService {

    private final JavaMailSender mailSender;
    private final Random random = new Random();

    @Autowired
    public MailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public String createVerificationCode() {
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }

    public void sendEmail(String toEmail, String verificationCode) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setFrom("ribbon0508@naver.com");
        message.setSubject("[봄콩이] 인증번호 메일입니다.");
        message.setText(
                "안녕하세요.\n\n" +
                        "요청하신 인증번호는 [" + verificationCode + "] 입니다.\n" +
                        "5분 이내에 입력해주세요.\n\n" +
                        "감사합니다."
        );

        mailSender.send(message);
    }

    public String sendVerificationCode(String toEmail) {
        String code = createVerificationCode();
        sendEmail(toEmail, code);
        return code;
    }

    public String createTemporaryPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        return password.toString();
    }

    public void sendTemporaryPassword(String toEmail, String tempPassword) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setFrom("ribbon0508@naver.com");
        message.setSubject("[봄콩이] 임시 비밀번호 안내");
        message.setText(
                "안녕하세요.\n\n" +
                        "요청하신 임시 비밀번호는 아래와 같습니다.\n\n" +
                        "임시 비밀번호: [" + tempPassword + "]\n\n" +
                        "로그인 후 반드시 비밀번호를 변경해 주세요.\n\n" +
                        "감사합니다."
        );

        mailSender.send(message);
    }

    public String sendTemporaryPasswordToUser(String toEmail) {
        String tempPassword = createTemporaryPassword();
        sendTemporaryPassword(toEmail, tempPassword);
        return tempPassword;
    }
}
