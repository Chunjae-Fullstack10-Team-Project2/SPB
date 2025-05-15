package net.spb.spb.service.lecture;

import net.spb.spb.dto.lecture.LectureGradeDTO;
import net.spb.spb.dto.lecture.LectureGradeDetailDTO;
import net.spb.spb.dto.lecture.LectureGradeListDTO;
import net.spb.spb.dto.pagingsearch.LectureGradePageDTO;

import java.util.List;

public interface LectureGradeServiceIf {
    public int createLectureGrade(LectureGradeDTO dto);
    public int updateLectureGrade(LectureGradeDTO dto);
    public int deleteLectureGradeByidx(int idx);
    public LectureGradeDetailDTO getLectureGradeByIdx(int idx);
    public int getLectureGradeTotalCount(LectureGradePageDTO pageDTO);
    public List<LectureGradeListDTO> getLectureGradeList(LectureGradePageDTO pageDTO);
}
