package net.spb.spb.mapper.lecture;

import net.spb.spb.domain.LectureVO;
import net.spb.spb.dto.ChapterDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LectureMapper {

    public LectureVO selectLectureMain(int lectureIdx);
    public List<ChapterDTO> selectLectureChapter(int lectureIdx);
    public int addBookmark(@Param("lectureIdx")int lectureIdx, @Param("memberId")String memberId);
    public int deleteBookmark(@Param("lectureIdx")int lectureIdx, @Param("memberId")String memberId);
    public ChapterDTO getChapterById(@Param("chapterIdx") int chapterIdx);
}
