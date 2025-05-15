package net.spb.spb.mapper.lecture;

import net.spb.spb.domain.LectureGradeVO;
import net.spb.spb.dto.lecture.LectureGradeDetailDTO;
import net.spb.spb.dto.lecture.LectureGradeListDTO;
import net.spb.spb.dto.pagingsearch.LectureGradePageDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LectureGradeMapper {
    public int insertLectureGrade(LectureGradeVO vo);
    public int updateLectureGrade(LectureGradeVO vo);
    public int deleteLectureGradeByIdx(int idx);
    public LectureGradeDetailDTO selectLectureGradeByIdx(int idx);

    public List<LectureGradeListDTO> selectLectureGradeTotalCount(LectureGradePageDTO pageDTO);
    public List<LectureGradeListDTO> selectLectureGradeList(LectureGradePageDTO pageDTO);
}
