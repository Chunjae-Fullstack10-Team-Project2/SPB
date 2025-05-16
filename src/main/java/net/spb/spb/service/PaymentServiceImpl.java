package net.spb.spb.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.*;
import net.spb.spb.dto.*;
import net.spb.spb.dto.lecture.LectureDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.mapper.PaymentMapper;
import org.modelmapper.ModelMapper;
import org.springframework.http.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Log4j2
@Transactional
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentServiceIf{
    private final ModelMapper modelMapper;
    private final PaymentMapper paymentMapper;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    @Override
    public List<CartDTO> selectCart(String memberId) {
        List<CartDTO> cartDTO = paymentMapper.selectCart(memberId);
        return cartDTO;
    }

    @Override
    public int cartCount(CartDTO cartDTO) {
        int cartCount = paymentMapper.cartCount(cartDTO);
        return cartCount;
    }

    @Override
    public int addCart(CartDTO cartDTO){
        CartVO vo = modelMapper.map(cartDTO, CartVO.class);
        int rtnResult = paymentMapper.addCart(vo);
        log.info("service >> rtnResult = " + rtnResult);
        return rtnResult;
    }

    @Override
    public int deleteCartItems(CartDTO cartDTO) {
        int rtnResult = 0;
        for(int i=0; i < cartDTO.getSelectCartItemIds().size(); i++){
            rtnResult += paymentMapper.deleteCartItems(cartDTO.getCartMemberId(), cartDTO.getSelectCartItemIds().get(i));
        }

        return rtnResult;
    }

    @Override
    public List<LectureDTO> findLecturesByIds(List<Integer> lectureIdxList) {
        List<LectureVO> lectureVOList = paymentMapper.findLecturesByIds(lectureIdxList);
        log.info("service >> paymentVOList = " + lectureVOList);
        List<LectureDTO> paymentLectureList =
                lectureVOList.stream().map(
                                lectureVO -> modelMapper.map(lectureVO, LectureDTO.class))
                        .collect(Collectors.toList());
        return paymentLectureList;
    }

    @Override
    public int insertOrder(OrderDTO orderDTO) {
        OrderVO orderVO = modelMapper.map(orderDTO, OrderVO.class);
        int rtnResult = paymentMapper.insertOrder(orderVO);
        return rtnResult;
    }

    @Override
    public int insertOrderLecture(int orderLectureIdx) {
        int rtnResult = paymentMapper.insertOrderLecture(orderLectureIdx);
        return rtnResult;
    }

    @Override
    public int getMaxOrderIdx() {
        return paymentMapper.getMaxOrderIdx();
    }

    @Override
    public int savePaymentInfo(PaymentDTO paymentDTO) {
        PaymentVO paymentVO = modelMapper.map(paymentDTO, PaymentVO.class);
        int rtnResult = paymentMapper.savePaymentInfo(paymentVO);
        return rtnResult;
    }

    @Override
    public int processAfterPayment(PaymentDTO paymentDTO) {
        PaymentVO paymentVO = modelMapper.map(paymentDTO, PaymentVO.class);
        int rtnResult = paymentMapper.processAfterPayment(paymentVO);
        return rtnResult;
    }

    @Override
    public OrderDTO findByMerchantUid(String merchantUid) {
        OrderVO vo = paymentMapper.selectOrder(merchantUid);
        OrderDTO dto = (vo != null ?modelMapper.map(vo, OrderDTO.class) : null);
        return dto;
    }

    @Override
    public MemberDTO getMemberInfo(String memberId) {
        MemberVO memberVO = paymentMapper.getMemberInfo(memberId);
        MemberDTO dto = (memberVO != null ?modelMapper.map(memberVO, MemberDTO.class) : null);
        return dto;
    }

    @Override
    public List<LectureDTO> getOrderLectureInfo(int orderIdx) {
        List<Integer> orderLectureidxs = paymentMapper.getOrderLectureIdxs(orderIdx);
        return findLecturesByIds(orderLectureidxs);
    }

    @Override
    public PaymentDTO getPaymentInfo(int orderIdx) {
        PaymentVO paymentVO = paymentMapper.getPaymentInfo(orderIdx);
        log.info("paymentVO: "+paymentVO);
        PaymentDTO dto = (paymentVO != null?modelMapper.map(paymentVO, PaymentDTO.class):null);
        return dto;
    }

    @Override
    public void updateOrderInfo(PaymentDTO paymentDTO) {
        PaymentVO paymentVO = modelMapper.map(paymentDTO, PaymentVO.class);
        paymentMapper.updateOrderInfo(paymentVO);
    }

    @Override
    public Map<String, Object> cancelPayment(String merchantUid, String reason, int amount) throws Exception {
        String token = getAccessToken();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(token);

        Map<String, Object> body = new HashMap<>();
        body.put("imp_uid", merchantUid);
        body.put("amount", amount);
        body.put("reason", reason);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
        ResponseEntity<Map> response = restTemplate.postForEntity(
                "https://api.iamport.kr/payments/cancel", request, Map.class);

        // 결제 상태 DB 업데이트
        paymentMapper.updatePaymentStatus(merchantUid, "c");

        return response.getBody();
    }

    @Override
    public int getCartCount(String memberId) {
        return paymentMapper.getCartCount(memberId);
    }

    @Override
    public void updateBookmarkState(PaymentDTO dto) {
        paymentMapper.updateBookmarkState(dto);
    }

    @Override
    public String getOrderStatus(int orderIdx) {
        return paymentMapper.getOrderStatus(orderIdx);
    }

    @Override
    public void insertLectureRegister(int orderLectureIdx, String memberId) {
        paymentMapper.insertLectureRegister(orderLectureIdx, memberId);
    }

    private String getAccessToken() throws Exception {
        org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, String> body = new HashMap<>();
        body.put("imp_key", "5308452081165714");
        body.put("imp_secret", "k9aHUjxe7p8EHezB3AqXUCJ50XHQ9BydDigbryzrMxeXWvDfseFzy1HQ8bjXGqAuBSoWSJYytsnApRL1");

        String jsonBody = objectMapper.writeValueAsString(body);

        HttpEntity<String> request = new HttpEntity<>(jsonBody, headers);

        ResponseEntity<Map> response = restTemplate.postForEntity(
                "https://api.iamport.kr/users/getToken", request, Map.class);

        Map<String, Object> responseBody = (Map<String, Object>) response.getBody().get("response");
        return responseBody.get("access_token").toString();
    }

}
