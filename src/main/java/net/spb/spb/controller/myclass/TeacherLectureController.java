package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
import net.spb.spb.service.teacher.TeacherServiceIf;
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
@RequestMapping("/myclass/lecture")
public class TeacherLectureController {

    private final TeacherServiceIf teacherService;

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
            @ModelAttribute LecturePageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        int totalCount = teacherService.getTeacherLectureListTotalCount(memberId, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<LectureDTO> lectures = teacherService.getTeacherLectureListById(memberId, pageDTO);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("lectureList", lectures);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("내 강의 목록", "/myclass/lecture"));

        return "myclass/lecture/list";
    }
}
