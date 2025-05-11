package net.spb.spb.controller.student;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.lecture.LectureReviewDTO;
import net.spb.spb.dto.lecture.LectureReviewListRequestDTO;
import net.spb.spb.dto.lecture.LectureReviewResponseDTO;
import net.spb.spb.dto.lecture.StudentLectureResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;
import net.spb.spb.service.lecture.LectureReviewServiceIf;
import net.spb.spb.service.lecture.StudentLectureServiceIf;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/mystudy/review")
public class StudentReviewController {

    private final LectureReviewServiceIf lectureReviewService;
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
    public String list(@ModelAttribute LectureReviewPageDTO pageDTO, Model model, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureReviewListRequestDTO reqDTO = LectureReviewListRequestDTO.builder()
                .where_column("lectureReviewMemberId")
                .where_value(memberId)
                .build();

        List<LectureReviewResponseDTO> reviews = lectureReviewService.getLectureReviewList(reqDTO, pageDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("reviewList", reviews);

        setBreadcrumb(model, Map.of("수강후기", "/mystudy/review"));

        return "mystudy/review";
    }

    @GetMapping("/regist")
    public String registGET(@ModelAttribute LectureReviewPageDTO pageDTO, Model model, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        List<StudentLectureResponseDTO> lectures = studentLectureService.getStudentLectureList(memberId, null);

        model.addAttribute("lectureList", lectures);
        model.addAttribute("pageDTO", pageDTO);
        setBreadcrumb(model, Map.of("수강후기", "/mystudy/review"), Map.of("수강후기 등록", "/mystudy/review/regist"));
        return "review/regist";
    }

    @PostMapping("/regist")
    public String registPOST(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            @Valid @ModelAttribute LectureReviewDTO lectureReviewDTO,
            BindingResult bindingResult,
            Model model,
            HttpServletRequest req
    ) {
        if (bindingResult.hasErrors()) {
            // 잘못된 입력이 있습니다. 다시 확인해주세요.
            model.addAttribute("pageDTO", pageDTO);
            model.addAttribute("lectureReviewDTO", lectureReviewDTO);
            return "review/regist";
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        lectureReviewDTO.setLectureReviewMemberId(memberId);
        lectureReviewService.createLectureReview(memberId, lectureReviewDTO);

        return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
    }

    @GetMapping("/view")
    public String view(@ModelAttribute LectureReviewPageDTO pageDTO, @RequestParam("idx") int idx, Model model) {
        LectureReviewResponseDTO lectureReviewResponseDTO = lectureReviewService.getLectureReviewByIdx(idx);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("lectureReviewDTO", lectureReviewResponseDTO);

        setBreadcrumb(model, Map.of("수강후기", "/mystudy/review"), Map.of("수강후기 상세보기", "/mystudy/review/view"));

        return "/review/view";
    }
}
