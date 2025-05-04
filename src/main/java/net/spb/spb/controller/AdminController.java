package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.service.member.MemberServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("admin")
public class AdminController {

    private final MemberServiceIf memberService;

    @GetMapping("/member/list")
    public void memberList(Model model) {
        List<MemberDTO> memberDTOs = memberService.getMembers();
        model.addAttribute("list", memberDTOs);
    }

    @PostMapping("/member/update")
    public String memberModify(@ModelAttribute MemberDTO memberDTO) {
        memberService.updateMemberByAdmin(memberDTO);
        return "/admin/member/update-success";
    }

    @PostMapping("/member/state")
    public String memberModifyState(@ModelAttribute MemberDTO memberDTO) {
        memberService.updateMemberState(memberDTO);
        return "redirect:/admin/member/list";
    }

    @GetMapping("/member/view")
    public void memberView(@RequestParam("memberId")String memberId, Model model) {
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);
    }
}
