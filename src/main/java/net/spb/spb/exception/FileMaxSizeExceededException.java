package net.spb.spb.exception;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
@Log4j2
public class FileMaxSizeExceededException {
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public String handleMaxSizeException(MaxUploadSizeExceededException exc,
                                         HttpServletRequest request,
                                         RedirectAttributes redirectAttributes) {
        String referer = request.getHeader("Referer");
        redirectAttributes.addFlashAttribute("errorMessage", "파일 사이즈 초과");
        log.error("파일 사이즈 초과");
        if (referer == null || referer.isBlank()) {
            return "redirect:/error";
        }
        return "redirect:" + referer;
    }
}
