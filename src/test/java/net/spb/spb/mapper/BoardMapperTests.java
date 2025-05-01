package net.spb.spb.mapper;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.PostVO;
import net.spb.spb.dto.PostPageDTO;
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
public class BoardMapperTests {

    @Autowired(required=false)
    private BoardMapper boardMapper;

    @Test
    public void insert() {
        log.info("=============================");
        log.info("BoardMapperTests  >>  insert");
        log.info("=============================");
        PostVO vo = PostVO.builder()
                        .postTitle("제목6")
                        .postContent("내용6")
                        .postMemberId("user01")
                        .postCategory("FREEBOARD")
                        .build();
        int rtnResult = boardMapper.insertPost(vo);
        Assertions.assertTrue(rtnResult > 0, "BoardMapperTests  >>  insert");
        log.info("vo: "+vo);
    }

    @Test
    public void update() {
        log.info("=============================");
        log.info("BoardMapperTests  >>  update");
        log.info("=============================");
        LocalDateTime ldt = LocalDateTime.now();
        PostVO vo = PostVO.builder()
                .postTitle("제목2")
                .postContent("내용2")
                .postMemberId("user01")
                .postCategory("FREEBOARD")
                .postUpdatedAt(ldt)
                .postIdx(2)
                .build();
        int rtnResult = boardMapper.modifyPost(vo);
        log.info("vo: "+vo);
        Assertions.assertTrue(rtnResult > 0, "BoardMapperTests  >>  update");
    }

    @Test
    public void delete() {
        log.info("=============================");
        log.info("BoardMapperTests  >>  delete");
        log.info("=============================");
        int rtnResult = boardMapper.deletePost(4);
        log.info("rtnResult: " + rtnResult);
        Assertions.assertTrue(rtnResult > 0, "BoardMapperTests  >>  delete");
    }

    @Test
    public void selectAll() {
        log.info("=============================");
        log.info("BoardMapperTests  >>  selectAll");
        log.info("=============================");
        PostPageDTO postPageDTO = PostPageDTO.builder().postCategory("FREEBOARD").page_size(10).build();
        List<PostVO> vos = boardMapper.getPosts(postPageDTO);
        for(PostVO vo: vos) {
            log.info("vo: "+vo);
        }
    }

    @Test
    public void select() {
        log.info("=============================");
        log.info("BoardMapperTests  >>  select");
        log.info("=============================");
        PostVO vo = boardMapper.getPostByIdx(3);
        log.info("vo: "+vo);
    }

    @Test
    public void getPostCount() {
        PostPageDTO postPageDTO = PostPageDTO.builder().search_type("postTitle").search_word("제목").postCategory("UNIINFO").build();
        int rtnResult = boardMapper.getPostCount(postPageDTO);
        log.info("=============================");
        log.info("BoardMapperTests  >>  getPostCount");
        log.info("rtnResult : "+rtnResult);
        log.info("=============================");
    }
}
