package net.spb.spb.service;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
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

    // 기본 조회 (timeType = "MONTH", 전체 기간)
    public List<Map<String, Object>> getMonthlySales() {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", "MONTH");
        return adminMapper.selectMonthlySales(param);
    }

    // 조건 기반 조회 (timeType, startDate, endDate)
    public List<Map<String, Object>> getMonthlySales(String timeType, String startDate, String endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", timeType);
        if (startDate != null && !startDate.isEmpty()) param.put("startDate", startDate);
        if (endDate != null && !endDate.isEmpty()) param.put("endDate", endDate);
        return adminMapper.selectMonthlySales(param);
    }

    // 🟢 초기 대시보드용 - 전체 강좌 매출
    public List<Map<String, Object>> getLectureSales() {
        return adminMapper.selectLectureSalesDefault();
    }

    // 🟢 조건 기반 강좌 매출 (날짜 필터 사용)
    public List<Map<String, Object>> getLectureSales(String timeType, String startDate, String endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("timeType", timeType); // 현재 사용 X → XML에서 필요하면 추가
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return adminMapper.selectLectureSales(param);
    }

    // 🟢 개별 거래 목록
    public List<OrderDTO> getSalesDetailList(SearchDTO searchDTO, PageRequestDTO pageDTO) {
        return adminMapper.selectSalesDetailList(searchDTO, pageDTO);
    }

    // 🟢 거래 수 조회
    public int getSalesDetailCount(SearchDTO searchDTO) {
        return adminMapper.selectSalesDetailCount(searchDTO);
    }

}
