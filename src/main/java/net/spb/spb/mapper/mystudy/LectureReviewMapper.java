package net.spb.spb.mapper.mystudy;

import net.spb.spb.domain.LectureReviewVO;
import net.spb.spb.dto.mystudy.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;

import java.util.List;

public interface LectureReviewMapper {
    public int insertLectureReview(LectureReviewVO lectureReviewVO);
    public List<LectureReviewResponseDTO> selectLectureReviewList(String memberId, LectureReviewPageDTO pageDTO);
    public LectureReviewResponseDTO selectLectureReviewByIdx(int idx);
    public int updateLectureReview(LectureReviewVO lectureReviewVO);
    public int deleteLectureReviewByIdx(int idx);

    public int selectLectureReviewListTotalCount(String memberId, LectureReviewPageDTO pageDTO);
}
