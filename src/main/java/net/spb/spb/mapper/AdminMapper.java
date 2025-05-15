package net.spb.spb.mapper;

import net.spb.spb.domain.*;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.*;
import net.spb.spb.dto.post.PostDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface AdminMapper {

    // Teacher
    int existsByTeacherId(String teacherId);

    int insertTeacher(TeacherVO teacherVO);

    List<MemberDTO> selectTeacherWithoutTeacherProfile(TeacherPageDTO teacherPageDTO);

    List<MemberDTO> selectTeacherWithTeacherProfile(TeacherPageDTO teacherPageDTO);

    int selectTeacherWithoutTeacherProfileCount(TeacherPageDTO teacherPageDTO);

    int selectTeacherWithTeacherProfileCount(TeacherPageDTO teacherPageDTO);

    int modifyTeacherProfile (TeacherVO teacherVO);

    int deleteTeacher (String teacherId);

    int restoreTeacher (String teacherId);

    List<MemberVO> getAllTeachers(MemberPageDTO memberPageDTO);

    int getAllTeachersCount(MemberPageDTO memberPageDTO);

    // Lecture
    int insertLecture(LectureVO lectureVo);

    List<LectureDTO> selectLectureList(LecturePageDTO lecturePageDTO);

    LectureDTO selectLecture(int lectureIdx);

    int selectLectureCount(LecturePageDTO lecturePageDTO);

    int updateLecture(LectureVO lectureVO);

    int deleteLecture(int lectureIdx);

    int restoreLecture(int lectureIdx);

    int existsByLectureId(int lectureIdx);

    // Chapter
    int insertChapter(ChapterVO chapterVO);

    int selectChapterCount(ChapterPageDTO chapterPageDTO);

    List<ChapterDTO> selectChapterList(ChapterPageDTO chapterPageDTO);

    ChapterDTO selectChapter(int chapterIdx);

    int updateChapter(ChapterVO chapterVO);

    int deleteChapter(int chapterIdx);

    int restoreChapter(int chapterIdx);
    // Sales
    List<Map<String, Object>> selectMonthlySales(Map<String, Object> param);

    List<Map<String, Object>> selectLectureSalesDefault();

    List<Map<String, Object>> selectLectureSales(Map<String, Object> param);

    List<OrderDTO> selectSalesDetailList(@Param("searchDTO") SearchDTO searchDTO,
                                         @Param("pageDTO") PageRequestDTO pageDTO);

    int selectSalesDetailCount(@Param("searchDTO") SearchDTO searchDTO);

    List<OrderDTO> selectSalesListForExport(Map<String, Object> param);

    // Reports
    List<PostDTO> selectReportedPosts(PostPageDTO postPageDTO);

    int selectReportedPostsCount(PostPageDTO postPageDTO);

    PostDTO selectPostByIdx(int postIdx);

    int deletePostByAdmin(int postIdx);

    int updateReportState(ReportVO reportVO);

}