package net.spb.spb.service.mystudy;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.LectureReviewVO;
import net.spb.spb.dto.mystudy.LectureReviewDTO;
import net.spb.spb.dto.mystudy.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;
import net.spb.spb.exception.NotFoundException;
import net.spb.spb.mapper.lecture.LectureReviewMapper;
import net.spb.spb.mapper.mystudy.StudentLectureMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Log4j2
@Service
@Transactional
@RequiredArgsConstructor
public class LectureReviewService implements LectureReviewServiceIf {
    private final ModelMapper modelMapper;
    private final LectureReviewMapper lectureReviewMapper;
    private final StudentLectureMapper studentLectureMapper;

    @Override
    public int createLectureReview(String memberId, LectureReviewDTO lectureReviewDTO) {
        LectureReviewVO lectureReviewVO = modelMapper.map(lectureReviewDTO, LectureReviewVO.class);

        // lectureIdx 에 해당하는 강좌가 없을 경우 - 404 Not Found
        if (false) {}
        // 회원이 lectureIdx 에 해당하는 강좌를 수강하지 않는 경우 -> 403 Forbidden
        if (!studentLectureMapper.isLectureRegisteredByMemberId(memberId, lectureReviewDTO.getLectureReviewRefIdx())) {}
        // 이미 수강후기를 작성한 경우 -> 409 Conflict
        if (!lectureReviewMapper.hasLectureReview(memberId, lectureReviewDTO.getLectureReviewRefIdx())){}

        return lectureReviewMapper.insertLectureReview(lectureReviewVO);
    }

    @Override
    public List<LectureReviewResponseDTO> getLectureReviewList(LectureReviewPageDTO pageDTO) {
        return lectureReviewMapper.selectLectureReviewList(pageDTO);
    }

    @Override
    public LectureReviewResponseDTO getLectureReviewByIdx(int idx) {
        LectureReviewResponseDTO review = lectureReviewMapper.selectLectureReviewByIdx(idx);

        if (review == null) {
            throw new NotFoundException("요청한 수강후기를 찾을 수 없습니다.", "LectureReview", idx);
        }

        return review;
    }

    @Override
    public int updateLectureReview(String memberId, LectureReviewDTO lectureReviewDTO) {
        int reviewIdx = lectureReviewDTO.getLectureReviewIdx();
        LectureReviewResponseDTO review = lectureReviewMapper.selectLectureReviewByIdx(reviewIdx);

        if(review == null) {
            // throw new NotFoundException("LectureReview", reviewIdx);
        }
        if(!review.getLectureReviewMemberId().equals(memberId)) {
            // throw new AccessDeniedException("LectureReview", reviewIdx);
        }

        LectureReviewVO lectureReviewVO = modelMapper.map(lectureReviewDTO, LectureReviewVO.class);
        return lectureReviewMapper.updateLectureReview(lectureReviewVO);
    }

    @Override
    public int deleteLectureReviewByIdx(String memberId, int idx) {
        LectureReviewResponseDTO review = lectureReviewMapper.selectLectureReviewByIdx(idx);

        if(review == null) {
            // throw new NotFoundException("LectureReview", idx);
        }
        if(!review.getLectureReviewMemberId().equals(memberId)) {
            // throw new AccessDeniedException("LectureReview", idx);
        }

        return lectureReviewMapper.deleteLectureReviewByIdx(idx);
    }

    @Override
    public int getLectureReviewListTotalCount(LectureReviewPageDTO pageDTO) {
        return lectureReviewMapper.selectLectureReviewListTotalCount(pageDTO);
    }
}
