package net.spb.spb.mapper;

import net.spb.spb.domain.TeacherQnaVO;
import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.TeacherQnaListRequestDTO;
import net.spb.spb.dto.teacher.TeacherQnaResponseDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TeacherQnaMapper {
    List<TeacherQnaResponseDTO> selectTeacherQnaList(@Param("reqDTO")TeacherQnaListRequestDTO reqDTO, @Param("pageDTO")TeacherQnaPageDTO pageDTO);
    public TeacherQnaResponseDTO selectTeacherQnaByIdx(int teacherQnaIdx);

    public int insertTeacherQuestion(TeacherQnaVO teacherQnaVO);
    public int updateTeacherAnswer(TeacherQnaVO teacherQnaVO);
    public int deleteTeacherQnaByIdx(int teacherQnaIdx);

    public int selectTeacherQnaListTotalCount(@Param("reqDTO")TeacherQnaListRequestDTO reqDTO, @Param("pageDTO") TeacherQnaPageDTO pageDTO);
    public String selectTeacherQnaPwdByIdx(int teacherQnaIdx);
}
