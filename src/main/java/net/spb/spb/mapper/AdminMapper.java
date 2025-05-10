package net.spb.spb.mapper;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;

import java.util.List;

public interface AdminMapper {
    int insertLecture(LectureVO lectureVo);
    int insertChapter(ChapterVO chapterVO);
    int insertTeacher(TeacherVO teacherVO);
    List<LectureDTO> selectLecture(LecturePageDTO lecturePageDTO);
    int selectLectureCount(LecturePageDTO lecturePageDTO);
    List<MemberDTO> selectTeacherWithoutTeacherProfile();
    List<MemberDTO> selectTeacherWithTeacherProfile();
    int modifyTeacherProfile (TeacherVO teacherVO);
}
