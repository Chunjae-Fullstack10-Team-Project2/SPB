package net.spb.spb.controller.mystudy;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.lecture.StudentLectureResponseDTO;
import net.spb.spb.dto.pagingsearch.StudentLecturePageDTO;
import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.TeacherQnaListRequestDTO;
import net.spb.spb.dto.teacher.TeacherQnaResponseDTO;
import net.spb.spb.service.lecture.LectureGradeService;
import net.spb.spb.service.lecture.LectureReviewServiceIf;
import net.spb.spb.service.lecture.StudentLectureServiceIf;
import net.spb.spb.service.teacher.TeacherQnaService;
import net.spb.spb.util.BreadcrumbUtil;
import net.spb.spb.util.PagingUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/mystudy")
public class StudentLectureController {
    private final StudentLectureServiceIf studentLectureService;
    private final LectureReviewServiceIf lectureReviewService;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의학습방", "url", "/mystudy");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String list(
            @ModelAttribute("pageDTO") StudentLecturePageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        int totalCount = studentLectureService.getStudentLectureTotalCount(memberId, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<StudentLectureResponseDTO> lectures = studentLectureService.getStudentLectureList(memberId, pageDTO);
        lectures.forEach(dto -> {
            boolean hasReview = lectureReviewService.hasLectureReview(memberId, dto.getLectureRegisterRefIdx());
            dto.setHasLectureReview(hasReview);
        });

        log.info("lecture: {}", lectures);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("lectureList", lectures);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("내 강의 목록", "/mystudy"));

        return "mystudy/lecture";
    }
}
