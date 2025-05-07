package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.post.PostLikeRequestDTO;
import net.spb.spb.service.board.PostLikeService;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board/{category}/like")
public class PostLikeController {
    private final PostLikeService postLikeService;

    @PostMapping("/regist")
    public String insertPostLike(@PathVariable("category") BoardCategory category, @ModelAttribute PostLikeRequestDTO postLikeRequestDTO, HttpSession session) {
        postLikeRequestDTO.setPostLikeMemberId((String)session.getAttribute("memberId"));
        postLikeService.insertLike(postLikeRequestDTO);
        return "redirect:/board/"+category+"/view?idx="+postLikeRequestDTO.getPostIdx();
    }

    @PostMapping("/delete")
    public String deletePostLike(@PathVariable("category") BoardCategory category, @ModelAttribute PostLikeRequestDTO postLikeRequestDTO, HttpSession session) {
        String memberId = (String)session.getAttribute("memberId");
        postLikeRequestDTO.setPostLikeMemberId(memberId);
        postLikeService.deleteLike(postLikeRequestDTO);
        return "redirect:/board/"+category+"/view?idx="+postLikeRequestDTO.getPostIdx();
    }
}