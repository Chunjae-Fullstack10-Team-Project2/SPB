package net.spb.spb.service.lecture;

import net.spb.spb.dto.LectureHistoryDTO;

public interface VideoServiceIf {
    public void saveProgress(LectureHistoryDTO lectureHistoryDTO);
    public void updateProgress(LectureHistoryDTO lectureHistoryDTO);
    public String getLastWatchedTime(String lectureMemberId, int lectureChapterIdx);
    public boolean existsByMemberIdAndChapterIdx(String lectureMemberId, int lectureHistoryChapterIdx);
    public void purchaseConfirm(LectureHistoryDTO lectureHistoryDTO);
}
