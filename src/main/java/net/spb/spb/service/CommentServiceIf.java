package net.spb.spb.service;

import net.spb.spb.dto.PostCommentDTO;

import java.util.List;

public interface CommentServiceIf {
    int insertComment(PostCommentDTO dto);
    int updateComment(PostCommentDTO dto);
    int deleteComment(int postCommentIdx);
    List<PostCommentDTO> selectComments(int postCommentRefPostIdx);
}
