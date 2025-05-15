package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.lecture.LectureGradeDTO;
import net.spb.spb.dto.lecture.LectureGradeDetailDTO;
import net.spb.spb.dto.lecture.LectureGradeListDTO;
import net.spb.spb.dto.pagingsearch.LectureGradePageDTO;
import net.spb.spb.service.lecture.LectureGradeServiceIf;
import net.spb.spb.service.lecture.LectureServiceIf;
import net.spb.spb.service.teacher.TeacherServiceIf;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/myclass/grade")
public class TeacherGradeController {

    private final LectureServiceIf lectureService;
    private final LectureGradeServiceIf lectureGradeService;
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
            @ModelAttribute LectureGradePageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        pageDTO.setWhere_column("tl.lectureTeacherId");
        pageDTO.setWhere_value(memberId);

        int totalCount = lectureGradeService.getLectureGradeTotalCount(pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<LectureGradeListDTO> students = lectureGradeService.getLectureGradeList(pageDTO);
        List<LectureDTO> lectures = teacherService.selectTeacherLecture(memberId);

        log.info("lectures: {}",lectures);
        log.info("students: {}",students);

        model.addAttribute("lectureList", lectures);
        model.addAttribute("studentList", students);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("성적 관리", "/myclass/grade"));

        return "myclass/grade/list";
    }

    @GetMapping("/view")
    public String view(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        LectureGradeDetailDTO lectureGradeDTO = lectureGradeService.getLectureGradeByIdx(idx);

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        if (lectureGradeDTO == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 성적표를 찾을 수 없습니다.");
            return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(lectureGradeDTO.getLectureTeacherId())) {
            redirectAttributes.addFlashAttribute("message", "조회 권한이 없습니다.");
            return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
        }

        model.addAttribute("lectureGradeDTO", lectureGradeDTO);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("성적 관리", "/myclass/grade"), Map.of("성적 상세보기", "/myclass/grade/view?idx=" + idx));

        return "myclass/grade/view";
    }

    @GetMapping("/regist")
    public String registGET(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @RequestParam("lectureIdx") int lectureIdx,
            @RequestParam("memberId") String memberId,
            Model model
    ) {

        LectureDTO lecture = lectureService.getLectureByIdx(lectureIdx);

        model.addAttribute("lecture", lecture);
        model.addAttribute("memberId", memberId);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("성적 관리", "/myclass/grade"), Map.of("성적 등록", "/myclass/grade/regist"));

        return "myclass/grade/regist";
    }

    @PostMapping("/regist")
    public String registPOST(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @Valid @ModelAttribute LectureGradeDTO lectureGradeDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("lectureGradeDTO", lectureGradeDTO);
            return "redirect:/myclass/grade/regist?" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        int idx = lectureGradeDTO.getLectureGradeRefIdx();
        LectureDTO lecture = lectureService.getLectureByIdx(idx);
        if (lecture == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 강좌를 찾을 수 없습니다.");
            return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(lecture.getLectureTeacherId())) {
            redirectAttributes.addFlashAttribute("message", "등록 권한이 없습니다.");
            return "redirect:/myclass/grade/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        lectureGradeService.createLectureGrade(lectureGradeDTO);

        return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
    }

    @GetMapping("/modify")
    public String modifyGET(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureGradeDetailDTO lectureGrade = lectureGradeService.getLectureGradeByIdx(idx);
        if (lectureGrade == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 성적표를 찾을 수 없습니다.");
            return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(lectureGrade.getLectureTeacherId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/myclass/grade/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("lectureGradeDTO", lectureGrade);

        setBreadcrumb(model, Map.of("성적 관리", "/myclass/grade"), Map.of("성적 수정", "/myclass/grade/modify"));

        return "myclass/grade/modify";
    }

    @PostMapping("/modify")
    public String modifyPOST(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @Valid @ModelAttribute LectureGradeDTO lectureGradeDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        int idx = lectureGradeDTO.getLectureGradeIdx();

        if (bindingResult.hasErrors()) {
            log.warn("modify valid fail: {}", lectureGradeDTO);
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("lectureGradeDTO", lectureGradeDTO);
            return "redirect:/myclass/grade/modify?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureGradeDetailDTO lectureGrade = lectureGradeService.getLectureGradeByIdx(idx);
        if (lectureGrade == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 성적표를 찾을 수 없습니다.");
            return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(lectureGrade.getLectureTeacherId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/myclass/grade/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        lectureGradeService.updateLectureGrade(lectureGradeDTO);

        return "redirect:/myclass/grade/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
    }

    @PostMapping("/delete")
    public String delete(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        log.info("delete-idx: {}", idx);

        LectureGradeDetailDTO lectureGrade = lectureGradeService.getLectureGradeByIdx(idx);
        if (lectureGrade == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 성적표를 찾을 수 없습니다.");
            return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(lectureGrade.getLectureTeacherId())) {
            redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
            return "redirect:/myclass/grade/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        lectureGradeService.deleteLectureGradeByidx(idx);

        return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
    }

    @PostMapping("/delete-multiple")
    public String deleteMultiple(
            @ModelAttribute LectureGradePageDTO pageDTO,
            @RequestParam("idxList") List<Integer> idxList,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        for (Integer idx : idxList) {
            LectureGradeDetailDTO lectureGrade = lectureGradeService.getLectureGradeByIdx(idx);
            if (lectureGrade == null) {
                redirectAttributes.addFlashAttribute("message", "요청한 성적표를 찾을 수 없습니다.");
                return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
            }
            if (!memberId.equals(lectureGrade.getLectureTeacherId())) {
                redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
                return "redirect:/myclass/grade/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
            }

            lectureGradeService.deleteLectureGradeByidx(idx);
        }

        return "redirect:/myclass/grade?" + pageDTO.getLinkUrl();
    }
}
