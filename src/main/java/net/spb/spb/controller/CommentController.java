package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.PostCommentDTO;
import net.spb.spb.service.CommentServiceImpl;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/board/{category}/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentServiceImpl service;

    @PostMapping("/write")
    public String write(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO dto) {
        dto.setPostCommentMemberId("user01");
        service.insertComment(dto);
        return "redirect:/board/"+category+"/view?idx="+dto.getPostCommentRefPostIdx();
    }

    @PostMapping("/modify")
    public String modify(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO dto) {
        service.updateComment(dto);
        return "redirect:/board/"+category+"/view?idx="+dto.getPostCommentRefPostIdx();
    }

    @PostMapping("/delete")
    public String delete(@PathVariable("category") BoardCategory category, @ModelAttribute PostCommentDTO dto) {
        service.deleteComment(dto.getPostCommentIdx());
        return "redirect:/board/"+category+"/view?idx="+dto.getPostCommentRefPostIdx();

    }
}
