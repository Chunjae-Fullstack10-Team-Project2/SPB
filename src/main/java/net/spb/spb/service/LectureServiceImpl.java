package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.mapper.LectureMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("lectureService")
@Log4j2
@Transactional
@RequiredArgsConstructor
public class LectureServiceImpl implements LectureServiceIf {

    private final LectureMapper lectureMapper;
    private final ModelMapper modelMapper;

    @Override
    public LectureDTO selectLectureMain(int lectureIdx) {
        LectureVO lectureVO = lectureMapper.selectLectureMain(lectureIdx);
        LectureDTO lectureDTO = modelMapper.map(lectureVO, LectureDTO.class);
        return lectureDTO;
    }

    @Override
    public List<ChapterDTO> selectLectureChapter(int lectureIdx) {
        List<ChapterDTO> chapterDTOList = lectureMapper.selectLectureChapter(lectureIdx);
        return chapterDTOList;
    }

    @Override
    public int addBookmark(int lectureIdx, String memberId) {
        return lectureMapper.addBookmark(lectureIdx, memberId);
    }

    @Override
    public int deleteBookmark(int lectureIdx, String memberId) {
        return lectureMapper.deleteBookmark(lectureIdx, memberId);
    }

    @Override
    public ChapterDTO getChapterById(int chapterIdx) {
        return lectureMapper.getChapterById(chapterIdx);
    }

    @Override
    public boolean checkLecturePermission(String memberId, int lectureIdx) {
        Integer count = lectureMapper.countValidOrdersForMemberLecture(memberId, lectureIdx);
        return count != null && count > 0;
    }

    @Override
    public boolean isLectureOwner(String memberId, int lectureIdx) {
        return lectureMapper.isLectureOwner(memberId, lectureIdx) > 0;
    }
}
