package net.spb.spb.service.teacher;

import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.TeacherQnaDTO;
import net.spb.spb.dto.teacher.TeacherQnaListRequestDTO;
import net.spb.spb.dto.teacher.TeacherQnaResponseDTO;

import java.util.List;

public interface TeacherQnaServiceIf {
    public List<TeacherQnaResponseDTO> getTeacherQnaList(TeacherQnaListRequestDTO reqDTO, TeacherQnaPageDTO pageDTO);
    public TeacherQnaResponseDTO getTeacherQnaByIdx(int idx);
    public int createTeacherQuestion(TeacherQnaDTO teacherQnaDTO);
    public int updateTeacherAnswer(String memberId, TeacherQnaDTO teacherQnaDTO);
    public int deleteTeacherQuestionByIdx(String memberId, int idx);
    public String getTeacherQnaPwdByIdx(int idx);
}
