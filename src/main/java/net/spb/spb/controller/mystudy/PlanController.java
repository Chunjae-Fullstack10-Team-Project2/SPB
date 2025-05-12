package net.spb.spb.controller.mystudy;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.mystudy.PlanDTO;
import net.spb.spb.dto.mystudy.PlanResponseDTO;
import net.spb.spb.dto.lecture.StudentLectureResponseDTO;
import net.spb.spb.service.PlanServiceIf;
import net.spb.spb.service.lecture.StudentLectureServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@RequiredArgsConstructor
@Controller
@RequestMapping("/mystudy/plan")
public class PlanController {
    private final PlanServiceIf planService;
    private final StudentLectureServiceIf studentLectureService;

    @GetMapping("")
    public String list(Model model, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        List<StudentLectureResponseDTO> lectures = studentLectureService.getStudentLectureList(memberId, null);

        model.addAttribute("lectureList", lectures);

        return "mystudy/plan";
    }

    @PostMapping("/regist")
    public String regist(@RequestParam("date") String date, PlanDTO planDTO, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        planDTO.setPlanMemberId(memberId);
        planService.insert(planDTO);

        return "redirect:/mystudy/plan?date=" + date;
    }

    @PostMapping("/delete")
    public String delete(PlanDTO planDTO, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        if(memberId.equals(planDTO.getPlanMemberId())) {
            planService.delete(planDTO.getPlanIdx());
        }

        return "redirect:/mystudy/plan";
    }

    @PostMapping("/modify")
    @ResponseBody
    public Map<String, Object> modify(@RequestBody PlanDTO planDTO, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        Map<String, Object> response = new HashMap<>();

        if (!memberId.equals(planDTO.getPlanMemberId())) {
            response.put("errorMessage", "수정 권한이 없습니다.");
            return response;
        }

        planService.update(planDTO);
        return response;
    }

    @GetMapping(value="/search", params="date")
    @ResponseBody
    public List<PlanResponseDTO> getPlansByDay(@RequestParam(value="date") String date, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        return planService.getPlanListByDay(memberId, LocalDate.parse(date));
    }

    @GetMapping(value="/search", params={"date1", "date2"})
    @ResponseBody
    public List<PlanResponseDTO> getPlansByMonth(@RequestParam(value="date1") String date1, @RequestParam(value="date2") String date2, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        return planService.getPlanListByMonth(memberId, LocalDate.parse(date1), LocalDate.parse(date2));
    }

    @GetMapping("/{idx}")
    @ResponseBody
    public PlanResponseDTO getPlanByIdx(@PathVariable("idx") int idx) {
        return planService.getPlanByIdx(idx);
    }
}
