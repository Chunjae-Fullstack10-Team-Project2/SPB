package net.spb.spb.mapper;

import net.spb.spb.domain.FileVO;

public interface FileMapper {
    int insertFile(FileVO vo);
    int deleteFile(int fileIdx);
    int deleteFileByFileName(String fileName);
    FileVO selectFileByIdx(int Idx);
}
