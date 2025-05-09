package net.spb.spb.service.board;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PostCommentVO;
import net.spb.spb.dto.post.PostCommentDTO;
import net.spb.spb.mapper.CommentMapper;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Log4j2
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentServiceIf {

    private final CommentMapper commentMapper;
    private final ModelMapper modelMapper;

    /**
     * @param dto
     * @return
     */
    @Override
    public int insertComment(PostCommentDTO dto) {
        PostCommentVO vo = modelMapper.map(dto, PostCommentVO.class);
        int rtnResult = commentMapper.insertComment(vo);
        log.info("=============================");
        log.info("CommentServiceImpl  >>  insertComment");
        log.info("vo: " + vo);
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @param dto
     * @return
     */
    @Override
    public int modifyComment(PostCommentDTO dto) {
        PostCommentVO vo = modelMapper.map(dto, PostCommentVO.class);
        int rtnResult = commentMapper.updateComment(vo);
        log.info("=============================");
        log.info("CommentServiceImpl  >>  updateComment");
        log.info("vo: " + vo);
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @param postCommentIdx
     * @return
     */
    @Override
    public int deleteComment(int postCommentIdx) {
        int rtnResult = commentMapper.deleteComment(postCommentIdx);
        log.info("=============================");
        log.info("CommentServiceImpl  >>  deleteComment");
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        return rtnResult;
    }

    /**
     * @param postCommentRefPostIdx
     * @return
     */
    @Override
    public List<PostCommentDTO> selectComments(int postCommentRefPostIdx) {
        List<PostCommentVO> vos = commentMapper.selectComments(postCommentRefPostIdx);
        List<PostCommentDTO> dtos = vos.stream().map(vo -> modelMapper.map(vo, PostCommentDTO.class)).collect(Collectors.toList());

        log.info("=============================");
        log.info("CommentServiceImpl  >>  selectComments");
        log.info("dtos: " + dtos);
        log.info("=============================");
        return dtos;
    }
}
