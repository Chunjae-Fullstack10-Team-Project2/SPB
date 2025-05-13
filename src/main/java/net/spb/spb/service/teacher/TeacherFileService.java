package net.spb.spb.service.teacher;

import lombok.RequiredArgsConstructor;
import net.spb.spb.domain.FileVO;
import net.spb.spb.domain.TeacherFileVO;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.dto.pagingsearch.TeacherFilePageDTO;
import net.spb.spb.dto.teacher.TeacherFileDTO;
import net.spb.spb.dto.teacher.TeacherFileResponseDTO;
import net.spb.spb.mapper.TeacherFileMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TeacherFileService implements TeacherFileServiceIf {

    private final ModelMapper modelMapper;
    private final TeacherFileMapper teacherFileMapper;

    @Override
    public int createTeacherFile(TeacherFileDTO dto) {
        TeacherFileVO vo = modelMapper.map(dto, TeacherFileVO.class);
        return teacherFileMapper.insertTeacherFile(vo);
    }

    @Override
    public List<TeacherFileResponseDTO> getTeacherFileList(String teacherId, TeacherFilePageDTO pageDTO) {
        int totalCount = teacherFileMapper.selectTeacherFileListTotalCount(teacherId, pageDTO);
        pageDTO.setTotal_count(totalCount);

        List<TeacherFileVO> voList = teacherFileMapper.selectTeacherFileList(teacherId, pageDTO);
        return voList.stream().map( vo -> {
            TeacherFileResponseDTO dto = modelMapper.map(vo, TeacherFileResponseDTO.class);
            FileVO file = teacherFileMapper.selectFileByIdx(vo.getTeacherFileIdx());
            dto.setFileDTO(modelMapper.map(file, FileDTO.class));
            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    public TeacherFileResponseDTO getTeacherFileByIdx(int idx) {
        TeacherFileResponseDTO dto = teacherFileMapper.selectTeacherFileByIdx(idx);
        FileVO file = teacherFileMapper.selectFileByIdx(idx);
        dto.setFileDTO(modelMapper.map(file, FileDTO.class));
        return dto;
    }

    @Override
    public int deleteTeacherFileByIdx(int idx) {
        return teacherFileMapper.deleteTeacherFileByIdx(idx);
    }

    @Override
    public FileDTO getFileByIdx(int idx) {
        return modelMapper.map(teacherFileMapper.selectFileByIdx(idx), FileDTO.class);
    }
}
