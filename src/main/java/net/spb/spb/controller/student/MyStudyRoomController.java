package net.spb.spb.controller.student;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.lecture.StudentLectureResponseDTO;
import net.spb.spb.dto.pagingsearch.StudentLecturePageDTO;
import net.spb.spb.service.lecture.StudentLectureServiceIf;
import net.spb.spb.util.PagingUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/mystudy")
public class MyStudyRoomController {
    private final StudentLectureServiceIf studentLectureService;

    @GetMapping("/lecture")
    public String list(@ModelAttribute("pageDTO") StudentLecturePageDTO pageDTO, Model model, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        String baseUrl = req.getRequestURI();
        pageDTO.setLinkUrl(PagingUtil.buildLinkUrl(baseUrl, pageDTO));
        pageDTO.setTotal_count(studentLectureService.getStudentLectureTotalCount(memberId, pageDTO));

        List<StudentLectureResponseDTO> lectures = studentLectureService.getStudentLectureList(memberId, pageDTO);

        String paging = PagingUtil.pagingArea(pageDTO);

        model.addAttribute("lectureList", lectures);
        model.addAttribute("paging", paging);

        return "mystudy/lecture";
    }
}
