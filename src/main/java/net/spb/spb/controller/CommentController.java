package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.post.PostCommentDTO;
import net.spb.spb.service.board.CommentServiceIf;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/board/{category}/comment")
@RequiredArgsConstructor
@Log4j2
public class CommentController {

    private final CommentServiceIf service;

    @PostMapping("/write")
    @ResponseBody
    public Map<String, Object> write(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO postCommentDTO, HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String sessionMemberId = (String) session.getAttribute("memberId");
        postCommentDTO.setPostCommentMemberId(sessionMemberId);
        int rtnResult = service.insertComment(postCommentDTO);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "댓글을 등록하였습니다.");
        } else {
            result.put("success", false);
            result.put("message", "댓글 등록에 실패하였습니다.");
        }
        return result;
    }

    @PostMapping("/modify")
    @ResponseBody
    public Map<String, Object> modify(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO postCommentDTO, HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String sessionMemberId = (String) session.getAttribute("memberId");
        if (!sessionMemberId.equals(postCommentDTO.getPostCommentMemberId())) {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
            return result;
        }
        int rtnResult = service.modifyComment(postCommentDTO);

        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "댓글을 수정하였습니다.");
        } else {
            result.put("success", false);
            result.put("message", "댓글 수정에 실패하였습니다.");
        }
        return result;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO postCommentDTO, HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String sessionMemberId = (String) session.getAttribute("memberId");
        if (!sessionMemberId.equals(postCommentDTO.getPostCommentMemberId())) {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
            return result;
        }

        int rtnResult = service.deleteComment(postCommentDTO.getPostCommentIdx());
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "댓글이 삭제되었습니다.");
        } else {
            result.put("success", false);
            result.put("message", "댓글 삭제에 실패했습니다.");
        }
        return result;
    }
}
