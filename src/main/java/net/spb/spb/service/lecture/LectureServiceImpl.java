package net.spb.spb.service.lecture;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.LectureVO;
import net.spb.spb.domain.TeacherVO;
import net.spb.spb.dto.ChapterDTO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.dto.TeacherDTO;
import net.spb.spb.dto.lecture.LectureReviewDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.mapper.lecture.LectureMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

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

    @Override
    public List<LectureDTO> getAllLectures(SearchDTO searchDTO, PageRequestDTO pageRequestDTO) {
        return lectureMapper.getAllLecture(searchDTO, pageRequestDTO);
    }

    @Override
    public int getTotalCount(SearchDTO searchDTO, String subject) {
        return lectureMapper.getTotalCount(searchDTO, subject);
    }

    @Override
    public List<LectureDTO> getLectureMain(String subject, SearchDTO searchDTO, PageRequestDTO pageRequestDTO) {
        return lectureMapper.getLectureMain(subject, searchDTO, pageRequestDTO);
    }

    @Override
    public List<LectureReviewDTO> selectLectureReview(int lectureIdx, PageRequestDTO pageRequestDTO) {
        return lectureMapper.selectLectureReview(lectureIdx, pageRequestDTO);
    }

    @Override
    public int insertReport(PostReportDTO postReportDTO) {
        return lectureMapper.insertReport(postReportDTO);
    }

    @Override
    public List<Integer> selectBookmark(List<Integer> lectureIdxList, String memberId) {
        return lectureMapper.selectBookmark(lectureIdxList, memberId);
    }

    @Override
    public LectureDTO getLectureByIdx(int lectureIdx) {
        LectureVO vo = lectureMapper.selectLectureByIdx(lectureIdx);
        return modelMapper.map(vo, LectureDTO.class);
    }
}
