package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.service.lecture.LectureServiceIf;
import net.spb.spb.service.PaymentServiceIf;
import net.spb.spb.service.teacher.TeacherServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/lecture")
public class LectureController {

    private final TeacherServiceIf teacherService;
    private final PaymentServiceIf paymentService;
    private final LectureServiceIf lectureService;

    @GetMapping("/main")
    public String lectureMain(
            @RequestParam(value="subject", required = false) String subject,
            Model model,
            @ModelAttribute SearchDTO searchDTO,
            @ModelAttribute PageRequestDTO pageRequestDTO) {
        List<LectureDTO> lectureList;
        log.info("subject: "+subject);
        if(subject == null || subject.isBlank()) {
            lectureList = lectureService.getAllLectures(searchDTO, pageRequestDTO);
        } else {
            lectureList = lectureService.getLectureMain(subject, searchDTO, pageRequestDTO);
        }
        log.info("lecture list: {}", lectureList);
        model.addAttribute("lectureDTO", lectureList);
        List<String> subjectList = teacherService.getAllSubject();
        model.addAttribute("subjectList", subjectList);

        PageResponseDTO<LectureDTO> pageResponseDTO = PageResponseDTO.<LectureDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(lectureService.getTotalCount(searchDTO, subject))
                .dtoList(lectureList)
                .build();
        model.addAttribute("responseDTO", pageResponseDTO);
        return "lecture/lecture";
    }

    @GetMapping("/lectureDetail")
    public String lectureDetail(
            @RequestParam("lectureIdx") int lectureIdx,
            Model model
    ){
        LectureDTO lectureDTO = lectureService.selectLectureMain(lectureIdx);
        List<ChapterDTO> chapterList = lectureService.selectLectureChapter(lectureIdx);
        log.info("chapterList: {}",chapterList);
        int chapterCount = chapterList.size();
        log.info("chapterCount: {}",chapterCount);
        log.info("chapterList: {}",chapterList);
        model.addAttribute("lectureDTO", lectureDTO);
        model.addAttribute("chapterList", chapterList);
        model.addAttribute("chapterCount", chapterCount);
        return "lecture/lectureMain";
    }

    @PostMapping("/addBookmark")
    @ResponseBody
    public int addBookmark(@RequestParam("lectureIdx") int lectureIdx, HttpSession session){
        String memberId = (String) session.getAttribute("memberId");
        return lectureService.addBookmark(lectureIdx, memberId);
    }

    @PostMapping("/deleteBookmark")
    @ResponseBody
    public int deleteBookmark(@RequestParam("lectureIdx") int lectureIdx, HttpSession session){
        String memberId = (String) session.getAttribute("memberId");
        return lectureService.deleteBookmark(lectureIdx, memberId);
    }

    @GetMapping("/chapter/play")
    public String playVideo(@RequestParam("chapterIdx") int chapterIdx, Model model) {
        log.info("💡 컨트롤러 진입 확인");
        ChapterDTO chapter = lectureService.getChapterById(chapterIdx);
        model.addAttribute("chapter", chapter);
        return "lecture/chapterPlay";
    }
}
