package net.spb.spb.controller.student;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.lecture.LectureReviewListRequestDTO;
import net.spb.spb.dto.lecture.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;
import net.spb.spb.service.lecture.LectureReviewServiceIf;
import net.spb.spb.util.BreadcrumbUtil;
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
@RequestMapping("/mystudy/review")
public class StudentReviewController {

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
}
