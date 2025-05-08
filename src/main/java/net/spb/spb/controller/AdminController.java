package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.*;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.service.ReportService;
import net.spb.spb.service.member.MemberServiceIf;
import net.spb.spb.util.PagingUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final MemberServiceIf memberService;
    private final ReportService reportService;

    @GetMapping("/member/list")
    public void memberList(@ModelAttribute MemberPageDTO memberPageDTO, Model model, HttpServletRequest req) {
        String baseUrl = req.getRequestURI();
        memberPageDTO.setLinkUrl(PagingUtil.buildMemberLinkUrl(baseUrl, memberPageDTO));
        if (memberPageDTO.getSearch_member_grade() != null && memberPageDTO.getSearch_member_grade().trim().equals(""))
            memberPageDTO.setSearch_member_grade(null);
        int total_count = memberService.getMemberCount(memberPageDTO);
        memberPageDTO.setTotal_count(total_count);
        String paging = PagingUtil.pagingArea(memberPageDTO);
        List<MemberDTO> memberDTOs = memberService.getMembers(memberPageDTO);
        model.addAttribute("searchDTO", memberPageDTO);
        model.addAttribute("list", memberDTOs);
        model.addAttribute("memberTotalCount", total_count);
        model.addAttribute("paging", paging);
    }

    @PostMapping("/member/update")
    public String memberModify(@ModelAttribute MemberDTO memberDTO) {
        memberService.updateMemberByAdmin(memberDTO);
        return "/admin/member/update-success";
    }

    @PostMapping("/member/state")
    public String memberModifyState(@ModelAttribute MemberPageDTO memberPageDTO, @ModelAttribute MemberDTO memberDTO) {
        memberService.updateMemberState(memberDTO);
        String query = memberPageDTO.toQueryString();
        return "redirect:/admin/member/list?" + query;
    }

    @GetMapping("/member/view")
    public void memberView(@RequestParam("memberId") String memberId, Model model) {
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);
    }

    @GetMapping("/report/list")
    public String reportList() {
        return "admin/report/list";
    }

    @GetMapping("/report/list/board")
    public String boardReportList(@ModelAttribute SearchDTO searchDTO,
                             @ModelAttribute PageRequestDTO pageRequestDTO,
                             Model model) {
        List<PostReportDTO> boardReportList = reportService.listBoardReport(searchDTO, pageRequestDTO);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageResponseDTO.<PostReportDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(reportService.boardReportTotalCount(searchDTO))
                .dtoList(boardReportList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("boardReportList", boardReportList);
        model.addAttribute("searchDTO", searchDTO);
        return "admin/report/list";
    }

    @GetMapping("/report/list/review")
    public String reviewReportList(@ModelAttribute SearchDTO searchDTO,
                             @ModelAttribute PageRequestDTO pageRequestDTO,
                             Model model) {
        List<PostReportDTO> reviewReportList = reportService.listReviewReport(searchDTO, pageRequestDTO);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageResponseDTO.<PostReportDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(reportService.reviewReportTotalCount(searchDTO))
                .dtoList(reviewReportList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("reviewReportList", reviewReportList);
        model.addAttribute("searchDTO", searchDTO);
        return "admin/report/list";
    }
}