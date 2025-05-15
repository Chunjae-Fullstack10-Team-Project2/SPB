package net.spb.spb.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.pagingsearch.ChapterPageDTO;
import net.spb.spb.service.AdminService;
import net.spb.spb.util.BreadcrumbUtil;
import net.spb.spb.util.FileUtil;
import net.spb.spb.util.NewPagingUtil;
import net.spb.spb.util.VideoUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminChapterController extends AdminBaseController {

    private final AdminService adminService;
    private final FileUtil fileUtil;

    private static final long MAX_FILE_SIZE_100 = 100 * 1024 * 1024;

    @GetMapping("/chapter/list")
    public void chapterList(@ModelAttribute ChapterPageDTO chapterPageDTO, Model model, HttpServletRequest req) {
        String baseUrl = req.getRequestURI();
        chapterPageDTO.setLinkUrl(NewPagingUtil.buildLinkUrl(baseUrl, chapterPageDTO));
        int totalCount = adminService.selectChapterCount(chapterPageDTO);
        String paging = NewPagingUtil.pagingArea(chapterPageDTO);
        List<ChapterDTO> chapters = adminService.selectChapterList(chapterPageDTO);
        model.addAttribute("chapters", chapters);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("searchDTO", chapterPageDTO);
        model.addAttribute("paging", paging);
        model.addAttribute("lectureIdx", chapterPageDTO.getLectureIdx());
        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강의 목록", "")
        );
    }

    @GetMapping("/chapter/regist")
    public void chapterRegist(@RequestParam(name = "lectureIdx", defaultValue = "0") int lectureIdx, Model model) {
        LectureDTO lectureDTO = adminService.selectLecture(lectureIdx);
        model.addAttribute("lectureIdx", lectureIdx);
        model.addAttribute("lectureDTO", lectureDTO);
        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강의 등록", "")
        );
    }

    @PostMapping("/chapter/regist")
    @ResponseBody
    public ResponseEntity<?> chapterRegistPOST(@RequestParam(name = "file1", required = true) MultipartFile file,
                                               @Valid @ModelAttribute ChapterDTO chapterDTO,
                                               BindingResult bindingResult) {
        if(bindingResult.hasErrors()) {
            String errorMessage = bindingResult.getFieldError().getDefaultMessage();
            log.error(errorMessage);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", errorMessage));
        }

        if(file==null || file.isEmpty())
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("message", "강의 영상은 필수입니다."));

        if(adminService.existsByLectureId(chapterDTO.getChapterLectureIdx()))
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("message", "존재하지 않는 강좌 번호입니다."));

        try {
            if (file != null && !file.isEmpty()) {
                if (file.getSize()>MAX_FILE_SIZE_100) {
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
    public ResponseEntity<?> chapterModifyPOST(@RequestParam(name = "file1") MultipartFile file,
                                               @Valid @ModelAttribute ChapterDTO chapterDTO,
                                               BindingResult bindingResult) {
        if(bindingResult.hasErrors()) {
            String errorMessage = bindingResult.getFieldError().getDefaultMessage();
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorMessage);
        }

        if(adminService.existsByLectureId(chapterDTO.getChapterLectureIdx()))
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("message", "강좌 번호가 존재하지 않습니다."));

        try {
            if (file != null && !file.isEmpty()) {
                if (file.getSize() > MAX_FILE_SIZE_100) {
                    return ResponseEntity
                            .status(HttpStatus.PAYLOAD_TOO_LARGE)
                            .body(Map.of("message", "파일 크기가 100MB를 초과했습니다."));
                }
                File savedFile = fileUtil.saveFile(file);
                chapterDTO.setChapterVideo(savedFile.getName());
                chapterDTO.setChapterRuntime(VideoUtil.getVideoDuration(savedFile));
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        adminService.updateChapter(chapterDTO);
        return ResponseEntity.ok(Map.of("message", "강의 수정 성공"));
    }

    @PostMapping("/chapter/delete")
    @ResponseBody
    public Map<String, Object> chapterDelete(@RequestParam("chapterIdx") int chapterIdx) {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = adminService.deleteChapter(chapterIdx);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "강의가 삭제되었습니다.");
            result.put("redirect", "/admin/chapter/list");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    @PostMapping("/chapter/restore")
    @ResponseBody
    public Map<String, Object> chapterRestore(@RequestParam("chapterIdx") int chapterIdx) {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = adminService.restoreChapter(chapterIdx);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "강의가 복구되었습니다.");
            result.put("redirect", "/admin/chapter/list");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

}
