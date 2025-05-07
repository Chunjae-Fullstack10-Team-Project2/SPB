package net.spb.spb.service;

import net.spb.spb.dto.CartDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.PaymentDTO;
import net.spb.spb.dto.member.MemberDTO;

import java.util.List;
import java.util.Map;

public interface PaymentServiceIf {
    public List<CartDTO> selectCart(String memberId);
    public int cartCount(CartDTO cartDTO);
    public int addCart(CartDTO cartDTO);
    public int deleteCartItems(CartDTO cartDTO);
    public List<LectureDTO> findLecturesByIds(List<Integer> lectureIdxList);
    public int insertOrder(OrderDTO orderDTO);
    public int insertOrderLecture(int orderLectureIdx);
    public int getMaxOrderIdx();
    public int savePaymentInfo(PaymentDTO paymentDTO);
    public int processAfterPayment(PaymentDTO paymentDTO);
    public OrderDTO findByMerchantUid(String merchantUid);
    public MemberDTO getMemberInfo(String memberId);
    public List<LectureDTO> getOrderLectureInfo(int orderIdx);
    public PaymentDTO getPaymentInfo(int orderIdx);
    public void updateOrderInfo(PaymentDTO paymentDTO);
    public Map<String, Object> cancelPayment(String merchantUid, String reason, int amount) throws Exception;
    public int getCartCount(String memberId);
}
