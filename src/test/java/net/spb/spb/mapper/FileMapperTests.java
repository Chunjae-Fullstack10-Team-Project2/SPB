package net.spb.spb.mapper;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.FileVO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations="file:src/main/webapp/WEB-INF/root-context.xml")
public class FileMapperTests {

    @Autowired(required=false)
    private FileMapper fileMapper;

    @Test
    public void insertFile(){
        FileVO vo = FileVO.builder().fileName("23124").fileExt("jpg").filePath("/upload").build();
        int rtnResult = fileMapper.insertFile(vo);
        log.info("rtnResult: "+rtnResult);
        Assertions.assertTrue(rtnResult>0, "insertFile test");
    }

    @Test
    public void deleteFile() {
        int fileIdx = 1;
        int rtnResult = fileMapper.deleteFile(fileIdx);
        log.info("rtnResult: "+rtnResult);
        Assertions.assertTrue(rtnResult>0, "deleteFileTest");
    }

    @Test
    public void deleteFileByFileName() {
        String fileName = "23124";
        int rtnResult = fileMapper.deleteFileByFileName(fileName);
        log.info("rtnResult: "+rtnResult);
        Assertions.assertTrue(rtnResult > 0, "deleteFileByFileName");
    }
 }
