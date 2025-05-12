package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.post.PostCommentDTO;
import net.spb.spb.service.board.CommentServiceIf;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/board/{category}/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentServiceIf service;

    @PostMapping("/write")
    @ResponseBody
    public Map<String, Object> write(@PathVariable("category") BoardCategory category,
                                                @Valid @ModelAttribute PostCommentDTO postCommentDTO,
                                                BindingResult bindingResult,
                                                HttpSession session,
                                                @RequestParam("memberProfileImg") String memberProfileImg) {

        Map<String, Object> response = new HashMap<>();

        if (bindingResult.hasErrors()) {
            String firstErrorMessage = bindingResult.getFieldErrors().get(0).getDefaultMessage();
            response.put("success", false);
            response.put("message", firstErrorMessage);
            return response;
        }

        String sessionMemberId = (String) session.getAttribute("memberId");
        postCommentDTO.setPostCommentMemberId(sessionMemberId);
        int result = service.insertComment(postCommentDTO);
        postCommentDTO.setPostCommentMemberProfileImg(memberProfileImg);
        postCommentDTO.setPostCommentIdx(result);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "댓글이 등록되었습니다.");
            response.put("comment", postCommentDTO);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            response.put("createdAt", LocalDateTime.now().format(formatter));
        } else {
            response.put("success", false);
            response.put("message", "댓글 등록에 실패했습니다.");
        }
        return response;
    }

    @PostMapping("/modify")
    @ResponseBody
    public Map<String, Object> modify(@PathVariable("category") BoardCategory category,
                                      @Valid @ModelAttribute PostCommentDTO postCommentDTO,
                                      BindingResult bindingResult,
                                      HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        if (bindingResult.hasErrors()) {
            String firstErrorMessage = bindingResult.getFieldErrors().get(0).getDefaultMessage();
            response.put("success", false);
            response.put("message", firstErrorMessage);
            return response;
        }
        String sessionMemberId = (String) session.getAttribute("memberId");
        if (!sessionMemberId.equals(postCommentDTO.getPostCommentMemberId())) {
            response.put("success", false);
            response.put("message", "권한이 없습니다.");
            return response;
        }
        int result = service.modifyComment(postCommentDTO);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "댓글을 수정하였습니다.");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            response.put("updatedAt", LocalDateTime.now().format(formatter));
        } else {
            response.put("success", false);
            response.put("message", "댓글 수정에 실패하였습니다.");
        }
        return response;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@PathVariable("category") BoardCategory category,
                                      @ModelAttribute PostCommentDTO postCommentDTO,
                                      HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        if (postCommentDTO.getPostCommentIdx()<1) {
            response.put("success", false);
            response.put("message", "잘못된 요청입니다.");
        }
        String sessionMemberId = (String) session.getAttribute("memberId");
        if (!sessionMemberId.equals(postCommentDTO.getPostCommentMemberId())) {
            response.put("success", false);
            response.put("message", "권한이 없습니다.");
            return response;
        }
        int result = service.deleteComment(postCommentDTO.getPostCommentIdx());
        if (result > 0) {
            response.put("success", true);
            response.put("message", "댓글이 삭제되었습니다.");
        } else {
            response.put("success", false);
            response.put("message", "댓글 삭제에 실패했습니다.");
        }
        return response;
    }
}
