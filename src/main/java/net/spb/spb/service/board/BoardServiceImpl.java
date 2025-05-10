package net.spb.spb.service.board;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.FileVO;
import net.spb.spb.domain.PostCommentVO;
import net.spb.spb.domain.ReportVO;
import net.spb.spb.domain.PostVO;
import net.spb.spb.dto.*;
import net.spb.spb.dto.post.PostCommentDTO;
import net.spb.spb.dto.post.PostDTO;
import net.spb.spb.dto.pagingsearch.PostPageDTO;
import net.spb.spb.dto.post.PostReportDTO;
import net.spb.spb.mapper.BoardFileMapper;
import net.spb.spb.mapper.BoardMapper;
import net.spb.spb.mapper.CommentMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Log4j2
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardServiceIf {

    private final BoardMapper boardMapper;
    private final ModelMapper modelMapper;
    private final CommentMapper commentMapper;
    private final BoardFileMapper boardFileMapper;

    @Override
    public int insertPost(PostDTO dto) {
        PostVO vo = modelMapper.map(dto, PostVO.class);
        boardMapper.insertPost(vo);
        return vo.getPostIdx();
    }

    @Override
    public int modifyPost(PostDTO dto) {
        PostVO vo = modelMapper.map(dto, PostVO.class);
        return boardMapper.modifyPost(vo);
    }

    @Override
    public int deletePost(int postIdx) {
        return boardMapper.deletePost(postIdx);
    }

    @Override
    public List<PostDTO> getPosts(PostPageDTO postPageDTO) {
        return boardMapper.getPosts(postPageDTO);
    }

    @Override
    public PostDTO getPostByIdx(int postIdx) {
        PostDTO dto = boardMapper.getPostByIdx(postIdx);
        List<FileVO> postFileVOs = boardFileMapper.selectFile(postIdx);
        dto.setPostFiles(postFileVOs.stream().map(vo->modelMapper.map(vo, FileDTO.class)).collect(Collectors.toList()));
        return dto;
    }

    @Override
    public PostDTO getPostByIdx(HashMap<String, Object> param) {
        PostDTO dto = boardMapper.getPostByIdxWithLike(param);
        List<PostCommentVO> postCommentVOs = commentMapper.selectComments((int)param.get("postIdx"));
        List<FileVO> postFileVOs = boardFileMapper.selectFile((int)param.get("postIdx"));
        dto.setPostComments(
                postCommentVOs.stream().map(vo -> modelMapper.map(vo, PostCommentDTO.class)).collect(Collectors.toList()));
        List<String> imageExts = List.of("jpg", "jpeg", "png", "gif", "webp");
        dto.setPostFiles(postFileVOs.stream().map(vo -> {
            FileDTO file = modelMapper.map(vo, FileDTO.class);
            String ext = file.getFileExt().toLowerCase().replace(".", "");
            file.setImage(imageExts.contains(ext));
            return file;
        }).collect(Collectors.toList()));
        return dto;
    }

    @Override
    public int getPostCount(PostPageDTO postPageDTO) {
        return boardMapper.getPostCount(postPageDTO);
    }

    @Override
    public int setReadCnt(int postIdx) {
        return boardMapper.setReadCnt(postIdx);
    }

    @Override
    public int insertPostReport(PostReportDTO postReportDTO) {
        return boardMapper.insertPostReport(modelMapper.map(postReportDTO, ReportVO.class));
    }
}