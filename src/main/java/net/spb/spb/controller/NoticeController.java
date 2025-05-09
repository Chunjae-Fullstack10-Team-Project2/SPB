package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.NoticeDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.service.NoticeService;
import net.spb.spb.util.NoticePaging;
import net.spb.spb.util.Paging;
import net.spb.spb.util.PagingUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notice")
public class NoticeController {

    private final NoticeService noticeService;


//    @GetMapping("/list")
//    public String list(@RequestParam(name = "page", defaultValue = "1") int page,
//                       @RequestParam(name = "size", defaultValue = "5") int size,
//                       @RequestParam(name = "keyword", required = false) String keyword,
//                       @RequestParam(name = "searchType", required = false) String searchType,
//                       Model model) throws Exception {
//
//
//        int offset = NoticePaging.getOffset(page, size);
//        List<NoticeDTO> list;
//
//        int totalCount = 0;
//
//        List<NoticeDTO> fixedList = noticeService.getFixedNotices();
//
//
//        int totalPage = NoticePaging.getTotalPage(totalCount, size);
//
//        String pagination = NoticePaging.getPagination(page, totalPage, "/notice/list", keyword, searchType, size);
//
//        int listNumber = NoticePaging.getStartNum(totalCount, page, size);
//
//        model.addAttribute("list", list);
//        model.addAttribute("fixedList", fixedList);
//        model.addAttribute("pagination", pagination);
//        model.addAttribute("currentPage", page);
//        model.addAttribute("totalPage", totalPage);
//        model.addAttribute("size", size);
//        model.addAttribute("keyword", keyword);
//        model.addAttribute("searchType", searchType);
//        model.addAttribute("listNumber", listNumber);
//
//        return "notice/list";
//    }

    @GetMapping("/view")
    public String view(@RequestParam("noticeIdx") int noticeIdx, Model model) throws Exception {
        NoticeDTO dto = noticeService.getDetail(noticeIdx);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String createdAtStr = dto.getNoticeCreatedAt().format(formatter);

        String updatedAtStr = null;
        if (!dto.getNoticeCreatedAt().isEqual(dto.getNoticeUpdatedAt())) {
            updatedAtStr = dto.getNoticeUpdatedAt().format(formatter);
        }

        model.addAttribute("dto", dto);
        model.addAttribute("createdAtStr", createdAtStr);
        model.addAttribute("updatedAtStr", updatedAtStr);

        return "notice/view";
    }

    @GetMapping("/regist")
    public String registForm(HttpSession session) {
        // 세션에서 회원 정보 가져오기
        Object memberObj = session.getAttribute("member");
        if (memberObj == null || !(memberObj instanceof MemberDTO) ||
                !((MemberDTO)memberObj).getMemberGrade().equals("0")) {
            // 관리자가 아닌 경우 리스트로 리다이렉트
            return "redirect:/notice/list";
        }
        return "notice/regist";
    }

    @PostMapping("/regist")
    public String regist(@ModelAttribute NoticeDTO dto, HttpSession session) throws Exception {
        // 세션에서 회원 정보 가져오기
        Object memberObj = session.getAttribute("member");
        if (memberObj == null || !(memberObj instanceof MemberDTO) ||
                !((MemberDTO)memberObj).getMemberGrade().equals("0")) {
            // 관리자가 아닌 경우 리스트로 리다이렉트
            return "redirect:/notice/list";
        }

        // 현재 로그인한 사용자 아이디 설정
        MemberDTO member = (MemberDTO) memberObj;
        dto.setNoticeMemberId(member.getMemberId());

        noticeService.register(dto);
        return "redirect:/notice/list";
    }

    @GetMapping("/modify")
    public String modifyForm(@RequestParam("noticeIdx") int noticeIdx, Model model) throws Exception {
        NoticeDTO dto = noticeService.getDetail(noticeIdx);
        model.addAttribute("dto", dto);
        return "notice/modify";
    }

    @PostMapping("/modify")
    public String modify(@ModelAttribute NoticeDTO dto) throws Exception {
        dto.setNoticeMemberId("system");
        noticeService.update(dto);
        return "redirect:/notice/view?noticeIdx=" + dto.getNoticeIdx();
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("noticeIdx") int noticeIdx) throws Exception {
        noticeService.delete(noticeIdx);
        return "redirect:/notice/list";
    }

    @PostMapping("/fix")
    public String fixNotice(@RequestParam(name = "noticeIdx") int noticeIdx) {
        noticeService.fixNotice(noticeIdx);
        return "redirect:/notice/list";
    }

    @PostMapping("/unfix")
    public String unfixNotice(@RequestParam(name = "noticeIdx") int noticeIdx) {
        noticeService.unfixNotice(noticeIdx);
        return "redirect:/notice/list";
    }

}
