package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.FaqDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.service.faq.FaqService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@Log4j2
@RequestMapping("/faq")
public class FaqController {
    @Autowired
    private FaqService faqService;

    @GetMapping("/list")
    public String faq(@ModelAttribute SearchDTO searchDTO,
                      @ModelAttribute PageRequestDTO pageRequestDTO,
                      Model model) {

        List<QnaDTO> faqList = faqService.faqList(searchDTO, pageRequestDTO);
        PageResponseDTO<QnaDTO> pageResponseDTO = PageResponseDTO.<QnaDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(faqService.totalCount(searchDTO))
                .dtoList(faqList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("faqList", faqList);
        model.addAttribute("searchDTO", searchDTO);
        return "faq/list";
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<String> updateFaq(@RequestBody FaqDTO faqDTO) {
        try {
            faqService.update(faqDTO);
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            log.error("FAQ 수정에 실패했습니다.", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
        }
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> deleteFaq(@RequestBody String faqIdx) {
        try {
            faqService.delete(faqIdx);
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            log.error("FAQ 삭제에 실패했습니다.", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
        }
    }

    @GetMapping("/regist")
    public String create(@ModelAttribute FaqDTO faqDTO, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");

        model.addAttribute("faqDTO", faqDTO);
        return "faq/regist";
    }

    @PostMapping("/regist")
    public String regist(@ModelAttribute FaqDTO faqDTO, BindingResult bindingResult, HttpSession session, Model model) {
        if (bindingResult.hasErrors()) {
            return "fqa/regist";
        }

        model.addAttribute("faqDTO", faqDTO);

        boolean result = faqService.create(faqDTO);
        if (result) {
            model.addAttribute("message", "자주 묻는 질문을 등록했습니다.");
            return "redirect:/faq/list";
        }
        return "faq/regist";
    }

}
