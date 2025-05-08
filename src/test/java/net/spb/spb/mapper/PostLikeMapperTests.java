package net.spb.spb.mapper;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.post.PostLikeRequestDTO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/root-context.xml")
public class PostLikeMapperTests {
    @Autowired(required=false)
    private PostLikeMapper mapper;

    @Test
    public void insertLikeTest() {
        PostLikeRequestDTO postLikeRequestDTO = PostLikeRequestDTO.builder().postLikeRefIdx(41).postLikeRefType("POST").postLikeMemberId("user05").build();
        int rtnResult = mapper.insertLike(postLikeRequestDTO);
        log.info("rtnResult : {}", rtnResult);
        Assertions.assertTrue(rtnResult > 0, "insertLikeTest");
    }

    @Test
    public void deleteLikeTest() {
        PostLikeRequestDTO postLikeRequestDTO = PostLikeRequestDTO.builder().postLikeRefIdx(41).postLikeRefType("POST").postLikeMemberId("user05").build();
        int rtnResult = mapper.deleteLike(postLikeRequestDTO);
        log.info("rtnResult : {}", rtnResult);
        Assertions.assertTrue(rtnResult > 0, "insertLikeTest");
    }
}
