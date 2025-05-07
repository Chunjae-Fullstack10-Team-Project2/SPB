package net.spb.spb.mapper.mystudy;

import net.spb.spb.dto.mystudy.StudentLectureDTO;
import net.spb.spb.dto.pagingsearch.StudentLecturePageDTO;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface StudentLectureMapper {
    public List<StudentLectureDTO> getStudentLectureList(@Param("memberId") String memberId, @Param("pageDTO") StudentLecturePageDTO pageDTO);

    public int getStudentLectureTotalCount(@Param("memberId") String memberId, @Param("pageDTO") StudentLecturePageDTO pageDTO);

    public LocalDateTime getLastWatchDate(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);
    public int getLectureProgress(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);
}