package net.spb.spb.service.teacher;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.TeacherNoticeVO;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherNoticeDTO;
import net.spb.spb.dto.teacher.TeacherNoticeResponseDTO;
import net.spb.spb.mapper.TeacherNoticeMapper;
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
        pageDTO.setTotal_count(teacherNoticeMapper.selectTeacherNoticeListTotalCount(memberId, pageDTO));
        return teacherNoticeMapper.selectTeacherNoticeList(memberId, pageDTO);
    }

    @Override
    public TeacherNoticeResponseDTO getTeacherNoticeByIdx(int idx) {
        TeacherNoticeResponseDTO teacherNotice = teacherNoticeMapper.selectTeacherNoticeByIdx(idx);

        if (teacherNotice == null) {
            // 요청한 수강후기를 찾을 수 없습니다.
        }

        return teacherNotice;
    }

    @Override
    public int updateTeacherNotice(String memberId, TeacherNoticeDTO teacherNoticeDTO) {
        int idx = teacherNoticeDTO.getTeacherNoticeIdx();
        TeacherNoticeResponseDTO teacherNotice = teacherNoticeMapper.selectTeacherNoticeByIdx(idx);

        if (teacherNotice == null) {
            // 요청한 수강후기를 찾을 수 없습니다.
        }
        if (!teacherNotice.getTeacherNoticeMemberId().equals(memberId)) {
            // 수정 권한이 없습니다.
        }

        TeacherNoticeVO teacherNoticeVO = modelMapper.map(teacherNoticeDTO, TeacherNoticeVO.class);
        return teacherNoticeMapper.updateTeacherNotice(teacherNoticeVO);
    }

    @Override
    public int deleteTeacherNoticeByIdx(String memberId, int idx) {
        TeacherNoticeResponseDTO teacherNotice = teacherNoticeMapper.selectTeacherNoticeByIdx(idx);

        if (teacherNotice == null) {
            // 요청한 수강후기를 찾을 수 없습니다.
        }
        if (!teacherNotice.getTeacherNoticeMemberId().equals(memberId)) {
            // 삭제 권한이 없습니다.
        }

        return teacherNoticeMapper.deleteTeacherNoticeByIdx(idx);
    }
}
