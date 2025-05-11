package net.spb.spb.controller.teacher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherNoticeDTO;
import net.spb.spb.dto.teacher.TeacherNoticeRequestDTO;
import net.spb.spb.dto.teacher.TeacherNoticeResponseDTO;
import net.spb.spb.service.teacher.TeacherNoticeService;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

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
            Model model,
            HttpServletRequest req
    ) {
        if (bindingResult.hasErrors()) {
            // 잘못된 입력이 있습니다. 다시 확인해주세요.
            model.addAttribute("teacherNoticeDTO", teacherNoticeDTO);
            return "myclass/notice/regist";
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        teacherNoticeDTO.setTeacherNoticeMemberId(memberId);
        noticeService.createTeacherNotice(teacherNoticeDTO);

        return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
    }

    @GetMapping("/view")
    public String view(@ModelAttribute TeacherNoticePageDTO pageDTO, @RequestParam("idx") int idx, Model model) {
        TeacherNoticeResponseDTO teacherNoticeDTO = noticeService.getTeacherNoticeByIdx(idx);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherNoticeDTO", teacherNoticeDTO);

        setBreadcrumb(model, Map.of("공지사항", "/myclass/notice"), Map.of("공지사항 상세보기", "/myclass/notice/view"));

        return "/myclass/notice/view";
    }

    @GetMapping("/modify")
    public String modifyGET(@ModelAttribute TeacherNoticePageDTO pageDTO, @RequestParam("idx") int idx, Model model) {
        TeacherNoticeResponseDTO teacherNoticeDTO = noticeService.getTeacherNoticeByIdx(idx);

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
