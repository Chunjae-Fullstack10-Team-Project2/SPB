package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PostDTO;
import net.spb.spb.service.BoardServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@Log4j2
@RequestMapping("/board/freeboard")
@RequiredArgsConstructor
public class BoardController {

    private final BoardServiceImpl service;

    @GetMapping("/list")
    public String list(Model model) {
        List<PostDTO> posts = service.getPosts();
        model.addAttribute("posts", posts);
        return "board/list";
    }

    @GetMapping("/view")
    public String view(@RequestParam("idx") int idx, Model model) {
        PostDTO post = service.getPostByIdx(idx);
        model.addAttribute("post", post);
        return "board/view";
    }

    @GetMapping("/write")
    public String write() {
        return "board/regist";
    }

    @PostMapping("/write")
    public String writePOST(@ModelAttribute PostDTO dto) {
        dto.setPostCategory("FREEBOARD");
        dto.setPostMemberId("user01");
        service.insertPost(dto);
        return "redirect:/board/list";
    }


    @GetMapping("/modify")
    public String modify(@RequestParam("idx") int idx, Model model) {
        PostDTO post = service.getPostByIdx(idx);
        model.addAttribute("post", post);
        return "board/modify";
    }

    @PostMapping("/modify")
    public String modifyPOST(@ModelAttribute PostDTO dto) {
        dto.setPostUpdatedAt(LocalDateTime.now());
        service.modifyPost(dto);
        return "redirect:/board/freeboard/list";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("idx") int idx) {
        int rtnResult = service.deletePost(idx);
        if (rtnResult < 1) {
            return "";
        }
        return "redirect:/board/freeboard/list";
    }
}
