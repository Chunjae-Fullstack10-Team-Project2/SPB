package net.spb.spb.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.servlet.HandlerInterceptor;

@Log4j2
public class AdminCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {


        HttpSession session = request.getSession(false);

        if (session == null) {
            log.warn("Session not found, redirecting to login page.");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String memberId = (String) session.getAttribute("memberId");
        String memberGrade = (String) session.getAttribute("memberGrade");

        log.info("Admin Check - memberId: " + memberId + ", memberGrade: " + memberGrade);

        // 관리자가 아닌 경우
        if (memberGrade == null || !memberGrade.equals("0")) {
            log.warn("User is not admin, redirecting to notice list: " + memberId);
            response.sendRedirect(request.getContextPath() + "/main");
            return false;
        }

        log.info("Admin access granted: " + memberId);
        return true;
    }
}