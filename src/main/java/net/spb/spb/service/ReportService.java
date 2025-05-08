package net.spb.spb.service;

import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.dto.pagingsearch.ReportPageDTO;
import net.spb.spb.mapper.ReportMapper;
import org.apache.ibatis.annotations.Param;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {
    @Autowired
    private ReportMapper reportMapper;

    public List<PostReportDTO> listBoardReport(SearchDTO searchDTO, PageRequestDTO pageRequestDTO) {
        return reportMapper.listBoardReport(searchDTO, pageRequestDTO);
    }

    public int boardReportTotalCount(SearchDTO searchDTO) {
        return reportMapper.boardReportTotalCount(searchDTO);
    }

    public List<PostReportDTO> listReviewReport(SearchDTO searchDTO, PageRequestDTO pageRequestDTO) {
        return reportMapper.listReviewReport(searchDTO, pageRequestDTO);
    }

    public int reviewReportTotalCount(SearchDTO searchDTO) {
        return reportMapper.reviewReportTotalCount(searchDTO);
    }
}
