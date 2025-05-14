package net.spb.spb.service.teacher;

import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.*;

import java.util.List;

public interface TeacherQnaServiceIf {
    public List<TeacherQnaResponseDTO> getTeacherQnaList(TeacherQnaListRequestDTO reqDTO, TeacherQnaPageDTO pageDTO);
    public TeacherQnaResponseDTO getTeacherQnaByIdx(int idx);
    public int createTeacherQuestion(TeacherQnaQuestionDTO questionDTO);
    public int updateTeacherAnswer(TeacherQnaAnswerDTO answerDTO);
    public int deleteTeacherQuestionByIdx(int idx);
    public String getTeacherQnaPwdByIdx(int idx);

    public int getTeacherQnaTotalCount(TeacherQnaListRequestDTO reqDTO, TeacherQnaPageDTO pageDTO);
}
