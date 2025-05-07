package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.NoticeDTO;
import net.spb.spb.service.NoticeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notice")
public class NoticeController {

    private final NoticeService noticeService;

    @GetMapping("/list")
    public String list(@RequestParam(name = "page", defaultValue = "1") int page,
                       @RequestParam(name = "size", defaultValue = "5") int size,
                       @RequestParam(name = "keyword", required = false) String keyword,
                       @RequestParam(name = "searchType", required = false) String searchType,
                       Model model) throws Exception {

        int offset = (page - 1) * size;
        List<NoticeDTO> list;
        int totalCount;

        if (keyword != null && !keyword.trim().isEmpty()) {
            if ("content".equals(searchType)) {
                totalCount = noticeService.getSearchCountByContent(keyword);
                list = noticeService.searchByContent(keyword, offset, size);
            } else {
                totalCount = noticeService.getSearchCountByTitle(keyword);
                list = noticeService.searchByTitle(keyword, offset, size);
            }
        } else {
            totalCount = noticeService.getTotalCount();
            list = noticeService.getListPaged(offset, size);
        }

        List<NoticeDTO> fixedList = noticeService.getFixedNotices();
        int totalPage = (int) Math.ceil((double) totalCount / size);

        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPage, page + 2);
        int prevPage = page > 1 ? page - 1 : 1;
        int nextPage = page < totalPage ? page + 1 : totalPage;

        model.addAttribute("prevPage", prevPage);
        model.addAttribute("nextPage", nextPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("list", list);
        model.addAttribute("fixedList", fixedList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("size", size);
        model.addAttribute("keyword", keyword);
        model.addAttribute("searchType", searchType);
        return "notice/list";
    }

    @GetMapping("/view")
    public String view(@RequestParam("noticeIdx") int noticeIdx, Model model) throws Exception {
        NoticeDTO dto = noticeService.getDetail(noticeIdx);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        String createdAtStr = dto.getNoticeCreatedAt().format(formatter);
        String updatedAtStr = dto.getNoticeUpdatedAt().format(formatter);

        model.addAttribute("dto", dto);
        model.addAttribute("createdAtStr", createdAtStr);
        model.addAttribute("updatedAtStr", updatedAtStr);

        return "notice/view";
    }

    @GetMapping("/regist")
    public String registForm() {
        return "notice/regist";
    }

    @PostMapping("/regist")
    public String regist(@ModelAttribute NoticeDTO dto) throws Exception {
        dto.setNoticeMemberId("system");
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
    @ResponseBody
    public String fixNotice(@RequestParam int noticeIdx) {
        if (noticeService.countFixedNotices() >= 3) return "LIMIT";
        noticeService.fixNotice(noticeIdx);
        return "OK";
    }

    @PostMapping("/unfix")
    @ResponseBody
    public String unfixNotice(@RequestParam int noticeIdx) {
        noticeService.unfixNotice(noticeIdx);
        return "OK";
    }
}
