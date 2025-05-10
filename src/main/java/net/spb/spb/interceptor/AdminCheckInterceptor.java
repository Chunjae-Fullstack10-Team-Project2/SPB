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

        HttpSession session = request.getSession();
        String memberId = (String) session.getAttribute("memberId");
        String memberGrade = (String) session.getAttribute("memberGrade");

        // memberGrade가 null이거나 "0"이 아니면 (관리자가 아니면) 리스트로 리디렉션
        if (memberGrade == null || !memberGrade.equals("0")) {
            log.info("User is not admin, redirecting to notice list: " + memberId);
            response.sendRedirect(request.getContextPath() + "/notice/list");
            return false;
        }

        log.info("Admin access granted: " + memberId);
        return true;
    }
}