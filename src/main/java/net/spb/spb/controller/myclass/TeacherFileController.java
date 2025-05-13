package net.spb.spb.controller.myclass;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.pagingsearch.TeacherFilePageDTO;
import net.spb.spb.dto.teacher.TeacherFileDTO;
import net.spb.spb.dto.teacher.TeacherFileResponseDTO;
import net.spb.spb.service.teacher.TeacherFileServiceIf;
import net.spb.spb.util.BreadcrumbUtil;
import net.spb.spb.util.FileUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/myclass/library")
public class TeacherFileController {

    private final FileUtil fileUtil;
    private final TeacherFileServiceIf teacherFileService;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의강의실", "url", "/myclass");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String list(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String teacherId = (String) session.getAttribute("memberId");

        List<TeacherFileResponseDTO> files = teacherFileService.getTeacherFileList(teacherId, pageDTO);

        model.addAttribute("fileList", files);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("자료실", "/myclass/library"));

        return "myclass/library/list";
    }

    @GetMapping("/regist")
    public String registGET(@ModelAttribute TeacherFilePageDTO pageDTO, Model model) {
        model.addAttribute("pageDTO", pageDTO);
        setBreadcrumb(model, Map.of("자료실", "/myclass/library"), Map.of("자료 등록", "/myclass/library/regist"));
        return "myclass/library/regist";
    }

    @PostMapping("/regist")
    public String registPOST(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @Valid @ModelAttribute TeacherFileDTO teacherFileDTO,
            @RequestParam(name = "file") MultipartFile file,
            BindingResult bindingResult,
            HttpServletRequest req,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("errorMessage", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/regist?" + pageDTO.getLinkUrl();
        }

        if (file == null || file.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 필수입니다. 파일을 첨부해주세요.");
            return "redirect:/myclass/library/regist?" + pageDTO.getLinkUrl();
        }

        if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
            redirectAttributes.addFlashAttribute("errorMessage", "각 파일은 10MB 이하만 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/regist?" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        teacherFileDTO.setTeacherFileMemberId(memberId);
        try {
            int fileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
            teacherFileDTO.setTeacherFileFileIdx(fileIdx);
            teacherFileService.createTeacherFile(teacherFileDTO);
        } catch (Exception e) {
            log.info(e.getMessage());
        }

        return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
    }

    @GetMapping("/modify")
    public String modifyGET(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherFileResponseDTO teacherFileDTO = teacherFileService.getTeacherFileByIdx(idx);

        if (!memberId.equals(teacherFileDTO.getTeacherFileMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
        }

        model.addAttribute("teacherFileDTO", teacherFileDTO);

        setBreadcrumb(model, Map.of("자료실", "/myclass/library"), Map.of("자료 수정", "/myclass/libraray/modify"));

        return "myclass/library/modify";
    }

    @PostMapping("/modify")
    public String modifyPOST(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @Valid @ModelAttribute TeacherFileDTO teacherFileDTO,
            @RequestParam(name = "file") MultipartFile file,
            @RequestParam(name = "deleteFile", defaultValue = "") String deleteFile,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        int idx = teacherFileDTO.getTeacherFileIdx();

        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("errorMessage", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/modify?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        if (file == null || file.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 필수입니다. 파일을 첨부해주세요.");
            return "redirect:/myclass/library/modify?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
            redirectAttributes.addFlashAttribute("errorMessage", "각 파일은 10MB 이하만 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/modify?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        if (!memberId.equals(teacherFileDTO.getTeacherFileMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
        }

        try {
            // 파일 등록
            int newFileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
            teacherFileDTO.setTeacherFileFileIdx(newFileIdx);
            teacherFileService.createTeacherFile(teacherFileDTO);

            // 파일 삭제
            String orgFileName = deleteFile.substring(deleteFile.indexOf("|") + 1);
            int orgFileIdx = Integer.parseInt(deleteFile.substring(0, deleteFile.indexOf("|")));
            fileUtil.deleteFile(orgFileName);
            teacherFileService.deleteTeacherFileByIdx(orgFileIdx);
        } catch (Exception e) {
            log.info(e.getMessage());
        }

        return "redirect:/teacher/personal/library/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
    }

    @PostMapping("/delete")
    public String delete(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @RequestParam("teacherFileIdx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        TeacherFileResponseDTO teacherFileDTO = teacherFileService.getTeacherFileByIdx(idx);
        if (!memberId.equals(teacherFileDTO.getTeacherFileMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "삭제 권한이 없습니다.");
            return "redirect:/teacher/personal/library/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        teacherFileService.deleteTeacherFileByIdx(idx);

        return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
    }

    @PostMapping("/delete-multiple")
    public String deleteMultiple(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @RequestParam("fileIdxs") List<Integer> fileIdxs,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        for (int idx : fileIdxs) {
            TeacherFileResponseDTO file = teacherFileService.getTeacherFileByIdx(idx);
            if (file == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "요청한 자료를 찾을 수 없습니다.");
                return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
            }
            if (!memberId.equals(file.getTeacherFileMemberId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "삭제 권한이 없습니다.");
                return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
            }

            try {
                fileUtil.deleteFile(file.getFileDTO().getFileName());
                teacherFileService.deleteTeacherFileByIdx(idx);
            } catch (Exception e) {
                log.info(e.getMessage());
            }
        }

        return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
    }
}
