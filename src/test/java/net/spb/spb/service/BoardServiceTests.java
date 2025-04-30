package net.spb.spb.service;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PostVO;
import net.spb.spb.dto.PostDTO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDateTime;
import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations="file:src/main/webapp/WEB-INF/root-context.xml")
public class BoardServiceTests {
    @Autowired
    private BoardServiceImpl service;

    @Test
    public void insertPost() {
        PostDTO dto = PostDTO.builder()
                        .postTitle("제목7")
                        .postContent("내용7")
                        .postCategory("FREEBOARD")
                        .postMemberId("user01")
                        .build();
        int rtnResult = service.insertPost(dto);

        log.info("=============================");
        log.info("BoardServiceImpl  >>  insertPost");
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        Assertions.assertTrue(rtnResult>0, "BoardServiceImpl  >>  insertPost");
    }

    @Test
    public void modifyPost() {

        PostDTO dto = PostDTO.builder()
                .postTitle("제목7수정")
                .postContent("내용7수정")
                .postCategory("FREEBOARD")
                .postMemberId("user01")
                .postUpdatedAt(LocalDateTime.now())
                .postIdx(7)
                .build();
        int rtnResult = service.modifyPost(dto);

        log.info("=============================");
        log.info("BoardServiceImpl  >>  modifyPost");
        log.info("dto: " + dto);
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        Assertions.assertTrue(rtnResult>0, "BoardServiceImpl  >>  modifyPost");
    }

    @Test
    public void deletePost() {
        int rtnResult = service.deletePost(7);

        log.info("=============================");
        log.info("BoardServiceImpl  >>  deletePost");
        log.info("rtnResult: " + rtnResult);
        log.info("=============================");
        Assertions.assertTrue(rtnResult>0, "BoardServiceImpl  >>  deletePost");
    }
    @Test
    public void getPosts() {
        List<PostDTO> dtos = service.getPosts("FREEBOARD");
        log.info("=============================");
        log.info("BoardServiceImpl  >>  getPosts");
        log.info("dtos: " + dtos);
        log.info("=============================");
    }
    @Test
    public void getPostByIdx() {
        PostDTO dto = service.getPostByIdx(8);
        log.info("=============================");
        log.info("BoardServiceImpl  >>  getPosts");
        log.info("dto: " + dto);
        log.info("=============================");
    }


}
