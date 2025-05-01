package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.PostLikeRequestDTO;
import net.spb.spb.service.PostLikeService;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board/{category}/like")
public class PostLikeController {
    private final PostLikeService postLikeService;

    @PostMapping("/regist")
    public String insertPostLike(@PathVariable("category") BoardCategory category, @ModelAttribute PostLikeRequestDTO postLikeRequestDTO) {
        String memberId = "user05"; // 세션에서 받은 아이디로 추후 변경 예정
        postLikeRequestDTO.setPostLikeMemberId(memberId);
        postLikeService.insertLike(postLikeRequestDTO);
        return "redirect:/board/"+category+"/view?idx="+postLikeRequestDTO.getPostIdx();
    }

    @PostMapping("/delete")
    public String deletePostLike(@PathVariable("category") BoardCategory category, @ModelAttribute PostLikeRequestDTO postLikeRequestDTO) {
        String memberId = "user05"; // 세션에서 받은 아이디로 추후 변경 예정
        postLikeRequestDTO.setPostLikeMemberId(memberId);
        postLikeService.deleteLike(postLikeRequestDTO);
        return "redirect:/board/"+category+"/view?idx="+postLikeRequestDTO.getPostIdx();
    }
}
