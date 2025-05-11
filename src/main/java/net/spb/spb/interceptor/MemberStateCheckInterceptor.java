package net.spb.spb.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.spb.spb.dto.member.MemberDTO;
import org.springframework.web.servlet.HandlerInterceptor;

public class MemberStateCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("memberId") == null) {
            return true;
        }

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("memberDTO");
        String memberState = memberDTO.getMemberState();
        String uri = request.getRequestURI();

        // 비밀번호 변경한 지 90일 경과
        if (memberState.equals("3") &&
                !(uri.startsWith(request.getContextPath() + "/main") || uri.startsWith(request.getContextPath() + "/mypage/changePwd"))) {
            response.sendRedirect(request.getContextPath() + "/mypage/changePwd");
            return false;
        }

        // 로그인 한 지 1년 경과된 휴면 계정
        if (memberState.equals("5") &&
                !(uri.startsWith(request.getContextPath() + "/main") || uri.startsWith(request.getContextPath() + "/reactivate"))) {
            response.sendRedirect(request.getContextPath() + "/reactivate");
            return false;
        }

        return true;
    }
}
