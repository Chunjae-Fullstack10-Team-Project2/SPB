package net.spb.spb.service.teacher;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.TeacherNoticeVO;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherNoticeDTO;
import net.spb.spb.dto.teacher.TeacherNoticeResponseDTO;
import net.spb.spb.mapper.teacher.TeacherNoticeMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Log4j2
@RequiredArgsConstructor
public class TeacherNoticeService implements TeacherNoticeServiceIf {

    private final TeacherNoticeMapper teacherNoticeMapper;
    private final ModelMapper modelMapper;


    @Override
    public int createTeacherNotice(TeacherNoticeDTO teacherNoticeDTO) {
        TeacherNoticeVO teacherNoticeVO = modelMapper.map(teacherNoticeDTO, TeacherNoticeVO.class);
        return teacherNoticeMapper.insertTeacherNotice(teacherNoticeVO);
    }

    @Override
    public List<TeacherNoticeResponseDTO> getTeacherNoticeList(String memberId, TeacherNoticePageDTO pageDTO) {
        return teacherNoticeMapper.selectTeacherNoticeList(memberId, pageDTO);
    }

    @Override
    public TeacherNoticeResponseDTO getTeacherNoticeByIdx(int idx) {
        return teacherNoticeMapper.selectTeacherNoticeByIdx(idx);
    }

    @Override
    public int updateTeacherNotice(String memberId, TeacherNoticeDTO teacherNoticeDTO) {
        TeacherNoticeVO teacherNoticeVO = modelMapper.map(teacherNoticeDTO, TeacherNoticeVO.class);
        return teacherNoticeMapper.updateTeacherNotice(teacherNoticeVO);
    }

    @Override
    public int deleteTeacherNoticeByIdx(String memberId, int idx) {
        return teacherNoticeMapper.deleteTeacherNoticeByIdx(idx);
    }

    @Override
    public int getTeacherNoticeTotalCount(String memberId, TeacherNoticePageDTO pageDTO) {
        return teacherNoticeMapper.selectTeacherNoticeListTotalCount(memberId, pageDTO);
    }
}
