package net.spb.spb.mapper.teacher;

import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TeacherMapper {
    public TeacherVO selectTeacher(String teacherId);
    public List<LectureVO> selectTeacherLecture(String teacherId);
    public List<TeacherVO> getTeacherMain(@Param("subject") String subject, @Param("searchDTO") SearchDTO searchDTO, @Param("pageRequestDTO") PageRequestDTO pageRequestDTO);
    public List<String> getAllSubject();
    public List<TeacherVO> getAllTeacher(@Param("searchDTO") SearchDTO searchDTO, @Param("pageRequestDTO") PageRequestDTO pageRequestDTO);
    public int getTotalCount(@Param("searchDTO") SearchDTO searchDTO, @Param("subject") String subject);
    public List<Integer> selectBookmark(@Param("teacherId")String teacherId, @Param("memberId")String memberId);

    public int selectTeacherLectureListTotalCount(@Param("teacherId") String teacherId, @Param("pageDTO") LecturePageDTO pageDTO);
    public List<LectureVO> selectTeacherLectureListById(@Param("teacherId") String teacherId, @Param("pageDTO") LecturePageDTO pageDTO);
}
