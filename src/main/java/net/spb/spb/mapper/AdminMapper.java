package net.spb.spb.mapper;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface AdminMapper {
    int insertLecture(LectureVO lectureVo);

    int insertChapter(ChapterVO chapterVO);

    int insertTeacher(TeacherVO teacherVO);

    List<LectureDTO> selectLecture(LecturePageDTO lecturePageDTO);

    int selectLectureCount(LecturePageDTO lecturePageDTO);
    
    List<Map<String, Object>> selectMonthlySales(Map<String, Object> param);

    List<Map<String, Object>> selectLectureSalesDefault();

    List<Map<String, Object>> selectLectureSales(Map<String, Object> param);

    List<OrderDTO> selectSalesDetailList(@Param("searchDTO") SearchDTO searchDTO,
                                         @Param("pageDTO") PageRequestDTO pageDTO);

    int selectSalesDetailCount(@Param("searchDTO") SearchDTO searchDTO);

    List<MemberDTO> selectTeacherWithoutTeacherProfile();
    List<MemberDTO> selectTeacherWithTeacherProfile();
    int modifyTeacherProfile (TeacherVO teacherVO);
