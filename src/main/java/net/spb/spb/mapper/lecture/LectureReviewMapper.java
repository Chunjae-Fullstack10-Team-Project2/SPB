package net.spb.spb.mapper.lecture;

import net.spb.spb.domain.LectureReviewVO;
import net.spb.spb.dto.lecture.LectureReviewListRequestDTO;
import net.spb.spb.dto.lecture.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LectureReviewMapper {
    public int insertLectureReview(LectureReviewVO lectureReviewVO);
    public List<LectureReviewResponseDTO> selectLectureReviewList(@Param("reqDTO") LectureReviewListRequestDTO reqDTO, @Param("pageDTO") LectureReviewPageDTO pageDTO);
    public LectureReviewResponseDTO selectLectureReviewByIdx(int lectureIdx);
    public int updateLectureReview(LectureReviewVO lectureReviewVO);
    public int deleteLectureReviewByIdx(int lectureIdx);

    public int selectLectureReviewListTotalCount(@Param("reqDTO") LectureReviewListRequestDTO reqDTO, @Param("pageDTO") LectureReviewPageDTO pageDTO);

    public boolean hasLectureReview(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);
}
