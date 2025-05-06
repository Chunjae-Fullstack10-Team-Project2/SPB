package net.spb.spb.service;

import net.spb.spb.dto.PostReportDTO;
import net.spb.spb.dto.ReportPageDTO;
import net.spb.spb.mapper.ReportMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {
    @Autowired
    private ReportMapper reportMapper;
    @Autowired
    private ModelMapper modelMapper;
    public List<PostReportDTO> getReports(ReportPageDTO reportPageDTO) {
        return reportMapper.getReports(reportPageDTO).stream().map(reportVO -> modelMapper.map(reportVO, PostReportDTO.class)).toList();
    }
}
