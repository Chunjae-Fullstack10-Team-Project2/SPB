package net.spb.spb.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.member.MemberDTO;
import org.springframework.web.servlet.HandlerInterceptor;

@Log4j2
public class NoticeAdminInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        // 세션 확인
        HttpSession session = request.getSession(false);

        // 세션이 없거나 member 속성이 없으면 로그인 페이지로 리디렉션
        if (session == null || session.getAttribute("member") == null) {
            log.info("No session or member attribute found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // memberGrade 확인하여 관리자(0)인지 체크
        MemberDTO member = (MemberDTO) session.getAttribute("member");
        String memberGrade = member.getMemberGrade();

        // memberGrade가 null이거나 "0"이 아니면 (관리자가 아니면) 리스트로 리디렉션
        if (memberGrade == null || !memberGrade.equals("0")) {
            log.info("User is not admin, redirecting to notice list: " + member.getMemberId());
            response.sendRedirect(request.getContextPath() + "/notice/list");
            return false;
        }

        log.info("Admin access granted: " + member.getMemberId());
        return true;
    }
}