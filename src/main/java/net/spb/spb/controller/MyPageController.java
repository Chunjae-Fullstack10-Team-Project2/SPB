package net.spb.spb.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.BookmarkDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.OrderLectureDTO;
import net.spb.spb.dto.post.PostCommentDTO;
import net.spb.spb.dto.post.PostDTO;
import net.spb.spb.dto.post.PostLikeRequestDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.service.member.MyPageService;
import net.spb.spb.service.member.MemberServiceImpl;
import net.spb.spb.util.BreadcrumbUtil;
import net.spb.spb.util.FileUtil;
import net.spb.spb.util.PageUtil;
import net.spb.spb.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@Log4j2
@RequestMapping(value = "/mypage")
public class MyPageController {
    @Autowired(required = false)
    private FileUtil fileUtil;

    @Autowired
    private MemberServiceImpl memberService;
    @Autowired
    private MyPageService myPageService;
    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "마이 페이지", "url", "/mypage");

    // 브레드크럼
    private void setBreadcrumb(Model model, Map<String, String>... pagePairs) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> page : pagePairs) {
            pages.putAll(page);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String mypage(HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);
        setBreadcrumb(model, Map.of("마이 페이지", ""));

        return "mypage/mypage";
    }

    @PostMapping("")
    public String updateMyPage(@ModelAttribute MemberDTO memberDTO,
                               BindingResult bindingResult,
                               @RequestParam(value = "profileImgFile", required = false) MultipartFile profileImg,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("errorMessage", "오류가 발생했습니다. 다시 시도해주세요.");
            return "mypage/mypage";
        }

        String memberId = (String) session.getAttribute("memberId");
        MemberDTO sessionDTO = (MemberDTO) session.getAttribute("memberDTO");

        if (memberId == null || sessionDTO == null) {
            return "redirect:/login";
        }

        if (!memberDTO.getMemberName().matches("^[a-zA-Z가-힣]{1,30}$")) {
            redirectAttributes.addFlashAttribute("errorMessage", "이름은 한글 또는 영어로 최대 30자까지 입력 가능합니다.");
            return "redirect:/mypage";
        }

        if (!memberDTO.getMemberBirth().matches("^\\d{8}$")) {
            redirectAttributes.addFlashAttribute("errorMessage", "생년월일은 YYYYMMDD 형식으로 입력해주세요.");
            return "redirect:/mypage";
        }

        if (!memberDTO.getMemberZipCode().matches("^\\d{5}$")) {
            redirectAttributes.addFlashAttribute("errorMessage", "우편번호는 숫자 5자리여야 합니다.");
            return "redirect:/mypage";
        }

        if (memberDTO.getMemberAddr1() == null || memberDTO.getMemberAddr1().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "주소는 필수 항목입니다.");
            return "redirect:/mypage";
        } else if (memberDTO.getMemberAddr1().length() > 100) {
            redirectAttributes.addFlashAttribute("errorMessage", "주소는 100자 이하여야 합니다.");
            return "redirect:/mypage";
        }

        if (memberDTO.getMemberAddr2() != null && memberDTO.getMemberAddr2().length() > 100) {
            redirectAttributes.addFlashAttribute("errorMessage", "상세주소는 100자 이하여야 합니다.");
            return "redirect:/mypage";
        }

        if ("14".equals(sessionDTO.getMemberGrade()) &&
                !sessionDTO.getMemberGrade().equals(memberDTO.getMemberGrade())) {
            redirectAttributes.addFlashAttribute("errorMessage", "승인 대기 중에는 학년을 변경할 수 없습니다.");
            return "redirect:/mypage";
        }

        if ("13".equals(sessionDTO.getMemberGrade())) {
            redirectAttributes.addFlashAttribute("errorMessage", "교사는 해당 필드를 변경할 수 없습니다.");
            return "redirect:/mypage";
        }

        MemberDTO safeDTO = new MemberDTO();
        safeDTO.setMemberId(memberId);
        safeDTO.setMemberName(memberDTO.getMemberName());
        safeDTO.setMemberBirth(memberDTO.getMemberBirth());
        safeDTO.setMemberZipCode(memberDTO.getMemberZipCode());
        safeDTO.setMemberAddr1(memberDTO.getMemberAddr1());
        safeDTO.setMemberAddr2(memberDTO.getMemberAddr2());
        safeDTO.setMemberEmail(sessionDTO.getMemberEmail());
        safeDTO.setMemberPhone(sessionDTO.getMemberPhone());
        safeDTO.setMemberGrade(sessionDTO.getMemberGrade().equals("14") ? "14" : memberDTO.getMemberGrade());

        try {
            if (profileImg != null && !profileImg.isEmpty()) {
                String oldFile = sessionDTO.getMemberProfileImg();
                if (oldFile != null && !oldFile.isBlank()) {
                    fileUtil.deleteFile(oldFile);
                }
                File savedFile = fileUtil.saveFile(profileImg);
                safeDTO.setMemberProfileImg(savedFile.getName());
            } else {
                safeDTO.setMemberProfileImg(sessionDTO.getMemberProfileImg());
            }
        } catch (Exception e) {
            model.addAttribute("message", "프로필 이미지 변경 중 오류 발생");
            return "mypage/mypage";
        }

        boolean result = memberService.updateMember(safeDTO);
        if (result) {
            session.setAttribute("memberDTO", safeDTO);
            redirectAttributes.addFlashAttribute("message", "회원 정보가 성공적으로 수정되었습니다.");
            return "redirect:/mypage";
        } else {
            redirectAttributes.addFlashAttribute("message", "회원 정보 수정에 실패했습니다.");
            return "redirect:/mypage";
        }
    }

    @PostMapping("/checkPwd")
    @ResponseBody
    public ResponseEntity<String> checkPassword(@RequestParam("memberPwd") String memberPwd, HttpSession session) throws NoSuchAlgorithmException {
        String memberId = (String) session.getAttribute("memberId");
        String originalPwd = memberService.getPwdById(memberId);
        String encryptedPassword = PasswordUtil.encryptPassword(memberPwd);

        if (encryptedPassword != null && encryptedPassword.equals(originalPwd)) {
            return ResponseEntity.ok("success");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("fail");
        }
    }

    @PostMapping("/quit")
    @ResponseBody
    public ResponseEntity<String> quitMember(HttpSession session, HttpServletResponse response, HttpServletRequest request) {
        String memberId = (String) session.getAttribute("memberId");

        boolean isUpdated = memberService.updateMemberStateWithLogin("6", memberId);
        if (isUpdated) {
            request.getSession().invalidate();

            Cookie autoLoginCookie = new Cookie("autoLogin", null);
            autoLoginCookie.setMaxAge(0);
            autoLoginCookie.setPath("/");
            response.addCookie(autoLoginCookie);
            return ResponseEntity.ok("success");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("fail");
        }
    }

    @GetMapping("/likes")
    public String listPostLikes(HttpSession session, Model model,
                                @ModelAttribute SearchDTO searchDTO,
                                @ModelAttribute PageRequestDTO pageRequestDTO) {

        String postLikeMemberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("postLikeCreatedAt");
        }

        if ("".equals(searchDTO.getStartDate())) searchDTO.setStartDate(null);
        if ("".equals(searchDTO.getEndDate())) searchDTO.setEndDate(null);
        if ("".equals(searchDTO.getSearchWord())) searchDTO.setSearchWord(null);
        if ("".equals(searchDTO.getSearchType())) searchDTO.setSearchType(null);
        if ("".equals(searchDTO.getSortColumn())) searchDTO.setSortColumn(null);
        if ("".equals(searchDTO.getSortOrder())) searchDTO.setSortOrder(null);

        int totalCount = myPageService.likesTotalCount(searchDTO, postLikeMemberId);
        PageResponseDTO<PostLikeRequestDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> myPageService.listMyLikes(searchDTO, pageRequestDTO, postLikeMemberId)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("likesList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("좋아요 목록", ""));
        return "mypage/likes";
    }

    @PostMapping("/likes/delete")
    @ResponseBody
    public ResponseEntity<String> cancelLike(@RequestParam("postLikeRefIdx") int postLikeRefIdx,
                                             HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        boolean success = myPageService.cancelLike(postLikeRefIdx);
        if (success) {
            return ResponseEntity.ok().header("Content-Type", "text/plain; charset=UTF-8")
                    .body("좋아요가 취소되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("좋아요 취소에 실패했습니다.");
        }
    }

    @GetMapping("/report")
    public String listPostReport(HttpSession session, Model model,
                                 @ModelAttribute SearchDTO searchDTO,
                                 @ModelAttribute PageRequestDTO pageRequestDTO) {
        String reportMemberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("reportCreatedAt");
        }

        int totalCount = myPageService.reportTotalCount(searchDTO, reportMemberId);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> myPageService.listMyReport(searchDTO, pageRequestDTO, reportMemberId)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("reportList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("신고 목록", ""));
        return "mypage/report";
    }

    @PostMapping("/report/delete")
    @ResponseBody
    public ResponseEntity<String> deleteReport(@RequestParam("reportIdx") String reportIdx, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");

        if (memberId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        boolean success = myPageService.deleteReport(reportIdx);

        if (success) {
            return ResponseEntity
                    .ok()
                    .header("Content-Type", "text/plain; charset=UTF-8")
                    .body("신고 내역이 삭제되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제에 실패했습니다.");
        }
    }

    @GetMapping("/order")
    public String listLectureOrder(HttpSession session, Model model,
                                   @ModelAttribute SearchDTO searchDTO,
                                   @ModelAttribute PageRequestDTO pageRequestDTO) {
        String memberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("orderCreatedAt");
        }

        List<Integer> pagedOrderIdxList = myPageService.getPagedOrderIdxList(searchDTO, pageRequestDTO, memberId);
        List<OrderDTO> flatList = myPageService.getOrdersWithLectures(pagedOrderIdxList, searchDTO);

        Map<Integer, OrderDTO> grouped = new LinkedHashMap<>();
        for (OrderDTO dto : flatList) {
            grouped.computeIfAbsent(dto.getOrderIdx(), idx -> {
                OrderDTO od = new OrderDTO();
                od.setOrderIdx(idx);
                od.setOrderMemberId(dto.getOrderMemberId());
                od.setOrderCreatedAt(dto.getOrderCreatedAt());
                od.setOrderAmount(dto.getOrderAmount());
                od.setOrderStatus(dto.getOrderStatus());
                od.setOrderLectureDTOList(new ArrayList<>());
                return od;
            }).getOrderLectureDTOList().add(new OrderLectureDTO(dto.getLectureIdx(), dto.getLectureTitle()));
        }

        List<OrderDTO> finalOrderList = new ArrayList<>(grouped.values());
        int totalCount = myPageService.orderTotalCount(searchDTO, memberId);

        PageResponseDTO<OrderDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> finalOrderList
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("orderList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("강좌 주문 목록", ""));
        return "mypage/order";
    }

    @PostMapping("/order/confirm")
    public String confirmOrder(@RequestParam("orderIdx") int orderIdx, @RequestParam("orderStatus") String orderStatus,
                               HttpSession session, RedirectAttributes rttr) {
        String memberId = (String) session.getAttribute("memberId");
        boolean success = myPageService.confirmOrder(orderIdx, orderStatus, memberId);
        rttr.addFlashAttribute("message", success ? "구매가 확정되었습니다." : "처리 중 오류 발생");
        return "redirect:/mypage/order";
    }

    @PostMapping("/order/refund")
    public String refundOrder(@RequestParam("orderIdx") int orderIdx, @RequestParam("orderStatus") String orderStatus,
                              HttpSession session, RedirectAttributes rttr) {
        String memberId = (String) session.getAttribute("memberId");
        boolean success = myPageService.requestRefund(orderIdx, orderStatus, memberId);
        rttr.addFlashAttribute("message", success ? "환불이 요청되었습니다." : "처리 중 오류 발생");
        return "redirect:/mypage/order";
    }

    @PostMapping("/order/cancel")
    public String orderCancel(@RequestParam("orderIdx") int orderIdx, @RequestParam("orderStatus") String orderStatus,
                              HttpSession session, RedirectAttributes rttr) {
        String memberId = (String) session.getAttribute("memberId");
        boolean success = myPageService.requestRefund(orderIdx, orderStatus, memberId);
        rttr.addFlashAttribute("message", success ? "주문이 취소되었습니다." : "처리 중 오류 발생");
        return "redirect:/mypage/order";
    }

    @GetMapping("/changePwd")
    public String changePwd(HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);
        setBreadcrumb(model, Map.of("비밀번호 변경", ""));

        return "mypage/changePwd";
    }

    @PostMapping("/changePwd")
    public String changePwd(@RequestParam("currentPwd") String currentPwd,
                            @RequestParam("newPwd") String newPwd,
                            @RequestParam("confirmPwd") String confirmPwd,
                            HttpSession session,
                            Model model) throws NoSuchAlgorithmException {

        String memberId = (String) session.getAttribute("memberId");

        if (memberId == null) return "redirect:/login";

        setBreadcrumb(model, Map.of("비밀번호 변경", ""));

        String originalEncryptedPwd = memberService.getPwdById(memberId);
        String encryptedCurrentPwd = PasswordUtil.encryptPassword(currentPwd);

        if (!encryptedCurrentPwd.equals(originalEncryptedPwd)) {
            model.addAttribute("message", "현재 비밀번호가 일치하지 않습니다.");
            return "mypage/changePwd";
        }

        if (!currentPwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$") ||
                !newPwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$") ||
                !confirmPwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{4,15}$")) {
            model.addAttribute("message", "비밀번호 형식이 올바르지 않습니다.");
            return "mypage/changePwd";
        }

        if (!newPwd.equals(confirmPwd)) {
            model.addAttribute("message", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            return "mypage/changePwd";
        }

        String encryptedNewPwd = PasswordUtil.encryptPassword(newPwd);
        boolean result = myPageService.changePwd(encryptedNewPwd, memberId);

        if (result) {
            return "redirect:/mypage";
        } else {
            model.addAttribute("message", "비밀번호 변경에 실패했습니다. 다시 시도해주세요.");
            return "mypage/changePwd";
        }
    }

    @GetMapping("/bookmark")
    public String listMyBookmark(HttpSession session, Model model,
                                 @ModelAttribute SearchDTO searchDTO,
                                 @ModelAttribute PageRequestDTO pageRequestDTO) {
        String bookmarkMemberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("bookmarkCreatedAt");
        }

        int totalCount = myPageService.bookmarkTotalCount(searchDTO, bookmarkMemberId);
        PageResponseDTO<BookmarkDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> myPageService.listMyBookmark(searchDTO, pageRequestDTO, bookmarkMemberId)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("bookmarkList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("북마크 목록", ""));
        return "mypage/bookmark";
    }

    @PostMapping("/bookmark/delete")
    @ResponseBody
    public ResponseEntity<String> cancelBookmark(@RequestParam("bookmarkIdx") int bookmarkIdx, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");

        if (memberId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        boolean success = myPageService.cancelBookmark(bookmarkIdx);

        if (success) {
            return ResponseEntity
                    .ok()
                    .header("Content-Type", "text/plain; charset=UTF-8")
                    .body("북마크가 삭제되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제에 실패했습니다.");
        }
    }

    @GetMapping("/post")
    public String listMyPost(HttpSession session, Model model,
                             @ModelAttribute SearchDTO searchDTO,
                             @ModelAttribute PageRequestDTO pageRequestDTO) {
        String postMemberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("postCreatedAt");
        }

        // endDate가 날짜 문자열이면 "23:59:59" 붙이기
        if (searchDTO.getEndDate() != null && !searchDTO.getEndDate().isBlank()) {
            if (!searchDTO.getEndDate().contains(" ")) {
                searchDTO.setEndDate(searchDTO.getEndDate() + " 23:59:59");
            }
        }

        int totalCount = myPageService.postTotalCount(searchDTO, postMemberId);
        PageResponseDTO<PostDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> myPageService.listMyPost(searchDTO, pageRequestDTO, postMemberId)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("postList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("게시글 목록", ""));

        return "mypage/post";
    }

    @GetMapping("/comment")
    public String listMyComment(HttpSession session, Model model,
                                @ModelAttribute SearchDTO searchDTO,
                                @ModelAttribute PageRequestDTO pageRequestDTO) {
        String memberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("postCommentCreatedAt");
        }

        int totalCount = myPageService.commentTotalCount(searchDTO, memberId);
        PageResponseDTO<PostCommentDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> myPageService.listMyComment(searchDTO, pageRequestDTO, memberId)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("commentList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("댓글 목록", ""));
        return "mypage/comment";
    }

}