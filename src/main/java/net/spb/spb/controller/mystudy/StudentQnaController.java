package net.spb.spb.controller.mystudy;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.TeacherQnaListRequestDTO;
import net.spb.spb.dto.teacher.TeacherQnaResponseDTO;
import net.spb.spb.service.teacher.TeacherQnaServiceIf;
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
@RequestMapping("/mystudy")
public class StudentQnaController {
    private final TeacherQnaServiceIf teacherQnaService;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의학습방", "url", "/mystudy");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("/qna")
    public String qna(
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherQnaListRequestDTO reqDTO = TeacherQnaListRequestDTO.builder()
                .where_column("ttq.teacherQnaQMemberId")
                .where_value(memberId)
                .build();

        int totalCount = teacherQnaService.getTeacherQnaTotalCount(reqDTO, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<TeacherQnaResponseDTO> qnas = teacherQnaService.getTeacherQnaList(reqDTO, pageDTO);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("dtoList", qnas);

        setBreadcrumb(model, Map.of("QnA", "/mystudy/qna"));

        return "mystudy/qna";
    }
}
