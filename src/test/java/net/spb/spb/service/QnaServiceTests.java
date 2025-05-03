package net.spb.spb.service;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.qna.QnaDTO;
import net.spb.spb.dto.qna.QnaSearchDTO;
import net.spb.spb.mapper.QnaMapper;
import net.spb.spb.service.Qna.QnaService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/root-context.xml")
public class QnaServiceTests {

    @Autowired
    private QnaService qnaService;

    @Autowired(required = false)
    private QnaMapper qnaMapper;


}
