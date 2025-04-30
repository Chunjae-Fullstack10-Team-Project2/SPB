package net.spb.spb.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import net.spb.spb.dto.MemberDTO;
import net.spb.spb.service.MailService;
import net.spb.spb.service.MemberServiceImpl;
import net.spb.spb.service.NaverLoginService;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

@Controller
@Log4j2
public class MemberController {
    @Autowired(required = false)
    private MemberServiceImpl memberService;

    @Autowired
    private NaverLoginService naverLoginService;

    @Autowired
    private MailService mailService;

    @GetMapping("/")
    public String main() {
        return "common/main";
    }

    @GetMapping("/main")
    public String main2() {
        return "common/main";
    }

    @GetMapping("/naver/callback")
    public String naverCallback(@RequestParam("code") String code,
                                @RequestParam("state") String state,
                                HttpSession session,
                                Model model) throws Exception {

        String accessToken = naverLoginService.getAccessToken(code, state);
        MemberDTO naverUser = naverLoginService.getUserInfo(accessToken);

        String naverId = naverUser.getMemberId();
        if (!memberService.existUser(naverId)) {
            naverUser.setMemberId(naverId);
            naverUser.setMemberPwd("naver");
            memberService.join(naverUser);
        }

        session.setAttribute("memberId", naverId);
        return "redirect:/main";
    }

    @GetMapping("/login")
    public String login(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        Cookie[] cookies = request.getCookies();
        String autoLoginId = null;

        String action = request.getParameter("action");
        if (action != null && action.equals("logout")) {
            request.getSession().invalidate();

            Cookie autoLoginCookie = new Cookie("autoLogin", null);
            autoLoginCookie.setMaxAge(0);
            autoLoginCookie.setPath("/");
            response.addCookie(autoLoginCookie);

            return "redirect:/login";
        }

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("autoLogin".equals(cookie.getName())) {
                    autoLoginId = cookie.getValue();
                    break;
                }
            }
        }

        if (autoLoginId != null) {
            MemberDTO autoLoginUser = new MemberDTO();
            autoLoginUser.setMemberId(autoLoginId);

            if (memberService.existUser(autoLoginId)) {
                session.setAttribute("memberId", autoLoginId);
                return "redirect:/board/list";
            }
        }

        return "login/login";
    }

    @PostMapping("/login")
    public String login(@Valid @ModelAttribute MemberDTO memberDTO, BindingResult bindingResult,
                        @RequestParam(value = "checkIdSave", required = false) String checkIdSave,
                        @RequestParam(value = "checkAutoLogin", required = false) String checkAutoLogin,
                        HttpServletResponse response,
                        HttpSession session,
                        Model model) {
        if (bindingResult.hasErrors()) {
            return "login/login";
        }

        int returnValue = memberService.login(memberDTO);

        if (returnValue == 1) {
            session.setAttribute("memberId", memberDTO.getMemberId());

            if (checkIdSave != null) {
                Cookie idCookie = new Cookie("saveId", memberDTO.getMemberId());
                session.setAttribute("memberId", memberDTO.getMemberId());
                idCookie.setMaxAge(60 * 60 * 24 * 1);
                idCookie.setPath("/");
                response.addCookie(idCookie);
            } else {
                Cookie idCookie = new Cookie("saveId", null);
                idCookie.setMaxAge(0);
                idCookie.setPath("/");
                response.addCookie(idCookie);
            }

            if (checkAutoLogin != null) {
                Cookie autoCookie = new Cookie("autoLogin", memberDTO.getMemberId());
                session.setAttribute("memberId", memberDTO.getMemberId());
                autoCookie.setMaxAge(60 * 60 * 24 * 1);
                autoCookie.setPath("/");
                response.addCookie(autoCookie);
            } else {
                Cookie autoCookie = new Cookie("autoLogin", null);
                autoCookie.setMaxAge(0);
                autoCookie.setPath("/");
                response.addCookie(autoCookie);
            }

            return "redirect:/board/list";
        } else {
            model.addAttribute("loginError", true);

            return "login/login";
        }
    }

    @GetMapping("join")
    public String join() {
        return "login/join";
    }

    @PostMapping("/checkIdDuplicate")
    @ResponseBody
    public Map<String, Object> checkIdDuplicate(@RequestBody Map<String, String> requestBody, HttpSession session) {
        String memberId = requestBody.get("memberId");

        boolean existMember = memberService.existUser(memberId);
        Map<String, Object> result = new HashMap<>();

        if (existMember) {
            result.put("success", false);
            result.put("message", "이미 존재하는 아이디입니다.");
        } else {
            result.put("success", true);
            result.put("message", "사용 가능한 아이디입니다.");
            session.setAttribute("idDuplicateCheck", true);
        }

        return result;
    }

    @PostMapping("/email/verify")
    @ResponseBody
    public Map<String, Object> verifyEmail(@ModelAttribute MemberDTO memberDTO, HttpSession session) {
        String memberEmail = memberDTO.getMemberEmail();
        Map<String, Object> result = new HashMap<>();

        if (memberEmail != null && !memberEmail.isEmpty()) {
            String code = mailService.sendVerificationCode(memberEmail);
            session.setAttribute("emailAuthCode", code);
            session.setAttribute("memberEmail", memberEmail);
            session.setAttribute("emailVerified", false);

            result.put("success", true);
            result.put("message", "인증 코드가 전송되었습니다.");
        } else {
            result.put("success", false);
            result.put("message", "이메일을 입력해주세요.");
        }

        session.setAttribute("memberDTO", memberDTO);
        return result;
    }

    @PostMapping("/email/codeCheck")
    @ResponseBody
    public Map<String, Object> checkEmailCode(@RequestParam("memberEmailCode") String memberEmailCode,
                                              @ModelAttribute MemberDTO memberDTO, HttpSession session) {
        String sessionCode = (String) session.getAttribute("emailAuthCode");
        Map<String, Object> result = new HashMap<>();

        if (sessionCode != null && sessionCode.equals(memberEmailCode)) {
            result.put("success", true);
            result.put("message", "인증 코드가 일치합니다.");
            session.setAttribute("emailVerified", true);
        } else {
            result.put("success", false);
            result.put("message", "인증 코드가 일치하지 않습니다.");
        }

        session.setAttribute("memberDTO", memberDTO);
        return result;
    }

    @PostMapping("/join")
    public String join(@Valid @ModelAttribute MemberDTO memberDTO, BindingResult bindingResult, HttpSession session, Model model) {
        if (bindingResult.hasErrors()) {
            return "login/join";
        }

        String sessionMemberId = (String) session.getAttribute("memberId");
        String formMemberId = memberDTO.getMemberId();

        if (sessionMemberId != null && !sessionMemberId.equals(formMemberId)) {
            session.removeAttribute("idDuplicateCheck");
            session.removeAttribute("memberId");
            model.addAttribute("errorMessage", "아이디가 변경되었습니다. 아이디를 다시 입력해 주세요.");
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }

        Boolean idDuplicateCheck = (Boolean) session.getAttribute("idDuplicateCheck");
        if (idDuplicateCheck == null || !idDuplicateCheck) {
            model.addAttribute("errorMessage", "아이디 중복체크가 완료되지 않았습니다.");
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }

        Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
        if (emailVerified == null || !emailVerified) {
            model.addAttribute("errorMessage", "이메일 인증이 완료되지 않았습니다.");
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }

        boolean result = memberService.join(memberDTO);

        if (result) {
            session.removeAttribute("emailVerified");
            session.removeAttribute("emailAuthCode");
            session.removeAttribute("memberEmail");
            return "redirect:/login";
        } else {
            model.addAttribute("errorMessage", "회원가입에 실패했습니다.");
            model.addAttribute("memberDTO", memberDTO);
            return "login/join";
        }
    }

    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);

        return "login/mypage";
    }

    @PostMapping("/mypage")
    public String updateMyPage(@ModelAttribute MemberDTO memberDTO, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        memberDTO.setMemberId(memberId);

        boolean result = memberService.updateMember(memberDTO);
        if (result) {
            session.setAttribute("memberDTO", memberDTO);
            return "redirect:/mypage";
        } else {
            model.addAttribute("errorMessage", "회원 정보 수정에 실패했습니다.");
            return "login/mypage";
        }
    }

    @PostMapping("/mypage/checkPwd")
    @ResponseBody
    public ResponseEntity<String> checkPassword(@RequestParam("memberPwd") String memberPwd, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        String originalPwd = memberService.getPwdById(memberId);

        if (originalPwd != null && originalPwd.equals(memberPwd)) {
            return ResponseEntity.ok("success");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("fail");
        }
    }
}