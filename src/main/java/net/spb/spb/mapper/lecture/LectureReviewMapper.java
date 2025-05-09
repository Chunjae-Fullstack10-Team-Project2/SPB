package net.spb.spb.mapper.lecture;

import net.spb.spb.domain.LectureReviewVO;
import net.spb.spb.dto.mystudy.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;

import java.util.List;

public interface LectureReviewMapper {
    public int insertLectureReview(LectureReviewVO lectureReviewVO);
    public List<LectureReviewResponseDTO> selectLectureReviewList(LectureReviewPageDTO pageDTO);
    public LectureReviewResponseDTO selectLectureReviewByIdx(int idx);
    public int updateLectureReview(LectureReviewVO lectureReviewVO);
    public int deleteLectureReviewByIdx(int idx);

    public int selectLectureReviewListTotalCount(LectureReviewPageDTO pageDTO);

    public boolean hasLectureReview(String memberId, int lectureIdx);
}
