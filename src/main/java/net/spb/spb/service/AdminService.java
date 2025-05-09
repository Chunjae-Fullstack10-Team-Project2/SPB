package net.spb.spb.service;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
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

    public int insertTeacher(TeacherDTO teacherDTO) {
        return adminMapper.insertTeacher(modelMapper.map(teacherDTO, TeacherVO.class));
    }

    public List<LectureDTO> selectLecture(LecturePageDTO lecturePageDTO) {
        return adminMapper.selectLecture(lecturePageDTO);
    }

    public int selectLectureCount(LecturePageDTO lecturePageDTO) {
        return adminMapper.selectLectureCount(lecturePageDTO);
    }

    public List<Map<String, Object>> getMonthlySales() {
        return adminMapper.selectMonthlySalesDefault(); // 초기 JSP용 (기본 월별)
    }

    public List<Map<String, Object>> getMonthlySales(String timeType) {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", timeType);
        return adminMapper.selectMonthlySales(param);
    }

    public List<Map<String, Object>> getLectureSales() {
        return adminMapper.selectLectureSalesDefault(); // 초기 JSP용
    }

    public List<Map<String, Object>> getLectureSales(String timeType, String startDate, String endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", timeType);
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return adminMapper.selectLectureSales(param);
    }

}
