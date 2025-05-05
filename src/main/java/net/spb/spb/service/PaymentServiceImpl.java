package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.*;
import net.spb.spb.dto.*;
import net.spb.spb.dto.member.MemberDTO;
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


}
