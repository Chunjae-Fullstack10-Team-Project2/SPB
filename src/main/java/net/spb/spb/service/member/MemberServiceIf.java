package net.spb.spb.service.member;

import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.MemberPageDTO;
import net.spb.spb.dto.pagingsearch.ReportPageDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MemberServiceIf {
    int login(MemberDTO memberDTO);

    boolean existMember(String userId);

    boolean join(MemberDTO memberDTO);

    MemberDTO getMemberById(String memberId);

    boolean updateMember(MemberDTO memberDTO);
    boolean updateMemberStateWithLogin(@Param("memberState") String memberState, @Param("memberId") String memberId);

    boolean updateMemberPwdChangeDateWithLogin(@Param("memberPwdChangeDate") String memberPwdChangeDate, @Param("memberId") String memberId);

    boolean updateMemberLastLoginWithLogin(@Param("memberLastLogin") String memberLastLogin, @Param("memberId") String memberId);
    String getPwdById(String memberId);

    List<MemberDTO> getMembers(MemberPageDTO memberPageDTO);

    boolean updateMemberState(MemberDTO memberDTO);

    boolean updateMemberByAdmin(MemberDTO memberDTO);

    int getMemberCount(MemberPageDTO memberPageDTO);

    boolean updatePassword(String memberId, String encryptedPassword);

    String findByEmail(String memberEmail);

}
