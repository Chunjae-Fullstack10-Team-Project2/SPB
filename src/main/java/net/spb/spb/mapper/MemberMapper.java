package net.spb.spb.mapper;

import net.spb.spb.domain.MemberVO;

public interface MemberMapper {
    int login(MemberVO memberVO);

    MemberVO existUser(String userId);

    boolean join(MemberVO memberVO);
}
