package net.spb.spb.mapper;

import lombok.extern.log4j.Log4j2;
import net.spb.spb.domain.MemberVO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/root-context.xml")
public class MemberMapperTests {
    @Autowired(required = false)
    private MemberMapper memberMapper;

    @Test
    public void testLogin() {
        MemberVO memberVO = MemberVO.builder()
                .memberId("user1")
                .memberPwd("1234")
                .build();
        int returnvalue = memberMapper.login(memberVO);
        Assertions.assertTrue(returnvalue > 0);
    }
}
