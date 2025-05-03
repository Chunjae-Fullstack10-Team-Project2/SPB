package net.spb.spb.service.member;

import net.spb.spb.dto.member.MemberDTO;

public interface MemberServiceIf {
    int login(MemberDTO memberDTO);

    boolean existUser(String userId);

    boolean join(MemberDTO memberDTO);

    MemberDTO getMemberById(String memberId);

    boolean updateMember(MemberDTO memberDTO);

    String getPwdById(String memberId);
}
