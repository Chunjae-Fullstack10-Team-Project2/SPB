package net.spb.spb.util;

import net.spb.spb.dto.MemberDTO;

public class MemberDTOUtil {

    public static MemberDTO merge(MemberDTO oldDto, MemberDTO newDto) {
        if (oldDto == null) return newDto;
        if (newDto == null) return oldDto;

        if (isNullOrEmpty(newDto.getMemberId())) newDto.setMemberId(oldDto.getMemberId());
        if (isNullOrEmpty(newDto.getMemberPwd())) newDto.setMemberPwd(oldDto.getMemberPwd());
        if (isNullOrEmpty(newDto.getMemberName())) newDto.setMemberName(oldDto.getMemberName());
        if (isNullOrEmpty(newDto.getMemberAddr1())) newDto.setMemberAddr1(oldDto.getMemberAddr1());
        if (isNullOrEmpty(newDto.getMemberAddr2())) newDto.setMemberAddr2(oldDto.getMemberAddr2());
        if (isNullOrEmpty(newDto.getMemberZipCode())) newDto.setMemberZipCode(oldDto.getMemberZipCode());
        if (isNullOrEmpty(newDto.getMemberBirth())) newDto.setMemberBirth(oldDto.getMemberBirth());
        if (isNullOrEmpty(newDto.getMemberState())) newDto.setMemberState(oldDto.getMemberState());
        if (isNullOrEmpty(newDto.getMemberGrade())) newDto.setMemberGrade(oldDto.getMemberGrade());
        if (isNullOrEmpty(newDto.getMemberEmail())) newDto.setMemberEmail(oldDto.getMemberEmail());
        if (isNullOrEmpty(newDto.getMemberPhone())) newDto.setMemberPhone(oldDto.getMemberPhone());

        if (newDto.getMemberIdx() == 0) newDto.setMemberIdx(oldDto.getMemberIdx());
        if (newDto.getMemberPwdChangeDate() == null) newDto.setMemberPwdChangeDate(oldDto.getMemberPwdChangeDate());
        if (newDto.getMemberCreatedAt() == null) newDto.setMemberCreatedAt(oldDto.getMemberCreatedAt());

        return newDto;
    }

    private static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
