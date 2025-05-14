package net.spb.spb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/error")
public class CustomErrorController {

    @GetMapping("/404")
    public String handle404(Model model) {
        model.addAttribute("title", "404 - 페이지 없음");
        model.addAttribute("heading", "404 - 페이지를 찾을 수 없습니다");
        model.addAttribute("message", "요청하신 페이지가 존재하지 않거나, 삭제되었거나, 주소가 잘못 입력되었습니다.");
        return "error/common";
    }

    @GetMapping("/500")
    public String handle500(Model model) {
        model.addAttribute("title", "500 - 서버 오류");
        model.addAttribute("heading", "500 - 내부 서버 오류");
        model.addAttribute("message", "요청 처리 중 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.");
        return "error/common";
    }

    @GetMapping("/invalidParam")
    public String handleInvalidParam(Model model) {
        model.addAttribute("title", "잘못된 요청");
        model.addAttribute("heading", "잘못된 요청입니다");
        model.addAttribute("message", "요청한 파라미터가 잘못되었습니다. 다시 시도해주세요.");
        return "error/common";
    }
}
