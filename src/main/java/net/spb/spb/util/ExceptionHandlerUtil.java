package net.spb.spb.util;

import org.springframework.ui.Model;

public class ExceptionHandlerUtil {
    public static String handle(RuntimeException e, String redirectUrl, Model model) {
        model.addAttribute("errorMessage", e.getMessage());
        return "redirect:" + redirectUrl;
    }
}
