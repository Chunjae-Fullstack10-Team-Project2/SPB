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

    @Override
    public int insertComment(PostCommentDTO dto) {
        PostCommentVO vo = modelMapper.map(dto, PostCommentVO.class);
        commentMapper.insertComment(vo);
        return vo.getPostCommentIdx();
    }

    @Override
    public int modifyComment(PostCommentDTO dto) {
        return commentMapper.updateComment(modelMapper.map(dto, PostCommentVO.class));
    }

    @Override
    public int deleteComment(int postCommentIdx) {
        return commentMapper.deleteComment(postCommentIdx);
    }

    @Override
    public List<PostCommentDTO> selectComments(int postCommentRefPostIdx) {
        return commentMapper.selectComments(postCommentRefPostIdx);
    }
}
