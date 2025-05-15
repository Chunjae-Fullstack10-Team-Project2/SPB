package net.spb.spb.controller.mystudy;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.lecture.LectureDTO;
import net.spb.spb.dto.lecture.LectureGradeDetailDTO;
import net.spb.spb.dto.lecture.LectureGradeListDTO;
import net.spb.spb.dto.pagingsearch.LectureGradePageDTO;
import net.spb.spb.service.lecture.LectureGradeServiceIf;
import net.spb.spb.service.lecture.StudentLectureServiceIf;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/mystudy/grade")
public class StudentGradeController {
    private final LectureGradeServiceIf lectureGradeService;
    private final StudentLectureServiceIf studentLectureService;

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
            @ModelAttribute LectureGradePageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        pageDTO.setWhere_column("tlr.lectureRegisterMemberId");
        pageDTO.setWhere_value(memberId);

        int totalCount = lectureGradeService.getLectureGradeTotalCount(pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<LectureGradeListDTO> dtoList = lectureGradeService.getLectureGradeList(pageDTO);
        List<LectureDTO> lectures = studentLectureService.getStudentLectures(memberId);

        log.info("dtoList: {}", dtoList);
        log.info("lectures: {}", lectures);

        model.addAttribute("dtoList", dtoList);
        model.addAttribute("lectureList", lectures);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("totalCount", totalCount);

        setBreadcrumb(model, Map.of("성적 관리", "/mystudy/grade"));

        return "mystudy/grade/list";
    }
    
    @GetMapping("/view")
    public String view(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        LectureGradeDetailDTO lectureGradeDTO = lectureGradeService.getLectureGradeByIdx(idx);

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        if (lectureGradeDTO == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 성적표를 찾을 수 없습니다.");
            return "redirect:/mystudy/grade?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(lectureGradeDTO.getLectureGradeMemberId())) {
            redirectAttributes.addFlashAttribute("message", "조회 권한이 없습니다.");
            return "redirect:/mystudy/grade?" + pageDTO.getLinkUrl();
        }

        model.addAttribute("lectureGradeDTO", lectureGradeDTO);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("나의 성적", "/mystudy/grade"), Map.of("성적 상세보기", "/mystudy/grade/view?idx=" + idx));

        return "mystudy/grade/view";
    }
}
