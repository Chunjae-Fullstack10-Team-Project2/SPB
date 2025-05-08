package net.spb.spb.service.mystudy;

import net.spb.spb.dto.mystudy.StudentLectureResponseDTO;
import net.spb.spb.dto.pagingsearch.StudentLecturePageDTO;

import java.util.List;

public interface StudentLectureServiceIf {
    public List<StudentLectureResponseDTO> getStudentLectureList(String memberId, StudentLecturePageDTO pageDTO);
    public int getStudentLectureTotalCount(String memberId, StudentLecturePageDTO pageDTO);
}
