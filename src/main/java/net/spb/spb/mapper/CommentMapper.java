package net.spb.spb.mapper;

import net.spb.spb.domain.PostCommentVO;
import net.spb.spb.dto.post.PostCommentDTO;

import java.util.List;

public interface CommentMapper {
    int insertComment(PostCommentVO vo);
    int updateComment(PostCommentVO vo);
    int deleteComment(int postCommentIdx);
    List<PostCommentDTO> selectComments(int postCommentRefPostIdx);
}
