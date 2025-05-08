package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.ChapterVO;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.mapper.TeacherMapper;
import org.apache.ibatis.annotations.Param;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Log4j2
@Transactional
@RequiredArgsConstructor
public class TeacherServiceImpl implements TeacherServiceIf {

    private final TeacherMapper teacherMapper;
    private final ModelMapper modelMapper;

    @Override
    public TeacherDTO selectTeacher(String teacherId) {
        TeacherVO teacherVO = teacherMapper.selectTeacher(teacherId);
        TeacherDTO teacherDTO = modelMapper.map(teacherVO, TeacherDTO.class);
        return teacherDTO;
    }

    @Override
    public List<LectureDTO> selectTeacherLecture(String teacherId) {
        List<LectureVO> lectureVOList = teacherMapper.selectTeacherLecture(teacherId);
        List<LectureDTO> lectureDTOList =
                lectureVOList.stream().map(
                                lectureVO -> modelMapper.map(lectureVO, LectureDTO.class))
                        .collect(Collectors.toList());
        return lectureDTOList;
    }

    @Override
    public LectureDTO selectLectureMain(int lectureIdx) {
        LectureVO lectureVO = teacherMapper.selectLectureMain(lectureIdx);
        LectureDTO lectureDTO = modelMapper.map(lectureVO, LectureDTO.class);
        return lectureDTO;
    }

    @Override
    public List<ChapterDTO> selectLectureChapter(int lectureIdx) {
        List<ChapterVO> chapterVOList = teacherMapper.selectLectureChapter(lectureIdx);
        List<ChapterDTO> chapterDTOList =
                chapterVOList.stream().map(
                        chapterVO -> modelMapper.map(chapterVO, ChapterDTO.class))
                        .collect(Collectors.toList());
        return chapterDTOList;
    }

    @Override
    public List<TeacherDTO> getTeacherMain(String subject, SearchDTO searchDTO, PageRequestDTO pageRequestDTO) {
        List<TeacherVO> teacherVOList = teacherMapper.getTeacherMain(subject, searchDTO, pageRequestDTO);
        List<TeacherDTO> teacherDTOList =
                teacherVOList.stream().map(
                        teacherVO -> modelMapper.map(teacherVO, TeacherDTO.class))
                        .collect(Collectors.toList());
        return teacherDTOList;
    }

    @Override
    public List<TeacherDTO> getAllTeacher(SearchDTO searchDTO, PageRequestDTO pageRequestDTO){
        List<TeacherVO> teacherVOList = teacherMapper.getAllTeacher(searchDTO, pageRequestDTO);
        List<TeacherDTO> teacherDTOList =
                teacherVOList.stream().map(
                                teacherVO -> modelMapper.map(teacherVO, TeacherDTO.class))
                        .collect(Collectors.toList());
        return teacherDTOList;
    }

    @Override
    public int addBookmark(int lectureIdx, String memberId) {
        return teacherMapper.addBookmark(lectureIdx, memberId);
    }

    @Override
    public int deleteBookmark(int lectureIdx, String memberId) {
        return teacherMapper.deleteBookmark(lectureIdx, memberId);
    }

    @Override
    public List<Integer> selectBookmark(String teacherId, String memberId) {
        return teacherMapper.selectBookmark(teacherId, memberId);
    }

    @Override
    public int getTotalCount(SearchDTO searchDTO, String subject) {
        return teacherMapper.getTotalCount(searchDTO, subject);
    }

    @Override
    public List<String> getAllSubject() {
        return teacherMapper.getAllSubject();
    }
}
