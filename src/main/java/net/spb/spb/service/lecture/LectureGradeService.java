package net.spb.spb.service.lecture;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.LectureGradeVO;
import net.spb.spb.dto.lecture.LectureGradeDTO;
import net.spb.spb.dto.lecture.LectureGradeDetailDTO;
import net.spb.spb.dto.lecture.LectureGradeListDTO;
import net.spb.spb.dto.pagingsearch.LectureGradePageDTO;
import net.spb.spb.mapper.lecture.LectureGradeMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Log4j2
@Service
@RequiredArgsConstructor
public class LectureGradeService implements LectureGradeServiceIf {

    private final ModelMapper modelMapper;
    private final LectureGradeMapper lectureGradeMapper;

    @Override
    public int createLectureGrade(LectureGradeDTO dto) {
        LectureGradeVO vo = modelMapper.map(dto, LectureGradeVO.class);
        return lectureGradeMapper.insertLectureGrade(vo);
    }

    @Override
    public int updateLectureGrade(LectureGradeDTO dto) {
        LectureGradeVO vo = modelMapper.map(dto, LectureGradeVO.class);
        return lectureGradeMapper.updateLectureGrade(vo);
    }

    @Override
    public int deleteLectureGradeByidx(int idx) {
        return lectureGradeMapper.deleteLectureGradeByIdx(idx);
    }

    @Override
    public LectureGradeDetailDTO getLectureGradeByIdx(int idx) {
        return lectureGradeMapper.selectLectureGradeByIdx(idx);
    }

    @Override
    public List<LectureGradeListDTO> getLectureGradeTotalCount(LectureGradePageDTO pageDTO) {
        return lectureGradeMapper.selectLectureGradeTotalCount(pageDTO);
    }

    @Override
    public List<LectureGradeListDTO> getLectureGradeList(LectureGradePageDTO pageDTO) {
        return lectureGradeMapper.selectLectureGradeList(pageDTO);
    }
}
