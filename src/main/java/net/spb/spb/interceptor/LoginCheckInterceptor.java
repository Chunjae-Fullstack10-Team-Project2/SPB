package net.spb.spb.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.servlet.HandlerInterceptor;

@Log4j2
public class LoginCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        // false: 세션이 없으면 null 반환
        HttpSession session = request.getSession(false);

        // 세션이 없거나 memberId가 없으면 로그인 페이지로 리디렉션
        if (session == null || session.getAttribute("memberId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false; // 컨트롤러 진입 막기
        }

        // 필요한 경우 세션 정보 로깅
        String memberId = (String) session.getAttribute("memberId");
        log.info("Logged in user: " + memberId);

        return true; // 컨트롤러 진입 허용
    }
}