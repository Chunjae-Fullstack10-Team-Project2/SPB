package net.spb.spb.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.MemberPageDTO;
import net.spb.spb.dto.pagingsearch.TeacherPageDTO;
import net.spb.spb.service.AdminService;
import net.spb.spb.service.member.MemberServiceIf;
import net.spb.spb.service.teacher.TeacherServiceIf;
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
@RequestMapping("/admin/teacher")
public class AdminTeacherController extends AdminBaseController {

    private final MemberServiceIf memberService;
    private final TeacherServiceIf teacherService;
    private final AdminService adminService;
    private final FileUtil fileUtil;

    @GetMapping("/manage")
    public String teacherManage(@ModelAttribute TeacherPageDTO pageDTO,
                                Model model,
                                HttpServletRequest req) {
        String baseURL = req.getRequestURI();

        // 1. 등록된 선생님 목록 (teacher1)
        pageDTO.setLinkUrl(NewPagingUtil.buildLinkUrl(baseURL, pageDTO));
        int totalCount = adminService.selectTeacherWithTeacherProfileCount(pageDTO);
        List<MemberDTO> teacherWithProfile = adminService.selectTeacherWithTeacherProfile(pageDTO);
        pageDTO.setTotal_count(totalCount);
        String paging1 = NewPagingUtil.pagingArea(pageDTO);

        // 2. 등록 요청 선생님 목록 (teacher2)
        TeacherPageDTO requestPageDTO = new TeacherPageDTO();
        requestPageDTO.setPage_no(pageDTO.getPage_no());
        requestPageDTO.setPage_size(pageDTO.getPage_size());
        requestPageDTO.setLinkUrl(NewPagingUtil.buildLinkUrl(baseURL, requestPageDTO));
        requestPageDTO.setSearch_word(pageDTO.getSearch_word());

        int requestTotalCount = adminService.selectTeacherWithoutTeacherProfileCount(requestPageDTO);
        List<MemberDTO> teacherWithoutProfile = adminService.selectTeacherWithoutTeacherProfile(requestPageDTO);
        requestPageDTO.setTotal_count(requestTotalCount);
        String paging2 = NewPagingUtil.pagingArea(requestPageDTO);

        // model attribute 설정
        model.addAttribute("teacher1", teacherWithProfile);
        model.addAttribute("teacher2", teacherWithoutProfile);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("requestTotalCount", requestTotalCount);
        model.addAttribute("paging1", paging1);
        model.addAttribute("paging2", paging2);
        model.addAttribute("search", pageDTO);

        setBreadcrumb(model, Map.of("선생님 관리", ""));

        return "admin/teacher/teacher_manage";
    }

    @GetMapping("/regist")
    public String teacherRegist(@RequestParam(name = "memberId", defaultValue = "") String memberId,
                                Model model,
                                RedirectAttributes redirectAttributes,
                                HttpSession session) {

        if (memberId.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "회원 ID가 누락되었습니다.");
            return "redirect:/admin/teacher/manage";
        }

        MemberDTO memberDTO = memberService.getMemberById(memberId);
        if (memberDTO == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않는 회원입니다.");
            return "redirect:/admin/teacher/manage";
        }

        if(adminService.existsByTeacherId(memberDTO.getMemberId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "이미 등록된 선생님입니다.");
            return "redirect:/admin/teacher/manage";
        }

        session.setAttribute("registTeacherName", memberDTO.getMemberName());
        session.setAttribute("registTeacherId", memberDTO.getMemberId());

        model.addAttribute("memberDTO", memberDTO);
        setBreadcrumb(model,
                Map.of("선생님 목록", "/admin/teacher/list"),
                Map.of("선생님 등록", "")
        );
        return "admin/teacher/regist";
    }

    @PostMapping("/regist")
    public String teacherRegistPost(@RequestParam(name = "file1") MultipartFile file,
                                    @Valid @ModelAttribute TeacherDTO teacherDTO,
                                    BindingResult bindingResult,
                                    RedirectAttributes redirectAttributes,
                                    HttpSession session) {

        // 유효성 검사 시작
        String sessionTeacherId = (String)session.getAttribute("registTeacherId");
        String sessionTeacherName = (String)session.getAttribute("registTeacherName");

        if (bindingResult.hasErrors()) {
            List<String> errorMessages = bindingResult.getFieldErrors().stream()
                    .map(FieldError::getDefaultMessage)
                    .collect(Collectors.toList());
            redirectAttributes.addFlashAttribute("errorMessages", errorMessages);
            redirectAttributes.addFlashAttribute("teacherDTO", teacherDTO);
            return "redirect:/admin/teacher/regist?memberId="+sessionTeacherId;
        }

        if (!sessionTeacherId.equalsIgnoreCase(teacherDTO.getTeacherId()) || !sessionTeacherName.equalsIgnoreCase(teacherDTO.getTeacherName())) {
            redirectAttributes.addFlashAttribute("errorMessages", "선생님 등록 중에 오류가 발생했습니다.");
            redirectAttributes.addFlashAttribute("teacherDTO", teacherDTO);
            return "redirect:/admin/teacher/regist?memberId="+sessionTeacherId;
        }

        if (file != null && !file.isEmpty() && file.getSize() > (10 * 1024 * 1024)) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일은 10MB 이하만 업로드할 수 있습니다.");
            redirectAttributes.addFlashAttribute("teacherDTO", teacherDTO);
            return "redirect:/admin/teacher/regist?memberId="+sessionTeacherId;
        }
        // 유효성 종료

        teacherDTO.setTeacherId(sessionTeacherId);
        teacherDTO.setTeacherName(sessionTeacherName);

        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                teacherDTO.setTeacherProfileImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
        adminService.insertTeacher(teacherDTO);
        session.removeAttribute("registTeacherId");
        session.removeAttribute("registTeacherName");
        return "redirect:/admin/teacher/manage";
    }

    @GetMapping("/modify")
    public String teacherModify(@RequestParam(name = "teacherId", defaultValue = "") String teacherId,
                                Model model,
                                RedirectAttributes redirectAttributes,
                                HttpSession session) {
        if(teacherId.isBlank()||!adminService.existsByTeacherId(teacherId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않는 선생님입니다.");
            return "redirect:/admin/teacher/manage";
        }

        TeacherDTO teacherDTO = teacherService.selectTeacher(teacherId);
        session.setAttribute("modifyTeacherId", teacherDTO.getTeacherId());
        model.addAttribute("teacherDTO", teacherDTO);
        setBreadcrumb(model,
                Map.of("선생님 목록", "/admin/teacher/manage"),
                Map.of("선생님 수정", "")
        );
        return "admin/teacher/modify";
    }

    @PostMapping("/modify")
    public String teacherModifyPost(@RequestParam(name = "file1") MultipartFile file,
                                    @Valid @ModelAttribute TeacherDTO teacherDTO,
                                    BindingResult bindingResult,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        String sessionTeacherId = (String)session.getAttribute("modifyTeacherId");

        if (bindingResult.hasErrors()) {
            List<String> errorMessages = bindingResult.getFieldErrors().stream()
                    .map(FieldError::getDefaultMessage)
                    .collect(Collectors.toList());
            redirectAttributes.addFlashAttribute("errorMessages", errorMessages);
            redirectAttributes.addFlashAttribute("teacherDTO", teacherDTO);
            return "redirect:/admin/teacher/modify?teacherId="+sessionTeacherId;
        }

        try {
            if (file != null && !file.isEmpty()) {
                File savedFile = fileUtil.saveFile(file);
                if (!teacherDTO.getTeacherProfileImg().isBlank()) {
                    fileUtil.deleteOnlyFile(teacherDTO.getTeacherProfileImg());
                }
                teacherDTO.setTeacherProfileImg(savedFile.getName());
            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
        teacherDTO.setTeacherId(sessionTeacherId);
        adminService.modifyTeacherProfile(teacherDTO);
        session.removeAttribute("modifyTeacherId");
        return "redirect:/admin/teacher/manage";
    }

    @GetMapping("/search")
    public String teacherSearchPopup(@ModelAttribute MemberPageDTO memberPageDTO, Model model, HttpServletRequest req) {
        memberPageDTO.setSearch_member_grade("13");
        memberPageDTO.setPage_size(5);
        String baseUrl = req.getRequestURI();
        memberPageDTO.setLinkUrl(NewPagingUtil.buildLinkUrl(baseUrl, memberPageDTO));
        int total_count = adminService.getAllTeachersCount(memberPageDTO);
        memberPageDTO.setTotal_count(total_count);
        String paging = NewPagingUtil.pagingArea(memberPageDTO);
        List<MemberDTO> memberDTOs = adminService.getAllTeachers(memberPageDTO);
        model.addAttribute("teachers", memberDTOs);
        model.addAttribute("searchDTO", memberPageDTO);
        model.addAttribute("paging", paging);
        return "/admin/teacher/searchPopup";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> teacherDelete(@RequestParam("teacherId") String teacherId) {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = adminService.deleteTeacher(teacherId);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "선생님 삭제되었습니다.");
            result.put("redirect", "/admin/teacher/manage");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    @PostMapping("/restore")
    @ResponseBody
    public Map<String, Object> teacherRestore(@RequestParam("teacherId") String teacherId) {
        Map<String, Object> result = new HashMap<>();
        int rtnResult = adminService.restoreTeacher(teacherId);
        if (rtnResult > 0) {
            result.put("success", true);
            result.put("message", "선생님 정보가 복구되었습니다.");
            result.put("redirect", "/admin/teacher/manage");
        } else {
            result.put("success", false);
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

}
