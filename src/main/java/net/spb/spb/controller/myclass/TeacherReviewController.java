package net.spb.spb.controller.myclass;

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
@RequestMapping("/myclass/review")
public class TeacherReviewController {

    private final LectureReviewServiceIf service;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의강의실", "url", "/myclass");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String list(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureReviewListRequestDTO reqDTO = LectureReviewListRequestDTO.builder()
                .where_column("tt.teacherId")
                .where_value(memberId)
                .build();

        int totalCount = service.getLectureReviewTotalCount(reqDTO, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<LectureReviewResponseDTO> reviews = service.getLectureReviewList(reqDTO, pageDTO);

        model.addAttribute("reviewList", reviews);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("totalCount", totalCount);

        setBreadcrumb(model, Map.of("수강후기", "myclass/review"));

        return "myclass/review/list";
    }

}
