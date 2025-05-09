package net.spb.spb.service.mystudy;

import net.spb.spb.dto.mystudy.LectureReviewDTO;
import net.spb.spb.dto.mystudy.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;

import java.util.List;

public interface LectureReviewServiceIf {
    public int createLectureReview(String memberId, LectureReviewDTO lectureReviewDTO);
    public List<LectureReviewResponseDTO> getLectureReviewList(LectureReviewPageDTO pageDTO);
    public LectureReviewResponseDTO getLectureReviewByIdx(int idx);
    public int updateLectureReview(String memberId, LectureReviewDTO lectureReviewDTO);
    public int deleteLectureReviewByIdx(String memberId, int idx);

    public int getLectureReviewListTotalCount(LectureReviewPageDTO pageDTO);
}
