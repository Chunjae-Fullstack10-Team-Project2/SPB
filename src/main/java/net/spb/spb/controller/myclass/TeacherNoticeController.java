package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherFilePageDTO;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherFileResponseDTO;
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

    @GetMapping("/view")
    public String view(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @RequestParam("idx") int idx,
            Model model
    ) {
        TeacherNoticeResponseDTO teacherNoticeDTO = noticeService.getTeacherNoticeByIdx(idx);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherNoticeDTO", teacherNoticeDTO);

        setBreadcrumb(model, Map.of("공지사항", "/myclass/notice"), Map.of("공지사항 상세보기", "/myclass/notice/view?idx=" + idx));

        return "/myclass/notice/view";
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
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
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

        TeacherNoticeResponseDTO notice = noticeService.getTeacherNoticeByIdx(idx);

        if (notice == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 공지사항이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }
        if(!memberId.equals(notice.getTeacherNoticeMemberId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherNoticeDTO", notice);

        setBreadcrumb(model, Map.of("공지사항", "/myclass/notice"), Map.of("공지사항 수정", "/myclass/notice/modify"));

        return "myclass/notice/modify";
    }

    @PostMapping("/modify")
    public String modifyPost(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @ModelAttribute TeacherNoticeDTO teacherNoticeDTO,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherNoticeResponseDTO notice = noticeService.getTeacherNoticeByIdx(teacherNoticeDTO.getTeacherNoticeIdx());

        if (notice == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 공지사항이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }
        if(!memberId.equals(notice.getTeacherNoticeMemberId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }

        noticeService.updateTeacherNotice(memberId, teacherNoticeDTO);

        return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
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

        TeacherNoticeResponseDTO notice = noticeService.getTeacherNoticeByIdx(idx);

        if (notice == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 공지사항이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }
        if(!memberId.equals(notice.getTeacherNoticeMemberId())) {
            redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
            return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
        }

        noticeService.deleteTeacherNoticeByIdx(memberId, idx);

        return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
    }

    @PostMapping("/delete-multiple")
    public String deleteMultiple(
            @ModelAttribute TeacherNoticePageDTO pageDTO,
            @RequestParam("noticeIdxs") List<Integer> idxList,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        for (int idx : idxList) {
            TeacherNoticeResponseDTO notice = noticeService.getTeacherNoticeByIdx(idx);

            if (notice == null) {
                redirectAttributes.addFlashAttribute("message", "요청한 공지사항이 없습니다.");
                return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
            }
            if(!memberId.equals(notice.getTeacherNoticeMemberId())) {
                redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
                return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
            }

            noticeService.deleteTeacherNoticeByIdx(memberId, idx);
        }

        return "redirect:/myclass/notice?" + pageDTO.getLinkUrl();
    }
}
