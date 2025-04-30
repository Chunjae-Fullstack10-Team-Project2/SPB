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

    private final FileMapper fileMapper;
    private final ModelMapper modelMapper;

    public int insertFile(FileDTO dto) {
        FileVO vo = modelMapper.map(dto, FileVO.class);
        int rtnResult = fileMapper.insertFile(vo);
        int fileIdx = 0;
        log.info("=============================");
        log.info("FileService  >>  insertFile");
        log.info("rtnResult: "+rtnResult);
        log.info("vo: "+vo);
        log.info("dto: "+dto);
        fileIdx = vo.getFileIdx();
        log.info("fileIdx: "+fileIdx);
        log.info("=============================");
        return fileIdx;
    }

    public int deleteFile(int fileIdx) {
        int rtnResult = fileMapper.deleteFile(fileIdx);
        log.info("=============================");
        log.info("FileService  >>  deleteFile");
        log.info("rtnResult: "+rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    public int deleteFileByFileName(String fileName) {
        int rtnResult = fileMapper.deleteFileByFileName(fileName);
        return rtnResult;
    }

}
