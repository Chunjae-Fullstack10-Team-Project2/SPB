package net.spb.spb.mapper;

import net.spb.spb.domain.CartVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.OrderVO;
import net.spb.spb.domain.PaymentVO;
import net.spb.spb.dto.CartDTO;
import net.spb.spb.dto.LectureDTO;
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
}
