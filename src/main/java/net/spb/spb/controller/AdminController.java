package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.*;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.service.AdminService;
import net.spb.spb.service.ReportService;
import net.spb.spb.service.member.MemberServiceIf;
import net.spb.spb.util.FileUtil;
import net.spb.spb.util.PagingUtil;
import net.spb.spb.util.VideoUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final MemberServiceIf memberService;
    private final ReportService reportService;
    private final AdminService adminService;
    private final FileUtil fileUtil;

    private static final long MAX_FILE_SIZE = 500 * 1024 * 1024;

    @GetMapping("/member/list")
    public void memberList(@ModelAttribute MemberPageDTO memberPageDTO, Model model, HttpServletRequest req) {
        String baseUrl = req.getRequestURI();
        memberPageDTO.setLinkUrl(PagingUtil.buildLinkUrl(baseUrl, memberPageDTO));
        if (memberPageDTO.getSearch_member_grade() != null && memberPageDTO.getSearch_member_grade().trim().equals("")) {
            memberPageDTO.setSearch_member_grade(null);
        }
        int total_count = memberService.getMemberCount(memberPageDTO);
        memberPageDTO.setTotal_count(total_count);
        String paging = PagingUtil.pagingArea(memberPageDTO);
        List<MemberDTO> memberDTOs = memberService.getMembers(memberPageDTO);
        model.addAttribute("searchDTO", memberPageDTO);
        model.addAttribute("list", memberDTOs);
        model.addAttribute("memberTotalCount", total_count);
        model.addAttribute("paging", paging);
    }

    @PostMapping("/member/update")
    public String memberModify(@ModelAttribute MemberDTO memberDTO) {
        memberService.updateMemberByAdmin(memberDTO);
        return "/admin/member/update-success";
    }

    @PostMapping("/member/state")
    public String memberModifyState(@ModelAttribute MemberPageDTO memberPageDTO, @ModelAttribute MemberDTO memberDTO) {
        memberService.updateMemberState(memberDTO);
        String query = memberPageDTO.toQueryString();
        return "redirect:/admin/member/list?" + query;
    }

    @GetMapping("/member/view")
    public void memberView(@RequestParam("memberId") String memberId, Model model) {
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);
    }

    @GetMapping("/report/list")
    public String reportList() {
        return "admin/report/list";
    }

    @GetMapping("/report/list/board")
    public String boardReportList(@ModelAttribute SearchDTO searchDTO,
                                  @ModelAttribute PageRequestDTO pageRequestDTO,
                                  Model model) {
        List<PostReportDTO> boardReportList = reportService.listBoardReport(searchDTO, pageRequestDTO);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageResponseDTO.<PostReportDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(reportService.boardReportTotalCount(searchDTO))
                .dtoList(boardReportList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("boardReportList", boardReportList);
        model.addAttribute("searchDTO", searchDTO);
        return "admin/report/list";
    }

    @GetMapping("/report/list/review")
    public String reviewReportList(@ModelAttribute SearchDTO searchDTO,
                                   @ModelAttribute PageRequestDTO pageRequestDTO,
                                   Model model) {
        List<PostReportDTO> reviewReportList = reportService.listReviewReport(searchDTO, pageRequestDTO);
        PageResponseDTO<PostReportDTO> pageResponseDTO = PageResponseDTO.<PostReportDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .totalCount(reportService.reviewReportTotalCount(searchDTO))
                .dtoList(reviewReportList)
                .build();

        model.addAttribute("responseDTO", pageResponseDTO);
        model.addAttribute("reviewReportList", reviewReportList);
        model.addAttribute("searchDTO", searchDTO);
        return "admin/report/list";
    }

    @GetMapping("/teacher/regist")
    public void teacherRegist(@RequestParam(name = "memberId", defaultValue = "") String memberId, Model model) {
        MemberDTO memberDTO = null;
        if (!memberId.equals("")) {
            memberDTO = memberService.getMemberById(memberId);
        }
        model.addAttribute("memberDTO", memberDTO);
    }

    @PostMapping("/teacher/regist")
    public void teacherRegistPost(@RequestParam(name = "file1") MultipartFile file, @ModelAttribute TeacherDTO teacherDTO) {
        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                teacherDTO.setTeacherProfileImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
        adminService.insertTeacher(teacherDTO);
    }

    @GetMapping("/teacher/searchPopup")
    public void teacherSearchPopup(@ModelAttribute MemberPageDTO memberPageDTO, Model model, HttpServletRequest req) {
        memberPageDTO.setSearch_member_grade("13");
        String baseUrl = req.getRequestURI();
        memberPageDTO.setLinkUrl(PagingUtil.buildLinkUrl(baseUrl, memberPageDTO));
        int total_count = memberService.getMemberCount(memberPageDTO);
        memberPageDTO.setTotal_count(total_count);
        String paging = PagingUtil.pagingArea(memberPageDTO);
        List<MemberDTO> memberDTOs = memberService.getMembers(memberPageDTO);
        model.addAttribute("teachers", memberDTOs);
        model.addAttribute("searchDTO", memberPageDTO);
        model.addAttribute("paging", paging);
    }

    @GetMapping("/lecture/regist")
    public void lectureRegist() {
    }

    @PostMapping("/lecture/regist")
    public void lectureRegistPOST(@RequestParam(name = "file1") MultipartFile file, @ModelAttribute LectureDTO lectureDTO) {
        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                lectureDTO.setLectureThumbnailImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
        adminService.insertLecture(lectureDTO);
    }

    @GetMapping("/lecture/list")
    public void lectureList(@ModelAttribute LecturePageDTO lecturePageDTO, Model model) {
        List<LectureDTO> lectureDTOs = adminService.selectLecture(lecturePageDTO);
        model.addAttribute("lectures", lectureDTOs);
    }

    @GetMapping("/lecture/searchPopup")
    public void lectureSearchPopup(@ModelAttribute LecturePageDTO lecturePageDTO, HttpServletRequest req, Model model) {
        String baseUrl = req.getRequestURI();
        lecturePageDTO.setLinkUrl(PagingUtil.buildLinkUrl(baseUrl, lecturePageDTO));
        int total_count = adminService.selectLectureCount(lecturePageDTO);
        lecturePageDTO.setTotal_count(total_count);
        String paging = PagingUtil.pagingArea(lecturePageDTO);
        List<LectureDTO> lectureDTOs = adminService.selectLecture(lecturePageDTO);
        model.addAttribute("lectures", lectureDTOs);
        model.addAttribute("searchDTO", lecturePageDTO);
        model.addAttribute("paging", paging);
    }

    @GetMapping("/lecture/chapter/regist")
    public void lectureChapterRegist(@RequestParam(name = "lectureIdx", defaultValue = "0") int lectureIdx, Model model) {
        model.addAttribute("lectureIdx", lectureIdx);
    }

    @PostMapping("/lecture/chapter/regist")
    @ResponseBody
    public ResponseEntity<?> lectureChapterRegistPOST(@RequestParam(name = "file1", required = true) MultipartFile file,
                                                      @ModelAttribute ChapterDTO chapterDTO) {
        try {
            if (file != null && !file.isEmpty()) {
                if (file.getSize() > MAX_FILE_SIZE) {
                    return ResponseEntity
                            .status(HttpStatus.PAYLOAD_TOO_LARGE)
                            .body(Map.of("message", "파일 크기가 100MB를 초과했습니다."));
                }
                File savedFile = fileUtil.saveFile(file);
                chapterDTO.setChapterVideo(savedFile.getName());
                chapterDTO.setChapterRuntime(VideoUtil.getVideoDuration(savedFile));
                adminService.insertChapter(chapterDTO);
                return ResponseEntity.ok(Map.of("message", "강의 등록 완료"));
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("message", "강의 등록 중 오류가 발생했습니다."));
    }
}
