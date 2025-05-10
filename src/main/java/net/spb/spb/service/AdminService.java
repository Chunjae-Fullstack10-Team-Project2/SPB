package net.spb.spb.service;

import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.LecturePageDTO;
import net.spb.spb.mapper.AdminMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.toList;

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

    public List<MemberDTO> selectTeacherWithoutTeacherProfile() {
        return adminMapper.selectTeacherWithoutTeacherProfile();
    }

    public List<MemberDTO> selectTeacherWithTeacherProfile() {
        return adminMapper.selectTeacherWithTeacherProfile();
    }

    public int modifyTeacherProfile(TeacherDTO teacherDTO) {
        return adminMapper.modifyTeacherProfile(modelMapper.map(teacherDTO, TeacherVO.class));
    }
}
