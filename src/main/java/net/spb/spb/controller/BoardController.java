package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PostDTO;
import net.spb.spb.service.BoardServiceImpl;
import net.spb.spb.util.BoardCategory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@Log4j2
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardServiceImpl service;

    @GetMapping("/{category}/list")
    public String list(@PathVariable("category") BoardCategory category, Model model) {
        List<PostDTO> posts = service.getPosts(category.toString().toUpperCase());
        model.addAttribute("posts", posts);
        return "board/list";
    }

    @GetMapping("/{category}/view")
    public String view(@PathVariable("category") BoardCategory category, @RequestParam("idx") int idx, Model model) {
        PostDTO post = service.getPostByIdx(idx);
        model.addAttribute("post", post);
        return "board/view";
    }

    @GetMapping("/{category}/write")
    public String write(@PathVariable("category") BoardCategory category, Model model) {

        return "board/regist";
    }

    @PostMapping("/{category}/write")
    public String writePOST(@PathVariable("category") BoardCategory category, @ModelAttribute PostDTO dto) {
        log.info(category.toString().toUpperCase());
        log.info(category.toString());
        dto.setPostCategory(category.toString().toUpperCase());
        dto.setPostMemberId("user01"); // 세션에서 받은 아이디로 추후 변경 예정
        service.insertPost(dto);
        return "redirect:/board/"+category+ "/list";
    }


    @GetMapping("/{category}/modify")
    public String modify(@PathVariable("category") BoardCategory category, @RequestParam("idx") int idx, Model model) {
        PostDTO post = service.getPostByIdx(idx);
        model.addAttribute("post", post);
        return "board/modify";
    }

    @PostMapping("/{category}/modify")
    public String modifyPOST(@PathVariable("category") BoardCategory category, @ModelAttribute PostDTO dto) {
        dto.setPostUpdatedAt(LocalDateTime.now());
        service.modifyPost(dto);
        return "redirect:/board/" + category + "/list";
    }

    @PostMapping("/{category}/delete")
    public String delete(@PathVariable("category") BoardCategory category, @RequestParam("idx") int idx) {
        int rtnResult = service.deletePost(idx);
        if (rtnResult < 1) {
            return "";
        }
        return "redirect:/board/"+category+"/list";
    }
}
