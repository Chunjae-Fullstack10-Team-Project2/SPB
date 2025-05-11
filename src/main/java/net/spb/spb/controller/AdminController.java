package net.spb.spb.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.*;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.service.AdminService;
import net.spb.spb.service.ReportService;
import net.spb.spb.service.teacher.TeacherServiceIf;
import net.spb.spb.service.member.MemberServiceIf;
import net.spb.spb.util.*;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final MemberServiceIf memberService;
    private final ReportService reportService;
    private final AdminService adminService;
    private final TeacherServiceIf teacherService;
    private final FileUtil fileUtil;

    private static final long MAX_FILE_SIZE = 500 * 1024 * 1024;
    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "관리 페이지", "url", "/admin");

    @GetMapping({"","/"})
    public String adminMain(Model model) {
        setBreadcrumb(model, Map.of("관리 페이지", ""));
        return "admin/main";
    }

    @GetMapping("/member/list")
    public void memberList(@ModelAttribute MemberPageDTO memberPageDTO, Model model, HttpServletRequest req) {
        String baseUrl = req.getRequestURI();
        memberPageDTO.setLinkUrl(PagingUtil.buildLinkUrl(baseUrl, memberPageDTO));
        if (memberPageDTO.getSearch_member_grade() != null && memberPageDTO.getSearch_member_grade().trim().equals("")) {
            memberPageDTO.setSearch_member_grade(null);
        }
        int total_count = memberService.getMemberCount(memberPageDTO);
        memberPageDTO.setTotal_count(total_count);
        String paging = NewPagingUtil.pagingArea(memberPageDTO);
        List<MemberDTO> memberDTOs = memberService.getMembers(memberPageDTO);
        model.addAttribute("searchDTO", memberPageDTO);
        model.addAttribute("list", memberDTOs);
        model.addAttribute("memberTotalCount", total_count);
        model.addAttribute("paging", paging);
        setBreadcrumb(model, Map.of("회원 목록", ""));
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
    public String memberView(@RequestParam("memberId") String memberId, Model model) {
        MemberDTO memberDTO = memberService.getMemberById(memberId);
        model.addAttribute("memberDTO", memberDTO);
        return "/admin/member/memberPopup";
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

    @GetMapping("/teacher/list")
    public void teacherList(@ModelAttribute MemberPageDTO memberPageDTO, Model model, HttpServletRequest req) {
        List<MemberDTO> teacherWithTeacherProfile = adminService.selectTeacherWithTeacherProfile();
        List<MemberDTO> teacherWithoutTeacherProfile = adminService.selectTeacherWithoutTeacherProfile();
        model.addAttribute("teacher1", teacherWithTeacherProfile);
        model.addAttribute("teacher2", teacherWithoutTeacherProfile);
        setBreadcrumb(model, Map.of("선생님 목록", ""));
    }

    @GetMapping("/teacher/regist")
    public void teacherRegist(@RequestParam(name = "memberId", defaultValue = "") String memberId, Model model) {
        MemberDTO memberDTO = null;
        if (!memberId.equals("")) {
            memberDTO = memberService.getMemberById(memberId);
        }
        model.addAttribute("memberDTO", memberDTO);
        setBreadcrumb(model,
                Map.of("선생님 목록", "/admin/teacher/list"),
                Map.of("선생님 등록", "")
        );
    }

    @PostMapping("/teacher/regist")
    public String teacherRegistPost(@RequestParam(name = "file1") MultipartFile file, @ModelAttribute TeacherDTO teacherDTO) {
        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                teacherDTO.setTeacherProfileImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
        adminService.insertTeacher(teacherDTO);
        return "redirect:/admin/teacher/list";
    }

    @GetMapping("/teacher/modify")
    public void teacherModify(@RequestParam(name = "teacherId", defaultValue = "") String teacherId, Model model) {
        TeacherDTO teacherDTO = teacherService.selectTeacher(teacherId);
        model.addAttribute("teacherDTO", teacherDTO);
        setBreadcrumb(model,
                Map.of("선생님 목록", "/admin/teacher/list"),
                Map.of("선생님 등록", "")
        );
    }

    @PostMapping("/teacher/modify")
    public String teacherModifyPost(@RequestParam(name = "file1") MultipartFile file, @ModelAttribute TeacherDTO teacherDTO) {
        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                teacherDTO.setTeacherProfileImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
        adminService.modifyTeacherProfile(teacherDTO);
        return "redirect:/admin/teacher/list";
    }

    @GetMapping("/teacher/search")
    public String teacherSearchPopup(@ModelAttribute MemberPageDTO memberPageDTO, Model model, HttpServletRequest req) {
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
        return "/admin/teacher/searchPopup";
    }

    @GetMapping("/lecture/list")
    public void lectureList(@ModelAttribute LecturePageDTO lecturePageDTO, Model model) {
        List<LectureDTO> lectureDTOs = adminService.selectLectureList(lecturePageDTO);
        model.addAttribute("lectures", lectureDTOs);
        setBreadcrumb(model, Map.of("강좌 목록", ""));
    }

    @GetMapping("/lecture/regist")
    public void lectureRegist(Model model) {
        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강좌 등록", "")
        );
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


    @GetMapping("/lecture/modify")
    public void lectureModify(@RequestParam("lectureIdx") int lectureIdx, Model model) {
        LectureDTO lectureDTO = adminService.selectLecture(lectureIdx);
        model.addAttribute("lectureDTO", lectureDTO);
        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강좌 수정", "")
        );
    }

    @PostMapping("/lecture/modify")
    public void lectureModifyPOST(@RequestParam(name = "file1") MultipartFile file, @ModelAttribute LectureDTO lectureDTO) {
        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                lectureDTO.setLectureThumbnailImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
        adminService.updateLecture(lectureDTO);
    }

    @PostMapping("/lecture/delete")
    @ResponseBody
    public Map<String, Object> lectureDeletePOST(@ModelAttribute LectureDTO lectureDTO) {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = adminService.deleteLecture(lectureDTO);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "게시글이 삭제되었습니다.");
            result.put("redirect", "/admin/lecture/list");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    @GetMapping("/lecture/search")
    public String lectureSearchPopup(@ModelAttribute LecturePageDTO lecturePageDTO, HttpServletRequest req, Model model) {
        String baseUrl = req.getRequestURI();
        lecturePageDTO.setLinkUrl(PagingUtil.buildLinkUrl(baseUrl, lecturePageDTO));
        int total_count = adminService.selectLectureCount(lecturePageDTO);
        lecturePageDTO.setTotal_count(total_count);
        String paging = PagingUtil.pagingArea(lecturePageDTO);
        List<LectureDTO> lectureDTOs = adminService.selectLectureList(lecturePageDTO);
        model.addAttribute("lectures", lectureDTOs);
        model.addAttribute("searchDTO", lecturePageDTO);
        model.addAttribute("paging", paging);
        return "/admin/lecture/searchPopup";
    }

    @GetMapping("/chapter/list")
    public void chapterList(@ModelAttribute ChapterPageDTO chapterPageDTO, Model model) {
        List<ChapterDTO> chapters = adminService.selectChapterList(chapterPageDTO);
        model.addAttribute("chapters", chapters);
        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강의 목록", "")
        );
    }

    @GetMapping("/chapter/regist")
    public void chapterRegist(@RequestParam(name = "lectureIdx", defaultValue = "0") int lectureIdx, Model model) {
        model.addAttribute("lectureIdx", lectureIdx);

        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강의 등록", "")
        );
    }

    @PostMapping("/chapter/regist")
    @ResponseBody
    public ResponseEntity<?> chapterRegistPOST(@RequestParam(name = "file1", required = true) MultipartFile file,
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

    @GetMapping("/chapter/modify")
    public void chapterModify(@RequestParam("chapterIdx") int chapterIdx, Model model) {
        ChapterDTO chapterDTO = adminService.selectChapter(chapterIdx);
        model.addAttribute("chapterDTO", chapterDTO);
        setBreadcrumb(model,
                Map.of("강의 목록", "/admin/chapter/list"),
                Map.of("강의 수정", "")
        );
    }

    @PostMapping("/chapter/modify")
    @ResponseBody
    public ResponseEntity<?> chapterModifyPOST(@RequestParam(name = "file1", required = true) MultipartFile file,
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
                adminService.updateChapter(chapterDTO);
                return ResponseEntity.ok(Map.of("message", "강의 등록 완료"));
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("message", "강의 등록 중 오류가 발생했습니다."));
    }

    @GetMapping("/sales/info")
    public String salesInfo(@ModelAttribute SearchDTO searchDTO,
                            @ModelAttribute PageRequestDTO pageRequestDTO,
                            Model model) {

        // 월별/강좌별 매출은 기존대로
        List<Map<String, Object>> monthlySales = adminService.getMonthlySales();
        List<Map<String, Object>> lectureSales = adminService.getLectureSales();

        // 개별 거래 내역 (조건 기반)
        List<OrderDTO> detailList = adminService.getSalesDetailList(searchDTO, pageRequestDTO);
        int count = adminService.getSalesDetailCount(searchDTO);

        PageResponseDTO<OrderDTO> pageResponseDTO = PageResponseDTO.<OrderDTO>withAll()
                .dtoList(detailList)
                .totalCount(count)
                .pageRequestDTO(pageRequestDTO)
                .build();

        model.addAttribute("monthlySales", monthlySales);
        model.addAttribute("lectureSales", lectureSales);
        model.addAttribute("searchDTO", searchDTO);
        model.addAttribute("responseDTO", pageResponseDTO);

        return "/admin/sales/dashboard";
    }


    @GetMapping("/sales/monthly")
    @ResponseBody
    public List<Map<String, Object>> getMonthlySales(
            @RequestParam("timeType") String timeType,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate
    ) {
        return adminService.getMonthlySales(timeType, startDate, endDate);
    }

    @GetMapping("/sales/lecture")
    @ResponseBody
    public List<Map<String, Object>> getLectureSales(
            @RequestParam("timeType") String timeType,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate) {
        return adminService.getLectureSales(timeType, startDate, endDate);
    }

    @GetMapping("/sales/detail")
    @ResponseBody
    public PageResponseDTO<OrderDTO> salesDetailList(
            @RequestParam(value = "searchWord", required = false) String searchWord,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "pageNo", defaultValue = "1") int pageNo,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
            @RequestParam(value = "sortColumn", required = false) String sortColumn,
            @RequestParam(value = "sortOrder", required = false) String sortOrder
    ) {
        SearchDTO searchDTO = new SearchDTO();
        searchDTO.setSearchWord(searchWord);
        searchDTO.setSearchType(searchType);
        searchDTO.setSortColumn(sortColumn);
        searchDTO.setSortOrder(sortOrder);
        searchDTO.setStartDate(startDate);
        searchDTO.setEndDate(endDate);

        PageRequestDTO pageRequestDTO = PageRequestDTO.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .build();

        List<OrderDTO> detailList = adminService.getSalesDetailList(searchDTO, pageRequestDTO);
        int count = adminService.getSalesDetailCount(searchDTO);

        return PageResponseDTO.<OrderDTO>withAll()
                .dtoList(detailList)
                .totalCount(count)
                .pageRequestDTO(pageRequestDTO)
                .build();
    }

    @GetMapping("/sales/export")
    public void exportSalesToExcel(
            @RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate", required = false) String endDate,
            HttpServletResponse response
    ) throws IOException {

        Map<String, Object> param = new HashMap<>();
        param.put("searchType", searchType);
        param.put("searchWord", searchWord);
        param.put("startDate", startDate);
        param.put("endDate", endDate);

        List<OrderDTO> list = adminService.getSalesListForExport(param);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("매출 내역");

        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("주문번호");
        header.createCell(1).setCellValue("회원 ID");
        header.createCell(2).setCellValue("강좌명");
        header.createCell(3).setCellValue("금액");
        header.createCell(4).setCellValue("주문일");

        int rowNum = 1;
        for (OrderDTO row : list) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(row.getOrderIdx());
            r.createCell(1).setCellValue(row.getOrderMemberId());
            r.createCell(2).setCellValue(row.getLectureTitle());
            r.createCell(3).setCellValue(row.getOrderAmount());
            r.createCell(4).setCellValue(row.getOrderCreatedAt().toString());
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"sales.xlsx\"");

        workbook.write(response.getOutputStream());
        workbook.close();
    }


    // 브레드크럼
    private void setBreadcrumb(Model model, Map<String, String>... pagePairs) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> page : pagePairs) {
            pages.putAll(page);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }
}

