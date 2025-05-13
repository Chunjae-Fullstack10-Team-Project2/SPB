package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.NoticeDTO;
import net.spb.spb.service.NoticeService;
import net.spb.spb.util.NoticePaging;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
                       @RequestParam(name = "startDate", required = false) String startDateStr,
                       @RequestParam(name = "endDate", required = false) String endDateStr,
                       Model model, HttpServletResponse response) throws Exception {


        LocalDate startDate = null;
        LocalDate endDate = null;

        if (startDateStr != null && !startDateStr.isEmpty() && endDateStr != null && !endDateStr.isEmpty()) {
            try {
                startDate = LocalDate.parse(startDateStr);
                endDate = LocalDate.parse(endDateStr);
            } catch (Exception e) {

            }
        }

        // 총 게시글 수
        int totalCount;

        // 검색 조건
        if (startDate != null && endDate != null) {
            if (keyword != null && !keyword.isEmpty()) {
                if ("title".equals(searchType)) {
                    totalCount = noticeService.getCountByDateRangeAndTitle(startDate, endDate, keyword);
                } else if ("content".equals(searchType)) {
                    totalCount = noticeService.getCountByDateRangeAndContent(startDate, endDate, keyword);
                } else {
                    totalCount = noticeService.getCountByDateRangeAndTitle(startDate, endDate, keyword);
                }
            } else {
                totalCount = noticeService.getCountByDateRange(startDate, endDate);
            }
        } else if (keyword != null && !keyword.isEmpty()) {
            if ("title".equals(searchType)) {
                totalCount = noticeService.getSearchCountByTitle(keyword);
            } else if ("content".equals(searchType)) {
                totalCount = noticeService.getSearchCountByContent(keyword);
            } else {
                totalCount = noticeService.getSearchCount(keyword);
            }
        } else {
            totalCount = noticeService.getTotalCount();
        }

        int totalPage = NoticePaging.getTotalPage(totalCount, size);

        // 페이징 유효성 검사
        int validatedPage = NoticePaging.validatePageNumber(page, totalPage);

        if (validatedPage != page) {
            StringBuilder redirectUrl = new StringBuilder("/notice/list?page=" + validatedPage);

            if (size != 5) {
                redirectUrl.append("&size=").append(size);
            }

            if (startDateStr != null && !startDateStr.isEmpty()) {
                redirectUrl.append("&startDate=").append(startDateStr);
            }

            if (endDateStr != null && !endDateStr.isEmpty()) {
                redirectUrl.append("&endDate=").append(endDateStr);
            }

            if (keyword != null && !keyword.isEmpty()) {
                redirectUrl.append("&keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));
            }

            if (searchType != null && !searchType.isEmpty()) {
                redirectUrl.append("&searchType=").append(searchType);
            }

            return "redirect:" + redirectUrl;
        }

        int offset = NoticePaging.getOffset(validatedPage, size);
        List<NoticeDTO> list;

        // 일반 공지사항
        if (startDate != null && endDate != null) {
            if (keyword != null && !keyword.isEmpty()) {
                if ("title".equals(searchType)) {
                    list = noticeService.getListByDateRangeAndTitle(startDate, endDate, keyword, offset, size);
                } else if ("content".equals(searchType)) {
                    list = noticeService.getListByDateRangeAndContent(startDate, endDate, keyword, offset, size);
                } else {
                    list = noticeService.getListByDateRangeAndTitle(startDate, endDate, keyword, offset, size);
                }
            } else {
                list = noticeService.getListByDateRange(startDate, endDate, offset, size);
            }
        } else if (keyword != null && !keyword.isEmpty()) {
            if ("title".equals(searchType)) {
                list = noticeService.searchByTitle(keyword, offset, size);
            } else if ("content".equals(searchType)) {
                list = noticeService.searchByContent(keyword, offset, size);
            } else {
                list = noticeService.searchList(keyword, offset, size);
            }
        } else {
            list = noticeService.getListPaged(offset, size);
        }

        // 고정 공지사항
        List<NoticeDTO> fixedList = noticeService.getFixedNotices();


        String pagination = NoticePaging.getPagination(validatedPage, totalPage, "/notice/list",
                keyword, searchType, size, startDateStr, endDateStr);

        int listNumber = NoticePaging.getStartNum(totalCount, validatedPage, size);

        model.addAttribute("list", list);
        model.addAttribute("fixedList", fixedList);
        model.addAttribute("pagination", pagination);
        model.addAttribute("currentPage", validatedPage);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("size", size);
        model.addAttribute("keyword", keyword);
        model.addAttribute("searchType", searchType);
        model.addAttribute("listNumber", listNumber);
        model.addAttribute("startDate", startDateStr);
        model.addAttribute("endDate", endDateStr);

        return "notice/list";
    }

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
        // 세션에서 필요한 값 가져오기 (memberId ,memberGrade)
        String memberId = (String) session.getAttribute("memberId");
        String memberGrade = (String) session.getAttribute("memberGrade");

        // 관리자가 아닌 경우 리다이렉트
        if (memberId == null || memberGrade == null || !memberGrade.equals("0")) {
            return "redirect:/notice/list";
        }
        return "notice/regist";
    }

    @PostMapping("/regist")
    public String regist(@ModelAttribute NoticeDTO dto, HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
        // 유효성 검사 - 제목
        if (dto.getNoticeTitle() == null || dto.getNoticeTitle().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "제목을 입력해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }
        if (dto.getNoticeTitle().length() > 100) {
            redirectAttributes.addFlashAttribute("message", "제목은 100자 이내로 작성해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }

        // 유효성 검사 - 내용
        if (dto.getNoticeContent() == null || dto.getNoticeContent().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "내용을 입력해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }
        if (dto.getNoticeContent().length() > 20000) {
            redirectAttributes.addFlashAttribute("message", "내용은 20,000자 이내로 작성해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }

        if (dto.getNoticeIsFixed() == null) {
            dto.setNoticeIsFixed(false);
        }

        // 세션에서 회원 ID 직접 가져오기
        String memberId = (String) session.getAttribute("memberId");

        // 현재 로그인한 사용자 아이디 설정
        dto.setNoticeMemberId(memberId);

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
    public String modify(@ModelAttribute NoticeDTO dto, RedirectAttributes redirectAttributes) throws Exception {
        // 유효성 검사 - 제목
        if (dto.getNoticeTitle() == null || dto.getNoticeTitle().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "제목을 입력해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }
        if (dto.getNoticeTitle().length() > 100) {
            redirectAttributes.addFlashAttribute("message", "제목은 100자 이내로 작성해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }

        // 유효성 검사 - 내용
        if (dto.getNoticeContent() == null || dto.getNoticeContent().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "내용을 입력해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }
        if (dto.getNoticeContent().length() > 20000) {
            redirectAttributes.addFlashAttribute("message", "내용은 20,000자 이내로 작성해주세요.");
            redirectAttributes.addFlashAttribute("noticeDTO", dto);
            return "redirect:/notice/regist";
        }

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

    // 오류 발생 시
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, HttpServletRequest request) {
        return "redirect:/notice/list";
    }

}