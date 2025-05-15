package net.spb.spb.mapper;

import net.spb.spb.domain.FileVO;
import net.spb.spb.domain.TeacherFileVO;
import net.spb.spb.dto.pagingsearch.TeacherFilePageDTO;
import net.spb.spb.dto.teacher.TeacherFileResponseDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TeacherFileMapper {
    int insertTeacherFile(TeacherFileVO vo);
    int updateTeacherFile(TeacherFileVO vo);
    int deleteTeacherFileByIdx(int idx);
    int deleteTeacherFileByFileIdx(int fileIdx);
    List<TeacherFileVO> selectTeacherFileList(@Param("teacherId") String teacherId, @Param("pageDTO") TeacherFilePageDTO pageDTO);
    TeacherFileResponseDTO selectTeacherFileByIdx(int idx);
    FileVO selectFileByIdx(int idx);

    int selectTeacherFileListTotalCount(@Param("teacherId") String teacherId, @Param("pageDTO") TeacherFilePageDTO pageDTO);
}
