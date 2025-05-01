package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import net.spb.spb.domain.PostFileVO;
import net.spb.spb.dto.PostFileDTO;
import net.spb.spb.mapper.BoardFileMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class BoardFileService {
    private final BoardFileMapper boardFileMapper;
    private final ModelMapper modelMapper;

    public int insertBoardFile(PostFileDTO dto) {
        PostFileVO vo = modelMapper.map(dto, PostFileVO.class);
        int rtnResult = boardFileMapper.insertPostFile(vo);
        return rtnResult;
    }

    public int deleteBoardFileByFileIdx(int fileIdx) {
        int rtnResult = boardFileMapper.deletePostFileByFileIdx(fileIdx);
        return rtnResult;
    }

}
