package net.spb.spb.service;

import net.spb.spb.dto.NoticeDTO;

import java.time.LocalDate;
import java.util.List;

public interface NoticeService {
    List<NoticeDTO> getList() throws Exception;

    NoticeDTO getDetail(int noticeIdx) throws Exception;

    void register(NoticeDTO dto) throws Exception;

    void update(NoticeDTO dto) throws Exception;

    void delete(int noticeIdx) throws Exception;

    int getTotalCount() throws Exception;

    List<NoticeDTO> getListPaged(int offset, int size) throws Exception;


    void fixNotice(int noticeIdx);

    void unfixNotice(int noticeIdx);


    int getSearchCount(String keyword) throws Exception;
    List<NoticeDTO> searchList(String keyword, int offset, int size) throws Exception;

    int getSearchCountByTitle(String keyword) throws Exception;
    List<NoticeDTO> searchByTitle(String keyword, int offset, int size) throws Exception;

    int getSearchCountByContent(String keyword) throws Exception;
    List<NoticeDTO> searchByContent(String keyword, int offset, int size) throws Exception;

    List<NoticeDTO> getFixedNotices() throws Exception;

    // 날짜 범위로 검색
    int getCountByDateRange(LocalDate startDate, LocalDate endDate) throws Exception;
    List<NoticeDTO> getListByDateRange(LocalDate startDate, LocalDate endDate, int offset, int size) throws Exception;

    // 날짜 범위와 제목으로 검색
    int getCountByDateRangeAndTitle(LocalDate startDate, LocalDate endDate, String keyword) throws Exception;
    List<NoticeDTO> getListByDateRangeAndTitle(LocalDate startDate, LocalDate endDate, String keyword, int offset, int size) throws Exception;

    // 날짜 범위와 내용으로 검색
    int getCountByDateRangeAndContent(LocalDate startDate, LocalDate endDate, String keyword) throws Exception;
    List<NoticeDTO> getListByDateRangeAndContent(LocalDate startDate, LocalDate endDate, String keyword, int offset, int size) throws Exception;
}


