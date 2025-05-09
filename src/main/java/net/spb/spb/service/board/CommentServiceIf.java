package net.spb.spb.service.board;

import net.spb.spb.dto.post.PostCommentDTO;

import java.util.List;

public interface CommentServiceIf {
    int insertComment(PostCommentDTO dto);
    int modifyComment(PostCommentDTO dto);
    int deleteComment(int postCommentIdx);
    List<PostCommentDTO> selectComments(int postCommentRefPostIdx);
}
