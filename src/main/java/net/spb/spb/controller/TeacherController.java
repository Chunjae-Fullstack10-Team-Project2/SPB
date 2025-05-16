package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.lecture.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.pagingsearch.*;
import net.spb.spb.dto.teacher.*;
import net.spb.spb.service.teacher.TeacherFileServiceIf;
import net.spb.spb.service.teacher.TeacherNoticeServiceIf;
import net.spb.spb.service.teacher.TeacherQnaServiceIf;
import net.spb.spb.service.teacher.TeacherServiceIf;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
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
@RequestMapping(value = "/teacher")
public class TeacherController {

    private final TeacherServiceIf teacherService;
    private final TeacherQnaServiceIf teacherQnaService;
    private final TeacherFileServiceIf teacherFileService;
    private final TeacherNoticeServiceIf teacherNoticeService;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "선생님", "url", "/teacher");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String teacherMain(
            @RequestParam(value="subject", required = false) String subject,
            Model model,
            @ModelAttribute SearchDTO searchDTO,
            @ModelAttribute PageRequestDTO pageRequestDTO
    ) {
        pageRequestDTO.setPageSize(12);
        List<TeacherDTO> teacherList;
        if(subject == null || subject.isBlank()) {
            teacherList = teacherService.getAllTeacher(searchDTO, pageRequestDTO);
        } else {
            teacherList = teacherService.getTeacherMain(subject, searchDTO, pageRequestDTO);
        }
        model.addAttribute("teacherDTO", teacherList);
        List<String> subjectList = teacherService.getAllSubject();
        model.addAttribute("subjectList", subjectList);

        PageResponseDTO<TeacherDTO> pageResponseDTO = PageResponseDTO.<TeacherDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(teacherService.getTotalCount(searchDTO, subject))
                .dtoList(teacherList)
                .build();
        model.addAttribute("responseDTO", pageResponseDTO);
        return "teacher/teacherMain";
    }

    @GetMapping("/personal")
    public String teacherPersonalMain(
            @RequestParam("teacherId") String teacherId,
            Model model, HttpSession session
    ) {
        String memberId = (String) session.getAttribute("memberId");
        List<Integer> bookmarked = teacherService.selectBookmark(teacherId, memberId);
        model.addAttribute("bookmarked", bookmarked);

        TeacherDTO teacherDTO = teacherService.selectTeacher(teacherId);
        log.info("teacherDTO: {}",teacherDTO);
        List<LectureDTO> lectureList = teacherService.selectTeacherLecture(teacherId);
        log.info("lectureList: {}",lectureList);
        model.addAttribute("teacherDTO", teacherDTO);
        model.addAttribute("lectureList", lectureList);
        return "teacher/teacherPersonal";
    }

    @GetMapping("/personal/library")
    public String teacherLibraryList(@ModelAttribute TeacherFilePageDTO pageDTO, Model model) {
        List<TeacherFileResponseDTO> files = teacherFileService.getTeacherFileList(pageDTO.getTeacherId(), pageDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("fileList", files);

        setBreadcrumb(model, Map.of("자료실", "/teacher/library"));

        return "teacher/library/list";
    }

    @GetMapping("/personal/library/view")
    public String teacherLibraryView(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            Model model
    ) {
        TeacherFileResponseDTO teacherFileDTO = teacherFileService.getTeacherFileByIdx(idx);

        if (teacherFileDTO == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "요청한 자료를 찾을 수 없습니다.");
            return "redirect:/teacher/personal/library?teacherId=" + pageDTO.getTeacherId();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherFileDTO", teacherFileDTO);

        setBreadcrumb(model, Map.of("자료실", "/teacher/library"), Map.of("자료실 상세보기", "/teacher/library/view"));

        return "teacher/library/view";
    }

    @GetMapping("/personal/notice")
    public String teacherNoticeList(@ModelAttribute TeacherNoticePageDTO pageDTO, Model model) {
        List<TeacherNoticeResponseDTO> notices = teacherNoticeService.getTeacherNoticeList(pageDTO.getTeacherId(), pageDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("noticeList", notices);

        setBreadcrumb(model, Map.of("공지사항", "/teacher/notice"));

        return "teacher/notice/list";
    }

    @GetMapping("/personal/notice/view")
    public String teacherNoticeView(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            Model model
    ) {
        TeacherNoticeResponseDTO teacherNoticeDTO = teacherNoticeService.getTeacherNoticeByIdx(idx);

        if (teacherNoticeDTO == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "요청한 자료를 찾을 수 없습니다.");
            return "redirect:/teacher/personal/notice?teacherId=" + pageDTO.getTeacherId();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherNoticeDTO", teacherNoticeDTO);

        setBreadcrumb(model, Map.of("공지사항", "/teacher/notice"), Map.of("공지사항 상세보기", "/teacher/notice/view"));

        return "teacher/notice/view";
    }

    @GetMapping("/personal/qna")
    public String teacherQnaList(@ModelAttribute TeacherQnaPageDTO pageDTO, Model model) {
        String teacherId = pageDTO.getTeacherId();
        TeacherDTO teacherDTO = teacherService.selectTeacher(teacherId);

        TeacherQnaListRequestDTO reqDTO = TeacherQnaListRequestDTO.builder()
                .where_column("ttq.teacherQnaAMemberId")
                .where_value(teacherId)
                .build();

        List<TeacherQnaResponseDTO> qnas = teacherQnaService.getTeacherQnaList(reqDTO, pageDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("qnaList", qnas);

        setBreadcrumb(model, Map.of(teacherDTO.getTeacherName() + " 선생님", "/teacher/personal"), Map.of("QnA", "/teacher/personal/qna"));

        return "teacher/qna/list";
    }

    @GetMapping("/personal/qna/view")
    public String teacherQnaView(
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            Model model
    ) {
        String teacherId = pageDTO.getTeacherId();
        TeacherDTO teacherDTO = teacherService.selectTeacher(teacherId);
        TeacherQnaResponseDTO teacherQnaDTO = teacherQnaService.getTeacherQnaByIdx(idx);

        if (teacherQnaDTO == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "요청한 QnA를 찾을 수 없습니다.");
            return "redirect:/teacher/personal/qna?teacherId=" + pageDTO.getTeacherId();
        }

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherQnaDTO", teacherQnaDTO);

        setBreadcrumb(model, Map.of(teacherDTO.getTeacherName() + " 선생님", "/teacher/personal"), Map.of("QnA", "/teacher/personal/qna"), Map.of("QnA 상세보기", "/teacher/personal/qna/view"));

        return "teacher/qna/view";
    }

    @GetMapping("/personal/qna/regist")
    public String teacherQnaRegistGET(@ModelAttribute TeacherQnaPageDTO pageDTO, Model model) {
        String teacherId = pageDTO.getTeacherId();
        TeacherDTO teacherDTO = teacherService.selectTeacher(teacherId);
        model.addAttribute("pageDTO", pageDTO);
        setBreadcrumb(model, Map.of(teacherDTO.getTeacherName() + " 선생님", "/teacher/personal"), Map.of("QnA", "/teacher/personal/qna"), Map.of("QnA 등록", "/teacher/personal/qna/regist"));
        return "teacher/qna/regist";
    }

    @PostMapping("/personal/qna/regist")
    public String teacherQnaRegistPOST(
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            @Valid @ModelAttribute TeacherQnaQuestionDTO teacherQnaDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("teacherQnaDTO", teacherQnaDTO);
            return "redirect:/teacher/personal/qna/regist?" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        teacherQnaDTO.setTeacherQnaQMemberId(memberId);
        teacherQnaService.createTeacherQuestion(teacherQnaDTO);

        return "redirect:/teacher/personal/qna?" + pageDTO.getLinkUrl();
    }

    @GetMapping("/personal/qna/delete")
    public String teacherQnaDelete(
            @ModelAttribute TeacherQnaPageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            Model model,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherQnaResponseDTO teacherQnaDTO = teacherQnaService.getTeacherQnaByIdx(idx);

        if (teacherQnaDTO == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "요청한 QnA를 찾을 수 없습니다.");
            return "redirect:/teacher/personal/qna?teacherId=" + pageDTO.getTeacherId();
        }
        if (!teacherQnaDTO.getTeacherQnaQMemberId().equals(memberId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "삭제 권한이 없습니다.");
            return "redirect:/teacher/personal/qna?teacherId=" + pageDTO.getTeacherId() + "&idx=" + idx;
        }

        teacherQnaService.deleteTeacherQuestionByIdx(idx);

        model.addAttribute("pageDTO", pageDTO);

        return "redirect:/teacher/personal/qna?" + pageDTO.getLinkUrl();
    }

    @PostMapping("/personal/qna/checkPwd")
    @ResponseBody
    public ResponseEntity<String> checkPwd(@RequestParam("idx") int idx, @RequestParam("pwd") String pwd) {
        String originPwd = teacherQnaService.getTeacherQnaPwdByIdx(idx);

        if (originPwd == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("fail");
        }
        if (pwd != null && pwd.equals(originPwd)) {
            return ResponseEntity.ok("success");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("fail");
        }
    }

}
