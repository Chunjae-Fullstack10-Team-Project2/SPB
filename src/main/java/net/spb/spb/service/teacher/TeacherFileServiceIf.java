package net.spb.spb.service.teacher;

import net.spb.spb.dto.FileDTO;
import net.spb.spb.dto.pagingsearch.TeacherFilePageDTO;
import net.spb.spb.dto.teacher.TeacherFileDTO;
import net.spb.spb.dto.teacher.TeacherFileResponseDTO;

import java.util.List;

public interface TeacherFileServiceIf {
    public int createTeacherFile(TeacherFileDTO dto);
    public List<TeacherFileResponseDTO> getTeacherFileList(String teacherId, TeacherFilePageDTO pageDTO);
    public TeacherFileResponseDTO getTeacherFileByIdx(int idx);
    public int deleteTeacherFileByIdx(int idx);
    public FileDTO getFileByIdx(int idx);
}
