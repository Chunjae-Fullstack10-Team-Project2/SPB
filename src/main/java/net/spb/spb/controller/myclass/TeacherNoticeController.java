package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherNoticeDTO;
import net.spb.spb.dto.teacher.TeacherNoticeResponseDTO;
import net.spb.spb.service.teacher.TeacherNoticeService;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    public String list(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            Model model,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        int totalCount = noticeService.getTeacherNoticeListTotalCount(memberId, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<TeacherNoticeResponseDTO> notices = noticeService.getTeacherNoticeList(memberId, pageDTO);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("noticeList", notices);

        setBreadcrumb(model, Map.of("공지사항", "/myclass/notice"));

        return "myclass/notice/list";
    }

    @GetMapping("/regist")
    public String registGET(@ModelAttribute TeacherNoticePageDTO pageDTO, Model model) {
        model.addAttribute("pageDTO", pageDTO);
        setBreadcrumb(model, Map.of("공지사항", "/myclass/notice"), Map.of("공지사항 등록", "/myclass/regist"));
        return "myclass/notice/regist";
    }

    @PostMapping("/regist")
    public String registPOST(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @Valid @ModelAttribute TeacherNoticeDTO teacherNoticeDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("errorMessage", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("teacherNoticeDTO", teacherNoticeDTO);
            return "redirect:/myclass/notice/regist?" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        teacherNoticeDTO.setTeacherNoticeMemberId(memberId);
        noticeService.createTeacherNotice(teacherNoticeDTO);

        return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
    }

    @GetMapping("/modify")
    public String modifyGET(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherNoticeResponseDTO teacherNoticeDTO = noticeService.getTeacherNoticeByIdx(idx);

        if (teacherNoticeDTO == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }
        if(!memberId.equals(teacherNoticeDTO.getTeacherNoticeMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherNoticeDTO", teacherNoticeDTO);

        setBreadcrumb(model, Map.of("공지사항", "/myclass/notice"), Map.of("공지사항 수정", "/myclass/notice/modify"));

        return "myclass/notice/modify";
    }

    @PostMapping("/modify")
    public String modifyPost(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @ModelAttribute TeacherNoticeDTO teacherNoticeDTO,
            Model model,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        noticeService.updateTeacherNotice(memberId, teacherNoticeDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherNoticeDTO", teacherNoticeDTO);

        return "redirect:/myclass/notice?idx=" + teacherNoticeDTO.getTeacherNoticeIdx() + "&" + pageDTO.getLinkUrl();
    }

    @GetMapping("/delete")
    public String delete(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @RequestParam("idx") int idx,
            Model model,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        noticeService.deleteTeacherNoticeByIdx(memberId, idx);

        model.addAttribute("pageDTO", pageDTO);

        return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
    }
}
