package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.MemberDTO;
import net.spb.spb.dto.QnaDTO;
import net.spb.spb.service.MemberServiceImpl;
import net.spb.spb.service.Qna.QnaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@Log4j2
@RequestMapping(value = "/qna")
public class QnaController {

    @Autowired
    private QnaService qnaService;

    @Autowired
    private MemberServiceImpl memberService;

    @GetMapping("/list")
    public String qna(Model model) {
        List<QnaDTO> qnaList = qnaService.qnaList();
        model.addAttribute("qnaList", qnaList);
        return "qna/list";
    }

    @GetMapping("/regist")
    public String regist(@ModelAttribute QnaDTO qnaDTO, HttpSession session, Model model) {

        String memberId = (String) session.getAttribute("memberId");
        qnaDTO.setQnaQMemberId(memberId);

        model.addAttribute("qnaDTO", qnaDTO);
        return "qna/regist";
    }

    @PostMapping("/regist")
    public String regist(@ModelAttribute QnaDTO qnaDTO, BindingResult bindingResult, HttpServletRequest request, HttpSession session, Model model) {
        if (bindingResult.hasErrors()) {
            return "qna/regist";
        }

        String memberId = (String) session.getAttribute("memberId");
        qnaDTO.setQnaQMemberId(memberId);

        model.addAttribute("qnaDTO", qnaDTO);

        boolean result = qnaService.createQ(qnaDTO);
        if (result) {
            model.addAttribute("message", "문의를 등록했습니다.");
            return "redirect:/qna/list";
        }
        return "qna/regist";
    }

    @GetMapping("/view")
    public String view(@RequestParam("qnaIdx") String qnaIdx, Model model) {
        QnaDTO qnaDTO = qnaService.view(qnaIdx);
        model.addAttribute("qnaDTO", qnaDTO);
        return "qna/view";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("qnaIdx") String qnaIdx, Model model) {
        boolean result = qnaService.delete(qnaIdx);
        if (result) {
            model.addAttribute("message", "문의를 삭제했습니다.");
            return "redirect:/list";
        }
        return "redirect:/list";
    }

    @GetMapping("/regist/answer")
    public String answer(@RequestParam("qnaIdx") String qnaIdx, @ModelAttribute QnaDTO qnaDTO, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        qnaDTO.setQnaAMemberId(memberId);

        MemberDTO memberDTO = memberService.getMemberById(memberId);
        int memberGrade = Integer.parseInt(memberDTO.getMemberGrade());

        if (memberGrade != 0 && memberGrade != 13) {
            model.addAttribute("message", "답변 권한이 없습니다.");
            return "qna/view";
        }

        model.addAttribute("qnaDTO", qnaDTO);
        return "qna/answerRegist";
    }

    @PostMapping("/regist/answer")
    public String answer(@RequestParam("qnaIdx") String qnaIdx, @ModelAttribute QnaDTO qnaDTO, BindingResult bindingResult, HttpSession session, Model model) {
        if (bindingResult.hasErrors()) {
            return "qna/answerRegist";
        }
        String memberId = (String) session.getAttribute("memberId");
        qnaDTO.setQnaAMemberId(memberId);

        model.addAttribute("qnaDTO", qnaDTO);

        boolean result = qnaService.updateA(qnaDTO);
        if (result) {
            model.addAttribute("message", "답변을 등록했습니다.");
            return "redirect:/view";
        }
        return "qna/view";
    }


}
