package net.spb.spb.mapper;

import net.spb.spb.domain.TeacherNoticeVO;
import net.spb.spb.dto.pagingsearch.TeacherNoticePageDTO;
import net.spb.spb.dto.teacher.TeacherNoticeResponseDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TeacherNoticeMapper {
    public int insertTeacherNotice(TeacherNoticeVO teacherNoticeVO);
    public List<TeacherNoticeResponseDTO> selectTeacherNoticeList(@Param("memberId") String memberId, @Param("pageDTO") TeacherNoticePageDTO pageDTO);
    public TeacherNoticeResponseDTO selectTeacherNoticeByIdx(int teacherNoticeIdx);
    public int updateTeacherNotice(TeacherNoticeVO teacherNoticeVO);
    public int deleteTeacherNoticeByIdx(int teacherNoticeIdx);

    public int selectTeacherNoticeListTotalCount(@Param("memberId") String memberId, @Param("pageDTO") TeacherNoticePageDTO pageDTO);
}
