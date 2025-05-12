package net.spb.spb.controller;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.*;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.service.PaymentServiceIf;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/payment")
public class PaymentController {
    private final PaymentServiceIf paymentService;

    private final IamportClient iamportClient;

    private String tId = "";
    private String partnerOrderId ="";

    @GetMapping("/cart")
    public String cart(
            @RequestParam("memberId") String memberId,
            Model model
    ) {
        List<CartDTO> cartList = paymentService.selectCart(memberId);
        log.info("cartList: "+cartList);
        model.addAttribute("cartList", cartList);
        model.addAttribute("memberId", memberId);
        return "payment/cart";
    }

    @PostMapping("/addCart")
    @ResponseBody
    public int addCart(
            @RequestBody CartDTO cartDTO
    ){
        log.info("cartDTO: "+cartDTO.toString());
        int cartCount = paymentService.cartCount(cartDTO);
        int result = 0;
        if(cartCount == 0){
            result = paymentService.addCart(cartDTO);
        } else {
            return 999;
        }
        log.info("result === " + result);
        return result;
    }

    @PostMapping("/cartDelete")
    @ResponseBody
    public String cartDelete(@RequestBody CartDTO cartDTO){
        log.info("삭제 요청 lectureIdxList: " + cartDTO.getSelectCartItemIds());
        paymentService.deleteCartItems(cartDTO);
        return "payment/cart";
    }

    @GetMapping("/payment")
    public String payment(@RequestParam("lectureIdxList") List<Integer> lectureIdxList, Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        MemberDTO memberDTO = paymentService.getMemberInfo(memberId);
        log.info("memberDTO: "+memberDTO.toString());
        model.addAttribute("member", memberDTO);

        log.info("memberId: " + memberId);
        List<LectureDTO> selectedLectures = paymentService.findLecturesByIds(lectureIdxList);
        log.info("selectedLectures: "+selectedLectures);
        model.addAttribute("selectedLectures", selectedLectures);
        int totalAmount = selectedLectures.stream().mapToInt(LectureDTO::getLectureAmount).sum();
        model.addAttribute("totalAmount", selectedLectures.stream().mapToInt(LectureDTO::getLectureAmount).sum());
        log.info(totalAmount);
        return "payment/payment";
    }

    @PostMapping("/insertOrder")
    @ResponseBody
    public int insertOrder(@RequestBody OrderDTO orderDTO, Model model){
        log.info(orderDTO);
        paymentService.insertOrder(orderDTO);

        try{
            for(int i=0; i<orderDTO.getOrderLectureList().size(); i++){
                paymentService.insertOrderLecture(Integer.parseInt(orderDTO.getOrderLectureList().get(i)));
            }
        }catch (Exception e){
            e.printStackTrace();
        }

        return paymentService.getMaxOrderIdx();
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verifyPayment(@RequestBody Map<String, String> body, HttpSession session) {
        String impUid = body.get("imp_uid");
        String merchantUid = body.get("merchant_uid");;
        String memberId = (String) session.getAttribute("memberId");

        try {
            IamportResponse<Payment> response = iamportClient.paymentByImpUid(impUid);
            Payment payment = response.getResponse();
            log.info("pgTid: "+payment.getPgTid());
            OrderDTO order = paymentService.findByMerchantUid(merchantUid);

            if (order.getOrderAmount() != payment.getAmount().intValue()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "status", "fail",
                        "message", "금액 불일치"
                ));
            }

            if ("paid".equals(payment.getStatus())) {
                PaymentDTO paymentDTO = new PaymentDTO();
                paymentDTO.setPaymentTransactionId ((String) payment.getImpUid());
                paymentDTO.setPaymentOrderIdx(Integer.parseInt(merchantUid));
                paymentDTO.setPaymentMemberId(memberId);
                paymentDTO.setPaymentMethod(payment.getPayMethod());
                //paymentDTO.setTotalAmount((Integer) ((Map) body.get("amount")).get("total"));
                //paymentDTO.setItemName((String) body.get("item_name"));
                paymentDTO.setPaymentStatus("s");
                paymentDTO.setPaymentPgTid(payment.getPgTid());
                //paymentDTO.setPaymentApprovedAt(payment.getPaidAt().toString());


                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss z yyyy", Locale.ENGLISH);
                ZonedDateTime zonedDateTime = ZonedDateTime.parse(payment.getPaidAt().toString(), formatter);

                paymentDTO.setPaymentApprovedAt2(zonedDateTime.toLocalDateTime());

                if(payment.getCancelledAt() != null ){
                    zonedDateTime = ZonedDateTime.parse(payment.getCancelledAt().toString(), formatter);

                    paymentDTO.setPaymentCanceledAt2(zonedDateTime.toLocalDateTime());
                }

                paymentService.savePaymentInfo(paymentDTO); //결제테이블에 등록

                paymentService.updateOrderInfo(paymentDTO); //주문테이블 업데이트

                paymentService.updateBookmarkState(paymentDTO);

                // ⬇️ 예: 강의 등록, 장바구니 비우기 등
                paymentService.processAfterPayment(paymentDTO);
                return ResponseEntity.ok(Map.of(
                        "status", "success"
                ));
            } else {

                PaymentDTO paymentDTO = new PaymentDTO();
                paymentDTO.setPaymentTransactionId (payment.getImpUid());
                paymentDTO.setPaymentOrderIdx(Integer.parseInt(merchantUid));
                paymentDTO.setPaymentMemberId(memberId);
                paymentDTO.setPaymentMethod(payment.getPayMethod());
                paymentDTO.setPaymentPgTid(payment.getPgTid());
                //paymentDTO.setItemName((String) body.get("item_name"));
                paymentDTO.setPaymentStatus("f");
                //paymentDTO.setPaymentApprovedAt(payment.getPaidAt().toString());


                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss z yyyy", Locale.ENGLISH);
                ZonedDateTime zonedDateTime = ZonedDateTime.parse(payment.getPaidAt().toString(), formatter);

                paymentDTO.setPaymentApprovedAt2(zonedDateTime.toLocalDateTime());

                if(payment.getCancelledAt() != null ){
                    zonedDateTime = ZonedDateTime.parse(payment.getCancelledAt().toString(), formatter);

                    paymentDTO.setPaymentCanceledAt2(zonedDateTime.toLocalDateTime());
                }


                paymentService.savePaymentInfo(paymentDTO); //결제테이블에 등록

                paymentService.updateOrderInfo(paymentDTO); //주문테이블 업데이트

                return ResponseEntity.badRequest().body(Map.of(
                        "status", "fail",
                        "message", "결제 상태 비정상"
                ));
            }

        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(Map.of(
                    "status", "fail",
                    "message", "서버 오류: " + e.getMessage()
            ));
        }
    }

    @GetMapping("/paymentDetail")
    public String paymentDetail(@RequestParam("orderIdx") int orderIdx, Model model, HttpSession session){
        try {
            String memberId = (String) session.getAttribute("memberId");
            MemberDTO memberDTO = paymentService.getMemberInfo(memberId);
            model.addAttribute("member", memberDTO);
            model.addAttribute("orderIdx", orderIdx);
            List<LectureDTO> lectureDTO = paymentService.getOrderLectureInfo(orderIdx);
            model.addAttribute("lectureDTO", lectureDTO);
            log.info("lectureDTO === " + lectureDTO);
            if(lectureDTO.size()>0){
                model.addAttribute("lectureDTOSize", lectureDTO.size());
            }
            PaymentDTO paymentDTO = paymentService.getPaymentInfo(orderIdx);
            model.addAttribute("paymentDTO", paymentDTO);
            log.info("paymentDTO === " + paymentDTO);
            model.addAttribute("totalAmount", lectureDTO.stream().mapToInt(LectureDTO::getLectureAmount).sum());
        }catch (Exception e){
            System.out.println("🔥 예외 발생: " + e.getMessage());
            e.printStackTrace();
        }

        return "payment/paymentDetail";
    }

    @PostMapping("/cancel")
    @ResponseBody
    public ResponseEntity<?>  cancel(@RequestBody CancelRequestDTO dto){
        try {
            Map<String, Object> result = paymentService.cancelPayment(dto.getMerchant_uid(), dto.getReason(), dto.getAmount());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("결제 취소에 실패했습니다." + e.getMessage());
        }
    }

    @GetMapping("/cartCount")
    @ResponseBody
    public int getCartCount(HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) return 0;
        return paymentService.getCartCount(memberId);
    }

}
