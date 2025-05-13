package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import net.spb.spb.domain.NoticeVO;
import net.spb.spb.dto.NoticeDTO;
import net.spb.spb.mapper.NoticeMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;

    @Override
    public List<NoticeDTO> getList() throws Exception {
        return noticeMapper.selectAll()
                .stream()
                .map(NoticeDTO::new)
                .collect(Collectors.toList());
    }

    @Override
    public NoticeDTO getDetail(int noticeIdx) throws Exception {
        return new NoticeDTO(noticeMapper.selectOne(noticeIdx));
    }

    @Override
    @Transactional
    public void register(NoticeDTO dto) throws Exception {
        noticeMapper.insert(dto.toVO());
    }

    @Override
    @Transactional
    public void update(NoticeDTO dto) throws Exception {
        noticeMapper.update(dto.toVO());
    }

    @Override
    @Transactional
    public void delete(int noticeIdx) throws Exception {
        noticeMapper.delete(noticeIdx);
    }

    @Override
    public int getTotalCount() throws Exception {
        return noticeMapper.getTotalCount();
    }

    @Override
    public List<NoticeDTO> getListPaged(int offset, int size) throws Exception {
        return noticeMapper.getListPaged(offset, size)
                .stream()
                .map(NoticeDTO::new)
                .collect(Collectors.toList());
    }
    

    @Override
    @Transactional
    public void fixNotice(int noticeIdx) {
        noticeMapper.fixNotice(noticeIdx);
    }

    @Override
    @Transactional
    public void unfixNotice(int noticeIdx) {
        noticeMapper.unfixNotice(noticeIdx);
    }


    @Override
    public int getSearchCount(String keyword) throws Exception {
        return noticeMapper.getSearchCount(keyword);
    }

    @Override
    public List<NoticeDTO> searchList(String keyword, int offset, int size) throws Exception {
        return noticeMapper.searchList(keyword, offset, size)
                .stream()
                .map(NoticeDTO::new)
                .collect(Collectors.toList());
    }

    @Override
    public int getSearchCountByTitle(String keyword) {
        return noticeMapper.getSearchCountByTitle(keyword);
    }

    @Override
    public List<NoticeDTO> searchByTitle(String keyword, int offset, int size) {
        return noticeMapper.searchByTitle(keyword, offset, size).stream().map(NoticeDTO::new).collect(Collectors.toList());
    }

    @Override
    public int getSearchCountByContent(String keyword) {
        return noticeMapper.getSearchCountByContent(keyword);
    }

    @Override
    public List<NoticeDTO> searchByContent(String keyword, int offset, int size) {
        return noticeMapper.searchByContent(keyword, offset, size).stream().map(NoticeDTO::new).collect(Collectors.toList());
    }

    @Override
    public List<NoticeDTO> getFixedNotices() throws Exception {
        List<NoticeVO> fixedNotices = noticeMapper.getFixedNotices();
        return fixedNotices.stream().map(notice -> {
            NoticeDTO dto = new NoticeDTO();
            dto.setNoticeIdx(notice.getNoticeIdx());
            dto.setNoticeTitle(notice.getNoticeTitle());
            dto.setNoticeContent(notice.getNoticeContent());
            dto.setNoticeMemberId(notice.getNoticeMemberId());
            dto.setNoticeIsFixed(notice.getNoticeIsFixed());
            dto.setNoticeCreatedAt(notice.getNoticeCreatedAt());
            dto.setNoticeUpdatedAt(notice.getNoticeUpdatedAt());
            return dto;
        }).collect(Collectors.toList());
    }

    // 날짜 범위로 검색
    @Override
    public int getCountByDateRange(LocalDate startDate, LocalDate endDate) throws Exception {
        return noticeMapper.getCountByDateRange(startDate, endDate);
    }

    @Override
    public List<NoticeDTO> getListByDateRange(LocalDate startDate, LocalDate endDate, int offset, int size) throws Exception {
        return noticeMapper.getListByDateRange(startDate, endDate, offset, size)
                .stream()
                .map(NoticeDTO::new)
                .collect(Collectors.toList());
    }

    // 날짜 범위와 제목으로 검색
    @Override
    public int getCountByDateRangeAndTitle(LocalDate startDate, LocalDate endDate, String keyword) throws Exception {
        return noticeMapper.getCountByDateRangeAndTitle(startDate, endDate, keyword);
    }

    @Override
    public List<NoticeDTO> getListByDateRangeAndTitle(LocalDate startDate, LocalDate endDate, String keyword, int offset, int size) throws Exception {
        return noticeMapper.getListByDateRangeAndTitle(startDate, endDate, keyword, offset, size)
                .stream()
                .map(NoticeDTO::new)
                .collect(Collectors.toList());
    }

    // 날짜 범위와 내용으로 검색
    @Override
    public int getCountByDateRangeAndContent(LocalDate startDate, LocalDate endDate, String keyword) throws Exception {
        return noticeMapper.getCountByDateRangeAndContent(startDate, endDate, keyword);
    }

    @Override
    public List<NoticeDTO> getListByDateRangeAndContent(LocalDate startDate, LocalDate endDate, String keyword, int offset, int size) throws Exception {
        return noticeMapper.getListByDateRangeAndContent(startDate, endDate, keyword, offset, size)
                .stream()
                .map(NoticeDTO::new)
                .collect(Collectors.toList());
    }

}