package net.spb.spb.interceptor;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.service.LectureServiceIf;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Log4j2
@Component
public class LectureAccessInterceptor implements HandlerInterceptor {

    private LectureServiceIf lectureService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        log.info("💥 인터셉터 진입 확인");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("memberId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String memberId = (String) session.getAttribute("memberId");
        String memberGrade = (String) session.getAttribute("memberGrade"); // A: 관리자
        String lectureIdxStr = request.getParameter("chapterLectureIdx");
        if (lectureIdxStr == null) {
            response.sendRedirect(request.getContextPath() + "/error");
            return false;
        }

        int lectureIdx = Integer.parseInt(lectureIdxStr);

        boolean isAdmin = "A".equalsIgnoreCase(memberGrade);
        boolean isLectureOwner = lectureService.isLectureOwner(memberId, lectureIdx);
        boolean hasPurchased = lectureService.checkLecturePermission(memberId, lectureIdx);


        log.info("memberId={}, lectureIdx={}", memberId, lectureIdx);
        log.info("isAdmin={}, isOwner={}, hasPurchased={}", isAdmin, isLectureOwner, hasPurchased);

        if (isAdmin || isLectureOwner || hasPurchased) {
            return true; // 통과
        } else {
            response.sendRedirect(request.getContextPath() + "/lecture/main?lectureIdx=" + lectureIdx + "&denied=true");
            return false;
        }
    }

    @PostConstruct
    public void init() {
        log.info("✅ LectureAccessInterceptor Bean 등록됨");
    }

    public void setLectureService(LectureServiceIf lectureService) {
        this.lectureService = lectureService;
    }
}
