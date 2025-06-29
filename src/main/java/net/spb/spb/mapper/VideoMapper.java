package net.spb.spb.mapper;

import net.spb.spb.dto.LectureHistoryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface VideoMapper {
    public void saveProgress(@Param("dto") LectureHistoryDTO lectureHistoryDTO);
    public void updateProgress(@Param("dto") LectureHistoryDTO lectureHistoryDTO);
    public String getLastWatchedTime(@Param("lectureMemberId") String lectureMemberId, @Param("lectureHistoryChapterIdx") int lectureHistoryChapterIdx);
    public int countByMemberIdAndChapterIdx(@Param("lectureMemberId") String lectureMemberId, @Param("lectureHistoryChapterIdx") int lectureHistoryChapterIdx);
    public int purchaseConfirm(@Param("dto") LectureHistoryDTO lectureHistoryDTO);
}
