package net.spb.spb.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.service.AdminService;
import net.spb.spb.service.qna.QnaService;
import net.spb.spb.util.BreadcrumbUtil;
import net.spb.spb.util.PageUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminQnaController extends AdminBaseController {

    private final QnaService qnaService;

    @GetMapping("/qna/list")
    public String qna(@ModelAttribute SearchDTO searchDTO,
                      @ModelAttribute PageRequestDTO pageRequestDTO,
                      Model model) {

        int totalCount = qnaService.notAnsweredQnaTotalCount(searchDTO);
        PageResponseDTO<QnaDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> qnaService.notAnsweredQna(searchDTO, pageRequestDTO)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("notAnsweredQnaList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("미답변 문의 관리", ""));

        return "/admin/qna/list";
    }

}
