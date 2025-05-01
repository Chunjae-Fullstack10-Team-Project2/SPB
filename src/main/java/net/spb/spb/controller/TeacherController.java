package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.service.TeacherServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/teacher")
public class TeacherController {
    private final TeacherServiceIf teacherService;

    @GetMapping("/personal")
    public String teacherMain(
            @RequestParam("teacherId") String teacherId,
            Model model
    ) {
        TeacherDTO teacherDTO = teacherService.selectTeacher(teacherId);
        log.info("teacherDTO: {}",teacherDTO);
        List<LectureDTO> lectureList = teacherService.selectTeacherLecture(teacherId);
        log.info("lectureList: {}",lectureList);
        model.addAttribute("teacherDTO", teacherDTO);
        model.addAttribute("lectureList", lectureList);
        return "teacher/teacherPersonal";
    }

    @GetMapping("/lecture")
    public String lectureMain(
            @RequestParam("lectureIdx") int lectureIdx,
            Model model
    ){
        LectureDTO lectureDTO = teacherService.selectLectureMain(lectureIdx);
        List<ChapterDTO> chapterList = teacherService.selectLectureChapter(lectureIdx);
        log.info("chapterList: {}",chapterList);
        model.addAttribute("lectureDTO", lectureDTO);
        model.addAttribute("chapterList", chapterList);
        return "teacher/lectureMain";
    }
}
