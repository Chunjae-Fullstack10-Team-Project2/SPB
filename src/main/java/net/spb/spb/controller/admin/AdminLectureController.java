package net.spb.spb.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
import net.spb.spb.service.AdminService;
import net.spb.spb.util.BreadcrumbUtil;
import net.spb.spb.util.FileUtil;
import net.spb.spb.util.NewPagingUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin/lecture")
public class AdminLectureController extends AdminBaseController {

    private final AdminService adminService;
    private final FileUtil fileUtil;

    private static final long MAX_FILE_SIZE_10 = 10 * 1024 * 1024;

    @GetMapping("/list")
    public void lectureList(@ModelAttribute LecturePageDTO lecturePageDTO, Model model) {
        List<LectureDTO> lectureDTOs = adminService.selectLectureList(lecturePageDTO);
        model.addAttribute("lectures", lectureDTOs);
        setBreadcrumb(model, Map.of("강좌 목록", ""));
    }

    @GetMapping("/regist")
    public void lectureRegist(Model model) {
        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강좌 등록", "")
        );
    }

    @PostMapping("/regist")
    public String lectureRegistPOST(@RequestParam(name = "file1") MultipartFile file,
                                    @Valid @ModelAttribute LectureDTO lectureDTO,
                                    BindingResult bindingResult,
                                    RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            List<String> errorMessages = bindingResult.getFieldErrors().stream()
                    .map(FieldError::getDefaultMessage)
                    .collect(Collectors.toList());
            redirectAttributes.addFlashAttribute("errorMessages", errorMessages);
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            log.error(errorMessages);
            return "redirect:/admin/lecture/regist";
        }

        if (lectureDTO.getLectureAmount() < 0 || lectureDTO.getLectureAmount() > 5000000) {
            redirectAttributes.addFlashAttribute("errorMessage", "강좌 가격을 최대 5,000,000원 이하로 입력하세요.");
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            return "redirect:/admin/lecture/regist";
        }

        if (lectureDTO.getLectureTeacherId().isBlank() || !adminService.existsByTeacherId(lectureDTO.getLectureTeacherId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "선생님 정보가 올바르지 않습니다.");
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            return "redirect:/admin/lecture/regist";
        }

        if (file != null && !file.isEmpty() && file.getSize() > MAX_FILE_SIZE_10) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 10MB 이하만 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            log.error("파일 크기 제한");
            return "redirect:/admin/lecture/regist";
        }

        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                lectureDTO.setLectureThumbnailImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        adminService.insertLecture(lectureDTO);
        return "redirect:/admin/lecture/list";
    }


    @GetMapping("/modify")
    public void lectureModify(@RequestParam("lectureIdx") int lectureIdx, Model model) {
        LectureDTO lectureDTO = adminService.selectLecture(lectureIdx);
        model.addAttribute("lectureDTO", lectureDTO);
        setBreadcrumb(model,
                Map.of("강좌 목록", "/admin/lecture/list"),
                Map.of("강좌 수정", "")
        );
    }

    @PostMapping("/modify")
    public String lectureModifyPOST(@RequestParam(name = "file1") MultipartFile file,
                                    @RequestParam("lectureIdx") int lectureIdx,
                                    @Valid @ModelAttribute LectureDTO lectureDTO,
                                    BindingResult bindingResult,
                                    RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            List<String> errorMessages = bindingResult.getFieldErrors().stream()
                    .map(FieldError::getDefaultMessage)
                    .collect(Collectors.toList());
            redirectAttributes.addFlashAttribute("errorMessages", errorMessages);
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            log.error(errorMessages);
            return "redirect:/admin/lecture/modify?lectureIdx="+lectureIdx;
        }

        if (lectureDTO.getLectureAmount() < 0 || lectureDTO.getLectureAmount() > 5000000) {
            redirectAttributes.addFlashAttribute("errorMessage", "강좌 가격을 최대 5,000,000원 이하로 입력하세요.");
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            return "redirect:/admin/lecture/regist";
        }

        if (lectureDTO.getLectureTeacherId().isBlank() || !adminService.existsByTeacherId(lectureDTO.getLectureTeacherId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "선생님 정보가 올바르지 않습니다.");
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            return "redirect:/admin/lecture/modify?lectureIdx="+lectureIdx;
        }

        if (file != null && !file.isEmpty() && file.getSize() > MAX_FILE_SIZE_10) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 10MB 이하만 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("lectureDTO", lectureDTO);
            log.error("파일 크기 제한");
            return "redirect:/admin/lecture/modify?lectureIdx="+lectureIdx;
        }

        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                lectureDTO.setLectureThumbnailImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        adminService.updateLecture(lectureDTO);
        return "redirect:/admin/lecture/list";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> lectureDelete(@RequestParam("lectureIdx") int lectureIdx) {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = adminService.deleteLecture(lectureIdx);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "강좌가 삭제되었습니다.");
            result.put("redirect", "/admin/lecture/list");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    @PostMapping("/restore")
    @ResponseBody
    public Map<String, Object> lectureRestore(@RequestParam("lectureIdx") int lectureIdx) {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = adminService.restoreLecture(lectureIdx);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "강좌가 복구되었습니다.");
            result.put("redirect", "/admin/lecture/list");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    @GetMapping("/search")
    public String lectureSearchPopup(@ModelAttribute LecturePageDTO lecturePageDTO, HttpServletRequest req, Model model) {
        String baseUrl = req.getRequestURI();
        lecturePageDTO.setLinkUrl(NewPagingUtil.buildLinkUrl(baseUrl, lecturePageDTO));
        int total_count = adminService.selectLectureCount(lecturePageDTO);
        lecturePageDTO.setTotal_count(total_count);
        String paging = NewPagingUtil.pagingArea(lecturePageDTO);
        List<LectureDTO> lectureDTOs = adminService.selectLectureList(lecturePageDTO);
        model.addAttribute("lectures", lectureDTOs);
        model.addAttribute("searchDTO", lecturePageDTO);
        model.addAttribute("paging", paging);
        return "/admin/lecture/searchPopup";
    }

}
