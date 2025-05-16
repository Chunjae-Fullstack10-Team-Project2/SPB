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
    private final LectureReviewMapper lectureReviewMapper;

    @Override
    public int createLectureReview(String memberId, LectureReviewDTO lectureReviewDTO) {
        LectureReviewVO lectureReviewVO = modelMapper.map(lectureReviewDTO, LectureReviewVO.class);
        lectureReviewMapper.insertLectureReview(lectureReviewVO);
        return lectureReviewVO.getLectureReviewIdx();
    }

    @Override
    public List<LectureReviewResponseDTO> getLectureReviewList(LectureReviewListRequestDTO reqDTO, LectureReviewPageDTO pageDTO) {
        pageDTO.setTotal_count(lectureReviewMapper.selectLectureReviewListTotalCount(reqDTO, pageDTO));
        return lectureReviewMapper.selectLectureReviewList(reqDTO, pageDTO);
    }

    @Override
    public LectureReviewResponseDTO getLectureReviewByIdx(int idx) {
        return lectureReviewMapper.selectLectureReviewByIdx(idx);
    }

    @Override
    public int updateLectureReview(String memberId, LectureReviewDTO lectureReviewDTO) {
        LectureReviewVO lectureReviewVO = modelMapper.map(lectureReviewDTO, LectureReviewVO.class);
        return lectureReviewMapper.updateLectureReview(lectureReviewVO);
    }

    @Override
    public int deleteLectureReviewByIdx(String memberId, int idx) {
        return lectureReviewMapper.deleteLectureReviewByIdx(idx);
    }

    @Override
    public int getLectureReviewTotalCount(LectureReviewListRequestDTO reqDTO, LectureReviewPageDTO pageDTO) {
        return lectureReviewMapper.selectLectureReviewListTotalCount(reqDTO, pageDTO);
    }

    @Override
    public boolean hasLectureReview(String memberId, int idx) {
        return lectureReviewMapper.hasLectureReview(memberId, idx);
    }
}
