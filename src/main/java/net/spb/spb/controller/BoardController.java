package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.post.PostDTO;
import net.spb.spb.dto.post.PostFileDTO;
import net.spb.spb.dto.pagingsearch.PostPageDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.service.board.BoardFileService;
import net.spb.spb.service.board.BoardServiceImpl;
import net.spb.spb.service.board.NaverNewsService;
import net.spb.spb.util.*;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@Log4j2
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardServiceImpl service;
    private final BoardFileService boardFileService;
    private final FileUtil fileUtil;

    @Autowired
    private NaverNewsService naverNewsService;

    private static final long MAX_FILE_SIZE = 100 * 1024 * 1024;

    @GetMapping("/{category}/list")
    public String list(@PathVariable("category") BoardCategory category,
                       Model model,
                       @ModelAttribute PostPageDTO postPageDTO,
                       HttpServletRequest req) {
        String baseUrl = req.getRequestURI();
        postPageDTO.setLinkUrl(NewPagingUtil.buildLinkUrl(baseUrl, postPageDTO));
        postPageDTO.setPostCategory(category.toString().toUpperCase());
        postPageDTO.normalizeSearchType();
        int postTotalCount = service.getPostCount(postPageDTO);
        postPageDTO.setTotal_count(postTotalCount);
        List<PostDTO> posts = service.getPosts(postPageDTO);
        String paging = NewPagingUtil.pagingArea(postPageDTO);
        model.addAttribute("posts", posts);
        model.addAttribute("search", postPageDTO);
        model.addAttribute("paging", paging);
        model.addAttribute("postTotalCount", postTotalCount);
        addBreadcrumb(model, category, "목록");
        return "board/list";
    }

    @GetMapping("/{category}/view")
    public String view(@PathVariable("category") BoardCategory category,
                       @RequestParam("idx") int idx,
                       Model model,
                       HttpSession session) {
        service.setReadCnt(idx);
        String memberId = (String) session.getAttribute("memberId");
        HashMap<String, Object> param = new HashMap<>();
        param.put("postIdx", idx);
        param.put("memberId", memberId);
        PostDTO post = service.getPostByIdx(param);
        model.addAttribute("post", post);
        addBreadcrumb(model, category, "상세 보기");
        return "board/view";
    }

    @GetMapping("/{category}/write")
    public String write(@PathVariable("category") BoardCategory category,
                        Model model,
                        HttpSession session) {
        addBreadcrumb(model, category, "글쓰기");
        return "board/regist";
    }

    @PostMapping("/{category}/write")
    public String writePOST(@RequestParam(name = "files") MultipartFile[] files,
                            @PathVariable("category") BoardCategory category,
                            HttpSession session,
                            RedirectAttributes redirectAttributes,
                            @Valid @ModelAttribute PostDTO postDTO,
                            BindingResult bindingResult) throws IOException {

        // 제목 / 내용 체크
        if (bindingResult.hasErrors()) {
            List<String> errorMessages = bindingResult.getFieldErrors().stream()
                    .map(FieldError::getDefaultMessage)  // 메시지만 추출
                    .collect(Collectors.toList());

            redirectAttributes.addFlashAttribute("errorMessages", errorMessages);
            redirectAttributes.addFlashAttribute("postDTO", postDTO);
            return "redirect:/board/" + category + "/write";
        }

        postDTO.setPostCategory(category.toString().toUpperCase());
        postDTO.setPostMemberId((String) session.getAttribute("memberId"));

        if (files.length > 10) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 한 번에 최대 10개까지 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("postDTO", postDTO);
            return "redirect:/board/" + category + "/write";
        }

        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
                redirectAttributes.addFlashAttribute("errorMessage", "각 파일은 10MB 이하만 업로드할 수 있습니다.");
                redirectAttributes.addFlashAttribute("postDTO", postDTO);
                return "redirect:/board/" + category + "/write";
            }
        }

        int postIdx = service.insertPost(postDTO);

        try {
            for (MultipartFile file : files) {
                if (file != null && !file.isEmpty()) {
                    int fileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
                    PostFileDTO postFileDTO = PostFileDTO.builder().postFilePostIdx(postIdx).postFileFileIdx(fileIdx).build();
                    boardFileService.insertBoardFile(postFileDTO);
                }
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }

        return "redirect:/board/" + category + "/list";
    }

    @GetMapping("/{category}/modify")
    public String modify(@PathVariable("category") BoardCategory category,
                         @RequestParam("idx") int idx,
                         Model model,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        PostDTO postDTO = service.getPostByIdx(idx);
        String loginMemberId = (String) session.getAttribute("memberId");
        if (!loginMemberId.equals(postDTO.getPostMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/board/"+category+"/list";
        }
        model.addAttribute("post", postDTO);
        addBreadcrumb(model, category, "수정");
        return "board/modify";
    }

    @PostMapping("/{category}/modify")
    public String modifyPOST(@RequestParam(name = "files") MultipartFile[] files,
                             @PathVariable("category") BoardCategory category,
                             @Valid @ModelAttribute PostDTO postDTO,
                             BindingResult bindingResult,
                             @RequestParam(name = "deleteFile", defaultValue = "") String[] deleteFile,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) throws IOException {

        // 제목 / 내용 체크
        if (bindingResult.hasErrors()) {
            List<String> errorMessages = bindingResult.getFieldErrors().stream()
                    .map(FieldError::getDefaultMessage)
                    .collect(Collectors.toList());
            redirectAttributes.addFlashAttribute("errorMessages", errorMessages);
            redirectAttributes.addFlashAttribute("postDTO", postDTO);
            return "redirect:/board/" + category + "/modify?idx="+postDTO.getPostIdx();
        }

        String sessionMemberId = (String) session.getAttribute("memberId");
        if (!sessionMemberId.equals(postDTO.getPostMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/board/"+category+"/list";
        }

        if (files.length > 10) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 한 번에 최대 10개까지 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("postDTO", postDTO);
            return "redirect:/board/" + category + "/modify?idx="+postDTO.getPostIdx();
        }

        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
                redirectAttributes.addFlashAttribute("errorMessage", "각 파일은 10MB 이하만 업로드할 수 있습니다.");
                redirectAttributes.addFlashAttribute("postDTO", postDTO);
                return "redirect:/board/" + category + "/modify?idx="+postDTO.getPostIdx();
            }
        }

        postDTO.setPostUpdatedAt(LocalDateTime.now());
        service.modifyPost(postDTO);

        // 파일 추가
        try {
            for (MultipartFile file : files) {
                if (file != null && !file.isEmpty()) {
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
            String fileName = file.substring(file.indexOf("|") + 1);
            int fileIdx = Integer.parseInt(file.substring(0, file.indexOf("|")));
            try {
                fileUtil.deleteFile(fileName);
                boardFileService.deleteBoardFileByFileIdx(fileIdx);
            } catch (Exception e) {
                log.info(e.getMessage());
            }
        }

        return "redirect:/board/" + category + "/view?idx="+postDTO.getPostIdx();
    }

    @PostMapping("/{category}/delete")
    @ResponseBody
    public Map<String, Object> deletePostAjax(@PathVariable("category") BoardCategory category,
                                              @ModelAttribute PostDTO postDTO,
                                              HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        String sessionMemberId = (String) session.getAttribute("memberId");
        if (!sessionMemberId.equals(postDTO.getPostMemberId())) {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
            return result;
        }

        int rtnResult = service.deletePost(postDTO.getPostIdx());
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "게시글이 삭제되었습니다.");
            result.put("redirect", "/board/" + category.name().toLowerCase() + "/list");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    @PostMapping("/{category}/report/regist")
    @ResponseBody
    public Map<String, Object> reportRegist(@PathVariable("category") BoardCategory category,
                                            @RequestParam("postMemberId") String postMemberId,
                                            @ModelAttribute PostReportDTO postReportDTO,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String sessionMemberId = (String) session.getAttribute("memberId");

        if (sessionMemberId.equals(postMemberId)) {
            result.put("success", false);
            result.put("message", "자신의 게시글은 신고할 수 없습니다.");
            return result;
        }
        postReportDTO.setReportMemberId(sessionMemberId);
        postReportDTO.setReportRefType(ReportRefType.POST);
        int rtnResult = service.insertPostReport(postReportDTO);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "신고가 접수되었습니다.");
        } else {
            result.put("success", false);
            result.put("message", "이미 신고한 게시글입니다.");
        }

        return result;
    }


    @GetMapping("/news")
    public String listNews(Model model,
                           @ModelAttribute SearchDTO searchDTO,
                           @ModelAttribute PageRequestDTO pageRequestDTO) throws Exception {
        String keyword = searchDTO.getSearchWord();

        if (keyword == null || keyword.isBlank()) {
            model.addAttribute("searchDTO", searchDTO);
            model.addAttribute("newsList", List.of());
            model.addAttribute("message", "검색어를 입력하세요. 결과는 최신순으로 최대 100개까지 조회 가능합니다.");
            return "board/news/news";
        }

        List<Map<String, Object>> fullList = naverNewsService.searchNewsList(keyword);

        String searchType = searchDTO.getSearchType();
        if (searchType != null && !searchType.isBlank()) {
            fullList = fullList.stream()
                    .filter(news -> {
                        Object field = news.get(searchType);
                        return field != null && field.toString().toLowerCase().contains(keyword.toLowerCase());
                    })
                    .collect(Collectors.toList());
        }

        String sortColumn = Optional.ofNullable(searchDTO.getSortColumn()).orElse("pubDate");
        String sortOrder = Optional.ofNullable(searchDTO.getSortOrder()).orElse("desc");

        Comparator<Map<String, Object>> comparator = Comparator.comparing(
                news -> Optional.ofNullable(news.get(sortColumn)).map(Object::toString).orElse("")
        );

        if ("desc".equalsIgnoreCase(sortOrder)) {
            comparator = comparator.reversed();
        }

        List<Map<String, Object>> sortedList = fullList.stream().sorted(comparator).collect(Collectors.toList());

        int total = sortedList.size();
        PageResponseDTO<Map<String, Object>> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                total,
                () -> {
                    int start = pageRequestDTO.getPageSkipCount();
                    int end = Math.min(start + pageRequestDTO.getPageSize(), total);
                    return start >= total ? List.of() : sortedList.subList(start, end);
                }
        );

        model.addAttribute("newsList", pageResponseDTO.getDtoList());
        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("searchDTO", searchDTO);
        return "board/news/news";
    }

    private void addBreadcrumb(Model model, BoardCategory category, String currentPageName) {
        List<Map<String, String>> breadcrumbItems = List.of(
                Map.of("name", category.getDisplayName(), "url", "/board/" + category.name().toLowerCase() + "/list"),
                Map.of("name", currentPageName, "url", "")
        );
        model.addAttribute("breadcrumbItems", breadcrumbItems);
    }

}
