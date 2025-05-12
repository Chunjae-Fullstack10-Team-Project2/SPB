package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import net.spb.spb.service.PaymentServiceIf;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributeAdvice {

    @Autowired
    private PaymentServiceIf paymentService;

    @ModelAttribute("cartCount")
    public Integer cartCount(HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId != null) {
            return paymentService.getCartCount(memberId);
        }
        return 0;
    }
}
