package net.spb.spb.service;

import net.spb.spb.domain.LectureVO;
import net.spb.spb.dto.LectureDTO;
import net.spb.spb.mapper.AdminMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminService {
    @Autowired
    private AdminMapper adminMapper;
    @Autowired
    private ModelMapper modelMapper;

    public int insertLecture(LectureDTO lectureDTO) {
        return adminMapper.insertLecture(modelMapper.map(lectureDTO, LectureVO.class));
    }

}
