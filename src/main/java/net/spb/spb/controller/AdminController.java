package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.MemberPageDTO;
import net.spb.spb.dto.PostReportDTO;
import net.spb.spb.dto.ReportPageDTO;
import net.spb.spb.dto.member.MemberDTO;
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
        if (memberPageDTO.getSearch_member_grade()!=null && memberPageDTO.getSearch_member_grade().trim().equals("")) memberPageDTO.setSearch_member_grade(null);
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
    public void memberView(@RequestParam("memberId")String memberId, Model model) {
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);
    }

    @GetMapping("/report/list")
    public void reportList(@ModelAttribute ReportPageDTO reportPageDTO, Model model) {
        List<PostReportDTO> reports = reportService.getReports(reportPageDTO);
        model.addAttribute("search", reportPageDTO);
        model.addAttribute("reports", reports);
    }

}
