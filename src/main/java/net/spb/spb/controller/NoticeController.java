package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.NoticeDTO;
import net.spb.spb.service.NoticeService;
import net.spb.spb.util.Paging;
import net.spb.spb.util.PagingUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.List;

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
//        int offset = Paging.getOffset(page, size);
//        List<NoticeDTO> list;
        int totalCount;

//        if (keyword != null && !keyword.trim().isEmpty()) {
//            if ("content".equals(searchType)) {
//                totalCount = noticeService.getSearchCountByContent(keyword);
//                list = noticeService.searchByContent(keyword, offset, size);
//            } else {
//                totalCount = noticeService.getSearchCountByTitle(keyword);
//                list = noticeService.searchByTitle(keyword, offset, size);
//            }
//        } else {
//            totalCount = noticeService.getTotalCount();
//            list = noticeService.getListPaged(offset, size);
//        }

        // 고정된 공지사항
//        List<NoticeDTO> fixedList = noticeService.getFixedNotices();
//
////        int totalPage = Paging.getTotalPage(totalCount, size);
//
//        String queryParams = "&size=" + size;
//        if (keyword != null && !keyword.trim().isEmpty()) {
//            queryParams += "&keyword=" + URLEncoder.encode(keyword, StandardCharsets.UTF_8);
//            if (searchType != null) {
//                queryParams += "&searchType=" + searchType;
//            }
//        }

//        int listNumber = totalCount - offset;

//        String paginationHtml = PagingUtil.getPagination(page, totalPage, "/notice/list", queryParams);
//
//        model.addAttribute("list", list);
//        model.addAttribute("pagination", paginationHtml);
//        model.addAttribute("currentPage", page);
//        model.addAttribute("totalPage", totalPage);
//        model.addAttribute("size", size);
//        model.addAttribute("keyword", keyword);
//        model.addAttribute("searchType", searchType);
//        model.addAttribute("listNumber", listNumber);
//        model.addAttribute("fixedList", fixedList);
//        return "notice/list";
//    }


//    @GetMapping("/view")
//    public String view(@RequestParam("noticeIdx") int noticeIdx, Model model) throws Exception {
//        NoticeDTO dto = noticeService.getDetail(noticeIdx);
//
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
//        String createdAtStr = dto.getNoticeCreatedAt().format(formatter);
//
//        String updatedAtStr = null;
//        if (!dto.getNoticeCreatedAt().isEqual(dto.getNoticeUpdatedAt())) {
//            updatedAtStr = dto.getNoticeUpdatedAt().format(formatter);
//        }
//
//        model.addAttribute("dto", dto);
//        model.addAttribute("createdAtStr", createdAtStr);
//        model.addAttribute("updatedAtStr", updatedAtStr);
//
//        return "notice/view";
//    }
//
//    @GetMapping("/regist")
//    public String registForm() {
//        return "notice/regist";
//    }
//
//    @PostMapping("/regist")
//    public String regist(@ModelAttribute NoticeDTO dto) throws Exception {
//        dto.setNoticeMemberId("system");
//        noticeService.register(dto);
//        return "redirect:/notice/list";
//    }
//
//    @GetMapping("/modify")
//    public String modifyForm(@RequestParam("noticeIdx") int noticeIdx, Model model) throws Exception {
//        NoticeDTO dto = noticeService.getDetail(noticeIdx);
//        model.addAttribute("dto", dto);
//        return "notice/modify";
//    }
//
//    @PostMapping("/modify")
//    public String modify(@ModelAttribute NoticeDTO dto) throws Exception {
//        dto.setNoticeMemberId("system");
//        noticeService.update(dto);
//        return "redirect:/notice/view?noticeIdx=" + dto.getNoticeIdx();
//    }
//
//    @PostMapping("/delete")
//    public String delete(@RequestParam("noticeIdx") int noticeIdx) throws Exception {
//        noticeService.delete(noticeIdx);
//        return "redirect:/notice/list";
//    }
//
//    @PostMapping("/fix")
//    public String fixNotice(@RequestParam(name = "noticeIdx") int noticeIdx) {
//        noticeService.fixNotice(noticeIdx);
//        return "redirect:/notice/list";
//    }
//
//    @PostMapping("/unfix")
//    public String unfixNotice(@RequestParam(name = "noticeIdx") int noticeIdx) {
//        noticeService.unfixNotice(noticeIdx);
//        return "redirect:/notice/list";
//    }
}
