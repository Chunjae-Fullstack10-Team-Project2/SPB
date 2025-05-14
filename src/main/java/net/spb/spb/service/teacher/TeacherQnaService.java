package net.spb.spb.service.teacher;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.TeacherQnaVO;
import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.*;
import net.spb.spb.mapper.teacher.TeacherQnaMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Log4j2
@Service
@RequiredArgsConstructor
public class TeacherQnaService implements TeacherQnaServiceIf {

    private final ModelMapper modelMapper;
    private final TeacherQnaMapper teacherQnaMapper;

    @Override
    public List<TeacherQnaResponseDTO> getTeacherQnaList(TeacherQnaListRequestDTO reqDTO, TeacherQnaPageDTO pageDTO) {
        return teacherQnaMapper.selectTeacherQnaList(reqDTO, pageDTO);
    }

    @Override
    public TeacherQnaResponseDTO getTeacherQnaByIdx(int idx) {
        return teacherQnaMapper.selectTeacherQnaByIdx(idx);
    }

    @Override
    public int createTeacherQuestion(TeacherQnaQuestionDTO questionDTO) {
        TeacherQnaVO teacherQnaVO = modelMapper.map(questionDTO, TeacherQnaVO.class);
        return teacherQnaMapper.insertTeacherQuestion(teacherQnaVO);
    }

    @Override
    public int updateTeacherAnswer(TeacherQnaAnswerDTO answerDTO) {
        TeacherQnaVO vo = modelMapper.map(answerDTO, TeacherQnaVO.class);
        return teacherQnaMapper.updateTeacherAnswer(vo);
    }

    @Override
    public int deleteTeacherQuestionByIdx(int idx) {
        return teacherQnaMapper.deleteTeacherQnaByIdx(idx);
    }

    @Override
    public String getTeacherQnaPwdByIdx(int idx) {
        return teacherQnaMapper.selectTeacherQnaPwdByIdx(idx);
    }

    @Override
    public int getTeacherQnaTotalCount(TeacherQnaListRequestDTO reqDTO, TeacherQnaPageDTO pageDTO) {
        return teacherQnaMapper.selectTeacherQnaTotalCount(reqDTO, pageDTO);
    }
}
