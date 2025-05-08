package net.spb.spb.mapper;

import net.spb.spb.domain.ReportVO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.ReportPageDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.post.PostReportDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReportMapper {
    List<PostReportDTO> listBoardReport(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO);

    int boardReportTotalCount(@Param("searchDTO") SearchDTO searchDTO);

    List<PostReportDTO> listReviewReport(@Param("searchDTO") SearchDTO searchDTO, @Param("pageDTO") PageRequestDTO pageDTO);

    int reviewReportTotalCount(@Param("searchDTO") SearchDTO searchDTO);
}
