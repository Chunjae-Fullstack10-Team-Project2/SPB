package net.spb.spb.mapper;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.ReportVO;
import net.spb.spb.domain.TeacherVO;
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

    List<MemberDTO> selectTeacherWithoutTeacherProfile();

    List<MemberDTO> selectTeacherWithTeacherProfile();

    int modifyTeacherProfile (TeacherVO teacherVO);

    // Lecture
    int insertLecture(LectureVO lectureVo);

    List<LectureDTO> selectLectureList(LecturePageDTO lecturePageDTO);

    LectureDTO selectLecture(int lectureIdx);

    int selectLectureCount(LecturePageDTO lecturePageDTO);

    int updateLecture(LectureVO lectureVO);

    int deleteLecture(LectureVO lectureVO);

    // Chapter
    int insertChapter(ChapterVO chapterVO);

    List<ChapterDTO> selectChapterList(ChapterPageDTO chapterPageDTO);

    ChapterDTO selectChapter(int chapterIdx);

    int updateChapter(ChapterVO chapterVO);

    int deleteChapter(ChapterVO chapterVO);

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