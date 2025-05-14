package net.spb.spb.service.lecture;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.LectureHistoryDTO;
import net.spb.spb.mapper.VideoMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Log4j2
@Transactional
@RequiredArgsConstructor
public class VideoServiceImpl implements VideoServiceIf{

    private final VideoMapper videoMapper;
    private final ModelMapper modelMapper;

    @Override
    public void saveProgress(LectureHistoryDTO lectureHistoryDTO) {
        log.info("lectureHistoryDTO: " + lectureHistoryDTO);
        videoMapper.saveProgress(lectureHistoryDTO);
    }

    @Override
    public void updateProgress(LectureHistoryDTO lectureHistoryDTO) {
        videoMapper.updateProgress(lectureHistoryDTO);
    }

    @Override
    public String getLastWatchedTime(String lectureMemberId, int lectureChapterIdx) {
        return videoMapper.getLastWatchedTime(lectureMemberId, lectureChapterIdx);
    }

    @Override
    public boolean existsByMemberIdAndChapterIdx(String lectureMemberId, int lectureHistoryChapterIdx) {
        return videoMapper.countByMemberIdAndChapterIdx(lectureMemberId, lectureHistoryChapterIdx) > 0;
    }

    @Override
    public void purchaseConfirm(LectureHistoryDTO lectureHistoryDTO) {
        videoMapper.purchaseConfirm(lectureHistoryDTO);
    }
}
