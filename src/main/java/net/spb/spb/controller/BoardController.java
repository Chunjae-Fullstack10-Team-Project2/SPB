package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PostDTO;
import net.spb.spb.dto.PostFileDTO;
import net.spb.spb.service.BoardFileService;
import net.spb.spb.service.BoardServiceImpl;
import net.spb.spb.util.BoardCategory;
import net.spb.spb.util.FileUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@Log4j2
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardServiceImpl service;
    private final BoardFileService boardFileService;
    private final FileUtil fileUtil;

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
    public String writePOST(@RequestParam(name="files") MultipartFile[] files, @PathVariable("category") BoardCategory category, @ModelAttribute PostDTO dto) throws IOException {

        dto.setPostCategory(category.toString().toUpperCase());
        dto.setPostMemberId("user01"); // 세션에서 받은 아이디로 추후 변경 예정

        int postIdx = service.insertPost(dto);

        // 파일 처리
        try {
            for(MultipartFile file : files) {
                if(file != null && !file.isEmpty()) {
                    log.info("BoardController >> writePOST >> file upload");
                    int fileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
                    PostFileDTO postFileDTO = PostFileDTO.builder().postFilePostIdx(postIdx).postFileFileIdx(fileIdx).build();
                    boardFileService.insertBoardFile(postFileDTO);
                }
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }

        return "redirect:/board/"+category+ "/list";
    }

    @GetMapping("/{category}/modify")
    public String modify(@PathVariable("category") BoardCategory category, @RequestParam("idx") int idx, Model model) {
        PostDTO post = service.getPostByIdx(idx);
        model.addAttribute("post", post);
        return "board/modify";
    }

    @PostMapping("/{category}/modify")
    public String modifyPOST(@RequestParam(name="files") MultipartFile[] files, @PathVariable("category") BoardCategory category, @ModelAttribute PostDTO dto, @RequestParam(name="deleteFile", defaultValue="") String[] deleteFile) throws IOException {

        dto.setPostUpdatedAt(LocalDateTime.now());
        service.modifyPost(dto);

        // 파일 추가
        try {
            for(MultipartFile file : files) {
                if(file != null && !file.isEmpty()) {
                    int fileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
                    PostFileDTO postFileDTO = PostFileDTO.builder().postFilePostIdx(dto.getPostIdx()).postFileFileIdx(fileIdx).build();
                    boardFileService.insertBoardFile(postFileDTO);
                }
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }

        // 파일 삭제
        for (String file : deleteFile) {
            String fileName = file.substring(file.indexOf("|")+1);
            int fileIdx = Integer.parseInt(file.substring(0, file.indexOf("|")));
            try {
                fileUtil.deleteFile(fileName);
                boardFileService.deleteBoardFileByFileIdx(fileIdx);
            } catch(Exception e) {
                log.info(e.getMessage());
            }
        }
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
