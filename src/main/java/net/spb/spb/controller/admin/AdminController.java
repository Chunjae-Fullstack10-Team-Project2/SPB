package net.spb.spb.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController extends AdminBaseController {

    @GetMapping({"","/"})
    public String adminMain(Model model) {
        setBreadcrumb(model, Map.of("관리 페이지", ""));
        return "admin/main";
    }

}

