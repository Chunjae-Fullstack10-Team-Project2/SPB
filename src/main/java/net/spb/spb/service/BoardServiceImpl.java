package net.spb.spb.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.FileVO;
import net.spb.spb.domain.PostCommentVO;
import net.spb.spb.domain.PostVO;
import net.spb.spb.dto.FileDTO;
import net.spb.spb.dto.PostCommentDTO;
import net.spb.spb.dto.PostDTO;
import net.spb.spb.dto.PostPageDTO;
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
public class BoardServiceImpl implements BoardServiceIf{

    private final BoardMapper boardMapper;
    private final ModelMapper modelMapper;
    private final CommentMapper commentMapper;
    private final BoardFileMapper boardFileMapper;
    /**
     * @param dto
     * @return
     */
    @Override
    public int insertPost(PostDTO dto) {
        PostVO vo = modelMapper.map(dto, PostVO.class);
        int rtnResult = boardMapper.insertPost(vo);
        int postIdx = 0;
        log.info("=============================");
        log.info("BoardServiceImpl  >>  insertPost");
        log.info("vo: " + vo);
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        postIdx = vo.getPostIdx();
        log.info("postIdx: " + postIdx);
        log.info("=============================");
        return postIdx;
    }

    /**
     * @param dto
     * @return
     */
    @Override
    public int modifyPost(PostDTO dto) {
        PostVO vo = modelMapper.map(dto, PostVO.class);
        int rtnResult = boardMapper.modifyPost(vo);
        log.info("=============================");
        log.info("BoardServiceImpl  >>  modifyPost");
        log.info("vo: " + vo);
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @param postIdx
     * @return
     */
    @Override
    public int deletePost(int postIdx) {
        int rtnResult = boardMapper.deletePost(postIdx);
        log.info("=============================");
        log.info("BoardServiceImpl  >>  deletePost");
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @return
     */
    @Override
    public List<PostDTO> getPosts(PostPageDTO dto) {
        List<PostVO> vos = boardMapper.getPosts(dto);
        List<PostDTO> dtos = vos.stream().map(vo -> modelMapper.map(vo, PostDTO.class)).collect(Collectors.toList());
        log.info("=============================");
        log.info("BoardServiceImpl  >>  getPosts");
        log.info(dtos);
        log.info("=============================");
        return dtos;
    }

    /**
     * @param postIdx
     * @return
     */
    @Override
    public PostDTO getPostByIdx(int postIdx) {
        PostDTO dto = modelMapper.map(boardMapper.getPostByIdx(postIdx), PostDTO.class);
        List<FileVO> postFileVOs = boardFileMapper.selectFile(postIdx);
        dto.setPostFiles(postFileVOs.stream().map(vo->modelMapper.map(vo, FileDTO.class)).collect(Collectors.toList()));
        log.info("=============================");
        log.info("BoardServiceImpl  >>  getPostByIdx");
        log.info(dto);
        log.info("=============================");
        return dto;
    }

    /**
     * @param param
     * @return
     */
    @Override
    public PostDTO getPostByIdx(HashMap<String, Object> param) {
        PostDTO dto = modelMapper.map(boardMapper.getPostByIdxWithLike(param), PostDTO.class);
        List<PostCommentVO> postCommentVOs = commentMapper.selectComments((int)param.get("postIdx"));
        List<FileVO> postFileVOs = boardFileMapper.selectFile((int)param.get("postIdx"));
        dto.setPostComments(
                postCommentVOs.stream().map(vo -> modelMapper.map(vo, PostCommentDTO.class)).collect(Collectors.toList()));
        dto.setPostFiles(postFileVOs.stream().map(vo->modelMapper.map(vo, FileDTO.class)).collect(Collectors.toList()));
        log.info("=============================");
        log.info("BoardServiceImpl  >>  getPostByIdx");
        log.info(dto);
        log.info("=============================");
        return dto;
    }

    /**
     * @param postPageDTO
     * @return
     */
    @Override
    public int getPostCount(PostPageDTO postPageDTO) {
        return boardMapper.getPostCount(postPageDTO);
    }
}