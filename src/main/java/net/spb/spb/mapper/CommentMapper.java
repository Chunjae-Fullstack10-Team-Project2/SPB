package net.spb.spb.mapper;

import net.spb.spb.domain.PostCommentVO;
import java.util.List;

public interface CommentMapper {
    int insertComment(PostCommentVO vo);
    int updateComment(PostCommentVO vo);
    int deleteComment(int postCommentIdx);
    List<PostCommentVO> selectComments(int postCommentRefPostIdx);
}
