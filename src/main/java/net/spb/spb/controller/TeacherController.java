package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.BookmarkDTO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.service.PaymentServiceIf;
import net.spb.spb.service.TeacherServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/teacher")
public class TeacherController {
    private final TeacherServiceIf teacherService;
    private final PaymentServiceIf paymentService;

    @GetMapping("/main")
    public String teacherMain(
            @RequestParam(value="subject", required = false) String subject,
            Model model,
            @ModelAttribute SearchDTO searchDTO,
            @ModelAttribute PageRequestDTO pageRequestDTO
    ) {
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
}
