package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PageRequestDTO;
import net.spb.spb.dto.PageResponseDTO;
import net.spb.spb.dto.qna.AnswerDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.dto.qna.SearchDTO;
import net.spb.spb.service.member.MemberServiceImpl;
import net.spb.spb.service.Qna.QnaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
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
    public String qna(@ModelAttribute SearchDTO searchDTO,
                      @ModelAttribute PageRequestDTO pageRequestDTO,
                      Model model) {

        List<QnaDTO> qnaList = qnaService.searchQna(searchDTO, pageRequestDTO);
        PageResponseDTO<QnaDTO> pageResponseDTO = PageResponseDTO.<QnaDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(qnaService.totalCount(searchDTO))
                .dtoList(qnaList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("qnaList", qnaList);
        model.addAttribute("searchDTO", searchDTO);
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
    public String regist(@ModelAttribute QnaDTO qnaDTO, BindingResult bindingResult, HttpSession session, Model model) {
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
    public String view(@RequestParam("qnaIdx") String qnaIdx, Model model, HttpSession session) {
        QnaDTO qnaDTO = qnaService.view(qnaIdx);
        model.addAttribute("qnaDTO", qnaDTO);

        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            model.addAttribute("message", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        MemberDTO memberDTO = memberService.getMemberById(memberId);
        if (memberDTO == null) {
            return "redirect:/login";
        }

        String memberGrade = memberDTO.getMemberGrade();
        session.setAttribute("memberGrade", memberGrade);

        return "qna/view";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("qnaIdx") String qnaIdx, Model model, HttpSession session) {
        int memberGrade = Integer.parseInt(session.getAttribute("memberGrade").toString());
        if (memberGrade != 0 && memberGrade != 13) {
            return "redirect:/qna/view?qnaIdx=" + qnaIdx + "&message=unauthorized";
        } else {
            boolean result = qnaService.delete(qnaIdx);
            if (result) {
                model.addAttribute("message", "문의를 삭제했습니다.");
                return "redirect:/qna/list";
            } else {
                return "redirect:/qna/view?qnaIdx=" + qnaIdx + "&message=error";
            }
        }
    }

    @GetMapping("/regist/answer")
    public String answer(@RequestParam("qnaIdx") String qnaIdx, @ModelAttribute QnaDTO qnaDTO, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        qnaDTO.setQnaAMemberId(memberId);

        int memberGrade = Integer.parseInt(session.getAttribute("memberGrade").toString());
        if (memberGrade != 0 && memberGrade != 13) {
            return "redirect:/qna/view?qnaIdx=" + qnaIdx + "&message=unauthorized";
        }

        model.addAttribute("qnaDTO", qnaDTO);
        return "qna/answerRegist";
    }

    @PostMapping("/regist/answer")
    public String answer(@RequestParam("qnaIdx") String qnaIdx,
                         @Valid @ModelAttribute AnswerDTO answerDTO,
                         BindingResult bindingResult,
                         HttpSession session) {
        if (bindingResult.hasErrors()) {
            for (FieldError error : bindingResult.getFieldErrors()) {
                System.out.println("필드: " + error.getField() + " / 메시지: " + error.getDefaultMessage());
            }
            return "qna/answerRegist";
        }

        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        QnaDTO qnaDTO = new QnaDTO();
        qnaDTO.setQnaIdx(qnaIdx);
        qnaDTO.setQnaAMemberId(memberId);
        qnaDTO.setQnaAContent(answerDTO.getQnaAContent());
        qnaDTO.setQnaAnsweredAt(new Date());

        boolean result = qnaService.updateA(qnaDTO);

        if (result) {
            return "redirect:/qna/view?qnaIdx=" + qnaIdx + "&message=authorized";
        } else {
            return "redirect:/qna/view?qnaIdx=" + qnaIdx + "&message=error";
        }
    }

    @GetMapping("/myQna")
    public String myQna(Model model, HttpSession session,
                        @ModelAttribute SearchDTO searchDTO,
                        @ModelAttribute PageRequestDTO pageRequestDTO) {

        String qnaQMemberId = (String) session.getAttribute("memberId");

        List<QnaDTO> qnaList = qnaService.myQna(searchDTO, pageRequestDTO, qnaQMemberId);
        PageResponseDTO<QnaDTO> pageResponseDTO = PageResponseDTO.<QnaDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(qnaService.totalCount(searchDTO))
                .dtoList(qnaList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("qnaList", qnaList);
        model.addAttribute("searchDTO", searchDTO);
        return "qna/list";
    }

}