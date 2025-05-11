package net.spb.spb.mapper;

import net.spb.spb.domain.LectureVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LectureMapper {

    public LectureVO selectLectureMain(int lectureIdx);
    public List<ChapterDTO> selectLectureChapter(int lectureIdx);
    public int addBookmark(@Param("lectureIdx")int lectureIdx, @Param("memberId")String memberId);
    public int deleteBookmark(@Param("lectureIdx")int lectureIdx, @Param("memberId")String memberId);
    public ChapterDTO getChapterById(@Param("chapterIdx") int chapterIdx);
    public int countValidOrdersForMemberLecture(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);
    public int isLectureOwner(@Param("memberId") String memberId, @Param("lectureIdx") int lectureIdx);
}
