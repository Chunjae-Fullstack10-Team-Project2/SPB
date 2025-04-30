package net.spb.spb.mapper;

import net.spb.spb.domain.MemberVO;

public interface MemberMapper {
    int login(MemberVO memberVO);

    MemberVO existUser(String userId);

    boolean join(MemberVO memberVO);

    MemberVO getMemberById(String memberId);

    boolean updateMember(MemberVO memberVO);

    String getPwdById(String memberId);

}
