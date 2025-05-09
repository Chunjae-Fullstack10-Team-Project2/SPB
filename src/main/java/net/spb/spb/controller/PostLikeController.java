package net.spb.spb.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import net.spb.spb.dto.post.PostLikeRequestDTO;
import net.spb.spb.service.board.PostLikeService;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board/{category}/like")
public class PostLikeController {
    private final PostLikeService postLikeService;

    @PostMapping("/regist")
    @ResponseBody
    public Map<String, Object> insertPostLike(@PathVariable("category") BoardCategory category, @ModelAttribute PostLikeRequestDTO postLikeRequestDTO, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        postLikeRequestDTO.setPostLikeMemberId((String) session.getAttribute("memberId"));
        int inserted = postLikeService.insertLike(postLikeRequestDTO);

        if (inserted > 0) {
            result.put("success", true);
            result.put("message", "좋아요를 추가했습니다.");
        } else {
            result.put("success", false);
            result.put("message", "좋아요 등록에 실패했습니다.");
        }

        return result;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deletePostLike(@PathVariable("category") BoardCategory category, @ModelAttribute PostLikeRequestDTO postLikeRequestDTO, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        postLikeRequestDTO.setPostLikeMemberId((String) session.getAttribute("memberId"));
        int deleted = postLikeService.deleteLike(postLikeRequestDTO);

        if (deleted > 0) {
            result.put("success", true);
            result.put("message", "좋아요를 취소했습니다.");
        } else {
            result.put("success", false);
            result.put("message", "좋아요 취소에 실패했습니다.");
        }

        return result;
    }

}