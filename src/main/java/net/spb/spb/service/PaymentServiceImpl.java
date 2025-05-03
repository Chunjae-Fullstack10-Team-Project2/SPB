package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.CartVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.OrderVO;
import net.spb.spb.domain.PaymentVO;
import net.spb.spb.dto.*;
import net.spb.spb.mapper.PaymentMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Log4j2
@Transactional
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentServiceIf{
    private final ModelMapper modelMapper;
    private final PaymentMapper paymentMapper;

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
}
