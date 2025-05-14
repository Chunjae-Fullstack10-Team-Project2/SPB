//package net.spb.spb.controller.myclass;
//
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpSession;
//import jakarta.validation.Valid;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.log4j.Log4j2;
//import net.spb.spb.dto.LectureDTO;
//import net.spb.spb.dto.exam.ExamDTO;
//import net.spb.spb.dto.exam.ExamResponseDTO;
//import net.spb.spb.dto.pagingsearch.TeacherFilePageDTO;
//import net.spb.spb.service.exam.ExamServiceIf;
//import net.spb.spb.service.lecture.LectureServiceIf;
//import net.spb.spb.service.teacher.TeacherServiceIf;
//import net.spb.spb.util.BreadcrumbUtil;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.validation.BindingResult;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.servlet.mvc.support.RedirectAttributes;
//
//import java.util.LinkedHashMap;
//import java.util.List;
//import java.util.Map;
//
//@Log4j2
//@Controller
//@RequiredArgsConstructor
//@RequestMapping("/myclass/exam")
//public class TeacherExamController {
//
//    private final ExamServiceIf examService;
//    private final TeacherServiceIf teacherService;
//    private final LectureServiceIf lectureService;
//
//    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의강의실", "url", "/myclass");
//
//    private void setBreadcrumb(Model model, Map<String, String> ... page) {
//        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
//        for (Map<String, String> p : page) {
//            pages.putAll(p);
//        }
//        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
//    }
//
//    @GetMapping("")
//    public String list(
//            @ModelAttribute ExamPageDTO pageDTO,
//            HttpServletRequest req,
//            Model model
//    ) {
//        HttpSession session = req.getSession();
//        String memberId = (String) session.getAttribute("memberId");
//
//        int totalCount = examService.getExamTotalCountByTeacherId(memberId, pageDTO);
//        pageDTO.setTotal_count(totalCount);
//
//        List<ExamResponseDTO> exams = examService.getExamListByTeacherId(memberId, pageDTO);
//
//        List<LectureDTO> lectures = teacherService.selectTeacherLecture(memberId);
//
//        model.addAttribute("totalCount", totalCount);
//        model.addAttribute("examList", exams);
//        model.addAttribute("lectureList", lectures);
//        model.addAttribute("pageDTO", pageDTO);
//
//        setBreadcrumb(model, Map.of("시험 관리", "/myclass/exam"));
//
//        return "myclass/exam/list";
//    }
//
//    @GetMapping("/regist")
//    public String registGET(
//            @ModelAttribute ExamPageDTO pageDTO,
//            HttpServletRequest req,
//            Model model
//    ) {
//        HttpSession session = req.getSession();
//        String memberId = (String) session.getAttribute("memberId");
//
//        List<LectureDTO> lectures = teacherService.selectTeacherLecture(memberId);
//
//        model.addAttribute("lectureList", lectures);
//        model.addAttribute("pageDTO", pageDTO);
//
//        setBreadcrumb(model, Map.of("시험 관리", "/myclass/exam"), Map.of("시험 등록", "/myclass/exam/regist"));
//        return "myclass/exam/regist";
//    }
//
//    @PostMapping("/regist")
//    public String registPOST(
//            @ModelAttribute ExamPageDTO pageDTO,
//            @Valid @ModelAttribute ExamDTO examDTO,
//            BindingResult bindingResult,
//            RedirectAttributes redirectAttributes,
//            HttpServletRequest req
//    ) {
//        if (bindingResult.hasErrors()) {
//            redirectAttributes.addFlashAttribute("errorMessage", "잘못된 입력이 있습니다. 다시 확인해주세요.");
//            redirectAttributes.addFlashAttribute("examDTO", examDTO);
//            return "redirect:/myclass/exam/regist?" + pageDTO.getLinkUrl();
//        }
//
//        HttpSession session = req.getSession();
//        String memberId = (String) session.getAttribute("memberId");
//
//        int lectureIdx = examDTO.getExamLectureIdx();
//        LectureDTO lecture = lectureService.getLectureByIdx(lectureIdx);
//
//        if (lecture == null) {
//            redirectAttributes.addFlashAttribute("errorMessage", "요청한 강좌를 찾을 수 없습니다.");
//            redirectAttributes.addFlashAttribute("examDTO", examDTO);
//            return "redirect:/myclass/exam/regist?" + pageDTO.getLinkUrl();
//        }
//        if (!lecture.getLectureTeacherId().equals(memberId)) {
//            redirectAttributes.addFlashAttribute("errorMessage", "등록 권한이 없습니다.");
//            return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//        }
//
//        examService.createExam(examDTO);
//
//        return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//    }
//
//    @PostMapping("/delete")
//    public String delete(
//            @ModelAttribute ExamPageDTO pageDTO,
//            @RequestParam("examIdx") int idx,
//            RedirectAttributes redirectAttributes,
//            HttpServletRequest req
//    ) {
//        HttpSession session = req.getSession();
//        String memberId = (String) session.getAttribute("memberId");
//
//        ExamResponseDTO examDTO = examService.getExamByIdx(idx);
//
//        int lectureIdx = examDTO.getExamLectureIdx();
//        LectureDTO lecture = lectureService.getLectureByIdx(lectureIdx);
//
//        if (lecture == null) {
//            redirectAttributes.addFlashAttribute("errorMessage", "요청한 강좌를 찾을 수 없습니다.");
//            return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//        }
//        if (!lecture.getLectureTeacherId().equals(memberId)) {
//            redirectAttributes.addFlashAttribute("errorMessage", "삭제 권한이 없습니다.");
//            return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//        }
//
//        examService.deleteExamByIdx(idx);
//
//        return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//    }
//
//    @PostMapping("/delete-multiple")
//    public String deleteMultiple(
//            @ModelAttribute TeacherFilePageDTO pageDTO,
//            @RequestParam("examIdxs") List<Integer> examIdxs,
//            RedirectAttributes redirectAttributes,
//            HttpServletRequest req
//    ) {
//        HttpSession session = req.getSession();
//        String memberId = (String) session.getAttribute("memberId");
//
//        for (int idx : examIdxs) {
//            ExamResponseDTO examDTO = examService.getExamByIdx(idx);
//
//            int lectureIdx = examDTO.getExamLectureIdx();
//            LectureDTO lecture = lectureService.getLectureByIdx(lectureIdx);
//
//            if (lecture == null) {
//                redirectAttributes.addFlashAttribute("errorMessage", "요청한 강좌를 찾을 수 없습니다.");
//                return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//            }
//            if (!lecture.getLectureTeacherId().equals(memberId)) {
//                redirectAttributes.addFlashAttribute("errorMessage", "삭제 권한이 없습니다.");
//                return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//            }
//
//            examService.deleteExamByIdx(idx);
//        }
//
//        return "redirect:/myclass/exam?" + pageDTO.getLinkUrl();
//    }
//}
