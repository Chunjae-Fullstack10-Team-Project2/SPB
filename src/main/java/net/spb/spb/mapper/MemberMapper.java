package net.spb.spb.mapper;

import net.spb.spb.domain.MemberVO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.MemberPageDTO;
import net.spb.spb.dto.pagingsearch.ReportPageDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MemberMapper {
    int login(MemberVO memberVO);

    MemberVO existMember(String userId);

    boolean join(MemberVO memberVO);

    MemberVO getMemberById(String memberId);

    boolean updateMember(MemberVO memberVO);

    boolean updateMemberStateWithLogin(@Param("memberState") String memberState, @Param("memberId") String memberId);

    boolean updateMemberPwdChangeDateWithLogin(@Param("memberPwdChangeDate") String memberPwdChangeDate, @Param("memberId") String memberId);

    boolean updateMemberLastLoginWithLogin(@Param("memberLastLogin") String memberLastLogin, @Param("memberId") String memberId);

    String getPwdById(String memberId);

    List<MemberVO> getAllMembers(MemberPageDTO memberPageDTO);

    boolean updateMemberState(MemberVO memberVO);

    boolean updateMemberByAdmin(MemberVO memberVO);

    int getMemberCount(MemberPageDTO memberPageDTO);

    int updatePassword(@Param("memberId") String memberId, @Param("encryptedPassword") String encryptedPassword);

    String selectByEmail(String memberEmail);
}
