package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.qna.AnswerDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.service.member.MemberServiceImpl;
import net.spb.spb.service.qna.QnaService;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@Log4j2
@RequestMapping(value = "/qna")
public class QnaController {

    @Autowired
    private QnaService qnaService;

    @Autowired
    private MemberServiceImpl memberService;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "1:1 문의", "url", "/qna/list");

    // 브레드크럼
    private void setBreadcrumb(Model model, Map<String, String>... pagePairs) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> page : pagePairs) {
            pages.putAll(page);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }
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
        setBreadcrumb(model, Map.of("목록", ""));

        return "qna/list";
    }

    @GetMapping("/regist")
    public String regist(@ModelAttribute QnaDTO qnaDTO, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        qnaDTO.setQnaQMemberId(memberId);

        model.addAttribute("qnaDTO", qnaDTO);
        setBreadcrumb(model, Map.of("등록", ""));

        return "qna/regist";
    }

    @PostMapping("/regist")
    public String regist(@Valid @ModelAttribute QnaDTO qnaDTO, BindingResult bindingResult, HttpSession session, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("errorMessage", "오류가 발생했습니다. 다시 시도해주세요.");
            return "qna/regist";
        }

        String pwd = qnaDTO.getQnaQPwd();
        if (pwd != null && pwd.trim().isEmpty()) {
            qnaDTO.setQnaQPwd(null);
        }

        if (pwd != null && !pwd.trim().isEmpty() && !pwd.matches("^\\d{4}$")) {
            model.addAttribute("message", "비밀번호는 숫자 네 자리여야 합니다.");
            model.addAttribute("qnaDTO", qnaDTO);
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
        setBreadcrumb(model, Map.of("조회", ""));

        return "qna/view";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("qnaIdx") String qnaIdx, Model model, HttpSession session) {
        int memberGrade = Integer.parseInt(session.getAttribute("memberGrade").toString());
        if (memberGrade != 0) {
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
    public String answer(@RequestParam("qnaIdx") String qnaIdx, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        int memberGrade = Integer.parseInt(session.getAttribute("memberGrade").toString());
        if (memberGrade != 0) {
            return "redirect:/qna/view?qnaIdx=" + qnaIdx + "&message=unauthorized";
        }

        QnaDTO qnaDTO = qnaService.view(qnaIdx);
        if (qnaDTO == null) {
            model.addAttribute("message", "해당 질문을 찾을 수 없습니다.");
            return "redirect:/qna/list";
        }

        qnaDTO.setQnaAMemberId(memberId);
        model.addAttribute("qnaDTO", qnaDTO);
        setBreadcrumb(model, Map.of("답변 작성", ""));

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
                .totalCount(qnaService.myQnaTotalCount(searchDTO, qnaQMemberId))
                .dtoList(qnaList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("qnaList", qnaList);
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("내가 한 문의", ""));

        return "mypage/myQna";
    }

    @PostMapping("/checkPwd")
    @ResponseBody
    public ResponseEntity<String> checkPassword(@RequestParam("qnaQPwd") String qnaQPwd,
                                                @RequestParam("qnaIdx") String qnaIdx) {
        String originalPwd = qnaService.getPwdByQnaIdx(qnaIdx);

        if (originalPwd == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("fail");
        }

        if (qnaQPwd != null && qnaQPwd.equals(originalPwd)) {
            return ResponseEntity.ok("success");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("fail");
        }
    }
}