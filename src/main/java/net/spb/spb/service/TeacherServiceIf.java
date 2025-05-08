package net.spb.spb.service;


import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;

import java.util.List;

public interface TeacherServiceIf {
    public TeacherDTO selectTeacher(String teacherId);
    public List<LectureDTO> selectTeacherLecture(String teacherId);
    public LectureDTO selectLectureMain(int lectureIdx);
    public List<ChapterDTO> selectLectureChapter(int lectureIdx);
    public List<TeacherDTO> getTeacherMain(String subject);
    public List<String> getAllSubject();
    public List<TeacherDTO> getAllTeacher();
    public int addBookmark(int lectureIdx, String memberId);
    public int deleteBookmark(int lectureIdx, String memberId);
    public List<Integer> selectBookmark(String teacherId, String memberId);
}
