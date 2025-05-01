package net.spb.spb.mapper;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PostCommentVO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations="file:src/main/webapp/WEB-INF/root-context.xml")
public class CommentMapperTests {
    @Autowired(required=false)
    private CommentMapper commentMapper;

    @Test
    public void insertComment() {
        PostCommentVO vo = PostCommentVO.builder()
                                        .postCommentRefPostIdx(8)
                                        .postCommentMemberId("user01")
                                        .postCommentContent("댓글 테스트")
                                        .build();
        int rtnResult = commentMapper.insertComment(vo);
        log.info("=============================");
        log.info("CommentMapperTests  >>  insertComment");
        log.info("rtnResult: "+rtnResult);
        log.info("=============================");
        Assertions.assertTrue(rtnResult > 0, "CommentMapperTests  >>  insertComment");
    }

    @Test
    public void updateComment() {
        PostCommentVO vo = PostCommentVO.builder()
                                        .postCommentIdx(1)
                                        .postCommentRefPostIdx(8)
                                        .postCommentMemberId("user01")
                                        .postCommentContent("댓글 테스트 수정 테스트")
                                        .build();
        int rtnResult = commentMapper.updateComment(vo);
        log.info("=============================");
        log.info("CommentMapperTests  >>  updateComment");
        log.info("rtnResult: "+rtnResult);
        log.info("=============================");
        Assertions.assertTrue(rtnResult > 0, "CommentMapperTests  >>  updateComment");

    }
    @Test
    public void deleteComment() {
        int rtnResult = commentMapper.deleteComment(1);
        log.info("=============================");
        log.info("CommentMapperTests  >>  deleteComment");
        log.info("rtnResult: "+rtnResult);
        log.info("=============================");
        Assertions.assertTrue(rtnResult > 0, "CommentMapperTests  >>  deleteComment");

    }
    @Test
    public void selectComments() {
        List<PostCommentVO> vos = commentMapper.selectComments(8);
        log.info("=============================");
        log.info("CommentMapperTests  >>  selectComments");
        log.info("vos: "+vos);
        log.info("=============================");

    }
}
