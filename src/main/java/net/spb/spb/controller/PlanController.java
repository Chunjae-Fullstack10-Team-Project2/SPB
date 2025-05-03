package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PlanListRequestDTO;
import net.spb.spb.dto.PlanListResponseDTO;
import net.spb.spb.service.PlanServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Log4j2
@RequiredArgsConstructor
@Controller
@RequestMapping("/my_study")
public class PlanController {
    private final PlanServiceIf planService;

    @GetMapping("/plan")
    public String lists() {
        return "my_study/plan";
    }
}
