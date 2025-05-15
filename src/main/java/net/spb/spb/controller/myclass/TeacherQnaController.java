package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.*;
import net.spb.spb.service.teacher.TeacherQnaService;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@RequiredArgsConstructor
@Controller
@RequestMapping("/myclass/qna")
public class TeacherQnaController {

    private final TeacherQnaService service;

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
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            HttpServletRequest req,
            Model model) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherQnaListRequestDTO reqDTO = TeacherQnaListRequestDTO.builder()
                .where_column("ttq.teacherQnaAMemberId")
                .where_value(memberId)
                .build();

        int totalCount = service.getTeacherQnaTotalCount(reqDTO, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<TeacherQnaResponseDTO> qnas = service.getTeacherQnaList(reqDTO, pageDTO);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("dtoList", qnas);

        setBreadcrumb(model, Map.of("QnA", "/myclass/qna"));

        return "myclass/qna/list";
    }

    @GetMapping("/view")
    public String view(
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        TeacherQnaResponseDTO dto = service.getTeacherQnaByIdx(idx);

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        if (dto == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 QnA를 찾을 수 없습니다.");
            return "redirect:/myclass/qna?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(dto.getTeacherQnaAMemberId())) {
            redirectAttributes.addFlashAttribute("message", "조회 권한이 없습니다.");
            return "redirect:/myclass/qna?" + pageDTO.getLinkUrl();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("dto", dto);

        setBreadcrumb(model, Map.of("QnA", "/myclass/qna"), Map.of("QnA 상세보기", "/myclass/qna/view?idx=" + idx));

        return "myclass/qna/view";
    }

    @GetMapping("/regist")
    public String registGET(
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherQnaResponseDTO qna = service.getTeacherQnaByIdx(idx);

        if (qna == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 QnA가 없습니다.");
            return "redirect:/myclass/qna?" + pageDTO.getLinkUrl();
        }
        if(!memberId.equals(qna.getTeacherQnaAMemberId())) {
            redirectAttributes.addFlashAttribute("message", "답변 권한이 없습니다.");
            return "redirect:/myclass/qna/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("dto", qna);
        setBreadcrumb(model, Map.of("QnA", "/myclass/qna"), Map.of("QnA 답변하기", "/myclass/qna/regist"));

        return "myclass/qna/regist";
    }

    @PostMapping("/regist")
    public String registPOST(
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            @Valid @ModelAttribute TeacherQnaAnswerDTO dto,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("dto", dto);
            return "redirect:/myclass/qna/regist?" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        int idx = dto.getTeacherQnaIdx();
        TeacherQnaResponseDTO qna = service.getTeacherQnaByIdx(idx);

        if (qna == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 QnA가 없습니다.");
            return "redirect:/myclass/qna?" + pageDTO.getLinkUrl();
        }
        if(!memberId.equals(qna.getTeacherQnaAMemberId())) {
            redirectAttributes.addFlashAttribute("message", "답변 권한이 없습니다.");
            return "redirect:/myclass/qna/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        service.updateTeacherAnswer(dto);

        return "redirect:/myclass/qna/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
    }

    @PostMapping("/delete")
    public String delete(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherQnaResponseDTO qna = service.getTeacherQnaByIdx(idx);

        if (qna == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 QnA가 없습니다.");
            return "redirect:/myclass/qna?" + pageDTO.getLinkUrl();
        }
        if(!memberId.equals(qna.getTeacherQnaAMemberId())) {
            redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
            return "redirect:/myclass/qna/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        service.deleteTeacherQuestionByIdx(idx);

        return "redirect:/myclass/qna?" + pageDTO.getLinkUrl();
    }
}
