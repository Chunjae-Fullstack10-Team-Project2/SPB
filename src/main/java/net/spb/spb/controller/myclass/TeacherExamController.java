package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.exam.ExamResponseDTO;
import net.spb.spb.dto.pagingsearch.ExamPageDTO;
import net.spb.spb.service.exam.ExamServiceIf;
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
@RequestMapping("/myclass/exam")
public class TeacherExamController {
    
    private final ExamServiceIf examService;
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
            @ModelAttribute ExamPageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");
        
        int totalCount = examService.getExamTotalCountByTeacherId(memberId, pageDTO);
        pageDTO.setTotal_count(totalCount);
        
        List<ExamResponseDTO> exams = examService.getExamListByTeacherId(memberId, pageDTO);

        List<LectureDTO> lectures = teacherService.selectTeacherLecture(memberId);
        
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("examList", exams);
        model.addAttribute("lectureList", lectures);
        model.addAttribute("pageDTO", pageDTO);
        
        setBreadcrumb(model, Map.of("시험 관리", "/myclass/exam"));

        return "myclass/exam/list";
    }
}
