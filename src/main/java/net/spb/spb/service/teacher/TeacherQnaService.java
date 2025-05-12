package net.spb.spb.service.teacher;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.TeacherQnaVO;
import net.spb.spb.dto.pagingsearch.TeacherQnaPageDTO;
import net.spb.spb.dto.teacher.TeacherQnaDTO;
import net.spb.spb.dto.teacher.TeacherQnaListRequestDTO;
import net.spb.spb.dto.teacher.TeacherQnaResponseDTO;
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
        pageDTO.setTotal_count(teacherQnaMapper.selectTeacherQnaListTotalCount(reqDTO, pageDTO));
        
        return teacherQnaMapper.selectTeacherQnaList(reqDTO, pageDTO);
    }

    @Override
    public TeacherQnaResponseDTO getTeacherQnaByIdx(int idx) {
        TeacherQnaResponseDTO teacherQna = teacherQnaMapper.selectTeacherQnaByIdx(idx);

        if (teacherQna != null) {
            // 요청한 Qna를 찾을 수 없습니다.
        }

        return teacherQna;
    }

    @Override
    public int createTeacherQuestion(TeacherQnaDTO teacherQnaDTO) {
        TeacherQnaVO teacherQnaVO = modelMapper.map(teacherQnaDTO, TeacherQnaVO.class);
        return teacherQnaMapper.insertTeacherQuestion(teacherQnaVO);
    }

    @Override
    public int updateTeacherAnswer(String memberId, TeacherQnaDTO teacherQnaDTO) {
        int idx = teacherQnaDTO.getTeacherQnaIdx();
        TeacherQnaResponseDTO teacherQna = teacherQnaMapper.selectTeacherQnaByIdx(idx);

        if (teacherQna != null) {
            // 요청한 Qna를 찾을 수 없습니다.
        }
        if (!teacherQna.getTeacherQnaAMemberId().equals(memberId)) {
            // 답변 권한이 없습니다.
        }

        TeacherQnaVO teacherQnaVO = modelMapper.map(teacherQnaDTO, TeacherQnaVO.class);
        return teacherQnaMapper.updateTeacherAnswer(teacherQnaVO);
    }

    @Override
    public int deleteTeacherQuestionByIdx(String memberId, int idx) {
        TeacherQnaResponseDTO teacherQna = teacherQnaMapper.selectTeacherQnaByIdx(idx);

        if (teacherQna != null) {
            // 요청한 Qna를 찾을 수 없습니다.
        }
        if (!teacherQna.getTeacherQnaQMemberId().equals(memberId)) {
            // 삭제 권한이 없습니다.
        }

        return teacherQnaMapper.deleteTeacherQnaByIdx(idx);
    }

    @Override
    public String getTeacherQnaPwdByIdx(int idx) {
        return teacherQnaMapper.selectTeacherQnaPwdByIdx(idx);
    }
}
