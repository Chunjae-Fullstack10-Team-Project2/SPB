package net.spb.spb.service.mystudy;

import net.spb.spb.dto.mystudy.StudentLectureDTO;
import net.spb.spb.dto.mystudy.StudentLecturePageDTO;

import java.util.List;

public interface StudentLectureServiceIf {
    public List<StudentLectureDTO> getStudentLectureList(String memberId);
    public List<StudentLectureDTO> getStudentLectureList(String memberId, StudentLecturePageDTO pageDTO);
    public int getStudentLectureTotalCount(String memberId, StudentLecturePageDTO pageDTO);
}
