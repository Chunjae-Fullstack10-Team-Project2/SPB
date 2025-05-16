package net.spb.spb.mapper.lecture;

import net.spb.spb.dto.lecture.LectureDTO;
import net.spb.spb.dto.lecture.StudentLectureResponseDTO;
import net.spb.spb.dto.pagingsearch.StudentLecturePageDTO;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface StudentLectureMapper {
    public List<LectureDTO> getStudentLectures(String memberId);
    public List<StudentLectureResponseDTO> getStudentLectureList(@Param("memberId") String memberId, @Param("pageDTO") StudentLecturePageDTO pageDTO);

    public int getStudentLectureTotalCount(@Param("memberId") String memberId, @Param("pageDTO") StudentLecturePageDTO pageDTO);
    public int getLectureProgress(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);
    public LocalDateTime getLastWatchDate(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);

    public boolean isLectureRegisteredByMemberId(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);
}