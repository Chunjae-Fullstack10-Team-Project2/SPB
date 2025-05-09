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

            // 마지막 로그인 일자가 1년 경과
            LocalDate lastLoginDate = memberDTO.getMemberLastLogin();
            // 비밀번호 90일 이상 경과
            LocalDate pwdChangeDate = memberDTO.getMemberPwdChangeDate();

            if (lastLoginDate != null) {
                long daysSinceLastLogin = ChronoUnit.DAYS.between(lastLoginDate, LocalDate.now());
                if (daysSinceLastLogin >= 365) {
                    memberDTO.setMemberState("5");
                    memberService.updateMemberStateWithLogin("5", memberId);

                }
            } else if (pwdChangeDate != null) {
                long dayBetween = ChronoUnit.DAYS.between(pwdChangeDate, LocalDate.now());
                if (dayBetween >= 90) {
                    memberDTO.setMemberState("3");
                    memberService.updateMemberStateWithLogin("3", memberId);
                }
            }

            if (memberDTO.getMemberState().equals("1")) {
                memberService.updateMemberLastLoginWithLogin(LocalDate.now().toString(), memberId);
            }

            session.setAttribute("memberDTO", memberDTO);
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
            // model.addAttribute("memberDTO", naverMemberDto);
            session.setAttribute("memberDTO", naverMemberDto);
            return "redirect:/join";
        }

        session.setAttribute("memberId", naverMemberId);
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
            session.setAttribute("memberId", memberDTO.getMemberId());
            session.setAttribute("memberGrade", memberDTO.getMemberGrade());

//            // 로그인 일자 오늘로
//            String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
//            memberService.updateMemberLastLoginWithLogin(today, memberDTO.getMemberId());

            // 아이디 저장 쿠키 처리
            if (checkIdSave != null) {
                Cookie idCookie = new Cookie("saveId", memberDTO.getMemberId());
                idCookie.setMaxAge(60 * 60 * 24); // 1일
                idCookie.setPath("/");
                response.addCookie(idCookie);
            } else {
                Cookie idCookie = new Cookie("saveId", null);
                idCookie.setMaxAge(0);
                idCookie.setPath("/");
                response.addCookie(idCookie);
            }

            // 자동 로그인 쿠키 처리
            if (checkAutoLogin != null) {
                Cookie autoCookie = new Cookie("autoLogin", memberDTO.getMemberId());
                autoCookie.setMaxAge(60 * 60 * 24); // 1일
                autoCookie.setPath("/");
                response.addCookie(autoCookie);
            } else {
                Cookie autoCookie = new Cookie("autoLogin", null);
                autoCookie.setMaxAge(0);
                autoCookie.setPath("/");
                response.addCookie(autoCookie);
            }

            return "redirect:/main";
        } else {
            model.addAttribute("errorMessage", "아이디를 확인해주세요.");
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
            // 인증 코드 생성 및 이메일 전송
            String code = mailService.sendVerificationCode(memberEmail);
            session.setAttribute("emailAuthCode", code);
            session.setAttribute("memberEmail", memberEmail);
            session.setAttribute("emailVerified", false);
            session.setAttribute("emailAuthTime", System.currentTimeMillis());

            // 인증 시도 횟수
            Integer emailTryCount = (Integer) session.getAttribute("emailTryCount");
            if (emailTryCount == null) {
                emailTryCount = 0;
            }

            if (emailTryCount >= 3) {
                result.put("success", false);
                result.put("message", "이메일 인증 시도 횟수를 초과했습니다. 나중에 다시 시도해주세요.");
                return result;
            }

            emailTryCount++;
            session.setAttribute("emailTryCount", emailTryCount);

            result.put("success", true);
            result.put("message", "인증 코드가 전송되었습니다.");
            result.put("emailTryCount", emailTryCount);
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
            result.put("success", false);
            result.put("message", "인증 시간이 만료되었습니다. 다시 시도해주세요.");
            return result;
        }

        if (sessionCode != null && sessionCode.equals(memberEmailCode)) {
            result.put("success", true);
            session.setAttribute("emailVerified", true);
            session.removeAttribute("emailTryCount");
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
}