package net.spb.spb.service;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.post.PostCommentDTO;
import net.spb.spb.service.board.CommentServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations="file:src/main/webapp/WEB-INF/root-context.xml")
public class CommentServiceTests {
    @Autowired
    private CommentServiceImpl service;

    @Test
    public void insertComment() {
        PostCommentDTO dto = PostCommentDTO.builder()
                .postCommentRefPostIdx(8)
                .postCommentMemberId("user01")
                .postCommentContent("서비스 댓글 테스트")
                .build();

        int rtnResult = service.insertComment(dto);
        log.info("=============================");
        log.info("CommentServiceTests  >>  insertComment");
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");

    }
    @Test
    public void updateComment() {
        PostCommentDTO dto = PostCommentDTO.builder()
                .postCommentIdx(5)
                .postCommentRefPostIdx(8)
                .postCommentMemberId("user01")
                .postCommentContent("서비스 댓글 테스트 수정 테스트")
                .build();
        int rtnResult = service.modifyComment(dto);
        log.info("=============================");
        log.info("CommentServiceTests  >>  updateComment");
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");

    }
    @Test
    public void deleteComment() {
        int rtnResult = service.deleteComment(3);
        log.info("=============================");
        log.info("CommentServiceTests  >>  deleteComment");
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");

    }
    @Test
    public void selectComments() {
        List<PostCommentDTO> dtos = service.selectComments(8);
        log.info("=============================");
        log.info("CommentServiceTests  >>  selectComments");
        log.info("dtos: " + dtos);
        log.info("=============================");

    }
}
