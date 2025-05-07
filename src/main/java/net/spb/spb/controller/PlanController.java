package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PlanDTO;
import net.spb.spb.dto.mystudy.PlanResponseDTO;
import net.spb.spb.dto.mystudy.StudentLectureDTO;
import net.spb.spb.service.mystudy.PlanServiceIf;
import net.spb.spb.service.mystudy.StudentLectureServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Log4j2
@RequiredArgsConstructor
@Controller
@RequestMapping("/mystudy")
public class PlanController {
    private final PlanServiceIf planService;
    private final StudentLectureServiceIf studentLectureService;

    @GetMapping("/plan")
    public String list(Model model, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        List<StudentLectureDTO> lectures = studentLectureService.getStudentLectureList(memberId, null);

        model.addAttribute("lectureList", lectures);

        return "mystudy/plan";
    }

    @PostMapping("/plan/regist")
    public String regist(PlanDTO planDTO, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        planDTO.setPlanMemberId(memberId);
        planService.insert(planDTO);

        return "redirect:/mystudy/plan";
    }

    @GetMapping(value="/plan/search", params="date")
    @ResponseBody
    public List<PlanResponseDTO> getPlansByDay(@RequestParam(value="date") String date, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        return planService.getPlanListByDay(memberId, LocalDate.parse(date));
    }

    @GetMapping(value="/plan/search", params={"date1", "date2"})
    @ResponseBody
    public List<PlanResponseDTO> getPlansByMonth(@RequestParam(value="date1") String date1, @RequestParam(value="date2") String date2, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        return planService.getPlanListByMonth(memberId, LocalDate.parse(date1), LocalDate.parse(date2));
    }
}
