package net.spb.spb.mapper;

import net.spb.spb.domain.*;
import net.spb.spb.dto.CartDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.PaymentDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PaymentMapper {
    public List<CartDTO> selectCart(String memberId);
    public int cartCount(CartDTO cartDTO);
    public int addCart(CartVO cartVO);
    public int deleteCartItems(String cartMemberId, int cartLectureIdx);
    public List<LectureVO> findLecturesByIds(@Param("lectureIdxs") List<Integer> lectureIdxs);
    public int insertOrder(OrderVO orderVO);
    public int insertOrderLecture(int orderLectureIdx);
    public int getMaxOrderIdx();
    public int savePaymentInfo(PaymentVO paymentVO);
    public int processAfterPayment(PaymentVO paymentVO);
    public OrderVO selectOrder(String merchantUid);
    public MemberVO getMemberInfo(String memberId);
    public List<Integer> getOrderLectureIdxs(int orderIdx);
    public PaymentVO getPaymentInfo(int orderIdx);
    public void updateOrderInfo(PaymentVO paymentVO);
    public void updatePaymentStatus(@Param("merchantUid") String merchantUid, @Param("status") String status);
}
