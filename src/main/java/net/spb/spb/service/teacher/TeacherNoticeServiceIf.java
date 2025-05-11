package net.spb.spb.service.teacher;

import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherNoticeDTO;
import net.spb.spb.dto.teacher.TeacherNoticeResponseDTO;

import java.util.List;

public interface TeacherNoticeServiceIf {
    public int createTeacherNotice(TeacherNoticeDTO teacherNoticeDTO);
    public List<TeacherNoticeResponseDTO> getTeacherNoticeList(String memberId, TeacherNoticePageDTO pageDTO);
    public TeacherNoticeResponseDTO getTeacherNoticeByIdx(int idx);
    public int updateTeacherNotice(String memberId, TeacherNoticeDTO teacherNoticeDTO);
    public int deleteTeacherNoticeByIdx(String memberId, int idx);
}
