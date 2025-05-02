package net.spb.spb.service;

import net.spb.spb.dto.CartDTO;

import java.util.List;

public interface PaymentServiceIf {
    public List<CartDTO> selectCart(String memberId);
    public int cartCount(CartDTO cartDTO);
    public int addCart(CartDTO cartDTO);
    public int deleteCartItems(CartDTO cartDTO);
}
