package net.spb.spb.exception;

import lombok.extern.log4j.Log4j2;
import org.springframework.ui.Model;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
@Log4j2
public class GlobalExceptionHandler {

    @ExceptionHandler({NumberFormatException.class, MethodArgumentTypeMismatchException.class})
    public String handleNumberFormatException(Exception ex, Model model) {
        log.warn("잘못된 숫자 형식 예외 발생: {}", ex.getMessage());
        return renderError(model, "잘못된 요청", "잘못된 요청입니다", "쿼리스트링 또는 숫자 파라미터가 올바르지 않습니다.");
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public String handleMissingParams(MissingServletRequestParameterException ex, Model model) {
        log.warn("파라미터 누락: {}", ex.getMessage());
        return renderError(model, "파라미터 누락", "요청이 잘못되었습니다", "요청에 필요한 파라미터가 누락되었습니다.");
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public String handle404(NoHandlerFoundException ex, Model model) {
        log.warn("404 에러 발생: {}", ex.getRequestURL());
        return renderError(model, "404 - 페이지 없음", "페이지를 찾을 수 없습니다", "요청하신 페이지가 존재하지 않거나 삭제되었습니다.");
    }

    @ExceptionHandler(Exception.class)
    public String handleGeneric(Exception ex, Model model) {
        log.error("알 수 없는 예외 발생", ex);
        return renderError(model, "500 - 서버 오류", "내부 서버 오류", "서버 처리 중 문제가 발생했습니다. 관리자에게 문의해주세요.");
    }

    private String renderError(Model model, String title, String heading, String message) {
        model.addAttribute("title", title);
        model.addAttribute("heading", heading);
        model.addAttribute("message", message);
        return "error/common"; // /WEB-INF/views/error/common.jsp
    }
}