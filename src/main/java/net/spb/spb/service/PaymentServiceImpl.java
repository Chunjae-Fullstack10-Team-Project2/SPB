package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.CartVO;
import net.spb.spb.dto.CartDTO;
import net.spb.spb.mapper.PaymentMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

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
        for(int i=0; i < cartDTO.getDeleteCartItemIds().size(); i++){
            rtnResult += paymentMapper.deleteCartItems(cartDTO.getCartMemberId(), cartDTO.getDeleteCartItemIds().get(i));
        }

        return rtnResult;
    }
}
