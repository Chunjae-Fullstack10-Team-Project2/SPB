package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.mystudy.PlanDetailResponseDTO;
import net.spb.spb.service.mystudy.PlanServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Log4j2
@RequiredArgsConstructor
@Controller
@RequestMapping("/mystudy")
public class PlanController {
    private final PlanServiceIf planService;

    @GetMapping("/plan")
    public String lists(@RequestParam LocalDate date, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        // List<PlanDetailResponseDTO> todayPlans = planService.selectTodayList();

        return "mystudy/plan";
    }
}
