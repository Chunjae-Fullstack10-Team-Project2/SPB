package net.spb.spb.service.mystudy;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.mystudy.StudentLectureDTO;
import net.spb.spb.dto.mystudy.StudentLecturePageDTO;
import net.spb.spb.mapper.mystudy.StudentLectureMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Log4j2
@Service
@Transactional
@RequiredArgsConstructor
public class StudentLectureService implements StudentLectureServiceIf {
    private final StudentLectureMapper studentLectureMapper;

    @Override
    public List<StudentLectureDTO> getStudentLectureList(String memberId) {
        return studentLectureMapper.getStudentLectureList(memberId);
    }

    @Override
    public List<StudentLectureDTO> getStudentLectureList(String memberId, StudentLecturePageDTO pageDTO) {
        return studentLectureMapper.getStudentLectureList(memberId, pageDTO);
    }

    @Override
    public int getStudentLectureTotalCount(String memberId, StudentLecturePageDTO pageDTO) {
        return studentLectureMapper.getStudentLectureTotalCount(memberId, pageDTO);
    }
}
