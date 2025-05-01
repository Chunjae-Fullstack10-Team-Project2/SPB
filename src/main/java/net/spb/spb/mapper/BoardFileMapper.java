package net.spb.spb.mapper;

import net.spb.spb.domain.FileVO;
import net.spb.spb.domain.PostFileVO;

import java.util.List;

public interface BoardFileMapper {
    int insertPostFile(PostFileVO vo);
    int deletePostFile(int postFileIdx);
    int deletePostFileByFileIdx(int fileIdx);
    List<FileVO> selectFile(int postIdx);
}
