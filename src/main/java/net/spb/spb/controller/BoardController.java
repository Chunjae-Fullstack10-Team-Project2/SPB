package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
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
import net.spb.spb.util.BoardCategory;
import net.spb.spb.util.FileUtil;
import net.spb.spb.util.NewPagingUtil;
import net.spb.spb.util.ReportRefType;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
                            @ModelAttribute PostDTO dto,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) throws IOException {

        if (files.length > 10) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 최대 10개까지 업로드할 수 있습니다.");
            return "redirect:/board/" + category + "/write";
        }

        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
                redirectAttributes.addFlashAttribute("errorMessage", "각 파일은 10MB 이하만 업로드할 수 있습니다.");
                return "redirect:/board/" + category + "/write";
            }
        }

        dto.setPostCategory(category.toString().toUpperCase());
        dto.setPostMemberId((String) session.getAttribute("memberId"));
        int postIdx = service.insertPost(dto);

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
                             @ModelAttribute PostDTO postDTO,
                             @RequestParam(name = "deleteFile", defaultValue = "") String[] deleteFile,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) throws IOException {
        String sessionMemberId = (String) session.getAttribute("memberId");
        if (!sessionMemberId.equals(postDTO.getPostMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/board/"+category+"/list";
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
        return "redirect:/board/" + category + "/list";
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
            result.put("message", "신고 접수에 실패했습니다.");
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

        // 내부 검색 필터링
        String searchType = searchDTO.getSearchType();
        if (searchType != null && !searchType.isBlank()) {
            fullList = fullList.stream()
                    .filter(news -> {
                        Object field = news.get(searchType);
                        return field != null && field.toString().toLowerCase().contains(keyword.toLowerCase());
                    })
                    .toList();
        }

        // 정렬 처리
        String sortColumn = searchDTO.getSortColumn() != null ? searchDTO.getSortColumn() : "pubDate";
        String sortOrder = searchDTO.getSortOrder() != null ? searchDTO.getSortOrder() : "desc";

        Comparator<Map<String, Object>> comparator = Comparator.comparing(
                news -> {
                    Object value = news.get(sortColumn);
                    return value != null ? value.toString() : "";
                },
                Comparator.naturalOrder()
        );

        if ("desc".equalsIgnoreCase(sortOrder)) {
            comparator = comparator.reversed();
        }

        fullList = fullList.stream().sorted(comparator).toList();

        // 페이징
        int total = fullList.size();
        int start = pageRequestDTO.getPageSkipCount();
        int end = Math.min(start + pageRequestDTO.getPageSize(), total);
        List<Map<String, Object>> pageList = (start >= total) ? List.of() : fullList.subList(start, end);

        PageResponseDTO<Map<String, Object>> pageResponseDTO = PageResponseDTO.<Map<String, Object>>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(total)
                .dtoList(pageList)
                .build();

        model.addAttribute("newsList", pageList);
        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("searchDTO", searchDTO);

        return "board/news/news";
    }

    private void addBreadcrumb(Model model, BoardCategory category, String currentPageName) {
        List<Map<String, String>> breadcrumbItems = List.of(
                Map.of("name", "게시판", "url", "/board"),
                Map.of("name", category.getDisplayName(), "url", "/board/" + category.name().toLowerCase() + "/list"),
                Map.of("name", currentPageName, "url", "")
        );
        model.addAttribute("breadcrumbItems", breadcrumbItems);
    }

}
