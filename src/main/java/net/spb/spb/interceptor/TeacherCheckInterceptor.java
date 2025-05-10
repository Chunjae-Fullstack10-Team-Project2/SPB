package net.spb.spb.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.servlet.HandlerInterceptor;

@Log4j2
public class TeacherCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession();
        String memberId = (String) session.getAttribute("memberId");
        String memberGrade = (String) session.getAttribute("memberGrade");

        if (memberGrade == null || !memberGrade.equals("13")) {
            log.info("User is not teacher: {}", memberId);

            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('권한이 없습니다.'); history.back();</script>");
            response.getWriter().flush();
            return false;
        }

        log.info("Teacher access granted: {}", memberId);
        return true;
    }
}
