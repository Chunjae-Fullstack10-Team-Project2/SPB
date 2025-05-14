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

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/myclass/library")
public class TeacherFileController {

    private final FileUtil fileUtil;
    private final TeacherFileServiceIf service;

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
        String memberId = (String) session.getAttribute("memberId");

        int totalCount = service.getTeacherFileTotalCount(memberId, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<TeacherFileResponseDTO> files = service.getTeacherFileList(memberId, pageDTO);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("fileList", files);
        model.addAttribute("pageDTO", pageDTO);

        setBreadcrumb(model, Map.of("자료실", "/myclass/library"));

        return "myclass/library/list";
    }

    @GetMapping("/view")
    public String view(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @RequestParam("idx") int idx,
            Model model
    ) {
        TeacherFileResponseDTO teacherFileDTO = service.getTeacherFileByIdx(idx);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("teacherFileDTO", teacherFileDTO);

        setBreadcrumb(model, Map.of("자료실", "/myclass/library"), Map.of("자료실 상세보기", "/myclass/library/view?idx=" + idx));

        return "myclass/library/view";
    }

    @GetMapping("/regist")
    public String registGET(@ModelAttribute TeacherFilePageDTO pageDTO, Model model) {
        model.addAttribute("pageDTO", pageDTO);
        setBreadcrumb(model, Map.of("자료실", "/myclass/library"), Map.of("자료실 등록", "/myclass/library/regist"));
        return "myclass/library/regist";
    }

    @PostMapping("/regist")
    public String registPOST(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @Valid @ModelAttribute TeacherFileDTO teacherFileDTO,
            @RequestParam(name = "file") MultipartFile file,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/regist?" + pageDTO.getLinkUrl();
        }

        if (file == null || file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "파일은 필수입니다. 파일을 첨부해주세요.");
            return "redirect:/myclass/library/regist?" + pageDTO.getLinkUrl();
        }

        if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
            redirectAttributes.addFlashAttribute("message", "각 파일은 10MB 이하만 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/regist?" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        teacherFileDTO.setTeacherFileMemberId(memberId);
        try {
            int fileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
            teacherFileDTO.setTeacherFileFileIdx(fileIdx);
            service.createTeacherFile(teacherFileDTO);
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

        TeacherFileResponseDTO teacherFileDTO = service.getTeacherFileByIdx(idx);

        if (teacherFileDTO == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 자료를 찾을 수 없습니다.");
            return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(teacherFileDTO.getTeacherFileMemberId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/myclass/library/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
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
            @RequestParam(name = "deleteFile") String deleteFile,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        int idx = teacherFileDTO.getTeacherFileIdx();

        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/modify?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
            redirectAttributes.addFlashAttribute("message", "각 파일은 10MB 이하만 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("teacherFileDTO", teacherFileDTO);
            return "redirect:/myclass/library/modify?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        if (!memberId.equals(teacherFileDTO.getTeacherFileMemberId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/myclass/library/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        try {
            if (file != null) {
                // 파일 등록
                int newFileIdx = fileUtil.uploadFile(file.getOriginalFilename(), file.getBytes());
                teacherFileDTO.setTeacherFileFileIdx(newFileIdx);

                // 파일 삭제
                fileUtil.deleteFile(deleteFile);
            }
            service.updateTeacherFile(teacherFileDTO);
        } catch (Exception e) {
            log.info(e.getMessage());
        }

        return "redirect:/myclass/library/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
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

        TeacherFileResponseDTO teacherFileDTO = service.getTeacherFileByIdx(idx);
        if (!memberId.equals(teacherFileDTO.getTeacherFileMemberId())) {
            redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
            return "redirect:/myclass/library/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        try {
            fileUtil.deleteFile(teacherFileDTO.getFileDTO().getFileName());
            service.deleteTeacherFileByIdx(idx);
        } catch (Exception e) {
            log.info(e.getMessage());
        }

        return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
    }

    @PostMapping("/delete-multiple")
    public String deleteMultiple(
            @ModelAttribute TeacherFilePageDTO pageDTO,
            @RequestParam("idxList") List<Integer> idxList,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        for (int idx : idxList) {
            TeacherFileResponseDTO file = service.getTeacherFileByIdx(idx);
            if (file == null) {
                redirectAttributes.addFlashAttribute("message", "요청한 자료를 찾을 수 없습니다.");
                return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
            }
            if (!memberId.equals(file.getTeacherFileMemberId())) {
                redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
                return "redirect:/myclass/library/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
            }

            try {
                fileUtil.deleteFile(file.getFileDTO().getFileName());
                service.deleteTeacherFileByIdx(idx);
            } catch (Exception e) {
                log.info(e.getMessage());
            }
        }

        return "redirect:/myclass/library?" + pageDTO.getLinkUrl();
    }
}
