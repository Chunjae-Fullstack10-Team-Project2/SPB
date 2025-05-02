package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.CartDTO;
import net.spb.spb.service.PaymentServiceIf;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/payment")
public class PaymentController {
    private final PaymentServiceIf paymentService;

    @GetMapping("/cart")
    public String cart(
            @RequestParam("memberId") String memberId,
            Model model
    ) {
        List<CartDTO> cartList = paymentService.selectCart(memberId);
        log.info("cartList: "+cartList);
        model.addAttribute("cartList", cartList);
        return "payment/cart";
    }

    @PostMapping("/addCart")
    @ResponseBody
    public int addCart(
            @RequestBody CartDTO cartDTO
    ){
        log.info("cartDTO: "+cartDTO.toString());
        int cartCount = paymentService.cartCount(cartDTO);
        int result = 0;
        if(cartCount == 0){
            result = paymentService.addCart(cartDTO);
        } else {
            return 999;
        }
        log.info("result === " + result);
        return result;
    }

    @PostMapping("/cartDelete")
    @ResponseBody
    public String cartDelete(@RequestBody CartDTO cartDTO){
        log.info("삭제 요청 lectureIdxList: " + cartDTO.getDeleteCartItemIds());
        paymentService.deleteCartItems(cartDTO);
        return "payment/cart";
    }
}
