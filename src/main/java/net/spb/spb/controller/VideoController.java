package net.spb.spb.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.LectureHistoryDTO;
import net.spb.spb.service.VideoServiceIf;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/video")
public class VideoController {
    private final VideoServiceIf videoService;
    private final ModelMapper modelMapper;

    @PostMapping("/progress")
    @ResponseBody
    public void saveProgress(@RequestBody LectureHistoryDTO historyDTO) {
        log.info("💾 저장 요청 DTO: {}", historyDTO);
        boolean exists = videoService.existsByMemberIdAndChapterIdx(
                historyDTO.getLectureMemberId(),
                historyDTO.getLectureHistoryChapterIdx()
        );

        if (exists) {
            videoService.updateProgress(historyDTO);
        } else {
            videoService.saveProgress(historyDTO);
        }
    }

    @GetMapping("/progress")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getProgress(
            @RequestParam("lectureMemberId") String lectureMemberId,
            @RequestParam("lectureHistoryChapterIdx") int lectureHistoryChapterIdx) {
        String timeStr = videoService.getLastWatchedTime(lectureMemberId, lectureHistoryChapterIdx); // 예: "00:03:15"
        int seconds = 0;

        if (timeStr != null && !timeStr.isBlank()) {
            try {
                seconds = LocalTime.parse(timeStr).toSecondOfDay(); // HH:mm:ss → 초 단위 변환
            } catch (Exception e) {
                log.warn("시간 파싱 실패: " + timeStr, e);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("lastTime", seconds); // 숫자형 초 값 반환
        return ResponseEntity.ok(result);
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<String> handleDataIntegrityViolationException(DataIntegrityViolationException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body("이미 해당 강의에 대한 진행 정보가 존재합니다.");
    }
}
