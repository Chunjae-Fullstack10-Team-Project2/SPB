package net.spb.spb.service.lecture;

import net.spb.spb.dto.lecture.LectureReviewDTO;
import net.spb.spb.dto.lecture.LectureReviewListRequestDTO;
import net.spb.spb.dto.lecture.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;

import java.util.List;

public interface LectureReviewServiceIf {
    public int createLectureReview(String memberId, LectureReviewDTO lectureReviewDTO);
    public List<LectureReviewResponseDTO> getLectureReviewList(LectureReviewListRequestDTO reqDTO, LectureReviewPageDTO pageDTO);
    public LectureReviewResponseDTO getLectureReviewByIdx(int idx);
    public int updateLectureReview(String memberId, LectureReviewDTO lectureReviewDTO);
    public int deleteLectureReviewByIdx(String memberId, int idx);
}
