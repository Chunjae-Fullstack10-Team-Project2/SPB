package net.spb.spb.service;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.ReportVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.lecture.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.*;
import net.spb.spb.dto.post.PostDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.mapper.AdminMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {
    @Autowired
    private AdminMapper adminMapper;
    @Autowired
    private ModelMapper modelMapper;

    public int insertLecture(LectureDTO lectureDTO) {
        return adminMapper.insertLecture(modelMapper.map(lectureDTO, LectureVO.class));
    }

    public int insertChapter(ChapterDTO chapterDTO) {
        return adminMapper.insertChapter(modelMapper.map(chapterDTO, ChapterVO.class));
    }

    public boolean existsByTeacherId(String teacherId) {
        return adminMapper.existsByTeacherId(teacherId) == 1;
    }

    public int insertTeacher(TeacherDTO teacherDTO) {
        return adminMapper.insertTeacher(modelMapper.map(teacherDTO, TeacherVO.class));
    }

    public List<MemberDTO> getAllTeachers(MemberPageDTO memberPageDTO) {
        return adminMapper.getAllTeachers(memberPageDTO).stream().map(vo -> modelMapper.map(vo, MemberDTO.class)).toList();
    }

    public int getAllTeachersCount(MemberPageDTO memberPageDTO) {
        return adminMapper.getAllTeachersCount(memberPageDTO);
    }

    public List<LectureDTO> selectLectureList(LecturePageDTO lecturePageDTO) {
        return adminMapper.selectLectureList(lecturePageDTO);
    }

    public LectureDTO selectLecture(int lectureIdx) {
        return adminMapper.selectLecture(lectureIdx);
    }

    public List<ChapterDTO> selectChapterList(ChapterPageDTO chapterPageDTO) {
        return adminMapper.selectChapterList(chapterPageDTO);
    }

    public int selectChapterCount(ChapterPageDTO chapterPageDTO) {
        return adminMapper.selectChapterCount(chapterPageDTO);
    }

    public ChapterDTO selectChapter(int chapterIdx) {
        return adminMapper.selectChapter(chapterIdx);
    }

    public int selectLectureCount(LecturePageDTO lecturePageDTO) {
        return adminMapper.selectLectureCount(lecturePageDTO);
    }

    public List<Map<String, Object>> getMonthlySales() {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", "MONTH");
        return adminMapper.selectMonthlySales(param);
    }

    public List<Map<String, Object>> getMonthlySales(String timeType, String startDate, String endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", timeType);
        if (startDate != null && !startDate.isEmpty()) param.put("startDate", startDate);
        if (endDate != null && !endDate.isEmpty()) param.put("endDate", endDate);
        return adminMapper.selectMonthlySales(param);
    }

    public List<Map<String, Object>> getLectureSales() {
        return adminMapper.selectLectureSalesDefault();
    }

    public List<Map<String, Object>> getLectureSales(String timeType, String startDate, String endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", timeType);
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return adminMapper.selectLectureSales(param);
    }

    public List<OrderDTO> getSalesDetailList(SearchDTO searchDTO, PageRequestDTO pageDTO) {
        return adminMapper.selectSalesDetailList(searchDTO, pageDTO);
    }

    public int getSalesDetailCount(SearchDTO searchDTO) {
        return adminMapper.selectSalesDetailCount(searchDTO);
    }

    public List<OrderDTO> getSalesListForExport(Map<String, Object> param) {
        return adminMapper.selectSalesListForExport(param);
    }

    public List<MemberDTO> selectTeacherWithoutTeacherProfile(TeacherPageDTO teacherPageDTO) {
        return adminMapper.selectTeacherWithoutTeacherProfile(teacherPageDTO);
    }

    public List<MemberDTO> selectTeacherWithTeacherProfile(TeacherPageDTO teacherPageDTO) {
        return adminMapper.selectTeacherWithTeacherProfile(teacherPageDTO);
    }

    public int selectTeacherWithoutTeacherProfileCount(TeacherPageDTO teacherPageDTO) {
        return adminMapper.selectTeacherWithoutTeacherProfileCount(teacherPageDTO);
    }

    public int selectTeacherWithTeacherProfileCount(TeacherPageDTO teacherPageDTO) {
        return adminMapper.selectTeacherWithTeacherProfileCount(teacherPageDTO);
    }

    public int modifyTeacherProfile(TeacherDTO teacherDTO) {
        return adminMapper.modifyTeacherProfile(modelMapper.map(teacherDTO, TeacherVO.class));
    }

    public int deleteTeacher(String teacherId) {
        return adminMapper.deleteTeacher(teacherId);
    }

    public int restoreTeacher(String teacherId) {
        return adminMapper.restoreTeacher(teacherId);
    }

    public int updateLecture(LectureDTO lectureDTO) {
        return adminMapper.updateLecture(modelMapper.map(lectureDTO, LectureVO.class));
    }

    public int deleteLecture(int lectureIdx) {
        return adminMapper.deleteLecture(lectureIdx);
    }

    public int restoreLecture(int lectureIdx) {
        return adminMapper.restoreLecture(lectureIdx);
    }

    public int deleteChapter(int chapterIdx) {
        return adminMapper.deleteChapter(chapterIdx);
    }
    public int restoreChapter(int chapterIdx) {
        return adminMapper.restoreChapter(chapterIdx);
    }

    public boolean existsByLectureId(int lectureIdx) {
        return adminMapper.existsByLectureId(lectureIdx) > 1 ? true : false;
    }

    public int updateChapter(ChapterDTO chapterDTO) {
        return adminMapper.updateChapter(modelMapper.map(chapterDTO, ChapterVO.class));
    }

    public List<PostDTO> selectReportedPosts(PostPageDTO postPageDTO) {
        return adminMapper.selectReportedPosts(postPageDTO);
    }

    public int selectReportedPostsCount(PostPageDTO postPageDTO) {
        return adminMapper.selectReportedPostsCount(postPageDTO);
    }

    public PostDTO selectPostByIdx(int postIdx) {
        return adminMapper.selectPostByIdx(postIdx);
    }

    public int deletePostByAdmin(int postIdx) {
        return adminMapper.deletePostByAdmin(postIdx);
    }

    public int updateReportState(PostReportDTO reportDTO) {
        return adminMapper.updateReportState(modelMapper.map(reportDTO, ReportVO.class));
    }
}
