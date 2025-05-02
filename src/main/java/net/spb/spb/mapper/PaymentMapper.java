package net.spb.spb.mapper;

import net.spb.spb.domain.CartVO;
import net.spb.spb.dto.CartDTO;

import java.util.List;

public interface PaymentMapper {
    public List<CartDTO> selectCart(String memberId);
    public int cartCount(CartDTO cartDTO);
    public int addCart(CartVO cartVO);
    public int deleteCartItems(String cartMemberId, int cartLectureIdx);
}
