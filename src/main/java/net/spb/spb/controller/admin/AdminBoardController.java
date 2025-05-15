package net.spb.spb.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.PostPageDTO;
import net.spb.spb.dto.post.PostDTO;
import net.spb.spb.service.AdminService;
import net.spb.spb.service.board.BoardServiceIf;
import net.spb.spb.util.BoardCategory;
import net.spb.spb.util.BreadcrumbUtil;
import net.spb.spb.util.NewPagingUtil;
import net.spb.spb.util.PagingUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminBoardController extends AdminBaseController {

    private final AdminService adminService;
    private final BoardServiceIf boardService;

    @GetMapping("/board/manage")
    public String boardReportList(@ModelAttribute PostPageDTO postPageDTO,
                                  Model model,
                                  HttpServletRequest req) {
        postPageDTO.setPostCategory(BoardCategory.freeboard.name().toUpperCase());
        String baseUrl = req.getRequestURI();
        postPageDTO.normalizeSearchType();
        postPageDTO.setLinkUrl(PagingUtil.buildLinkUrl(baseUrl, postPageDTO));
        int totalCount = boardService.getPostCount(postPageDTO);
        postPageDTO.setTotal_count(totalCount);
        String paging = NewPagingUtil.pagingArea(postPageDTO);
        List<PostDTO> postDTOs = adminService.selectReportedPosts(postPageDTO);
        model.addAttribute("postTotalCount", totalCount);
        model.addAttribute("posts", postDTOs);
        model.addAttribute("search", postPageDTO);
        model.addAttribute("paging", paging);
        setBreadcrumb(model, Map.of("자유게시판 관리", ""));
        return "/admin/board/list";
    }

    @GetMapping("/board/manage/view")
    @ResponseBody
    public ResponseEntity<PostDTO> boardManageView(@RequestParam("idx") int idx) {
        PostDTO postDTO = adminService.selectPostByIdx(idx);
        return ResponseEntity.ok(postDTO);
    }

    @PostMapping("/board/report/state")
    public Map<String, Object> boardReportState() {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = 0;
        //adminService.updateReport();
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "신고가 접수되었습니다.");
        } else {
            result.put("success", false);
            result.put("message", "신고 접수에 실패했습니다.");
        }

        return result;
    }

    @PostMapping("/board/delete")
    @ResponseBody
    public Map<String, Object> boardReportDelete(@RequestParam("postIdx") int postIdx) {
        Map<String, Object> result = new HashMap<>();

        PostDTO postDTO = adminService.selectPostByIdx(postIdx);

        if (postDTO.getPostState() == 3) {
            result.put("success", false);
            result.put("message", "이미 삭제된 게시글입니다.");
            return result;
        }

        int rtnResult = adminService.deletePostByAdmin(postIdx);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "게시글이 삭제되었습니다.");
        } else {
            result.put("success", false);
            result.put("message", "게시글 삭제에 실패했습니다.");
        }
        return result;
    }

}
