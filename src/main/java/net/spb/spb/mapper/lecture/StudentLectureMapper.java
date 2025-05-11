package net.spb.spb.mapper.lecture;

import net.spb.spb.dto.lecture.StudentLectureResponseDTO;
import net.spb.spb.dto.pagingsearch.StudentLecturePageDTO;

import java.time.LocalDateTime;
import java.util.List;

public interface StudentLectureMapper {
    public List<StudentLectureResponseDTO> getStudentLectureList(String memberId, StudentLecturePageDTO pageDTO);

    public int getStudentLectureTotalCount(String memberId, StudentLecturePageDTO pageDTO);
    public int getLectureProgress(String memberId, int lectureIdx);
    public LocalDateTime getLastWatchDate(String memberId, int lectureIdx);

    public boolean isLectureRegisteredByMemberId(String memberId, int lectureIdx);
}