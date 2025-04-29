package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.PostCommentDTO;
import net.spb.spb.service.CommentServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/board/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentServiceImpl service;

    @PostMapping("/write")
    public String write(@ModelAttribute PostCommentDTO dto) {
        dto.setPostCommentMemberId("user01");
        service.insertComment(dto);
        return "redirect:/board/freeboard/view?idx="+dto.getPostCommentRefPostIdx();
    }

    @PostMapping("/modify")
    public String modify(@ModelAttribute PostCommentDTO dto) {
        service.updateComment(dto);
        return "redirect:/board/freeboard/view?idx="+dto.getPostCommentRefPostIdx();
    }

    @PostMapping("/delete")
    public String delete(@ModelAttribute PostCommentDTO dto) {
        service.deleteComment(dto.getPostCommentIdx());
        return "redirect:/board/freeboard/view?idx="+dto.getPostCommentRefPostIdx();
    }
}
