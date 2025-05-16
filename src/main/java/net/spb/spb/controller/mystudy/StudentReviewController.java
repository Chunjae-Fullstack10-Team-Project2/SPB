package net.spb.spb.controller.mystudy;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.lecture.*;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;
import net.spb.spb.service.lecture.LectureReviewServiceIf;
import net.spb.spb.service.lecture.LectureServiceIf;
import net.spb.spb.service.lecture.StudentLectureServiceIf;
import net.spb.spb.util.BreadcrumbUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/mystudy/review")
public class StudentReviewController {

    private final LectureReviewServiceIf lectureReviewService;
    private final LectureServiceIf lectureService;
    private final StudentLectureServiceIf studentLectureService;

    private static final Map<String, String> ROOT_BREADCRUMB = Map.of("name", "나의학습방", "url", "/mystudy");

    private void setBreadcrumb(Model model, Map<String, String> ... page) {
        LinkedHashMap<String, String> pages = new LinkedHashMap<>();
        for (Map<String, String> p : page) {
            pages.putAll(p);
        }
        BreadcrumbUtil.addBreadcrumb(model, pages, ROOT_BREADCRUMB);
    }

    @GetMapping("")
    public String list(@ModelAttribute LectureReviewPageDTO pageDTO, Model model, HttpServletRequest req) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureReviewListRequestDTO reqDTO = LectureReviewListRequestDTO.builder()
                .where_column("lectureReviewMemberId")
                .where_value(memberId)
                .build();

        List<LectureReviewResponseDTO> reviews = lectureReviewService.getLectureReviewList(reqDTO, pageDTO);

        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("reviewList", reviews);

        setBreadcrumb(model, Map.of("수강후기", "/mystudy/review"));

        return "mystudy/review/list";
    }

    @GetMapping("/regist")
    public String registGET(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        List<LectureDTO> lectures = studentLectureService.getStudentLectures(memberId);
        
        model.addAttribute("lectureList", lectures);
        model.addAttribute("pageDTO", pageDTO);
        setBreadcrumb(model, Map.of("수강후기", "/mystudy/review"), Map.of("수강후기 등록", "/mystudy/review/regist"));

        return "mystudy/review/regist";
    }

    @PostMapping("/regist")
    public String registPOST(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            @Valid @ModelAttribute LectureReviewDTO lectureReviewDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        if(bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("review", lectureReviewDTO);
            return "redirect:/mystudy/review/regist?" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        int lectureIdx = lectureReviewDTO.getLectureReviewRefIdx();
        // 해당 강좌가 없을 경우
        if (lectureService.getLectureByIdx(lectureIdx) == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 강좌를 찾을 수 없습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }
        // 해당 강좌를 수강하지 않는 경우
        if (!studentLectureService.isLectureRegisteredByMemberId(memberId, lectureIdx)) {
            redirectAttributes.addFlashAttribute("message", "수강 중인 강좌만 후기를 등록할 수 있습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }
        // 이미 후기를 작성한 경우
        if (lectureReviewService.hasLectureReview(memberId, lectureIdx)) {
            redirectAttributes.addFlashAttribute("message", "수강 후기는 한 번만 작성할 수 있습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }

        lectureReviewDTO.setLectureReviewMemberId(memberId);
        lectureReviewService.createLectureReview(memberId, lectureReviewDTO);

        return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
    }

    @GetMapping("/view")
    public String view(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureReviewResponseDTO review = lectureReviewService.getLectureReviewByIdx(idx);

        if (review == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 수강후기를 찾을 수 없습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(review.getLectureReviewMemberId())) {
            redirectAttributes.addFlashAttribute("message", "조회 권한이 없습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }

        model.addAttribute("review", review);
        model.addAttribute("pageDTO", pageDTO);
        setBreadcrumb(model, Map.of("수강후기", "/mystudy/review"), Map.of("수강후기 상세보기", "/mystudy/review/view?idx=" + idx));

        return "mystudy/review/view";
    }
    
    @GetMapping("/modify")
    public String modifyGET(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req,
            Model model
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureReviewResponseDTO review = lectureReviewService.getLectureReviewByIdx(idx);
        if (review == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 수강후기를 찾을 수 없습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(review.getLectureReviewMemberId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/mystudy/review/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        List<LectureDTO> lectures = studentLectureService.getStudentLectures(memberId);
        
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("lectureList", lectures);
        model.addAttribute("review", review);

        setBreadcrumb(model, Map.of("수강후기", "/mystudy/review"), Map.of("수강후기 수정", "/mystudy/review/modify"));
        return "review/modify";
    }

    @PostMapping("/modify")
    public String modifyPost(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            @Valid @ModelAttribute LectureReviewDTO lectureReviewDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        int idx = lectureReviewDTO.getLectureReviewRefIdx();

        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("message", "잘못된 입력이 있습니다. 다시 확인해주세요.");
            redirectAttributes.addFlashAttribute("review", lectureReviewDTO);
            return "redirect:/myclass/review/modify?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureReviewResponseDTO review = lectureReviewService.getLectureReviewByIdx(idx);
        if (review == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 수강후기를 찾을 수 없습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(review.getLectureReviewMemberId())) {
            redirectAttributes.addFlashAttribute("message", "수정 권한이 없습니다.");
            return "redirect:/mystudy/review/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        lectureReviewService.updateLectureReview(memberId, lectureReviewDTO);

        return "redirect:/mystudy/review/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
    }

    @GetMapping("/delete")
    public String delete(
            @ModelAttribute LectureReviewPageDTO pageDTO,
            @RequestParam("idx") int idx,
            RedirectAttributes redirectAttributes,
            HttpServletRequest req
    ) {
        HttpSession session = req.getSession();
        String memberId = (String) session.getAttribute("memberId");

        LectureReviewResponseDTO review = lectureReviewService.getLectureReviewByIdx(idx);
        if (review == null) {
            redirectAttributes.addFlashAttribute("message", "요청한 수강후기를 찾을 수 없습니다.");
            return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
        }
        if (!memberId.equals(review.getLectureReviewMemberId())) {
            redirectAttributes.addFlashAttribute("message", "삭제 권한이 없습니다.");
            return "redirect:/mystudy/review/view?idx=" + idx + "&" + pageDTO.getLinkUrl();
        }

        lectureReviewService.deleteLectureReviewByIdx(memberId, idx);

        return "redirect:/mystudy/review?" + pageDTO.getLinkUrl();
    }
}
