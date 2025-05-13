package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.FileVO;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.mapper.FileMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Log4j2
public class FileService {

    private final ModelMapper modelMapper;
    private final FileMapper fileMapper;

    public int insertFile(FileDTO dto) {
        FileVO vo = modelMapper.map(dto, FileVO.class);
        int rtnResult = fileMapper.insertFile(vo);
        int fileIdx = 0;
        fileIdx = vo.getFileIdx();
        return fileIdx;
    }

    public int deleteFile(int fileIdx) {
        return fileMapper.deleteFile(fileIdx);
    }

    public int deleteFileByFileName(String fileName) {
        return fileMapper.deleteFileByFileName(fileName);
    }

    public FileDTO getFileByIdx(int idx) { return modelMapper.map(fileMapper.selectFileByIdx(idx), FileDTO.class); }
}
