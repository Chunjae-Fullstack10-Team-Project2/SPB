package net.spb.spb.mapper;

import net.spb.spb.domain.NoticeVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface NoticeMapper {

    List<NoticeVO> selectAll();

    NoticeVO selectOne(int noticeIdx);

    void insert(NoticeVO vo);

    void update(NoticeVO vo);

    void delete(int noticeIdx);

    int getTotalCount();

    List<NoticeVO> getListPaged(@Param("offset") int offset, @Param("size") int size);

    void fixNotice(@Param("noticeIdx") int noticeIdx);
    void unfixNotice(@Param("noticeIdx") int noticeIdx);

    int getSearchCount(@Param("keyword") String keyword);
    List<NoticeVO> searchList(@Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);

    int getSearchCountByTitle(String keyword);
    List<NoticeVO> searchByTitle(@Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);

    int getSearchCountByContent(String keyword);
    List<NoticeVO> searchByContent(@Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);

    List<NoticeVO> getFixedNotices();

    // 날짜 범위로 검색
    int getCountByDateRange(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);
    List<NoticeVO> getListByDateRange(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate,
                                      @Param("offset") int offset, @Param("size") int size);

    // 날짜 범위와 제목으로 검색
    int getCountByDateRangeAndTitle(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate,
                                    @Param("keyword") String keyword);
    List<NoticeVO> getListByDateRangeAndTitle(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate,
                                              @Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);

    // 날짜 범위와 내용으로 검색
    int getCountByDateRangeAndContent(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate,
                                      @Param("keyword") String keyword);
    List<NoticeVO> getListByDateRangeAndContent(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate,
                                                @Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);
}



