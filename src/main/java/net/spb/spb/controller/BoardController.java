package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.PostDTO;
import net.spb.spb.dto.PostFileDTO;
import net.spb.spb.dto.PostPageDTO;
import net.spb.spb.dto.PostReportDTO;
import net.spb.spb.service.BoardFileService;
import net.spb.spb.service.BoardServiceImpl;
import net.spb.spb.util.BoardCategory;
import net.spb.spb.util.FileUtil;
import net.spb.spb.util.PagingUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
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
    public String list(@PathVariable("category") BoardCategory category, Model model, @ModelAttribute PostPageDTO postPageDTO, HttpServletRequest req) {
        String baseUrl = req.getRequestURI();
        postPageDTO.setLinkUrl(PagingUtil.buildBoardLinkUrl(baseUrl, postPageDTO));
        postPageDTO.setPostCategory(category.toString().toUpperCase());
        postPageDTO.setSearch_type();
        int postTotalCount = service.getPostCount(postPageDTO);
        postPageDTO.setTotal_count(postTotalCount);
        List<PostDTO> posts = service.getPosts(postPageDTO);
        String paging = PagingUtil.pagingArea(postPageDTO);
        model.addAttribute("posts", posts);
        model.addAttribute("search", postPageDTO);
        model.addAttribute("paging", paging);
        model.addAttribute("postTotalCount", postTotalCount);
        return "board/list";
    }

    @GetMapping("/{category}/view")
    public String view(@PathVariable("category") BoardCategory category, @RequestParam("idx") int idx, Model model, HttpSession session) {
        service.setReadCnt(idx);
        String memberId = (String)session.getAttribute("memberId");
        HashMap<String, Object> param = new HashMap<>();
        param.put("postIdx", idx);
        param.put("memberId", memberId);
        PostDTO post = service.getPostByIdx(param);
        model.addAttribute("post", post);
        return "board/view";
    }

    @GetMapping("/{category}/write")
    public String write(@PathVariable("category") BoardCategory category, Model model, HttpSession session) {
        return "board/regist";
    }

    @PostMapping("/{category}/write")
    public String writePOST(@RequestParam(name="files") MultipartFile[] files, @PathVariable("category") BoardCategory category, @ModelAttribute PostDTO dto, HttpSession session) throws IOException {

        dto.setPostCategory(category.toString().toUpperCase());
        dto.setPostMemberId((String)session.getAttribute("memberId"));

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
    public String modify(@PathVariable("category") BoardCategory category, @RequestParam("idx") int idx, Model model, HttpSession session) {
        PostDTO postDTO = service.getPostByIdx(idx);
        if (session.getAttribute("memberId").equals(postDTO.getPostMemberId())) {
            int rtnResult = service.deletePost(postDTO.getPostIdx());
            if (rtnResult < 1) {
                return "";
            }
        }
        model.addAttribute("post", postDTO);
        return "board/modify";
    }

    @PostMapping("/{category}/modify")
    public String modifyPOST(@RequestParam(name="files") MultipartFile[] files, @PathVariable("category") BoardCategory category, @ModelAttribute PostDTO postDTO, @RequestParam(name="deleteFile", defaultValue="") String[] deleteFile, HttpSession session) throws IOException {
        if (session.getAttribute("memberId").equals(postDTO.getPostMemberId())) {
            int rtnResult = service.deletePost(postDTO.getPostIdx());
            if (rtnResult < 1) {
                return "";
            }
        }

        postDTO.setPostUpdatedAt(LocalDateTime.now());
        service.modifyPost(postDTO);

        // 파일 추가
        try {
            for(MultipartFile file : files) {
                if(file != null && !file.isEmpty()) {
                    int fileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
                    PostFileDTO postFileDTO = PostFileDTO.builder().postFilePostIdx(postDTO.getPostIdx()).postFileFileIdx(fileIdx).build();
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
    public String delete(@PathVariable("category") BoardCategory category, @ModelAttribute PostDTO postDTO, HttpSession session) {
        if(session.getAttribute("memberId").equals(postDTO.getPostMemberId())) {
            int rtnResult = service.deletePost(postDTO.getPostIdx());
            if (rtnResult < 1) {
                return "";
            }
        }
        return "redirect:/board/"+category+"/list";
    }

    @PostMapping("/{category}/report/regist")
    public String reportRegist(@PathVariable("category") BoardCategory category, @ModelAttribute PostReportDTO postReportDTO, HttpSession session) {
        if(!session.getAttribute("memberId").equals(postReportDTO.getPostMemberId())) {
            int rtnResult = service.insertPostReport(postReportDTO);
            if (rtnResult < 1) {
                log.info("report regist failed");
            }
        }
        return "redirect:/board/"+category+"/view?idx="+postReportDTO.getReportRefIdx();
    }
}
