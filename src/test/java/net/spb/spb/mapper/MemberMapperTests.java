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
    public void testJoin() {
        // 새로운 회원 정보 생성
        MemberVO newMember = MemberVO.builder()
                .memberId("newuser")
                .memberPwd("password123")
                .memberName("NewUser")
                .memberZipCode("12345")
                .memberAddr1("서울시 강남구")
                .memberAddr2("역삼동 123-45")
                .memberBirth("19900101")
                .memberGrade("1")
                .memberEmail("newuser@mail.com")
                .memberPhone("01012345679")
                .build();

        boolean result = memberMapper.join(newMember);

        Assertions.assertTrue(result);
    }
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
