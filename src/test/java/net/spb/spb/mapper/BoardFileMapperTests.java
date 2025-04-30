package net.spb.spb.mapper;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.FileVO;
import net.spb.spb.domain.PostFileVO;
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
public class BoardFileMapperTests {

    @Autowired(required=false)
    private BoardFileMapper boardFileMapper;

    @Test
    public void insertBoardFile(){
        PostFileVO vo = PostFileVO.builder().postFileFileIdx(2).postFilePostIdx(30).build();
        int rtnResult = boardFileMapper.insertPostFile(vo);
        log.info("rtnResult: "+rtnResult);
        Assertions.assertTrue(rtnResult>0, "insertFile test");
    }

    @Test
    public void deleteBoardFile() {
        int rtnResult = boardFileMapper.deletePostFile(2);
        log.info("rtnResult: "+rtnResult);
        Assertions.assertTrue(rtnResult>0, "deleteBoardFile test");
    }

    @Test
    public void selectFile() {
        List<FileVO> vos = boardFileMapper.selectFile(30);
        log.info("=============================");
        log.info("BoardFileMapperTests  >>  selectFile");
        log.info("vos: "+ vos);
        log.info("=============================");
    }
 }
