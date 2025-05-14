package net.spb.spb.service.lecture;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.LectureReviewVO;
import net.spb.spb.dto.lecture.LectureReviewDTO;
import net.spb.spb.dto.lecture.LectureReviewListRequestDTO;
import net.spb.spb.dto.lecture.LectureReviewResponseDTO;
import net.spb.spb.dto.pagingsearch.LectureReviewPageDTO;
import net.spb.spb.exception.AccessDeniedException;
import net.spb.spb.exception.ConflictException;
import net.spb.spb.exception.NotFoundException;
import net.spb.spb.mapper.lecture.LectureMapper;
import net.spb.spb.mapper.lecture.LectureReviewMapper;
import net.spb.spb.mapper.lecture.StudentLectureMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Log4j2
@Service
@RequiredArgsConstructor
public class LectureReviewService implements LectureReviewServiceIf {

    private final ModelMapper modelMapper;
    private final LectureMapper lectureMapper;
    private final LectureReviewMapper lectureReviewMapper;
    private final StudentLectureMapper studentLectureMapper;

    @Override
    public int createLectureReview(String memberId, LectureReviewDTO lectureReviewDTO) {
        LectureReviewVO lectureReviewVO = modelMapper.map(lectureReviewDTO, LectureReviewVO.class);

        // lectureIdx 에 해당하는 강좌가 없을 경우 - 404 Not Found
        int lectureIdx = lectureReviewDTO.getLectureReviewRefIdx();
        if (lectureReviewMapper.selectLectureReviewByIdx(lectureIdx) == null) {
            throw new NotFoundException("요청한 강좌를 찾을 수 없습니다.", "lecture", lectureIdx);
        }
        // 회원이 lectureIdx 에 해당하는 강좌를 수강하지 않는 경우 -> 403 Forbidden
        if (!studentLectureMapper.isLectureRegisteredByMemberId(memberId, lectureIdx)) {
            throw new AccessDeniedException("수강 중인 강좌만 후기를 등록할 수 있습니다.", "lecture", lectureIdx);
        }
        // 이미 수강후기를 작성한 경우 -> 409 Conflict
        if (!lectureReviewMapper.hasLectureReview(memberId, lectureIdx)){
            throw new ConflictException("수강후기만 한 번만 작성할 수 있습니다.", "lecture", lectureIdx);
        }

        return lectureReviewMapper.insertLectureReview(lectureReviewVO);
    }

    @Override
    public List<LectureReviewResponseDTO> getLectureReviewList(LectureReviewListRequestDTO reqDTO, LectureReviewPageDTO pageDTO) {
        pageDTO.setTotal_count(lectureReviewMapper.selectLectureReviewListTotalCount(reqDTO, pageDTO));
        return lectureReviewMapper.selectLectureReviewList(reqDTO, pageDTO);
    }

    @Override
    public LectureReviewResponseDTO getLectureReviewByIdx(int idx) {
        LectureReviewResponseDTO review = lectureReviewMapper.selectLectureReviewByIdx(idx);

        if (review == null) {
            throw new NotFoundException("요청한 수강후기를 찾을 수 없습니다.", "lecture-review", idx);
        }

        return review;
    }

    @Override
    public int updateLectureReview(String memberId, LectureReviewDTO lectureReviewDTO) {
        int reviewIdx = lectureReviewDTO.getLectureReviewIdx();
        LectureReviewResponseDTO review = lectureReviewMapper.selectLectureReviewByIdx(reviewIdx);

        if(review == null) {
            throw new NotFoundException("요청한 수강후기를 찾을 수 없습니다.", "lecture-review", reviewIdx);
        }
        if(!review.getLectureReviewMemberId().equals(memberId)) {
            throw new AccessDeniedException("수정 권한이 없습니다.", "lecture-review", reviewIdx);
        }

        LectureReviewVO lectureReviewVO = modelMapper.map(lectureReviewDTO, LectureReviewVO.class);
        return lectureReviewMapper.updateLectureReview(lectureReviewVO);
    }

    @Override
    public int deleteLectureReviewByIdx(String memberId, int idx) {
        LectureReviewResponseDTO review = lectureReviewMapper.selectLectureReviewByIdx(idx);

        if(review == null) {
            throw new NotFoundException("요청한 수강후기를 찾을 수 없습니다.", "lecture-review", idx);
        }
        if(!review.getLectureReviewMemberId().equals(memberId)) {
            throw new AccessDeniedException("수정 권한이 없습니다.", "lecture-review", idx);
        }

        return lectureReviewMapper.deleteLectureReviewByIdx(idx);
    }

    @Override
    public int getLectureReviewTotalCount(LectureReviewListRequestDTO reqDTO, LectureReviewPageDTO pageDTO) {
        return lectureReviewMapper.selectLectureReviewListTotalCount(reqDTO, pageDTO);
    }
}
