package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.TeacherQnaListRequestDTO;
import net.spb.spb.dto.teacher.TeacherQnaResponseDTO;
import net.spb.spb.service.teacher.TeacherQnaService;
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
@RequiredArgsConstructor
@Controller
@RequestMapping("/myclass/qna")
public class TeacherQnaController {
    private final TeacherQnaService teacherQnaService;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의강의실", "url", "/myclass");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String list(@ModelAttribute TeacherQnaPageDTO pageDTO, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherQnaListRequestDTO reqDTO = TeacherQnaListRequestDTO.builder()
                .where_column("ttq.teacherQnaAMemberId")
                .where_value(memberId)
                .build();

        List<TeacherQnaResponseDTO> qnas = teacherQnaService.getTeacherQnaList(reqDTO, pageDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("qnaList", qnas);

        setBreadcrumb(model, Map.of("QnA", "/myclass/qna"));

        return "myclass/qna/list";
    }
}
