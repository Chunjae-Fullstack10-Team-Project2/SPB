package net.spb.spb.mapper;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;

import java.util.List;

public interface TeacherMapper {
    public TeacherVO selectTeacher(String teacherId);
    public List<LectureVO> selectTeacherLecture(String teacherId);
    public LectureVO selectLectureMain(int lectureIdx);
    public List<ChapterVO> selectLectureChapter(int lectureIdx);
}
