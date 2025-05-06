package net.spb.spb.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.PostLikeRequestDTO;
import net.spb.spb.dto.PostReportDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.service.MyPageService;
import net.spb.spb.service.PostLikeService;
import net.spb.spb.service.member.MemberServiceImpl;
import net.spb.spb.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@Log4j2
@RequestMapping(value = "/mypage")
public class MyPageController {

    @Autowired
    private MemberServiceImpl memberService;
    @Autowired
    private MyPageService myPageService;

    @GetMapping("")
    public String mypage(HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);

        return "mypage/mypage";
    }

    @PostMapping("")
    public String updateMyPage(@ModelAttribute MemberDTO memberDTO, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        memberDTO.setMemberId(memberId);

        boolean result = memberService.updateMember(memberDTO);
        if (result) {
            session.setAttribute("memberDTO", memberDTO);
            return "redirect:/mypage";
        } else {
            model.addAttribute("errorMessage", "회원 정보 수정에 실패했습니다.");
            return "mypage/mypage";
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

        List<PostLikeRequestDTO> likesList = myPageService.listMyLikes(searchDTO, pageRequestDTO, postLikeMemberId);
        PageResponseDTO<PostLikeRequestDTO> pageResponseDTO = PageResponseDTO.<PostLikeRequestDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(myPageService.likesTotalCount(searchDTO, postLikeMemberId))
                .dtoList(likesList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("likesList", likesList);
        model.addAttribute("searchDTO", searchDTO);
        return "mypage/likes";
    }

    @GetMapping("/report")
    public String listPostReport(HttpSession session, Model model,
                                 @ModelAttribute SearchDTO searchDTO,
                                 @ModelAttribute PageRequestDTO pageRequestDTO) {
        String reportMemberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("reportCreatedAt");
        }

        List<PostReportDTO> reportList = myPageService.listMyReport(searchDTO, pageRequestDTO, reportMemberId);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageResponseDTO.<PostReportDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(myPageService.reportTotalCount(searchDTO, reportMemberId))
                .dtoList(reportList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("reportList", reportList);
        model.addAttribute("searchDTO", searchDTO);
        return "mypage/report";
    }

    @GetMapping("/order")
    public String listLectureOrder(HttpSession session, Model model,
                                   @ModelAttribute SearchDTO searchDTO,
                                   @ModelAttribute PageRequestDTO pageRequestDTO) {
        String orderMemberId = (String) session.getAttribute("memberId");

        if (searchDTO.getDateType() == null || searchDTO.getDateType().isEmpty()) {
            searchDTO.setDateType("orderCreatedAt");
        }

        // 원본 flat 리스트
        List<OrderDTO> rawOrderList = myPageService.listMyOrder(searchDTO, pageRequestDTO, orderMemberId);

        // 주문번호 기준으로 그룹핑
        Map<Integer, OrderDTO> orderMap = new LinkedHashMap<>();

        for (OrderDTO item : rawOrderList) {
            int orderIdx = item.getOrderIdx();

            // 이미 저장된 주문이면 기존 DTO에 강의 추가
            if (orderMap.containsKey(orderIdx)) {
                orderMap.get(orderIdx).getOrderLectureList().add(item.getLectureTitle());
            } else {
                // 처음 보는 주문이면 새로운 DTO 생성 후 강의 추가
                OrderDTO newOrder = new OrderDTO();
                newOrder.setOrderIdx(orderIdx);
                newOrder.setOrderMemberId(item.getOrderMemberId());
                newOrder.setOrderCreatedAt(item.getOrderCreatedAt());
                newOrder.setOrderAmount(item.getOrderAmount());
                newOrder.setOrderStatus(item.getOrderStatus());
                newOrder.setOrderLectureList(new ArrayList<>());
                newOrder.getOrderLectureList().add(item.getLectureTitle());

                orderMap.put(orderIdx, newOrder);
            }
        }

        List<OrderDTO> finalOrderList = new ArrayList<>(orderMap.values());

        PageResponseDTO<OrderDTO> pageResponseDTO = PageResponseDTO.<OrderDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(myPageService.orderTotalCount(searchDTO, orderMemberId))
                .dtoList(finalOrderList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("orderList", finalOrderList);
        model.addAttribute("searchDTO", searchDTO);
        return "mypage/order";
    }
}
