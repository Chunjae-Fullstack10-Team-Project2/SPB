package net.spb.spb.mapper;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;

import java.util.List;
import java.util.Map;

public interface AdminMapper {
    int insertLecture(LectureVO lectureVo);

    int insertChapter(ChapterVO chapterVO);

    int insertTeacher(TeacherVO teacherVO);

    List<LectureDTO> selectLecture(LecturePageDTO lecturePageDTO);

    int selectLectureCount(LecturePageDTO lecturePageDTO);

    List<Map<String, Object>> selectMonthlySalesDefault();
    List<Map<String, Object>> selectMonthlySales(Map<String, Object> param);

    List<Map<String, Object>> selectLectureSalesDefault();
    List<Map<String, Object>> selectLectureSales(Map<String, Object> param);

}
