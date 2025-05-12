package net.spb.spb.service.member;

import net.spb.spb.domain.MemberVO;
import net.spb.spb.dto.member.MemberDTO;
import net.spb.spb.dto.pagingsearch.MemberPageDTO;
import net.spb.spb.dto.pagingsearch.ReportPageDTO;
import net.spb.spb.mapper.MemberMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MemberServiceImpl implements MemberServiceIf {

    private final ModelMapper modelMapper;

    private final MemberMapper memberMapper;

    @Autowired
    public MemberServiceImpl(ModelMapper modelMapper, MemberMapper memberMapper) {
        this.modelMapper = modelMapper;
        this.memberMapper = memberMapper;
    }

    @Override
    public int login(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        return memberMapper.login(memberVO);
    }

    @Override
    public boolean existMember(String userId) {
        MemberVO memberVO = memberMapper.existMember(userId);
        return memberVO != null;
    }

    @Override
    public boolean join(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        boolean result = memberMapper.join(memberVO);
        return result;
    }

    @Override
    public MemberDTO getMemberById(String memberId) {
        MemberVO memberVO = memberMapper.getMemberById(memberId);
        if (memberVO == null) return null;
        return modelMapper.map(memberVO, MemberDTO.class);
    }

    @Override
    public boolean updateMember(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        return memberMapper.updateMember(memberVO);
    }

    @Override
    public boolean updateMemberStateWithLogin(String memberState, String memberId) {
        return memberMapper.updateMemberStateWithLogin(memberState, memberId);
    }

    @Override
    public boolean updateMemberPwdChangeDateWithLogin(String memberPwdChangeDate, String memberId) {
        return memberMapper.updateMemberPwdChangeDateWithLogin(memberPwdChangeDate, memberId);
    }

    @Override
    public boolean updateMemberLastLoginWithLogin(String memberLastLogin, String memberId) {
        return memberMapper.updateMemberLastLoginWithLogin(memberLastLogin, memberId);
    }

    @Override
    public String getPwdById(String memberId) {
        return memberMapper.getPwdById(memberId);
    }


    @Override
    public List<MemberDTO> getMembers(MemberPageDTO memberPageDTO) {
        return memberMapper.getAllMembers(memberPageDTO).stream().map(memberVO -> modelMapper.map(memberVO, MemberDTO.class)).toList();
    }

    @Override
    public boolean updateMemberState(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        return memberMapper.updateMemberState(memberVO);
    }

    @Override
    public boolean updateMemberByAdmin(MemberDTO memberDTO) {
        MemberVO memberVO = modelMapper.map(memberDTO, MemberVO.class);
        return memberMapper.updateMemberByAdmin(memberVO);
    }

    @Override
    public int getMemberCount(MemberPageDTO memberPageDTO) {
        return memberMapper.getMemberCount(memberPageDTO);
    }

}
