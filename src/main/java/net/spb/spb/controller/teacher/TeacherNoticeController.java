package net.spb.spb.controller.teacher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherNoticeResponseDTO;
import net.spb.spb.service.teacher.TeacherNoticeService;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/myclass/notice")
public class TeacherNoticeController {

    private final TeacherNoticeService noticeService;

    private static final  Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의강의실", "url", "/myclass");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String list(@ModelAttribute TeacherNoticePageDTO pageDTO, Model model, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        List<TeacherNoticeResponseDTO> notices = noticeService.getTeacherNoticeList(memberId, pageDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("noticeList", notices);

        setBreadcrumb(model, Map.of("공지사항", "/myclass/notice"));

        return "myclass/notice/list";
    }
}
