package net.spb.spb.mapper;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TeacherMapper {
    public TeacherVO selectTeacher(String teacherId);
    public List<LectureVO> selectTeacherLecture(String teacherId);
    public LectureVO selectLectureMain(int lectureIdx);
    public List<ChapterVO> selectLectureChapter(int lectureIdx);
    public List<TeacherVO> getTeacherMain(String subject);
    public List<String> getAllSubject();
    public List<TeacherVO> getAllTeacher();
    public int addBookmark(@Param("lectureIdx")int lectureIdx, @Param("memberId")String memberId);
    public int deleteBookmark(@Param("lectureIdx")int lectureIdx, @Param("memberId")String memberId);
    public List<Integer> selectBookmark(@Param("teacherId")String teacherId, @Param("memberId")String memberId);
}
