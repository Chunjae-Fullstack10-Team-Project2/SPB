package net.spb.spb.service;

import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;

import java.util.List;

public interface LectureServiceIf {
    public LectureDTO selectLectureMain(int lectureIdx);
    public List<ChapterDTO> selectLectureChapter(int lectureIdx);
    public int addBookmark(int lectureIdx, String memberId);
    public int deleteBookmark(int lectureIdx, String memberId);
    public ChapterDTO getChapterById(int chapterIdx);
}
