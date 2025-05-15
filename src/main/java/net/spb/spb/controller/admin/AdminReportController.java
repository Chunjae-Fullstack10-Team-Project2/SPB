package net.spb.spb.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.service.ReportService;
import net.spb.spb.util.PageUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin/report")
public class AdminReportController extends AdminBaseController {

    private final ReportService reportService;

    @GetMapping("/list")
    public String reportList() {
        return "admin/report/list";
    }

    @GetMapping("/list/board")
    public String boardReportList(@ModelAttribute SearchDTO searchDTO,
                                  @ModelAttribute PageRequestDTO pageRequestDTO,
                                  Model model) {
        int totalCount = reportService.boardReportTotalCount(searchDTO);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> reportService.listBoardReport(searchDTO, pageRequestDTO)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("boardReportList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("자유게시판 신고 목록", ""));

        return "admin/report/boardReportTable";
    }

    @PostMapping(path = "/board/reject", produces = "text/plain;charset=UTF-8")
    public ResponseEntity<String> rejectBoardReport(@RequestParam("reportIdx") String reportIdx) {
        reportService.rejectBoardReport(reportIdx);
        return ResponseEntity.ok("신고가 반려되었습니다.");
    }

    @PostMapping(path = "/board/process", produces = "text/plain;charset=UTF-8")
    public ResponseEntity<String> processBoardReport(@RequestParam("reportIdx") String reportIdx) {
        reportService.updateBoardReportAsProcessed(reportIdx);
        return ResponseEntity.ok("신고가 처리되었습니다.");
    }

    @GetMapping("/list/review")
    public String reviewReportList(@ModelAttribute SearchDTO searchDTO,
                                   @ModelAttribute PageRequestDTO pageRequestDTO,
                                   Model model) {
        int totalCount = reportService.reviewReportTotalCount(searchDTO);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageUtil.buildAndCorrectPageResponse(
                pageRequestDTO,
                totalCount,
                () -> reportService.listReviewReport(searchDTO, pageRequestDTO)
        );

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("reviewReportList", pageResponseDTO.getDtoList());
        model.addAttribute("searchDTO", searchDTO);
        setBreadcrumb(model, Map.of("강의평 신고 목록", ""));

        return "admin/report/reviewReportTable";
    }

    @PostMapping(path = "/review/process", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> processReviewReport(@RequestParam("reportIdx") String reportIdx) {
        reportService.updateReviewReportAsProcessed(reportIdx);
        return ResponseEntity.ok("신고가 처리되었습니다.");
    }

    @PostMapping(path = "/review/reject", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> rejectReviewReport(@RequestParam("reportIdx") String reportIdx) {
        reportService.rejectReviewReport(reportIdx);
        return ResponseEntity.ok("신고가 반려되었습니다.");
    }

}
