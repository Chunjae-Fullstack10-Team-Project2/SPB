package net.spb.spb.service.lecture;

import net.spb.spb.dto.lecture.StudentLectureResponseDTO;
import net.spb.spb.dto.pagingsearch.StudentLecturePageDTO;

import java.util.List;

public interface StudentLectureServiceIf {
    public List<StudentLectureResponseDTO> getStudentLectureList(String memberId, StudentLecturePageDTO pageDTO);
    public int getStudentLectureTotalCount(String memberId, StudentLecturePageDTO pageDTO);
}
