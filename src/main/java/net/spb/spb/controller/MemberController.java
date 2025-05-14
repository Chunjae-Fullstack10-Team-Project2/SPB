package net.spb.spb.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import net.spb.spb.dto.member.LoginDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.service.member.MailService;
import net.spb.spb.service.member.MemberServiceImpl;
import net.spb.spb.service.member.NaverLoginService;
import net.spb.spb.util.FileUtil;
import net.spb.spb.util.PasswordUtil;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;

import jakarta.validation.Valid;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@Log4j2
public class MemberController {

    @Autowired(required = false)
    private FileUtil fileUtil;

    @Value("${app.upload.path}")
    private String uploadBasePath;

    @Autowired(required = false)
    private MemberServiceImpl memberService;

    @Autowired
    private NaverLoginService naverLoginService;

    @Autowired
    private MailService mailService;

    @Autowired
    private ModelMapper modelMapper;

    @GetMapping(path = {"/", "/main"})
    public String main(HttpServletRequest request, HttpSession session) {
        Cookie[] cookies = request.getCookies();
        String autoLoginId = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("autoLogin".equals(cookie.getName())) {
                    autoLoginId = cookie.getValue();
                    break;
                }
            }
        }

        if (autoLoginId != null && memberService.existMember(autoLoginId)) {
            session.setAttribute("memberId", autoLoginId);
        }

        String memberId = (String) session.getAttribute("memberId");
        if (memberId != null) {
            MemberDTO memberDTO = memberService.getMemberById(memberId);
            session.setAttribute("memberGrade", memberDTO.getMemberGrade());
            session.setAttribute("memberDTO", memberDTO);

            return "common/loginMain";
        }

        return "common/main";
    }

    @PostMapping("/updatePwdChangeDate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updatePwdChangeDate(@RequestBody Map<String, String> requestData) {
        String memberId = requestData.get("memberId");

        MemberDTO memberDTO = memberService.getMemberById(memberId);
        if (memberDTO != null) {
            String now = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            boolean updatedDate = memberService.updateMemberPwdChangeDateWithLogin(now, memberId);
            boolean updatedState = memberService.updateMemberStateWithLogin("1", memberId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", updatedDate && updatedState);
            return ResponseEntity.ok(response);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/email/reactivate")
    @ResponseBody
    public void reactivateAccount(@RequestBody MemberDTO memberDTO) {
        String memberId = memberDTO.getMemberId();

        memberService.updateMemberStateWithLogin("1", memberId);
        //memberService.updateMemberPwdChangeDateWithLogin(LocalDate.now().toString(), memberId);
        memberService.updateMemberLastLoginWithLogin(LocalDate.now().toString(), memberId);
    }

    @GetMapping("/naver/callback")
    public String naverCallback(@RequestParam("code") String code,
                                @RequestParam("state") String state,
                                HttpSession session) throws Exception {

        String accessToken = naverLoginService.getAccessToken(code, state);
        MemberDTO naverMemberDto = naverLoginService.getUserInfo(accessToken);
        String naverMemberId = naverMemberDto.getMemberId();

        if (!memberService.existMember(naverMemberId)) {
            session.setAttribute("memberDTO", naverMemberDto);
            return "redirect:/join";
        }

        MemberDTO memberDTO = memberService.getMemberById(naverMemberId);
        LocalDate now = LocalDate.now();

        if (memberDTO.getMemberLastLogin() != null) {
            long daysSinceLogin = ChronoUnit.DAYS.between(memberDTO.getMemberLastLogin(), now);
            if (daysSinceLogin >= 365) {
                memberService.updateMemberStateWithLogin("5", memberDTO.getMemberId());
                memberDTO.setMemberState("5");
            }
        }

        if (memberDTO.getMemberPwdChangeDate() != null) {
            long daysSincePwd = ChronoUnit.DAYS.between(memberDTO.getMemberPwdChangeDate(), now);
            if (daysSincePwd >= 90) {
                memberService.updateMemberStateWithLogin("3", memberDTO.getMemberId());
                memberDTO.setMemberState("3");
            }
        }

        if ("1".equals(memberDTO.getMemberState())) {
            memberService.updateMemberLastLoginWithLogin(now.toString(), memberDTO.getMemberId());
        }

        session.setAttribute("memberId", naverMemberId);
        session.setAttribute("memberGrade", memberDTO.getMemberGrade());
        session.setAttribute("memberDTO", memberDTO);

        return "redirect:/main";
    }

    @GetMapping("/login")
    public String login(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        if (session.getAttribute("memberId") != null) {
            String action = request.getParameter("action");
            if (action != null && action.equals("logout")) {
                request.getSession().invalidate();

                Cookie autoLoginCookie = new Cookie("autoLogin", null);
                autoLoginCookie.setMaxAge(0);
                autoLoginCookie.setPath("/");
                response.addCookie(autoLoginCookie);

                return "redirect:/login";
            }
        }
        return "login/login";
    }

    @PostMapping("/login")
    public String login(@Valid @ModelAttribute LoginDTO loginDTO, BindingResult bindingResult,
                        @RequestParam(value = "checkIdSave", required = false) String checkIdSave,
                        @RequestParam(value = "checkAutoLogin", required = false) String checkAutoLogin,
                        HttpServletResponse response,
                        HttpSession session,
                        Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("errorMessage", "아이디 혹은 비밀번호를 확인해주세요.");
            return "login/login";
        }

        String memberId = loginDTO.getMemberId();
        String memberPwd = loginDTO.getMemberPwd();

        if (!memberId.matches("^[A-Za-z0-9]{4,15}$")) {
            model.addAttribute("errorMessage", "아이디 형식이 올바르지 않습니다.");
            return "login/login";
        }

        if (!memberPwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$")) {
            model.addAttribute("errorMessage", "비밀번호 형식이 올바르지 않습니다.");
            return "login/login";
        }

        MemberDTO memberDTO = modelMapper.map(loginDTO, MemberDTO.class);

        try {
            String encryptedPassword = PasswordUtil.encryptPassword(memberPwd);
            memberDTO.setMemberPwd(encryptedPassword);
        } catch (NoSuchAlgorithmException e) {
            model.addAttribute("errorMessage", "비밀번호 암호화 중 오류가 발생했습니다.");
            return "login/login";
        }

        int returnValue = memberService.login(memberDTO);

        if (returnValue == 1) {
            MemberDTO fullMember = memberService.getMemberById(memberDTO.getMemberId());
            LocalDate now = LocalDate.now();

            if (fullMember.getMemberLastLogin() != null) {
                long daysSinceLogin = ChronoUnit.DAYS.between(fullMember.getMemberLastLogin(), now);
                if (daysSinceLogin >= 365) {
                    memberService.updateMemberStateWithLogin("5", fullMember.getMemberId());
                    fullMember.setMemberState("5");
                }
            }

            if (fullMember.getMemberPwdChangeDate() != null) {
                long daysSincePwd = ChronoUnit.DAYS.between(fullMember.getMemberPwdChangeDate(), now);
                if (daysSincePwd >= 90) {
                    memberService.updateMemberStateWithLogin("3", fullMember.getMemberId());
                    fullMember.setMemberState("3");
                }
            }

            if ("1".equals(fullMember.getMemberState())) {
                memberService.updateMemberLastLoginWithLogin(now.toString(), fullMember.getMemberId());
            }

            session.setAttribute("memberId", fullMember.getMemberId());
            session.setAttribute("memberGrade", fullMember.getMemberGrade());
            session.setAttribute("memberDTO", fullMember);

            // 아이디 저장 쿠키
            Cookie idCookie = new Cookie("saveId", checkIdSave != null ? fullMember.getMemberId() : null);
            idCookie.setMaxAge(checkIdSave != null ? 60 * 60 * 24 : 0);
            idCookie.setPath("/");
            response.addCookie(idCookie);

            // 자동 로그인 쿠키
            Cookie autoCookie = new Cookie("autoLogin", checkAutoLogin != null ? fullMember.getMemberId() : null);
            autoCookie.setMaxAge(checkAutoLogin != null ? 60 * 60 * 24 : 0);
            autoCookie.setPath("/");
            response.addCookie(autoCookie);

            return "redirect:/main";
        } else {
            model.addAttribute("errorMessage", "아이디 또는 비밀번호를 확인해주세요.");
            return "login/login";
        }
    }

    @GetMapping("join")
    public String join(HttpSession session, Model model) {
        MemberDTO naverMemberDto = (MemberDTO) session.getAttribute("memberDTO");

        if (naverMemberDto != null) {
            model.addAttribute("memberDTO", naverMemberDto);
//            이걸 안 하면 네이버 로그인->회원가입에서 다시 join으로 새로 들어갔을 때 비어 있는 폼이 아닌 네이버 정보가 들어가 있는 폼이 또 나옴
//            근데 하면 네이버 로그인->회원가입에서 새로고침 하면 네이버 정보가 다 사라짐...ㅜ
            session.removeAttribute("memberDTO");
        }
        return "login/join";
    }

    @PostMapping("/checkIdDuplicate")
    @ResponseBody
    public Map<String, Object> checkIdDuplicate(@RequestBody Map<String, String> requestBody, HttpSession session) {
        String memberId = requestBody.get("memberId");

        Map<String, Object> result = new HashMap<>();

        String idRegex = "^[a-zA-Z0-9]{4,20}$";
        if (memberId == null || !memberId.matches(idRegex)) {
            result.put("success", false);
            result.put("message", "아이디는 4~20자, 알파벳과 숫자만 가능합니다.");
            return result;
        }

        boolean existMember = memberService.existMember(memberId);
        if (existMember) {
            result.put("success", false);
            result.put("message", "이미 존재하는 아이디입니다.");
        } else {
            result.put("success", true);
            result.put("message", "사용 가능한 아이디입니다.");
            session.setAttribute("checkedMemberId", memberId);
            session.setAttribute("idDuplicateCheck", true);
        }

        return result;
    }

    @PostMapping("/email/verify")
    @ResponseBody
    public Map<String, Object> verifyEmail(@RequestBody MemberDTO memberDTO, HttpSession session) {
        String memberEmail = memberDTO.getMemberEmail();
        Map<String, Object> result = new HashMap<>();

        if (memberEmail != null && !memberEmail.isEmpty()) {
            // 인증 시도 횟수와 마지막 시도 시간 가져오기
            Integer emailTryCount = (Integer) session.getAttribute("emailTryCount");
            Long lastTryTime = (Long) session.getAttribute("lastEmailTryTime");
            long now = System.currentTimeMillis();

            // 인증 횟수 3회 초과 && 10분 이내 재시도인 경우애눈 여전히 차단
            if (emailTryCount != null && emailTryCount >= 3) {
                if (lastTryTime != null && now - lastTryTime < 10 * 60 * 1000) {
                    result.put("success", false);
                    result.put("message", "이메일 인증 시도 횟수를 초과했습니다. 10분 후 다시 시도해주세요.");
                    return result;
                } else {
                    // 10분 지났으면 초기화
                    emailTryCount = 0;
                }
            }

            // 인증 코드 생성 및 이메일 전송
            String code = mailService.sendVerificationCode(memberEmail);
            session.setAttribute("emailAuthCode", code);
            session.setAttribute("memberEmail", memberEmail);
            session.setAttribute("emailVerified", false);
            session.setAttribute("emailAuthTime", now);

            // 횟수 증가 및 시간 저장
            session.setAttribute("emailTryCount", emailTryCount == null ? 1 : emailTryCount + 1);
            session.setAttribute("lastEmailTryTime", now);

            result.put("success", true);
            result.put("message", "인증 코드가 전송되었습니다.");
            result.put("emailTryCount", emailTryCount == null ? 1 : emailTryCount + 1);
        } else {
            result.put("success", false);
            result.put("message", "이메일을 입력해주세요.");
        }

        session.setAttribute("memberDTO", memberDTO);
        return result;
    }

    @PostMapping("/email/codeCheck")
    @ResponseBody
    public Map<String, Object> checkEmailCode(@RequestBody Map<String, String> data, HttpSession session) {
        String memberEmailCode = data.get("memberEmailCode");
        String memberEmail = data.get("memberEmail");

        String sessionCode = (String) session.getAttribute("emailAuthCode");
        Long authTime = (Long) session.getAttribute("emailAuthTime");
        Map<String, Object> result = new HashMap<>();

        long currentTime = System.currentTimeMillis();
        long fiveMinutesInMillis = 5 * 60 * 1000;

        if (authTime == null || (currentTime - authTime) > fiveMinutesInMillis) {
            session.removeAttribute("emailVerified");
            session.removeAttribute("emailAuthCode");
            session.removeAttribute("emailTryCount");
            session.removeAttribute("lastEmailTryTime");
            result.put("success", false);
            result.put("message", "인증 시간이 만료되었습니다. 다시 시도해주세요.");
            return result;
        }

        if (sessionCode != null && sessionCode.equals(memberEmailCode)) {
            result.put("success", true);
            session.setAttribute("emailVerified", true);
            session.removeAttribute("emailTryCount");
            session.removeAttribute("lastEmailTryTime");
            session.removeAttribute("emailAuthCode");
            session.removeAttribute("emailAuthTime");
        } else {
            result.put("success", false);
            result.put("message", "인증 코드가 일치하지 않습니다.");
        }

        return result;
    }

    @PostMapping("/join")
    public String join(@Valid @ModelAttribute MemberDTO memberDTO, BindingResult bindingResult,
                       @RequestParam(value = "profileImgFile", required = false) MultipartFile profileImg,
                       HttpServletRequest request, HttpSession session, Model model) {
        if (!"2".equals(memberDTO.getMemberJoinPath()) && bindingResult.hasErrors()) {
            for (FieldError error : bindingResult.getFieldErrors()) {
                System.out.println("필드: " + error.getField() + " / 메시지: " + error.getDefaultMessage());
            }
            model.addAttribute("errorMessage", "회원가입 중 오류가 발생했습니다. 관리자에게 문의하세요.");
            return "login/join";
        }

        // memberGrade가 13 또는 0이면 14로 변경 -> 관리자가 승인해줘야 함
        if (memberDTO.getMemberGrade().equals("13") || memberDTO.getMemberGrade().equals("0")) {
            memberDTO.setMemberGrade("14");
        }

        String sessionMemberId = (String) session.getAttribute("checkedMemberId");
        String inputMemberId = request.getParameter("memberId");
        if (sessionMemberId != null && !sessionMemberId.equals(inputMemberId)) {
            session.removeAttribute("idDuplicateCheck");
            session.removeAttribute("checkedMemberId");
            model.addAttribute("errorMessage", "아이디가 변경되었습니다. 아이디를 다시 입력해주세요.");
            model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
            model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }

        // 네이버로 가입한 회원은 아이디 중복체크, 이메일 인증 X
        if (!"2".equals(memberDTO.getMemberJoinPath())) {
            Boolean idDuplicateCheck = (Boolean) session.getAttribute("idDuplicateCheck");
            if (idDuplicateCheck == null || !idDuplicateCheck) {
                model.addAttribute("errorMessage", "아이디 중복체크가 완료되지 않았습니다.");
                model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
                model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
                model.addAttribute("memberDTO", memberDTO);
                return "login/join";
            }

            Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
            if (emailVerified == null || !emailVerified) {
                model.addAttribute("errorMessage", "이메일 인증이 완료되지 않았습니다.");
                model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
                model.addAttribute("memberDTO", memberDTO);
                return "login/join";
            }
        }

        String memberPwd = request.getParameter("memberPwd");
        if (!memberPwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$")) {
            model.addAttribute("errorMessage", "비밀번호 형식이 올바르지 않습니다.");
            model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }

        String memberPwdConfirm = request.getParameter("memberPwdConfirm");
        if (!memberPwd.equals(memberPwdConfirm)) {
            model.addAttribute("errorMessage", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
            model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }

        try {
            String encryptedPassword = PasswordUtil.encryptPassword(memberDTO.getMemberPwd());
            memberDTO.setMemberPwd(encryptedPassword);
        } catch (NoSuchAlgorithmException e) {
            model.addAttribute("errorMessage", "비밀번호 암호화 오류가 발생했습니다.");
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }

        String memberZipCode = request.getParameter("memberZipCode");
        if (!memberZipCode.matches("^\\d{5}$")) {
            model.addAttribute("errorMessage", "우편번호는 숫자 5자리여야 합니다.");
            model.addAttribute("memberDTO", memberDTO);
            model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
            model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
            return "login/join";
        }

        String memberAddr1 = request.getParameter("memberAddr1");
        String memberAddr2 = request.getParameter("memberAddr2");

        if (memberAddr1 != null && memberAddr1.length() > 100) {
            model.addAttribute("errorMessage", "기본 주소는 100자 이내로 입력해주세요.");
            model.addAttribute("memberDTO", memberDTO);
            model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
            model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
            return "login/join";
        }

        if (memberAddr2 != null && memberAddr2.length() > 100) {
            model.addAttribute("errorMessage", "상세 주소는 100자 이내로 입력해주세요.");
            model.addAttribute("memberDTO", memberDTO);
            model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
            model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
            return "login/join";
        }

        // 프로필 이미지 파일 저장
        if (profileImg != null && !profileImg.isEmpty()) {
            try {
                File savedFile = fileUtil.saveFile(profileImg);
                String savedFileName = savedFile.getName();
                memberDTO.setMemberProfileImg(savedFileName);
            } catch (IOException e) {
                model.addAttribute("errorMessage", "프로필 이미지 업로드에 실패했습니다.");
                return "login/join";
            }
        }

        String memberAgree = request.getParameter("memberAgree");
        if (!"1".equals(memberAgree)) {
            model.addAttribute("errorMessage", "개인정보 수집 및 이용에 동의해야 회원가입이 가능합니다.");
            model.addAttribute("memberDTO", memberDTO);
            model.addAttribute("memberPwdConfirm", request.getParameter("memberPwdConfirm"));
            model.addAttribute("memberEmailCode", request.getParameter("memberEmailCode"));
            return "login/join";
        }

        boolean result = memberService.join(memberDTO);

        if (result) {
            session.removeAttribute("memberEmail");
            model.addAttribute("errorMessage", "회원가입에 성공했습니다.");
            return "redirect:/login";
        } else {
            model.addAttribute("errorMessage", "회원가입에 실패했습니다.");
            System.out.println("실패");
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }
    }

    @GetMapping("/findPwd")
    public String findPwd() {
        return "login/findPwd";
    }

    @PostMapping("/email/sendTempPassword")
    public String sendTempPassword(@RequestParam("memberEmail") String memberEmail,
                                   RedirectAttributes redirectAttributes) {

        String memberId = memberService.findByEmail(memberEmail);

        if (memberId == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "해당 이메일로 등록된 계정이 없습니다.");
            return "redirect:/findPwd";
        }

        String tempPassword = mailService.sendTemporaryPasswordToUser(memberEmail);

        try {
            String encryptedPassword = PasswordUtil.encryptPassword(tempPassword);

            memberService.updatePassword(memberId, encryptedPassword);
            redirectAttributes.addFlashAttribute("successMessage", "임시 비밀번호가 이메일로 발송되었습니다.");
        } catch (NoSuchAlgorithmException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "임시 비밀번호 처리 중 오류가 발생했습니다.");
        }

        return "redirect:/findPwd";
    }

}