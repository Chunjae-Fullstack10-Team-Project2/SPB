package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PostCommentDTO;
import net.spb.spb.service.CommentServiceIf;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/board/{category}/comment")
@RequiredArgsConstructor
@Log4j2
public class CommentController {

    private final CommentServiceIf service;

    @PostMapping("/write")
    public String write(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO dto, HttpSession session) {
        dto.setPostCommentMemberId((String) session.getAttribute("memberId"));
        service.insertComment(dto);
        return "redirect:/board/"+category+"/view?idx="+dto.getPostCommentRefPostIdx()
                +"#comment-item"+dto.getPostCommentIdx();
    }

    @PostMapping("/modify")
    public String modify(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO dto, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        if (!memberId.equals(dto.getPostCommentMemberId())) {
            return "";
        }
        service.updateComment(dto);
        return "redirect:/board/" + category + "/view?idx=" + dto.getPostCommentRefPostIdx()
                + "#comment-item"+dto.getPostCommentIdx();
    }

    @PostMapping("/delete")
    public String delete(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO dto, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        if (!memberId.equals(dto.getPostCommentMemberId())) {
            return "";
        }
        service.deleteComment(dto.getPostCommentIdx());
        return "redirect:/board/" + category + "/view?idx=" + dto.getPostCommentRefPostIdx();
    }
}
