package net.spb.spb.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.spb.spb.dto.member.MemberDTO;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Objects;

public class MemberStateCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("memberId") == null) {
            return true; // 비로그인 상태는 통과
        }

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("memberDTO");
        String uri = request.getRequestURI();
        String cp = request.getContextPath();

        // memberDTO나 memberState가 null인 경우 -> 통과시키거나 기본 처리
        if (memberDTO == null || memberDTO.getMemberState() == null) {
            return true;
        }

        String memberState = memberDTO.getMemberState();

        if (memberState.equals("6")) {
            session.invalidate(); // 세션 강제 종료
            response.sendRedirect(cp + "/login");
            return false;
        }

        // 비밀번호 변경 90일 경과
        if (memberState.equals("3") &&
                !(uri.startsWith(cp + "/main") || uri.startsWith(cp + "/mypage/changePwd"))) {
            response.sendRedirect(cp + "/mypage/changePwd");
            return false;
        }

        // 1년 경과된 휴면 계정
        if (memberState.equals("5") &&
                !(uri.startsWith(cp + "/main") || uri.startsWith(cp + "/reactivate"))) {
            response.sendRedirect(cp + "/reactivate");
            return false;
        }

        return true;
    }
}
