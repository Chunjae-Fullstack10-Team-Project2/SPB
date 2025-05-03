package net.spb.spb.service;

import net.spb.spb.dto.CartDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.PaymentDTO;

import java.util.List;

public interface PaymentServiceIf {
    public List<CartDTO> selectCart(String memberId);
    public int cartCount(CartDTO cartDTO);
    public int addCart(CartDTO cartDTO);
    public int deleteCartItems(CartDTO cartDTO);
    public List<LectureDTO> findLecturesByIds(List<Integer> lectureIdxList);
    public int insertOrder(OrderDTO orderDTO);
}
