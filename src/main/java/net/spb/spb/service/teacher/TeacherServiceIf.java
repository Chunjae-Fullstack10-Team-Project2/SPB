package net.spb.spb.service.teacher;


import net.spb.spb.dto.lecture.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;

import java.util.List;

public interface TeacherServiceIf {
    public TeacherDTO selectTeacher(String teacherId);
    public List<LectureDTO> selectTeacherLecture(String teacherId);
    public List<TeacherDTO> getTeacherMain(String subject, SearchDTO searchDTO, PageRequestDTO pageRequestDTO);
    public List<String> getAllSubject();
    public List<TeacherDTO> getAllTeacher(SearchDTO searchDTO, PageRequestDTO pageRequestDTO);
    public int getTotalCount(SearchDTO searchDTO, String subject);
    public List<Integer> selectBookmark(String teacherId, String memberId);

    public int getTeacherLectureListTotalCount(String teacherId, LecturePageDTO pageDTO);
    public List<LectureDTO> getTeacherLectureListById(String teacherId, LecturePageDTO pageDTO);
}
