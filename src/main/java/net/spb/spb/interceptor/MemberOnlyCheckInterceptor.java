package net.spb.spb.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.servlet.HandlerInterceptor;

@Log4j2
public class MemberOnlyCheckInterceptor  implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null) {
            log.warn("Session not found, redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String memberId = (String) session.getAttribute("memberId");
        String memberGrade = (String) session.getAttribute("memberGrade");

        log.info("UserOnly Check - memberId: " + memberId + ", memberGrade: " + memberGrade);

        // 관리자면 접근 차단
        if ("0".equals(memberGrade)) {
            log.warn("Admin trying to access user-only page: " + memberId);
            response.sendRedirect(request.getContextPath() + "/admin/member/list");
            return false;
        }

        return true;
    }
}
