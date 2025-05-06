package net.spb.spb.mapper;

import net.spb.spb.domain.MemberVO;
import net.spb.spb.dto.MemberPageDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MemberMapper {
    int login(MemberVO memberVO);

    MemberVO existUser(String userId);

    boolean join(MemberVO memberVO);

    MemberVO getMemberById(String memberId);

    boolean updateMember(MemberVO memberVO);

    String getPwdById(String memberId);

    List<MemberVO> getAllMembers(MemberPageDTO memberPageDTO);

    boolean updateMemberState(MemberVO memberVO);

    boolean updateMemberByAdmin(MemberVO memberVO);

    int getMemberCount(MemberPageDTO memberPageDTO);

    boolean updateMemberStatenPwdChangeDate(MemberVO memberVO);
}
