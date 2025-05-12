package net.spb.spb.service.lecture;

import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;

import java.util.List;

public interface LectureServiceIf {
    public LectureDTO selectLectureMain(int lectureIdx);
    public List<ChapterDTO> selectLectureChapter(int lectureIdx);
    public int addBookmark(int lectureIdx, String memberId);
    public int deleteBookmark(int lectureIdx, String memberId);
    public ChapterDTO getChapterById(int chapterIdx);
    public boolean checkLecturePermission(String memberId, int lectureIdx);
    public boolean isLectureOwner(String memberId, int lectureIdx);
    public List<LectureDTO> getAllLectures(SearchDTO searchDTO, PageRequestDTO pageRequestDTO);
    public int getTotalCount(SearchDTO searchDTO, String subject);
    public List<LectureDTO> getLectureMain(String subject, SearchDTO searchDTO, PageRequestDTO pageRequestDTO);
}
