package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.CartDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.PaymentDTO;
import net.spb.spb.service.PaymentServiceIf;
import org.springframework.core.annotation.Order;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/payment")
public class PaymentController {
    private final PaymentServiceIf paymentService;

    private String tId = "";

    @GetMapping("/cart")
    public String cart(
            @RequestParam("memberId") String memberId,
            Model model
    ) {
        List<CartDTO> cartList = paymentService.selectCart(memberId);
        log.info("cartList: "+cartList);
        model.addAttribute("cartList", cartList);
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
    public String payment(@RequestParam("lectureIdxList") List<Integer> lectureIdxList, Model model) {
        List<LectureDTO> selectedLectures = paymentService.findLecturesByIds(lectureIdxList);
        log.info("selectedLectures: "+selectedLectures);
        model.addAttribute("selectedLectures", selectedLectures);
        return "payment/payment";
    }

    @PostMapping("/insertOrder")
    public int insertOrder(@RequestBody OrderDTO orderDTO, Model model){
        int rtnResult = paymentService.insertOrder(orderDTO);
        return rtnResult;
    }

    @PostMapping("/kakaoPayReady")
    @ResponseBody
    public ResponseEntity<?> kakaoPayReady(@RequestBody Map<String, String> requestData) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "SECRET_KEY DEV3E5A52C4D395F4EBA5C9EC99868F5FADAD243");
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> params = new HashMap<>();
        params.put("cid", "TC0ONETIME");
        params.put("partner_order_id", "partner_order_id");
        params.put("partner_user_id", "partner_user_id");
        params.put("item_name", requestData.get("item_name"));
        params.put("quantity", "1");
        params.put("total_amount", requestData.get("total_amount"));
        params.put("vat_amount", "200");
        params.put("tax_free_amount", "0");
        params.put("approval_url", "http://localhost:8080/payment/success");
        params.put("fail_url", "http://localhost:8080/payment/fail");
        params.put("cancel_url", "http://localhost:8080/payment/cancel");


        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers);

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    "https://open-api.kakaopay.com/online/v1/payment/ready",
                    entity,
                    Map.class
            );
            this.tId = (String) response.getBody().get("tid");
            Map<String, String> result = new HashMap<>();
            result.put("next_redirect_pc_url", (String) response.getBody().get("next_redirect_pc_url"));

            return ResponseEntity.ok(result);  // JSON 객체로 응답
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("카카오페이 오류");
        }
    }
    @GetMapping("/success")
    public String kakaoPaySuccess(@RequestParam("pg_token") String pgToken, Model model) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "SECRET_KEY DEV3E5A52C4D395F4EBA5C9EC99868F5FADAD243");
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> params = new HashMap<>();
        params.put("cid", "TC0ONETIME");
        params.put("tid", this.tId);
        params.put("partner_order_id", "partner_order_id");
        params.put("partner_user_id", "partner_user_id");
        params.put("pg_token", pgToken);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers);

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    "https://open-api.kakaopay.com/online/v1/payment/approve",
                    entity,
                    Map.class
            );

            Map<String, Object> body = response.getBody();
            log.info("결제 승인 성공: " + body);

            // ⬇️ 결제 정보 저장 예시
            PaymentDTO paymentDTO = new PaymentDTO();
            paymentDTO.setPaymentTransactionId ((String) body.get("tid"));
            //paymentDTO.setPartnerOrderId((String) body.get("partner_order_id"));
//            paymentDTO.setPartnerUserId((String) body.get("partner_user_id"));
//            paymentDTO.setTotalAmount((Integer) ((Map) body.get("amount")).get("total"));
//            paymentDTO.setItemName((String) body.get("item_name"));
//            paymentDTO.setPaymentMethodType((String) body.get("payment_method_type"));
//            paymentDTO.setApprovedAt((String) body.get("approved_at"));
//
//            paymentService.savePaymentInfo(paymentDTO); // 🔧 서비스 구현 필요
//
//            // ⬇️ 예: 강의 등록, 장바구니 비우기 등
//            paymentService.processAfterPayment(paymentDTO);

            model.addAttribute("paymentInfo", paymentDTO);
            return "payment/complete"; // 완료 페이지로 이동

        } catch (Exception e) {
            e.printStackTrace();
            return "payment/fail";
        }
    }
    @GetMapping("/fail")
    public String kakaoPayFail(@RequestParam("pg_token") String pgToken, Model model) {
        model.addAttribute("pgToken", pgToken);
        return "payment/cart"; // 성공 페이지로 이동
    }
    @GetMapping("/cancel")
    public String kakaoPayCancel(@RequestParam("pg_token") String pgToken, Model model) {
        model.addAttribute("pgToken", pgToken);
        return "payment/cart"; // 성공 페이지로 이동
    }
}
