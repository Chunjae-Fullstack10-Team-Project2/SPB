package net.spb.spb.service.member;

import net.spb.spb.dto.MemberPageDTO;
import net.spb.spb.dto.member.MemberDTO;
import org.apache.ibatis.annotations.Param;

import java.lang.reflect.Member;
import java.util.List;

public interface MemberServiceIf {
    int login(MemberDTO memberDTO);

    boolean existUser(String userId);

    boolean join(MemberDTO memberDTO);

    MemberDTO getMemberById(String memberId);

    boolean updateMember(MemberDTO memberDTO);

    String getPwdById(String memberId);

    List<MemberDTO> getMembers(MemberPageDTO memberPageDTO);

    boolean updateMemberState(MemberDTO memberDTO);

    boolean updateMemberByAdmin(MemberDTO memberDTO);

    int getMemberCount(MemberPageDTO memberPageDTO);

    boolean updateMemberStatenPwdChangeDate(MemberDTO memberDTO);
}
