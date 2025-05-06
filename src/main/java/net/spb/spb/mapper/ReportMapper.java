package net.spb.spb.mapper;

import net.spb.spb.domain.ReportVO;
import net.spb.spb.dto.ReportPageDTO;

import java.util.List;

public interface ReportMapper {
    List<ReportVO> getReports(ReportPageDTO reportPageDTO);
}
